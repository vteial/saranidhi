import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/cloud_backup/data/cloudkit/cloudkit_schema.dart';

/// Maps between local Drift models and CloudKit record field maps.
///
/// CloudKit stores records as `Map&lt;String, dynamic&gt;`, where keys are field
/// names and values are the stored data. This mapper converts between
/// local typed Drift objects and CloudKit's untyped field maps.
class CloudKitRecordMapper {
  /// Convert a local [Profile] to a CloudKit field map.
  static Map<String, dynamic> profileToFields(Profile profile) => {
    CKProfileFields.displayName: profile.displayName,
    CKProfileFields.birthStarNakshatra: profile.birthStarNakshatra ?? '',
    CKProfileFields.birthBird: profile.birthBird ?? '',
    CKProfileFields.locationLat: profile.locationLat ?? 0.0,
    CKProfileFields.locationLng: profile.locationLng ?? 0.0,
    CKProfileFields.theme: profile.theme,
    CKProfileFields.language: profile.language,
    CKProfileFields.storageMode: profile.storageMode,
    CKProfileFields.notifyRuling: profile.notifyRuling ? 1 : 0,
    CKProfileFields.notifyEating: profile.notifyEating ? 1 : 0,
    CKProfileFields.lastAiNote: profile.lastAiNote ?? '',
    CKProfileFields.lastAiNoteDate: profile.lastAiNoteDate ?? '',
    CKProfileFields.createdAt: profile.createdAt,
    CKProfileFields.updatedAt: profile.updatedAt,
  };

  /// Convert CloudKit fields back to a [ProfilesCompanion] for Drift insert.
  static Map<String, dynamic> fieldsToProfileMap(
    String recordName,
    Map<String, dynamic> fields,
  ) => {
    'id': recordName,
    'displayName': fields[CKProfileFields.displayName] as String? ?? '',
    'birthStarNakshatra':
        _nullableString(fields[CKProfileFields.birthStarNakshatra]),
    'birthBird': _nullableString(fields[CKProfileFields.birthBird]),
    'locationLat': _nullableDouble(fields[CKProfileFields.locationLat]),
    'locationLng': _nullableDouble(fields[CKProfileFields.locationLng]),
    'theme': fields[CKProfileFields.theme] as String? ?? 'light',
    'language': fields[CKProfileFields.language] as String? ?? 'en',
    'storageMode': fields[CKProfileFields.storageMode] as String? ?? 'icloud',
    'notifyRuling': _intToBool(fields[CKProfileFields.notifyRuling]),
    'notifyEating': _intToBool(fields[CKProfileFields.notifyEating]),
    'lastAiNote': _nullableString(fields[CKProfileFields.lastAiNote]),
    'lastAiNoteDate': _nullableString(fields[CKProfileFields.lastAiNoteDate]),
    'createdAt': fields[CKProfileFields.createdAt] as int? ?? 0,
    'updatedAt': fields[CKProfileFields.updatedAt] as int? ?? 0,
  };

  /// Convert a local [SaraKalaiJournalData] to a CloudKit field map.
  static Map<String, dynamic> journalToFields(SaraKalaiJournalData entry) => {
    CKJournalFields.timestamp: entry.timestamp,
    CKJournalFields.expectedFlow: entry.expectedFlow,
    CKJournalFields.actualFlow: entry.actualFlow,
    CKJournalFields.isAligned: entry.isAligned ? 1 : 0,
    CKJournalFields.nostril: entry.nostril,
    CKJournalFields.inhaleDurationMs: entry.inhaleDurationMs ?? 0,
    CKJournalFields.holdDurationMs: entry.holdDurationMs ?? 0,
    CKJournalFields.exhaleDurationMs: entry.exhaleDurationMs ?? 0,
    CKJournalFields.activeYama: entry.activeYama ?? '',
    CKJournalFields.activeBird: entry.activeBird ?? '',
    CKJournalFields.activeBirdState: entry.activeBirdState ?? '',
    CKJournalFields.activeElement: entry.activeElement ?? '',
    CKJournalFields.notes: entry.notes ?? '',
  };

  /// Convert CloudKit fields to a journal entry map for Drift insert.
  static Map<String, dynamic> fieldsToJournalMap(
    String recordName,
    Map<String, dynamic> fields,
  ) => {
    'id': recordName,
    'timestamp': fields[CKJournalFields.timestamp] as int? ?? 0,
    'expectedFlow':
        fields[CKJournalFields.expectedFlow] as String? ?? 'solar',
    'actualFlow': fields[CKJournalFields.actualFlow] as String? ?? 'solar',
    'isAligned': _intToBool(fields[CKJournalFields.isAligned]),
    'nostril': fields[CKJournalFields.nostril] as String? ?? 'right',
    'inhaleDurationMs': _nullableInt(fields[CKJournalFields.inhaleDurationMs]),
    'holdDurationMs': _nullableInt(fields[CKJournalFields.holdDurationMs]),
    'exhaleDurationMs':
        _nullableInt(fields[CKJournalFields.exhaleDurationMs]),
    'activeYama': _nullableString(fields[CKJournalFields.activeYama]),
    'activeBird': _nullableString(fields[CKJournalFields.activeBird]),
    'activeBirdState':
        _nullableString(fields[CKJournalFields.activeBirdState]),
    'activeElement': _nullableString(fields[CKJournalFields.activeElement]),
    'notes': _nullableString(fields[CKJournalFields.notes]),
  };

  /// Convert a local [BreathSession] to a CloudKit field map.
  static Map<String, dynamic> sessionToFields(BreathSession session) => {
    CKBreathSessionFields.timestamp: session.timestamp,
    CKBreathSessionFields.totalDurationMs: session.totalDurationMs,
    CKBreathSessionFields.nostril: session.nostril,
    CKBreathSessionFields.inhaleLengthMs: session.inhaleLengthMs,
    CKBreathSessionFields.holdAfterInhaleMs: session.holdAfterInhaleMs,
    CKBreathSessionFields.exhaleLengthMs: session.exhaleLengthMs,
    CKBreathSessionFields.holdAfterExhaleMs: session.holdAfterExhaleMs,
    CKBreathSessionFields.completedCycles: session.completedCycles,
    CKBreathSessionFields.mood: session.mood ?? '',
    CKBreathSessionFields.consciousnessRating:
        session.consciousnessRating ?? 0,
    CKBreathSessionFields.notes: session.notes ?? '',
  };

  /// Convert CloudKit fields to a breath session map for Drift insert.
  static Map<String, dynamic> fieldsToSessionMap(
    String recordName,
    Map<String, dynamic> fields,
  ) => {
    'id': recordName,
    'timestamp': fields[CKBreathSessionFields.timestamp] as int? ?? 0,
    'totalDurationMs':
        fields[CKBreathSessionFields.totalDurationMs] as int? ?? 0,
    'nostril': fields[CKBreathSessionFields.nostril] as String? ?? 'right',
    'inhaleLengthMs':
        fields[CKBreathSessionFields.inhaleLengthMs] as int? ?? 0,
    'holdAfterInhaleMs':
        fields[CKBreathSessionFields.holdAfterInhaleMs] as int? ?? 0,
    'exhaleLengthMs':
        fields[CKBreathSessionFields.exhaleLengthMs] as int? ?? 0,
    'holdAfterExhaleMs':
        fields[CKBreathSessionFields.holdAfterExhaleMs] as int? ?? 0,
    'completedCycles':
        fields[CKBreathSessionFields.completedCycles] as int? ?? 0,
    'mood': _nullableString(fields[CKBreathSessionFields.mood]),
    'consciousnessRating':
        _nullableInt(fields[CKBreathSessionFields.consciousnessRating]),
    'notes': _nullableString(fields[CKBreathSessionFields.notes]),
  };

  // --- Helpers ---

  static String? _nullableString(dynamic value) {
    if (value == null) return null;
    final str = value.toString();
    return str.isEmpty ? null : str;
  }

  static double? _nullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value == 0.0 ? null : value;
    if (value is int) return value == 0 ? null : value.toDouble();
    return null;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value == 0 ? null : value;
    return null;
  }

  static bool _intToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    return false;
  }
}
