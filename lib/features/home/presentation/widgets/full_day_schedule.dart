import 'package:flutter/material.dart';

import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/core/utils/pakshi_l10n.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays the full 5-yama daily schedule with the user's birth bird state
/// at each yama, highlighting the current yama.
class FullDaySchedule extends StatelessWidget {
  const FullDaySchedule({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final bird = data.birthBird;
    final pakshiDay = data.pakshiDay;
    final yamaResult = data.yamaResult;
    if (bird == null || pakshiDay == null || yamaResult == null) {
      return const SizedBox.shrink();
    }

    final birdEmoji = BirdEmoji.forBird(bird);
    final activeYamaIndex = data.activeYama?.index;

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

            // 5 yama rows
            for (final yama in yamaResult.yamas)
              _YamaRow(
                yama: yama,
                birdEmoji: birdEmoji,
                birdState: pakshiDay.stateForBird(bird, yama.index),
                isActive: yama.index == activeYamaIndex,
                isBest: pakshiDay.stateForBird(bird, yama.index) ==
                    PakshiState.ruling,
                l10n: l10n,
                theme: theme,
              ),

            const Divider(height: 16),

            // Align27 comparison row
            if (activeYamaIndex != null) ...[
              _Align27Row(
                pakshiDay: pakshiDay,
                activeYamaIndex: activeYamaIndex,
                l10n: l10n,
                theme: theme,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _YamaRow extends StatelessWidget {
  const _YamaRow({
    required this.yama,
    required this.birdEmoji,
    required this.birdState,
    required this.isActive,
    required this.isBest,
    required this.l10n,
    required this.theme,
  });

  final YamaSegment yama;
  final String birdEmoji;
  final PakshiState birdState;
  final bool isActive;
  final bool isBest;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final stateColor = _colorForState(birdState, theme);
    final timeStr = _formatTime(yama.start);
    final stateName = birdState.localizedName(l10n);
    final yamaLabel = 'Y${yama.index.index + 1}';

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
          if (isActive)
            Text(
              '\u2190 ${l10n.now}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: stateColor,
              ),
            )
          else if (isBest)
            Text(
              '\u2190 ${l10n.bestTime}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
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

class _Align27Row extends StatelessWidget {
  const _Align27Row({
    required this.pakshiDay,
    required this.activeYamaIndex,
    required this.l10n,
    required this.theme,
  });

  final PakshiDayResult pakshiDay;
  final YamaIndex activeYamaIndex;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final entry = pakshiDay.forYama(activeYamaIndex);
    final rulingBird = entry.bird;
    final birdEmoji = BirdEmoji.forBird(rulingBird);
    final birdName = rulingBird.localizedName(l10n);
    final stateName = entry.state.localizedName(l10n);

    return Row(
      children: [
        Text(birdEmoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            l10n.align27Shows(birdName, stateName),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
