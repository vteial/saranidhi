import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/integrated_arudam_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Golden before/after test characterizing scoring shift under CONF-PP-007 (R4).
///
/// Documents the exact score shifts resulting from aligning base bird-state scores
/// with the primary source (*"பஞ்ச பட்சி ஆருடம்"*, Kottumozhi Sathya p. 12) and
/// encoding Adhikara/Padu modifiers:
///
/// | State | Shipped Base | Corpus Aligned Base | Qualitative Favourability |
/// |---|---|---|---|
/// | Ruling | 100 | 100 | Unchanged peak power (100% success) |
/// | Eating | 80 | 80 | Unchanged strong positive (80% success) |
/// | Walking | 60 | 50 | Shifted to neutral midpoint (40% dragging / mixed) |
/// | Sleeping | 30 | 20 | Shifted to adverse / failure (80% failure) |
/// | Dying | 10 | 5 | Shifted to severe adverse / near block (90% failure) |
///
/// **Floor-Lock Invariant (R4.2):**
/// Rahu Kaal and Emakandam inauspicious window floor-lock (score=10, band=sunya)
/// remains 100% unchanged across day and night.
void main() {
  group('Oracle Scoring Golden (CONF-PP-007 / R4 before & after characterization)', () {
    final queryDate = DateTime(2026, 7, 5, 10, 0); // Sunday
    final sunrise = DateTime(2026, 7, 5, 6, 0);
    final sunset = DateTime(2026, 7, 5, 18, 0);
    const weekday = 0; // Sunday

    group('Base State Shifts (Pre-change vs Post-change)', () {
      test('Case 1: Ruling state in Artha window (Artha category)', () {
        // Inputs: Base ruling, Tarabala=1.0, Hora=1.0, Harmony=1.2, Aligned=1.0
        // PRE-CHANGE: 100 * 1.0 * 1.0 * 1.2 = 120 -> clamped to 100
        // POST-CHANGE: 100 * 1.0 * 1.0 * 1.2 = 120 -> clamped to 100 (UNCHANGED)
        final result = OracleCompositeEngine.evaluate(
          queryTime: queryDate,
          sunrise: sunrise,
          sunset: sunset,
          weekday: weekday,
          currentBirdState: PakshiState.ruling,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          category: QueryCategory.artha,
          actualSwara: 'right', // Aligned on Sunday solar
        );

        expect(result.score, 100);
        expect(result.band, OracleBand.siddha);
        expect(result.isFloorLocked, isFalse);
      });

      test('Case 2: Eating state in Kriya window (Kriya category)', () {
        // Inputs: Base eating, Tarabala=1.0, Hora=1.0, Harmony=1.2, Misaligned=0.75
        // Moment = 80 * 1.2 = 96
        // PRE-CHANGE: (96 * 0.75).round() = 72
        // POST-CHANGE: (96 * 0.75).round() = 72 (UNCHANGED)
        final result = OracleCompositeEngine.evaluate(
          queryTime: queryDate,
          sunrise: sunrise,
          sunset: sunset,
          weekday: weekday,
          currentBirdState: PakshiState.eating,
          currentWindow: ActionWindow.kriya,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          category: QueryCategory.kriya,
          actualSwara: 'left', // Misaligned
        );

        expect(result.score, 72);
        expect(result.band, OracleBand.vardhana);
        expect(result.isFloorLocked, isFalse);
      });

      test('Case 3: Walking state in Artha window (Artha category)', () {
        // Inputs: Base walking, Tarabala=1.0, Hora=1.0, Harmony=1.2, Aligned=1.0
        // PRE-CHANGE: Base=60 -> Moment = 60 * 1.2 = 72 -> Score = 72 (Vardhana)
        // POST-CHANGE: Base=50 -> Moment = 50 * 1.2 = 60 -> Score = 60 (Mandha - neutral midpoint)
        final result = OracleCompositeEngine.evaluate(
          queryTime: queryDate,
          sunrise: sunrise,
          sunset: sunset,
          weekday: weekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          category: QueryCategory.artha,
          actualSwara: 'right',
        );

        expect(result.score, 60);
        expect(result.band, OracleBand.mandha);
        expect(result.isFloorLocked, isFalse);
      });

      test('Case 4: Sleeping state in Yoga window (Yoga category)', () {
        // Inputs: Base sleeping, Tarabala=1.0, Hora=1.0, Harmony=1.2, Aligned=1.0
        // PRE-CHANGE: Base=30 -> Moment = 30 * 1.2 = 36 -> Score = 36 (Stambhana)
        // POST-CHANGE: Base=20 -> Moment = 20 * 1.2 = 24 -> Score = 24 (Sunya - failure weighted)
        final result = OracleCompositeEngine.evaluate(
          queryTime: queryDate,
          sunrise: sunrise,
          sunset: sunset,
          weekday: weekday,
          currentBirdState: PakshiState.sleeping,
          currentWindow: ActionWindow.yoga,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          category: QueryCategory.yoga,
          actualSwara: 'both', // Sushumna aligned in Yoga window
        );

        expect(result.score, 24);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isFalse);
      });

      test('Case 5: Dying state in Yoga window (Yoga category)', () {
        // Inputs: Base dying, Tarabala=1.0, Hora=1.0, Harmony=1.2, Aligned=1.0
        // PRE-CHANGE: Base=10 -> Moment = 10 * 1.2 = 12 -> Score = 12 (Sunya)
        // POST-CHANGE: Base=5 -> Moment = 5 * 1.2 = 6 -> Score = 6 (Sunya - severe adverse)
        final result = OracleCompositeEngine.evaluate(
          queryTime: queryDate,
          sunrise: sunrise,
          sunset: sunset,
          weekday: weekday,
          currentBirdState: PakshiState.dying,
          currentWindow: ActionWindow.yoga,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          category: QueryCategory.yoga,
          actualSwara: 'both',
        );

        expect(result.score, 6);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isFalse);
      });
    });

    group('Adhikara & Padu Modifiers (CONF-PP-007 / D2/D3)', () {
      test('Case 6: Rooster in Adhikara block receives 1.15 multiplier', () {
        // Friday day in Shukla (Jan 10, 2025): Cock is in Adhikara (p. 22)
        // 08:30 is Segment 2 (Rahu Kaal is Seg 4, Emakandam is Seg 7)
        // Base walking=50 * Tarabala=1.0 * Hora=1.0 * Harmony=1.2 * Adhikara=1.15
        // Raw moment = 50 * 1.2 * 1.15 = 69 -> score = 69 (Mandha)
        // (Without Adhikara, score would be 60)
        final friday = DateTime(2025, 1, 10, 8, 30);
        final fridaySunrise = DateTime(2025, 1, 10, 6, 0);
        final fridaySunset = DateTime(2025, 1, 10, 18, 0);
        const fridayWeekday = 5;

        final result = OracleCompositeEngine.evaluate(
          queryTime: friday,
          sunrise: fridaySunrise,
          sunset: fridaySunset,
          weekday: fridayWeekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.rooster,
        );

        expect(result.score, 69);
        expect(result.band, OracleBand.mandha);
        expect(result.isFloorLocked, isFalse);
      });

      test('Case 7: Rooster on Padu-Pakshi day receives 0.5 adverse multiplier', () {
        // Tuesday in Shukla (Jan 7, 2025): Cock is in Padu downtime (p. 18)
        // 11:00 is Segment 4 (Emakandam is Seg 3, Rahu Kaal is Seg 7)
        // Base walking=50 * 1.2 * Padu=0.5 = 30 -> score = 30 (Stambhana)
        // (Without Padu, score would be 60)
        final tuesday = DateTime(2025, 1, 7, 11, 0);
        final tuesdaySunrise = DateTime(2025, 1, 7, 6, 0);
        final tuesdaySunset = DateTime(2025, 1, 7, 18, 0);
        const tuesdayWeekday = 2;

        final result = OracleCompositeEngine.evaluate(
          queryTime: tuesday,
          sunrise: tuesdaySunrise,
          sunset: tuesdaySunset,
          weekday: tuesdayWeekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.rooster,
        );

        expect(result.score, 30);
        expect(result.band, OracleBand.stambhana);
        expect(result.isFloorLocked, isFalse);
      });
    });

    group('Inauspicious Floor-Lock Invariant (R4.2)', () {
      test('Case 8: Rahu Kaal daytime floor locks to 10 regardless of bird/state', () {
        // Sunday Rahu Kaal: 16:30 - 18:00 (segment 8)
        final rahuTime = DateTime(2026, 7, 5, 17, 0);

        final result = OracleCompositeEngine.evaluate(
          queryTime: rahuTime,
          sunrise: sunrise,
          sunset: sunset,
          weekday: weekday,
          currentBirdState: PakshiState.ruling,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.5,
          horaSwaraMultiplier: 1.5,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.vulture,
        );

        expect(result.score, 10);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isTrue);
      });

      test('Case 9: Emakandam daytime floor locks to 10 regardless of bird/state', () {
        // Sunday Emakandam: 12:00 - 13:30 (segment 5)
        final emaTime = DateTime(2026, 7, 5, 12, 30);

        final result = OracleCompositeEngine.evaluate(
          queryTime: emaTime,
          sunrise: sunrise,
          sunset: sunset,
          weekday: weekday,
          currentBirdState: PakshiState.ruling,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.5,
          horaSwaraMultiplier: 1.5,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.vulture,
        );

        expect(result.score, 10);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isTrue);
      });
    });
  });
}
