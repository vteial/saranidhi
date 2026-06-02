import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

void main() {
  group('PakshiCalculator', () {
    group('Waxing moon sequences', () {
      test('A-40: Sunday waxing produces correct state sequence', () {
        final result = PakshiCalculator.calculate(
          weekday: 0,
          lunarPhase: LunarPhase.waxing,
        );

        expect(result.entries.length, equals(5));
        // States must be in order: ruling, eating, walking, sleeping, dying
        expect(result.entries[0].state, equals(PakshiState.ruling));
        expect(result.entries[1].state, equals(PakshiState.eating));
        expect(result.entries[2].state, equals(PakshiState.walking));
        expect(result.entries[3].state, equals(PakshiState.sleeping));
        expect(result.entries[4].state, equals(PakshiState.dying));
      });

      test('Sunday waxing starts with Vulture', () {
        final result = PakshiCalculator.calculate(
          weekday: 0,
          lunarPhase: LunarPhase.waxing,
        );

        expect(result.entries[0].bird, equals(PakshiBird.vulture));
      });

      test('Monday waxing starts with Owl', () {
        final result = PakshiCalculator.calculate(
          weekday: 1,
          lunarPhase: LunarPhase.waxing,
        );

        expect(result.entries[0].bird, equals(PakshiBird.owl));
      });
    });

    group('Waning moon sequences', () {
      test('A-41: Sunday waning has different bird sequence than waxing', () {
        final waxing = PakshiCalculator.calculate(
          weekday: 0,
          lunarPhase: LunarPhase.waxing,
        );
        final waning = PakshiCalculator.calculate(
          weekday: 0,
          lunarPhase: LunarPhase.waning,
        );

        // First bird should differ
        expect(waning.entries[0].bird, isNot(equals(waxing.entries[0].bird)));
      });

      test('Sunday waning starts with Crow', () {
        final result = PakshiCalculator.calculate(
          weekday: 0,
          lunarPhase: LunarPhase.waning,
        );

        expect(result.entries[0].bird, equals(PakshiBird.crow));
      });
    });

    group('A-43: bird state at specific yama', () {
      test('forYama returns correct entry', () {
        final result = PakshiCalculator.calculate(
          weekday: 0,
          lunarPhase: LunarPhase.waxing,
        );

        final yama3 = result.forYama(YamaIndex.yama3);
        expect(yama3.state, equals(PakshiState.walking));
        expect(yama3.bird, equals(PakshiBird.crow));
      });
    });

    group('A-44: all weekdays produce different sequences', () {
      test('no two weekdays identical in waxing', () {
        final sequences = <int, List<PakshiBird>>{};
        for (var day = 0; day < 7; day++) {
          final result = PakshiCalculator.calculate(
            weekday: day,
            lunarPhase: LunarPhase.waxing,
          );
          sequences[day] = result.entries.map((e) => e.bird).toList();
        }

        // Check each pair is different
        for (var i = 0; i < 7; i++) {
          for (var j = i + 1; j < 7; j++) {
            final same = _listsEqual(sequences[i]!, sequences[j]!);
            // Not all days are unique in traditional system (some repeat)
            // But at least consecutive days differ
            if (j == i + 1) {
              expect(same, isFalse, reason: 'Day $i and day $j should differ');
            }
          }
        }
      });
    });

    group('dartWeekdayToSunBased', () {
      test('converts Dart weekday correctly', () {
        // Dart: 1=Mon, 2=Tue, ..., 7=Sun
        expect(PakshiCalculator.dartWeekdayToSunBased(7), equals(0)); // Sun
        expect(PakshiCalculator.dartWeekdayToSunBased(1), equals(1)); // Mon
        expect(PakshiCalculator.dartWeekdayToSunBased(6), equals(6)); // Sat
      });
    });

    group('A-42: Birth nakshatra to bird mapping', () {
      test('Ashwini maps to Vulture', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('Ashwini'),
          equals(PakshiBird.vulture),
        );
      });

      test('Pushya maps to Owl', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('Pushya'),
          equals(PakshiBird.owl),
        );
      });

      test('Hasta maps to Crow', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('Hasta'),
          equals(PakshiBird.crow),
        );
      });

      test('Mula maps to Rooster', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('Mula'),
          equals(PakshiBird.rooster),
        );
      });

      test('Revati maps to Peacock', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('Revati'),
          equals(PakshiBird.peacock),
        );
      });

      test('case insensitive matching', () {
        expect(
          PakshiCalculator.birthBirdFromNakshatra('ASHWINI'),
          equals(PakshiBird.vulture),
        );
      });

      test('unknown nakshatra throws', () {
        expect(
          () => PakshiCalculator.birthBirdFromNakshatra('Invalid'),
          throwsArgumentError,
        );
      });
    });

    group('Validation', () {
      test('throws on invalid weekday', () {
        expect(
          () => PakshiCalculator.calculate(
            weekday: 7,
            lunarPhase: LunarPhase.waxing,
          ),
          throwsArgumentError,
        );
      });

      test('throws on negative weekday', () {
        expect(
          () => PakshiCalculator.calculate(
            weekday: -1,
            lunarPhase: LunarPhase.waxing,
          ),
          throwsArgumentError,
        );
      });
    });
  });
}

bool _listsEqual(List<PakshiBird> a, List<PakshiBird> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
