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

/// Recalculates a user's birth bird on app load using the correct
/// dual-table (birth-Paksha-aware) derivation.
///
/// Background: Sprint 33 fixed the birth bird derivation to use the
/// correct Bright/Dark half table based on the user's birth Paksha.
/// However, existing profiles created before the fix retained a bird
/// derived from the old (Bright-Half-only) logic. This service corrects
/// those profiles automatically on app load.
///
/// Only runs when the profile has a stored DOB (`birthDateEpoch`). Profiles
/// without a DOB (manual "I know my star" selection) are left untouched —
/// we cannot determine the correct birth Paksha without a DOB.
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

    // Only migrate profiles that have a DOB — without it we can't
    // determine the birth Paksha, so we leave manual selections alone.
    final epoch = profile.birthDateEpoch;
    final nakshatra = profile.birthStarNakshatra;
    if (epoch == null || nakshatra == null) {
      return BirdMigrationResult.noChange;
    }

    // Reconstruct the birth moment (UTC — same convention as onboarding).
    final birthDate = DateTime.fromMillisecondsSinceEpoch(epoch, isUtc: true);
    final birthPaksha = PakshiCalculator.birthPakshaFromDOB(birthDate);
    final correctBird = PakshiCalculator.birthBirdFromNakshatraAndPaksha(
      nakshatra,
      birthPaksha,
    );

    if (correctBird == null) return BirdMigrationResult.noChange;

    final storedBird = profile.birthBird;
    if (storedBird == correctBird.name) {
      // Already correct — nothing to do.
      return BirdMigrationResult.noChange;
    }

    // Update the profile with the corrected bird.
    await (_db.update(_db.profiles)..where((t) => t.id.equals(profile.id)))
        .write(
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
