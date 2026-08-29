import 'package:flutter/foundation.dart';
import 'package:saranidhi/core/services/location_service.dart';
import 'package:saranidhi/core/utils/geolocation.dart';
import 'package:saranidhi/database/app_database.dart';

/// Result of a location-on-open check.
class LocationUpdateResult {
  const LocationUpdateResult({
    this.updated = false,
    this.newLat,
    this.newLng,
    this.distanceKm,
  });

  /// Whether the stored profile location was updated.
  final bool updated;

  /// The new latitude written to the profile (null if unchanged).
  final double? newLat;

  /// The new longitude written to the profile (null if unchanged).
  final double? newLng;

  /// Distance moved from the stored location (km), if measured.
  final double? distanceKm;

  static const none = LocationUpdateResult();
}

/// On web app open, requests the browser geolocation and updates the
/// stored profile location if the user has moved significantly
/// (>5 km) from their last saved position.
///
/// On non-web platforms this is a no-op (the [WebGeolocation] facade
/// resolves to a stub that returns null).
///
/// Rationale: sunrise/sunset and the daily Pakshi rhythm follow the
/// user's *current* geographic position. Auto-refreshing on open keeps
/// the schedule accurate when the user travels, without requiring a
/// manual location edit in Settings.
class LocationOnOpenService {
  const LocationOnOpenService(this._db);

  final AppDatabase _db;

  /// Distance beyond which we consider the user to have moved and update
  /// the stored profile location.
  static const double thresholdKm = 5.0;

  /// Checks the current position (web only) and updates the profile if moved.
  ///
  /// Returns [LocationUpdateResult.none] when: not on web, geolocation
  /// unavailable/denied, no profile exists, or the user hasn't moved far.
  Future<LocationUpdateResult> checkAndUpdate() async {
    // Only web uses browser geolocation. Mobile GPS handled elsewhere.
    if (!kIsWeb) return LocationUpdateResult.none;

    final position = await WebGeolocation.getCurrentPosition();
    if (position == null) return LocationUpdateResult.none;

    final profiles = await _db.select(_db.profiles).get();
    if (profiles.isEmpty) return LocationUpdateResult.none;

    final profile = profiles.first;
    final storedLat = profile.locationLat ?? 13.08;
    final storedLng = profile.locationLng ?? 80.27;

    final distance = LocationService.distanceKm(
      lat1: storedLat,
      lng1: storedLng,
      lat2: position.latitude,
      lng2: position.longitude,
    );

    if (distance <= thresholdKm) {
      return LocationUpdateResult(distanceKm: distance);
    }

    await (_db.update(_db.profiles)..where((t) => t.id.equals(profile.id)))
        .write(
      ProfilesCompanion(
        locationLat: Value(position.latitude),
        locationLng: Value(position.longitude),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );

    return LocationUpdateResult(
      updated: true,
      newLat: position.latitude,
      newLng: position.longitude,
      distanceKm: distance,
    );
  }
}
