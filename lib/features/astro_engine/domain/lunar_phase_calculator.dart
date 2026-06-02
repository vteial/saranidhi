import 'dart:math';

import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Detailed lunar phase information.
class LunarPhaseResult {
  const LunarPhaseResult({
    required this.phase,
    required this.illumination,
    required this.daysSinceNewMoon,
  });

  /// Whether the moon is waxing or waning.
  final LunarPhase phase;

  /// Approximate illumination percentage (0.0 to 1.0).
  final double illumination;

  /// Days since the last new moon (0–29.53).
  final double daysSinceNewMoon;

  /// Whether this is a full moon day (within 0.5 days of day 14.76).
  bool get isFullMoon => (daysSinceNewMoon - 14.765).abs() < 0.5;

  /// Whether this is a new moon day (within 0.5 days of day 0 or 29.53).
  bool get isNewMoon =>
      daysSinceNewMoon < 0.5 || (29.53 - daysSinceNewMoon) < 0.5;
}

/// Calculates the lunar phase (waxing/waning) for a given date.
///
/// Uses a simplified astronomical algorithm based on the synodic month
/// (29.53 days). This is an approximation suitable for Panja Pakshi
/// calculations — accuracy is within ±1 day.
///
/// The algorithm calculates the moon's age from a known new moon
/// reference date and determines the phase from that.
///
/// Reference new moon: January 6, 2000 at 18:14 UTC (a well-documented
/// astronomical event used as an epoch).
class LunarPhaseCalculator {
  const LunarPhaseCalculator._();

  /// Average length of a synodic month (new moon to new moon) in days.
  static const double _synodicMonth = 29.53058867;

  /// Reference new moon epoch: January 6, 2000 at 18:14 UTC.
  /// Expressed as Julian Day Number for precision.
  static final DateTime _referenceNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

  /// Calculates the lunar phase for a given [date].
  ///
  /// Returns a [LunarPhaseResult] with the phase (waxing/waning),
  /// approximate illumination, and days since last new moon.
  static LunarPhaseResult calculate(DateTime date) {
    final daysSinceNewMoon = _moonAge(date);

    // Waxing: day 0 to ~14.76 (new moon to full moon)
    // Waning: day ~14.76 to ~29.53 (full moon to next new moon)
    const halfCycle = _synodicMonth / 2;
    final phase = daysSinceNewMoon <= halfCycle
        ? LunarPhase.waxing
        : LunarPhase.waning;

    // Approximate illumination using cosine curve
    final illumination =
        (1 - cos(2 * pi * daysSinceNewMoon / _synodicMonth)) / 2;

    return LunarPhaseResult(
      phase: phase,
      illumination: illumination,
      daysSinceNewMoon: daysSinceNewMoon,
    );
  }

  /// Convenience method: returns just the [LunarPhase] for Pakshi calculations.
  static LunarPhase phaseForDate(DateTime date) {
    return calculate(date).phase;
  }

  /// Calculates the moon's age in days (0 to ~29.53) for the given date.
  static double _moonAge(DateTime date) {
    final utcDate = date.toUtc();
    final diffDays =
        utcDate.difference(_referenceNewMoon).inMilliseconds / 86400000.0;
    var age = diffDays % _synodicMonth;
    if (age < 0) age += _synodicMonth;
    return age;
  }
}
