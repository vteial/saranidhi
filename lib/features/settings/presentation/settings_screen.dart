import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:saranidhi/core/theme/theme_provider.dart';
import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/backup_actions_widget.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/storage_mode_selector.dart';
import 'package:saranidhi/features/notifications/providers/notification_providers.dart';

/// The Settings screen.
///
/// Provides theme selection and will include profile, backup,
/// notification, and language settings in future sprints.
class SettingsScreen extends ConsumerWidget {
  /// Creates the Settings screen widget.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: const BrandedAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Theme',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SegmentedButton<AppThemeMode>(
            segments: AppThemeMode.values
                .map(
                  (mode) => ButtonSegment<AppThemeMode>(
                    value: mode,
                    label: Text(
                      mode.name[0].toUpperCase() + mode.name.substring(1),
                    ),
                  ),
                )
                .toList(),
            selected: {currentTheme},
            onSelectionChanged: (selected) {
              ref.read(themeProvider.notifier).setTheme(selected.first);
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            subtitle: Text('Coming in Sprint 6'),
            enabled: false,
          ),
          const SizedBox(height: 16),
          const StorageModeSelector(),
          const Divider(height: 32),
          const BackupActionsWidget(),
          const Divider(height: 32),
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('Yama transition alerts (mobile only)'),
          ),
          _NotificationToggles(),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Coming in Sprint 8'),
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
