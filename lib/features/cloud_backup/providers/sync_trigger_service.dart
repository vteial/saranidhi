import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_sync_service.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/sync_providers.dart';

/// Service that triggers CloudKit push after local database writes.
///
/// Call methods on this service after CRUD operations on local data.
/// It checks whether iCloud sync is enabled before pushing, and
/// handles errors gracefully (push failures are logged, not thrown).
///
/// Usage from a Notifier/Provider:
/// ```dart
/// final trigger = ref.read(syncTriggerServiceProvider);
/// await trigger.onJournalEntryCreated(entry);
/// ```
final syncTriggerServiceProvider = Provider<SyncTriggerService>((ref) {
  return SyncTriggerService(ref);
});

class SyncTriggerService {
  SyncTriggerService(this._ref);

  final Ref _ref;

  /// Whether sync should fire (iCloud mode + supported platform).
  bool get _shouldSync {
    final mode = _ref.read(storageModeProvider);
    return mode == StorageMode.icloud;
  }

  CloudKitSyncService get _syncService {
    return _ref.read(cloudKitSyncServiceProvider);
  }

  // ----------------------------------------------------------
  // Journal entries
  // ----------------------------------------------------------

  /// Push a newly created journal entry to CloudKit.
  Future<void> onJournalEntryCreated(SaraKalaiJournalData entry) async {
    if (!_shouldSync) return;
    try {
      await _syncService.pushJournalEntry(entry);
    } catch (e) {
      debugPrint('[SyncTrigger] Push journal entry failed: $e');
    }
  }

  /// Push after a journal entry is deleted locally.
  Future<void> onJournalEntryDeleted(String entryId) async {
    if (!_shouldSync) return;
    try {
      await _syncService.deleteJournalEntry(entryId);
    } catch (e) {
      debugPrint('[SyncTrigger] Delete journal entry from CK failed: $e');
    }
  }

  // ----------------------------------------------------------
  // Breath sessions
  // ----------------------------------------------------------

  /// Push a newly created breath session to CloudKit.
  Future<void> onBreathSessionCreated(BreathSession session) async {
    if (!_shouldSync) return;
    try {
      await _syncService.pushBreathSession(session);
    } catch (e) {
      debugPrint('[SyncTrigger] Push breath session failed: $e');
    }
  }

  /// Push after a breath session is deleted locally.
  Future<void> onBreathSessionDeleted(String sessionId) async {
    if (!_shouldSync) return;
    try {
      await _syncService.deleteBreathSession(sessionId);
    } catch (e) {
      debugPrint('[SyncTrigger] Delete breath session from CK failed: $e');
    }
  }

  // ----------------------------------------------------------
  // Profile
  // ----------------------------------------------------------

  /// Push profile changes to CloudKit.
  Future<void> onProfileUpdated(Profile profile) async {
    if (!_shouldSync) return;
    try {
      await _syncService.pushProfile(profile);
    } catch (e) {
      debugPrint('[SyncTrigger] Push profile failed: $e');
    }
  }
}
