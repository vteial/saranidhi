import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_record_mapper.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_schema.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_metadata.dart';

/// Service handling all CloudKit interactions for iCloud sync.
///
/// Uses a [MethodChannel] to communicate with native Swift code
/// on iOS/macOS for CloudKit operations. This avoids dependency
/// on unmaintained third-party packages.
///
/// **Architecture:**
/// - Each local Drift row maps to one CloudKit record
/// - Record names use the local UUID (ensures idempotency)
/// - Sync is pull-then-push (pull on open, push after mutations)
/// - Conflict resolution: "primary device wins"
class CloudKitSyncService {
  CloudKitSyncService({MethodChannel? channel})
      : _channel = channel ??
            const MethodChannel('com.vteial.saranidhi/cloudkit');

  final MethodChannel _channel;

  /// Whether CloudKit is available on this platform.
  bool get isSupported =>
      !kIsWeb && (Platform.isIOS || Platform.isMacOS);


  /// Check if the user is signed in to iCloud.
  Future<bool> isAuthenticated() async {
    if (!isSupported) return false;
    try {
      final result = await _channel.invokeMethod<bool>('getAccountStatus');
      return result ?? false;
    } on Exception catch (e) {
      debugPrint('[CloudKit] Auth check failed: $e');
      return false;
    }
  }

  // ----------------------------------------------------------
  // Generic record operations via MethodChannel
  // ----------------------------------------------------------

  /// Save a record to CloudKit private database.
  Future<bool> _saveRecord({
    required String recordType,
    required String recordName,
    required Map<String, dynamic> fields,
  }) async {
    if (!isSupported) return false;
    try {
      final result = await _channel.invokeMethod<bool>(
        'saveRecord',
        {
          'recordType': recordType,
          'recordName': recordName,
          'fields': fields,
        },
      );
      return result ?? false;
    } on Exception catch (e) {
      debugPrint('[CloudKit] Save $recordType/$recordName failed: $e');
      return false;
    }
  }

  /// Fetch all records of a given type from CloudKit.
  Future<List<Map<String, dynamic>>> _fetchRecordsByType(
    String recordType,
  ) async {
    if (!isSupported) return [];
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'fetchRecordsByType',
        {'recordType': recordType},
      );
      if (result == null) return [];
      return result
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } on Exception catch (e) {
      debugPrint('[CloudKit] Fetch $recordType failed: $e');
      return [];
    }
  }

  /// Delete a record from CloudKit.
  Future<bool> _deleteRecord(String recordName) async {
    if (!isSupported) return false;
    try {
      final result = await _channel.invokeMethod<bool>(
        'deleteRecord',
        {'recordName': recordName},
      );
      return result ?? false;
    } on Exception catch (e) {
      debugPrint('[CloudKit] Delete $recordName failed: $e');
      return false;
    }
  }


  // ----------------------------------------------------------
  // Profile sync
  // ----------------------------------------------------------

  /// Push a profile record to CloudKit.
  Future<void> pushProfile(Profile profile) async {
    final fields = CloudKitRecordMapper.profileToFields(profile);
    await _saveRecord(
      recordType: CKRecordType.profile,
      recordName: profile.id,
      fields: fields,
    );
    debugPrint('[CloudKit] Pushed profile: ${profile.id}');
  }

  /// Pull all profile records from CloudKit.
  Future<List<Map<String, dynamic>>> pullProfiles() async {
    final records = await _fetchRecordsByType(CKRecordType.profile);
    return records.map((r) {
      final recordName = r['recordName'] as String? ?? '';
      final fields = Map<String, dynamic>.from(
        r['fields'] as Map? ?? {},
      );
      return CloudKitRecordMapper.fieldsToProfileMap(recordName, fields);
    }).toList();
  }

  /// Delete a profile record from CloudKit.
  Future<void> deleteProfile(String id) async {
    await _deleteRecord(id);
  }

  // ----------------------------------------------------------
  // Journal entry sync
  // ----------------------------------------------------------

  /// Push a journal entry to CloudKit.
  Future<void> pushJournalEntry(SaraKalaiJournalData entry) async {
    final fields = CloudKitRecordMapper.journalToFields(entry);
    await _saveRecord(
      recordType: CKRecordType.journalEntry,
      recordName: entry.id,
      fields: fields,
    );
    debugPrint('[CloudKit] Pushed journal entry: ${entry.id}');
  }

  /// Pull all journal entries from CloudKit.
  Future<List<Map<String, dynamic>>> pullJournalEntries() async {
    final records = await _fetchRecordsByType(CKRecordType.journalEntry);
    return records.map((r) {
      final recordName = r['recordName'] as String? ?? '';
      final fields = Map<String, dynamic>.from(
        r['fields'] as Map? ?? {},
      );
      return CloudKitRecordMapper.fieldsToJournalMap(recordName, fields);
    }).toList();
  }

  /// Delete a journal entry from CloudKit.
  Future<void> deleteJournalEntry(String id) async {
    await _deleteRecord(id);
  }


  // ----------------------------------------------------------
  // Breath session sync
  // ----------------------------------------------------------

  /// Push a breath session to CloudKit.
  Future<void> pushBreathSession(BreathSession session) async {
    final fields = CloudKitRecordMapper.sessionToFields(session);
    await _saveRecord(
      recordType: CKRecordType.breathSession,
      recordName: session.id,
      fields: fields,
    );
    debugPrint('[CloudKit] Pushed breath session: ${session.id}');
  }

  /// Pull all breath sessions from CloudKit.
  Future<List<Map<String, dynamic>>> pullBreathSessions() async {
    final records =
        await _fetchRecordsByType(CKRecordType.breathSession);
    return records.map((r) {
      final recordName = r['recordName'] as String? ?? '';
      final fields = Map<String, dynamic>.from(
        r['fields'] as Map? ?? {},
      );
      return CloudKitRecordMapper.fieldsToSessionMap(recordName, fields);
    }).toList();
  }

  /// Delete a breath session from CloudKit.
  Future<void> deleteBreathSession(String id) async {
    await _deleteRecord(id);
  }

  // ----------------------------------------------------------
  // Sync metadata (device registration)
  // ----------------------------------------------------------

  /// Register or update this device in CloudKit.
  Future<void> pushDeviceMetadata(SyncDeviceInfo device) async {
    await _saveRecord(
      recordType: CKRecordType.syncMetadata,
      recordName: device.deviceId,
      fields: {
        CKSyncMetadataFields.deviceId: device.deviceId,
        CKSyncMetadataFields.deviceName: device.deviceName,
        CKSyncMetadataFields.isPrimary: device.isPrimary ? 1 : 0,
        CKSyncMetadataFields.lastSyncTimestamp:
            device.lastSyncTimestamp.millisecondsSinceEpoch,
        CKSyncMetadataFields.platform: device.platform,
      },
    );
  }

  /// Pull all registered device metadata from CloudKit.
  Future<List<SyncDeviceInfo>> pullDeviceMetadata() async {
    final records = await _fetchRecordsByType(CKRecordType.syncMetadata);
    return records.map((r) {
      final fields = Map<String, dynamic>.from(
        r['fields'] as Map? ?? {},
      );
      return SyncDeviceInfo(
        deviceId:
            fields[CKSyncMetadataFields.deviceId] as String? ?? '',
        deviceName:
            fields[CKSyncMetadataFields.deviceName] as String? ??
                'Unknown',
        isPrimary:
            (fields[CKSyncMetadataFields.isPrimary] as int? ?? 0) == 1,
        lastSyncTimestamp: DateTime.fromMillisecondsSinceEpoch(
          fields[CKSyncMetadataFields.lastSyncTimestamp] as int? ?? 0,
        ),
        platform:
            fields[CKSyncMetadataFields.platform] as String? ?? '',
      );
    }).toList();
  }


  // ----------------------------------------------------------
  // Bulk operations
  // ----------------------------------------------------------

  /// Push all local data to CloudKit (full upload).
  Future<SyncResult> pushAll({
    required List<Profile> profiles,
    required List<SaraKalaiJournalData> journalEntries,
    required List<BreathSession> breathSessions,
  }) async {
    if (!isSupported) {
      return const SyncResult(
        success: false,
        message: 'CloudKit not supported on this platform',
      );
    }

    var pushed = 0;
    var errors = 0;

    for (final profile in profiles) {
      try {
        await pushProfile(profile);
        pushed++;
      } on Exception {
        errors++;
      }
    }

    for (final entry in journalEntries) {
      try {
        await pushJournalEntry(entry);
        pushed++;
      } on Exception {
        errors++;
      }
    }

    for (final session in breathSessions) {
      try {
        await pushBreathSession(session);
        pushed++;
      } on Exception {
        errors++;
      }
    }

    return SyncResult(
      success: errors == 0,
      message: 'Pushed $pushed records ($errors errors)',
      recordsPushed: pushed,
      errors: errors,
    );
  }

  /// Pull all remote data from CloudKit.
  Future<PullResult> pullAll() async {
    if (!isSupported) {
      return const PullResult(
        profiles: [],
        journalEntries: [],
        breathSessions: [],
      );
    }

    final profiles = await pullProfiles();
    final journalEntries = await pullJournalEntries();
    final breathSessions = await pullBreathSessions();

    return PullResult(
      profiles: profiles,
      journalEntries: journalEntries,
      breathSessions: breathSessions,
    );
  }
}

/// Result of a sync push operation.
class SyncResult {
  const SyncResult({
    required this.success,
    required this.message,
    this.recordsPushed = 0,
    this.recordsPulled = 0,
    this.errors = 0,
  });

  final bool success;
  final String message;
  final int recordsPushed;
  final int recordsPulled;
  final int errors;
}

/// Result of pulling all data from CloudKit.
class PullResult {
  const PullResult({
    required this.profiles,
    required this.journalEntries,
    required this.breathSessions,
  });

  final List<Map<String, dynamic>> profiles;
  final List<Map<String, dynamic>> journalEntries;
  final List<Map<String, dynamic>> breathSessions;
}
