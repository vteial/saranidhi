import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_metadata.dart';

void main() {
  group('SyncDeviceInfo', () {
    test('creates with all required fields', () {
      final device = SyncDeviceInfo(
        deviceId: 'uuid-device-1',
        deviceName: 'iPhone SE',
        isPrimary: true,
        lastSyncTimestamp: DateTime(2026, 7, 3, 10, 30),
        platform: 'ios',
      );

      expect(device.deviceId, equals('uuid-device-1'));
      expect(device.deviceName, equals('iPhone SE'));
      expect(device.isPrimary, isTrue);
      expect(device.lastSyncTimestamp, equals(DateTime(2026, 7, 3, 10, 30)));
      expect(device.platform, equals('ios'));
    });

    test('secondary device has isPrimary false', () {
      final device = SyncDeviceInfo(
        deviceId: 'uuid-device-2',
        deviceName: 'iMac',
        isPrimary: false,
        lastSyncTimestamp: DateTime(2026, 7, 2),
        platform: 'macos',
      );

      expect(device.isPrimary, isFalse);
      expect(device.platform, equals('macos'));
    });
  });

  group('SyncState', () {
    test('all states are distinct', () {
      final states = SyncState.values;
      expect(states.length, equals(6));
      expect(states.toSet().length, equals(6));
    });

    test('enum values match expected names', () {
      expect(SyncState.disabled.name, equals('disabled'));
      expect(SyncState.idle.name, equals('idle'));
      expect(SyncState.pulling.name, equals('pulling'));
      expect(SyncState.pushing.name, equals('pushing'));
      expect(SyncState.synced.name, equals('synced'));
      expect(SyncState.error.name, equals('error'));
    });
  });

  group('SyncStatus', () {
    test('default constructor sets state', () {
      const status = SyncStatus(state: SyncState.idle);

      expect(status.state, equals(SyncState.idle));
      expect(status.lastSyncTime, isNull);
      expect(status.message, isNull);
      expect(status.recordsPushed, equals(0));
      expect(status.recordsPulled, equals(0));
    });

    test('synced status with all fields', () {
      final now = DateTime.now();
      final status = SyncStatus(
        state: SyncState.synced,
        lastSyncTime: now,
        message: 'Sync complete',
        recordsPushed: 5,
        recordsPulled: 3,
      );

      expect(status.state, equals(SyncState.synced));
      expect(status.lastSyncTime, equals(now));
      expect(status.message, equals('Sync complete'));
      expect(status.recordsPushed, equals(5));
      expect(status.recordsPulled, equals(3));
    });

    test('error status with message', () {
      const status = SyncStatus(
        state: SyncState.error,
        message: 'Network unavailable',
      );

      expect(status.state, equals(SyncState.error));
      expect(status.message, equals('Network unavailable'));
    });

    test('copyWith updates specified fields', () {
      const original = SyncStatus(
        state: SyncState.idle,
        message: 'Ready',
      );

      final updated = original.copyWith(
        state: SyncState.pulling,
        message: 'Pulling...',
      );

      expect(updated.state, equals(SyncState.pulling));
      expect(updated.message, equals('Pulling...'));
      // Unchanged fields retain original values
      expect(updated.recordsPushed, equals(0));
      expect(updated.recordsPulled, equals(0));
    });

    test('copyWith preserves fields when not specified', () {
      final now = DateTime.now();
      final original = SyncStatus(
        state: SyncState.synced,
        lastSyncTime: now,
        message: 'Done',
        recordsPushed: 10,
        recordsPulled: 7,
      );

      final updated = original.copyWith(state: SyncState.idle);

      expect(updated.state, equals(SyncState.idle));
      expect(updated.lastSyncTime, equals(now));
      expect(updated.message, equals('Done'));
      expect(updated.recordsPushed, equals(10));
      expect(updated.recordsPulled, equals(7));
    });
  });
}
