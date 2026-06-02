import 'package:flutter/material.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';

/// Displays the 30-day alignment trend as a progress bar.
class TrendWidget extends StatelessWidget {
  const TrendWidget({required this.trend, super.key});

  final TrendResult trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = trend.alignmentPercentage;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('30-Day Trend', style: theme.textTheme.titleSmall),
                const Spacer(),
                Text(
                  '$percentage%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _percentColor(percentage, theme),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _percentColor(percentage, theme),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${trend.totalAlignedDays} aligned of '
              '${trend.totalDaysWithEntries} days logged',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _percentColor(int percentage, ThemeData theme) {
    if (percentage >= 70) return theme.colorScheme.primary;
    if (percentage >= 40) return Colors.orange;
    return theme.colorScheme.error;
  }
}
