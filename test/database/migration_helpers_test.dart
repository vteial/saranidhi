import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/migration_helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // In-memory database; `onCreate` runs `createAll()` so every table and
    // column from the current schema exists.
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('tableExists', () {
    test('returns true for a table created by the schema', () async {
      expect(await tableExists(db, 'profiles'), isTrue);
      expect(await tableExists(db, 'sara_kalai_journal'), isTrue);
      expect(await tableExists(db, 'somatic_intervention_logs'), isTrue);
    });

    test('returns false for a table that does not exist', () async {
      expect(await tableExists(db, 'no_such_table'), isFalse);
    });
  });

  group('columnExists', () {
    test('returns true for a column present in the table', () async {
      expect(
        await columnExists(db, 'sara_kalai_journal', 'is_pinned'),
        isTrue,
      );
      expect(
        await columnExists(db, 'profiles', 'birth_date_epoch'),
        isTrue,
      );
    });

    test('returns false for a column that does not exist', () async {
      expect(
        await columnExists(db, 'sara_kalai_journal', 'no_such_column'),
        isFalse,
      );
    });

    test('returns false when the table itself does not exist', () async {
      expect(
        await columnExists(db, 'no_such_table', 'is_pinned'),
        isFalse,
      );
    });
  });
}
