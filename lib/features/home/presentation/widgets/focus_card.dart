import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window_segment.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Current Mode Focus Card — shows the active action window with
/// a lifestyle recommendation. Tapping opens the expansion bottom sheet.
class FocusCard extends StatelessWidget {
  const FocusCard({
    required this.segment,
    this.onTap,
    super.key,
  });

  /// The currently active action window segment.
  final ActionWindowSegment segment;

  /// Callback when the card is tapped (opens expansion sheet).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final icon = _iconForWindow(segment.window);
    final color = _colorForWindow(segment.window, theme);
    final title = _titleForWindow(segment.window, l10n);
    final subtitle = _subtitleForWindow(segment.window, l10n);

    // Time remaining
    final now = DateTime.now();
    final remaining = segment.end.difference(now);
    final minutesLeft = remaining.inMinutes.clamp(0, 9999);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  if (segment.isBlockedByRahu)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'RAHU',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Text(
                      '${minutesLeft}min',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.expand_more,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                segment.isBlockedByRahu
                    ? _rahuBlockedText(segment.window, l10n)
                    : subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForWindow(ActionWindow window) {
    return switch (window) {
      ActionWindow.artha => Icons.bolt,
      ActionWindow.kriya => Icons.restaurant,
      ActionWindow.yoga => Icons.self_improvement,
    };
  }

  Color _colorForWindow(ActionWindow window, ThemeData theme) {
    return switch (window) {
      ActionWindow.artha => Colors.green.shade700,
      ActionWindow.kriya => Colors.blue.shade700,
      ActionWindow.yoga => Colors.purple.shade700,
    };
  }

  String _titleForWindow(ActionWindow window, AppLocalizations l10n) {
    return switch (window) {
      ActionWindow.artha => l10n.termArtha,
      ActionWindow.kriya => l10n.termKriya,
      ActionWindow.yoga => l10n.termYoga,
    };
  }

  String _subtitleForWindow(ActionWindow window, AppLocalizations l10n) {
    return switch (window) {
      ActionWindow.artha => l10n.focusCardArthaAdvice,
      ActionWindow.kriya => l10n.focusCardKriyaAdvice,
      ActionWindow.yoga => l10n.focusCardYogaAdvice,
    };
  }

  String _rahuBlockedText(ActionWindow window, AppLocalizations l10n) {
    return l10n.focusCardRahuBlocked;
  }
}
