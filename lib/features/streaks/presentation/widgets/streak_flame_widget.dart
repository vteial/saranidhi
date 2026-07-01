import 'package:flutter/material.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays the current streak with a flame icon.
class StreakFlameWidget extends StatelessWidget {
  const StreakFlameWidget({required this.streak, super.key});

  final StreakResult streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
                  l10n.streakDays(streak.currentStreak),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  streak.isActiveToday
                      ? l10n.activeToday
                      : streak.currentStreak > 0
                      ? l10n.logTodayToContinue
                      : l10n.startYourStreak,
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
                    l10n.best,
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
