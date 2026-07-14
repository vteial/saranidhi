// ignore: avoid_web_libraries_in_flutter
// Uses dart:js_interop and package:web for browser geolocation API (web-only).
import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Simple position data class.
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

/// Web-only geolocation service using the browser's navigator.geolocation API.
///
/// Returns the user's current GPS coordinates with a 10-second timeout.
/// Falls back gracefully if permission denied or unavailable.
class WebGeolocation {
  const WebGeolocation._();

  /// Requests the user's current position via browser geolocation API.
  ///
  /// Returns `null` if:
  /// - Permission denied
  /// - Geolocation unavailable (e.g., HTTP without HTTPS)
  /// - Timeout (10 seconds)
  /// - Any other error
  static Future<GeolocationPosition?> getCurrentPosition() async {
    final completer = Completer<GeolocationPosition?>();

    try {
      web.window.navigator.geolocation.getCurrentPosition(
        ((web.GeolocationPosition pos) {
          completer.complete(GeolocationPosition(
            latitude: pos.coords.latitude,
            longitude: pos.coords.longitude,
            accuracy: pos.coords.accuracy,
          ));
        }).toJS,
        ((web.GeolocationPositionError err) {
          completer.complete(null);
        }).toJS,
        web.PositionOptions(
          enableHighAccuracy: false,
          timeout: 10000,
          maximumAge: 60000,
        ),
      );
    } on Object {
      if (!completer.isCompleted) completer.complete(null);
    }

    return completer.future;
  }
}
