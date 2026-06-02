import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';

/// No-op backup repository for local-only mode.
///
/// All operations return success without doing anything.
class LocalBackupRepository implements CloudBackupRepository {
  @override
  Future<BackupResult> backup(List<int> encryptedData) async {
    return const BackupResult(
      success: true,
      message: 'Local mode — data stays on device',
    );
  }

  @override
  Future<List<int>?> restore() async => null;

  @override
  Future<BackupMetadata?> getBackupMetadata() async => null;

  @override
  Future<BackupResult> deleteBackup() async {
    return const BackupResult(
      success: true,
      message: 'No cloud backup to delete in local mode',
    );
  }

  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<bool> signIn() async => true;

  @override
  Future<void> signOut() async {}
}
