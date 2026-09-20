import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_transport.dart';
import 'package:saranidhi/features/settings/domain/owner_identity_service.dart';

/// Summary outcome of a single on-demand practice sync run.
class SyncOutcome {
  const SyncOutcome({
    this.pulledInserted = 0,
    this.pushed = 0,
    this.error,
    this.syncedAt,
  });

  /// Total remote records merged into local database during this run.
  final int pulledInserted;

  /// Total local records submitted to remote transport during this run.
  final int pushed;

  /// Error description if the sync run failed or was aborted.
  final String? error;

  /// Timestamp when sync completed successfully.
  final DateTime? syncedAt;

  bool get isSuccess => error == null;
  bool get hasError => error != null;

  @override
  String toString() =>
      'SyncOutcome(pulledInserted: $pulledInserted, pushed: $pushed, '
      'error: $error, syncedAt: $syncedAt)';
}

/// Orchestrates on-demand Practice Sync (pull → union-merge → push).
///
/// Ensures:
/// 1. Practice ID (ownerId) resolution and scoping.
/// 2. Client-side owner guard on pull (refuses foreign rows with 0 mutations).
/// 3. Union-merge by UUID (append-only, never deletes).
/// 4. Idempotent push to remote transport.
/// 5. Non-blocking error containment for offline resilience.
class PracticeSyncEngine {
  PracticeSyncEngine({
    required AppDatabase db,
    required this.transport,
    required this.ownerIdentityService,
    DatabaseExporter? exporter,
  }) : _db = db,
       _exporter = exporter ?? DatabaseExporter(db);

  final AppDatabase _db;
  final SyncTransport transport;
  final OwnerIdentityService ownerIdentityService;
  final DatabaseExporter _exporter;

  /// Executes an on-demand sync cycle for the given [scopes].
  Future<SyncOutcome> performSync({
    Set<SyncScope> scopes = const {SyncScope.sessions, SyncScope.journal},
  }) async {
    try {
      // 1. Resolve Practice ID (ownerId)
      var ownerId = await ownerIdentityService.ensureOwnerId();
      if (ownerId == null || ownerId.isEmpty) {
        return const SyncOutcome(
          error:
              'No local Practice ID found. Please complete profile setup before syncing.',
        );
      }

      // 2. Verify transport status
      if (!transport.isConfigured) {
        return const SyncOutcome(error: 'Sync server is not configured.');
      }
      if (!transport.isAuthenticated) {
        return const SyncOutcome(
          error: 'Please sign in to sync your practice data.',
        );
      }

      // Reconcile ownerId with authenticated backend user if mismatched (self-healing)
      final authUserId = transport.authUserId;
      if (authUserId != null &&
          authUserId.isNotEmpty &&
          authUserId != ownerId) {
        final bound = await ownerIdentityService.bindOwnerId(authUserId);
        if (bound != null && bound.isNotEmpty) {
          ownerId = bound;
        }
      }

      if (scopes.isEmpty) {
        return SyncOutcome(syncedAt: DateTime.now());
      }

      // 3. Pull remote rows for ownerId and scopes
      final remote = await transport.pull(ownerId: ownerId, scopes: scopes);

      // 4. Client-side owner guard assertion
      final foreignSession = remote.sessions
          .cast<Map<String, dynamic>?>()
          .firstWhere(
            (r) => r != null && r['ownerId'] != null && r['ownerId'] != ownerId,
            orElse: () => null,
          );
      final foreignJournal = remote.journal
          .cast<Map<String, dynamic>?>()
          .firstWhere(
            (r) => r != null && r['ownerId'] != null && r['ownerId'] != ownerId,
            orElse: () => null,
          );

      if (foreignSession != null || foreignJournal != null) {
        final foreignId =
            (foreignSession?['ownerId'] ?? foreignJournal?['ownerId'])
                as String;
        return SyncOutcome(
          error:
              'Owner guard check failed: foreign Practice ID ($foreignId) detected. '
              'Sync aborted with zero local changes.',
        );
      }

      // 5. Union-merge pulled rows into local database
      final mergeResult = await _exporter.mergePracticeRows(
        sessions: scopes.contains(SyncScope.sessions) ? remote.sessions : null,
        journal: scopes.contains(SyncScope.journal) ? remote.journal : null,
      );

      // 6. Push local rows (upsert-by-uuid)
      final localSessions = <Map<String, dynamic>>[];
      final localJournal = <Map<String, dynamic>>[];

      if (scopes.contains(SyncScope.sessions)) {
        final sessions = await _db.select(_db.breathSessions).get();
        localSessions.addAll(sessions.map(DatabaseExporter.sessionToMap));
      }

      if (scopes.contains(SyncScope.journal)) {
        final journal = await _db.select(_db.saraKalaiJournal).get();
        localJournal.addAll(journal.map(DatabaseExporter.journalToMap));
      }

      final localData = RemoteSyncData(
        sessions: localSessions,
        journal: localJournal,
      );

      await transport.push(ownerId: ownerId, local: localData, scopes: scopes);

      final totalPushed =
          (scopes.contains(SyncScope.sessions) ? localSessions.length : 0) +
          (scopes.contains(SyncScope.journal) ? localJournal.length : 0);

      return SyncOutcome(
        pulledInserted: mergeResult.totalInserted,
        pushed: totalPushed,
        syncedAt: DateTime.now(),
      );
    } on Object catch (e) {
      return SyncOutcome(error: e.toString());
    }
  }
}
