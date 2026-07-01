import 'package:flutter/material.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays Yama-level accuracy as a mini heatmap/bar chart.
class YamaAccuracyWidget extends StatelessWidget {
  const YamaAccuracyWidget({required this.accuracy, super.key});

  final YamaAccuracyResult accuracy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (accuracy.totalEntries == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.yamaAccuracy, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(
                l10n.yamaCoverageHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final maxCount = accuracy.yamaEntries.values.fold<int>(
      0,
      (max, v) => v > max ? v : max,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.yamaAccuracy, style: theme.textTheme.titleSmall),
                const Spacer(),
                Text(
                  '${accuracy.yamaCoverage}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...accuracy.yamaEntries.entries.map((entry) {
              final label = _yamaLabel(entry.key);
              final count = entry.value;
              final fraction = maxCount > 0 ? count / maxCount : 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: Text(label, style: theme.textTheme.bodySmall),
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
                            count > 0
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.5 + fraction * 0.5,
                                  )
                                : theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        '$count',
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
  }

  String _yamaLabel(String key) => switch (key) {
    'yama1' => 'Yama 1',
    'yama2' => 'Yama 2',
    'yama3' => 'Yama 3',
    'yama4' => 'Yama 4',
    'yama5' => 'Yama 5',
    _ => key,
  };
}
