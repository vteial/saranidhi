import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/daylight_segment_resolver.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_swara_affinity.dart';
import 'package:saranidhi/features/astro_engine/domain/name_bird_parser.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/tara_category.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

void main() {
  group('NameBirdParser', () {
    test('English vowels map correctly', () {
      expect(NameBirdParser.parse('Arun'), PakshiBird.vulture);
      expect(NameBirdParser.parse('Indira'), PakshiBird.owl);
      expect(NameBirdParser.parse('Uma'), PakshiBird.crow);
      expect(NameBirdParser.parse('Ezhil'), PakshiBird.rooster);
      expect(NameBirdParser.parse('Om'), PakshiBird.peacock);
    });

    test('Tamil Unicode vowels map correctly', () {
      expect(NameBirdParser.parse('\u0B85\u0BB0\u0BC1\u0BA3\u0BCD'), PakshiBird.vulture);
      expect(NameBirdParser.parse('\u0B87\u0BA8\u0BCD\u0BA4\u0BBF\u0BB0\u0BBE'), PakshiBird.owl);
      expect(NameBirdParser.parse('\u0B89\u0BAE\u0BBE'), PakshiBird.crow);
      expect(NameBirdParser.parse('\u0B8E\u0BB4\u0BBF\u0BB2\u0BCD'), PakshiBird.rooster);
      expect(NameBirdParser.parse('\u0B93\u0BAE\u0BCD'), PakshiBird.peacock);
    });

    test('empty name returns vulture', () {
      expect(NameBirdParser.parse(''), PakshiBird.vulture);
      expect(NameBirdParser.parse('   '), PakshiBird.vulture);
    });

    test('consonant-only name returns vulture', () {
      expect(NameBirdParser.parse('xyz'), PakshiBird.vulture);
    });

    test('first vowel is used, not first letter', () {
      expect(NameBirdParser.parse('Sri'), PakshiBird.owl); // 'i' is first vowel
      expect(NameBirdParser.parse('Prem'), PakshiBird.rooster); // 'e' is first vowel
    });
  });

  group('TaraCategory', () {
    test('same nakshatra returns janma', () {
      expect(TaraCategory.resolve(7, 7), TaraCategory.janma);
    });

    test('modulo-9 wraps correctly', () {
      // Birth=0 (Ashwini), Transit=1 (Bharani) → diff=1 → sampat
      expect(TaraCategory.resolve(0, 1), TaraCategory.sampat);
      // Birth=0, Transit=2 → diff=2 → vipat
      expect(TaraCategory.resolve(0, 2), TaraCategory.vipat);
    });

    test('negative difference wraps with +27', () {
      // Birth=5, Transit=0 → (0-5+27)%9 = 22%9 = 4 → pratyak
      expect(TaraCategory.resolve(5, 0), TaraCategory.pratyak);
    });

    test('weights are in valid range', () {
      for (final tara in TaraCategory.values) {
        expect(tara.weight, greaterThanOrEqualTo(0.2));
        expect(tara.weight, lessThanOrEqualTo(1.5));
      }
    });

    test('resolveOneBased works correctly', () {
      expect(TaraCategory.resolveOneBased(1, 1), TaraCategory.janma);
      expect(TaraCategory.resolveOneBased(1, 2), TaraCategory.sampat);
    });
  });

  group('HoraSwaraAffinity', () {
    test('solar hora + right nostril = 1.5', () {
      expect(
        HoraSwaraAffinity.getMultiplier(HoraPlanet.sun, BreathFlow.solar),
        1.5,
      );
      expect(
        HoraSwaraAffinity.getMultiplier(HoraPlanet.mars, BreathFlow.solar),
        1.5,
      );
    });

    test('lunar hora + left nostril = 1.5', () {
      expect(
        HoraSwaraAffinity.getMultiplier(HoraPlanet.moon, BreathFlow.lunar),
        1.5,
      );
      expect(
        HoraSwaraAffinity.getMultiplier(HoraPlanet.venus, BreathFlow.lunar),
        1.5,
      );
    });

    test('saturn + sushumna = 1.5', () {
      expect(
        HoraSwaraAffinity.getMultiplier(HoraPlanet.saturn, BreathFlow.sushumna),
        1.5,
      );
    });

    test('mismatched returns 0.5', () {
      expect(
        HoraSwaraAffinity.getMultiplier(HoraPlanet.sun, BreathFlow.lunar),
        0.5,
      );
    });

    test('saturn + non-sushumna = 1.0 (neutral)', () {
      expect(
        HoraSwaraAffinity.getMultiplier(HoraPlanet.saturn, BreathFlow.solar),
        1.0,
      );
    });
  });

  group('DaylightSegmentResolver', () {
    test('nighttime returns segment 0', () {
      final resolver = DaylightSegmentResolver.resolve(
        currentTime: DateTime(2026, 7, 14, 4, 0),
        sunrise: DateTime(2026, 7, 14, 6, 0),
        sunset: DateTime(2026, 7, 14, 18, 30),
      );
      expect(resolver.activeSegment, 0);
      expect(resolver.isDaytime, isFalse);
    });

    test('first segment = 1', () {
      final resolver = DaylightSegmentResolver.resolve(
        currentTime: DateTime(2026, 7, 14, 6, 30),
        sunrise: DateTime(2026, 7, 14, 6, 0),
        sunset: DateTime(2026, 7, 14, 18, 30),
      );
      expect(resolver.activeSegment, 1);
    });

    test('last segment = 8', () {
      final resolver = DaylightSegmentResolver.resolve(
        currentTime: DateTime(2026, 7, 14, 18, 0),
        sunrise: DateTime(2026, 7, 14, 6, 0),
        sunset: DateTime(2026, 7, 14, 18, 30),
      );
      expect(resolver.activeSegment, 8);
    });

    test('Rahu Kaal lookup matches RahuKaalCalculator', () {
      // Sunday: segment 8
      final resolver = DaylightSegmentResolver.resolve(
        currentTime: DateTime(2026, 7, 14, 17, 30),
        sunrise: DateTime(2026, 7, 14, 6, 0),
        sunset: DateTime(2026, 7, 14, 18, 30),
      );
      // At 17:30, segment = ceil((11.5h / 12.5h * 8)) ≈ 8
      expect(resolver.isRahuKaal(0), isTrue); // Sunday = segment 8
    });
  });

  group('OracleCompositeEngine', () {
    test('Ruling + all favorable = high score', () {
      final result = OracleCompositeEngine.evaluate(
        queryTime: DateTime(2026, 7, 14, 10, 0),
        sunrise: DateTime(2026, 7, 14, 6, 0),
        sunset: DateTime(2026, 7, 14, 18, 30),
        weekday: 1, // Monday
        currentBirdState: PakshiState.ruling,
        currentWindow: ActionWindow.artha,
        tarabalaMultiplier: 1.5,
        horaSwaraMultiplier: 1.5,
        category: QueryCategory.artha,
        actualSwara: 'right',
      );

      expect(result.score, greaterThanOrEqualTo(90));
      expect(result.band, OracleBand.siddha);
      expect(result.isFloorLocked, isFalse);
    });

    test('Dying + all unfavorable = low score', () {
      final result = OracleCompositeEngine.evaluate(
        queryTime: DateTime(2026, 7, 14, 10, 0),
        sunrise: DateTime(2026, 7, 14, 6, 0),
        sunset: DateTime(2026, 7, 14, 18, 30),
        weekday: 1,
        currentBirdState: PakshiState.dying,
        currentWindow: ActionWindow.yoga,
        tarabalaMultiplier: 0.2,
        horaSwaraMultiplier: 0.5,
        category: QueryCategory.artha,
        actualSwara: 'left',
      );

      expect(result.score, lessThanOrEqualTo(29));
      expect(result.band, OracleBand.sunya);
    });

    test('Rahu Kaal floor locks to 10', () {
      // Monday Rahu = segment 2 (06:00 + 1.5625h = ~07:34 to ~09:09)
      final result = OracleCompositeEngine.evaluate(
        queryTime: DateTime(2026, 7, 14, 8, 0), // segment 2 for Monday
        sunrise: DateTime(2026, 7, 14, 6, 0),
        sunset: DateTime(2026, 7, 14, 18, 30),
        weekday: 1, // Monday
        currentBirdState: PakshiState.ruling,
        currentWindow: ActionWindow.artha,
        tarabalaMultiplier: 1.5,
        horaSwaraMultiplier: 1.5,
        category: QueryCategory.artha,
        actualSwara: 'right',
      );

      expect(result.score, 10);
      expect(result.isFloorLocked, isTrue);
    });

    test('Category Harmony: matching = 1.2, conflicting = 0.5', () {
      expect(
        OracleCompositeEngine.getCategoryHarmony(
          QueryCategory.artha,
          ActionWindow.artha,
        ),
        1.2,
      );
      expect(
        OracleCompositeEngine.getCategoryHarmony(
          QueryCategory.artha,
          ActionWindow.yoga,
        ),
        0.5,
      );
    });

    test('OracleBand.fromScore maps correctly', () {
      expect(OracleBand.fromScore(95), OracleBand.siddha);
      expect(OracleBand.fromScore(75), OracleBand.vardhana);
      expect(OracleBand.fromScore(55), OracleBand.mandha);
      expect(OracleBand.fromScore(35), OracleBand.stambhana);
      expect(OracleBand.fromScore(15), OracleBand.sunya);
      expect(OracleBand.fromScore(0), OracleBand.sunya);
    });
  });
}
