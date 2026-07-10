import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:saranidhi/database/tables.dart';

part 'app_database.g.dart';

/// The main application database powered by Drift.
///
/// Contains all four schema tables:
/// - [Profiles] — user profile and preferences
/// - [SaraKalaiJournal] — breath journal entries
/// - [BreathSessions] — detailed breath session recordings
/// - [BirdLibrary] — Panja Pakshi bird reference data
@DriftDatabase(
  tables: [Profiles, SaraKalaiJournal, BreathSessions, BirdLibrary],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

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
        // Sprint 26: Add isPinned column to journal entries
        await m.addColumn(saraKalaiJournal, saraKalaiJournal.isPinned);
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
