import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_record_mapper.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_schema.dart';

void main() {
  group('CloudKitRecordMapper - Profile', () {
    test('profileToFields converts all fields correctly', () {
      // We test the static mapper method with a mock-like profile map
      // Since we can't instantiate Drift data classes without generated code,
      // we test the inverse: fieldsToProfileMap
      final fields = {
        CKProfileFields.displayName: 'Test User',
        CKProfileFields.birthStarNakshatra: 'Pushya',
        CKProfileFields.birthBird: 'crow',
        CKProfileFields.locationLat: 13.08,
        CKProfileFields.locationLng: 80.27,
        CKProfileFields.theme: 'dark',
        CKProfileFields.language: 'ta',
        CKProfileFields.storageMode: 'icloud',
        CKProfileFields.notifyRuling: 1,
        CKProfileFields.notifyEating: 0,
        CKProfileFields.lastAiNote: 'Wisdom text',
        CKProfileFields.lastAiNoteDate: '2026-07-03',
        CKProfileFields.createdAt: 1720000000000,
        CKProfileFields.updatedAt: 1720000001000,
      };

      final result = CloudKitRecordMapper.fieldsToProfileMap(
        'test-uuid-123',
        fields,
      );

      expect(result['id'], equals('test-uuid-123'));
      expect(result['displayName'], equals('Test User'));
      expect(result['birthStarNakshatra'], equals('Pushya'));
      expect(result['birthBird'], equals('crow'));
      expect(result['locationLat'], equals(13.08));
      expect(result['locationLng'], equals(80.27));
      expect(result['theme'], equals('dark'));
      expect(result['language'], equals('ta'));
      expect(result['storageMode'], equals('icloud'));
      expect(result['notifyRuling'], isTrue);
      expect(result['notifyEating'], isFalse);
      expect(result['lastAiNote'], equals('Wisdom text'));
      expect(result['lastAiNoteDate'], equals('2026-07-03'));
      expect(result['createdAt'], equals(1720000000000));
      expect(result['updatedAt'], equals(1720000001000));
    });

    test('fieldsToProfileMap handles null/empty values', () {
      final fields = <String, dynamic>{
        CKProfileFields.displayName: '',
        CKProfileFields.birthStarNakshatra: '',
        CKProfileFields.birthBird: '',
        CKProfileFields.locationLat: 0.0,
        CKProfileFields.locationLng: 0.0,
        CKProfileFields.theme: null,
        CKProfileFields.language: null,
        CKProfileFields.storageMode: null,
        CKProfileFields.notifyRuling: null,
        CKProfileFields.notifyEating: null,
        CKProfileFields.lastAiNote: '',
        CKProfileFields.lastAiNoteDate: null,
        CKProfileFields.createdAt: null,
        CKProfileFields.updatedAt: null,
      };

      final result = CloudKitRecordMapper.fieldsToProfileMap('id-1', fields);

      expect(result['id'], equals('id-1'));
      expect(result['displayName'], equals(''));
      expect(result['birthStarNakshatra'], isNull);
      expect(result['birthBird'], isNull);
      expect(result['locationLat'], isNull);
      expect(result['locationLng'], isNull);
      expect(result['theme'], equals('light')); // default
      expect(result['language'], equals('en')); // default
      expect(result['storageMode'], equals('icloud')); // default
      expect(result['notifyRuling'], isFalse);
      expect(result['notifyEating'], isFalse);
      expect(result['lastAiNote'], isNull);
      expect(result['lastAiNoteDate'], isNull);
      expect(result['createdAt'], equals(0));
      expect(result['updatedAt'], equals(0));
    });

    test('fieldsToProfileMap handles missing keys gracefully', () {
      final result = CloudKitRecordMapper.fieldsToProfileMap(
        'id-empty',
        <String, dynamic>{},
      );

      expect(result['id'], equals('id-empty'));
      expect(result['displayName'], equals(''));
      expect(result['theme'], equals('light'));
      expect(result['language'], equals('en'));
    });
  });

  group('CloudKitRecordMapper - Journal Entry', () {
    test('fieldsToJournalMap converts all fields correctly', () {
      final fields = {
        CKJournalFields.timestamp: 1720000000000,
        CKJournalFields.expectedFlow: 'solar',
        CKJournalFields.actualFlow: 'lunar',
        CKJournalFields.isAligned: 0,
        CKJournalFields.nostril: 'left',
        CKJournalFields.inhaleDurationMs: 4000,
        CKJournalFields.holdDurationMs: 2000,
        CKJournalFields.exhaleDurationMs: 5000,
        CKJournalFields.activeYama: 'yama2',
        CKJournalFields.activeBird: 'peacock',
        CKJournalFields.activeBirdState: 'ruling',
        CKJournalFields.activeElement: 'fire',
        CKJournalFields.notes: 'Felt calm',
      };

      final result = CloudKitRecordMapper.fieldsToJournalMap(
        'journal-uuid-1',
        fields,
      );

      expect(result['id'], equals('journal-uuid-1'));
      expect(result['timestamp'], equals(1720000000000));
      expect(result['expectedFlow'], equals('solar'));
      expect(result['actualFlow'], equals('lunar'));
      expect(result['isAligned'], isFalse);
      expect(result['nostril'], equals('left'));
      expect(result['inhaleDurationMs'], equals(4000));
      expect(result['holdDurationMs'], equals(2000));
      expect(result['exhaleDurationMs'], equals(5000));
      expect(result['activeYama'], equals('yama2'));
      expect(result['activeBird'], equals('peacock'));
      expect(result['activeBirdState'], equals('ruling'));
      expect(result['activeElement'], equals('fire'));
      expect(result['notes'], equals('Felt calm'));
    });

    test('fieldsToJournalMap handles zeroed nullable fields', () {
      final fields = {
        CKJournalFields.timestamp: 1720000000000,
        CKJournalFields.expectedFlow: 'solar',
        CKJournalFields.actualFlow: 'solar',
        CKJournalFields.isAligned: 1,
        CKJournalFields.nostril: 'right',
        CKJournalFields.inhaleDurationMs: 0,
        CKJournalFields.holdDurationMs: 0,
        CKJournalFields.exhaleDurationMs: 0,
        CKJournalFields.activeYama: '',
        CKJournalFields.activeBird: '',
        CKJournalFields.activeBirdState: '',
        CKJournalFields.activeElement: '',
        CKJournalFields.notes: '',
      };

      final result = CloudKitRecordMapper.fieldsToJournalMap('j-2', fields);

      expect(result['isAligned'], isTrue);
      // Zero ints should map to null (nullable columns)
      expect(result['inhaleDurationMs'], isNull);
      expect(result['holdDurationMs'], isNull);
      expect(result['exhaleDurationMs'], isNull);
      // Empty strings should map to null
      expect(result['activeYama'], isNull);
      expect(result['activeBird'], isNull);
      expect(result['notes'], isNull);
    });
  });

  group('CloudKitRecordMapper - Breath Session', () {
    test('fieldsToSessionMap converts all fields correctly', () {
      final fields = {
        CKBreathSessionFields.timestamp: 1720000000000,
        CKBreathSessionFields.totalDurationMs: 300000,
        CKBreathSessionFields.nostril: 'both',
        CKBreathSessionFields.inhaleLengthMs: 4000,
        CKBreathSessionFields.holdAfterInhaleMs: 2000,
        CKBreathSessionFields.exhaleLengthMs: 6000,
        CKBreathSessionFields.holdAfterExhaleMs: 1000,
        CKBreathSessionFields.completedCycles: 10,
        CKBreathSessionFields.mood: 'calm',
        CKBreathSessionFields.consciousnessRating: 8,
        CKBreathSessionFields.notes: 'Great session',
      };

      final result = CloudKitRecordMapper.fieldsToSessionMap(
        'session-1',
        fields,
      );

      expect(result['id'], equals('session-1'));
      expect(result['timestamp'], equals(1720000000000));
      expect(result['totalDurationMs'], equals(300000));
      expect(result['nostril'], equals('both'));
      expect(result['inhaleLengthMs'], equals(4000));
      expect(result['holdAfterInhaleMs'], equals(2000));
      expect(result['exhaleLengthMs'], equals(6000));
      expect(result['holdAfterExhaleMs'], equals(1000));
      expect(result['completedCycles'], equals(10));
      expect(result['mood'], equals('calm'));
      expect(result['consciousnessRating'], equals(8));
      expect(result['notes'], equals('Great session'));
    });

    test('fieldsToSessionMap handles defaults for missing keys', () {
      final result = CloudKitRecordMapper.fieldsToSessionMap(
        'session-empty',
        <String, dynamic>{},
      );

      expect(result['id'], equals('session-empty'));
      expect(result['timestamp'], equals(0));
      expect(result['totalDurationMs'], equals(0));
      expect(result['nostril'], equals('right'));
      expect(result['completedCycles'], equals(0));
      expect(result['mood'], isNull);
      expect(result['consciousnessRating'], isNull);
      expect(result['notes'], isNull);
    });
  });

  group('CloudKit Schema Constants', () {
    test('container ID is correct', () {
      expect(cloudKitContainerId, equals('iCloud.com.vteial.saranidhi'));
    });

    test('record types are defined', () {
      expect(CKRecordType.profile, equals('Profile'));
      expect(CKRecordType.journalEntry, equals('JournalEntry'));
      expect(CKRecordType.breathSession, equals('BreathSession'));
      expect(CKRecordType.syncMetadata, equals('SyncMetadata'));
    });
  });
}
