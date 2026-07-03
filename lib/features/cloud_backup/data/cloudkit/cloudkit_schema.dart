/// CloudKit record type definitions mapping to local Drift tables.
///
/// Each record type corresponds to a local database table.
/// Field names are camelCase to match CloudKit conventions.
library;

/// CloudKit container identifier for Saranidhi.
const cloudKitContainerId = 'iCloud.com.vteial.saranidhi';

/// Record type names in CloudKit.
abstract class CKRecordType {
  static const profile = 'Profile';
  static const journalEntry = 'JournalEntry';
  static const breathSession = 'BreathSession';
  static const syncMetadata = 'SyncMetadata';
}

/// Field mappings for the Profile record type.
///
/// Corresponds to local `profiles` table in Drift.
abstract class CKProfileFields {
  static const displayName = 'displayName';
  static const birthStarNakshatra = 'birthStarNakshatra';
  static const birthBird = 'birthBird';
  static const locationLat = 'locationLat';
  static const locationLng = 'locationLng';
  static const theme = 'theme';
  static const language = 'language';
  static const storageMode = 'storageMode';
  static const notifyRuling = 'notifyRuling';
  static const notifyEating = 'notifyEating';
  static const lastAiNote = 'lastAiNote';
  static const lastAiNoteDate = 'lastAiNoteDate';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

/// Field mappings for the JournalEntry record type.
///
/// Corresponds to local `sara_kalai_journal` table in Drift.
abstract class CKJournalFields {
  static const timestamp = 'timestamp';
  static const expectedFlow = 'expectedFlow';
  static const actualFlow = 'actualFlow';
  static const isAligned = 'isAligned';
  static const nostril = 'nostril';
  static const inhaleDurationMs = 'inhaleDurationMs';
  static const holdDurationMs = 'holdDurationMs';
  static const exhaleDurationMs = 'exhaleDurationMs';
  static const activeYama = 'activeYama';
  static const activeBird = 'activeBird';
  static const activeBirdState = 'activeBirdState';
  static const activeElement = 'activeElement';
  static const notes = 'notes';
}

/// Field mappings for the BreathSession record type.
///
/// Corresponds to local `breath_sessions` table in Drift.
abstract class CKBreathSessionFields {
  static const timestamp = 'timestamp';
  static const totalDurationMs = 'totalDurationMs';
  static const nostril = 'nostril';
  static const inhaleLengthMs = 'inhaleLengthMs';
  static const holdAfterInhaleMs = 'holdAfterInhaleMs';
  static const exhaleLengthMs = 'exhaleLengthMs';
  static const holdAfterExhaleMs = 'holdAfterExhaleMs';
  static const completedCycles = 'completedCycles';
  static const mood = 'mood';
  static const consciousnessRating = 'consciousnessRating';
  static const notes = 'notes';
}

/// Field mappings for SyncMetadata (device registration + conflict resolution).
abstract class CKSyncMetadataFields {
  static const deviceId = 'deviceId';
  static const deviceName = 'deviceName';
  static const isPrimary = 'isPrimary';
  static const lastSyncTimestamp = 'lastSyncTimestamp';
  static const platform = 'platform';
}
