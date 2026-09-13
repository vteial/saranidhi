import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/data/journal_repository.dart';

void main() {
  late AppDatabase db;
  late JournalRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = JournalRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('JournalRepository.getEntriesSince', () {
    test(
      'returns only entries >= cutoff in ascending timestamp order',
      () async {
        final now = DateTime.now();
        final tMinus30h = now.subtract(const Duration(hours: 30));
        final tMinus12h = now.subtract(const Duration(hours: 12));
        final tMinus4h = now.subtract(const Duration(hours: 4));
        final tMinus1h = now.subtract(const Duration(hours: 1));

        // Insert entries with explicit timestamps via db companion
        await db
            .into(db.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'entry-30h',
                timestamp: tMinus30h.millisecondsSinceEpoch,
                expectedFlow: 'solar',
                actualFlow: 'solar',
                isAligned: true,
                nostril: 'right',
              ),
            );

        await db
            .into(db.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'entry-12h',
                timestamp: tMinus12h.millisecondsSinceEpoch,
                expectedFlow: 'solar',
                actualFlow: 'solar',
                isAligned: true,
                nostril: 'right',
              ),
            );

        await db
            .into(db.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'entry-4h',
                timestamp: tMinus4h.millisecondsSinceEpoch,
                expectedFlow: 'lunar',
                actualFlow: 'lunar',
                isAligned: true,
                nostril: 'left',
              ),
            );

        await db
            .into(db.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'entry-1h',
                timestamp: tMinus1h.millisecondsSinceEpoch,
                expectedFlow: 'lunar',
                actualFlow: 'lunar',
                isAligned: true,
                nostril: 'left',
              ),
            );

        final cutoff = now.subtract(const Duration(hours: 24));
        final results = await repo.getEntriesSince(cutoff);

        // Should only include 12h, 4h, and 1h entries (not 30h)
        expect(results, hasLength(3));
        expect(results[0].id, equals('entry-12h'));
        expect(results[1].id, equals('entry-4h'));
        expect(results[2].id, equals('entry-1h'));

        // Verify ascending order
        expect(results[0].timestamp, lessThan(results[1].timestamp));
        expect(results[1].timestamp, lessThan(results[2].timestamp));
      },
    );

    test('returns empty list when no entries after cutoff', () async {
      final now = DateTime.now();
      final tMinus48h = now.subtract(const Duration(hours: 48));

      await db
          .into(db.saraKalaiJournal)
          .insert(
            SaraKalaiJournalCompanion.insert(
              id: 'old-entry',
              timestamp: tMinus48h.millisecondsSinceEpoch,
              expectedFlow: 'solar',
              actualFlow: 'solar',
              isAligned: true,
              nostril: 'right',
            ),
          );

      final cutoff = now.subtract(const Duration(hours: 24));
      final results = await repo.getEntriesSince(cutoff);
      expect(results, isEmpty);
    });
  });
}
