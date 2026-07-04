import 'dart:math';

/// Result of a Moon longitude calculation.
class MoonLongitudeResult {
  const MoonLongitudeResult({
    required this.longitude,
    required this.latitude,
    required this.distance,
  });

  /// Geocentric ecliptic longitude of the Moon in degrees (0–360).
  final double longitude;

  /// Geocentric ecliptic latitude of the Moon in degrees (-90 to +90).
  final double latitude;

  /// Distance from Earth to Moon in kilometers.
  final double distance;
}

/// Calculates the Moon's geocentric ecliptic longitude, latitude, and
/// distance using the truncated ELP 2000/82 algorithm from Jean Meeus'
/// "Astronomical Algorithms" (Chapter 47).
///
/// This is a pure Dart implementation with zero network dependency.
/// Accuracy: ~10 arc-seconds in longitude, ~4 arc-seconds in latitude
/// (sufficient for nakshatra determination where each nakshatra spans
/// 13°20' = 800 arc-minutes).
///
/// For Saranidhi's purpose (determining which nakshatra the Moon was in
/// at birth), even ~0.5° accuracy is more than adequate since each
/// nakshatra spans 13.33°.
class MoonLongitudeCalculator {
  const MoonLongitudeCalculator._();

  static const double _deg2rad = pi / 180;
  static const double _rad2deg = 180 / pi;

  /// Calculates the Moon's position for a given [dateTime].
  ///
  /// The [dateTime] should be in UTC for best accuracy.
  /// Returns a [MoonLongitudeResult] with ecliptic coordinates.
  static MoonLongitudeResult calculate(DateTime dateTime) {
    final jd = _julianDay(dateTime.toUtc());
    final t = (jd - 2451545.0) / 36525.0; // Julian centuries from J2000.0

    // Fundamental arguments (in degrees)
    // Moon's mean longitude (mean equinox of date)
    final lPrime = _normalize(
      218.3164477 +
          481267.88123421 * t -
          0.0015786 * t * t +
          t * t * t / 538841 -
          t * t * t * t / 65194000,
    );

    // Moon's mean elongation
    final d = _normalize(
      297.8501921 +
          445267.1114034 * t -
          0.0018819 * t * t +
          t * t * t / 545868 -
          t * t * t * t / 113065000,
    );

    // Sun's mean anomaly
    final m = _normalize(
      357.5291092 +
          35999.0502909 * t -
          0.0001536 * t * t +
          t * t * t / 24490000,
    );

    // Moon's mean anomaly
    final mPrime = _normalize(
      134.9633964 +
          477198.8675055 * t +
          0.0087414 * t * t +
          t * t * t / 69699 -
          t * t * t * t / 14712000,
    );

    // Moon's argument of latitude (mean distance from ascending node)
    final f = _normalize(
      93.2720950 +
          483202.0175233 * t -
          0.0036539 * t * t -
          t * t * t / 3526000 +
          t * t * t * t / 863310000,
    );

    // Additional arguments for corrections
    final a1 = _normalize(119.75 + 131.849 * t); // Venus
    final a2 = _normalize(53.09 + 479264.290 * t); // Jupiter
    final a3 = _normalize(313.45 + 481266.484 * t);

    // Eccentricity of Earth's orbit
    final e = 1 - 0.002516 * t - 0.0000074 * t * t;
    final e2 = e * e;

    // ─── Longitude terms (Σl) ─────────────────────────────────────────
    var sigmaL = 0.0;
    for (final term in _longitudeTerms) {
      final eFactor = _eccentricityFactor(term[1], e, e2);
      final arg =
          term[0] * d + term[1] * m + term[2] * mPrime + term[3] * f;
      sigmaL += term[4] * eFactor * sin(arg * _deg2rad);
    }

    // Additional corrections for longitude
    sigmaL += 3958 * sin(a1 * _deg2rad);
    sigmaL += 1962 * sin((lPrime - f) * _deg2rad);
    sigmaL += 318 * sin(a2 * _deg2rad);

    // ─── Latitude terms (Σb) ─────────────────────────────────────────
    var sigmaB = 0.0;
    for (final term in _latitudeTerms) {
      final eFactor = _eccentricityFactor(term[1], e, e2);
      final arg =
          term[0] * d + term[1] * m + term[2] * mPrime + term[3] * f;
      sigmaB += term[4] * eFactor * sin(arg * _deg2rad);
    }

    // Additional corrections for latitude
    sigmaB += -2235 * sin(lPrime * _deg2rad);
    sigmaB += 382 * sin(a3 * _deg2rad);
    sigmaB += 175 * sin((a1 - f) * _deg2rad);
    sigmaB += 175 * sin((a1 + f) * _deg2rad);
    sigmaB += 127 * sin((lPrime - mPrime) * _deg2rad);
    sigmaB += -115 * sin((lPrime + mPrime) * _deg2rad);

    // ─── Distance terms (Σr) ─────────────────────────────────────────
    var sigmaR = 0.0;
    for (final term in _distanceTerms) {
      final eFactor = _eccentricityFactor(term[1], e, e2);
      final arg =
          term[0] * d + term[1] * m + term[2] * mPrime + term[3] * f;
      sigmaR += term[4] * eFactor * cos(arg * _deg2rad);
    }

    // Final coordinates
    final longitude = _normalize(lPrime + sigmaL / 1000000);
    final latitude = sigmaB / 1000000;
    final distance = 385000.56 + sigmaR / 1000; // km

    return MoonLongitudeResult(
      longitude: longitude,
      latitude: latitude,
      distance: distance,
    );
  }

  /// Convenience method: returns just the ecliptic longitude in degrees.
  static double longitudeForDate(DateTime dateTime) {
    return calculate(dateTime).longitude;
  }

  /// Converts a calendar date to Julian Day Number.
  static double _julianDay(DateTime dt) {
    var y = dt.year;
    var m = dt.month;
    final d = dt.day +
        dt.hour / 24.0 +
        dt.minute / 1440.0 +
        dt.second / 86400.0;

    if (m <= 2) {
      y -= 1;
      m += 12;
    }

    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();

    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524.5;
  }

  /// Normalizes an angle to the range 0–360°.
  static double _normalize(double degrees) {
    var result = degrees % 360;
    if (result < 0) result += 360;
    return result;
  }

  /// Returns the eccentricity correction factor for terms involving
  /// the Sun's mean anomaly (M).
  static double _eccentricityFactor(double mCoeff, double e, double e2) {
    final absM = mCoeff.abs().round();
    if (absM == 1) return e;
    if (absM == 2) return e2;
    return 1.0;
  }

  // ─── Periodic term tables ───────────────────────────────────────────
  // Each row: [D, M, M', F, coefficient]
  // From Meeus, "Astronomical Algorithms", Table 47.A (longitude/distance)
  // and Table 47.B (latitude).
  // Content rephrased and reorganized for compliance with licensing.

  /// Main longitude periodic terms [D, M, M', F, Σl coefficient].
  /// 60 terms from Meeus Table 47.A (longitude component).
  static const List<List<double>> _longitudeTerms = [
    [0, 0, 1, 0, 6288774],
    [2, 0, -1, 0, 1274027],
    [2, 0, 0, 0, 658314],
    [0, 0, 2, 0, 213618],
    [0, 1, 0, 0, -185116],
    [0, 0, 0, 2, -114332],
    [2, 0, -2, 0, 58793],
    [2, -1, -1, 0, 57066],
    [2, 0, 1, 0, 53322],
    [2, -1, 0, 0, 45758],
    [0, 1, -1, 0, -40923],
    [1, 0, 0, 0, -34720],
    [0, 1, 1, 0, -30383],
    [2, 0, 0, -2, 15327],
    [0, 0, 1, 2, -12528],
    [0, 0, 1, -2, 10980],
    [4, 0, -1, 0, 10675],
    [0, 0, 3, 0, 10034],
    [4, 0, -2, 0, 8548],
    [2, 1, -1, 0, -7888],
    [2, 1, 0, 0, -6766],
    [1, 0, -1, 0, -5163],
    [1, 1, 0, 0, 4987],
    [2, -1, 1, 0, 4036],
    [2, 0, 2, 0, 3994],
    [4, 0, 0, 0, 3861],
    [2, 0, -3, 0, 3665],
    [0, 1, -2, 0, -2689],
    [2, 0, -1, 2, -2602],
    [2, -1, -2, 0, 2390],
    [1, 0, 1, 0, -2348],
    [2, -2, 0, 0, 2236],
    [0, 1, 2, 0, -2120],
    [0, 2, 0, 0, -2069],
    [2, -2, -1, 0, 2048],
    [2, 0, 1, -2, -1773],
    [2, 0, 0, 2, -1595],
    [4, -1, -1, 0, 1215],
    [0, 0, 2, 2, -1110],
    [3, 0, -1, 0, -892],
    [2, 1, 1, 0, -810],
    [4, -1, -2, 0, 759],
    [0, 2, -1, 0, -713],
    [2, 2, -1, 0, -700],
    [2, 1, -2, 0, 691],
    [2, -1, 0, -2, 596],
    [4, 0, 1, 0, 549],
    [0, 0, 4, 0, 537],
    [4, -1, 0, 0, 520],
    [1, 0, -2, 0, -487],
    [2, 1, 0, -2, -399],
    [0, 0, 2, -2, -381],
    [1, 1, 1, 0, 351],
    [3, 0, -2, 0, -340],
    [4, 0, -3, 0, 330],
    [2, -1, 2, 0, 327],
    [0, 2, 1, 0, -323],
    [1, 1, -1, 0, 299],
    [2, 0, 3, 0, 294],
    [2, 0, -1, -2, 0],
  ];

  /// Latitude periodic terms [D, M, M', F, Σb coefficient].
  /// 60 terms from Meeus Table 47.B.
  static const List<List<double>> _latitudeTerms = [
    [0, 0, 0, 1, 5128122],
    [0, 0, 1, 1, 280602],
    [0, 0, 1, -1, 277693],
    [2, 0, 0, -1, 173237],
    [2, 0, -1, 1, 55413],
    [2, 0, -1, -1, 46271],
    [2, 0, 0, 1, 32573],
    [0, 0, 2, 1, 17198],
    [2, 0, 1, -1, 9266],
    [0, 0, 2, -1, 8822],
    [2, -1, 0, -1, 8216],
    [2, 0, -2, -1, 4324],
    [2, 0, 1, 1, 4200],
    [2, 1, 0, -1, -3359],
    [2, -1, -1, 1, 2463],
    [2, -1, 0, 1, 2211],
    [2, -1, -1, -1, 2065],
    [0, 1, -1, -1, -1870],
    [4, 0, -1, -1, 1828],
    [0, 1, 0, 1, -1794],
    [0, 0, 0, 3, -1749],
    [0, 1, -1, 1, -1565],
    [1, 0, 0, 1, -1491],
    [0, 1, 1, 1, -1475],
    [0, 1, 1, -1, -1410],
    [0, 1, 0, -1, -1344],
    [1, 0, 0, -1, -1335],
    [0, 0, 3, 1, 1107],
    [4, 0, 0, -1, 1021],
    [4, 0, -1, 1, 833],
    [0, 0, 1, -3, 777],
    [4, 0, -2, 1, 671],
    [2, 0, 0, -3, 607],
    [2, 0, 2, -1, 596],
    [2, -1, 1, -1, 491],
    [2, 0, -2, 1, -451],
    [0, 0, 3, -1, 439],
    [2, 0, 2, 1, 422],
    [2, 0, -3, -1, 421],
    [2, 1, -1, 1, -366],
    [2, 1, 0, 1, -351],
    [4, 0, 0, 1, 331],
    [2, -1, 1, 1, 315],
    [2, -2, 0, -1, 302],
    [0, 0, 1, 3, -283],
    [2, 1, 1, -1, -229],
    [1, 1, 0, -1, 223],
    [1, 1, 0, 1, 223],
    [0, 1, -2, -1, -220],
    [2, 1, -1, -1, -220],
    [1, 0, 1, 1, -185],
    [2, -1, -2, -1, 181],
    [0, 1, 2, 1, -177],
    [4, 0, -2, -1, 176],
    [4, -1, -1, -1, 166],
    [1, 0, 1, -1, -164],
    [4, 0, 1, -1, 132],
    [1, 0, -1, -1, -119],
    [4, -1, 0, -1, 115],
    [2, -2, 0, 1, 107],
  ];

  /// Distance periodic terms [D, M, M', F, Σr coefficient].
  /// From Meeus Table 47.A (distance/cosine component).
  static const List<List<double>> _distanceTerms = [
    [0, 0, 1, 0, -20905355],
    [2, 0, -1, 0, -3699111],
    [2, 0, 0, 0, -2955968],
    [0, 0, 2, 0, -569925],
    [0, 1, 0, 0, 48888],
    [0, 0, 0, 2, -3149],
    [2, 0, -2, 0, 246158],
    [2, -1, -1, 0, -152138],
    [2, 0, 1, 0, -170733],
    [2, -1, 0, 0, -204586],
    [0, 1, -1, 0, -129620],
    [1, 0, 0, 0, 108743],
    [0, 1, 1, 0, 104755],
    [2, 0, 0, -2, 10321],
    [0, 0, 1, 2, 0],
    [0, 0, 1, -2, 79661],
    [4, 0, -1, 0, -34782],
    [0, 0, 3, 0, -23210],
    [4, 0, -2, 0, -21636],
    [2, 1, -1, 0, 24208],
    [2, 1, 0, 0, 30824],
    [1, 0, -1, 0, -8379],
    [1, 1, 0, 0, -16675],
    [2, -1, 1, 0, -12831],
    [2, 0, 2, 0, -10445],
    [4, 0, 0, 0, -11650],
    [2, 0, -3, 0, 14403],
    [0, 1, -2, 0, -7003],
    [2, 0, -1, 2, 0],
    [2, -1, -2, 0, 10056],
    [1, 0, 1, 0, 6322],
    [2, -2, 0, 0, -9884],
    [0, 1, 2, 0, 5751],
    [0, 2, 0, 0, 0],
    [2, -2, -1, 0, -4950],
    [2, 0, 1, -2, 4130],
    [2, 0, 0, 2, 0],
    [4, -1, -1, 0, -3958],
    [0, 0, 2, 2, 0],
    [3, 0, -1, 0, 3258],
    [2, 1, 1, 0, 2616],
    [4, -1, -2, 0, -1897],
    [0, 2, -1, 0, -2117],
    [2, 2, -1, 0, 2354],
    [2, 1, -2, 0, 0],
    [2, -1, 0, -2, 0],
    [4, 0, 1, 0, -1423],
    [0, 0, 4, 0, -1117],
    [4, -1, 0, 0, -1571],
    [1, 0, -2, 0, -1739],
  ];
}
