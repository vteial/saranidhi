import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:saranidhi/core/utils/app_constants.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences keys exported as part of a full data export.
const _exportedPrefKeys = [
  'theme_accent',
  'theme_brightness',
  'app_locale',
  'storage_mode',
  'notify_ruling',
  'notify_eating',
  'notify_rahu_kaal',
  'notify_morning_summary',
  'onboarding_complete',
];

/// Handles exporting and importing the database as encrypted bytes.
///
/// The export format is a JSON representation of all tables plus
/// user preferences, encoded to UTF-8 bytes. In production, these bytes
/// would be encrypted before upload (encryption layer to be added
/// with a user-derived key in a future sprint).
class DatabaseExporter {
  DatabaseExporter(this._db);

  final AppDatabase _db;

  /// Exports all database tables and user preferences to a JSON-encoded
  /// byte array.
  ///
  /// Returns the raw bytes ready for encryption and upload, or for
  /// direct file download/share.
  Future<Uint8List> exportToBytes() async {
    // Export all tables as lists of maps
    final profiles = await _db.select(_db.profiles).get();
    final journal = await _db.select(_db.saraKalaiJournal).get();
    final sessions = await _db.select(_db.breathSessions).get();
    final birds = await _db.select(_db.birdLibrary).get();
    final prasanam = await _db.select(_db.prasanamHistory).get();

    // Export user preferences from SharedPreferences
    final preferences = await _exportPreferences();

    final exportData = <String, dynamic>{
      'version': AppConstants.exportVersion,
      'appVersion': AppConstants.appVersion,
      'schemaVersion': AppConstants.schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'profiles': profiles.map(_profileToMap).toList(),
      'journal': journal.map(_journalToMap).toList(),
      'sessions': sessions.map(_sessionToMap).toList(),
      'birds': birds.map(_birdToMap).toList(),
      'prasanam': prasanam.map(_prasanamToMap).toList(),
      'preferences': preferences,
    };

    final jsonStr = jsonEncode(exportData);
    return Uint8List.fromList(utf8.encode(jsonStr));
  }

  /// Exports all data as a formatted JSON string (for human-readable
  /// file download).
  Future<String> exportToJsonString() async {
    final bytes = await exportToBytes();
    final jsonStr = utf8.decode(bytes);
    // Re-encode with indentation for readability
    final data = jsonDecode(jsonStr);
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Imports data from a JSON-encoded byte array into the database.
  ///
  /// This replaces all existing data (destructive import).
  /// Also restores user preferences from the export.
  Future<void> importFromBytes(Uint8List bytes) async {
    final jsonStr = utf8.decode(bytes);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    // Validate version
    final version = data['version'] as int?;
    if (version == null || version > 1) {
      throw FormatException('Unsupported backup version: $version');
    }

    // Clear existing data
    await _db.delete(_db.saraKalaiJournal).go();
    await _db.delete(_db.breathSessions).go();
    await _db.delete(_db.birdLibrary).go();
    await _db.delete(_db.prasanamHistory).go();
    await _db.delete(_db.profiles).go();

    // Import profiles
    final profilesList = data['profiles'] as List<dynamic>? ?? [];
    for (final p in profilesList) {
      final map = p as Map<String, dynamic>;
      await _db.into(_db.profiles).insert(
        ProfilesCompanion.insert(
          id: map['id'] as String,
          displayName: Value(map['displayName'] as String? ?? ''),
          birthStarNakshatra: Value(map['birthStarNakshatra'] as String?),
          birthBird: Value(map['birthBird'] as String?),
          locationLat: Value(map['locationLat'] as double?),
          locationLng: Value(map['locationLng'] as double?),
          birthDateEpoch: Value(map['birthDateEpoch'] as int?),
          birthTime: Value(map['birthTime'] as String?),
          birthPlaceName: Value(map['birthPlaceName'] as String?),
          birthPlaceLat: Value(map['birthPlaceLat'] as double?),
          birthPlaceLng: Value(map['birthPlaceLng'] as double?),
          theme: Value(map['theme'] as String? ?? 'light'),
          language: Value(map['language'] as String? ?? 'en'),
          storageMode: Value(map['storageMode'] as String? ?? 'local'),
          notifyRuling: Value(map['notifyRuling'] as bool? ?? true),
          notifyEating: Value(map['notifyEating'] as bool? ?? false),
          lastAiNote: Value(map['lastAiNote'] as String?),
          lastAiNoteDate: Value(map['lastAiNoteDate'] as String?),
          createdAt: map['createdAt'] as int,
          updatedAt: map['updatedAt'] as int,
        ),
      );
    }

    // Import journal entries
    final journalList = data['journal'] as List<dynamic>? ?? [];
    for (final j in journalList) {
      final map = j as Map<String, dynamic>;
      await _db.into(_db.saraKalaiJournal).insert(
        SaraKalaiJournalCompanion.insert(
          id: map['id'] as String,
          timestamp: map['timestamp'] as int,
          expectedFlow: map['expectedFlow'] as String,
          actualFlow: map['actualFlow'] as String,
          isAligned: map['isAligned'] as bool,
          nostril: map['nostril'] as String,
          inhaleDurationMs: Value(map['inhaleDurationMs'] as int?),
          holdDurationMs: Value(map['holdDurationMs'] as int?),
          exhaleDurationMs: Value(map['exhaleDurationMs'] as int?),
          activeYama: Value(map['activeYama'] as String?),
          activeBird: Value(map['activeBird'] as String?),
          activeBirdState: Value(map['activeBirdState'] as String?),
          activeElement: Value(map['activeElement'] as String?),
          notes: Value(map['notes'] as String?),
          isPinned: Value(map['isPinned'] as bool? ?? false),
        ),
      );
    }

    // Import breath sessions
    final sessionsList = data['sessions'] as List<dynamic>? ?? [];
    for (final s in sessionsList) {
      final map = s as Map<String, dynamic>;
      await _db.into(_db.breathSessions).insert(
        BreathSessionsCompanion.insert(
          id: map['id'] as String,
          timestamp: map['timestamp'] as int,
          totalDurationMs: map['totalDurationMs'] as int,
          nostril: map['nostril'] as String,
          inhaleLengthMs: map['inhaleLengthMs'] as int,
          holdAfterInhaleMs: map['holdAfterInhaleMs'] as int,
          exhaleLengthMs: map['exhaleLengthMs'] as int,
          holdAfterExhaleMs: map['holdAfterExhaleMs'] as int,
          completedCycles: map['completedCycles'] as int,
          mood: Value(map['mood'] as String?),
          consciousnessRating: Value(map['consciousnessRating'] as int?),
          notes: Value(map['notes'] as String?),
        ),
      );
    }

    // Import bird library
    final birdsList = data['birds'] as List<dynamic>? ?? [];
    for (final b in birdsList) {
      final map = b as Map<String, dynamic>;
      await _db.into(_db.birdLibrary).insert(
        BirdLibraryCompanion.insert(
          id: map['id'] as String,
          birdName: map['birdName'] as String,
          nakshatraGroup: map['nakshatraGroup'] as String,
          favorited: Value(map['favorited'] as bool? ?? false),
        ),
      );
    }

    // Import Prasanam history
    final prasanamList = data['prasanam'] as List<dynamic>? ?? [];
    for (final p in prasanamList) {
      final map = p as Map<String, dynamic>;
      await _db.into(_db.prasanamHistory).insert(
        PrasanamHistoryCompanion.insert(
          id: map['id'] as String,
          timestamp: map['timestamp'] as int,
          category: map['category'] as String,
          queryText: Value(map['queryText'] as String? ?? ''),
          score: map['score'] as int,
          band: map['band'] as String,
          guidanceEn: map['guidanceEn'] as String,
          guidanceTa: map['guidanceTa'] as String,
          isFloorLocked: Value(map['isFloorLocked'] as bool? ?? false),
          swara: Value(map['swara'] as String?),
          birdState: Value(map['birdState'] as String?),
          actionWindow: Value(map['actionWindow'] as String?),
          outcomeNotes: Value(map['outcomeNotes'] as String?),
          outcomeTimestamp: Value(map['outcomeTimestamp'] as int?),
        ),
      );
    }

    // Import preferences
    final preferences = data['preferences'] as Map<String, dynamic>?;
    if (preferences != null) {
      await _importPreferences(preferences);
    }
  }

  /// Returns the size in bytes of the export.
  Future<int> estimateExportSize() async {
    final bytes = await exportToBytes();
    return bytes.length;
  }

  /// Validates that a JSON byte array is a valid Saranidhi export file.
  ///
  /// Returns null if valid, or an error message if invalid.
  static String? validateExportData(Uint8List bytes) {
    try {
      final jsonStr = utf8.decode(bytes);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      final version = data['version'] as int?;
      if (version == null) return 'Missing version field';
      if (version > 1) return 'Unsupported version: $version';

      // Check schema version compatibility (Sprint 32)
      final schemaVersion = data['schemaVersion'] as int?;
      if (schemaVersion != null && schemaVersion > 4) {
        return 'Exported from a newer app version (schema $schemaVersion). '
            'Please update the app before importing.';
      }

      if (data['profiles'] is! List) return 'Missing or invalid profiles data';
      if (data['journal'] is! List) return 'Missing or invalid journal data';
      if (data['sessions'] is! List) return 'Missing or invalid sessions data';
      if (data['birds'] is! List) return 'Missing or invalid birds data';

      return null; // Valid
    } on FormatException {
      return 'Invalid JSON format';
    } on Exception catch (e) {
      return 'Validation error: $e';
    }
  }

  /// Returns a summary of data in an export file without importing it.
  static Map<String, int> summarizeExportData(Uint8List bytes) {
    final jsonStr = utf8.decode(bytes);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    return {
      'profiles': (data['profiles'] as List?)?.length ?? 0,
      'journal': (data['journal'] as List?)?.length ?? 0,
      'sessions': (data['sessions'] as List?)?.length ?? 0,
      'birds': (data['birds'] as List?)?.length ?? 0,
      'prasanam': (data['prasanam'] as List?)?.length ?? 0,
    };
  }

  // ─── Preferences export/import ───────────────────────────────────────

  Future<Map<String, dynamic>> _exportPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final exported = <String, dynamic>{};

    for (final key in _exportedPrefKeys) {
      final value = prefs.get(key);
      if (value != null) {
        exported[key] = value;
      }
    }

    return exported;
  }

  Future<void> _importPreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();

    for (final entry in preferences.entries) {
      final key = entry.key;
      final value = entry.value;

      // Only import known keys for safety
      if (!_exportedPrefKeys.contains(key)) continue;

      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      }
    }
  }

  // ─── Table row serialization ─────────────────────────────────────────

  Map<String, dynamic> _profileToMap(Profile p) => {
    'id': p.id,
    'displayName': p.displayName,
    'birthStarNakshatra': p.birthStarNakshatra,
    'birthBird': p.birthBird,
    'locationLat': p.locationLat,
    'locationLng': p.locationLng,
    'birthDateEpoch': p.birthDateEpoch,
    'birthTime': p.birthTime,
    'birthPlaceName': p.birthPlaceName,
    'birthPlaceLat': p.birthPlaceLat,
    'birthPlaceLng': p.birthPlaceLng,
    'theme': p.theme,
    'language': p.language,
    'storageMode': p.storageMode,
    'notifyRuling': p.notifyRuling,
    'notifyEating': p.notifyEating,
    'lastAiNote': p.lastAiNote,
    'lastAiNoteDate': p.lastAiNoteDate,
    'createdAt': p.createdAt,
    'updatedAt': p.updatedAt,
  };

  Map<String, dynamic> _journalToMap(SaraKalaiJournalData j) => {
    'id': j.id,
    'timestamp': j.timestamp,
    'expectedFlow': j.expectedFlow,
    'actualFlow': j.actualFlow,
    'isAligned': j.isAligned,
    'nostril': j.nostril,
    'inhaleDurationMs': j.inhaleDurationMs,
    'holdDurationMs': j.holdDurationMs,
    'exhaleDurationMs': j.exhaleDurationMs,
    'activeYama': j.activeYama,
    'activeBird': j.activeBird,
    'activeBirdState': j.activeBirdState,
    'activeElement': j.activeElement,
    'notes': j.notes,
    'isPinned': j.isPinned,
  };

  Map<String, dynamic> _sessionToMap(BreathSession s) => {
    'id': s.id,
    'timestamp': s.timestamp,
    'totalDurationMs': s.totalDurationMs,
    'nostril': s.nostril,
    'inhaleLengthMs': s.inhaleLengthMs,
    'holdAfterInhaleMs': s.holdAfterInhaleMs,
    'exhaleLengthMs': s.exhaleLengthMs,
    'holdAfterExhaleMs': s.holdAfterExhaleMs,
    'completedCycles': s.completedCycles,
    'mood': s.mood,
    'consciousnessRating': s.consciousnessRating,
    'notes': s.notes,
  };

  Map<String, dynamic> _birdToMap(BirdLibraryData b) => {
    'id': b.id,
    'birdName': b.birdName,
    'nakshatraGroup': b.nakshatraGroup,
    'favorited': b.favorited,
  };

  Map<String, dynamic> _prasanamToMap(PrasanamHistoryData p) => {
    'id': p.id,
    'timestamp': p.timestamp,
    'category': p.category,
    'queryText': p.queryText,
    'score': p.score,
    'band': p.band,
    'guidanceEn': p.guidanceEn,
    'guidanceTa': p.guidanceTa,
    'isFloorLocked': p.isFloorLocked,
    'swara': p.swara,
    'birdState': p.birdState,
    'actionWindow': p.actionWindow,
    'outcomeNotes': p.outcomeNotes,
    'outcomeTimestamp': p.outcomeTimestamp,
  };
}
