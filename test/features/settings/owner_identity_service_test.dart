import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/settings/domain/owner_identity_service.dart';

void main() {
  late AppDatabase db;
  late OwnerIdentityService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = OwnerIdentityService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('OwnerIdentityService', () {
    test('returns null when no profiles exist in database', () async {
      final ownerId = await service.ensureOwnerId();
      expect(ownerId, isNull);
    });

    test('generates and saves ownerId if profile exists without one', () async {
      await db
          .into(db.profiles)
          .insert(
            ProfilesCompanion.insert(
              id: 'prof-test-1',
              displayName: const drift.Value('Test Practitioner'),
              createdAt: 1710000000000,
              updatedAt: 1710000000000,
            ),
          );

      final ownerId = await service.ensureOwnerId();
      expect(ownerId, isNotNull);
      expect(ownerId!.length, equals(36));

      // Verify persisted to DB
      final profile = (await db.select(db.profiles).get()).first;
      expect(profile.ownerId, equals(ownerId));
    });

    test('returns existing ownerId without changes (idempotent)', () async {
      const existingId = 'existing-owner-id-123';
      await db
          .into(db.profiles)
          .insert(
            ProfilesCompanion.insert(
              id: 'prof-test-2',
              ownerId: const drift.Value(existingId),
              displayName: const drift.Value('Test Practitioner 2'),
              createdAt: 1710000000000,
              updatedAt: 1710000000000,
            ),
          );

      final ownerId = await service.ensureOwnerId();
      expect(ownerId, equals(existingId));

      // Verify not modified
      final profile = (await db.select(db.profiles).get()).first;
      expect(profile.ownerId, equals(existingId));
    });
  });
}
