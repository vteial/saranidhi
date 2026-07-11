/// Result of an Emakandam calculation.
class EmakandamResult {
  const EmakandamResult({
    required this.start,
    required this.end,
    required this.weekday,
  });

  /// Start time of Emakandam.
  final DateTime start;

  /// End time of Emakandam.
  final DateTime end;

  /// The weekday (0=Sunday..6=Saturday) this was calculated for.
  final int weekday;

  /// Duration of the Emakandam window.
  Duration get duration => end.difference(start);

  /// Whether the given [time] falls within Emakandam
  /// (inclusive start, exclusive end).
  bool isActive(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }
}

/// Calculates Emakandam (எமகண்டம்) — the third inauspicious time window.
///
/// Like Rahu Kaal and Kuligai, Emakandam divides daylight into 8 equal
/// segments and selects one based on the weekday:
///
/// | Day       | Segment Index (1-based) |
/// |-----------|------------------------|
/// | Sunday    | 5th                    |
/// | Monday    | 4th                    |
/// | Tuesday   | 3rd                    |
/// | Wednesday | 2nd                    |
/// | Thursday  | 1st                    |
/// | Friday    | 7th                    |
/// | Saturday  | 6th                    |
///
/// Note: The pattern counts down from Sun=5, with Fri=7 and Sat=6.
class EmakandamCalculator {
  const EmakandamCalculator._();

  /// Segment index (1-based) for each weekday.
  /// Index 0 = Sunday, 1 = Monday, ..., 6 = Saturday.
  static const List<int> _segmentByWeekday = [
    5, // Sunday
    4, // Monday
    3, // Tuesday
    2, // Wednesday
    1, // Thursday
    7, // Friday
    6, // Saturday
  ];

  /// Calculates the Emakandam window for a given day.
  ///
  /// [sunrise] and [sunset] define the daylight period.
  /// [weekday] is 0=Sunday through 6=Saturday.
  ///
  /// Throws [ArgumentError] if weekday is out of range or sunset is
  /// not after sunrise.
  static EmakandamResult calculate({
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

    return EmakandamResult(start: start, end: end, weekday: weekday);
  }
}
