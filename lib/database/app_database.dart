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
  int get schemaVersion => 1;

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
