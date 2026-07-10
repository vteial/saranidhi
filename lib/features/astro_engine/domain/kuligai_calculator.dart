/// Result of a Kuligai Kaal calculation.
class KuligaiKaalResult {
  const KuligaiKaalResult({
    required this.start,
    required this.end,
    required this.weekday,
  });

  /// Start time of Kuligai Kaal.
  final DateTime start;

  /// End time of Kuligai Kaal.
  final DateTime end;

  /// The weekday (0=Sunday..6=Saturday) this was calculated for.
  final int weekday;

  /// Duration of the Kuligai Kaal window.
  Duration get duration => end.difference(start);

  /// Whether the given [time] falls within Kuligai Kaal
  /// (inclusive start, exclusive end).
  bool isActive(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }
}

/// Calculates Kuligai Kaal — the secondary inauspicious time window each day.
///
/// Like Rahu Kaal, Kuligai Kaal divides daylight into 8 equal segments
/// and selects one based on the weekday. The segment offsets are:
///
/// | Day       | Segment Index (1-based) |
/// |-----------|------------------------|
/// | Sunday    | 7th                    |
/// | Monday    | 6th                    |
/// | Tuesday   | 5th                    |
/// | Wednesday | 4th                    |
/// | Thursday  | 3rd                    |
/// | Friday    | 2nd                    |
/// | Saturday  | 1st                    |
///
/// Note: The pattern counts down from Sun=7 to Sat=1.
class KuligaiKaalCalculator {
  const KuligaiKaalCalculator._();

  /// Segment index (1-based) for each weekday.
  /// Index 0 = Sunday, 1 = Monday, ..., 6 = Saturday.
  static const List<int> _segmentByWeekday = [
    7, // Sunday
    6, // Monday
    5, // Tuesday
    4, // Wednesday
    3, // Thursday
    2, // Friday
    1, // Saturday
  ];

  /// Calculates the Kuligai Kaal window for a given day.
  ///
  /// [sunrise] and [sunset] define the daylight period.
  /// [weekday] is 0=Sunday through 6=Saturday.
  ///
  /// Throws [ArgumentError] if weekday is out of range or sunset is
  /// not after sunrise.
  static KuligaiKaalResult calculate({
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

    return KuligaiKaalResult(start: start, end: end, weekday: weekday);
  }
}
