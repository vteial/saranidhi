import 'package:flutter/material.dart';

import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window_segment.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// A 24h color-coded horizontal timeline showing consolidated Action Windows.
///
/// Colors: Green = Artha, Blue = Kriya, Purple = Yoga, Red overlay = Rahu blocked.
/// A marker indicates the current time position.
class ActionBar extends StatelessWidget {
  const ActionBar({
    required this.segments,
    required this.dayStart,
    required this.dayEnd,
    this.currentTime,
    super.key,
  });

  /// Consolidated action window segments for the 24h period.
  final List<ActionWindowSegment> segments;

  /// Start of the displayed time range (typically sunrise).
  final DateTime dayStart;

  /// End of the displayed time range (typically next sunrise).
  final DateTime dayEnd;

  /// Current time for the position marker (null = no marker).
  final DateTime? currentTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalMs = dayEnd.difference(dayStart).inMilliseconds;

    if (totalMs <= 0 || segments.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  l10n.actionWindowsTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 28,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = constraints.maxWidth;
                  return Stack(
                    children: [
                      // Segment blocks
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: segments.map((segment) {
                            final segStart = segment.start.isBefore(dayStart)
                                ? dayStart
                                : segment.start;
                            final segEnd = segment.end.isAfter(dayEnd)
                                ? dayEnd
                                : segment.end;
                            final segMs =
                                segEnd.difference(segStart).inMilliseconds;
                            final flex = (segMs * 1000 ~/ totalMs).clamp(1, 1000);

                            return Expanded(
                              flex: flex,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _colorForWindow(
                                    segment.window,
                                    segment.isBlockedByRahu,
                                    theme,
                                  ),
                                ),
                                child: segment.isBlockedByRahu
                                    ? CustomPaint(
                                        painter: _DiagonalStripePainter(
                                          color: Colors.red.withValues(alpha: 0.3),
                                        ),
                                        child: const SizedBox.expand(),
                                      )
                                    : const SizedBox.expand(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Current time marker
                      if (currentTime != null &&
                          !currentTime!.isBefore(dayStart) &&
                          currentTime!.isBefore(dayEnd))
                        Positioned(
                          left: (currentTime!.difference(dayStart).inMilliseconds /
                                  totalMs *
                                  barWidth)
                              .clamp(0, barWidth - 2),
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2.5,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(1),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.3),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendDot(
                  color: _windowColor(ActionWindow.artha, theme),
                  label: l10n.termArtha,
                ),
                _LegendDot(
                  color: _windowColor(ActionWindow.kriya, theme),
                  label: l10n.termKriya,
                ),
                _LegendDot(
                  color: _windowColor(ActionWindow.yoga, theme),
                  label: l10n.termYoga,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForWindow(
    ActionWindow window,
    bool isBlocked,
    ThemeData theme,
  ) {
    if (isBlocked) {
      return Colors.red.withValues(alpha: 0.25);
    }
    return _windowColor(window, theme);
  }

  static Color _windowColor(ActionWindow window, ThemeData theme) {
    return switch (window) {
      ActionWindow.artha => Colors.green.withValues(alpha: 0.7),
      ActionWindow.kriya => Colors.blue.withValues(alpha: 0.6),
      ActionWindow.yoga => Colors.purple.withValues(alpha: 0.6),
    };
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

/// Draws diagonal stripes for Rahu-blocked segments.
class _DiagonalStripePainter extends CustomPainter {
  _DiagonalStripePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const gap = 6.0;
    for (var x = -size.height; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
