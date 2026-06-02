import 'dart:math';

/// Result of a sunrise/sunset calculation.
class SunriseSunsetResult {
  const SunriseSunsetResult({
    required this.sunrise,
    required this.sunset,
    required this.daylightDuration,
  });

  /// The sunrise time as a [DateTime] in the local timezone of the input date.
  final DateTime sunrise;

  /// The sunset time as a [DateTime] in the local timezone of the input date.
  final DateTime sunset;

  /// Total daylight duration.
  final Duration daylightDuration;
}

/// Calculates sunrise and sunset times using the NOAA Solar Position algorithm.
///
/// This is a pure Dart implementation with zero network dependency.
/// Based on the NOAA Solar Calculator spreadsheet algorithms.
///
/// Reference: https://gml.noaa.gov/grad/solcalc/solareqns.PDF
class SunriseCalculator {
  const SunriseCalculator._();

  static const double _zenith = 90.833; // Official zenith for sunrise/sunset
  static const double _degreesToRadians = pi / 180;
  static const double _radiansToDegrees = 180 / pi;

  /// Calculates sunrise and sunset for a given [date], [latitude], and
  /// [longitude].
  ///
  /// [latitude] must be between -90 and 90.
  /// [longitude] must be between -180 and 180.
  /// [utcOffset] is the timezone offset in hours (e.g., 5.5 for IST).
  ///
  /// Throws [ArgumentError] if coordinates are out of range.
  /// Returns `null` if the sun never rises or never sets at the given
  /// location/date (polar day/night).
  static SunriseSunsetResult? calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    required double utcOffset,
  }) {
    _validateCoordinates(latitude, longitude);

    final dayOfYear = _dayOfYear(date);
    final sunriseTime = _calculateSunTime(
      dayOfYear: dayOfYear,
      latitude: latitude,
      longitude: longitude,
      utcOffset: utcOffset,
      isSunrise: true,
    );
    final sunsetTime = _calculateSunTime(
      dayOfYear: dayOfYear,
      latitude: latitude,
      longitude: longitude,
      utcOffset: utcOffset,
      isSunrise: false,
    );

    if (sunriseTime == null || sunsetTime == null) {
      return null; // Polar day or polar night
    }

    final sunrise = _minutesToDateTime(date, sunriseTime);
    final sunset = _minutesToDateTime(date, sunsetTime);
    final daylightDuration = sunset.difference(sunrise);

    return SunriseSunsetResult(
      sunrise: sunrise,
      sunset: sunset,
      daylightDuration: daylightDuration,
    );
  }

  static void _validateCoordinates(double latitude, double longitude) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError.value(
        latitude,
        'latitude',
        'Must be between -90 and 90',
      );
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError.value(
        longitude,
        'longitude',
        'Must be between -180 and 180',
      );
    }
  }

  /// Returns the day of year (1–366) for the given date.
  static int _dayOfYear(DateTime date) {
    final startOfYear = DateTime(date.year);
    return date.difference(startOfYear).inDays + 1;
  }

  /// Core NOAA calculation returning time in minutes from midnight (local).
  ///
  /// Returns `null` if the sun doesn't rise/set (polar conditions).
  static double? _calculateSunTime({
    required int dayOfYear,
    required double latitude,
    required double longitude,
    required double utcOffset,
    required bool isSunrise,
  }) {
    // 1. Calculate the approximate time
    final lngHour = longitude / 15;
    final t = isSunrise
        ? dayOfYear + ((6 - lngHour) / 24)
        : dayOfYear + ((18 - lngHour) / 24);

    // 2. Sun's mean anomaly
    final meanAnomaly = (0.9856 * t) - 3.289;

    // 3. Sun's true longitude
    var trueLongitude =
        meanAnomaly +
        (1.916 * sin(meanAnomaly * _degreesToRadians)) +
        (0.020 * sin(2 * meanAnomaly * _degreesToRadians)) +
        282.634;
    trueLongitude = _normalizeDegrees(trueLongitude);

    // 4. Sun's right ascension
    var rightAscension =
        atan(0.91764 * tan(trueLongitude * _degreesToRadians)) *
        _radiansToDegrees;
    rightAscension = _normalizeDegrees(rightAscension);

    // Right ascension needs to be in the same quadrant as true longitude
    final lQuadrant = (trueLongitude / 90).floor() * 90;
    final raQuadrant = (rightAscension / 90).floor() * 90;
    rightAscension = rightAscension + (lQuadrant - raQuadrant);

    // Convert to hours
    rightAscension = rightAscension / 15;

    // 5. Sun's declination
    final sinDec = 0.39782 * sin(trueLongitude * _degreesToRadians);
    final cosDec = cos(asin(sinDec));

    // 6. Sun's local hour angle
    final cosH =
        (cos(_zenith * _degreesToRadians) -
            (sinDec * sin(latitude * _degreesToRadians))) /
        (cosDec * cos(latitude * _degreesToRadians));

    // Check for polar conditions
    if (cosH > 1) return null; // Sun never rises (polar night)
    if (cosH < -1) return null; // Sun never sets (polar day)

    // 7. Calculate H
    final h = isSunrise
        ? 360 - (acos(cosH) * _radiansToDegrees)
        : acos(cosH) * _radiansToDegrees;
    final hHours = h / 15;

    // 8. Local mean time of rising/setting
    final localMeanTime = hHours + rightAscension - (0.06571 * t) - 6.622;

    // 9. Adjust to UTC
    var utcTime = localMeanTime - lngHour;
    utcTime = _normalizeHours(utcTime);

    // 10. Convert to local time
    final localTime = utcTime + utcOffset;
    return _normalizeHours(localTime) * 60; // Return minutes from midnight
  }

  /// Normalize degrees to 0–360 range.
  static double _normalizeDegrees(double degrees) {
    var result = degrees % 360;
    if (result < 0) result += 360;
    return result;
  }

  /// Normalize hours to 0–24 range.
  static double _normalizeHours(double hours) {
    var result = hours % 24;
    if (result < 0) result += 24;
    return result;
  }

  /// Converts minutes from midnight to a [DateTime].
  static DateTime _minutesToDateTime(DateTime date, double minutes) {
    final totalMinutes = minutes.round();
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
