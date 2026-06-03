import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:saranidhi/core/theme/theme_provider.dart';
import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/backup_actions_widget.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/storage_mode_selector.dart';
import 'package:saranidhi/features/notifications/providers/notification_providers.dart';
import 'package:saranidhi/features/settings/presentation/profile_card.dart';

/// The Settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BrandedAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile
          const ProfileCard(),
          const Divider(height: 32),

          // Theme Brightness (Light/Dark/System)
          Text('Appearance', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          SegmentedButton<ThemeBrightness>(
            segments: ThemeBrightness.values
                .map(
                  (b) => ButtonSegment<ThemeBrightness>(
                    value: b,
                    label: Text(b.displayName),
                  ),
                )
                .toList(),
            selected: {themeState.brightness},
            onSelectionChanged: (selected) {
              ref.read(themeProvider.notifier).setBrightness(selected.first);
            },
          ),
          const SizedBox(height: 16),

          // Theme Accent Color
          Text('Color Accent', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ThemeAccent.values.map((accent) {
              final isSelected = themeState.accent == accent;
              return ChoiceChip(
                label: Text(accent.displayName),
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

          // Storage & Backup
          const StorageModeSelector(),
          const Divider(height: 32),
          const BackupActionsWidget(),
          const Divider(height: 32),

          // Notifications
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('Yama transition alerts (mobile only)'),
          ),
          _NotificationToggles(),

          const Divider(height: 32),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Coming in Sprint 9'),
            enabled: false,
          ),
        ],
      ),
    );
  }
}

class _NotificationToggles extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final notifier = ref.read(notificationPrefsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Ruling state alerts'),
            subtitle: const Text('Notify at Yama start (Ruling bird)'),
            value: prefs.notifyRuling,
            onChanged: (v) => notifier.setNotifyRuling(enabled: v),
            dense: true,
          ),
          SwitchListTile(
            title: const Text('Eating state alerts'),
            subtitle: const Text('Notify when bird enters Eating state'),
            value: prefs.notifyEating,
            onChanged: (v) => notifier.setNotifyEating(enabled: v),
            dense: true,
          ),
        ],
      ),
    );
  }
}
