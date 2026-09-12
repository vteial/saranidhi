import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/integrated_arudam_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

void main() {
  group('IntegratedArudamEngine', () {
    test('Moment x Readiness: aligned applies 1.0 multiplier', () {
      // Ruling base=100, Tarabala=1.0, Hora=1.0, Harmony(artha, artha)=1.2
      // Moment = 120 -> clamped to 100
      // Let's use eating base=80, Tarabala=1.0, Hora=1.0, Harmony(kriya, kriya)=1.2
      // Moment = 96. Aligned -> 96 * 1.0 = 96
      final result = IntegratedArudamEngine.evaluate(
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

      expect(result.momentScore, 96);
      expect(result.readinessMultiplier, 1.0);
      expect(result.score, 96);
      expect(result.band, OracleBand.siddha);
      expect(result.isFloorLocked, isFalse);
    });

    test('Moment x Readiness: misaligned applies 0.75 multiplier', () {
      // Eating base=80, Tarabala=1.0, Hora=1.0, Harmony(kriya, kriya)=1.2 -> Moment = 96
      // Misaligned -> 96 * 0.75 = 72
      final result = IntegratedArudamEngine.evaluate(
        birdState: PakshiState.eating,
        window: ActionWindow.kriya,
        category: QueryCategory.kriya,
        tarabalaMultiplier: 1,
        horaSwaraMultiplier: 1,
        isAligned: false,
        actualSwara: BreathFlow.lunar,
        isRahuActive: false,
        isEmakandamActive: false,
      );

      expect(result.momentScore, 96);
      expect(result.readinessMultiplier, 0.75);
      expect(result.score, 72);
      expect(result.band, OracleBand.vardhana);
      expect(result.isFloorLocked, isFalse);
    });

    test('Aligned vs misaligned score differs by exact 0.75 factor', () {
      // Walking base=60, Tarabala=1.0, Hora=1.0, Harmony(artha, artha)=1.2 -> Moment = 72
      // Aligned: 72 * 1.0 = 72
      final aligned = IntegratedArudamEngine.evaluate(
        birdState: PakshiState.walking,
        window: ActionWindow.artha,
        category: QueryCategory.artha,
        tarabalaMultiplier: 1,
        horaSwaraMultiplier: 1,
        isAligned: true,
        actualSwara: BreathFlow.solar,
        isRahuActive: false,
        isEmakandamActive: false,
      );

      // Misaligned: 72 * 0.75 = 54
      final misaligned = IntegratedArudamEngine.evaluate(
        birdState: PakshiState.walking,
        window: ActionWindow.artha,
        category: QueryCategory.artha,
        tarabalaMultiplier: 1,
        horaSwaraMultiplier: 1,
        isAligned: false,
        actualSwara: BreathFlow.lunar,
        isRahuActive: false,
        isEmakandamActive: false,
      );

      expect(aligned.score, 72);
      expect(misaligned.score, 54);
      expect((misaligned.score / aligned.score), closeTo(0.75, 0.01));
    });

    test('Stale / unknown swara (null) defaults to Moment ceiling (1.0)', () {
      final result = IntegratedArudamEngine.evaluate(
        birdState: PakshiState.walking,
        window: ActionWindow.artha,
        category: QueryCategory.artha,
        tarabalaMultiplier: 1,
        horaSwaraMultiplier: 1,
        isAligned: false, // Ignored when swara is null
        actualSwara: null,
        isRahuActive: false,
        isEmakandamActive: false,
      );

      expect(result.readinessMultiplier, 1.0);
      expect(result.score, result.momentScore);
      expect(result.score, 72);
    });

    group('Sushumna-in-Yoga rule', () {
      test('Sushumna is aligned in Yoga window', () {
        final result = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.sleeping,
          window: ActionWindow.yoga,
          category: QueryCategory.yoga,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          isAligned: false, // window.isSushumnaAligned overrides
          actualSwara: BreathFlow.sushumna,
          isRahuActive: false,
          isEmakandamActive: false,
        );

        expect(result.readinessMultiplier, 1.0);
        // Base sleeping=30, category yoga=1.2 -> 36 * 1.0 = 36
        expect(result.score, 36);
        expect(result.englishGuidance, contains('Sushumna Swara is active'));
      });

      test('Sushumna is misaligned in Artha window', () {
        final result = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.ruling,
          window: ActionWindow.artha,
          category: QueryCategory.artha,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          isAligned: true, // Overridden by window.isSushumnaAligned == false
          actualSwara: BreathFlow.sushumna,
          isRahuActive: false,
          isEmakandamActive: false,
        );

        expect(result.readinessMultiplier, 0.75);
        // Base ruling=100 * 1.2 = 120 (clamped moment 100); raw = 120 * 0.75 = 90
        expect(result.score, 90);
        expect(result.englishGuidance, contains('Sushumna Swara is active'));
      });

      test('Sushumna is misaligned in Kriya window', () {
        final result = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.eating,
          window: ActionWindow.kriya,
          category: QueryCategory.kriya,
          tarabalaMultiplier: 1,
          horaSwaraMultiplier: 1,
          isAligned: true, // Overridden
          actualSwara: BreathFlow.sushumna,
          isRahuActive: false,
          isEmakandamActive: false,
        );

        expect(result.readinessMultiplier, 0.75);
      });
    });

    group('Inauspicious floor-lock', () {
      test('Rahu Kaal active locks score to 10 and band Sunya', () {
        final result = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.ruling,
          window: ActionWindow.artha,
          category: QueryCategory.artha,
          tarabalaMultiplier: 1.5,
          horaSwaraMultiplier: 1.5,
          isAligned: true,
          actualSwara: BreathFlow.solar,
          isRahuActive: true,
          isEmakandamActive: false,
        );

        expect(result.score, 10);
        expect(result.momentScore, 10);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isTrue);
        expect(result.englishGuidance, contains('Rahu Kaal is active'));
      });

      test('Emakandam active locks score to 10 and band Sunya', () {
        final result = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.ruling,
          window: ActionWindow.artha,
          category: QueryCategory.artha,
          tarabalaMultiplier: 1.5,
          horaSwaraMultiplier: 1.5,
          isAligned: true,
          actualSwara: BreathFlow.solar,
          isRahuActive: false,
          isEmakandamActive: true,
        );

        expect(result.score, 10);
        expect(result.momentScore, 10);
        expect(result.band, OracleBand.sunya);
        expect(result.isFloorLocked, isTrue);
        expect(result.englishGuidance, contains('Emakandam is active'));
      });

      test(
        'Floor lock works for post-sunset/night when booleans are true (Task 38.3)',
        () {
          // Window containment passes true regardless of daytime
          final result = IntegratedArudamEngine.evaluate(
            birdState: PakshiState.sleeping,
            window: ActionWindow.yoga,
            category: QueryCategory.yoga,
            tarabalaMultiplier: 1,
            horaSwaraMultiplier: 1,
            isAligned: true,
            actualSwara: BreathFlow.solar,
            isRahuActive: true,
            isEmakandamActive: false,
          );

          expect(result.score, 10);
          expect(result.isFloorLocked, isTrue);
        },
      );
    });

    group('OracleBand mapping', () {
      test('Maps scores across all 5 bands', () {
        expect(OracleBand.fromScore(100), OracleBand.siddha);
        expect(OracleBand.fromScore(90), OracleBand.siddha);
        expect(OracleBand.fromScore(89), OracleBand.vardhana);
        expect(OracleBand.fromScore(70), OracleBand.vardhana);
        expect(OracleBand.fromScore(69), OracleBand.mandha);
        expect(OracleBand.fromScore(50), OracleBand.mandha);
        expect(OracleBand.fromScore(49), OracleBand.stambhana);
        expect(OracleBand.fromScore(30), OracleBand.stambhana);
        expect(OracleBand.fromScore(29), OracleBand.sunya);
        expect(OracleBand.fromScore(0), OracleBand.sunya);
      });
    });

    group('Provenance & Doctrinal Reasons (Sprint 39)', () {
      test(
        'strong/aligned case lists birdState:strong and readiness:strong with expected CONFs',
        () {
          final result = IntegratedArudamEngine.evaluate(
            birdState: PakshiState.ruling,
            window: ActionWindow.artha,
            category: QueryCategory.artha,
            tarabalaMultiplier: 1.2,
            horaSwaraMultiplier: 1.15,
            isAligned: true,
            actualSwara: BreathFlow.solar,
            isRahuActive: false,
            isEmakandamActive: false,
          );

          final birdReason = result.reasons.firstWhere(
            (r) => r.factor == ArudamFactor.birdState,
          );
          expect(birdReason.strength, FactorStrength.strong);
          expect(birdReason.conf, 'CONF-PP-004');

          final horaReason = result.reasons.firstWhere(
            (r) => r.factor == ArudamFactor.horaSwara,
          );
          expect(horaReason.strength, FactorStrength.strong);
          expect(horaReason.conf, 'CONF-014');

          final taraReason = result.reasons.firstWhere(
            (r) => r.factor == ArudamFactor.tarabala,
          );
          expect(taraReason.strength, FactorStrength.strong);
          expect(taraReason.conf, 'CONF-PP-001/002');

          final harmReason = result.reasons.firstWhere(
            (r) => r.factor == ArudamFactor.categoryHarmony,
          );
          expect(harmReason.strength, FactorStrength.strong);
          expect(harmReason.conf, 'CONF-015');

          final readinessReason = result.reasons.firstWhere(
            (r) => r.factor == ArudamFactor.readiness,
          );
          expect(readinessReason.strength, FactorStrength.strong);
          expect(readinessReason.conf, 'CONF-016 / CONF-017');
        },
      );

      test('misaligned case lists readiness:weak', () {
        final result = IntegratedArudamEngine.evaluate(
          birdState: PakshiState.eating,
          window: ActionWindow.kriya,
          category: QueryCategory.kriya,
          tarabalaMultiplier: 1.0,
          horaSwaraMultiplier: 1.0,
          isAligned: false,
          actualSwara: BreathFlow.lunar,
          isRahuActive: false,
          isEmakandamActive: false,
        );

        final readinessReason = result.reasons.firstWhere(
          (r) => r.factor == ArudamFactor.readiness,
        );
        expect(readinessReason.strength, FactorStrength.weak);
        expect(readinessReason.conf, 'CONF-016 / CONF-017');
      });

      test(
        'stale / unknown swara (actualSwara == null) omits readiness and sushumna reasons',
        () {
          final result = IntegratedArudamEngine.evaluate(
            birdState: PakshiState.walking,
            window: ActionWindow.artha,
            category: QueryCategory.artha,
            tarabalaMultiplier: 1.0,
            horaSwaraMultiplier: 1.0,
            isAligned: false,
            actualSwara: null,
            isRahuActive: false,
            isEmakandamActive: false,
          );

          expect(
            result.reasons.any((r) => r.factor == ArudamFactor.readiness),
            isFalse,
          );
          expect(
            result.reasons.any((r) => r.factor == ArudamFactor.sushumna),
            isFalse,
          );
          expect(
            result.reasons.length,
            4,
          ); // birdState, horaSwara, tarabala, categoryHarmony
        },
      );

      test(
        'Sushumna case emits sushumna factor (CONF-026) instead of readiness',
        () {
          final result = IntegratedArudamEngine.evaluate(
            birdState: PakshiState.sleeping,
            window: ActionWindow.yoga,
            category: QueryCategory.yoga,
            tarabalaMultiplier: 1.0,
            horaSwaraMultiplier: 1.0,
            isAligned: true,
            actualSwara: BreathFlow.sushumna,
            isRahuActive: false,
            isEmakandamActive: false,
          );

          expect(
            result.reasons.any((r) => r.factor == ArudamFactor.readiness),
            isFalse,
          );
          final sushumnaReason = result.reasons.firstWhere(
            (r) => r.factor == ArudamFactor.sushumna,
          );
          expect(sushumnaReason.conf, 'CONF-026');
          expect(sushumnaReason.strength, FactorStrength.moderate);
        },
      );

      test(
        'floor-locked case emits exactly one floorLock reason with blocking strength and CONF-018',
        () {
          final rahuResult = IntegratedArudamEngine.evaluate(
            birdState: PakshiState.ruling,
            window: ActionWindow.artha,
            category: QueryCategory.artha,
            tarabalaMultiplier: 1.5,
            horaSwaraMultiplier: 1.5,
            isAligned: true,
            actualSwara: BreathFlow.solar,
            isRahuActive: true,
            isEmakandamActive: false,
          );

          expect(rahuResult.reasons.length, 1);
          expect(rahuResult.reasons.first.factor, ArudamFactor.floorLock);
          expect(rahuResult.reasons.first.strength, FactorStrength.blocking);
          expect(rahuResult.reasons.first.conf, 'CONF-018');

          final emaResult = IntegratedArudamEngine.evaluate(
            birdState: PakshiState.ruling,
            window: ActionWindow.artha,
            category: QueryCategory.artha,
            tarabalaMultiplier: 1.5,
            horaSwaraMultiplier: 1.5,
            isAligned: true,
            actualSwara: BreathFlow.solar,
            isRahuActive: false,
            isEmakandamActive: true,
          );

          expect(emaResult.reasons.length, 1);
          expect(emaResult.reasons.first.factor, ArudamFactor.floorLock);
          expect(emaResult.reasons.first.strength, FactorStrength.blocking);
          expect(emaResult.reasons.first.conf, 'CONF-018');
        },
      );
    });
  });
}
