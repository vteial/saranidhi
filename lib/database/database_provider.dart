import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saranidhi/database/app_database.dart';

part 'database_provider.g.dart';

/// Provides a singleton instance of [AppDatabase] across the app.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
