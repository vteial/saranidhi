import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';

void main() {
  group('RahuKaalCalculator', () {
    final sunrise = DateTime(2025, 3, 20, 6, 0);
    final sunset = DateTime(2025, 3, 20, 18, 0);
    // 12 hours = 720 min, 8 segments = 90 min each

    group('Segment assignment by weekday', () {
      test('A-20: Sunday uses 8th segment', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0, // Sunday
        );

        // 8th segment: starts at 6:00 + 7*90min = 6:00 + 630min = 16:30
        expect(result.start.hour, equals(16));
        expect(result.start.minute, equals(30));
        expect(result.end.hour, equals(18));
        expect(result.end.minute, equals(0));
      });

      test('A-21: Monday uses 2nd segment', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 1, // Monday
        );

        // 2nd segment: starts at 6:00 + 1*90min = 7:30
        expect(result.start.hour, equals(7));
        expect(result.start.minute, equals(30));
        expect(result.end.hour, equals(9));
        expect(result.end.minute, equals(0));
      });

      test('A-22: Saturday uses 3rd segment', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 6, // Saturday
        );

        // 3rd segment: starts at 6:00 + 2*90min = 9:00
        expect(result.start.hour, equals(9));
        expect(result.start.minute, equals(0));
        expect(result.end.hour, equals(10));
        expect(result.end.minute, equals(30));
      });

      test('Tuesday uses 7th segment', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 2, // Tuesday
        );

        // 7th segment: starts at 6:00 + 6*90min = 15:00
        expect(result.start.hour, equals(15));
        expect(result.start.minute, equals(0));
      });

      test('Wednesday uses 5th segment', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 3, // Wednesday
        );

        // 5th segment: starts at 6:00 + 4*90min = 12:00
        expect(result.start.hour, equals(12));
        expect(result.start.minute, equals(0));
      });

      test('Thursday uses 6th segment', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 4, // Thursday
        );

        // 6th segment: starts at 6:00 + 5*90min = 13:30
        expect(result.start.hour, equals(13));
        expect(result.start.minute, equals(30));
      });

      test('Friday uses 4th segment', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 5, // Friday
        );

        // 4th segment: starts at 6:00 + 3*90min = 10:30
        expect(result.start.hour, equals(10));
        expect(result.start.minute, equals(30));
      });
    });

    group('isActive', () {
      test('A-23: time inside Rahu Kaal returns true', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 1, // Monday, 2nd segment: 7:30-9:00
        );

        final inside = DateTime(2025, 3, 20, 8, 0);
        expect(result.isActive(inside), isTrue);
      });

      test('A-24: time outside Rahu Kaal returns false', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 1, // Monday, 2nd segment: 7:30-9:00
        );

        final outside = DateTime(2025, 3, 20, 10, 0);
        expect(result.isActive(outside), isFalse);
      });

      test('time at start boundary is inside', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 1,
        );

        expect(result.isActive(result.start), isTrue);
      });

      test('time at end boundary is outside', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 1,
        );

        expect(result.isActive(result.end), isFalse);
      });
    });

    group('Duration', () {
      test('duration equals one-eighth of daylight', () {
        final result = RahuKaalCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
          weekday: 0,
        );

        expect(result.duration.inMinutes, equals(90));
      });
    });

    group('Validation', () {
      test('throws on invalid weekday', () {
        expect(
          () => RahuKaalCalculator.calculate(
            sunrise: sunrise,
            sunset: sunset,
            weekday: 7,
          ),
          throwsArgumentError,
        );
      });

      test('throws if sunset not after sunrise', () {
        expect(
          () => RahuKaalCalculator.calculate(
            sunrise: sunset,
            sunset: sunrise,
            weekday: 0,
          ),
          throwsArgumentError,
        );
      });
    });
  });
}
