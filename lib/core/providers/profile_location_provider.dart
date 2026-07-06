import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/database_provider.dart';

/// Cached profile location data (latitude + longitude).
///
/// Defaults to Chennai (13.08, 80.27) if no profile exists yet.
/// Used by breath alignment checker, notification scheduler, and
/// dashboard astro calculations.
class ProfileLocation {
  const ProfileLocation({
    this.latitude = 13.08,
    this.longitude = 80.27,
  });

  final double latitude;
  final double longitude;
}

/// Provides the user's current profile location.
///
/// Reads from the database on first access and caches the result.
/// Invalidated when profile changes (e.g., location edit in settings).
final profileLocationProvider = FutureProvider<ProfileLocation>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final profiles = await db.select(db.profiles).get();

  if (profiles.isEmpty) return const ProfileLocation();

  final profile = profiles.first;
  return ProfileLocation(
    latitude: profile.locationLat ?? 13.08,
    longitude: profile.locationLng ?? 80.27,
  );
});
