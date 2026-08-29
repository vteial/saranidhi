import 'package:drift/drift.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:uuid/uuid.dart';

/// Repository handling CRUD operations for somatic intervention logs.
///
/// Persists each guided breath-channel intervention session so effectiveness
/// can be reviewed over time.
class SomaticInterventionRepository {
  SomaticInterventionRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Inserts a new intervention log and returns its ID.
  ///
  /// [resolvedFlow] and [isSuccess] are typically written later, once the
  /// post-session verification completes ([updateOutcome]).
  Future<String> insertLog({
    required String protocolType,
    required String targetFlow,
    required String initialFlow,
    required int durationSeconds,
    String? resolvedFlow,
    bool isSuccess = false,
  }) async {
    final id = _uuid.v4();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _db.into(_db.somaticInterventionLogs).insert(
          SomaticInterventionLogsCompanion.insert(
            id: id,
            timestamp: timestamp,
            protocolType: protocolType,
            targetFlow: targetFlow,
            initialFlow: initialFlow,
            durationSeconds: durationSeconds,
            resolvedFlow: Value(resolvedFlow),
            isSuccess: Value(isSuccess),
          ),
        );

    return id;
  }

  /// Records the verified outcome of an intervention (post-session nostril
  /// test result + whether it matched the target flow).
  Future<void> updateOutcome({
    required String id,
    required String resolvedFlow,
    required bool isSuccess,
  }) async {
    await (_db.update(_db.somaticInterventionLogs)
          ..where((t) => t.id.equals(id)))
        .write(
      SomaticInterventionLogsCompanion(
        resolvedFlow: Value(resolvedFlow),
        isSuccess: Value(isSuccess),
      ),
    );
  }

  /// Returns all intervention logs ordered by timestamp descending.
  Future<List<SomaticInterventionLog>> getAllLogs() async {
    return (_db.select(_db.somaticInterventionLogs)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Returns the most recent N logs.
  Future<List<SomaticInterventionLog>> getRecentLogs({int limit = 20}) async {
    return (_db.select(_db.somaticInterventionLogs)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  /// Deletes an intervention log by ID.
  Future<int> deleteLog(String id) async {
    return (_db.delete(_db.somaticInterventionLogs)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  /// Watches all logs as a stream (for reactive UI updates).
  Stream<List<SomaticInterventionLog>> watchAllLogs() {
    return (_db.select(_db.somaticInterventionLogs)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ]))
        .watch();
  }
}
