import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

/// Displays the Oracle evaluation result with a score gauge and guidance.
///
/// Shows:
/// - Score gauge (0–100 with color gradient)
/// - Answer band label (Siddha / Vardhana / Mandha / Stambhana / Sunya)
/// - Guidance text (locale-aware)
/// - Floor lock indicator if inauspicious window
class OracleResultCard extends ConsumerWidget {
  const OracleResultCard({
    required this.score,
    required this.band,
    required this.guidanceEn,
    required this.guidanceTa,
    required this.isFloorLocked,
    required this.category,
    required this.queryText,
    super.key,
  });

  final int score;
  final OracleBand band;
  final String guidanceEn;
  final String guidanceTa;
  final bool isFloorLocked;
  final QueryCategory category;
  final String queryText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final isTamil = locale.languageCode == 'ta';

    final bandColor = _bandColor(band, theme);
    final bandLabel = _bandLabel(band, l10n);
    final bandEmoji = _bandEmoji(band);
    final guidance = isTamil ? guidanceTa : guidanceEn;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score gauge
            _ScoreGauge(score: score, bandColor: bandColor),
            const SizedBox(height: 16),

            // Band label with emoji
            Text(
              '$bandEmoji $bandLabel',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: bandColor,
              ),
            ),
            const SizedBox(height: 4),

            // Score text
            Text(
              '${l10n.prasanamScore}: $score/100',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Floor lock warning
            if (isFloorLocked) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.prasanamFloorLocked,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Guidance text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bandColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: bandColor.withValues(alpha: 0.25)),
              ),
              child: Text(
                guidance,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Query context (category + text)
            if (queryText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '"$queryText"',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _bandColor(OracleBand band, ThemeData theme) {
    return switch (band) {
      OracleBand.siddha => Colors.green.shade700,
      OracleBand.vardhana => Colors.teal.shade600,
      OracleBand.mandha => Colors.orange.shade700,
      OracleBand.stambhana => Colors.deepOrange.shade700,
      OracleBand.sunya => Colors.red.shade800,
    };
  }

  String _bandLabel(OracleBand band, AppLocalizations l10n) {
    return switch (band) {
      OracleBand.siddha => l10n.prasanamBandSiddha,
      OracleBand.vardhana => l10n.prasanamBandVardhana,
      OracleBand.mandha => l10n.prasanamBandMandha,
      OracleBand.stambhana => l10n.prasanamBandStambhana,
      OracleBand.sunya => l10n.prasanamBandSunya,
    };
  }

  String _bandEmoji(OracleBand band) {
    return switch (band) {
      OracleBand.siddha => '\u2728', // sparkles
      OracleBand.vardhana => '\u2705', // check
      OracleBand.mandha => '\u26A0\uFE0F', // warning
      OracleBand.stambhana => '\u23F8\uFE0F', // pause
      OracleBand.sunya => '\u26D4', // no entry
    };
  }
}

/// Custom gauge widget showing the Oracle score.
class _ScoreGauge extends StatelessWidget {
  const _ScoreGauge({required this.score, required this.bandColor});

  final int score;
  final Color bandColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 160,
      height: 100,
      child: CustomPaint(
        painter: _GaugePainter(
          score: score,
          bandColor: bandColor,
          trackColor: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '$score',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: bandColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the semi-circular gauge.
class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.score,
    required this.bandColor,
    required this.trackColor,
  });

  final int score;
  final Color bandColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 12;
    const strokeWidth = 12.0;
    const startAngle = math.pi; // 180 degrees (left)
    const sweepAngle = math.pi; // 180 degrees arc

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Value
    final valuePaint = Paint()
      ..color = bandColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final valueSweep = (score / 100) * sweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      valueSweep,
      false,
      valuePaint,
    );

    // Needle dot
    final needleAngle = startAngle + valueSweep;
    final needleX = center.dx + radius * math.cos(needleAngle);
    final needleY = center.dy + radius * math.sin(needleAngle);
    final needlePaint = Paint()..color = bandColor;
    canvas.drawCircle(Offset(needleX, needleY), 6, needlePaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.bandColor != bandColor;
}
