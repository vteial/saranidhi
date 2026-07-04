import 'package:saranidhi/features/astro_engine/domain/lahiri_ayanamsa.dart';
import 'package:saranidhi/features/astro_engine/domain/moon_longitude_calculator.dart';

/// The 27 Nakshatras in sidereal order, starting from Ashwini (0° Aries).
/// Each nakshatra spans exactly 13°20' (13.3333°) of sidereal longitude.
enum Nakshatra {
  ashwini,
  bharani,
  krittika,
  rohini,
  mrigashira,
  ardra,
  punarvasu,
  pushya,
  ashlesha,
  magha,
  purvaPhalguni,
  uttaraPhalguni,
  hasta,
  chitra,
  swati,
  vishakha,
  anuradha,
  jyeshtha,
  mula,
  purvaAshadha,
  uttaraAshadha,
  shravana,
  dhanishta,
  shatabhisha,
  purvaBhadrapada,
  uttaraBhadrapada,
  revati;

  /// The standard English name used in the existing nakshatra-to-bird mapping.
  /// Must match the string keys in `PakshiCalculator._*Nakshatras` sets.
  String get standardName => switch (this) {
    Nakshatra.ashwini => 'ashwini',
    Nakshatra.bharani => 'bharani',
    Nakshatra.krittika => 'krittika',
    Nakshatra.rohini => 'rohini',
    Nakshatra.mrigashira => 'mrigashira',
    Nakshatra.ardra => 'ardra',
    Nakshatra.punarvasu => 'punarvasu',
    Nakshatra.pushya => 'pushya',
    Nakshatra.ashlesha => 'ashlesha',
    Nakshatra.magha => 'magha',
    Nakshatra.purvaPhalguni => 'purva phalguni',
    Nakshatra.uttaraPhalguni => 'uttara phalguni',
    Nakshatra.hasta => 'hasta',
    Nakshatra.chitra => 'chitra',
    Nakshatra.swati => 'swati',
    Nakshatra.vishakha => 'vishakha',
    Nakshatra.anuradha => 'anuradha',
    Nakshatra.jyeshtha => 'jyeshtha',
    Nakshatra.mula => 'mula',
    Nakshatra.purvaAshadha => 'purva ashadha',
    Nakshatra.uttaraAshadha => 'uttara ashadha',
    Nakshatra.shravana => 'shravana',
    Nakshatra.dhanishta => 'dhanishta',
    Nakshatra.shatabhisha => 'shatabhisha',
    Nakshatra.purvaBhadrapada => 'purva bhadrapada',
    Nakshatra.uttaraBhadrapada => 'uttara bhadrapada',
    Nakshatra.revati => 'revati',
  };

  /// Display name in title case.
  String get displayName => switch (this) {
    Nakshatra.ashwini => 'Ashwini',
    Nakshatra.bharani => 'Bharani',
    Nakshatra.krittika => 'Krittika',
    Nakshatra.rohini => 'Rohini',
    Nakshatra.mrigashira => 'Mrigashira',
    Nakshatra.ardra => 'Ardra',
    Nakshatra.punarvasu => 'Punarvasu',
    Nakshatra.pushya => 'Pushya',
    Nakshatra.ashlesha => 'Ashlesha',
    Nakshatra.magha => 'Magha',
    Nakshatra.purvaPhalguni => 'Purva Phalguni',
    Nakshatra.uttaraPhalguni => 'Uttara Phalguni',
    Nakshatra.hasta => 'Hasta',
    Nakshatra.chitra => 'Chitra',
    Nakshatra.swati => 'Swati',
    Nakshatra.vishakha => 'Vishakha',
    Nakshatra.anuradha => 'Anuradha',
    Nakshatra.jyeshtha => 'Jyeshtha',
    Nakshatra.mula => 'Mula',
    Nakshatra.purvaAshadha => 'Purva Ashadha',
    Nakshatra.uttaraAshadha => 'Uttara Ashadha',
    Nakshatra.shravana => 'Shravana',
    Nakshatra.dhanishta => 'Dhanishta',
    Nakshatra.shatabhisha => 'Shatabhisha',
    Nakshatra.purvaBhadrapada => 'Purva Bhadrapada',
    Nakshatra.uttaraBhadrapada => 'Uttara Bhadrapada',
    Nakshatra.revati => 'Revati',
  };

  /// Starting sidereal longitude of this nakshatra in degrees.
  double get startDegree => index * _nakshatraSpan;

  /// Ending sidereal longitude of this nakshatra in degrees.
  double get endDegree => (index + 1) * _nakshatraSpan;

  /// Span of each nakshatra in degrees (13°20' = 13.3333°).
  static const double _nakshatraSpan = 360.0 / 27;
}

/// Result of a nakshatra calculation from date of birth.
class NakshatraResult {
  const NakshatraResult({
    required this.nakshatra,
    required this.nakshatraIndex,
    required this.siderealLongitude,
    required this.tropicalLongitude,
    required this.ayanamsa,
    required this.positionInNakshatra,
    required this.isNearBoundary,
  });

  /// The determined nakshatra.
  final Nakshatra nakshatra;

  /// Zero-based index (0 = Ashwini, 26 = Revati).
  final int nakshatraIndex;

  /// Moon's sidereal ecliptic longitude (0–360°).
  final double siderealLongitude;

  /// Moon's tropical ecliptic longitude (0–360°).
  final double tropicalLongitude;

  /// The Lahiri Ayanamsa value used for this calculation.
  final double ayanamsa;

  /// Position within the nakshatra as a fraction (0.0 = start, 1.0 = end).
  final double positionInNakshatra;

  /// Whether the Moon is within 0.5° of a nakshatra boundary.
  /// When true, the birth time accuracy is critical for correct determination.
  final bool isNearBoundary;

  /// The standard nakshatra name string (for use with PakshiCalculator).
  String get standardName => nakshatra.standardName;

  /// The display name (title case).
  String get displayName => nakshatra.displayName;
}

/// Calculates the birth nakshatra from date of birth using astronomical
/// algorithms.
///
/// Pipeline:
/// 1. Moon tropical longitude (ELP 2000/82 via [MoonLongitudeCalculator])
/// 2. Lahiri Ayanamsa correction (via [LahiriAyanamsa])
/// 3. Sidereal longitude → Nakshatra index (each spans 13°20')
///
/// This is a pure Dart implementation with zero network dependency.
///
/// **Accuracy considerations:**
/// - Moon position: ~10 arc-seconds (~0.003°)
/// - Ayanamsa: ~1 arc-second
/// - Total: well within a nakshatra's 13.33° span
/// - Near-boundary warning when within 0.5° of edge (birth time critical)
class NakshatraCalculator {
  const NakshatraCalculator._();

  /// Width of each nakshatra in degrees (360° / 27 = 13°20' = 13.3333°).
  static const double nakshatraSpan = 360.0 / 27;

  /// Boundary warning threshold in degrees.
  /// If Moon is within this distance of a nakshatra boundary,
  /// the result is flagged as [NakshatraResult.isNearBoundary].
  static const double boundaryThreshold = 0.5;

  /// Calculates the birth nakshatra from a date/time of birth.
  ///
  /// [dateOfBirth] should include the time component for accuracy.
  /// UTC is preferred; if local time is provided, results may be off
  /// by up to ~6° (Moon moves ~0.5°/hour).
  ///
  /// Returns a [NakshatraResult] with the nakshatra, sidereal longitude,
  /// and boundary warning flag.
  static NakshatraResult calculate(DateTime dateOfBirth) {
    // Step 1: Get tropical Moon longitude at birth time
    final moonResult = MoonLongitudeCalculator.calculate(dateOfBirth.toUtc());
    final tropicalLongitude = moonResult.longitude;

    // Step 2: Get Lahiri Ayanamsa for the birth date
    final ayanamsa = LahiriAyanamsa.forDate(dateOfBirth);

    // Step 3: Calculate sidereal longitude
    var siderealLongitude = tropicalLongitude - ayanamsa;
    if (siderealLongitude < 0) siderealLongitude += 360;
    if (siderealLongitude >= 360) siderealLongitude -= 360;

    // Step 4: Determine nakshatra index (0–26)
    final nakshatraIndex = (siderealLongitude / nakshatraSpan).floor();
    final clampedIndex = nakshatraIndex.clamp(0, 26);

    // Step 5: Calculate position within nakshatra (0.0 to 1.0)
    final nakshatraStart = clampedIndex * nakshatraSpan;
    final positionInNakshatra =
        (siderealLongitude - nakshatraStart) / nakshatraSpan;

    // Step 6: Check if near a boundary
    final distanceToStart = siderealLongitude - nakshatraStart;
    final distanceToEnd = nakshatraSpan - distanceToStart;
    final isNearBoundary =
        distanceToStart < boundaryThreshold ||
        distanceToEnd < boundaryThreshold;

    return NakshatraResult(
      nakshatra: Nakshatra.values[clampedIndex],
      nakshatraIndex: clampedIndex,
      siderealLongitude: siderealLongitude,
      tropicalLongitude: tropicalLongitude,
      ayanamsa: ayanamsa,
      positionInNakshatra: positionInNakshatra,
      isNearBoundary: isNearBoundary,
    );
  }

  /// Convenience method: returns just the nakshatra name string
  /// (compatible with `PakshiCalculator.birthBirdFromNakshatra`).
  static String nakshatraNameForDOB(DateTime dateOfBirth) {
    return calculate(dateOfBirth).standardName;
  }

  /// Converts a sidereal longitude to its nakshatra index (0–26).
  ///
  /// Useful when you already have the sidereal longitude from another source.
  static int indexFromSiderealLongitude(double siderealLongitude) {
    var normalized = siderealLongitude % 360;
    if (normalized < 0) normalized += 360;
    return (normalized / nakshatraSpan).floor().clamp(0, 26);
  }

  /// Returns the Nakshatra enum for a given sidereal longitude.
  static Nakshatra fromSiderealLongitude(double siderealLongitude) {
    return Nakshatra.values[indexFromSiderealLongitude(siderealLongitude)];
  }
}
