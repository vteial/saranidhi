import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:saranidhi/database/migration_helpers.dart';
import 'package:saranidhi/database/tables.dart';

part 'app_database.g.dart';

/// The main application database powered by Drift.
///
/// Contains all schema tables:
/// - [Profiles] — user profile and preferences
/// - [SaraKalaiJournal] — breath journal entries
/// - [BreathSessions] — detailed breath session recordings
/// - [BirdLibrary] — Panja Pakshi bird reference data
/// - [PrasanamHistory] — Prasanam Oracle query history
/// - [SomaticInterventionLogs] — guided breath-channel intervention sessions
@DriftDatabase(
  tables: [
    Profiles,
    SaraKalaiJournal,
    BreathSessions,
    BirdLibrary,
    PrasanamHistory,
    SomaticInterventionLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Sprint 21: Add DOB + birth place columns to profiles
        await m.addColumn(profiles, profiles.birthDateEpoch);
        await m.addColumn(profiles, profiles.birthTime);
        await m.addColumn(profiles, profiles.birthPlaceName);
        await m.addColumn(profiles, profiles.birthPlaceLat);
        await m.addColumn(profiles, profiles.birthPlaceLng);
      }
      if (from < 3) {
        // Sprint 26: Add isPinned column to journal entries.
        // Guard with `columnExists` to avoid a "duplicate column name" error
        // on databases created fresh at schema v2+.
        if (!await columnExists(this, 'sara_kalai_journal', 'is_pinned')) {
          await m.addColumn(saraKalaiJournal, saraKalaiJournal.isPinned);
        }
      }
      if (from < 4) {
        // Sprint 32: Create Prasanam Oracle history table.
        // Guard with `tableExists` to avoid errors on databases created fresh
        // at schema v3+.
        if (!await tableExists(this, 'prasanam_history')) {
          await m.createTable(prasanamHistory);
        }
      }
      if (from < 5) {
        // Sprint 35: Create Somatic Intervention logs table.
        // Guard with `tableExists` to avoid errors on databases created fresh
        // at schema v4+.
        if (!await tableExists(this, 'somatic_intervention_logs')) {
          await m.createTable(somaticInterventionLogs);
        }
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'saranidhi_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
