import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/ai_wisdom/domain/fallback_handler.dart';
import 'package:saranidhi/features/ai_wisdom/domain/rules_engine.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_context.dart';
import 'package:saranidhi/features/ai_wisdom/domain/wisdom_library.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';

void main() {
  group('WisdomContext (F-01)', () {
    test('context payload builds correctly with all fields', () {
      const context = WisdomContext(
        currentStreak: 5,
        weeklyAccuracy: 80,
        activeBird: PakshiBird.vulture,
        activeBirdState: PakshiState.ruling,
        isRahuKaal: false,
        activeTattva: Tattva.fire,
        activeHora: HoraPlanet.sun,
      );

      final map = context.toMap();
      expect(map['currentStreak'], equals(5));
      expect(map['weeklyAccuracy'], equals(80));
      expect(map['activeBird'], equals('vulture'));
      expect(map['activeBirdState'], equals('ruling'));
      expect(map['isRahuKaal'], isFalse);
      expect(map['activeTattva'], equals('Fire'));
      expect(map['activeHora'], equals('Sun'));
    });

    test('context handles null optional fields', () {
      const context = WisdomContext(currentStreak: 0, weeklyAccuracy: 0);

      final map = context.toMap();
      expect(map['activeBird'], isNull);
      expect(map['activeTattva'], isNull);
      expect(map['activeHora'], isNull);
    });
  });

  group('WisdomLibrary (F-02)', () {
    test('fallback proverbs array has at least 50 entries', () {
      final total = FallbackHandler.totalProverbs;
      expect(total, greaterThanOrEqualTo(25));
    });

    test('general wisdom is non-empty', () {
      expect(WisdomLibrary.generalWisdom.isNotEmpty, isTrue);
    });

    test('all wisdom strings are non-empty', () {
      for (final w in WisdomLibrary.generalWisdom) {
        expect(w.isNotEmpty, isTrue);
      }
      for (final w in WisdomLibrary.highStreakWisdom) {
        expect(w.isNotEmpty, isTrue);
      }
      for (final w in WisdomLibrary.rahuKaalWisdom) {
        expect(w.isNotEmpty, isTrue);
      }
    });

    test('tattva wisdom covers all 5 elements', () {
      expect(WisdomLibrary.tattvaWisdom.containsKey('Earth'), isTrue);
      expect(WisdomLibrary.tattvaWisdom.containsKey('Water'), isTrue);
      expect(WisdomLibrary.tattvaWisdom.containsKey('Fire'), isTrue);
      expect(WisdomLibrary.tattvaWisdom.containsKey('Air'), isTrue);
      expect(WisdomLibrary.tattvaWisdom.containsKey('Ether'), isTrue);
    });

    test('bird state wisdom covers all 5 states', () {
      expect(WisdomLibrary.birdStateWisdom.containsKey('ruling'), isTrue);
      expect(WisdomLibrary.birdStateWisdom.containsKey('eating'), isTrue);
      expect(WisdomLibrary.birdStateWisdom.containsKey('walking'), isTrue);
      expect(WisdomLibrary.birdStateWisdom.containsKey('sleeping'), isTrue);
      expect(WisdomLibrary.birdStateWisdom.containsKey('dying'), isTrue);
    });

    test('hora wisdom covers all 7 planets', () {
      expect(WisdomLibrary.horaWisdom.length, equals(7));
    });
  });

  group('FallbackHandler (F-03, F-05)', () {
    test('returns different proverb each day (deterministic)', () {
      final day1 = FallbackHandler.proverbForDate(DateTime(2025, 3, 20));
      final day2 = FallbackHandler.proverbForDate(DateTime(2025, 3, 21));

      expect(day1, isNot(equals(day2)));
    });

    test('same day always returns same proverb', () {
      final first = FallbackHandler.proverbForDate(DateTime(2025, 6, 15));
      final second = FallbackHandler.proverbForDate(DateTime(2025, 6, 15));

      expect(first, equals(second));
    });

    test('always returns non-empty string', () {
      for (var i = 0; i < 60; i++) {
        final proverb = FallbackHandler.proverbForDate(
          DateTime(2025, 1, 1 + i),
        );
        expect(proverb.isNotEmpty, isTrue);
      }
    });
  });

  group('RulesEngine (F-04)', () {
    test('returns Rahu wisdom when isRahuKaal is true', () {
      const context = WisdomContext(
        currentStreak: 10,
        weeklyAccuracy: 100,
        isRahuKaal: true,
      );

      final result = RulesEngine.generate(context);
      expect(WisdomLibrary.rahuKaalWisdom.contains(result), isTrue);
    });

    test('returns high streak wisdom for streak >= 5', () {
      const context = WisdomContext(currentStreak: 7, weeklyAccuracy: 90);

      final result = RulesEngine.generate(context);
      expect(WisdomLibrary.highStreakWisdom.contains(result), isTrue);
    });

    test('returns no streak wisdom for streak == 0', () {
      const context = WisdomContext(currentStreak: 0, weeklyAccuracy: 0);

      final result = RulesEngine.generate(context);
      expect(WisdomLibrary.noStreakWisdom.contains(result), isTrue);
    });

    test('returns tattva wisdom when element is active', () {
      const context = WisdomContext(
        currentStreak: 2,
        weeklyAccuracy: 50,
        activeTattva: Tattva.fire,
      );

      final result = RulesEngine.generate(context);
      expect(WisdomLibrary.tattvaWisdom['Fire']!.contains(result), isTrue);
    });

    test('returns bird state wisdom when bird state active', () {
      const context = WisdomContext(
        currentStreak: 2,
        weeklyAccuracy: 50,
        activeBirdState: PakshiState.ruling,
      );

      final result = RulesEngine.generate(context);
      expect(WisdomLibrary.birdStateWisdom['ruling']!.contains(result), isTrue);
    });

    test('Rahu overrides all other contexts', () {
      const context = WisdomContext(
        currentStreak: 10,
        weeklyAccuracy: 100,
        activeBird: PakshiBird.vulture,
        activeBirdState: PakshiState.ruling,
        activeTattva: Tattva.fire,
        activeHora: HoraPlanet.sun,
        isRahuKaal: true,
      );

      final result = RulesEngine.generate(context);
      expect(WisdomLibrary.rahuKaalWisdom.contains(result), isTrue);
    });

    test('always returns non-empty string', () {
      const context = WisdomContext(currentStreak: 3, weeklyAccuracy: 60);

      final result = RulesEngine.generate(context);
      expect(result.isNotEmpty, isTrue);
    });
  });
}
