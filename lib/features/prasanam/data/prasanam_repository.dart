import 'package:drift/drift.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:uuid/uuid.dart';

/// Repository handling CRUD operations for Prasanam Oracle history.
class PrasanamRepository {
  PrasanamRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Inserts a new Prasanam query and returns its ID.
  Future<String> insertQuery({
    required String category,
    required String queryText,
    required int score,
    required String band,
    required String guidanceEn,
    required String guidanceTa,
    required bool isFloorLocked,
    String? swara,
    String? birdState,
    String? actionWindow,
  }) async {
    final id = _uuid.v4();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _db
        .into(_db.prasanamHistory)
        .insert(
          PrasanamHistoryCompanion.insert(
            id: id,
            timestamp: timestamp,
            category: category,
            queryText: Value(queryText),
            score: score,
            band: band,
            guidanceEn: guidanceEn,
            guidanceTa: guidanceTa,
            isFloorLocked: Value(isFloorLocked),
            swara: Value(swara),
            birdState: Value(birdState),
            actionWindow: Value(actionWindow),
          ),
        );

    return id;
  }

  /// Returns all Prasanam queries ordered by timestamp descending.
  Future<List<PrasanamHistoryData>> getAllQueries() async {
    return (_db.select(_db.prasanamHistory)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .get();
  }

  /// Returns the most recent N queries.
  Future<List<PrasanamHistoryData>> getRecentQueries({int limit = 20}) async {
    return (_db.select(_db.prasanamHistory)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  /// Returns the most recent query (for 30-minute validation gate).
  Future<PrasanamHistoryData?> getMostRecentQuery() async {
    final results = await getRecentQueries(limit: 1);
    return results.isEmpty ? null : results.first;
  }

  /// Updates outcome notes for a Prasanam query.
  Future<void> updateOutcomeNotes({
    required String id,
    required String notes,
  }) async {
    final outcomeTimestamp = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.prasanamHistory)
          ..where((t) => t.id.equals(id)))
        .write(
      PrasanamHistoryCompanion(
        outcomeNotes: Value(notes),
        outcomeTimestamp: Value(outcomeTimestamp),
      ),
    );
  }

  /// Deletes a Prasanam query by ID.
  Future<int> deleteQuery(String id) async {
    return (_db.delete(_db.prasanamHistory)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  /// Watches all queries as a stream (for reactive UI updates).
  Stream<List<PrasanamHistoryData>> watchAllQueries() {
    return (_db.select(_db.prasanamHistory)..orderBy([
          (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
        ]))
        .watch();
  }
}
