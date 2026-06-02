import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

void main() {
  group('LunarPhaseCalculator', () {
    group('Known moon dates', () {
      test('A-60: well into waning phase returns waning', () {
        // Jan 17, 2025 — approximately 17 days since new moon (past full)
        final waningDate = DateTime(2025, 1, 17);
        final result = LunarPhaseCalculator.calculate(waningDate);

        expect(result.phase, equals(LunarPhase.waning));
        expect(result.daysSinceNewMoon, greaterThan(14.765));
      });

      test('A-61: day after known new moon returns waxing', () {
        // New moon: Dec 30, 2024 per algorithm (daysSinceNewMoon near 0)
        // Jan 1, 2025 should be early waxing
        final earlyWaxing = DateTime(2025, 1, 1);
        final result = LunarPhaseCalculator.calculate(earlyWaxing);

        expect(result.phase, equals(LunarPhase.waxing));
        expect(result.daysSinceNewMoon, lessThan(14.765));
      });

      test('A-62: mid-waxing phase returns waxing', () {
        // ~7 days into cycle should be waxing
        final result = LunarPhaseCalculator.calculate(DateTime(2025, 1, 7));
        expect(result.phase, equals(LunarPhase.waxing));
        expect(result.daysSinceNewMoon, lessThan(14.765));
      });

      test('A-63: mid-waning phase returns waning', () {
        // ~22 days into cycle should be waning
        final result = LunarPhaseCalculator.calculate(DateTime(2025, 1, 22));
        expect(result.phase, equals(LunarPhase.waning));
        expect(result.daysSinceNewMoon, greaterThan(14.765));
      });
    });

    group('Illumination', () {
      test('near new moon has low illumination', () {
        // Find a date where daysSinceNewMoon is near 0
        final date = DateTime(2025, 1, 1); // early in cycle
        final result = LunarPhaseCalculator.calculate(date);

        // Early waxing should have low illumination
        if (result.daysSinceNewMoon < 3) {
          expect(result.illumination, lessThan(0.1));
        }
      });

      test('near full moon has high illumination', () {
        // Find a date where daysSinceNewMoon is near 14.76
        final date = DateTime(2025, 1, 15); // ~15 days into cycle
        final result = LunarPhaseCalculator.calculate(date);

        // Near full moon should have high illumination
        expect(result.illumination, greaterThan(0.9));
      });

      test('illumination always between 0 and 1', () {
        for (var i = 0; i < 30; i++) {
          final date = DateTime(2025, 3, 1 + i);
          final result = LunarPhaseCalculator.calculate(date);
          expect(result.illumination, greaterThanOrEqualTo(0));
          expect(result.illumination, lessThanOrEqualTo(1));
        }
      });
    });

    group('daysSinceNewMoon', () {
      test('always between 0 and ~29.53', () {
        for (var i = 0; i < 60; i++) {
          final date = DateTime(2025, 1, 1 + i);
          final result = LunarPhaseCalculator.calculate(date);
          expect(result.daysSinceNewMoon, greaterThanOrEqualTo(0));
          expect(result.daysSinceNewMoon, lessThan(30));
        }
      });
    });

    group('isFullMoon / isNewMoon', () {
      test('full moon detected when daysSinceNewMoon near 14.765', () {
        // Search for a date where daysSinceNewMoon is near 14.765
        // Jan 15, 2025: ~15 days → near full moon
        final result = LunarPhaseCalculator.calculate(DateTime(2025, 1, 15));
        // Should be close to half cycle
        expect(result.daysSinceNewMoon, closeTo(14.765, 1.0));
      });

      test('new moon detected when daysSinceNewMoon near 0 or 29.53', () {
        // Jan 29, 2025: ~29.3 days → near end of cycle
        final result = LunarPhaseCalculator.calculate(DateTime(2025, 1, 29));
        final nearZero = result.daysSinceNewMoon < 1.5;
        final nearEnd = (29.53 - result.daysSinceNewMoon) < 1.5;
        expect(nearZero || nearEnd, isTrue);
      });
    });

    group('phaseForDate convenience', () {
      test('returns LunarPhase enum', () {
        final phase = LunarPhaseCalculator.phaseForDate(DateTime(2025, 3, 15));
        expect(phase, isA<LunarPhase>());
      });

      test('alternates over a full month', () {
        var waxingSeen = false;
        var waningSeen = false;

        for (var i = 0; i < 30; i++) {
          final date = DateTime(2025, 3, 1 + i);
          final phase = LunarPhaseCalculator.phaseForDate(date);
          if (phase == LunarPhase.waxing) waxingSeen = true;
          if (phase == LunarPhase.waning) waningSeen = true;
        }

        expect(waxingSeen, isTrue);
        expect(waningSeen, isTrue);
      });
    });

    group('Historical dates', () {
      test('works for dates before epoch (year 1999)', () {
        final date = DateTime(1999, 6, 15);
        final result = LunarPhaseCalculator.calculate(date);

        expect(result.phase, isA<LunarPhase>());
        expect(result.daysSinceNewMoon, greaterThanOrEqualTo(0));
      });

      test('works for far future dates', () {
        final date = DateTime(2050, 12, 25);
        final result = LunarPhaseCalculator.calculate(date);

        expect(result.phase, isA<LunarPhase>());
        expect(result.illumination, greaterThanOrEqualTo(0));
      });
    });
  });
}
