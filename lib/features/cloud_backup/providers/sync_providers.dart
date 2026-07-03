import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_sync_engine.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_sync_service.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_metadata.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';

/// Provides the [CloudKitSyncService] singleton.
final cloudKitSyncServiceProvider = Provider<CloudKitSyncService>((ref) {
  return CloudKitSyncService();
});

/// Provides the [CloudKitSyncEngine] which orchestrates sync.
final cloudKitSyncEngineProvider = Provider<CloudKitSyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncService = ref.watch(cloudKitSyncServiceProvider);
  return CloudKitSyncEngine(db: db, syncService: syncService);
});

/// Manages the iCloud sync state and triggers sync operations.
final syncNotifierProvider =
    NotifierProvider<SyncNotifier, SyncStatus>(SyncNotifier.new);

class SyncNotifier extends Notifier<SyncStatus> {
  @override
  SyncStatus build() {
    return const SyncStatus(state: SyncState.idle);
  }

  /// Trigger a full sync (pull + merge + push).
  ///
  /// Called automatically on app launch when storage mode is iCloud,
  /// or manually from the settings screen.
  Future<void> performSync() async {
    final storageMode = ref.read(storageModeProvider);
    if (storageMode != StorageMode.icloud) {
      state = const SyncStatus(
        state: SyncState.disabled,
        message: 'iCloud sync is not enabled',
      );
      return;
    }

    state = const SyncStatus(state: SyncState.pulling);

    final engine = ref.read(cloudKitSyncEngineProvider);
    final result = await engine.performFullSync();

    state = result;
  }

  /// Set this device as the primary device for conflict resolution.
  Future<void> setPrimaryDevice({required bool isPrimary}) async {
    final engine = ref.read(cloudKitSyncEngineProvider);
    await engine.setPrimaryDevice(isPrimary: isPrimary);
  }

  /// Update the device name shown in sync metadata.
  Future<void> setDeviceName(String name) async {
    final engine = ref.read(cloudKitSyncEngineProvider);
    await engine.setDeviceName(name);
  }

  /// Get information about all devices participating in sync.
  Future<List<SyncDeviceInfo>> getRegisteredDevices() async {
    final syncService = ref.read(cloudKitSyncServiceProvider);
    return syncService.pullDeviceMetadata();
  }
}

/// Provider for the current device's sync info.
final currentDeviceInfoProvider = FutureProvider<SyncDeviceInfo>((ref) async {
  final engine = ref.watch(cloudKitSyncEngineProvider);
  return engine.getDeviceInfo();
});

/// Provider for all registered devices in the sync group.
final registeredDevicesProvider =
    FutureProvider<List<SyncDeviceInfo>>((ref) async {
  final syncService = ref.watch(cloudKitSyncServiceProvider);
  return syncService.pullDeviceMetadata();
});
