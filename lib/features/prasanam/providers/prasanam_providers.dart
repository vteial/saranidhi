import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/prasanam/data/prasanam_repository.dart';

/// Provides the [PrasanamRepository] instance.
final prasanamRepositoryProvider = Provider<PrasanamRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PrasanamRepository(db);
});

/// Watches all Prasanam queries as a stream for reactive UI.
final prasanamHistoryProvider =
    StreamProvider<List<PrasanamHistoryData>>((ref) {
  final repo = ref.watch(prasanamRepositoryProvider);
  return repo.watchAllQueries();
});

/// Provides the most recent Prasanam query for validation gate checks.
final lastPrasanamQueryProvider =
    FutureProvider<PrasanamHistoryData?>((ref) async {
  final repo = ref.watch(prasanamRepositoryProvider);
  return repo.getMostRecentQuery();
});
