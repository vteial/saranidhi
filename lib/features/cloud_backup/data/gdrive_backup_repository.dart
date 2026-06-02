import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';

/// Stub implementation for Google Drive backup (Android/Web).
///
/// Replace with real Google Drive implementation when:
/// - Google Cloud Console project is configured
/// - OAuth client ID is set up
/// - `googleapis` / `google_sign_in` packages are integrated
class GoogleDriveBackupRepository implements CloudBackupRepository {
  bool _authenticated = false;

  @override
  Future<BackupResult> backup(List<int> encryptedData) async {
    if (!_authenticated) {
      return const BackupResult(
        success: false,
        message: 'Not signed in to Google',
      );
    }

    // TODO(sprint5): Upload encryptedData to Google Drive App Data folder
    return BackupResult(
      success: true,
      message: 'Backup uploaded to Google Drive (stub)',
      backupDate: DateTime.now(),
      sizeBytes: encryptedData.length,
    );
  }

  @override
  Future<List<int>?> restore() async {
    if (!_authenticated) return null;

    // TODO(sprint5): Download from Google Drive App Data folder
    return null; // No backup found (stub)
  }

  @override
  Future<BackupMetadata?> getBackupMetadata() async {
    if (!_authenticated) return null;

    // TODO(sprint5): Query Google Drive for backup file metadata
    return null;
  }

  @override
  Future<BackupResult> deleteBackup() async {
    // TODO(sprint5): Delete backup from Google Drive
    return const BackupResult(
      success: true,
      message: 'Google Drive backup deleted (stub)',
    );
  }

  @override
  Future<bool> isAuthenticated() async => _authenticated;

  @override
  Future<bool> signIn() async {
    // TODO(sprint5): Google Sign-In via `google_sign_in` package
    _authenticated = true;
    return true;
  }

  @override
  Future<void> signOut() async {
    _authenticated = false;
  }
}
