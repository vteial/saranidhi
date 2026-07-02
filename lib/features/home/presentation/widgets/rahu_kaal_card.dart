import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays the Rahu Kaal time window with contextual urgency styling.
///
/// - Red/orange highlight when currently active.
/// - Amber hint when starting within 1 hour.
/// - Subtle info display otherwise.
class RahuKaalCard extends StatelessWidget {
  const RahuKaalCard({required this.rahuKaal, super.key});

  final RahuKaalResult rahuKaal;

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

    final timeStr =
        '${_formatTime(rahuKaal.start)} - ${_formatTime(rahuKaal.end)}';

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.rahuKaalTitle}: $timeStr',
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
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
