import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';

void main() {
  group('StreakCalculator', () {
    final today = DateTime(2025, 3, 20);

    DailyAlignmentSummary _day(int daysAgo, {bool aligned = true}) {
      return DailyAlignmentSummary(
        date: today.subtract(Duration(days: daysAgo)),
        hasAlignedEntry: aligned,
        totalEntries: 1,
        alignedEntries: aligned ? 1 : 0,
      );
    }

    group('C-01: 5 consecutive aligned days', () {
      test('streak equals 5', () {
        final summaries = [
          _day(0), // today
          _day(1),
          _day(2),
          _day(3),
          _day(4),
        ];

        final result = StreakCalculator.calculate(
          summaries: summaries,
          today: today,
        );

        expect(result.currentStreak, equals(5));
        expect(result.isActiveToday, isTrue);
      });
    });

    group('C-02: 3 aligned, 1 missed, 2 aligned', () {
      test('streak equals 3 (most recent consecutive)', () {
        final summaries = [
          _day(0), // today
          _day(1),
          _day(2),
          // day 3 missed (no entry)
          _day(4),
          _day(5),
        ];

        final result = StreakCalculator.calculate(
          summaries: summaries,
          today: today,
        );

        expect(result.currentStreak, equals(3));
      });
    });

    group('C-03: No entries ever', () {
      test('streak equals 0', () {
        final result = StreakCalculator.calculate(summaries: [], today: today);

        expect(result.currentStreak, equals(0));
        expect(result.longestStreak, equals(0));
        expect(result.isActiveToday, isFalse);
      });
    });

    group('C-04: Entry today not yet logged', () {
      test('streak based on yesterday backwards', () {
        final summaries = [
          // No today entry
          _day(1), // yesterday
          _day(2),
          _day(3),
        ];

        final result = StreakCalculator.calculate(
          summaries: summaries,
          today: today,
        );

        expect(result.currentStreak, equals(3));
        expect(result.isActiveToday, isFalse);
      });
    });

    group('Streak broken by unaligned day', () {
      test('day with entries but no alignment breaks streak', () {
        final summaries = [
          _day(0), // today aligned
          _day(1, aligned: false), // yesterday not aligned
          _day(2), // aligned
        ];

        final result = StreakCalculator.calculate(
          summaries: summaries,
          today: today,
        );

        expect(result.currentStreak, equals(1)); // Only today
      });
    });

    group('C-08: Multiple entries same day', () {
      test('any aligned counts for streak', () {
        final summaries = [
          DailyAlignmentSummary(
            date: today,
            hasAlignedEntry: true, // at least one aligned
            totalEntries: 3,
            alignedEntries: 1,
          ),
          _day(1),
        ];

        final result = StreakCalculator.calculate(
          summaries: summaries,
          today: today,
        );

        expect(result.currentStreak, equals(2));
        expect(result.isActiveToday, isTrue);
      });
    });

    group('Longest streak', () {
      test('longest is greater than current', () {
        final summaries = [
          _day(0), // today — current streak = 1
          // gap at day 1
          _day(5),
          _day(6),
          _day(7),
          _day(8),
          _day(9), // 5-day streak in the past
        ];

        final result = StreakCalculator.calculate(
          summaries: summaries,
          today: today,
        );

        expect(result.currentStreak, equals(1));
        expect(result.longestStreak, equals(5));
      });

      test('current is longest when no past streaks are longer', () {
        final summaries = List.generate(10, (i) => _day(i));

        final result = StreakCalculator.calculate(
          summaries: summaries,
          today: today,
        );

        expect(result.currentStreak, equals(10));
        expect(result.longestStreak, equals(10));
      });
    });
  });
}
