import 'package:flutter/material.dart';

import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Hero card showing the user's birth bird and its current state.
///
/// Displays the bird emoji, localized name and state, guidance text,
/// and a progress bar showing current yama progress with time remaining.
/// Works for both daytime and nighttime yamas.
class BirthBirdCard extends StatelessWidget {
  const BirthBirdCard({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final bird = data.birthBird;
    if (bird == null) return const SizedBox.shrink();

    // Determine state based on day/night
    final PakshiState? state;
    if (data.isNight && data.activeNightYama != null) {
      state = data.birthBirdNightState;
    } else {
      state = data.birthBirdState;
    }

    final birdEmoji = BirdEmoji.forBird(bird);
    final birdName = bird.localizedName(l10n);
    final stateName = state?.localizedName(l10n) ?? '';

    final stateColor = _colorForState(state, theme);
    final guidance = _guidanceText(state, data.isNight, l10n);

    // Yama progress — works for both day and night
    var yamaProgressText = '';
    var yamaProgress = 0.0;

    if (data.isNight && data.activeNightYama != null) {
      final nightYama = data.activeNightYama!;
      final now = DateTime.now();
      final elapsed = now.difference(nightYama.start).inMilliseconds;
      final total = nightYama.duration.inMilliseconds;
      yamaProgress = (elapsed / total).clamp(0.0, 1.0);

      final remaining = nightYama.end.difference(now);
      final minutesLeft = remaining.inMinutes;
      yamaProgressText = l10n.yamaProgress(
        nightYama.index.index + 6,
        '${minutesLeft}min',
      );
    } else if (data.activeYama != null) {
      final activeYama = data.activeYama!;
      final now = DateTime.now();
      final elapsed = now.difference(activeYama.start).inMilliseconds;
      final total = activeYama.duration.inMilliseconds;
      yamaProgress = (elapsed / total).clamp(0.0, 1.0);

      final remaining = activeYama.end.difference(now);
      final minutesLeft = remaining.inMinutes;
      yamaProgressText = l10n.yamaProgress(
        activeYama.index.index + 1,
        '${minutesLeft}min',
      );
    }

    final hasProgress = (data.isNight && data.activeNightYama != null) ||
        (!data.isNight && data.activeYama != null);

    return Card(
      color: stateColor.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bird name and state
            Text(
              '$birdEmoji ${l10n.yourBirdState(birdName, stateName)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: stateColor,
              ),
            ),
            const SizedBox(height: 8),

            // Guidance text
            if (guidance.isNotEmpty)
              Text(
                guidance,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 12),

            // Progress bar + yama info
            if (hasProgress) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: yamaProgress,
                  backgroundColor: stateColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                yamaProgressText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _colorForState(PakshiState? state, ThemeData theme) {
    return switch (state) {
      PakshiState.ruling => theme.colorScheme.primary,
      PakshiState.eating => theme.colorScheme.primary,
      PakshiState.walking => Colors.orange,
      PakshiState.sleeping => theme.colorScheme.error,
      PakshiState.dying => theme.colorScheme.error,
      null => theme.colorScheme.onSurface,
    };
  }

  String _guidanceText(PakshiState? state, bool isNight, AppLocalizations l10n) {
    if (isNight) {
      return switch (state) {
        PakshiState.ruling => l10n.guidanceNightRuling,
        PakshiState.eating => l10n.guidanceNightEating,
        PakshiState.walking => l10n.guidanceNightWalking,
        PakshiState.sleeping => l10n.guidanceNightSleeping,
        PakshiState.dying => l10n.guidanceNightDying,
        null => '',
      };
    }
    return switch (state) {
      PakshiState.ruling => l10n.guidanceRuling,
      PakshiState.eating => l10n.guidanceEating,
      PakshiState.walking => l10n.guidanceWalking,
      PakshiState.sleeping => l10n.guidanceSleeping,
      PakshiState.dying => l10n.guidanceDying,
      null => '',
    };
  }
}
