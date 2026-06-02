/// Represents the result of a backup or restore operation.
class BackupResult {
  const BackupResult({
    required this.success,
    this.message,
    this.backupDate,
    this.sizeBytes,
  });

  final bool success;
  final String? message;
  final DateTime? backupDate;
  final int? sizeBytes;
}

/// Metadata about an existing backup in the cloud.
class BackupMetadata {
  const BackupMetadata({
    required this.lastBackupDate,
    required this.sizeBytes,
    required this.storageMode,
  });

  final DateTime lastBackupDate;
  final int sizeBytes;
  final String storageMode;
}

/// The storage mode for cloud backup.
enum StorageMode {
  /// Data stays on device only.
  local,

  /// Backup to iCloud (iOS).
  icloud,

  /// Backup to Google Drive (Android/Web).
  gdrive;

  String get displayName => switch (this) {
    StorageMode.local => 'Local Only',
    StorageMode.icloud => 'iCloud',
    StorageMode.gdrive => 'Google Drive',
  };

  String get description => switch (this) {
    StorageMode.local => 'Data stays on this device only',
    StorageMode.icloud => 'Backup to your iCloud account',
    StorageMode.gdrive => 'Backup to your Google Drive',
  };
}

/// Abstract interface for cloud backup operations.
///
/// Implementations:
/// - `LocalBackupRepository` — no-op (local only mode)
/// - `ICloudBackupRepository` — iOS iCloud backup (future)
/// - `GoogleDriveBackupRepository` — Android/Web Google Drive (future)
abstract class CloudBackupRepository {
  /// Backs up the database to the cloud provider.
  Future<BackupResult> backup(List<int> encryptedData);

  /// Restores the database from the cloud provider.
  /// Returns the encrypted bytes, or null if no backup exists.
  Future<List<int>?> restore();

  /// Checks if a backup exists and returns its metadata.
  Future<BackupMetadata?> getBackupMetadata();

  /// Deletes the existing backup from the cloud.
  Future<BackupResult> deleteBackup();

  /// Whether the user is authenticated with this provider.
  Future<bool> isAuthenticated();

  /// Signs in to the cloud provider.
  Future<bool> signIn();

  /// Signs out from the cloud provider.
  Future<void> signOut();
}
