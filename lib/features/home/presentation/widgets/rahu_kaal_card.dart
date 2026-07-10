import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/kuligai_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Enhanced Rahu Kaal card showing Rahu Kaal, Kuligai Kaal,
/// sunrise/sunset times, and current moon phase.
///
/// - Red/orange highlight when Rahu Kaal currently active.
/// - Amber hint when starting within 1 hour.
/// - Subtle info display otherwise.
class RahuKaalCard extends StatelessWidget {
  const RahuKaalCard({
    required this.rahuKaal,
    this.kuligaiKaal,
    this.sunrise,
    this.sunset,
    this.lunarPhase,
    super.key,
  });

  final RahuKaalResult rahuKaal;
  final KuligaiKaalResult? kuligaiKaal;
  final DateTime? sunrise;
  final DateTime? sunset;
  final LunarPhase? lunarPhase;

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
      cardColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
      textColor = theme.colorScheme.onSurfaceVariant;
      subtitle = '';
      icon = Icons.info_outline_rounded;
    }

    final rahuTimeStr =
        '${_formatTime(rahuKaal.start)} - ${_formatTime(rahuKaal.end)}';

    return Card(
      color: cardColor,
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

            // Additional info row: Kuligai, Sunrise/Sunset, Moon Phase
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

                // Kuligai Kaal
                if (kuligaiKaal != null)
                  _InfoChip(
                    emoji: '\u26A0\uFE0F',
                    label:
                        '${l10n.kuligaiKaalTitle}: ${_formatTime(kuligaiKaal!.start)} - ${_formatTime(kuligaiKaal!.end)}',
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
