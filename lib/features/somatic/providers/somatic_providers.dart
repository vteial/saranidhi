import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/somatic/data/somatic_intervention_repository.dart';

/// Provides the [SomaticInterventionRepository] instance.
final somaticInterventionRepositoryProvider =
    Provider<SomaticInterventionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SomaticInterventionRepository(db);
});

/// Watches all somatic intervention logs as a stream for reactive UI.
final somaticInterventionLogsProvider =
    StreamProvider<List<SomaticInterventionLog>>((ref) {
  final repo = ref.watch(somaticInterventionRepositoryProvider);
  return repo.watchAllLogs();
});
