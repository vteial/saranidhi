import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_transport.dart';

/// PocketBase implementation of [SyncTransport].
///
/// Communicates with a PocketBase instance (Fly.io or local Docker Compose)
/// via web-safe HTTP client calls.
class PocketBaseSyncTransport implements SyncTransport {
  PocketBaseSyncTransport({
    required String baseUrl,
    PocketBase? client,
    http.Client? httpClient,
    AuthStore? authStore,
  }) : _baseUrl = baseUrl.trim(),
       _client =
           client ??
           PocketBase(
             baseUrl.trim(),
             httpClientFactory: httpClient != null ? () => httpClient : null,
             authStore: authStore,
           );

  final String _baseUrl;
  final PocketBase _client;

  /// Exposes the underlying PocketBase client for testing or advanced inspection.
  PocketBase get client => _client;

  @override
  bool get isConfigured => _baseUrl.isNotEmpty;

  @override
  bool get isAuthenticated =>
      _client.authStore.isValid && _client.authStore.token.isNotEmpty;

  @override
  Future<void> signIn({
    required String email,
    required String passphrase,
  }) async {
    if (!isConfigured) {
      throw StateError(
        'PocketBaseSyncTransport is not configured with a server URL.',
      );
    }
    await _client.collection('users').authWithPassword(email, passphrase);
  }

  @override
  Future<void> signOut() async {
    _client.authStore.clear();
  }

  @override
  Future<RemoteSyncData> pull({
    required String ownerId,
    required Set<SyncScope> scopes,
  }) async {
    if (!isConfigured) {
      throw StateError('PocketBaseSyncTransport is not configured.');
    }
    if (!isAuthenticated) {
      throw StateError('PocketBaseSyncTransport is not authenticated.');
    }

    final pulledSessions = <Map<String, dynamic>>[];
    final pulledJournal = <Map<String, dynamic>>[];

    if (scopes.contains(SyncScope.sessions)) {
      final records = await _client
          .collection('sessions')
          .getFullList(filter: "ownerId = '$ownerId'");
      for (final r in records) {
        final row = _recordToSessionMap(r);
        pulledSessions.add(row);
      }
    }

    if (scopes.contains(SyncScope.journal)) {
      final records = await _client
          .collection('journal')
          .getFullList(filter: "ownerId = '$ownerId'");
      for (final r in records) {
        final row = _recordToJournalMap(r);
        pulledJournal.add(row);
      }
    }

    return RemoteSyncData(sessions: pulledSessions, journal: pulledJournal);
  }

  @override
  Future<void> push({
    required String ownerId,
    required RemoteSyncData local,
    required Set<SyncScope> scopes,
  }) async {
    if (!isConfigured) {
      throw StateError('PocketBaseSyncTransport is not configured.');
    }
    if (!isAuthenticated) {
      throw StateError('PocketBaseSyncTransport is not authenticated.');
    }

    // Push sessions if scoped
    if (scopes.contains(SyncScope.sessions) && local.sessions.isNotEmpty) {
      final existingRecords = await _client
          .collection('sessions')
          .getFullList(filter: "ownerId = '$ownerId'", fields: 'id,uuid');
      final existingMap = <String, String>{
        for (final r in existingRecords)
          if (r.getStringValue('uuid').isNotEmpty)
            r.getStringValue('uuid'): r.id,
      };

      for (final localRow in local.sessions) {
        final uuid = (localRow['uuid'] ?? localRow['id']) as String?;
        if (uuid == null || uuid.isEmpty) continue;

        final body = _sessionMapToRecordBody(
          ownerId: ownerId,
          uuid: uuid,
          row: localRow,
        );
        if (existingMap.containsKey(uuid)) {
          await _client
              .collection('sessions')
              .update(existingMap[uuid]!, body: body);
        } else {
          final created = await _client
              .collection('sessions')
              .create(body: body);
          existingMap[uuid] = created.id;
        }
      }
    }

    // Push journal entries if scoped
    if (scopes.contains(SyncScope.journal) && local.journal.isNotEmpty) {
      final existingRecords = await _client
          .collection('journal')
          .getFullList(filter: "ownerId = '$ownerId'", fields: 'id,uuid');
      final existingMap = <String, String>{
        for (final r in existingRecords)
          if (r.getStringValue('uuid').isNotEmpty)
            r.getStringValue('uuid'): r.id,
      };

      for (final localRow in local.journal) {
        final uuid = (localRow['uuid'] ?? localRow['id']) as String?;
        if (uuid == null || uuid.isEmpty) continue;

        final body = _journalMapToRecordBody(
          ownerId: ownerId,
          uuid: uuid,
          row: localRow,
        );
        if (existingMap.containsKey(uuid)) {
          await _client
              .collection('journal')
              .update(existingMap[uuid]!, body: body);
        } else {
          final created = await _client
              .collection('journal')
              .create(body: body);
          existingMap[uuid] = created.id;
        }
      }
    }
  }

  // ─── Serialization mappers ────────────────────────────────────────────────

  Map<String, dynamic> _recordToSessionMap(RecordModel r) {
    final uuid = r.getStringValue('uuid');
    return {
      'id': uuid.isNotEmpty ? uuid : r.id,
      'uuid': uuid.isNotEmpty ? uuid : r.id,
      'ownerId': r.getStringValue('ownerId'),
      'timestamp': r.getIntValue('timestamp'),
      'totalDurationMs': r.getIntValue('totalDurationMs'),
      'nostril': r.getStringValue('nostril'),
      'inhaleLengthMs': r.getIntValue('inhaleLengthMs'),
      'holdAfterInhaleMs': r.getIntValue('holdAfterInhaleMs'),
      'exhaleLengthMs': r.getIntValue('exhaleLengthMs'),
      'holdAfterExhaleMs': r.getIntValue('holdAfterExhaleMs'),
      'completedCycles': r.getIntValue('completedCycles'),
      if (r.data['mood'] != null) 'mood': r.getStringValue('mood'),
      if (r.data['consciousnessRating'] != null)
        'consciousnessRating': r.getIntValue('consciousnessRating'),
      if (r.data['notes'] != null) 'notes': r.getStringValue('notes'),
    };
  }

  Map<String, dynamic> _recordToJournalMap(RecordModel r) {
    final uuid = r.getStringValue('uuid');
    return {
      'id': uuid.isNotEmpty ? uuid : r.id,
      'uuid': uuid.isNotEmpty ? uuid : r.id,
      'ownerId': r.getStringValue('ownerId'),
      'timestamp': r.getIntValue('timestamp'),
      'expectedFlow': r.getStringValue('expectedFlow'),
      'actualFlow': r.getStringValue('actualFlow'),
      'nostril': r.getStringValue('nostril'),
      'isAligned': r.getBoolValue('isAligned'),
      if (r.data['inhaleDurationMs'] != null)
        'inhaleDurationMs': r.getIntValue('inhaleDurationMs'),
      if (r.data['holdDurationMs'] != null)
        'holdDurationMs': r.getIntValue('holdDurationMs'),
      if (r.data['exhaleDurationMs'] != null)
        'exhaleDurationMs': r.getIntValue('exhaleDurationMs'),
      if (r.data['activeYama'] != null)
        'activeYama': r.getStringValue('activeYama'),
      if (r.data['activeBird'] != null)
        'activeBird': r.getStringValue('activeBird'),
      if (r.data['activeBirdState'] != null)
        'activeBirdState': r.getStringValue('activeBirdState'),
      if (r.data['activeElement'] != null)
        'activeElement': r.getStringValue('activeElement'),
      if (r.data['notes'] != null) 'notes': r.getStringValue('notes'),
      'isPinned': r.getBoolValue('isPinned'),
      'wasForcedShift': r.getBoolValue('wasForcedShift'),
    };
  }

  Map<String, dynamic> _sessionMapToRecordBody({
    required String ownerId,
    required String uuid,
    required Map<String, dynamic> row,
  }) {
    return {
      'uuid': uuid,
      'ownerId': ownerId,
      'timestamp': row['timestamp'] ?? 0,
      'totalDurationMs': row['totalDurationMs'] ?? 0,
      'nostril': row['nostril'] ?? '',
      'inhaleLengthMs': row['inhaleLengthMs'] ?? 0,
      'holdAfterInhaleMs': row['holdAfterInhaleMs'] ?? 0,
      'exhaleLengthMs': row['exhaleLengthMs'] ?? 0,
      'holdAfterExhaleMs': row['holdAfterExhaleMs'] ?? 0,
      'completedCycles': row['completedCycles'] ?? 0,
      if (row['mood'] != null) 'mood': row['mood'],
      if (row['consciousnessRating'] != null)
        'consciousnessRating': row['consciousnessRating'],
      if (row['notes'] != null) 'notes': row['notes'],
    };
  }

  Map<String, dynamic> _journalMapToRecordBody({
    required String ownerId,
    required String uuid,
    required Map<String, dynamic> row,
  }) {
    return {
      'uuid': uuid,
      'ownerId': ownerId,
      'timestamp': row['timestamp'] ?? 0,
      'expectedFlow': row['expectedFlow'] ?? '',
      'actualFlow': row['actualFlow'] ?? '',
      'nostril': row['nostril'] ?? '',
      'isAligned': row['isAligned'] ?? false,
      if (row['inhaleDurationMs'] != null)
        'inhaleDurationMs': row['inhaleDurationMs'],
      if (row['holdDurationMs'] != null)
        'holdDurationMs': row['holdDurationMs'],
      if (row['exhaleDurationMs'] != null)
        'exhaleDurationMs': row['exhaleDurationMs'],
      if (row['activeYama'] != null) 'activeYama': row['activeYama'],
      if (row['activeBird'] != null) 'activeBird': row['activeBird'],
      if (row['activeBirdState'] != null)
        'activeBirdState': row['activeBirdState'],
      if (row['activeElement'] != null) 'activeElement': row['activeElement'],
      if (row['notes'] != null) 'notes': row['notes'],
      'isPinned': row['isPinned'] ?? false,
      'wasForcedShift': row['wasForcedShift'] ?? false,
    };
  }
}
