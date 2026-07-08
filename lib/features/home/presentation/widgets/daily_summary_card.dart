import 'package:flutter/material.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Daily summary card shown on the Today tab.
///
/// Displays a compact overview of today's practice:
/// - Entries logged
/// - Alignment status (aligned/total)
/// - Average hold time
/// - Active yama at time of most entries
class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // Don't show if no entries today
    if (data.todayEntryCount == 0) return const SizedBox.shrink();

    final holdAvg = data.todayAvgHoldMs != null
        ? '${(data.todayAvgHoldMs! / 1000).toStringAsFixed(1)}s'
        : '—';
    final alignPct = data.streak.isActiveToday ? '100%' : '—';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.summarize_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.dailySummaryTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryChip(
                  label: l10n.dailySummaryEntries,
                  value: '${data.todayEntryCount}',
                  icon: Icons.edit_note,
                  theme: theme,
                ),
                _SummaryChip(
                  label: l10n.dailySummaryAlignment,
                  value: alignPct,
                  icon: Icons.check_circle_outline,
                  theme: theme,
                ),
                _SummaryChip(
                  label: l10n.dailySummaryHold,
                  value: holdAvg,
                  icon: Icons.timer,
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
