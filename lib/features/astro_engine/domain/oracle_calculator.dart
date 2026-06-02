import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';

/// The floor value (percentage) that Oracle Readiness is locked to
/// during Rahu Kaal.
const int kRahuFloorPercent = 10;

/// Result of the Oracle Readiness calculation.
class OracleResult {
  const OracleResult({
    required this.readinessPercent,
    required this.isFloorLocked,
  });

  /// The Oracle Readiness percentage (0–100).
  final int readinessPercent;

  /// Whether the score was forced to the floor due to Rahu Kaal.
  final bool isFloorLocked;
}

/// Calculates Oracle Readiness with 10% Floor Lockout during Rahu Kaal.
///
/// The Oracle Readiness represents how "auspicious" the current moment is
/// for beginning new activities. During Rahu Kaal, regardless of other
/// factors, the readiness is locked to exactly 10%.
///
/// Outside Rahu Kaal, the normal calculated score passes through unchanged.
class OracleCalculator {
  const OracleCalculator._();

  /// Calculates the Oracle Readiness for a given time.
  ///
  /// [normalScore] is the calculated readiness (0–100) from other factors
  /// (e.g., alignment, bird state, hora strength).
  ///
  /// [rahuKaal] is the Rahu Kaal window for the day.
  ///
  /// [currentTime] is the time to check.
  ///
  /// If [currentTime] is within Rahu Kaal, returns [kRahuFloorPercent] (10%).
  /// Otherwise, returns [normalScore] clamped to 0–100.
  static OracleResult calculate({
    required int normalScore,
    required RahuKaalResult rahuKaal,
    required DateTime currentTime,
  }) {
    final isInRahu = rahuKaal.isActive(currentTime);

    if (isInRahu) {
      return const OracleResult(
        readinessPercent: kRahuFloorPercent,
        isFloorLocked: true,
      );
    }

    return OracleResult(
      readinessPercent: normalScore.clamp(0, 100),
      isFloorLocked: false,
    );
  }
}
