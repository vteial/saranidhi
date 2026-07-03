import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:saranidhi/database/app_database.dart';

import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_sync_service.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_metadata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _deviceIdKey = 'sync_device_id';
const _deviceNameKey = 'sync_device_name';
const _isPrimaryKey = 'sync_is_primary';
const _lastSyncKey = 'sync_last_sync_timestamp';

/// Orchestrates the full sync cycle between local Drift DB and CloudKit.
///
/// **Sync strategy:**
/// 1. Pull remote records from CloudKit
/// 2. Merge into local DB using conflict resolution
/// 3. Push local-only records to CloudKit
///
/// **Conflict resolution:**
/// - "Primary device wins" — the device marked as primary has its
///   `updatedAt` (for profiles) or `timestamp` (for entries) take precedence
/// - If this device IS the primary, local always wins
/// - If this device is NOT the primary, remote wins on conflict
/// - A "conflict" is defined as: same record ID exists both locally and
///   remotely with different `updatedAt`/`timestamp` values
class CloudKitSyncEngine {
  CloudKitSyncEngine({
    required this.db,
    required this.syncService,
  });

  final AppDatabase db;
  final CloudKitSyncService syncService;


  /// Get or create the device identifier for this device.
  Future<SyncDeviceInfo> getDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString(_deviceIdKey);
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    final deviceName = prefs.getString(_deviceNameKey) ?? _defaultDeviceName();
    final isPrimary = prefs.getBool(_isPrimaryKey) ?? false;
    final lastSync = prefs.getInt(_lastSyncKey) ?? 0;

    return SyncDeviceInfo(
      deviceId: deviceId,
      deviceName: deviceName,
      isPrimary: isPrimary,
      lastSyncTimestamp: DateTime.fromMillisecondsSinceEpoch(lastSync),
      platform: _currentPlatform(),
    );
  }

  /// Set this device as primary or secondary.
  Future<void> setPrimaryDevice({required bool isPrimary}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPrimaryKey, isPrimary);
  }

  /// Set a custom device name.
  Future<void> setDeviceName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceNameKey, name);
  }


  /// Perform a full sync cycle: pull → merge → push.
  ///
  /// Called on app launch when storage mode is iCloud.
  Future<SyncStatus> performFullSync() async {
    if (!syncService.isSupported) {
      return const SyncStatus(
        state: SyncState.error,
        message: 'CloudKit not supported on this platform',
      );
    }

    final authenticated = await syncService.isAuthenticated();
    if (!authenticated) {
      return const SyncStatus(
        state: SyncState.error,
        message: 'Not signed in to iCloud',
      );
    }

    try {
      // Phase 1: Pull remote data
      final pullResult = await syncService.pullAll();
      final deviceInfo = await getDeviceInfo();

      // Phase 2: Merge remote into local
      final pulled = await _mergeRemoteData(
        pullResult,
        isPrimary: deviceInfo.isPrimary,
      );

      // Phase 3: Push local data to remote
      final profiles = await db.select(db.profiles).get();
      final journal = await db.select(db.saraKalaiJournal).get();
      final sessions = await db.select(db.breathSessions).get();

      final pushResult = await syncService.pushAll(
        profiles: profiles,
        journalEntries: journal,
        breathSessions: sessions,
      );

      // Phase 4: Update device metadata
      final now = DateTime.now();
      await syncService.pushDeviceMetadata(
        SyncDeviceInfo(
          deviceId: deviceInfo.deviceId,
          deviceName: deviceInfo.deviceName,
          isPrimary: deviceInfo.isPrimary,
          lastSyncTimestamp: now,
          platform: deviceInfo.platform,
        ),
      );

      // Save last sync time locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, now.millisecondsSinceEpoch);

      return SyncStatus(
        state: SyncState.synced,
        lastSyncTime: now,
        message: 'Sync complete',
        recordsPulled: pulled,
        recordsPushed: pushResult.recordsPushed,
      );
    } on Exception catch (e) {
      debugPrint('[SyncEngine] Full sync failed: $e');
      return SyncStatus(
        state: SyncState.error,
        message: 'Sync failed: $e',
      );
    }
  }


  /// Merge remote data into local database.
  ///
  /// Returns the number of records merged (inserted or updated).
  Future<int> _mergeRemoteData(
    PullResult remote, {
    required bool isPrimary,
  }) async {
    var merged = 0;

    // Merge profiles
    for (final remoteProfile in remote.profiles) {
      final id = remoteProfile['id'] as String;
      final existing = await (db.select(db.profiles)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

      if (existing == null) {
        // New record from remote — insert
        await db.into(db.profiles).insert(
          ProfilesCompanion.insert(
            id: id,
            displayName: Value(remoteProfile['displayName'] as String? ?? ''),
            birthStarNakshatra:
                Value(remoteProfile['birthStarNakshatra'] as String?),
            birthBird: Value(remoteProfile['birthBird'] as String?),
            locationLat: Value(remoteProfile['locationLat'] as double?),
            locationLng: Value(remoteProfile['locationLng'] as double?),
            theme: Value(remoteProfile['theme'] as String? ?? 'light'),
            language: Value(remoteProfile['language'] as String? ?? 'en'),
            storageMode:
                Value(remoteProfile['storageMode'] as String? ?? 'icloud'),
            notifyRuling:
                Value(remoteProfile['notifyRuling'] as bool? ?? true),
            notifyEating:
                Value(remoteProfile['notifyEating'] as bool? ?? false),
            createdAt: remoteProfile['createdAt'] as int? ?? 0,
            updatedAt: remoteProfile['updatedAt'] as int? ?? 0,
          ),
        );
        merged++;
      } else if (!isPrimary) {
        // Conflict: remote wins (this device is secondary)
        final remoteUpdatedAt = remoteProfile['updatedAt'] as int? ?? 0;
        if (remoteUpdatedAt > existing.updatedAt) {
          await (db.update(db.profiles)
                ..where((t) => t.id.equals(id)))
              .write(
            ProfilesCompanion(
              displayName:
                  Value(remoteProfile['displayName'] as String? ?? ''),
              birthStarNakshatra:
                  Value(remoteProfile['birthStarNakshatra'] as String?),
              birthBird: Value(remoteProfile['birthBird'] as String?),
              locationLat: Value(remoteProfile['locationLat'] as double?),
              locationLng: Value(remoteProfile['locationLng'] as double?),
              theme: Value(remoteProfile['theme'] as String? ?? 'light'),
              language: Value(remoteProfile['language'] as String? ?? 'en'),
              storageMode:
                  Value(remoteProfile['storageMode'] as String? ?? 'icloud'),
              updatedAt: Value(remoteUpdatedAt),
            ),
          );
          merged++;
        }
      }
      // If isPrimary and conflict → local wins, skip remote update
    }

    // Merge journal entries
    for (final remoteEntry in remote.journalEntries) {
      final id = remoteEntry['id'] as String;
      final existing = await (db.select(db.saraKalaiJournal)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

      if (existing == null) {
        // New record from remote — insert
        await db.into(db.saraKalaiJournal).insert(
          SaraKalaiJournalCompanion.insert(
            id: id,
            timestamp: remoteEntry['timestamp'] as int? ?? 0,
            expectedFlow: remoteEntry['expectedFlow'] as String? ?? 'solar',
            actualFlow: remoteEntry['actualFlow'] as String? ?? 'solar',
            isAligned: remoteEntry['isAligned'] as bool? ?? false,
            nostril: remoteEntry['nostril'] as String? ?? 'right',
            inhaleDurationMs:
                Value(remoteEntry['inhaleDurationMs'] as int?),
            holdDurationMs: Value(remoteEntry['holdDurationMs'] as int?),
            exhaleDurationMs:
                Value(remoteEntry['exhaleDurationMs'] as int?),
            activeYama: Value(remoteEntry['activeYama'] as String?),
            activeBird: Value(remoteEntry['activeBird'] as String?),
            activeBirdState:
                Value(remoteEntry['activeBirdState'] as String?),
            activeElement: Value(remoteEntry['activeElement'] as String?),
            notes: Value(remoteEntry['notes'] as String?),
          ),
        );
        merged++;
      }
      // Journal entries are append-only (same ID = same entry, skip)
    }

    // Merge breath sessions
    for (final remoteSession in remote.breathSessions) {
      final id = remoteSession['id'] as String;
      final existing = await (db.select(db.breathSessions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

      if (existing == null) {
        // New record from remote — insert
        await db.into(db.breathSessions).insert(
          BreathSessionsCompanion.insert(
            id: id,
            timestamp: remoteSession['timestamp'] as int? ?? 0,
            totalDurationMs: remoteSession['totalDurationMs'] as int? ?? 0,
            nostril: remoteSession['nostril'] as String? ?? 'right',
            inhaleLengthMs: remoteSession['inhaleLengthMs'] as int? ?? 0,
            holdAfterInhaleMs:
                remoteSession['holdAfterInhaleMs'] as int? ?? 0,
            exhaleLengthMs: remoteSession['exhaleLengthMs'] as int? ?? 0,
            holdAfterExhaleMs:
                remoteSession['holdAfterExhaleMs'] as int? ?? 0,
            completedCycles: remoteSession['completedCycles'] as int? ?? 0,
            mood: Value(remoteSession['mood'] as String?),
            consciousnessRating:
                Value(remoteSession['consciousnessRating'] as int?),
            notes: Value(remoteSession['notes'] as String?),
          ),
        );
        merged++;
      }
      // Breath sessions are append-only (same ID = same session, skip)
    }

    return merged;
  }

  String _defaultDeviceName() {
    if (kIsWeb) return 'Web Browser';
    if (Platform.isIOS) return 'iPhone';
    if (Platform.isMacOS) return 'Mac';
    return 'Unknown Device';
  }

  String _currentPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    return 'unknown';
  }
}
