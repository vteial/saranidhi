import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/emakandam_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/kuligai_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Enhanced Rahu Kaal card showing Rahu Kaal, Kuligai Kaal,
/// Emakandam, sunrise/sunset times, and current moon phase.
///
/// Layout:
/// - Row 1: Rahu Kaal (main, with urgency styling)
/// - Row 2: Kuligai + Emakandam
/// - Row 3: Sunrise/Sunset + Moon Phase
/// - Row 4: Weekday + Tithi + Current Hora
class RahuKaalCard extends StatelessWidget {
  const RahuKaalCard({
    required this.rahuKaal,
    this.kuligaiKaal,
    this.emakandam,
    this.sunrise,
    this.sunset,
    this.lunarPhase,
    this.activeHora,
    this.selectedDate,
    super.key,
  });

  final RahuKaalResult rahuKaal;
  final KuligaiKaalResult? kuligaiKaal;
  final EmakandamResult? emakandam;
  final DateTime? sunrise;
  final DateTime? sunset;
  final LunarPhase? lunarPhase;
  final HoraResult? activeHora;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    final isActive = rahuKaal.isActive(now);
    final isSoon = !isActive &&
        now.isBefore(rahuKaal.start) &&
        rahuKaal.start.difference(now).inMinutes <= 60;

    final Color cardColor;
    final Color textColor;
    final String subtitle;
    final IconData icon;

    if (isActive) {
      cardColor = theme.colorScheme.error.withValues(alpha: 0.12);
      textColor = theme.colorScheme.error;
      subtitle = l10n.rahuKaalActive;
      icon = Icons.warning_rounded;
    } else if (isSoon) {
      cardColor = Colors.orange.withValues(alpha: 0.10);
      textColor = Colors.orange.shade800;
      subtitle = l10n.rahuKaalSoon;
      icon = Icons.access_time_rounded;
    } else {
      cardColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);
      textColor = theme.colorScheme.onSurfaceVariant;
      subtitle = '';
      icon = Icons.info_outline_rounded;
    }

    final rahuTimeStr =
        '${_formatTime(rahuKaal.start)} - ${_formatTime(rahuKaal.end)}';

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isActive
              ? theme.colorScheme.error.withValues(alpha: 0.3)
              : isSoon
                  ? Colors.orange.withValues(alpha: 0.3)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Rahu Kaal row
            Row(
              children: [
                Icon(icon, color: textColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.rahuKaalTitle}: $rahuTimeStr',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Row 2: Kuligai + Emakandam
            if (kuligaiKaal != null || emakandam != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  if (kuligaiKaal != null)
                    _InfoChip(
                      emoji: '\u26A0\uFE0F',
                      label:
                          '${l10n.kuligaiKaalTitle}: ${_formatTime(kuligaiKaal!.start)} - ${_formatTime(kuligaiKaal!.end)}',
                      theme: theme,
                    ),
                  if (emakandam != null)
                    _InfoChip(
                      emoji: '\u26A0\uFE0F',
                      label:
                          '${l10n.emakandamTitle}: ${_formatTime(emakandam!.start)} - ${_formatTime(emakandam!.end)}',
                      theme: theme,
                    ),
                ],
              ),
            ],

            // Row 3: Sunrise/Sunset + Moon Phase
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                // Sunrise / Sunset
                if (sunrise != null && sunset != null)
                  _InfoChip(
                    emoji: '\u2600\uFE0F',
                    label:
                        '${_formatTime(sunrise!)} / ${_formatTime(sunset!)}',
                    theme: theme,
                  ),

                // Moon phase
                if (lunarPhase != null)
                  _InfoChip(
                    emoji: lunarPhase == LunarPhase.waxing
                        ? '\uD83C\uDF14'
                        : '\uD83C\uDF16',
                    label: lunarPhase == LunarPhase.waxing
                        ? l10n.moonWaxing
                        : l10n.moonWaning,
                    theme: theme,
                  ),
              ],
            ),

            // Row 4: Weekday + Tithi + Hora planet
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                // Weekday + Tithi
                _InfoChip(
                  emoji: '\uD83D\uDCC5',
                  label: _tithiLabel(l10n),
                  theme: theme,
                ),

                // Current Hora planet
                if (activeHora != null)
                  _InfoChip(
                    emoji: _horaEmoji(activeHora!.planet),
                    label: _localizedPlanet(activeHora!.planet, l10n),
                    theme: theme,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  String _tithiLabel(AppLocalizations l10n) {
    final date = selectedDate ?? DateTime.now();
    final lunarResult = LunarPhaseCalculator.calculate(date);
    final daysSinceNew = lunarResult.daysSinceNewMoon;

    // Tithi: each tithi is ~1 day (29.53/30 tithis per month)
    // Shukla (waxing) 1-15, Krishna (waning) 1-15
    final tithiIndex = (daysSinceNew % 29.53) / (29.53 / 30);
    final int tithiNum;
    final String pakshaLabel;

    if (lunarResult.phase == LunarPhase.waxing) {
      tithiNum = (tithiIndex % 15).floor() + 1;
      pakshaLabel = 'Shukla';
    } else {
      tithiNum = ((tithiIndex - 15) % 15).floor() + 1;
      pakshaLabel = 'Krishna';
    }

    return '$pakshaLabel $tithiNum';
  }

  String _horaEmoji(HoraPlanet planet) => switch (planet) {
    HoraPlanet.sun => '\u2600\uFE0F',
    HoraPlanet.moon => '\uD83C\uDF19',
    HoraPlanet.mars => '\u2642\uFE0F',
    HoraPlanet.mercury => '\u263F',
    HoraPlanet.jupiter => '\u2643',
    HoraPlanet.venus => '\u2640\uFE0F',
    HoraPlanet.saturn => '\u2644',
  };

  String _localizedPlanet(HoraPlanet planet, AppLocalizations l10n) {
    return switch (planet) {
      HoraPlanet.sun => l10n.planetSun,
      HoraPlanet.moon => l10n.planetMoon,
      HoraPlanet.mars => l10n.planetMars,
      HoraPlanet.mercury => l10n.planetMercury,
      HoraPlanet.jupiter => l10n.planetJupiter,
      HoraPlanet.venus => l10n.planetVenus,
      HoraPlanet.saturn => l10n.planetSaturn,
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.emoji,
    required this.label,
    required this.theme,
  });

  final String emoji;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
