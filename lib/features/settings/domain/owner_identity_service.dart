import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:uuid/uuid.dart';

/// Service ensuring the local user profile always has a stable Practice ID (ownerId).
class OwnerIdentityService {
  const OwnerIdentityService(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Ensures the existing profile has a non-null, non-empty `ownerId`.
  ///
  /// If a profile exists but lacks an `ownerId`, generates a new UUID v4 and
  /// updates the profile. If no profile exists yet (pre-onboarding), returns null.
  /// Idempotent: returns existing `ownerId` if already assigned.
  Future<String?> ensureOwnerId() async {
    final profiles = await _db.select(_db.profiles).get();
    if (profiles.isEmpty) return null;

    final profile = profiles.first;
    if (profile.ownerId != null && profile.ownerId!.isNotEmpty) {
      return profile.ownerId;
    }

    final newOwnerId = _uuid.v4();
    await (_db.update(_db.profiles)..where((t) => t.id.equals(profile.id)))
        .write(ProfilesCompanion(ownerId: Value(newOwnerId)));
    return newOwnerId;
  }

  /// Binds the local profile's ownerId to the authenticated backend (PocketBase) user id.
  ///
  /// Idempotent: a no-op if the profile ownerId already equals [backendUserId].
  /// Returns the effective ownerId (== backendUserId on success), or null if no profile exists.
  Future<String?> bindOwnerId(String backendUserId) async {
    final profiles = await _db.select(_db.profiles).get();
    if (profiles.isEmpty) return null;

    final profile = profiles.first;
    if (profile.ownerId == backendUserId) {
      return profile.ownerId;
    }

    await (_db.update(_db.profiles)..where((t) => t.id.equals(profile.id)))
        .write(ProfilesCompanion(ownerId: Value(backendUserId)));
    return backendUserId;
  }
}

/// Provider for [OwnerIdentityService].
final ownerIdentityServiceProvider = Provider<OwnerIdentityService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return OwnerIdentityService(db);
});

/// Asynchronously provides the current device's Practice ID (ownerId).
final ownerIdProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(ownerIdentityServiceProvider);
  return service.ensureOwnerId();
});
