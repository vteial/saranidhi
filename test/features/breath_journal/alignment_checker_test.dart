import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/breath_journal/domain/alignment_checker.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';

void main() {
  group('AlignmentChecker', () {
    // Chennai: 13.08, 80.27, IST UTC+5.5
    const lat = 13.08;
    const lng = 80.27;
    const utc = 5.5;

    group('B-01: Solar flow when Solar expected', () {
      test('is aligned during Yama 1 (odd = solar expected)', () {
        // Yama 1 starts at sunrise (~6:10 in Chennai equinox)
        // Use a time well within Yama 1
        final time = DateTime(2025, 3, 20, 7, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.expectedFlow, equals(BreathFlow.solar));
        expect(result.isAligned, isTrue);
      });
    });

    group('B-02: Lunar flow when Solar expected', () {
      test('is not aligned during Yama 1', () {
        final time = DateTime(2025, 3, 20, 7, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.lunar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.expectedFlow, equals(BreathFlow.solar));
        expect(result.isAligned, isFalse);
      });
    });

    group('B-03: Sushumna context-dependent alignment', () {
      test('sushumna alignment depends on action window (bird state)', () {
        // Yama 1 at 7:00 — bird state varies by weekday/lunar phase.
        // With the default (waxing, weekday from date), the bird state
        // determines the action window. Sushumna is aligned ONLY in
        // Yoga window (Sleeping/Dying states).
        final time = DateTime(2025, 3, 20, 7, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.sushumna,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        // The result depends on the bird state at this time.
        // We verify the actionWindow field is populated.
        expect(result!.actionWindow, isNotNull);
        // Sushumna is aligned only if actionWindow is yoga
        expect(
          result.isAligned,
          equals(result.actionWindow == ActionWindow.yoga),
        );
      });

      test('sushumna blocked in non-yoga window', () {
        // Yama 2 at 9:30 — even yama, lunar expected
        final time = DateTime(2025, 3, 20, 9, 30);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.sushumna,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.actionWindow, isNotNull);
        // Alignment matches the window type
        expect(
          result.isAligned,
          equals(result.actionWindow == ActionWindow.yoga),
        );
      });
    });

    group('Expected flow by Yama', () {
      test('Yama 2 expects lunar flow', () {
        final time = DateTime(2025, 3, 20, 9, 30);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.lunar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.expectedFlow, equals(BreathFlow.lunar));
        expect(result.isAligned, isTrue);
      });

      test('before sunrise defaults to lunar', () {
        final time = DateTime(2025, 3, 20, 4, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.lunar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.expectedFlow, equals(BreathFlow.lunar));
        expect(result.activeYama, isNull);
      });
    });

    group('Pakshi info', () {
      test('returns active bird and state during daylight', () {
        final time = DateTime(2025, 3, 20, 12, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.activeBird, isNotNull);
        expect(result.activeBirdState, isNotNull);
        expect(result.activeYama, isNotNull);
      });

      test('no bird info before sunrise', () {
        final time = DateTime(2025, 3, 20, 4, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: lat,
          longitude: lng,
          utcOffset: utc,
        );

        expect(result, isNotNull);
        expect(result!.activeBird, isNull);
        expect(result.activeBirdState, isNull);
      });
    });

    group('Polar regions', () {
      test('returns null for extreme latitude in winter', () {
        final time = DateTime(2025, 12, 21, 12, 0);

        final result = AlignmentChecker.check(
          actualFlow: BreathFlow.solar,
          time: time,
          latitude: 89,
          longitude: 0,
          utcOffset: 0,
        );

        expect(result, isNull);
      });
    });
  });

  group('BreathFlow', () {
    test('displayName returns correct strings', () {
      expect(BreathFlow.solar.displayName, equals('Solar (Right)'));
      expect(BreathFlow.lunar.displayName, equals('Lunar (Left)'));
      expect(BreathFlow.sushumna.displayName, equals('Sushumna (Both)'));
    });

    test('nostril returns correct DB values', () {
      expect(BreathFlow.solar.nostril, equals('right'));
      expect(BreathFlow.lunar.nostril, equals('left'));
      expect(BreathFlow.sushumna.nostril, equals('both'));
    });
  });
}
