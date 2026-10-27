import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/core/services/location_on_open_service.dart';
import 'package:saranidhi/database/database_provider.dart';

/// Provides the [LocationOnOpenService] instance.
final locationOnOpenServiceProvider = Provider<LocationOnOpenService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocationOnOpenService(db);
});

/// Runs the web geolocation check once on app open and exposes the result.
///
/// Consumed by `LocationOnOpenWidget` to refresh location-dependent
/// providers when the user has moved significantly. Auto-runs when watched.
final locationOnOpenProvider = FutureProvider<LocationUpdateResult>((ref) async {
  final service = ref.watch(locationOnOpenServiceProvider);
  return service.checkAndUpdate();
});

/// In-memory session flag: whether LocationOnOpenWidget has run this session.
final locationOnOpenFiredProvider =
    NotifierProvider<LocationOnOpenFiredNotifier, bool>(
      LocationOnOpenFiredNotifier.new,
    );

class LocationOnOpenFiredNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markFired() => state = true;
}
