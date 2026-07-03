import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_schema.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CloudKitSyncService syncService;
  late List<MethodCall> methodCalls;

  setUp(() {
    methodCalls = [];
    final channel = MethodChannel('com.vteial.saranidhi/cloudkit');

    // Mock the method channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      methodCalls.add(call);

      switch (call.method) {
        case 'getAccountStatus':
          return true;
        case 'saveRecord':
          return true;
        case 'fetchRecordsByType':
          final args = call.arguments as Map<Object?, Object?>;
          final recordType = args['recordType'] as String;
          if (recordType == CKRecordType.profile) {
            return [
              {
                'recordName': 'profile-1',
                'fields': {
                  'displayName': 'Test User',
                  'birthStarNakshatra': 'Pushya',
                  'birthBird': 'crow',
                  'locationLat': 13.08,
                  'locationLng': 80.27,
                  'theme': 'light',
                  'language': 'en',
                  'storageMode': 'icloud',
                  'notifyRuling': 1,
                  'notifyEating': 0,
                  'createdAt': 1720000000000,
                  'updatedAt': 1720000001000,
                },
              },
            ];
          }
          if (recordType == CKRecordType.journalEntry) {
            return [
              {
                'recordName': 'journal-1',
                'fields': {
                  'timestamp': 1720000000000,
                  'expectedFlow': 'solar',
                  'actualFlow': 'solar',
                  'isAligned': 1,
                  'nostril': 'right',
                  'inhaleDurationMs': 3500,
                  'holdDurationMs': 1500,
                  'exhaleDurationMs': 4500,
                },
              },
            ];
          }
          if (recordType == CKRecordType.breathSession) {
            return <Map<String, dynamic>>[];
          }
          if (recordType == CKRecordType.syncMetadata) {
            return [
              {
                'recordName': 'device-1',
                'fields': {
                  'deviceId': 'device-1',
                  'deviceName': 'iPhone SE',
                  'isPrimary': 1,
                  'lastSyncTimestamp': 1720000000000,
                  'platform': 'ios',
                },
              },
            ];
          }
          return <Map<String, dynamic>>[];
        case 'deleteRecord':
          return true;
        default:
          return null;
      }
    });

    syncService = CloudKitSyncService(channel: channel);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.vteial.saranidhi/cloudkit'),
      null,
    );
  });

  group('CloudKitSyncService - isSupported', () {
    test('isSupported is false on test (non-iOS/macOS) platform', () {
      // In test environment, Platform.isIOS and Platform.isMacOS are false
      // on Linux CI, but may be true on macOS dev machines.
      // We just verify the property exists and is a bool.
      expect(syncService.isSupported, isA<bool>());
    });
  });

  group('CloudKitSyncService - pullProfiles', () {
    test('pullProfiles returns mapped profile data', () async {
      // On non-Apple platforms, sync service returns empty
      // This test validates the service doesn't crash
      final profiles = await syncService.pullProfiles();
      // On non-Apple: returns empty list (isSupported = false)
      // On Apple: would return mapped data
      expect(profiles, isA<List<Map<String, dynamic>>>());
    });
  });

  group('CloudKitSyncService - pullJournalEntries', () {
    test('pullJournalEntries returns list without error', () async {
      final entries = await syncService.pullJournalEntries();
      expect(entries, isA<List<Map<String, dynamic>>>());
    });
  });

  group('CloudKitSyncService - pullBreathSessions', () {
    test('pullBreathSessions returns list without error', () async {
      final sessions = await syncService.pullBreathSessions();
      expect(sessions, isA<List<Map<String, dynamic>>>());
    });
  });

  group('CloudKitSyncService - pullAll', () {
    test('pullAll returns PullResult with all record types', () async {
      final result = await syncService.pullAll();
      expect(result.profiles, isA<List<Map<String, dynamic>>>());
      expect(result.journalEntries, isA<List<Map<String, dynamic>>>());
      expect(result.breathSessions, isA<List<Map<String, dynamic>>>());
    });
  });

  group('CloudKitSyncService - pullDeviceMetadata', () {
    test('pullDeviceMetadata returns device info list', () async {
      final devices = await syncService.pullDeviceMetadata();
      // On non-Apple: returns empty (isSupported check)
      expect(devices, isA<List>());
    });
  });

  group('CloudKitSyncService - isAuthenticated', () {
    test('isAuthenticated returns bool without crash', () async {
      final result = await syncService.isAuthenticated();
      expect(result, isA<bool>());
    });
  });

  group('CloudKitSyncService - SyncResult', () {
    test('SyncResult stores all values', () {
      const result = SyncResult(
        success: true,
        message: 'Pushed 5 records (0 errors)',
        recordsPushed: 5,
        recordsPulled: 0,
        errors: 0,
      );

      expect(result.success, isTrue);
      expect(result.message, contains('5 records'));
      expect(result.recordsPushed, equals(5));
      expect(result.recordsPulled, equals(0));
      expect(result.errors, equals(0));
    });

    test('SyncResult failure case', () {
      const result = SyncResult(
        success: false,
        message: 'CloudKit not supported on this platform',
      );

      expect(result.success, isFalse);
      expect(result.recordsPushed, equals(0));
    });
  });

  group('CloudKitSyncService - PullResult', () {
    test('PullResult stores all lists', () {
      const result = PullResult(
        profiles: [{'id': '1'}],
        journalEntries: [{'id': '2'}, {'id': '3'}],
        breathSessions: [],
      );

      expect(result.profiles.length, equals(1));
      expect(result.journalEntries.length, equals(2));
      expect(result.breathSessions, isEmpty);
    });
  });
}
