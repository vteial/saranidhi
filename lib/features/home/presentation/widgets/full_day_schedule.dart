import 'package:flutter/material.dart';

import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays the full 10-yama daily schedule (5 day + 5 night) with the user's
/// birth bird state at each yama, highlighting the current yama.
class FullDaySchedule extends StatelessWidget {
  const FullDaySchedule({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final bird = data.effectiveBirthBird ?? data.birthBird;
    final pakshiDay = data.pakshiDay;
    final yamaResult = data.yamaResult;
    if (bird == null || pakshiDay == null || yamaResult == null) {
      return const SizedBox.shrink();
    }

    final birdEmoji = BirdEmoji.forBird(bird);
    final activeYamaIndex = data.activeYama?.index;
    final activeNightYamaIndex = data.activeNightYama?.index;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.todaysSchedule,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 5 daytime yama rows
            for (final yama in yamaResult.yamas)
              _YamaRow(
                yamaNumber: yama.index.index + 1,
                startTime: yama.start,
                birdEmoji: birdEmoji,
                birdState: pakshiDay.stateForBird(bird, yama.index),
                isActive: !data.isNight && yama.index == activeYamaIndex,
                isBest: pakshiDay.stateForBird(bird, yama.index) ==
                    PakshiState.ruling,
                l10n: l10n,
                theme: theme,
              ),

            // Night section
            if (data.nightYamaResult != null && data.pakshiNight != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Text('\uD83C\uDF19', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      l10n.nightYamas,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // 5 nighttime yama rows
              for (var i = 0; i < data.nightYamaResult!.yamas.length; i++)
                _YamaRow(
                  yamaNumber: i + 6,
                  startTime: data.nightYamaResult!.yamas[i].start,
                  birdEmoji: birdEmoji,
                  birdState: data.pakshiNight!.stateTable[bird.index][i],
                  isActive: data.isNight &&
                      data.nightYamaResult!.yamas[i].index ==
                          activeNightYamaIndex,
                  isBest: data.pakshiNight!.stateTable[bird.index][i] ==
                      PakshiState.ruling,
                  l10n: l10n,
                  theme: theme,
                ),
            ],

            const Divider(height: 16),

            // Ruling bird info for current yama
            if (!data.isNight && activeYamaIndex != null) ...[
              // Removed Align27 comparison row (Sprint 27.5)
            ] else if (data.isNight &&
                activeNightYamaIndex != null &&
                data.pakshiNight != null) ...[
              // Removed Align27 comparison row (Sprint 27.5)
            ],
          ],
        ),
      ),
    );
  }
}

class _YamaRow extends StatelessWidget {
  const _YamaRow({
    required this.yamaNumber,
    required this.startTime,
    required this.birdEmoji,
    required this.birdState,
    required this.isActive,
    required this.isBest,
    required this.l10n,
    required this.theme,
  });

  final int yamaNumber;
  final DateTime startTime;
  final String birdEmoji;
  final PakshiState birdState;
  final bool isActive;
  final bool isBest;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final stateColor = _colorForState(birdState, theme);
    final timeStr = _formatTime(startTime);
    final stateName = birdState.localizedName(l10n);
    final yamaLabel = 'Y$yamaNumber';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              yamaLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              timeStr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(birdEmoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              stateName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(BirdEmoji.forState(birdState), style: const TextStyle(fontSize: 14)),
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                '\u2190 ${l10n.now}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: stateColor,
                ),
              ),
            )
          else if (isBest)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                '\u2190 ${l10n.bestTime}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          const SizedBox(width: 8),
          _StateIndicator(color: stateColor),
        ],
      ),
    );
  }

  Color _colorForState(PakshiState state, ThemeData theme) {
    return switch (state) {
      PakshiState.ruling => theme.colorScheme.primary,
      PakshiState.eating => theme.colorScheme.primary,
      PakshiState.walking => Colors.orange,
      PakshiState.sleeping => theme.colorScheme.error,
      PakshiState.dying => theme.colorScheme.error,
    };
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}

class _StateIndicator extends StatelessWidget {
  const _StateIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
