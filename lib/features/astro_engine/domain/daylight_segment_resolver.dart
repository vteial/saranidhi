/// Resolves the current daylight segment index (1 to 8) for inauspicious
/// window checks.
///
/// Divides daylight (sunrise->sunset) into 8 equal octants and determines
/// which segment the current time falls into. Used by the Oracle engine
/// to check Rahu Kaal and Emakandam without re-instantiating separate
/// calculator classes.
///
/// Returns segment 0 if the time is outside daylight hours (nighttime).
class DaylightSegmentResolver {
  const DaylightSegmentResolver._(this.activeSegment);

  /// Resolves which daylight octant the [currentTime] falls into.
  factory DaylightSegmentResolver.resolve({
    required DateTime currentTime,
    required DateTime sunrise,
    required DateTime sunset,
  }) {
    if (currentTime.isBefore(sunrise) || !currentTime.isBefore(sunset)) {
      return const DaylightSegmentResolver._(0);
    }

    final totalMs = sunset.difference(sunrise).inMilliseconds;
    final elapsedMs = currentTime.difference(sunrise).inMilliseconds;
    final segmentMs = totalMs / 8;

    final index = (elapsedMs / segmentMs).floor() + 1;
    return DaylightSegmentResolver._(index.clamp(1, 8));
  }

  /// The active segment index (1-8), or 0 if nighttime.
  final int activeSegment;

  /// Whether the current time is during daytime (within a valid segment).
  bool get isDaytime => activeSegment > 0;

  /// Whether the current segment is Rahu Kaal for the given [weekday].
  /// Weekday: 0=Sunday through 6=Saturday.
  bool isRahuKaal(int weekday) {
    if (activeSegment == 0) return false;
    const lookup = [8, 2, 7, 5, 6, 4, 3];
    return activeSegment == lookup[weekday];
  }

  /// Whether the current segment is Emakandam for the given [weekday].
  bool isEmakandam(int weekday) {
    if (activeSegment == 0) return false;
    const lookup = [5, 4, 3, 2, 1, 7, 6];
    return activeSegment == lookup[weekday];
  }

  /// Whether the current segment is Kuligai Kaal for the given [weekday].
  /// Note: Kuligai is NOT included in inauspicious lockout (traditionally
  /// auspicious for growth/accumulation).
  bool isKuligai(int weekday) {
    if (activeSegment == 0) return false;
    const lookup = [7, 6, 5, 4, 3, 2, 1];
    return activeSegment == lookup[weekday];
  }
}
