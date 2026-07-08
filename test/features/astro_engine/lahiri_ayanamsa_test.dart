import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/lahiri_ayanamsa.dart';

void main() {
  group('LahiriAyanamsa', () {
    group('Known reference values', () {
      test('J2000.0 (Jan 1, 2000) gives ~23.85°', () {
        final result = LahiriAyanamsa.calculate(DateTime.utc(2000, 1, 1, 12));

        // At J2000.0, Lahiri ayanamsa is defined as ~23° 51' 09"
        expect(result.degrees, closeTo(23.8525, 0.05));
      });

      test('year 2025 gives ~24.17° (24° 10\' approximately)', () {
        // Official value for 2025: ~24° 10' 32"
        final result = LahiriAyanamsa.calculate(DateTime.utc(2025, 1, 1));

        // Should be approximately 24.17° (within 0.1°)
        expect(result.degrees, closeTo(24.17, 0.1));
      });

      test('year 1950 gives ~23.15° approximately', () {
        // Lahiri ayanamsa was ~23° 09' in 1950
        final result = LahiriAyanamsa.calculate(DateTime.utc(1950, 1, 1));

        expect(result.degrees, closeTo(23.15, 0.15));
      });

      test('year 1900 gives ~22.46° approximately', () {
        // Lahiri ayanamsa was ~22° 27' in 1900
        final result = LahiriAyanamsa.calculate(DateTime.utc(1900, 1, 1));

        expect(result.degrees, closeTo(22.46, 0.2));
      });
    });

    group('Monotonic increase', () {
      test('ayanamsa increases over time (precession)', () {
        final y2000 = LahiriAyanamsa.forDate(DateTime.utc(2000, 1, 1));
        final y2010 = LahiriAyanamsa.forDate(DateTime.utc(2010, 1, 1));
        final y2020 = LahiriAyanamsa.forDate(DateTime.utc(2020, 1, 1));
        final y2025 = LahiriAyanamsa.forDate(DateTime.utc(2025, 1, 1));

        expect(y2010, greaterThan(y2000));
        expect(y2020, greaterThan(y2010));
        expect(y2025, greaterThan(y2020));
      });

      test('increases by ~50 arcsec per year (~0.014° per year)', () {
        final y2020 = LahiriAyanamsa.forDate(DateTime.utc(2020, 1, 1));
        final y2021 = LahiriAyanamsa.forDate(DateTime.utc(2021, 1, 1));

        final annualIncrease = y2021 - y2020;
        // ~50.3" per year = ~0.01397° per year
        expect(annualIncrease, closeTo(0.01397, 0.002));
      });
    });

    group('forDate convenience', () {
      test('returns same value as calculate().degrees', () {
        final dt = DateTime.utc(2025, 6, 15);
        final full = LahiriAyanamsa.calculate(dt);
        final convenience = LahiriAyanamsa.forDate(dt);

        expect(convenience, equals(full.degrees));
      });
    });

    group('Formatting', () {
      test('formatted output is valid DMS string', () {
        final result = LahiriAyanamsa.calculate(DateTime.utc(2025, 1, 1));

        expect(result.formatted, contains('°'));
        expect(result.formatted, contains("'"));
        expect(result.formatted, contains('"'));
      });

      test('arcMinutes between 0 and 59', () {
        final result = LahiriAyanamsa.calculate(DateTime.utc(2025, 6, 15));

        expect(result.arcMinutes, greaterThanOrEqualTo(0));
        expect(result.arcMinutes, lessThan(60));
      });

      test('arcSeconds between 0 and 59', () {
        final result = LahiriAyanamsa.calculate(DateTime.utc(2025, 6, 15));

        expect(result.arcSeconds, greaterThanOrEqualTo(0));
        expect(result.arcSeconds, lessThan(60));
      });
    });

    group('Range validation', () {
      test('value between 20° and 30° for dates 1800–2200', () {
        // Ayanamsa has been between ~20° (1800) and won't reach 30° until ~2400
        final dates = [
          DateTime.utc(1800, 1, 1),
          DateTime.utc(1900, 1, 1),
          DateTime.utc(2000, 1, 1),
          DateTime.utc(2100, 1, 1),
          DateTime.utc(2200, 1, 1),
        ];

        for (final date in dates) {
          final value = LahiriAyanamsa.forDate(date);
          expect(
            value,
            greaterThan(20),
            reason: '${date.year} ayanamsa should be > 20°',
          );
          expect(
            value,
            lessThan(30),
            reason: '${date.year} ayanamsa should be < 30°',
          );
        }
      });
    });

    group('Time sensitivity', () {
      test('difference within same day is negligible (<0.001°)', () {
        final morning = LahiriAyanamsa.forDate(DateTime.utc(2025, 3, 15, 6));
        final evening = LahiriAyanamsa.forDate(DateTime.utc(2025, 3, 15, 18));

        // Ayanamsa changes ~0.000038° per hour → ~0.00046° in 12h
        expect((evening - morning).abs(), lessThan(0.001));
      });
    });

    group('Sidereal longitude application', () {
      test('tropical - ayanamsa gives reasonable sidereal longitude', () {
        // If tropical Moon is at 120° and ayanamsa is ~24°,
        // sidereal should be ~96°
        final ayanamsa = LahiriAyanamsa.forDate(DateTime.utc(2025, 1, 1));
        const tropicalLongitude = 120.0;
        final siderealLongitude = tropicalLongitude - ayanamsa;

        expect(siderealLongitude, closeTo(96, 1));
      });
    });
  });
}
