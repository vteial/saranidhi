import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Key for storing the last seen app version in SharedPreferences.
const _lastSeenVersionKey = 'whats_new_last_seen_version';

/// The current version's "What's New" content.
/// Update this each release with the changes for that version.
const _currentWhatsNewVersion = '1.2.0';

/// Provider that checks if the "What's New" screen should be shown.
///
/// Returns true if the stored last-seen version differs from current.
final shouldShowWhatsNewProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final lastSeen = prefs.getString(_lastSeenVersionKey);
  return lastSeen != _currentWhatsNewVersion;
});

/// Marks the "What's New" as seen for the current version.
Future<void> markWhatsNewSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_lastSeenVersionKey, _currentWhatsNewVersion);
}

/// "What's New" screen shown once per app version update.
///
/// Displays a summary of new features and improvements.
/// Dismissible via a "Got it" button at the bottom.
class WhatsNewScreen extends ConsumerWidget {
  const WhatsNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Header
              Icon(
                Icons.auto_awesome,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.whatsNewTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'v$_currentWhatsNewVersion',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Feature list
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _FeatureItem(
                        icon: Icons.celebration,
                        title: l10n.whatsNewCelebrations,
                        subtitle: l10n.whatsNewCelebrationsDesc,
                        theme: theme,
                      ),
                      _FeatureItem(
                        icon: Icons.timer,
                        title: l10n.whatsNewTimerPresets,
                        subtitle: l10n.whatsNewTimerPresetsDesc,
                        theme: theme,
                      ),
                      _FeatureItem(
                        icon: Icons.summarize,
                        title: l10n.whatsNewDailySummary,
                        subtitle: l10n.whatsNewDailySummaryDesc,
                        theme: theme,
                      ),
                      _FeatureItem(
                        icon: Icons.star,
                        title: l10n.whatsNewPinEntries,
                        subtitle: l10n.whatsNewPinEntriesDesc,
                        theme: theme,
                      ),
                      _FeatureItem(
                        icon: Icons.dark_mode,
                        title: l10n.whatsNewNightSchedule,
                        subtitle: l10n.whatsNewNightScheduleDesc,
                        theme: theme,
                      ),
                      _FeatureItem(
                        icon: Icons.speed,
                        title: l10n.whatsNewPerformance,
                        subtitle: l10n.whatsNewPerformanceDesc,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Dismiss button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    await markWhatsNewSeen();
                    ref.invalidate(shouldShowWhatsNewProvider);
                    if (context.mounted) {
                      Navigator.of(context).maybePop();
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(l10n.whatsNewDismiss),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
