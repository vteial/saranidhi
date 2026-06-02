import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/cloud_backup/data/gdrive_backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/data/icloud_backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/data/local_backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageModeKey = 'storage_mode';

/// Provides the current storage mode.
final storageModeProvider = NotifierProvider<StorageModeNotifier, StorageMode>(
  StorageModeNotifier.new,
);

class StorageModeNotifier extends Notifier<StorageMode> {
  @override
  StorageMode build() {
    _loadFromPrefs();
    return StorageMode.local;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageModeKey);
    if (saved != null) {
      state = StorageMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => StorageMode.local,
      );
    }
  }

  Future<void> setMode(StorageMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageModeKey, mode.name);
  }
}

/// Provides the appropriate [CloudBackupRepository] based on storage mode.
final backupRepositoryProvider = Provider<CloudBackupRepository>((ref) {
  final mode = ref.watch(storageModeProvider);
  return switch (mode) {
    StorageMode.local => LocalBackupRepository(),
    StorageMode.icloud => ICloudBackupRepository(),
    StorageMode.gdrive => GoogleDriveBackupRepository(),
  };
});

/// Provides the [DatabaseExporter] instance.
final databaseExporterProvider = Provider<DatabaseExporter>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DatabaseExporter(db);
});

/// State for backup operations.
class BackupState {
  const BackupState({
    this.isBackingUp = false,
    this.isRestoring = false,
    this.lastResult,
    this.metadata,
  });

  final bool isBackingUp;
  final bool isRestoring;
  final BackupResult? lastResult;
  final BackupMetadata? metadata;
}

/// Manages backup/restore operations.
final backupNotifierProvider = NotifierProvider<BackupNotifier, BackupState>(
  BackupNotifier.new,
);

class BackupNotifier extends Notifier<BackupState> {
  @override
  BackupState build() {
    _loadMetadata();
    return const BackupState();
  }

  Future<void> _loadMetadata() async {
    final repo = ref.read(backupRepositoryProvider);
    final metadata = await repo.getBackupMetadata();
    state = BackupState(metadata: metadata);
  }

  Future<void> performBackup() async {
    state = BackupState(isBackingUp: true, metadata: state.metadata);

    final exporter = ref.read(databaseExporterProvider);
    final repo = ref.read(backupRepositoryProvider);

    final bytes = await exporter.exportToBytes();
    final result = await repo.backup(bytes);

    final metadata = result.success ? await repo.getBackupMetadata() : null;
    state = BackupState(lastResult: result, metadata: metadata);
  }

  Future<void> performRestore() async {
    state = BackupState(isRestoring: true, metadata: state.metadata);

    final repo = ref.read(backupRepositoryProvider);
    final bytes = await repo.restore();

    if (bytes == null) {
      state = BackupState(
        lastResult: const BackupResult(
          success: false,
          message: 'No backup found to restore',
        ),
        metadata: state.metadata,
      );
      return;
    }

    final exporter = ref.read(databaseExporterProvider);
    final restoredBytes = bytes;
    await exporter.importFromBytes(
      restoredBytes is Uint8List
          ? restoredBytes
          : Uint8List.fromList(restoredBytes),
    );

    state = BackupState(
      lastResult: const BackupResult(
        success: true,
        message: 'Data restored successfully',
      ),
      metadata: state.metadata,
    );
  }
}
