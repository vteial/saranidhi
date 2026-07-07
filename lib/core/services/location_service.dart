import 'dart:math';

import 'package:flutter/foundation.dart';

/// Lightweight location service for dynamic location updates.
///
/// On mobile (iOS/Android): Uses platform-specific GPS via a simple
/// MethodChannel approach (avoiding heavy geolocator package).
/// On web: Falls back to profile city (no GPS available).
///
/// For Sprint 27, we use a simplified approach:
/// - The app checks location on open via the native GPS APIs
/// - If moved >50km from stored profile location, updates profile
/// - Web platform silently uses the stored profile location
class LocationService {
  const LocationService._();

  /// Haversine distance between two lat/lng points in kilometers.
  static double distanceKm({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Whether the distance between two points exceeds the threshold.
  ///
  /// Default threshold: 50km (significant enough to affect sunrise/sunset).
  static bool hasMovedSignificantly({
    required double storedLat,
    required double storedLng,
    required double currentLat,
    required double currentLng,
    double thresholdKm = 50.0,
  }) {
    final distance = distanceKm(
      lat1: storedLat,
      lng1: storedLng,
      lat2: currentLat,
      lng2: currentLng,
    );
    return distance > thresholdKm;
  }

  /// Whether GPS is available on the current platform.
  ///
  /// Returns false on web (no GPS API available).
  static bool get isGpsAvailable => !kIsWeb;

  static double _toRadians(double degrees) => degrees * pi / 180;
}
