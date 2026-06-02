import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';

void main() {
  group('OracleCalculator', () {
    final sunrise = DateTime(2025, 3, 20, 6, 0);
    final sunset = DateTime(2025, 3, 20, 18, 0);

    // Monday Rahu Kaal: 7:30 - 9:00
    final rahuKaal = RahuKaalCalculator.calculate(
      sunrise: sunrise,
      sunset: sunset,
      weekday: 1,
    );

    group('Floor Lockout during Rahu Kaal', () {
      test('A-25: score forced to 10% during Rahu Kaal', () {
        final duringRahu = DateTime(2025, 3, 20, 8, 0);

        final result = OracleCalculator.calculate(
          normalScore: 85,
          rahuKaal: rahuKaal,
          currentTime: duringRahu,
        );

        expect(result.readinessPercent, equals(kRahuFloorPercent));
        expect(result.isFloorLocked, isTrue);
      });

      test('high score still locked to 10% during Rahu', () {
        final duringRahu = DateTime(2025, 3, 20, 8, 30);

        final result = OracleCalculator.calculate(
          normalScore: 100,
          rahuKaal: rahuKaal,
          currentTime: duringRahu,
        );

        expect(result.readinessPercent, equals(10));
        expect(result.isFloorLocked, isTrue);
      });
    });

    group('Normal score outside Rahu Kaal', () {
      test('A-26: normal score passes through outside Rahu', () {
        final outsideRahu = DateTime(2025, 3, 20, 10, 0);

        final result = OracleCalculator.calculate(
          normalScore: 75,
          rahuKaal: rahuKaal,
          currentTime: outsideRahu,
        );

        expect(result.readinessPercent, equals(75));
        expect(result.isFloorLocked, isFalse);
      });

      test('score clamped to max 100', () {
        final outsideRahu = DateTime(2025, 3, 20, 10, 0);

        final result = OracleCalculator.calculate(
          normalScore: 150,
          rahuKaal: rahuKaal,
          currentTime: outsideRahu,
        );

        expect(result.readinessPercent, equals(100));
      });

      test('score clamped to min 0', () {
        final outsideRahu = DateTime(2025, 3, 20, 10, 0);

        final result = OracleCalculator.calculate(
          normalScore: -20,
          rahuKaal: rahuKaal,
          currentTime: outsideRahu,
        );

        expect(result.readinessPercent, equals(0));
      });
    });

    group('Boundary conditions', () {
      test('at Rahu start boundary — locked', () {
        final result = OracleCalculator.calculate(
          normalScore: 90,
          rahuKaal: rahuKaal,
          currentTime: rahuKaal.start,
        );

        expect(result.isFloorLocked, isTrue);
      });

      test('at Rahu end boundary — not locked', () {
        final result = OracleCalculator.calculate(
          normalScore: 90,
          rahuKaal: rahuKaal,
          currentTime: rahuKaal.end,
        );

        expect(result.isFloorLocked, isFalse);
        expect(result.readinessPercent, equals(90));
      });
    });
  });
}
