import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.nostrilPattern,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 5 yama rows
            for (final yama in yamaResult.yamas)
              _NostrilRow(
                yama: yama,
                isActive: yama.index == activeYamaIndex,
                l10n: l10n,
                theme: theme,
              ),

            // Next switch countdown
            if (nextSwitchText.isNotEmpty) ...[
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
    required this.l10n,
    required this.theme,
  });

  final YamaSegment yama;
  final bool isActive;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // Odd yamas (1,3,5) = Solar, Even yamas (2,4) = Lunar
    final yamaNumber = yama.index.index + 1;
    final isSolar = yamaNumber.isOdd;
    final emoji = isSolar ? '\u2600\uFE0F' : '\uD83C\uDF19';
    final flowLabel = isSolar ? l10n.solar : l10n.lunar;
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
}
