import 'package:drift/drift.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:uuid/uuid.dart';

/// Repository handling CRUD operations for Sara Kalai journal entries.
class JournalRepository {
  JournalRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Inserts a new journal entry and returns its ID.
  Future<String> insertEntry({
    required String expectedFlow,
    required String actualFlow,
    required bool isAligned,
    required String nostril,
    int? inhaleDurationMs,
    int? holdDurationMs,
    int? exhaleDurationMs,
    String? activeYama,
    String? activeBird,
    String? activeBirdState,
    String? activeElement,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _db
        .into(_db.saraKalaiJournal)
        .insert(
          SaraKalaiJournalCompanion.insert(
            id: id,
            timestamp: timestamp,
            expectedFlow: expectedFlow,
            actualFlow: actualFlow,
            isAligned: isAligned,
            nostril: nostril,
            inhaleDurationMs: Value(inhaleDurationMs),
            holdDurationMs: Value(holdDurationMs),
            exhaleDurationMs: Value(exhaleDurationMs),
            activeYama: Value(activeYama),
            activeBird: Value(activeBird),
            activeBirdState: Value(activeBirdState),
            activeElement: Value(activeElement),
            notes: Value(notes),
          ),
        );

    return id;
  }

  /// Returns all journal entries ordered by timestamp descending.
  Future<List<SaraKalaiJournalData>> getAllEntries() async {
    return (_db.select(_db.saraKalaiJournal)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .get();
  }

  /// Returns journal entries for a specific date (start of day to end of day).
  Future<List<SaraKalaiJournalData>> getEntriesForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.saraKalaiJournal)
          ..where(
            (t) =>
                t.timestamp.isBiggerOrEqualValue(
                  startOfDay.millisecondsSinceEpoch,
                ) &
                t.timestamp.isSmallerThanValue(endOfDay.millisecondsSinceEpoch),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Returns the most recent N entries.
  Future<List<SaraKalaiJournalData>> getRecentEntries({int limit = 20}) async {
    return (_db.select(_db.saraKalaiJournal)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  /// Deletes a journal entry by ID.
  Future<int> deleteEntry(String id) async {
    return (_db.delete(
      _db.saraKalaiJournal,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Returns the count of entries for today.
  Future<int> todayCount() async {
    final entries = await getEntriesForDate(DateTime.now());
    return entries.length;
  }

  /// Watches all entries as a stream (for reactive UI updates).
  Stream<List<SaraKalaiJournalData>> watchAllEntries() {
    return (_db.select(_db.saraKalaiJournal)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .watch();
  }
}
