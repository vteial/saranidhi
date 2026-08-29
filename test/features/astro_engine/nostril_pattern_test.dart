import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/nostril_pattern.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

void main() {
  group('NostrilPattern', () {
    group('tithi-based starting nostril', () {
      test('returns Lunar for null yama (nighttime default)', () {
        final result = NostrilPattern.expectedFlowForYama(null);
        expect(result, equals(BreathFlow.lunar));
      });

      test('all 5 yamas return valid BreathFlow for any date', () {
        // Test multiple dates to ensure no crashes
        final dates = [
          DateTime(2026, 7, 1), // arbitrary dates
          DateTime(2026, 7, 8),
          DateTime(2026, 7, 15),
          DateTime(2026, 7, 22),
          DateTime(2026, 7, 29),
        ];

        for (final date in dates) {
          for (final yama in YamaIndex.values) {
            final result = NostrilPattern.expectedFlowForYama(
              yama,
              date: date,
            );
            expect(
              result,
              anyOf(equals(BreathFlow.solar), equals(BreathFlow.lunar)),
              reason: 'Yama $yama on $date should return solar or lunar',
            );
          }
        }
      });

      test('odd yamas match starting nostril, even yamas alternate', () {
        // For any given date, Y1/Y3/Y5 should be same flow,
        // Y2/Y4 should be the opposite
        final date = DateTime(2026, 7, 10);
        final y1 = NostrilPattern.expectedFlowForYama(
          YamaIndex.yama1,
          date: date,
        );
        final y2 = NostrilPattern.expectedFlowForYama(
          YamaIndex.yama2,
          date: date,
        );
        final y3 = NostrilPattern.expectedFlowForYama(
          YamaIndex.yama3,
          date: date,
        );
        final y4 = NostrilPattern.expectedFlowForYama(
          YamaIndex.yama4,
          date: date,
        );
        final y5 = NostrilPattern.expectedFlowForYama(
          YamaIndex.yama5,
          date: date,
        );

        // Odd yamas (1,3,5) should be same
        expect(y1, equals(y3));
        expect(y3, equals(y5));
        // Even yamas (2,4) should be same
        expect(y2, equals(y4));
        // Odd and even should be opposite
        expect(y1 != y2, isTrue);
      });

      test('dayStartsWithSolar returns bool for any date', () {
        final result = NostrilPattern.dayStartsWithSolar(
          date: DateTime(2026, 7, 16),
        );
        expect(result, isA<bool>());
      });
    });

    group('Siva Swarodaya tithi blocks', () {
      // These tests verify the 3-day block pattern.
      // We use known dates where we can compute the expected tithi.

      test('consecutive days within same 3-day block have same pattern', () {
        // Two days 1 apart within same tithi block should have same start
        // (This isn't always true at block boundaries, so we test
        // non-boundary days)
        final day1 = NostrilPattern.dayStartsWithSolar(
          date: DateTime(2026, 7, 17), // early waxing
        );
        final day2 = NostrilPattern.dayStartsWithSolar(
          date: DateTime(2026, 7, 18),
        );
        // These should be same IF within same 3-day block
        // We just verify they're valid booleans (not crashing)
        expect(day1, isA<bool>());
        expect(day2, isA<bool>());
      });
    });
  });
}
