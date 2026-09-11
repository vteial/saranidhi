import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/onboarding/domain/bird_migration_service.dart';

void main() {
  late AppDatabase db;
  late BirdMigrationService service;

  // A fixed nakshatra recognized by both the Bright- and Dark-half tables,
  // and a fixed UTC birth moment. We never hardcode the resulting bird —
  // it is derived below via the SAME PakshiCalculator methods the service
  // uses, so the test stays honest even if the astro tables change.
  const nakshatra = 'Ashwini';
  final birthEpoch = DateTime.utc(1990, 5, 20, 6, 30).millisecondsSinceEpoch;

  /// The correct dual-table bird for [nakshatra] at [birthEpoch], derived the
  /// exact way [BirdMigrationService.recalculateIfNeeded] derives it.
  late PakshiBird correctBird;

  /// Some OTHER bird — guaranteed different from [correctBird] — used to seed
  /// a profile that carries a stale (old-logic) bird value.
  late PakshiBird staleBird;

  /// Inserts a profile row and returns its id. Optional fields left null are
  /// omitted so the service sees a realistic partial profile.
  Future<String> insertProfile({
    required String id,
    int? birthDateEpoch,
    String? birthStarNakshatra,
    String? birthBird,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: id,
            createdAt: now,
            updatedAt: now,
            birthDateEpoch: Value(birthDateEpoch),
            birthStarNakshatra: Value(birthStarNakshatra),
            birthBird: Value(birthBird),
          ),
        );
    return id;
  }

  Future<Profile> fetchProfile(String id) {
    return (db.select(db.profiles)..where((t) => t.id.equals(id))).getSingle();
  }

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = BirdMigrationService(db);

    // Derive the expected correct bird via the real calculator (dual-table,
    // Paksha-aware) — the same path the service takes.
    final birthDate = DateTime.fromMillisecondsSinceEpoch(
      birthEpoch,
      isUtc: true,
    );
    final birthPaksha = PakshiCalculator.birthPakshaFromDOB(birthDate);
    final derived = PakshiCalculator.birthBirdFromNakshatraAndPaksha(
      nakshatra,
      birthPaksha,
    );
    // Guard: our fixed inputs must yield a real bird, otherwise the fixture
    // is meaningless.
    expect(
      derived,
      isNotNull,
      reason: 'Fixture nakshatra/DOB must resolve to a known bird',
    );
    correctBird = derived!;

    // Pick any other enum value as the stale stored bird.
    staleBird = PakshiBird.values.firstWhere((b) => b != correctBird);
  });

  tearDown(() async {
    await db.close();
  });

  group('BirdMigrationService.recalculateIfNeeded (Sprint 37)', () {
    test(
      'corrects a stale-bird profile that has a DOB + nakshatra (Pushya stored rooster -> owl)',
      () async {
        final id = await insertProfile(
          id: 'pushya-dob-profile',
          birthDateEpoch: birthEpoch,
          birthStarNakshatra: 'Pushya',
          birthBird: 'rooster', // old incorrect Krishna derivation
        );

        final result = await service.recalculateIfNeeded();

        expect(result.changed, isTrue);
        expect(result.oldBird, 'rooster');
        expect(result.newBird, 'owl');

        // The DB row must actually be rewritten to the correct bird.
        final updated = await fetchProfile(id);
        expect(updated.birthBird, 'owl');
      },
    );

    test(
      'corrects a manual/no-DOB profile with an affected star (Pooram stored crow -> owl)',
      () async {
        final id = await insertProfile(
          id: 'pooram-manual-profile',
          birthStarNakshatra: 'Purva Phalguni',
          birthBird: 'crow', // old 5-5-5-5-7 derivation
        );

        final result = await service.recalculateIfNeeded();

        expect(result.changed, isTrue);
        expect(result.oldBird, 'crow');
        expect(result.newBird, 'owl');

        final updated = await fetchProfile(id);
        expect(updated.birthBird, 'owl');
        expect(updated.birthDateEpoch, isNull);
      },
    );

    test(
      'corrects a manual/no-DOB profile with Visakam (stored rooster -> crow)',
      () async {
        final id = await insertProfile(
          id: 'visakam-manual-profile',
          birthStarNakshatra: 'Vishakha',
          birthBird: 'rooster', // old 5-5-5-5-7 derivation
        );

        final result = await service.recalculateIfNeeded();

        expect(result.changed, isTrue);
        expect(result.oldBird, 'rooster');
        expect(result.newBird, 'crow');

        final updated = await fetchProfile(id);
        expect(updated.birthBird, 'crow');
      },
    );

    test(
      'corrects a manual/no-DOB profile with Uthiradam (stored peacock -> rooster)',
      () async {
        final id = await insertProfile(
          id: 'uthiradam-manual-profile',
          birthStarNakshatra: 'Uttara Ashadha',
          birthBird: 'peacock', // old 5-5-5-5-7 derivation
        );

        final result = await service.recalculateIfNeeded();

        expect(result.changed, isTrue);
        expect(result.oldBird, 'peacock');
        expect(result.newBird, 'rooster');

        final updated = await fetchProfile(id);
        expect(updated.birthBird, 'rooster');
      },
    );

    test('leaves a profile without a nakshatra untouched', () async {
      final id = await insertProfile(
        id: 'no-nakshatra-profile',
        birthStarNakshatra: null,
        birthBird: 'vulture',
      );

      final result = await service.recalculateIfNeeded();

      expect(result.changed, isFalse);

      final unchanged = await fetchProfile(id);
      expect(unchanged.birthBird, 'vulture');
    });

    test('is idempotent when the stored bird is already correct', () async {
      final id = await insertProfile(
        id: 'already-correct-profile',
        birthDateEpoch: birthEpoch,
        birthStarNakshatra: 'Ashwini',
        birthBird: 'vulture',
      );

      final result = await service.recalculateIfNeeded();

      expect(result.changed, isFalse);
      expect(result.oldBird, isNull);
      expect(result.newBird, isNull);

      final unchanged = await fetchProfile(id);
      expect(unchanged.birthBird, 'vulture');
    });

    test('returns noChange on an empty database', () async {
      final result = await service.recalculateIfNeeded();

      expect(result.changed, isFalse);
      expect(result.oldBird, isNull);
      expect(result.newBird, isNull);
      expect(result, same(BirdMigrationResult.noChange));
    });
  });
}
