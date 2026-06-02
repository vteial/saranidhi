import 'package:flutter/material.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';

/// Displays the current streak with a flame icon.
class StreakFlameWidget extends StatelessWidget {
  const StreakFlameWidget({required this.streak, super.key});

  final StreakResult streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStreak = streak.currentStreak > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.local_fire_department,
              size: 40,
              color: hasStreak
                  ? Colors.orange
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${streak.currentStreak} day${streak.currentStreak == 1 ? '' : 's'}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  streak.isActiveToday
                      ? 'Active today!'
                      : streak.currentStreak > 0
                      ? 'Log today to continue'
                      : 'Start your streak',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (streak.longestStreak > streak.currentStreak)
              Column(
                children: [
                  Text(
                    '${streak.longestStreak}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Best',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
