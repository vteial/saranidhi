import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
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
        // Check if column already exists using PRAGMA table_info() to avoid
        // "duplicate column name" error on databases created fresh at v2+.
        final columns = await customSelect(
          "PRAGMA table_info('sara_kalai_journal')",
        ).get();
        final hasIsPinned = columns.any(
          (row) => row.read<String>('name') == 'is_pinned',
        );
        if (!hasIsPinned) {
          await m.addColumn(saraKalaiJournal, saraKalaiJournal.isPinned);
        }
      }
      if (from < 4) {
        // Sprint 32: Create Prasanam Oracle history table.
        // Check if table already exists to avoid errors on databases
        // that were created fresh at schema v3+.
        final tables = await customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='prasanam_history'",
        ).get();
        if (tables.isEmpty) {
          await m.createTable(prasanamHistory);
        }
      }
      if (from < 5) {
        // Sprint 35: Create Somatic Intervention logs table.
        // Check if table already exists to avoid errors on databases
        // that were created fresh at schema v4+.
        final tables = await customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='somatic_intervention_logs'",
        ).get();
        if (tables.isEmpty) {
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
