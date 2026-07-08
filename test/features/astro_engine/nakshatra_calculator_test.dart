import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/nakshatra_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

void main() {
  group('NakshatraCalculator', () {
    group('Basic calculation', () {
      test('returns a valid nakshatra for a DOB', () {
        // A known DOB — results will depend on algorithm accuracy
        final result = NakshatraCalculator.calculate(
          DateTime.utc(1990, 5, 15, 10, 30),
        );

        expect(result.nakshatraIndex, greaterThanOrEqualTo(0));
        expect(result.nakshatraIndex, lessThanOrEqualTo(26));
        expect(result.nakshatra, isA<Nakshatra>());
        expect(result.standardName, isNotEmpty);
        expect(result.displayName, isNotEmpty);
      });

      test('sidereal longitude is between 0 and 360', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(1985, 8, 20, 14, 0),
        );

        expect(result.siderealLongitude, greaterThanOrEqualTo(0));
        expect(result.siderealLongitude, lessThan(360));
      });

      test('tropical longitude is between 0 and 360', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(1995, 12, 1, 6, 0),
        );

        expect(result.tropicalLongitude, greaterThanOrEqualTo(0));
        expect(result.tropicalLongitude, lessThan(360));
      });

      test('ayanamsa is reasonable (~22-25° for modern dates)', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(2000, 6, 15, 12, 0),
        );

        expect(result.ayanamsa, greaterThan(22));
        expect(result.ayanamsa, lessThan(25));
      });

      test('positionInNakshatra is between 0 and 1', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(1988, 3, 22, 9, 15),
        );

        expect(result.positionInNakshatra, greaterThanOrEqualTo(0));
        expect(result.positionInNakshatra, lessThanOrEqualTo(1));
      });
    });

    group('Nakshatra span coverage', () {
      test('all 27 nakshatras can be reached over a month', () {
        // Moon traverses all 27 nakshatras in ~27.3 days
        final seen = <int>{};
        for (var day = 0; day < 28; day++) {
          final result = NakshatraCalculator.calculate(
            DateTime.utc(2025, 3, 1 + day, 12),
          );
          seen.add(result.nakshatraIndex);
        }

        // Should see most nakshatras (at least 25 out of 27)
        expect(seen.length, greaterThanOrEqualTo(25));
      });

      test('consecutive days usually give different nakshatras', () {
        // Moon stays in one nakshatra for ~1 day, so most consecutive
        // days should differ
        var changes = 0;
        var previous = -1;
        for (var day = 0; day < 10; day++) {
          final result = NakshatraCalculator.calculate(
            DateTime.utc(2025, 6, 1 + day, 12),
          );
          if (result.nakshatraIndex != previous) changes++;
          previous = result.nakshatraIndex;
        }

        // Should change at least 7 times in 10 days
        expect(changes, greaterThanOrEqualTo(7));
      });
    });

    group('Time sensitivity', () {
      test('different birth times on same day can give different nakshatras', () {
        // Near a nakshatra boundary, time matters
        // We test that the calculator produces different results for
        // different times (Moon moves ~0.5°/hour)
        final morning = NakshatraCalculator.calculate(
          DateTime.utc(2025, 4, 10, 2),
        );
        final evening = NakshatraCalculator.calculate(
          DateTime.utc(2025, 4, 10, 22),
        );

        // 20 hours apart → Moon moves ~10° → likely different nakshatras
        // (each is 13.33° wide, so 10° difference might cross a boundary)
        final longDiff =
            (evening.siderealLongitude - morning.siderealLongitude).abs();
        // If it wrapped around 360, adjust
        final adjustedDiff = longDiff > 180 ? 360 - longDiff : longDiff;
        expect(adjustedDiff, greaterThan(5)); // At least 5° difference
      });
    });

    group('Boundary detection', () {
      test('isNearBoundary is a boolean', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(2000, 1, 1, 12),
        );

        expect(result.isNearBoundary, isA<bool>());
      });

      test('boundary detection based on threshold', () {
        // When position is very close to start or end of nakshatra
        // We can't force a specific DOB to land near boundary,
        // so just verify the logic is consistent
        final result = NakshatraCalculator.calculate(
          DateTime.utc(2025, 7, 15, 12),
        );

        if (result.positionInNakshatra < 0.0375 ||
            result.positionInNakshatra > 0.9625) {
          // 0.5° / 13.333° ≈ 0.0375
          expect(result.isNearBoundary, isTrue);
        }
      });
    });

    group('Integration with PakshiCalculator', () {
      test('standardName is recognized by PakshiCalculator', () {
        // Every nakshatra enum should produce a name that
        // PakshiCalculator can map to a bird
        for (final nakshatra in Nakshatra.values) {
          final bird = PakshiCalculator.birthBirdFromNakshatraSafe(
            nakshatra.standardName,
          );
          expect(
            bird,
            isNotNull,
            reason:
                '${nakshatra.standardName} should map to a bird',
          );
        }
      });

      test('calculate result maps to a valid bird', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(1992, 11, 5, 8, 30),
        );
        final bird = PakshiCalculator.birthBirdFromNakshatraSafe(
          result.standardName,
        );

        expect(bird, isNotNull);
        expect(bird, isA<PakshiBird>());
      });
    });

    group('nakshatraNameForDOB convenience', () {
      test('returns same as calculate().standardName', () {
        final dob = DateTime.utc(1988, 7, 20, 16, 45);
        final full = NakshatraCalculator.calculate(dob);
        final convenience = NakshatraCalculator.nakshatraNameForDOB(dob);

        expect(convenience, equals(full.standardName));
      });
    });

    group('indexFromSiderealLongitude', () {
      test('0° gives Ashwini (index 0)', () {
        final index = NakshatraCalculator.indexFromSiderealLongitude(0);
        expect(index, equals(0));
      });

      test('13.33° gives Bharani (index 1)', () {
        final index = NakshatraCalculator.indexFromSiderealLongitude(13.34);
        expect(index, equals(1));
      });

      test('350° gives Revati (index 26)', () {
        final index = NakshatraCalculator.indexFromSiderealLongitude(350);
        expect(index, equals(26));
      });

      test('359.99° gives Revati (index 26)', () {
        final index = NakshatraCalculator.indexFromSiderealLongitude(359.99);
        expect(index, equals(26));
      });

      test('negative longitude is normalized', () {
        final index = NakshatraCalculator.indexFromSiderealLongitude(-10);
        expect(index, greaterThanOrEqualTo(0));
        expect(index, lessThanOrEqualTo(26));
      });
    });

    group('fromSiderealLongitude', () {
      test('returns correct Nakshatra enum', () {
        expect(
          NakshatraCalculator.fromSiderealLongitude(5),
          equals(Nakshatra.ashwini),
        );
        expect(
          NakshatraCalculator.fromSiderealLongitude(100),
          equals(Nakshatra.pushya), // 93.33° - 106.67°
        );
      });
    });

    group('Nakshatra enum', () {
      test('has exactly 27 values', () {
        expect(Nakshatra.values.length, equals(27));
      });

      test('startDegree of first is 0', () {
        expect(Nakshatra.ashwini.startDegree, equals(0));
      });

      test('endDegree of last is 360', () {
        expect(Nakshatra.revati.endDegree, closeTo(360, 0.01));
      });

      test('all display names are non-empty', () {
        for (final n in Nakshatra.values) {
          expect(n.displayName.isNotEmpty, isTrue);
        }
      });

      test('all standard names are non-empty and lowercase', () {
        for (final n in Nakshatra.values) {
          expect(n.standardName.isNotEmpty, isTrue);
          expect(n.standardName, equals(n.standardName.toLowerCase()));
        }
      });
    });

    group('Historical dates', () {
      test('works for 1960s birth dates', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(1965, 3, 15, 5, 30),
        );

        expect(result.nakshatraIndex, greaterThanOrEqualTo(0));
        expect(result.nakshatraIndex, lessThanOrEqualTo(26));
      });

      test('works for recent (2020s) birth dates', () {
        final result = NakshatraCalculator.calculate(
          DateTime.utc(2024, 9, 1, 14, 0),
        );

        expect(result.nakshatraIndex, greaterThanOrEqualTo(0));
        expect(result.nakshatraIndex, lessThanOrEqualTo(26));
      });
    });
  });
}
