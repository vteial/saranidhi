import 'package:flutter/material.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays the current streak with a flame icon.
///
/// When the user has zero streak (new users), shows a motivational
/// onboarding-style hint to encourage their first entry.
class StreakFlameWidget extends StatelessWidget {
  const StreakFlameWidget({required this.streak, super.key});

  final StreakResult streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hasStreak = streak.currentStreak > 0;

    // Zero-state: show motivational onboarding card
    if (!hasStreak && !streak.isActiveToday) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 32,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.streakZeroTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.streakZeroSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Motivational steps
              _StreakStep(
                icon: Icons.air_rounded,
                text: l10n.streakStep1,
                theme: theme,
              ),
              const SizedBox(height: 6),
              _StreakStep(
                icon: Icons.check_circle_outline,
                text: l10n.streakStep2,
                theme: theme,
              ),
              const SizedBox(height: 6),
              _StreakStep(
                icon: Icons.trending_up,
                text: l10n.streakStep3,
                theme: theme,
              ),
            ],
          ),
        ),
      );
    }

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

class _StreakStep extends StatelessWidget {
  const _StreakStep({
    required this.icon,
    required this.text,
    required this.theme,
  });

  final IconData icon;
  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
