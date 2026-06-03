import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saranidhi/core/utils/bird_emoji.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

/// Displays today's sunrise/sunset time and current bird state.
class AstroInfoBar extends StatelessWidget {
  const AstroInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();

    // Default: Chennai (will use profile location in future)
    const lat = 13.08;
    const lng = 80.27;
    const utcOffset = 5.5;

    final sunResult = SunriseCalculator.calculate(
      date: now,
      latitude: lat,
      longitude: lng,
      utcOffset: utcOffset,
    );

    if (sunResult == null) {
      return const SizedBox.shrink();
    }

    // Calculate current bird state
    final yamaResult = YamaCalculator.calculate(
      sunrise: sunResult.sunrise,
      sunset: sunResult.sunset,
    );
    final activeYama = yamaResult.activeYama(now);

    final weekday = PakshiCalculator.dartWeekdayToSunBased(now.weekday);
    final lunarPhase = LunarPhaseCalculator.phaseForDate(now);
    final pakshiResult = PakshiCalculator.calculate(
      weekday: weekday,
      lunarPhase: lunarPhase,
    );

    PakshiBird? activeBird;
    PakshiState? activeBirdState;
    if (activeYama != null) {
      final entry = pakshiResult.forYama(activeYama.index);
      activeBird = entry.bird;
      activeBirdState = entry.state;
    }

    return Semantics(
      label: activeBird != null
          ? '${l10n.sunrise} ${_formatTime(sunResult.sunrise)}, '
              '${l10n.sunset} ${_formatTime(sunResult.sunset)}, '
              '${activeBird.displayName} ${activeBirdState?.displayName ?? ''}'
          : '${l10n.sunrise} ${_formatTime(sunResult.sunrise)}, '
              '${l10n.sunset} ${_formatTime(sunResult.sunset)}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoChip(
                icon: Icons.wb_sunny_outlined,
                label: l10n.sunrise,
                value: _formatTime(sunResult.sunrise),
                color: Colors.orange,
              ),
              _InfoChip(
                icon: Icons.nights_stay_outlined,
                label: l10n.sunset,
                value: _formatTime(sunResult.sunset),
                color: Colors.indigo,
              ),
              if (activeBird != null)
                _InfoChip(
                  label: activeBird.displayName,
                  value: activeBirdState?.displayName ?? '',
                  color: theme.colorScheme.primary,
                  emoji: BirdEmoji.forBird(activeBird),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
    this.emoji,
  });

  final IconData? icon;
  final String? emoji;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        if (emoji != null)
          Text(emoji!, style: const TextStyle(fontSize: 20))
        else if (icon != null)
          Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
