import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

void main() {
  group('YamaCalculator', () {
    // Standard test sunrise/sunset (12 hours daylight)
    final sunrise = DateTime(2025, 3, 20, 6, 0);
    final sunset = DateTime(2025, 3, 20, 18, 0);

    group('12-hour daylight', () {
      test('A-10: divides into 5 equal yamas of 144 minutes', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        expect(result.yamas.length, equals(5));
        expect(result.yamaDuration.inMinutes, equals(144));

        for (final yama in result.yamas) {
          expect(yama.duration.inMinutes, equals(144));
        }
      });

      test('first yama starts at sunrise', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        expect(result.yamas.first.start, equals(sunrise));
      });

      test('last yama ends at sunset', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        expect(result.yamas.last.end, equals(sunset));
      });

      test('yamas are contiguous (no gaps)', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        for (var i = 0; i < 4; i++) {
          expect(result.yamas[i].end, equals(result.yamas[i + 1].start));
        }
      });
    });

    group('8-hour winter daylight', () {
      test('A-11: each yama is 96 minutes', () {
        final winterSunrise = DateTime(2025, 12, 21, 8, 0);
        final winterSunset = DateTime(2025, 12, 21, 16, 0);

        final result = YamaCalculator.calculate(
          sunrise: winterSunrise,
          sunset: winterSunset,
        );

        expect(result.yamaDuration.inMinutes, equals(96));
      });
    });

    group('activeYama', () {
      test('A-12: time in middle of Yama 3 returns yama3', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        // Yama 3 starts at 6:00 + 288 min = 10:48
        // Middle of Yama 3 = 10:48 + 72 min = 12:00
        final midYama3 = DateTime(2025, 3, 20, 12, 0);
        final active = result.activeYama(midYama3);

        expect(active, isNotNull);
        expect(active!.index, equals(YamaIndex.yama3));
      });

      test('A-13: time at yama boundary returns the new yama', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        // Yama 2 starts at 6:00 + 144 min = 8:24
        final yama2Start = result.yamas[1].start;
        final active = result.activeYama(yama2Start);

        expect(active, isNotNull);
        expect(active!.index, equals(YamaIndex.yama2));
      });

      test('A-14: time before sunrise returns null', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        final beforeSunrise = DateTime(2025, 3, 20, 5, 30);
        final active = result.activeYama(beforeSunrise);

        expect(active, isNull);
      });

      test('A-15: time after sunset returns null', () {
        final result = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        final afterSunset = DateTime(2025, 3, 20, 18, 30);
        final active = result.activeYama(afterSunset);

        expect(active, isNull);
      });
    });

    group('Validation', () {
      test('throws if sunset is not after sunrise', () {
        expect(
          () => YamaCalculator.calculate(sunrise: sunset, sunset: sunrise),
          throwsArgumentError,
        );
      });

      test('throws if sunrise equals sunset', () {
        expect(
          () => YamaCalculator.calculate(sunrise: sunrise, sunset: sunrise),
          throwsArgumentError,
        );
      });
    });

    group('YamaIndex', () {
      test('has correct labels', () {
        expect(YamaIndex.yama1.label, equals('Yama 1'));
        expect(YamaIndex.yama5.label, equals('Yama 5'));
      });
    });
  });
}
