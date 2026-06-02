/// Result of a Rahu Kaal calculation.
class RahuKaalResult {
  const RahuKaalResult({
    required this.start,
    required this.end,
    required this.weekday,
  });

  /// Start time of Rahu Kaal.
  final DateTime start;

  /// End time of Rahu Kaal.
  final DateTime end;

  /// The weekday (0=Sunday..6=Saturday) this was calculated for.
  final int weekday;

  /// Duration of the Rahu Kaal window.
  Duration get duration => end.difference(start);

  /// Whether the given [time] falls within Rahu Kaal
  /// (inclusive start, exclusive end).
  bool isActive(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }
}

/// Calculates Rahu Kaal — the inauspicious time window each day.
///
/// Rahu Kaal is determined by dividing daylight (sunrise to sunset)
/// into 8 equal segments and selecting one based on the weekday:
///
/// | Day       | Segment Index (1-based) |
/// |-----------|------------------------|
/// | Sunday    | 8th                    |
/// | Monday    | 2nd                    |
/// | Tuesday   | 7th                    |
/// | Wednesday | 5th                    |
/// | Thursday  | 6th                    |
/// | Friday    | 4th                    |
/// | Saturday  | 3rd                    |
///
/// During Rahu Kaal, the Oracle Readiness is locked to 10% (Floor Lockout).
class RahuKaalCalculator {
  const RahuKaalCalculator._();

  /// Segment index (1-based) for each weekday.
  /// Index 0 = Sunday, 1 = Monday, ..., 6 = Saturday.
  static const List<int> _segmentByWeekday = [
    8, // Sunday
    2, // Monday
    7, // Tuesday
    5, // Wednesday
    6, // Thursday
    4, // Friday
    3, // Saturday
  ];

  /// Calculates the Rahu Kaal window for a given day.
  ///
  /// [sunrise] and [sunset] define the daylight period.
  /// [weekday] is 0=Sunday through 6=Saturday.
  ///
  /// Throws [ArgumentError] if weekday is out of range or sunset is
  /// not after sunrise.
  static RahuKaalResult calculate({
    required DateTime sunrise,
    required DateTime sunset,
    required int weekday,
  }) {
    if (weekday < 0 || weekday > 6) {
      throw ArgumentError.value(
        weekday,
        'weekday',
        'Must be 0 (Sunday) through 6 (Saturday)',
      );
    }
    if (!sunset.isAfter(sunrise)) {
      throw ArgumentError('sunset must be after sunrise');
    }

    final totalDaylightMs = sunset.difference(sunrise).inMilliseconds;
    final segmentDurationMs = totalDaylightMs ~/ 8;

    // Segment index is 1-based
    final segmentIndex = _segmentByWeekday[weekday];

    final start = sunrise.add(
      Duration(milliseconds: segmentDurationMs * (segmentIndex - 1)),
    );
    final end = sunrise.add(
      Duration(milliseconds: segmentDurationMs * segmentIndex),
    );

    return RahuKaalResult(start: start, end: end, weekday: weekday);
  }
}
