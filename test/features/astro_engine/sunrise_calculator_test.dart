import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/sunrise_calculator.dart';

void main() {
  group('SunriseCalculator', () {
    group('Equator on equinox', () {
      test('A-01: sunrise near 06:00 local time', () {
        // March 20 equinox, equator (0,0), UTC+0
        final result = SunriseCalculator.calculate(
          date: DateTime(2025, 3, 20),
          latitude: 0,
          longitude: 0,
          utcOffset: 0,
        );

        expect(result, isNotNull);
        // Sunrise should be approximately 06:00 (within 10 minutes)
        final sunriseMinutes =
            result!.sunrise.hour * 60 + result.sunrise.minute;
        expect(sunriseMinutes, closeTo(360, 10)); // 360 = 6:00 AM
      });

      test('A-04: daylight duration matches ~12 hours at equinox', () {
        final result = SunriseCalculator.calculate(
          date: DateTime(2025, 3, 20),
          latitude: 0,
          longitude: 0,
          utcOffset: 0,
        );

        expect(result, isNotNull);
        // At equator on equinox, daylight ~12 hours (within 20 min)
        expect(result!.daylightDuration.inMinutes, closeTo(720, 20));
      });
    });

    group('High latitude scenarios', () {
      test('A-02: early sunrise at 60N summer solstice', () {
        // June 21, 60°N, UTC+2 (Helsinki-ish)
        final result = SunriseCalculator.calculate(
          date: DateTime(2025, 6, 21),
          latitude: 60,
          longitude: 25,
          utcOffset: 3,
        );

        expect(result, isNotNull);
        // Very early sunrise expected (before 04:00)
        final sunriseHour = result!.sunrise.hour;
        expect(sunriseHour, lessThan(5));
      });

      test('A-03: late sunrise at 60N winter solstice', () {
        // December 21, 60°N, UTC+2
        final result = SunriseCalculator.calculate(
          date: DateTime(2025, 12, 21),
          latitude: 60,
          longitude: 25,
          utcOffset: 2,
        );

        expect(result, isNotNull);
        // Late sunrise expected (after 09:00)
        final sunriseHour = result!.sunrise.hour;
        expect(sunriseHour, greaterThanOrEqualTo(9));
      });
    });

    group('Southern hemisphere', () {
      test(
        'A-06: December sunrise earlier than June in southern hemisphere',
        () {
          // Sydney: -33.87, 151.21, UTC+11 (summer) / UTC+10 (winter)
          final december = SunriseCalculator.calculate(
            date: DateTime(2025, 12, 21),
            latitude: -33.87,
            longitude: 151.21,
            utcOffset: 11,
          );
          final june = SunriseCalculator.calculate(
            date: DateTime(2025, 6, 21),
            latitude: -33.87,
            longitude: 151.21,
            utcOffset: 10,
          );

          expect(december, isNotNull);
          expect(june, isNotNull);
          // In southern hemisphere, December is summer (earlier sunrise)
          final decSunriseMin =
              december!.sunrise.hour * 60 + december.sunrise.minute;
          final junSunriseMin = june!.sunrise.hour * 60 + june.sunrise.minute;
          expect(decSunriseMin, lessThan(junSunriseMin));
        },
      );
    });

    group('Indian locations', () {
      test('Chennai sunrise around 06:00 IST on equinox', () {
        // Chennai: 13.08, 80.27, IST (UTC+5.5)
        final result = SunriseCalculator.calculate(
          date: DateTime(2025, 3, 20),
          latitude: 13.08,
          longitude: 80.27,
          utcOffset: 5.5,
        );

        expect(result, isNotNull);
        final sunriseMinutes =
            result!.sunrise.hour * 60 + result.sunrise.minute;
        // Chennai equinox sunrise ~06:10-06:20 IST
        expect(sunriseMinutes, closeTo(370, 15));
      });
    });

    group('Validation', () {
      test('A-05: invalid latitude throws ArgumentError', () {
        expect(
          () => SunriseCalculator.calculate(
            date: DateTime(2025, 3, 20),
            latitude: 91,
            longitude: 0,
            utcOffset: 0,
          ),
          throwsArgumentError,
        );
      });

      test('invalid longitude throws ArgumentError', () {
        expect(
          () => SunriseCalculator.calculate(
            date: DateTime(2025, 3, 20),
            latitude: 0,
            longitude: 181,
            utcOffset: 0,
          ),
          throwsArgumentError,
        );
      });

      test('negative latitude throws ArgumentError', () {
        expect(
          () => SunriseCalculator.calculate(
            date: DateTime(2025, 3, 20),
            latitude: -91,
            longitude: 0,
            utcOffset: 0,
          ),
          throwsArgumentError,
        );
      });
    });

    group('Polar conditions', () {
      test('returns null for polar night (extreme latitude in winter)', () {
        // 89°N in December — sun doesn't rise
        final result = SunriseCalculator.calculate(
          date: DateTime(2025, 12, 21),
          latitude: 89,
          longitude: 0,
          utcOffset: 0,
        );

        // May return null for polar night
        // (algorithm returns null when cosH > 1 or < -1)
        // At 89°N winter solstice, this should be polar night
        expect(result, isNull);
      });
    });

    group('Consistency checks', () {
      test('sunset is always after sunrise', () {
        // Test multiple dates
        final dates = [
          DateTime(2025, 1, 15),
          DateTime(2025, 4, 15),
          DateTime(2025, 7, 15),
          DateTime(2025, 10, 15),
        ];

        for (final date in dates) {
          final result = SunriseCalculator.calculate(
            date: date,
            latitude: 13.08,
            longitude: 80.27,
            utcOffset: 5.5,
          );

          expect(result, isNotNull);
          expect(result!.sunset.isAfter(result.sunrise), isTrue);
        }
      });

      test('daylight duration equals sunset minus sunrise', () {
        final result = SunriseCalculator.calculate(
          date: DateTime(2025, 6, 15),
          latitude: 40,
          longitude: -74,
          utcOffset: -4,
        );

        expect(result, isNotNull);
        final calculatedDuration = result!.sunset.difference(result.sunrise);
        expect(
          result.daylightDuration.inMinutes,
          equals(calculatedDuration.inMinutes),
        );
      });
    });
  });
}
