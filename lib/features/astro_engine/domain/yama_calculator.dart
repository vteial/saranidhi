/// Represents one of the 5 Night Yamas (time segments from sunset to sunrise).
enum NightYamaIndex {
  yama6,
  yama7,
  yama8,
  yama9,
  yama10;

  /// Human-readable label (6-based).
  String get label => 'Yama ${index + 6}';
}

/// A single Night Yama segment with start and end times.
class NightYamaSegment {
  const NightYamaSegment({
    required this.index,
    required this.start,
    required this.end,
  });

  final NightYamaIndex index;
  final DateTime start;
  final DateTime end;

  /// Duration of this Night Yama.
  Duration get duration => end.difference(start);

  /// Whether the given [time] falls within this Night Yama (inclusive start,
  /// exclusive end).
  bool contains(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }
}

/// Result of the Night Yama calculation.
class NightYamaResult {
  const NightYamaResult({required this.yamas, required this.yamaDuration});

  /// The 5 Night Yama segments.
  final List<NightYamaSegment> yamas;

  /// Duration of each Night Yama (all equal).
  final Duration yamaDuration;

  /// Returns the active [NightYamaSegment] for a given [time], or `null` if
  /// the time is not within any night yama.
  NightYamaSegment? activeYama(DateTime time) {
    for (final yama in yamas) {
      if (yama.contains(time)) return yama;
    }
    return null;
  }
}

/// Represents one of the 5 Yamas (time segments) of daylight.
enum YamaIndex {
  yama1,
  yama2,
  yama3,
  yama4,
  yama5;

  /// Human-readable label (1-based).
  String get label => 'Yama ${index + 1}';
}

/// A single Yama segment with start and end times.
class YamaSegment {
  const YamaSegment({
    required this.index,
    required this.start,
    required this.end,
  });

  final YamaIndex index;
  final DateTime start;
  final DateTime end;

  /// Duration of this Yama.
  Duration get duration => end.difference(start);

  /// Whether the given [time] falls within this Yama (inclusive start,
  /// exclusive end).
  bool contains(DateTime time) {
    return !time.isBefore(start) && time.isBefore(end);
  }
}

/// Result of the Yama calculation for a full day.
class YamaResult {
  const YamaResult({required this.yamas, required this.yamaDuration});

  /// The 5 Yama segments for the day.
  final List<YamaSegment> yamas;

  /// Duration of each Yama (all equal).
  final Duration yamaDuration;

  /// Returns the active [YamaSegment] for a given [time], or `null` if
  /// the time is before sunrise or after sunset.
  YamaSegment? activeYama(DateTime time) {
    for (final yama in yamas) {
      if (yama.contains(time)) return yama;
    }
    return null;
  }
}

/// Calculates the 5 Yamas by dividing daylight (sunrise to sunset)
/// into 5 equal time segments.
///
/// In Sara Kalai tradition, each Yama corresponds to one Panja Pakshi
/// bird activity state.
class YamaCalculator {
  const YamaCalculator._();

  /// Divides daylight from [sunrise] to [sunset] into 5 equal Yamas.
  ///
  /// Throws [ArgumentError] if sunset is not after sunrise.
  static YamaResult calculate({
    required DateTime sunrise,
    required DateTime sunset,
  }) {
    if (!sunset.isAfter(sunrise)) {
      throw ArgumentError('sunset must be after sunrise');
    }

    final totalDaylight = sunset.difference(sunrise);
    final yamaDurationMs = totalDaylight.inMilliseconds ~/ 5;
    final yamaDuration = Duration(milliseconds: yamaDurationMs);

    final yamas = <YamaSegment>[];
    for (var i = 0; i < 5; i++) {
      final start = sunrise.add(Duration(milliseconds: yamaDurationMs * i));
      final end = (i == 4)
          ? sunset // Last yama ends exactly at sunset
          : sunrise.add(Duration(milliseconds: yamaDurationMs * (i + 1)));

      yamas.add(
        YamaSegment(index: YamaIndex.values[i], start: start, end: end),
      );
    }

    return YamaResult(yamas: yamas, yamaDuration: yamaDuration);
  }

  /// Divides nighttime from [sunset] to [nextSunrise] into 5 equal Night Yamas.
  ///
  /// Throws [ArgumentError] if nextSunrise is not after sunset.
  static NightYamaResult calculateNight({
    required DateTime sunset,
    required DateTime nextSunrise,
  }) {
    if (!nextSunrise.isAfter(sunset)) {
      throw ArgumentError('nextSunrise must be after sunset');
    }

    final totalNight = nextSunrise.difference(sunset);
    final yamaDurationMs = totalNight.inMilliseconds ~/ 5;
    final yamaDuration = Duration(milliseconds: yamaDurationMs);

    final yamas = <NightYamaSegment>[];
    for (var i = 0; i < 5; i++) {
      final start = sunset.add(Duration(milliseconds: yamaDurationMs * i));
      final end = (i == 4)
          ? nextSunrise
          : sunset.add(Duration(milliseconds: yamaDurationMs * (i + 1)));

      yamas.add(
        NightYamaSegment(
          index: NightYamaIndex.values[i],
          start: start,
          end: end,
        ),
      );
    }

    return NightYamaResult(yamas: yamas, yamaDuration: yamaDuration);
  }
}
