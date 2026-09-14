import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:saranidhi/core/utils/branded_app_bar.dart';
import 'package:saranidhi/core/widgets/empty_state_widget.dart';
import 'package:saranidhi/features/analytics/domain/analytics_calculator.dart';
import 'package:saranidhi/features/analytics/providers/analytics_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Analytics & Export screen showing detailed insights about practice patterns.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;
    final weeklyAsync = ref.watch(weeklyAnalyticsProvider);
    final l10n = AppLocalizations.of(context);

    // Show comprehensive empty state when no weekly data exists
    // (indicates the user has never logged any entries)
    final showFullEmptyState = weeklyAsync.when(
      data: (weeks) => weeks.isEmpty,
      loading: () => false,
      error: (_, __) => false,
    );

    return Scaffold(
      appBar: BrandedAppBar(title: l10n.analyticsTitle),
      body: showFullEmptyState
          ? Center(
              child: EmptyStateWidget(
                icon: Icons.insights_rounded,
                title: l10n.analyticsEmptyTitle,
                subtitle: l10n.analyticsEmptySubtitle,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row 1: Weekly Summary + Monthly Patterns (two-column on wide)
                  if (isWide)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _WeeklySummaryCard()),
                          const SizedBox(width: 12),
                          Expanded(child: _MonthlyPatternsCard()),
                        ],
                      ),
                    )
                  else ...[
                    _WeeklySummaryCard(),
                    const SizedBox(height: 12),
                    _MonthlyPatternsCard(),
                  ],
                  const SizedBox(height: 12),

                  // Row 2: Streak Insights + Yama Performance (two-column on wide)
                  if (isWide)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _StreakInsightsCard()),
                          const SizedBox(width: 12),
                          Expanded(child: _YamaPerformanceCard()),
                        ],
                      ),
                    )
                  else ...[
                    _StreakInsightsCard(),
                    const SizedBox(height: 12),
                    _YamaPerformanceCard(),
                  ],
                  const SizedBox(height: 12),

                  // Row 3: Hold Time Progression (full-width)
                  _HoldTimeProgressionCard(),
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
          final l10n = AppLocalizations.of(context);
          return _emptyCard(
            theme,
            l10n.weeklyAlignment,
            l10n.weeklyAlignmentEmpty,
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).weeklyAlignment,
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
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('MMM d', locale);
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
    final l10n = AppLocalizations.of(context);

    return patternsAsync.when(
      data: (patterns) {
        if (patterns.totalEntries == 0) {
          return _emptyCard(
            theme,
            l10n.monthlyPatterns,
            l10n.monthlyPatternsEmpty,
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.monthlyPatterns,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _PatternRow(
                  icon: Icons.trending_up,
                  label: l10n.bestDay,
                  value: patterns.bestDayWeekday == null
                      ? '—'
                      : _localizedWeekday(patterns.bestDayWeekday!, context),
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                // Hide "Needs Attention" if it's the same day as "Best Day"
                if (patterns.worstDayWeekday != null &&
                    patterns.worstDayWeekday != patterns.bestDayWeekday)
                  _PatternRow(
                    icon: Icons.trending_down,
                    label: l10n.needsAttention,
                    value: _localizedWeekday(
                      patterns.worstDayWeekday!,
                      context,
                    ),
                    color: theme.colorScheme.error,
                    theme: theme,
                  ),
                _PatternRow(
                  icon: Icons.star,
                  label: l10n.mostActiveYama,
                  value: _yamaLabel(patterns.mostActiveYama, l10n),
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.schedule,
                  label: l10n.leastActiveYama,
                  value: _yamaLabel(patterns.leastActiveYama, l10n),
                  color: theme.colorScheme.onSurfaceVariant,
                  theme: theme,
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _StatChip(
                        label: l10n.activeDays,
                        value: '${patterns.activeDays}',
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      child: _StatChip(
                        label: l10n.avgPerDay,
                        value: patterns.avgEntriesPerDay.toStringAsFixed(1),
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      child: _StatChip(
                        label: l10n.alignment,
                        value: '${patterns.alignmentPercentage}%',
                        theme: theme,
                      ),
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

  String _yamaLabel(String? yama, AppLocalizations l10n) {
    if (yama == null) return '—';
    final yamaNum = yama.replaceAll('yama', '');
    return '${l10n.yamaPrefix} $yamaNum';
  }

  String _localizedWeekday(int weekday, BuildContext context) {
    // weekday: 1=Mon … 7=Sun (Dart). Build a reference date with that weekday.
    final locale = Localizations.localeOf(context).toString();
    // 2024-01-01 is a Monday; add (weekday-1) days to hit the target weekday.
    final ref = DateTime(2024).add(Duration(days: weekday - 1));
    return DateFormat.EEEE(locale).format(ref);
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
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          const SizedBox(width: 8),
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
          textAlign: TextAlign.center,
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
    final l10n = AppLocalizations.of(context);

    return insightsAsync.when(
      data: (insights) {
        if (insights.totalPracticeDays == 0) {
          return _emptyCard(
            theme,
            l10n.streakInsights,
            l10n.streakInsightsEmpty,
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.streakInsights,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _StatChip(
                        label: l10n.current,
                        value:
                            '${insights.currentStreak}${l10n.daysSuffixShort}',
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      child: _StatChip(
                        label: l10n.longest,
                        value:
                            '${insights.longestStreak}${l10n.daysSuffixShort}',
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      child: _StatChip(
                        label: l10n.totalDays,
                        value: '${insights.totalPracticeDays}',
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                _PatternRow(
                  icon: Icons.calendar_today,
                  label: l10n.practiceConsistency,
                  value: '${insights.practiceConsistency}%',
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.timelapse,
                  label: l10n.avgGapBetweenSessions,
                  value: insights.averageGapDays > 0
                      ? '${insights.averageGapDays.toStringAsFixed(1)} ${l10n.days}'
                      : l10n.noGaps,
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
    final l10n = AppLocalizations.of(context);

    return yamaAsync.when(
      data: (counts) {
        final total = counts.values.fold<int>(0, (a, b) => a + b);
        if (total == 0) {
          return _emptyCard(
            theme,
            l10n.yamaPerformance,
            l10n.yamaPerformanceEmpty,
          );
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
                  l10n.yamaPerformance,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.yamaPerformanceSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                ...sorted.map((entry) {
                  final yamaNum = entry.key.replaceAll('yama', '');
                  final fraction = maxCount > 0 ? entry.value / maxCount : 0.0;
                  final pct = total > 0 ? (entry.value * 100 ~/ total) : 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '${l10n.yamaShortPrefix}$yamaNum',
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
    final l10n = AppLocalizations.of(context);

    return holdAsync.when(
      data: (hold) {
        if (hold.totalSessions == 0) {
          return _emptyCard(
            theme,
            l10n.holdTimeProgression,
            l10n.holdTimeEmpty,
          );
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
          TrendDirection.improving => l10n.improving,
          TrendDirection.stable => l10n.stable,
          TrendDirection.declining => l10n.declining,
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
                      l10n.holdTimeProgression,
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
                    Expanded(
                      child: _StatChip(
                        label: l10n.thisWeek,
                        value:
                            '${(hold.weeklyAverage / 1000).toStringAsFixed(1)}${l10n.secondsSuffixShort}',
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      child: _StatChip(
                        label: l10n.thisMonth,
                        value:
                            '${(hold.monthlyAverage / 1000).toStringAsFixed(1)}${l10n.secondsSuffixShort}',
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      child: _StatChip(
                        label: l10n.bestEver,
                        value:
                            '${(hold.personalBestMs / 1000).toStringAsFixed(1)}${l10n.secondsSuffixShort}',
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                _PatternRow(
                  icon: Icons.timer,
                  label: l10n.allTimeAverage,
                  value:
                      '${(hold.allTimeAverage / 1000).toStringAsFixed(1)}${l10n.secondsSuffixShort}',
                  color: theme.colorScheme.primary,
                  theme: theme,
                ),
                _PatternRow(
                  icon: Icons.format_list_numbered,
                  label: l10n.totalSessions,
                  value: '${hold.totalSessions}',
                  color: theme.colorScheme.onSurfaceVariant,
                  theme: theme,
                ),
                if (hold.personalBestDate != null)
                  _PatternRow(
                    icon: Icons.emoji_events,
                    label: l10n.personalBestDate,
                    value: DateFormat(
                      'MMM d, yyyy',
                      Localizations.localeOf(context).toString(),
                    ).format(hold.personalBestDate!),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
