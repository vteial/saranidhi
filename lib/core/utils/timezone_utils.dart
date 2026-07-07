/// Utilities for deriving timezone offset from geographic coordinates.
///
/// Uses longitude-based approximation: UTC offset ≈ longitude / 15.
/// This is sufficient for sunrise/sunset calculations where ±30 min
/// accuracy is acceptable. For precise civil timezone (DST, political
/// boundaries), a full timezone database would be needed.
class TimezoneUtils {
  const TimezoneUtils._();

  /// Derives an approximate UTC offset (in hours) from longitude.
  ///
  /// Formula: offset = longitude / 15, rounded to nearest 0.5.
  /// Examples:
  ///   - Chennai (80.27°) → 5.5 (IST)
  ///   - Mumbai (72.88°) → 5.0 (close to IST, rounds to 5.0)
  ///   - London (0°) → 0.0 (GMT)
  ///   - New York (-74°) → -5.0 (EST)
  ///
  /// For Indian cities (our primary use case), this naturally produces
  /// offsets close to IST (+5.5). The rounding to 0.5 ensures we land
  /// on standard timezone boundaries.
  static double offsetFromLongitude(double longitude) {
    final raw = longitude / 15.0;
    // Round to nearest 0.5
    return (raw * 2).round() / 2;
  }

  /// Returns the UTC offset for a known Indian location.
  ///
  /// All Indian cities use IST (+5:30 = 5.5).
  /// For non-Indian locations, falls back to longitude-based derivation.
  static double offsetForLocation({
    required double latitude,
    required double longitude,
  }) {
    // India bounding box: lat 6°–36°, lng 68°–98°
    if (latitude >= 6.0 &&
        latitude <= 36.0 &&
        longitude >= 68.0 &&
        longitude <= 98.0) {
      return 5.5; // IST — all of India uses single timezone
    }
    return offsetFromLongitude(longitude);
  }
}
