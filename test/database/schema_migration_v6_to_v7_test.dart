import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/migration_helpers.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Schema Migration v6 -> v7', () {
    test(
      'upgrades existing v6 database, adds owner_id, and backfills UUID without data loss',
      () async {
        final rawDb = sqlite3.openInMemory();

        // Setup v6 schema where profiles table lacks owner_id
        rawDb.execute('''
        CREATE TABLE profiles (
          id TEXT NOT NULL PRIMARY KEY,
          display_name TEXT NOT NULL DEFAULT '',
          birth_star_nakshatra TEXT,
          birth_bird TEXT,
          location_lat REAL,
          location_lng REAL,
          birth_date_epoch INTEGER,
          birth_time TEXT,
          birth_place_name TEXT,
          birth_place_lat REAL,
          birth_place_lng REAL,
          theme TEXT NOT NULL DEFAULT 'light',
          language TEXT NOT NULL DEFAULT 'en',
          storage_mode TEXT NOT NULL DEFAULT 'local',
          notify_ruling INTEGER NOT NULL DEFAULT 1,
          notify_eating INTEGER NOT NULL DEFAULT 0,
          last_ai_note TEXT,
          last_ai_note_date TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
        PRAGMA user_version = 6;
      ''');

        // Insert an existing profile in v6 format
        rawDb.execute('''
        INSERT INTO profiles (
          id, display_name, birth_star_nakshatra, birth_bird,
          location_lat, location_lng, created_at, updated_at
        ) VALUES (
          'profile-uuid-1', 'Siddha Practitioner', 'Ashwini', 'Vulture',
          13.08, 80.27, 1710000000000, 1710000000000
        );
      ''');

        // Open AppDatabase over the v6 database
        final db = AppDatabase(NativeDatabase.opened(rawDb));

        // Read profile after migration has executed
        final profiles = await db.select(db.profiles).get();

        expect(profiles.length, equals(1));
        final p = profiles.first;
        expect(p.id, equals('profile-uuid-1'));
        expect(p.displayName, equals('Siddha Practitioner'));
        expect(p.birthStarNakshatra, equals('Ashwini'));
        expect(p.birthBird, equals('Vulture'));
        expect(p.locationLat, equals(13.08));
        expect(p.locationLng, equals(80.27));
        expect(p.ownerId, isNotNull);
        expect(p.ownerId!.length, equals(36));
        expect(RegExp(r'^[0-9a-fA-F-]{36}$').hasMatch(p.ownerId!), isTrue);

        // Verify columnExists
        expect(await columnExists(db, 'profiles', 'owner_id'), isTrue);

        await db.close();
      },
    );

    test('fresh install creates schema with owner_id column', () async {
      final db = AppDatabase(NativeDatabase.memory());

      expect(await columnExists(db, 'profiles', 'owner_id'), isTrue);

      await db.close();
    });

    test('migration is idempotent on re-run', () async {
      final rawDb = sqlite3.openInMemory();
      rawDb.execute('''
        CREATE TABLE profiles (
          id TEXT NOT NULL PRIMARY KEY,
          display_name TEXT NOT NULL DEFAULT '',
          birth_star_nakshatra TEXT,
          birth_bird TEXT,
          location_lat REAL,
          location_lng REAL,
          birth_date_epoch INTEGER,
          birth_time TEXT,
          birth_place_name TEXT,
          birth_place_lat REAL,
          birth_place_lng REAL,
          theme TEXT NOT NULL DEFAULT 'light',
          language TEXT NOT NULL DEFAULT 'en',
          storage_mode TEXT NOT NULL DEFAULT 'local',
          notify_ruling INTEGER NOT NULL DEFAULT 1,
          notify_eating INTEGER NOT NULL DEFAULT 0,
          last_ai_note TEXT,
          last_ai_note_date TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
        PRAGMA user_version = 6;
        INSERT INTO profiles (
          id, display_name, created_at, updated_at
        ) VALUES (
          'profile-uuid-2', 'Practitioner Two', 1710000000000, 1710000000000
        );
      ''');

      final db = AppDatabase(NativeDatabase.opened(rawDb));
      final p1 = (await db.select(db.profiles).get()).first;
      final originalOwnerId = p1.ownerId;
      expect(originalOwnerId, isNotNull);

      // Manually trigger onUpgrade again
      final m = db.createMigrator();
      await db.migration.onUpgrade(m, 6, 7);

      final p2 = (await db.select(db.profiles).get()).first;
      expect(p2.ownerId, equals(originalOwnerId));

      await db.close();
    });
  });
}
