import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';

void main() {
  group('SevenDayRibbon', () {
    // Thursday, March 20, 2025
    final today = DateTime(2025, 3, 20);

    DailyAlignmentSummary _day(int daysAgo, {bool aligned = true}) {
      return DailyAlignmentSummary(
        date: today.subtract(Duration(days: daysAgo)),
        hasAlignedEntry: aligned,
        totalEntries: 1,
        alignedEntries: aligned ? 1 : 0,
      );
    }

    test('generates exactly 7 days', () {
      final ribbon = SevenDayRibbon.generate(summaries: [], today: today);

      expect(ribbon.length, equals(7));
    });

    test('last day is today', () {
      final ribbon = SevenDayRibbon.generate(summaries: [], today: today);

      final lastDay = ribbon.last;
      expect(lastDay.date, equals(today));
    });

    test('first day is 6 days ago', () {
      final ribbon = SevenDayRibbon.generate(summaries: [], today: today);

      final firstDay = ribbon.first;
      expect(firstDay.date, equals(today.subtract(const Duration(days: 6))));
    });

    group('C-05: mixed results', () {
      test('correct checkmark/X pattern', () {
        final summaries = [
          _day(0), // today aligned
          _day(1, aligned: false), // yesterday unaligned
          _day(2), // 2 days ago aligned
          // day 3, 4 — no entry
          _day(5), // 5 days ago aligned
          _day(6), // 6 days ago aligned
        ];

        final ribbon = SevenDayRibbon.generate(
          summaries: summaries,
          today: today,
        );

        expect(ribbon[0].status, equals(DayStatus.aligned)); // 6 days ago
        expect(ribbon[1].status, equals(DayStatus.aligned)); // 5 days ago
        expect(ribbon[2].status, equals(DayStatus.noEntry)); // 4 days ago
        expect(ribbon[3].status, equals(DayStatus.noEntry)); // 3 days ago
        expect(ribbon[4].status, equals(DayStatus.aligned)); // 2 days ago
        expect(ribbon[5].status, equals(DayStatus.unaligned)); // yesterday
        expect(ribbon[6].status, equals(DayStatus.aligned)); // today
      });
    });

    test('empty summaries gives all noEntry', () {
      final ribbon = SevenDayRibbon.generate(summaries: [], today: today);

      for (final day in ribbon) {
        expect(day.status, equals(DayStatus.noEntry));
      }
    });

    test('day labels are single characters', () {
      final ribbon = SevenDayRibbon.generate(summaries: [], today: today);

      for (final day in ribbon) {
        expect(day.dayLabel.length, equals(1));
      }
    });
  });
}
