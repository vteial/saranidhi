/// Non-web stub for [WebGeolocation].
///
/// On mobile/desktop there is no `navigator.geolocation`, so this stub
/// always returns null. The real implementation (web_geolocation.dart)
/// is selected via conditional import on web builds.
library;

/// Simple position data class (mirrors the web implementation).
class GeolocationPosition {
  const GeolocationPosition({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  final double latitude;
  final double longitude;
  final double accuracy;
}

/// Stub geolocation service — always returns null (no browser API).
class WebGeolocation {
  const WebGeolocation._();

  /// Always returns null on non-web platforms.
  static Future<GeolocationPosition?> getCurrentPosition() async => null;
}
