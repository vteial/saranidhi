import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/theme/app_theme.dart';
import 'package:saranidhi/core/theme/theme_provider.dart';

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
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
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
          const ListTile(
            leading: Icon(Icons.cloud_outlined),
            title: Text('Cloud Backup'),
            subtitle: Text('Coming in Sprint 5'),
            enabled: false,
          ),
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('Coming in Sprint 6'),
            enabled: false,
          ),
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
