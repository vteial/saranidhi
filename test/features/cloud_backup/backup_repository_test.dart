import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/cloud_backup/data/gdrive_backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/data/icloud_backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/data/local_backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';

void main() {
  group('LocalBackupRepository', () {
    late LocalBackupRepository repo;

    setUp(() {
      repo = LocalBackupRepository();
    });

    test('backup always succeeds', () async {
      final result = await repo.backup([1, 2, 3]);
      expect(result.success, isTrue);
    });

    test('restore returns null (no cloud)', () async {
      final data = await repo.restore();
      expect(data, isNull);
    });

    test('getBackupMetadata returns null', () async {
      final meta = await repo.getBackupMetadata();
      expect(meta, isNull);
    });

    test('isAuthenticated always true', () async {
      expect(await repo.isAuthenticated(), isTrue);
    });
  });

  group('GoogleDriveBackupRepository (stub)', () {
    late GoogleDriveBackupRepository repo;

    setUp(() {
      repo = GoogleDriveBackupRepository();
    });

    test('backup fails when not authenticated', () async {
      final result = await repo.backup([1, 2, 3]);
      expect(result.success, isFalse);
      expect(result.message, contains('Not signed in'));
    });

    test('signIn succeeds (stub)', () async {
      final result = await repo.signIn();
      expect(result, isTrue);
      expect(await repo.isAuthenticated(), isTrue);
    });

    test('backup succeeds after signIn', () async {
      await repo.signIn();
      final result = await repo.backup([1, 2, 3]);
      expect(result.success, isTrue);
      expect(result.sizeBytes, equals(3));
    });

    test('signOut clears auth', () async {
      await repo.signIn();
      await repo.signOut();
      expect(await repo.isAuthenticated(), isFalse);
    });

    test('restore returns null (stub)', () async {
      await repo.signIn();
      final data = await repo.restore();
      expect(data, isNull);
    });
  });

  group('ICloudBackupRepository (stub)', () {
    late ICloudBackupRepository repo;

    setUp(() {
      repo = ICloudBackupRepository();
    });

    test('backup fails when not authenticated', () async {
      final result = await repo.backup([1, 2, 3]);
      expect(result.success, isFalse);
    });

    test('signIn succeeds (stub)', () async {
      final result = await repo.signIn();
      expect(result, isTrue);
    });

    test('backup succeeds after signIn', () async {
      await repo.signIn();
      final result = await repo.backup([4, 5, 6, 7]);
      expect(result.success, isTrue);
      expect(result.sizeBytes, equals(4));
    });

    test('deleteBackup succeeds', () async {
      final result = await repo.deleteBackup();
      expect(result.success, isTrue);
    });
  });

  group('StorageMode', () {
    test('displayName returns correct labels', () {
      expect(StorageMode.local.displayName, equals('Local Only'));
      expect(StorageMode.icloud.displayName, equals('iCloud'));
      expect(StorageMode.gdrive.displayName, equals('Google Drive'));
    });

    test('description is non-empty', () {
      for (final mode in StorageMode.values) {
        expect(mode.description.isNotEmpty, isTrue);
      }
    });
  });
}
