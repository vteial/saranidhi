import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/swara_clock.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays expected nostril flow on the 1-hour / 24-cycle clock (CONF-014),
/// seeded at astronomical sunrise by the Weekday Udhaya rule (CONF-013 / CONF-001).
///
/// Highlights the current active swara block and displays the countdown to the next switch.
class NostrilDominanceChart extends StatelessWidget {
  const NostrilDominanceChart({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // If neither sunrise nor yamaResult is available, return empty.
    final sunrise = data.sunrise ?? data.yamaResult?.yamas.firstOrNull?.start;
    if (sunrise == null) return const SizedBox.shrink();

    final now = DateTime.now();

    // Anchor sunrise to the civil day containing now (CONF-001)
    final DateTime anchoredSunrise;
    if (data.latitude != null &&
        data.longitude != null &&
        data.utcOffset != null) {
      anchoredSunrise =
          SwaraClock.anchorSunriseForLocation(
            time: now,
            latitude: data.latitude!,
            longitude: data.longitude!,
            utcOffset: data.utcOffset!,
          ) ??
          (now.isBefore(sunrise)
              ? sunrise.subtract(const Duration(days: 1))
              : sunrise);
    } else {
      anchoredSunrise = now.isBefore(sunrise)
          ? sunrise.subtract(const Duration(days: 1))
          : sunrise;
    }

    final paksha =
        data.lunarPhase ?? LunarPhaseCalculator.phaseForDate(anchoredSunrise);

    final currentBlock = SwaraClock.blockAt(
      time: now,
      sunrise: anchoredSunrise,
      paksha: paksha,
    );

    // Calculate next switch time from current ~1h swara block
    var nextSwitchText = '';
    final minutesLeft = currentBlock.end.difference(now).inMinutes;
    if (minutesLeft > 0) {
      nextSwitchText = l10n.nextSwitch(minutesLeft);
    }

    // Build 5 consecutive hourly blocks (current block + 4 upcoming blocks)
    final blocks = <SwaraBlock>[currentBlock];
    var cursorTime = currentBlock.end.add(const Duration(seconds: 1));
    for (var i = 1; i < 5; i++) {
      final b = SwaraClock.blockAt(
        time: cursorTime,
        sunrise: anchoredSunrise,
        paksha: paksha,
      );
      blocks.add(b);
      cursorTime = b.end.add(const Duration(seconds: 1));
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

            // 5 hourly swara blocks
            for (var i = 0; i < blocks.length; i++)
              _SwaraBlockRow(
                block: blocks[i],
                isActive: i == 0,
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

            // Night gentle wellness note
            if (data.isNight) ...[
              const SizedBox(height: 6),
              Text(
                l10n.nightSwaraRest,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SwaraBlockRow extends StatelessWidget {
  const _SwaraBlockRow({
    required this.block,
    required this.isActive,
    required this.l10n,
    required this.theme,
  });

  final SwaraBlock block;
  final bool isActive;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isSolar = block.flow == BreathFlow.solar;
    final emoji = isSolar ? '\u2600\uFE0F' : '\uD83C\uDF19';
    final flowLabel = isSolar ? l10n.solar : l10n.lunar;
    final timeStr = _formatTime(block.start);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 48,
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
