import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/nostril_pattern.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays expected nostril flow per yama (Solar/Lunar pattern).
///
/// Odd yamas (1,3,5) = Solar (Right), Even yamas (2,4) = Lunar (Left).
/// Highlights current yama and shows countdown to next switch.
class NostrilDominanceChart extends StatelessWidget {
  const NostrilDominanceChart({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final yamaResult = data.yamaResult;
    if (yamaResult == null) return const SizedBox.shrink();

    final activeYamaIndex = data.activeYama?.index;
    final now = DateTime.now();

    // Calculate next switch time
    var nextSwitchText = '';
    if (data.activeYama != null) {
      final minutesLeft = data.activeYama!.end.difference(now).inMinutes;
      if (minutesLeft > 0) {
        nextSwitchText = l10n.nextSwitch(minutesLeft);
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.air_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.nostrilPattern,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 5 yama rows
            for (final yama in yamaResult.yamas)
              _NostrilRow(
                yama: yama,
                isActive: yama.index == activeYamaIndex,
                // Use the selected date (from sunrise) so the pattern
                // reflects the viewed date's tithi, not always today.
                date: data.sunrise ?? DateTime.now(),
                l10n: l10n,
                theme: theme,
              ),

            // Night note or next switch countdown
            if (data.isNight) ...[
              const SizedBox(height: 12),
              Text(
                l10n.nightNoNostrilPattern,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ] else if (nextSwitchText.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                nextSwitchText,
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
}

class _NostrilRow extends StatelessWidget {
  const _NostrilRow({
    required this.yama,
    required this.isActive,
    required this.date,
    required this.l10n,
    required this.theme,
  });

  final YamaSegment yama;
  final bool isActive;
  final DateTime date;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // Tithi-based pattern for the viewed date (not always today)
    final expectedFlow = NostrilPattern.expectedFlowForYama(
      yama.index,
      date: date,
    );
    final isSolar = expectedFlow == BreathFlow.solar;
    final emoji = isSolar ? '\u2600\uFE0F' : '\uD83C\uDF19';
    final flowLabel = isSolar ? l10n.solar : l10n.lunar;
    final yamaNumber = yama.index.index + 1;
    final yamaLabel = 'Y$yamaNumber';
    final timeStr = _formatTime(yama.start);

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
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              flowLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '\u2190 ${l10n.now}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
