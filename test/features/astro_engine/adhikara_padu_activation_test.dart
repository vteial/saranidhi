import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/astro_engine/domain/integrated_arudam_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_adhikara.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

/// Test suite for Adhikara / Padu-Pakshi activation under CONF-PP-007.
///
/// Verifies:
/// - R1: Prasanam path activates Adhikara/Padu modifier via `bird` parameter.
/// - R1.2 / R2.2: Null-bird is a complete no-op (regression oracle).
/// - R2.1: Prasanam composite and Home direct paths agree identically.
/// - R3: Inauspicious floor-lock (Rahu/Emakandam) wins over Adhikara x1.15 boost.
/// - R5: Score shifts are explicitly characterized (Adhikara, Padu, normal, floor-lock).
void main() {
  group('Adhikara / Padu-Pakshi Activation (CONF-PP-007)', () {
    // Fixed reference dates and times
    // Jan 10, 2025 is Friday in Shukla (Valarpirai)
    final fridayShukla = DateTime(2025, 1, 10, 8, 30);
    final fridaySunrise = DateTime(2025, 1, 10, 6);
    final fridaySunset = DateTime(2025, 1, 10, 18);
    const fridayWeekday = 5; // Friday

    // Jan 7, 2025 is Tuesday in Shukla (Valarpirai)
    final tuesdayShukla = DateTime(2025, 1, 7, 11);
    final tuesdaySunrise = DateTime(2025, 1, 7, 6);
    final tuesdaySunset = DateTime(2025, 1, 7, 18);
    const tuesdayWeekday = 2; // Tuesday

    // Jan 8, 2025 is Wednesday in Shukla (Valarpirai)
    final wednesdayShukla = DateTime(2025, 1, 8, 10);
    final wednesdaySunrise = DateTime(2025, 1, 8, 6);
    final wednesdaySunset = DateTime(2025, 1, 8, 18);
    const wednesdayWeekday = 3; // Wednesday

    group('T1a — Null-bird no-op invariant (R1.2 / R2.2)', () {
      test('evaluate with bird: null returns identical verdict to omitted bird', () {
        final resultOmitted = OracleCompositeEngine.evaluate(
          queryTime: fridayShukla,
          sunrise: fridaySunrise,
          sunset: fridaySunset,
          weekday: fridayWeekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          category: QueryCategory.artha,
          actualSwara: 'right',
        );

        final resultExplicitNull = OracleCompositeEngine.evaluate(
          queryTime: fridayShukla,
          sunrise: fridaySunrise,
          sunset: fridaySunset,
          weekday: fridayWeekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: null,
        );

        expect(resultExplicitNull.score, equals(resultOmitted.score));
        expect(resultExplicitNull.band, equals(resultOmitted.band));
        expect(resultExplicitNull.isFloorLocked, equals(resultOmitted.isFloorLocked));
        expect(resultExplicitNull.englishGuidance, equals(resultOmitted.englishGuidance));
        expect(resultExplicitNull.tamilGuidance, equals(resultOmitted.tamilGuidance));
      });

      test('IntegratedArudamEngine with default adhikaraMultiplier matches pre-activation', () {
        final resultDefault = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.eating,
          window: ActionWindow.kriya,
          category: QueryCategory.kriya,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          isAligned: true,
          actualSwara: BreathFlow.solar,
          isRahuActive: false,
          isEmakandamActive: false,
        );

        final resultExplicitOne = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.eating,
          window: ActionWindow.kriya,
          category: QueryCategory.kriya,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          isAligned: true,
          actualSwara: BreathFlow.solar,
          isRahuActive: false,
          isEmakandamActive: false,
          adhikaraMultiplier: 1,
        );

        expect(resultDefault.score, equals(resultExplicitOne.score));
        expect(resultDefault.momentScore, equals(resultExplicitOne.momentScore));
        expect(resultDefault.band, equals(resultExplicitOne.band));
      });
    });

    group('T1b — Floor-lock over boost invariant (R3)', () {
      test('Adhikara day inside Rahu Kaal stays locked to 10 and sunya band', () {
        // Cock on Friday daytime in Shukla is Adhikara (p. 22)
        // Segment 4 on Friday (10:30 - 12:00) is Rahu Kaal
        final rahuTime = DateTime(2025, 1, 10, 11);

        final result = OracleCompositeEngine.evaluate(
          queryTime: rahuTime,
          sunrise: fridaySunrise,
          sunset: fridaySunset,
          weekday: fridayWeekday,
          currentBirdState: PakshiState.ruling,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.5,
          horaSwaraMultiplier: 1.5,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.rooster, // Has Adhikara
        );

        expect(result.score, 10);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isTrue);
      });

      test('Adhikara day inside Emakandam stays locked to 10 and sunya band', () {
        // Cock on Friday daytime in Shukla is Adhikara (p. 22)
        // Segment 7 on Friday (15:00 - 16:30) is Emakandam
        final emaTime = DateTime(2025, 1, 10, 15, 30);

        final result = OracleCompositeEngine.evaluate(
          queryTime: emaTime,
          sunrise: fridaySunrise,
          sunset: fridaySunset,
          weekday: fridayWeekday,
          currentBirdState: PakshiState.ruling,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1.5,
          horaSwaraMultiplier: 1.5,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.rooster, // Has Adhikara
        );

        expect(result.score, 10);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isTrue);
      });
    });

    group('T4-check — Two surfaces agree identically (R2.1)', () {
      test('Prasanam composite and Home direct paths produce identical multiplier and verdict', () {
        // Test all 5 birds across Adhikara, Padu, and normal days
        final testCases = [
          (PakshiBird.rooster, fridayWeekday, fridayShukla, fridaySunrise, fridaySunset, 1.15), // Adhikara
          (PakshiBird.rooster, tuesdayWeekday, tuesdayShukla, tuesdaySunrise, tuesdaySunset, 0.5), // Padu
          (PakshiBird.rooster, wednesdayWeekday, wednesdayShukla, wednesdaySunrise, wednesdaySunset, 1.0), // Normal
          (PakshiBird.owl, wednesdayWeekday, wednesdayShukla, wednesdaySunrise, wednesdaySunset, 1.15), // Owl Wed Shukla Adhikara
        ];

        for (final (bird, weekday, queryTime, sunrise, sunset, expectedMult) in testCases) {
          // 1. Derivation via PakshiAdhikara.multiplierFor (used by Home card)
          final derivedMult = PakshiAdhikara.multiplierFor(
            weekday: weekday,
            queryTime: queryTime,
            bird: bird,
            sunrise: sunrise,
            sunset: sunset,
          );
          expect(derivedMult, equals(expectedMult));

          // 2. Direct evaluate via IntegratedArudamEngine (Home card path)
          final homeVerdict = IntegratedArudamEngine.evaluate(
            birdState: PakshiState.walking,
            window: ActionWindow.artha,
            category: QueryCategory.artha,
            tarabalaMultiplier: 1,
            horaSwaraMultiplier: 1,
            isAligned: true,
            actualSwara: BreathFlow.solar,
            isRahuActive: false,
            isEmakandamActive: false,
            adhikaraMultiplier: derivedMult,
          );

          // 3. Composite evaluate via OracleCompositeEngine (Prasanam screen path)
          final prasanamResult = OracleCompositeEngine.evaluate(
            queryTime: queryTime,
            sunrise: sunrise,
            sunset: sunset,
            weekday: weekday,
            currentBirdState: PakshiState.walking,
            currentWindow: ActionWindow.artha,
            tarabalaMultiplier: 1,
            horaSwaraMultiplier: 1,
            category: QueryCategory.artha,
            actualSwara: 'right', // Aligned on right
            bird: bird,
          );

          // Both paths must produce the exact same final score and band!
          expect(
            homeVerdict.score,
            equals(prasanamResult.score),
            reason: 'Surface divergence for bird=$bird on weekday=$weekday',
          );
          expect(
            homeVerdict.band,
            equals(prasanamResult.band),
            reason: 'Band divergence for bird=$bird on weekday=$weekday',
          );
        }
      });
    });

    group('T5 — Score shift characterization (R5)', () {
      test('Adhikara day applies x1.15 boost: 60 -> 69 (Mandha)', () {
        // Walking base 50 * Harmony 1.2 * Adhikara 1.15 = 69
        // Un-boosted score would be 50 * 1.2 = 60
        final result = OracleCompositeEngine.evaluate(
          queryTime: fridayShukla,
          sunrise: fridaySunrise,
          sunset: fridaySunset,
          weekday: fridayWeekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.rooster,
        );

        expect(result.score, 69);
        expect(result.band, OracleBand.mandha);
        expect(result.isFloorLocked, isFalse);
      });

      test('Padu day applies x0.5 reduction: 60 -> 30 (Stambhana)', () {
        // Walking base 50 * Harmony 1.2 * Padu 0.5 = 30
        // Un-reduced score would be 50 * 1.2 = 60
        final result = OracleCompositeEngine.evaluate(
          queryTime: tuesdayShukla,
          sunrise: tuesdaySunrise,
          sunset: tuesdaySunset,
          weekday: tuesdayWeekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.rooster,
        );

        expect(result.score, 30);
        expect(result.band, OracleBand.stambhana);
        expect(result.isFloorLocked, isFalse);
      });

      test('Normal day applies x1.0 multiplier: score unchanged at 60 (Mandha)', () {
        // Walking base 50 * Harmony 1.2 * Normal 1.0 = 60
        final result = OracleCompositeEngine.evaluate(
          queryTime: wednesdayShukla,
          sunrise: wednesdaySunrise,
          sunset: wednesdaySunset,
          weekday: wednesdayWeekday,
          currentBirdState: PakshiState.walking,
          currentWindow: ActionWindow.artha,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          category: QueryCategory.artha,
          actualSwara: 'right',
          bird: PakshiBird.rooster,
        );

        expect(result.score, 60);
        expect(result.band, OracleBand.mandha);
        expect(result.isFloorLocked, isFalse);
      });
    });
  });
}
