import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

void main() {
  group('TattvaCalculator', () {
    // A yama of 100 minutes for easy math
    final yamaStart = DateTime(2025, 3, 20, 10, 0);
    final yamaEnd = DateTime(2025, 3, 20, 11, 40); // 100 minutes
    final yama = YamaSegment(
      index: YamaIndex.yama3,
      start: yamaStart,
      end: yamaEnd,
    );

    group('A-50: Elements cycle in correct order', () {
      test('produces 5 tattvas in order', () {
        final tattvas = TattvaCalculator.calculateForYama(yama);

        expect(tattvas.length, equals(5));
        expect(tattvas[0].tattva, equals(Tattva.earth));
        expect(tattvas[1].tattva, equals(Tattva.water));
        expect(tattvas[2].tattva, equals(Tattva.fire));
        expect(tattvas[3].tattva, equals(Tattva.air));
        expect(tattvas[4].tattva, equals(Tattva.ether));
      });
    });

    group('A-51: Each element duration within Yama', () {
      test('each tattva is 20 minutes in a 100-minute yama', () {
        final tattvas = TattvaCalculator.calculateForYama(yama);

        for (final tattva in tattvas) {
          expect(tattva.duration.inMinutes, equals(20));
        }
      });

      test('first tattva starts at yama start', () {
        final tattvas = TattvaCalculator.calculateForYama(yama);
        expect(tattvas.first.start, equals(yamaStart));
      });

      test('last tattva ends at yama end', () {
        final tattvas = TattvaCalculator.calculateForYama(yama);
        expect(tattvas.last.end, equals(yamaEnd));
      });

      test('tattvas are contiguous', () {
        final tattvas = TattvaCalculator.calculateForYama(yama);
        for (var i = 0; i < 4; i++) {
          expect(tattvas[i].end, equals(tattvas[i + 1].start));
        }
      });
    });

    group('A-52: Active element at given time', () {
      test('returns Earth at start of yama', () {
        final result = TattvaCalculator.activeTattva(
          time: yamaStart,
          yamaSegment: yama,
        );

        expect(result, isNotNull);
        expect(result!.tattva, equals(Tattva.earth));
      });

      test('returns Fire at 40-60 minute mark', () {
        // Fire is the 3rd element, starts at 40 min
        final fireTime = yamaStart.add(const Duration(minutes: 45));
        final result = TattvaCalculator.activeTattva(
          time: fireTime,
          yamaSegment: yama,
        );

        expect(result, isNotNull);
        expect(result!.tattva, equals(Tattva.fire));
      });

      test('returns Ether at end of yama', () {
        // Ether is last, starts at 80 min
        final etherTime = yamaStart.add(const Duration(minutes: 85));
        final result = TattvaCalculator.activeTattva(
          time: etherTime,
          yamaSegment: yama,
        );

        expect(result, isNotNull);
        expect(result!.tattva, equals(Tattva.ether));
      });

      test('returns null for time outside yama', () {
        final outside = DateTime(2025, 3, 20, 9, 0);
        final result = TattvaCalculator.activeTattva(
          time: outside,
          yamaSegment: yama,
        );

        expect(result, isNull);
      });
    });

    group('Tattva properties', () {
      test('Sanskrit names are correct', () {
        expect(Tattva.earth.sanskritName, equals('Prithvi'));
        expect(Tattva.water.sanskritName, equals('Apas'));
        expect(Tattva.fire.sanskritName, equals('Tejas'));
        expect(Tattva.air.sanskritName, equals('Vayu'));
        expect(Tattva.ether.sanskritName, equals('Akasha'));
      });

      test('display names are capitalized', () {
        expect(Tattva.earth.displayName, equals('Earth'));
        expect(Tattva.ether.displayName, equals('Ether'));
      });
    });

    group('With real yama from YamaCalculator', () {
      test('tattvas divide a 144-minute yama into ~28.8 min each', () {
        final sunrise = DateTime(2025, 3, 20, 6, 0);
        final sunset = DateTime(2025, 3, 20, 18, 0);
        final yamaResult = YamaCalculator.calculate(
          sunrise: sunrise,
          sunset: sunset,
        );

        final tattvas = TattvaCalculator.calculateForYama(yamaResult.yamas[0]);

        // 144 min / 5 = 28.8 min ≈ 28 min (integer division)
        for (final t in tattvas) {
          expect(t.duration.inMinutes, closeTo(28.8, 1));
        }
      });
    });
  });
}
