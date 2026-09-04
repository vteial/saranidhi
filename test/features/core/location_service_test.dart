import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/services/location_service.dart';

void main() {
  group('LocationService.distanceKm', () {
    test('distance between identical points is zero', () {
      final d = LocationService.distanceKm(
        lat1: 13.08,
        lng1: 80.27,
        lat2: 13.08,
        lng2: 80.27,
      );
      expect(d, closeTo(0, 0.001));
    });

    test('Chennai to Bengaluru is roughly 290 km', () {
      // Chennai (13.08, 80.27) -> Bengaluru (12.97, 77.59)
      final d = LocationService.distanceKm(
        lat1: 13.08,
        lng1: 80.27,
        lat2: 12.97,
        lng2: 77.59,
      );
      // Great-circle distance is ~290 km; allow generous tolerance.
      expect(d, greaterThan(250));
      expect(d, lessThan(320));
    });

    test('distance is symmetric', () {
      final ab = LocationService.distanceKm(
        lat1: 13.08,
        lng1: 80.27,
        lat2: 12.97,
        lng2: 77.59,
      );
      final ba = LocationService.distanceKm(
        lat1: 12.97,
        lng1: 77.59,
        lat2: 13.08,
        lng2: 80.27,
      );
      expect(ab, closeTo(ba, 0.001));
    });

    test('one degree of latitude is roughly 111 km', () {
      final d = LocationService.distanceKm(
        lat1: 0,
        lng1: 0,
        lat2: 1,
        lng2: 0,
      );
      expect(d, closeTo(111.19, 1.0));
    });
  });

  group('LocationService.hasMovedSignificantly', () {
    test('returns false for a small move within default threshold', () {
      // ~11 km apart (0.1 deg lat) — below default 50 km threshold.
      final moved = LocationService.hasMovedSignificantly(
        storedLat: 13.08,
        storedLng: 80.27,
        currentLat: 13.18,
        currentLng: 80.27,
      );
      expect(moved, isFalse);
    });

    test('returns true for a large move beyond default threshold', () {
      // Chennai -> Bengaluru (~290 km) exceeds default 50 km threshold.
      final moved = LocationService.hasMovedSignificantly(
        storedLat: 13.08,
        storedLng: 80.27,
        currentLat: 12.97,
        currentLng: 77.59,
      );
      expect(moved, isTrue);
    });

    test('respects a custom 5 km threshold (used by location-on-open)', () {
      // ~11 km apart exceeds a 5 km threshold.
      final moved = LocationService.hasMovedSignificantly(
        storedLat: 13.08,
        storedLng: 80.27,
        currentLat: 13.18,
        currentLng: 80.27,
        thresholdKm: 5.0,
      );
      expect(moved, isTrue);
    });

    test('does not flag a sub-threshold move at 5 km threshold', () {
      // ~1.1 km apart (0.01 deg lat) stays under a 5 km threshold.
      final moved = LocationService.hasMovedSignificantly(
        storedLat: 13.08,
        storedLng: 80.27,
        currentLat: 13.09,
        currentLng: 80.27,
        thresholdKm: 5.0,
      );
      expect(moved, isFalse);
    });
  });

  group('LocationService.isGpsAvailable', () {
    test('matches the platform (false on web, true otherwise)', () {
      expect(LocationService.isGpsAvailable, equals(!kIsWeb));
    });
  });
}
