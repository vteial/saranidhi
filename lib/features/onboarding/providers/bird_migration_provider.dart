import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/onboarding/domain/bird_migration_service.dart';

/// Provides the [BirdMigrationService] instance.
final birdMigrationServiceProvider = Provider<BirdMigrationService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BirdMigrationService(db);
});

/// Runs the birth-bird recalculation once on app load and exposes the result.
///
/// Consumed by `BirdMigrationOnLoadWidget` to show a one-time notice when
/// the bird changes. Auto-runs when first watched.
final birdMigrationProvider = FutureProvider<BirdMigrationResult>((ref) async {
  final service = ref.watch(birdMigrationServiceProvider);
  return service.recalculateIfNeeded();
});
