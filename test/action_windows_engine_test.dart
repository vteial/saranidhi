import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window_segment.dart';
import 'package:saranidhi/features/astro_engine/domain/action_windows_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

void main() {
  group('ActionWindowSegment', () {
    test('contains() returns true for time within segment', () {
      final segment = ActionWindowSegment(
        window: ActionWindow.artha,
        start: DateTime(2026, 7, 11, 6, 0),
        end: DateTime(2026, 7, 11, 10, 0),
        birdStateName: 'Ruling',
      );

      expect(segment.contains(DateTime(2026, 7, 11, 8, 0)), isTrue);
      expect(segment.contains(DateTime(2026, 7, 11, 6, 0)), isTrue); // inclusive
      expect(segment.contains(DateTime(2026, 7, 11, 10, 0)), isFalse); // exclusive end
      expect(segment.contains(DateTime(2026, 7, 11, 5, 59)), isFalse);
    });

    test('duration calculates correctly', () {
      final segment = ActionWindowSegment(
        window: ActionWindow.kriya,
        start: DateTime(2026, 7, 11, 10, 0),
        end: DateTime(2026, 7, 11, 12, 30),
        birdStateName: 'Eating',
      );

      expect(segment.duration, const Duration(hours: 2, minutes: 30));
    });

    test('copyWithRahuBlocked creates copy with flag', () {
      final segment = ActionWindowSegment(
        window: ActionWindow.artha,
        start: DateTime(2026, 7, 11, 6, 0),
        end: DateTime(2026, 7, 11, 10, 0),
        birdStateName: 'Ruling',
      );

      final blocked = segment.copyWithRahuBlocked(blocked: true);
      expect(blocked.isBlockedByRahu, isTrue);
      expect(blocked.window, ActionWindow.artha);
      expect(blocked.start, segment.start);
    });
  });

  group('ActionWindowsEngine.consolidate()', () {
    late YamaResult dayYamas;
    late NightYamaResult nightYamas;
    late DateTime sunrise;
    late DateTime sunset;
    late DateTime nextSunrise;

    setUp(() {
      sunrise = DateTime(2026, 7, 11, 6, 0);
      sunset = DateTime(2026, 7, 11, 18, 30);
      nextSunrise = DateTime(2026, 7, 12, 6, 0);

      dayYamas = YamaCalculator.calculate(
        sunrise: sunrise,
        sunset: sunset,
      );
      nightYamas = YamaCalculator.calculateNight(
        sunset: sunset,
        nextSunrise: nextSunrise,
      );
    });

    test('produces non-empty segments for valid input', () {
      const weekday = 6; // Saturday
      final lunarPhase = LunarPhase.waxing;
      final dayPakshi = PakshiCalculator.calculate(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );
      final nightPakshi = PakshiCalculator.calculateNight(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );

      final segments = ActionWindowsEngine.consolidate(
        dayYamas: dayYamas.yamas,
        nightYamas: nightYamas.yamas,
        dayPakshi: dayPakshi,
        nightPakshi: nightPakshi,
        userBird: PakshiBird.owl,
      );

      expect(segments, isNotEmpty);
      // Total segments <= 10 (worst case: no consolidation)
      expect(segments.length, lessThanOrEqualTo(10));
      // Total segments >= 1 (at least one consolidated block)
      expect(segments.length, greaterThanOrEqualTo(1));
    });

    test('segments cover full 24h range', () {
      const weekday = 1; // Monday
      final lunarPhase = LunarPhase.waxing;
      final dayPakshi = PakshiCalculator.calculate(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );
      final nightPakshi = PakshiCalculator.calculateNight(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );

      final segments = ActionWindowsEngine.consolidate(
        dayYamas: dayYamas.yamas,
        nightYamas: nightYamas.yamas,
        dayPakshi: dayPakshi,
        nightPakshi: nightPakshi,
        userBird: PakshiBird.vulture,
      );

      // First segment starts at sunrise
      expect(segments.first.start, sunrise);
      // Last segment ends at next sunrise
      expect(segments.last.end, nextSunrise);
    });

    test('consecutive same-window yamas are merged', () {
      const weekday = 3; // Wednesday
      final lunarPhase = LunarPhase.waxing;
      final dayPakshi = PakshiCalculator.calculate(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );
      final nightPakshi = PakshiCalculator.calculateNight(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );

      final segments = ActionWindowsEngine.consolidate(
        dayYamas: dayYamas.yamas,
        nightYamas: nightYamas.yamas,
        dayPakshi: dayPakshi,
        nightPakshi: nightPakshi,
        userBird: PakshiBird.crow,
      );

      // Segments should be fewer than 10 (raw yamas) due to consolidation
      // If all 10 yamas happened to alternate differently, max would be 10
      // In practice, some consecutive yamas will share windows
      // Verify no two adjacent segments have the same window
      for (var i = 1; i < segments.length; i++) {
        expect(
          segments[i].window != segments[i - 1].window,
          isTrue,
          reason: 'Adjacent segments ${i - 1} and $i should have different windows',
        );
      }
    });

    test('all segments have valid ActionWindow values', () {
      const weekday = 5; // Friday
      final lunarPhase = LunarPhase.waning;
      final dayPakshi = PakshiCalculator.calculate(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );
      final nightPakshi = PakshiCalculator.calculateNight(
        weekday: weekday,
        lunarPhase: lunarPhase,
      );

      final segments = ActionWindowsEngine.consolidate(
        dayYamas: dayYamas.yamas,
        nightYamas: nightYamas.yamas,
        dayPakshi: dayPakshi,
        nightPakshi: nightPakshi,
        userBird: PakshiBird.peacock,
      );

      for (final segment in segments) {
        expect(ActionWindow.values, contains(segment.window));
        expect(segment.birdStateName, isNotEmpty);
        expect(segment.duration.inMinutes, greaterThan(0));
      }
    });

    test('returns empty list for empty input', () {
      final dayPakshi = PakshiCalculator.calculate(
        weekday: 1,
        lunarPhase: LunarPhase.waxing,
      );
      final nightPakshi = PakshiCalculator.calculateNight(
        weekday: 1,
        lunarPhase: LunarPhase.waxing,
      );

      final segments = ActionWindowsEngine.consolidate(
        dayYamas: [],
        nightYamas: [],
        dayPakshi: dayPakshi,
        nightPakshi: nightPakshi,
        userBird: PakshiBird.owl,
      );

      expect(segments, isEmpty);
    });
  });

  group('ActionWindowsEngine.applyRahuGuardrail()', () {
    test('marks overlapping Artha/Kriya as blocked', () {
      final segments = [
        ActionWindowSegment(
          window: ActionWindow.artha,
          start: DateTime(2026, 7, 11, 9, 0),
          end: DateTime(2026, 7, 11, 12, 0),
          birdStateName: 'Ruling',
        ),
        ActionWindowSegment(
          window: ActionWindow.kriya,
          start: DateTime(2026, 7, 11, 12, 0),
          end: DateTime(2026, 7, 11, 14, 30),
          birdStateName: 'Eating',
        ),
        ActionWindowSegment(
          window: ActionWindow.yoga,
          start: DateTime(2026, 7, 11, 14, 30),
          end: DateTime(2026, 7, 11, 18, 0),
          birdStateName: 'Sleeping',
        ),
      ];

      // Rahu overlaps with Artha and Kriya
      final rahuKaal = RahuKaalResult(
        start: DateTime(2026, 7, 11, 10, 30),
        end: DateTime(2026, 7, 11, 12, 0),
        weekday: 6,
      );

      final result = ActionWindowsEngine.applyRahuGuardrail(
        segments: segments,
        rahuKaal: rahuKaal,
      );

      expect(result[0].isBlockedByRahu, isTrue); // Artha overlaps Rahu
      expect(result[1].isBlockedByRahu, isFalse); // Kriya starts at Rahu end (no overlap)
      expect(result[2].isBlockedByRahu, isFalse); // Yoga is never blocked
    });

    test('does not block Yoga window during Rahu', () {
      final segments = [
        ActionWindowSegment(
          window: ActionWindow.yoga,
          start: DateTime(2026, 7, 11, 10, 0),
          end: DateTime(2026, 7, 11, 12, 0),
          birdStateName: 'Sleeping',
        ),
      ];

      final rahuKaal = RahuKaalResult(
        start: DateTime(2026, 7, 11, 10, 0),
        end: DateTime(2026, 7, 11, 11, 30),
        weekday: 6,
      );

      final result = ActionWindowsEngine.applyRahuGuardrail(
        segments: segments,
        rahuKaal: rahuKaal,
      );

      expect(result[0].isBlockedByRahu, isFalse);
    });
  });

  group('ActionWindowsEngine.activeSegment()', () {
    test('returns correct segment for given time', () {
      final segments = [
        ActionWindowSegment(
          window: ActionWindow.artha,
          start: DateTime(2026, 7, 11, 6, 0),
          end: DateTime(2026, 7, 11, 10, 0),
          birdStateName: 'Ruling',
        ),
        ActionWindowSegment(
          window: ActionWindow.kriya,
          start: DateTime(2026, 7, 11, 10, 0),
          end: DateTime(2026, 7, 11, 12, 30),
          birdStateName: 'Eating',
        ),
      ];

      final active = ActionWindowsEngine.activeSegment(
        segments,
        DateTime(2026, 7, 11, 8, 0),
      );

      expect(active?.window, ActionWindow.artha);
    });

    test('returns null for time outside all segments', () {
      final segments = [
        ActionWindowSegment(
          window: ActionWindow.artha,
          start: DateTime(2026, 7, 11, 6, 0),
          end: DateTime(2026, 7, 11, 10, 0),
          birdStateName: 'Ruling',
        ),
      ];

      final active = ActionWindowsEngine.activeSegment(
        segments,
        DateTime(2026, 7, 11, 5, 0),
      );

      expect(active, isNull);
    });
  });
}
