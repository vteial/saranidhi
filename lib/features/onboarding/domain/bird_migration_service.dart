import 'package:drift/drift.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Result of a birth-bird migration check.
class BirdMigrationResult {
  const BirdMigrationResult({
    required this.changed,
    this.oldBird,
    this.newBird,
  });

  /// Whether the stored bird was updated.
  final bool changed;

  /// The previously-stored bird name (if changed).
  final String? oldBird;

  /// The newly-computed correct bird name (if changed).
  final String? newBird;

  static const BirdMigrationResult noChange = BirdMigrationResult(
    changed: false,
  );
}

/// Recalculates a user's birth bird on app load using the canonical
/// Siddha 5-6-5-5-6 single permanent table (CONF-PP-001, CONF-PP-002).
///
/// Background:
/// - Sprint 33 introduced dual-table derivation.
/// - Sprint 37 corrected the nakshatra partition to 5-6-5-5-6 and established
///   a single permanent table (no Krishna reverse-swap for birth stars).
///
/// This service automatically corrects existing profiles (both DOB-based
/// and manual "I know my star" profiles) whose stored bird differs from
/// the canonical single-table result.
class BirdMigrationService {
  const BirdMigrationService(this._db);

  final AppDatabase _db;

  /// Checks the current profile and recalculates the birth bird if needed.
  ///
  /// Returns a [BirdMigrationResult] describing whether a change occurred.
  Future<BirdMigrationResult> recalculateIfNeeded() async {
    final profiles = await _db.select(_db.profiles).get();
    if (profiles.isEmpty) return BirdMigrationResult.noChange;

    final profile = profiles.first;
    final nakshatra = profile.birthStarNakshatra;
    if (nakshatra == null) {
      return BirdMigrationResult.noChange;
    }

    // Single permanent 5-6-5-5-6 table governs all birth-star profiles
    // (both DOB-based and manual "known-star" selections).
    final correctBird = PakshiCalculator.birthBirdFromNakshatraSafe(nakshatra);
    if (correctBird == null) return BirdMigrationResult.noChange;

    final storedBird = profile.birthBird;
    if (storedBird == correctBird.name) {
      // Already correct — nothing to do (idempotent).
      return BirdMigrationResult.noChange;
    }

    // Update the profile with the corrected bird.
    await (_db.update(
      _db.profiles,
    )..where((t) => t.id.equals(profile.id))).write(
      ProfilesCompanion(
        birthBird: Value(correctBird.name),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );

    return BirdMigrationResult(
      changed: true,
      oldBird: storedBird,
      newBird: correctBird.name,
    );
  }
}
