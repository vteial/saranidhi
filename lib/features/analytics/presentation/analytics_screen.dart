import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/features/analytics/domain/analytics_calculator.dart';
import 'package:saranidhi/features/analytics/providers/analytics_providers.dart';

/// Analytics & Export screen showing detailed insights about practice patterns.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const BrandedAppBar(title: 'Analytics'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _WeeklySummaryCard(),
            const SizedBox(height: 12),
            _MonthlyPatternsCard(),
            const SizedBox(height: 12),
            _StreakInsightsCard(),
            const SizedBox(height: 12),
            _YamaPerformanceCard(),
            const SizedBox(height: 12),
            _HoldTimeProgressionCard(),
            const SizedBox(height: 12),
            _ExportCard(),
          ],
        ),
      ),
    );
  }
}

class _WeeklySummaryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyAnalyticsProvider);
    final theme = Theme.of(context);

    return weeklyAsync.when(
      data: (weeks) {
        if (weeks.isEmpty) {
          return _emptyCard(theme, 'Weekly Summary', 'Log entries to see '
              'weekly alignment trends.');
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Alignment',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...weeks.map((week) => _WeekRow(week: week, theme: theme)),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({required this.week, required this.theme});

  final WeeklySummary week;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');
    final label =
        '${dateFormat.format(week.weekStart)} – ${dateFormat.format(week.weekEnd)}';
    final pct = week.alignmentPercentage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _pctColor(pct, theme),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: Text(
              '$pct%',
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _pctColor(pct, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _pctColor(int pct, ThemeData theme) {
    if (pct >= 70) return theme.colorScheme.primary;
    if (pct >= 40) return Colors.orange;
    return theme.colorScheme.error;
  }
}

class _MonthlyPatternsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternsAsync = ref.watch(monthlyPatternsProvider);
    final theme = Theme.of(context);

    return patternsAsync.when(
      data: (patterns) {
        if (patterns.totalEntries == 0) {
          return _emptyCard(theme, 'Monthly Patterns', 'Practice for a few '
              'days to see patterns emerge.');
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Patterns (30 days)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _PatternRow(
                  icon: Icons.trending_up,
                  label: 'Best day',
                  value: patterns.bestDay ?? '—',
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.trending_down,
                  label: 'Needs attention',
                  value: patterns.worstDay ?? '—',
                  color: theme.colorScheme.error,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.star,
                  label: 'Most active yama',
                  value: _yamaLabel(patterns.mostActiveYama),
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.schedule,
                  label: 'Least active yama',
                  value: _yamaLabel(patterns.leastActiveYama),
                  color: theme.colorScheme.onSurfaceVariant,
                  theme: theme,
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      label: 'Active days',
                      value: '${patterns.activeDays}',
                      theme: theme,
                    ),
                    _StatChip(
                      label: 'Avg/day',
                      value: patterns.avgEntriesPerDay.toStringAsFixed(1),
                      theme: theme,
                    ),
                    _StatChip(
                      label: 'Alignment',
                      value: '${patterns.alignmentPercentage}%',
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _yamaLabel(String? yama) {
    if (yama == null) return '—';
    final num = yama.replaceAll('yama', '');
    return 'Yama $num';
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.bodySmall),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

class _StreakInsightsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(streakInsightsProvider);
    final theme = Theme.of(context);

    return insightsAsync.when(
      data: (insights) {
        if (insights.totalPracticeDays == 0) {
          return _emptyCard(theme, 'Streak Insights', 'Start practicing to '
              'build streak insights.');
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Insights',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      label: 'Current',
                      value: '${insights.currentStreak}d',
                      theme: theme,
                    ),
                    _StatChip(
                      label: 'Longest',
                      value: '${insights.longestStreak}d',
                      theme: theme,
                    ),
                    _StatChip(
                      label: 'Total days',
                      value: '${insights.totalPracticeDays}',
                      theme: theme,
                    ),
                  ],
                ),
                const Divider(height: 16),
                _PatternRow(
                  icon: Icons.calendar_today,
                  label: 'Practice consistency',
                  value: '${insights.practiceConsistency}%',
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.timelapse,
                  label: 'Avg gap between sessions',
                  value: insights.averageGapDays > 0
                      ? '${insights.averageGapDays.toStringAsFixed(1)} days'
                      : 'No gaps',
                  color: theme.colorScheme.onSurfaceVariant,
                  theme: theme,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _YamaPerformanceCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yamaAsync = ref.watch(yamaPerformanceProvider);
    final theme = Theme.of(context);

    return yamaAsync.when(
      data: (counts) {
        final total = counts.values.fold<int>(0, (a, b) => a + b);
        if (total == 0) {
          return _emptyCard(theme, 'Yama Performance', 'Log entries during '
              'different yamas to see breakdown.');
        }

        final sorted = counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final maxCount = sorted.first.value;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yama Performance',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Which time of day you practice most',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                ...sorted.map((entry) {
                  final yamaNum = entry.key.replaceAll('yama', '');
                  final fraction =
                      maxCount > 0 ? entry.value / maxCount : 0.0;
                  final pct =
                      total > 0 ? (entry.value * 100 ~/ total) : 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 52,
                          child: Text(
                            'Yama $yamaNum',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: fraction,
                              minHeight: 8,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.5 + fraction * 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 44,
                          child: Text(
                            '$pct%',
                            textAlign: TextAlign.end,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _HoldTimeProgressionCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdAsync = ref.watch(holdTimeProgressionProvider);
    final theme = Theme.of(context);

    return holdAsync.when(
      data: (hold) {
        if (hold.totalSessions == 0) {
          return _emptyCard(theme, 'Hold Time Progression', 'Use the breath '
              'timer to track hold time improvement.');
        }

        final trendIcon = switch (hold.trendDirection) {
          TrendDirection.improving => Icons.trending_up,
          TrendDirection.stable => Icons.trending_flat,
          TrendDirection.declining => Icons.trending_down,
        };
        final trendColor = switch (hold.trendDirection) {
          TrendDirection.improving => theme.colorScheme.primary,
          TrendDirection.stable => theme.colorScheme.onSurfaceVariant,
          TrendDirection.declining => theme.colorScheme.error,
        };
        final trendLabel = switch (hold.trendDirection) {
          TrendDirection.improving => 'Improving',
          TrendDirection.stable => 'Stable',
          TrendDirection.declining => 'Declining',
        };

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hold Time Progression',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(trendIcon, size: 18, color: trendColor),
                    const SizedBox(width: 4),
                    Text(
                      trendLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: trendColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      label: 'This week',
                      value: '${(hold.weeklyAverage / 1000).toStringAsFixed(1)}s',
                      theme: theme,
                    ),
                    _StatChip(
                      label: 'This month',
                      value: '${(hold.monthlyAverage / 1000).toStringAsFixed(1)}s',
                      theme: theme,
                    ),
                    _StatChip(
                      label: 'Best ever',
                      value: '${(hold.personalBestMs / 1000).toStringAsFixed(1)}s',
                      theme: theme,
                    ),
                  ],
                ),
                const Divider(height: 16),
                _PatternRow(
                  icon: Icons.timer,
                  label: 'All-time average',
                  value: '${(hold.allTimeAverage / 1000).toStringAsFixed(1)}s',
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.format_list_numbered,
                  label: 'Total sessions',
                  value: '${hold.totalSessions}',
                  color: theme.colorScheme.onSurfaceVariant,
                  theme: theme,
                ),
                if (hold.personalBestDate != null)
                  _PatternRow(
                    icon: Icons.emoji_events,
                    label: 'Personal best date',
                    value: DateFormat('MMM d, yyyy')
                        .format(hold.personalBestDate!),
                    color: theme.colorScheme.primary,
                    theme: theme,
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _ExportCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Data',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Download your complete journal history as a CSV file.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _exportCsv(context, ref),
                icon: const Icon(Icons.download),
                label: const Text('Export as CSV'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final csv = await ref.read(csvExportProvider.future);

      if (kIsWeb) {
        // On web, show a dialog with the CSV content (can't write files)
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CSV export is available on mobile devices'),
            ),
          );
        }
        return;
      }

      // On mobile/desktop, write to a file
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/saranidhi_journal_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.csv',
      );
      await file.writeAsString(csv);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to: ${file.path}')),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}

Card _emptyCard(ThemeData theme, String title, String hint) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
