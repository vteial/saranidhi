import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saranidhi/core/l10n/locale_provider.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:saranidhi/core/theme/theme_provider.dart';
import 'package:saranidhi/core/utils/responsive_wrapper.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/backup_actions_widget.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/storage_mode_selector.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/sync_device_config_widget.dart';
import 'package:saranidhi/features/notifications/providers/notification_providers.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/features/settings/presentation/about_card.dart';
import 'package:saranidhi/features/settings/presentation/data_export_import_widget.dart';
import 'package:saranidhi/features/settings/presentation/profile_card.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// The Settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;

    // Left column: Profile + Appearance + Language
    final personalSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Profile
        const ProfileCard(),
        const Divider(height: 32),

        // Theme Brightness (Light/Dark/System)
        Text(l10n.appearance, style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        SegmentedButton<ThemeBrightness>(
          segments: [
            ButtonSegment<ThemeBrightness>(
              value: ThemeBrightness.light,
              label: Text(l10n.light),
            ),
            ButtonSegment<ThemeBrightness>(
              value: ThemeBrightness.dark,
              label: Text(l10n.dark),
            ),
            ButtonSegment<ThemeBrightness>(
              value: ThemeBrightness.system,
              label: Text(l10n.system),
            ),
          ],
          selected: {themeState.brightness},
          onSelectionChanged: (selected) {
            ref.read(themeProvider.notifier).setBrightness(selected.first);
          },
        ),
        const SizedBox(height: 16),

        // Theme Accent Color
        Text(l10n.colorAccent, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ThemeAccent.values.map((accent) {
            final isSelected = themeState.accent == accent;
            return ChoiceChip(
              label: Text(_localizedAccentName(accent, l10n)),
              selected: isSelected,
              onSelected: (_) {
                ref.read(themeProvider.notifier).setAccent(accent);
              },
              avatar: CircleAvatar(
                backgroundColor: accent.seedColor,
                radius: 10,
              ),
            );
          }).toList(),
        ),

        const Divider(height: 32),

        // Language Switcher
        Text(l10n.language, style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        SegmentedButton<AppLocale>(
          segments: AppLocale.values
              .map(
                (loc) => ButtonSegment<AppLocale>(
                  value: loc,
                  label: Text(loc.displayName),
                ),
              )
              .toList(),
          selected: {currentLocale},
          onSelectionChanged: (selected) {
            ref.read(localeProvider.notifier).setLocale(selected.first);
          },
        ),

        // About card — only in wide layout (left column)
        if (isWide) ...[
          const Divider(height: 32),
          const AboutCard(),
        ],
      ],
    );

    // Right column: Storage + Backup + Sync + Notifications + Clear Data
    final dataSection = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Storage & Backup
        const StorageModeSelector(),
        const Divider(height: 32),
        const BackupActionsWidget(),
        const SyncDeviceConfigWidget(),
        const Divider(height: 32),

        // Notifications
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: Text(l10n.notifications),
          subtitle: Text(l10n.notificationsSubtitle),
        ),
        _NotificationToggles(),

        const Divider(height: 32),

        // Data Export / Import
        const DataExportImportWidget(),

        const Divider(height: 32),

        // Clear All Data
        _ClearAllDataTile(),
      ],
    );

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(l10n.settingsTitle),
                leading: const BackButton(),
                pinned: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: personalSection),
                            const SizedBox(width: 24),
                            Expanded(child: dataSection),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            personalSection,
                            const Divider(height: 32),
                            dataSection,
                            // About card at the bottom on narrow screens
                            const Divider(height: 32),
                            const AboutCard(),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _localizedAccentName(ThemeAccent accent, AppLocalizations l10n) =>
      switch (accent) {
        ThemeAccent.defaultPurple => l10n.accentDefault,
        ThemeAccent.emerald => l10n.accentEmerald,
        ThemeAccent.gold => l10n.accentGold,
        ThemeAccent.purple => l10n.accentPurple,
      };
}

class _NotificationToggles extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final notifier = ref.read(notificationPrefsProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.rulingStateAlerts),
            subtitle: Text(l10n.rulingStateAlertsSubtitle),
            value: prefs.notifyRuling,
            onChanged: (v) => notifier.setNotifyRuling(enabled: v),
            dense: true,
          ),
          SwitchListTile(
            title: Text(l10n.eatingStateAlerts),
            subtitle: Text(l10n.eatingStateAlertsSubtitle),
            value: prefs.notifyEating,
            onChanged: (v) => notifier.setNotifyEating(enabled: v),
            dense: true,
          ),
          SwitchListTile(
            title: const Text('Rahu Kaal Alerts'),
            subtitle: const Text('Notify when Rahu Kaal starts and ends'),
            value: prefs.notifyRahuKaal,
            onChanged: (v) => notifier.setNotifyRahuKaal(enabled: v),
            dense: true,
          ),
          SwitchListTile(
            title: const Text('Morning Summary'),
            subtitle: const Text("Today's best times at sunrise"),
            value: prefs.notifyMorningSummary,
            onChanged: (v) => notifier.setNotifyMorningSummary(enabled: v),
            dense: true,
          ),
        ],
      ),
    );
  }
}

class _ClearAllDataTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
      title: Text(
        l10n.clearAllData,
        style: TextStyle(color: theme.colorScheme.error),
      ),
      subtitle: Text(l10n.clearAllDataSubtitle),
      onTap: () => _showClearDataDialog(context, ref),
    );
  }

  Future<void> _showClearDataDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearAllDataConfirmTitle),
        content: Text(l10n.clearAllDataConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.clearData),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      final db = ref.read(appDatabaseProvider);
      // Delete all data from all tables
      await db.delete(db.saraKalaiJournal).go();
      await db.delete(db.breathSessions).go();
      await db.delete(db.birdLibrary).go();
      await db.delete(db.profiles).go();

      // Reset onboarding flag so the guard redirects to onboarding
      await ref.read(onboardingCompleteProvider.notifier).reset();
      // Reset onboarding form state back to step 0
      ref.invalidate(onboardingNotifierProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dataCleared)),
        );
      }
    }
  }
}
