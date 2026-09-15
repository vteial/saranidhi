import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';

/// Provides the current primary [Profile] from the database.
///
/// Returns `null` if no profile exists yet (e.g. pre-onboarding).
final profileProvider = FutureProvider<Profile?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final profiles = await db.select(db.profiles).get();
  return profiles.isEmpty ? null : profiles.first;
});
