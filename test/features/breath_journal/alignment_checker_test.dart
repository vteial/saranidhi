import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/swara_clock.dart';
import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

void main() {
  group('AlignmentChecker', () {
    // Chennai: 13.08, 80.27, IST UTC+5.5
    const lat = 13.08;
    const lng = 80.27;
    const utc = 5.5;

    group('B-01: aligned when actual flow matches expected', () {
      test('is aligned when actual matches SwaraClock expected flow', () {
        // Sunday July 5, 2026 at 06:30 Chennai time.
        // Sunrise ~ 05:48. Sunday seed: Solar (1h inception).
        // 06:30 is in the first hour [05:48, 06:48) -> Solar.
        final time = DateTime(2026, 7, 5, 6, 30);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.expectedFlow, equals(BreathFlow.solar));
        expect(result.isAligned, isTrue);
      });
    });

    group('B-02: not aligned when actual flow is the opposite of expected', () {
      test(
        'is not aligned when actual is opposite of SwaraClock expected flow',
        () {
          final time = DateTime(2026, 7, 5, 6, 30);

          final result = AlignmentChecker.check(
            actualFlow: BreathFlow.lunar,
            time: time,
            latitude: lat,
            longitude: lng,
            utcOffset: utc,
          );

          expect(result, isNotNull);
          expect(result!.expectedFlow, equals(BreathFlow.solar));
          expect(result.isAligned, isFalse);
        },
      );
    });

    group('B-03: Sushumna context-dependent alignment', () {
      test('sushumna alignment depends on action window (bird state)', () {
        // Yama 1 at 7:00 — bird state varies by weekday/lunar phase.
        // With the default (waxing, weekday from date), the bird state
        // determines the action window. Sushumna is aligned ONLY in
        // Yoga window (Sleeping/Dying states).
        final time = DateTime(2025, 3, 20, 7, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.sushumna,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.actionWindow, isNotNull);
        expect(
          result.isAligned,
          equals(result.actionWindow == ActionWindow.yoga),
        );
      });

      test('sushumna blocked in non-yoga window', () {
        // Yama 2 at 9:30
        final time = DateTime(2025, 3, 20, 9, 30);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.sushumna,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.actionWindow, isNotNull);
        expect(
          result.isAligned,
          equals(result.actionWindow == ActionWindow.yoga),
        );
      });
    });

    group('Swara Clock Expected Flow & Latent Bug Fix (Task 42.1 / 42.4)', () {
      test('expected flow alternates hourly and matches SwaraClock', () {
        // Sunday July 5, 2026: sunrise ~ 05:48
        // Hour 0 [05:48, 06:48): Solar (Right)
        final r1 = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: DateTime(2026, 7, 5, 6, 15),
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );
        expect(r1?.expectedFlow, equals(BreathFlow.solar));

        // Hour 1 [06:48, 07:48): Lunar (Left)
        final r2 = AlignmentChecker.check(
          actualFlow: BreathFlow.lunar,
          time: DateTime(2026, 7, 5, 7, 15),
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );
        expect(r2?.expectedFlow, equals(BreathFlow.lunar));
      });

      test('honors historical non-now entry timestamps (fixing latent bug)', () {
        // Verify that passing different historical dates calculates the expected
        // flow corresponding to those timestamps, proving no fallback to DateTime.now().
        final sunResult1 = SunriseCalculator.calculate(
          date: DateTime(2025, 1, 5), // Sunday
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        )!;
        final paksha1 = LunarPhaseCalculator.phaseForDate(sunResult1.sunrise);
        final expectedSundayDawn = SwaraClock.expectedFlowAt(
          time: sunResult1.sunrise.add(const Duration(minutes: 30)),
          sunrise: sunResult1.sunrise,
          paksha: paksha1,
        );

        final result1 = AlignmentChecker.check(
          actualFlow: expectedSundayDawn,
          time: sunResult1.sunrise.add(const Duration(minutes: 30)),
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );
        expect(result1?.expectedFlow, equals(expectedSundayDawn));
        expect(result1?.isAligned, isTrue);

        // A different day: Monday January 6, 2025
        final sunResult2 = SunriseCalculator.calculate(
          date: DateTime(2025, 1, 6), // Monday
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        )!;
        final paksha2 = LunarPhaseCalculator.phaseForDate(sunResult2.sunrise);
        final expectedMondayDawn = SwaraClock.expectedFlowAt(
          time: sunResult2.sunrise.add(const Duration(minutes: 30)),
          sunrise: sunResult2.sunrise,
          paksha: paksha2,
        );

        final result2 = AlignmentChecker.check(
          actualFlow: expectedMondayDawn,
          time: sunResult2.sunrise.add(const Duration(minutes: 30)),
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );
        expect(result2?.expectedFlow, equals(expectedMondayDawn));
        expect(result2?.isAligned, isTrue);
        expect(result1?.expectedFlow, isNot(equals(result2?.expectedFlow)));
      });

      test('pre-dawn time anchors to prior civil day cycle', () {
        // 04:00 on Thursday March 20, 2025 (before sunrise).
        // Anchors to Wednesday March 19 sunrise.
        final time = DateTime(2025, 3, 20, 4, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.lunar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.expectedFlow, equals(BreathFlow.lunar));
        expect(result.activeYama, isNull);
      });
    });

    group('Pakshi info', () {
      test('returns active bird and state during daylight', () {
        final time = DateTime(2025, 3, 20, 12, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.activeBird, isNotNull);
        expect(result.activeBirdState, isNotNull);
        expect(result.activeYama, isNotNull);
      });

      test('no bird info before sunrise', () {
        final time = DateTime(2025, 3, 20, 4, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.activeBird, isNull);
        expect(result.activeBirdState, isNull);
      });
    });

    group('Polar regions', () {
      test('returns null for extreme latitude in winter', () {
        final time = DateTime(2025, 12, 21, 12, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: 89,
          longitude: 0,
          utcOffset: 0,
        );

        expect(result, isNull);
      });
    });
  });

  group('BreathFlow', () {
    test('displayName returns correct strings', () {
      expect(BreathFlow.solar.displayName, equals('Solar (Right)'));
      expect(BreathFlow.lunar.displayName, equals('Lunar (Left)'));
      expect(BreathFlow.sushumna.displayName, equals('Sushumna (Both)'));
    });

    test('nostril returns correct DB values', () {
      expect(BreathFlow.solar.nostril, equals('right'));
      expect(BreathFlow.lunar.nostril, equals('left'));
      expect(BreathFlow.sushumna.nostril, equals('both'));
    });
  });
}
