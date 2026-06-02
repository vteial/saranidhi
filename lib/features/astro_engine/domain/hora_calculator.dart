/// The 7 classical planets in Chaldean order (slowest to fastest orbit).
enum HoraPlanet {
  saturn,
  jupiter,
  mars,
  sun,
  venus,
  mercury,
  moon;

  /// Display name with first letter capitalized.
  String get displayName => name[0].toUpperCase() + name.substring(1);
}

/// Result of a Hora calculation for a specific time.
class HoraResult {
  const HoraResult({
    required this.planet,
    required this.horaIndex,
    required this.start,
    required this.end,
    required this.isDayHora,
  });

  /// The ruling planet for this hora.
  final HoraPlanet planet;

  /// 0-based index of the hora within the day (0–11) or night (0–11).
  final int horaIndex;

  /// Start time of this hora.
  final DateTime start;

  /// End time of this hora.
  final DateTime end;

  /// Whether this is a daytime hora (true) or nighttime hora (false).
  final bool isDayHora;

  /// Duration of this hora.
  Duration get duration => end.difference(start);
}

/// Calculates Planetary Hours (Horas) using the Chaldean order.
///
/// The day (sunrise to sunset) is divided into 12 equal Horas.
/// The night (sunset to next sunrise) is divided into 12 equal Horas.
///
/// The first hora of the day is ruled by the lord of the weekday:
/// - Sunday → Sun
/// - Monday → Moon
/// - Tuesday → Mars
/// - Wednesday → Mercury
/// - Thursday → Jupiter
/// - Friday → Venus
/// - Saturday → Saturn
///
/// Subsequent horas follow the Chaldean sequence:
/// Saturn → Jupiter → Mars → Sun → Venus → Mercury → Moon → (repeat)
class HoraCalculator {
  const HoraCalculator._();

  /// The day lord for each weekday (0=Sunday..6=Saturday).
  static const List<HoraPlanet> _dayLords = [
    HoraPlanet.sun, // Sunday
    HoraPlanet.moon, // Monday
    HoraPlanet.mars, // Tuesday
    HoraPlanet.mercury, // Wednesday
    HoraPlanet.jupiter, // Thursday
    HoraPlanet.venus, // Friday
    HoraPlanet.saturn, // Saturday
  ];

  /// Chaldean order of planets (used for cycling through horas).
  static const List<HoraPlanet> _chaldeanOrder = [
    HoraPlanet.saturn,
    HoraPlanet.jupiter,
    HoraPlanet.mars,
    HoraPlanet.sun,
    HoraPlanet.venus,
    HoraPlanet.mercury,
    HoraPlanet.moon,
  ];

  /// Returns all 12 day horas from [sunrise] to [sunset] for the given
  /// [weekday] (0=Sunday..6=Saturday).
  static List<HoraResult> calculateDayHoras({
    required DateTime sunrise,
    required DateTime sunset,
    required int weekday,
  }) {
    _validateInputs(sunrise, sunset, weekday);

    final totalMs = sunset.difference(sunrise).inMilliseconds;
    final horaDurationMs = totalMs ~/ 12;
    final startPlanet = _dayLords[weekday];
    final startIndex = _chaldeanOrder.indexOf(startPlanet);

    return List.generate(12, (i) {
      final planetIndex = (startIndex + i) % 7;
      final start = sunrise.add(Duration(milliseconds: horaDurationMs * i));
      final end = (i == 11)
          ? sunset
          : sunrise.add(Duration(milliseconds: horaDurationMs * (i + 1)));

      return HoraResult(
        planet: _chaldeanOrder[planetIndex],
        horaIndex: i,
        start: start,
        end: end,
        isDayHora: true,
      );
    });
  }

  /// Returns all 12 night horas from [sunset] to [nextSunrise] for the
  /// given [weekday] (0=Sunday..6=Saturday).
  ///
  /// Night horas continue the Chaldean sequence from where day horas ended
  /// (i.e., starting at the 13th planet in sequence from the day lord).
  static List<HoraResult> calculateNightHoras({
    required DateTime sunset,
    required DateTime nextSunrise,
    required int weekday,
  }) {
    if (!nextSunrise.isAfter(sunset)) {
      throw ArgumentError('nextSunrise must be after sunset');
    }
    if (weekday < 0 || weekday > 6) {
      throw ArgumentError.value(
        weekday,
        'weekday',
        'Must be 0 (Sunday) through 6 (Saturday)',
      );
    }

    final totalMs = nextSunrise.difference(sunset).inMilliseconds;
    final horaDurationMs = totalMs ~/ 12;

    // Night starts at hora 13 from day lord (index 12 since 0-based offset)
    final dayLordIndex = _chaldeanOrder.indexOf(_dayLords[weekday]);
    final nightStartIndex = (dayLordIndex + 12) % 7;

    return List.generate(12, (i) {
      final planetIndex = (nightStartIndex + i) % 7;
      final start = sunset.add(Duration(milliseconds: horaDurationMs * i));
      final end = (i == 11)
          ? nextSunrise
          : sunset.add(Duration(milliseconds: horaDurationMs * (i + 1)));

      return HoraResult(
        planet: _chaldeanOrder[planetIndex],
        horaIndex: i,
        start: start,
        end: end,
        isDayHora: false,
      );
    });
  }

  /// Returns the active [HoraResult] for a given [time] within a day.
  ///
  /// Checks day horas first, then night horas.
  /// Returns `null` if time doesn't fall in either range (shouldn't happen
  /// if sunrise/sunset/nextSunrise cover a full 24h cycle).
  static HoraResult? activeHora({
    required DateTime time,
    required DateTime sunrise,
    required DateTime sunset,
    required DateTime nextSunrise,
    required int weekday,
  }) {
    // Check day horas
    if (!time.isBefore(sunrise) && time.isBefore(sunset)) {
      final dayHoras = calculateDayHoras(
        sunrise: sunrise,
        sunset: sunset,
        weekday: weekday,
      );
      for (final hora in dayHoras) {
        if (!time.isBefore(hora.start) && time.isBefore(hora.end)) {
          return hora;
        }
      }
    }

    // Check night horas
    if (!time.isBefore(sunset) && time.isBefore(nextSunrise)) {
      final nightHoras = calculateNightHoras(
        sunset: sunset,
        nextSunrise: nextSunrise,
        weekday: weekday,
      );
      for (final hora in nightHoras) {
        if (!time.isBefore(hora.start) && time.isBefore(hora.end)) {
          return hora;
        }
      }
    }

    return null;
  }

  static void _validateInputs(DateTime sunrise, DateTime sunset, int weekday) {
    if (!sunset.isAfter(sunrise)) {
      throw ArgumentError('sunset must be after sunrise');
    }
    if (weekday < 0 || weekday > 6) {
      throw ArgumentError.value(
        weekday,
        'weekday',
        'Must be 0 (Sunday) through 6 (Saturday)',
      );
    }
  }
}
