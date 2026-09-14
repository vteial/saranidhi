import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/analytics/domain/analytics_calculator.dart';

void main() {
  group('AnalyticsCalculator.generateCsv', () {
    const expectedHeader =
        'Date,Time,Expected Flow,Actual Flow,Aligned,Nostril,'
        ' Inhale (ms),Hold (ms),Exhale (ms),Yama,Bird,Bird State,Element,Notes';

    test('empty entries list generates only the header line', () {
      final csv = AnalyticsCalculator.generateCsv([]);
      expect(csv.trim(), equals(expectedHeader));
    });

    test('single complete entry formats all columns correctly', () {
      // 2026-09-13 14:30:00
      final dt = DateTime(2026, 9, 13, 14, 30);
      final entry = SaraKalaiJournalData(
        id: 'entry-1',
        timestamp: dt.millisecondsSinceEpoch,
        expectedFlow: 'solar',
        actualFlow: 'solar',
        isAligned: true,
        nostril: 'right',
        inhaleDurationMs: 4000,
        holdDurationMs: 16000,
        exhaleDurationMs: 8000,
        activeYama: 'yama1',
        activeBird: 'vulture',
        activeBirdState: 'ruling',
        activeElement: 'fire',
        notes: 'Clean session',
        isPinned: false,
        wasForcedShift: false,
      );

      final csv = AnalyticsCalculator.generateCsv([entry]);
      final lines = csv.trim().split('\n');

      expect(lines.length, equals(2));
      expect(lines[0], equals(expectedHeader));
      expect(
        lines[1],
        equals(
          '2026-09-13,14:30,solar,solar,true,right,4000,16000,8000,yama1,vulture,ruling,fire,"Clean session"',
        ),
      );
    });

    test('handles null durations, metadata and notes safely', () {
      final dt = DateTime(2026, 9, 13, 8, 5);
      final entry = SaraKalaiJournalData(
        id: 'entry-2',
        timestamp: dt.millisecondsSinceEpoch,
        expectedFlow: 'lunar',
        actualFlow: 'solar',
        isAligned: false,
        nostril: 'right',
        isPinned: false,
        wasForcedShift: false,
      );

      final csv = AnalyticsCalculator.generateCsv([entry]);
      final lines = csv.trim().split('\n');

      expect(lines.length, equals(2));
      expect(
        lines[1],
        equals('2026-09-13,08:05,lunar,solar,false,right,,,,,,,,""'),
      );
    });

    test('escapes quotes and handles commas in notes properly', () {
      final dt = DateTime(2026, 9, 13, 10, 0);
      final entry = SaraKalaiJournalData(
        id: 'entry-3',
        timestamp: dt.millisecondsSinceEpoch,
        expectedFlow: 'solar',
        actualFlow: 'solar',
        isAligned: true,
        nostril: 'right',
        notes: 'Felt "great", with smooth flow',
        isPinned: false,
        wasForcedShift: false,
      );

      final csv = AnalyticsCalculator.generateCsv([entry]);
      final lines = csv.trim().split('\n');

      expect(lines.length, equals(2));
      expect(
        lines[1],
        equals(
          '2026-09-13,10:00,solar,solar,true,right,,,,,,,,"Felt ""great"", with smooth flow"',
        ),
      );
    });
  });

  group('AnalyticsCalculator.calculateMonthlyPatterns', () {
    test('empty entries returns null weekdays and 0 totals', () {
      final patterns = AnalyticsCalculator.calculateMonthlyPatterns(
        entries: [],
      );
      expect(patterns.bestDayWeekday, isNull);
      expect(patterns.worstDayWeekday, isNull);
      expect(patterns.totalEntries, equals(0));
      expect(patterns.activeDays, equals(0));
    });

    test('correctly identifies best and worst weekdays as integers', () {
      // 2026-09-13 is Sunday (weekday 7) - 100% aligned (2/2)
      // 2026-09-15 is Tuesday (weekday 2) - 0% aligned (0/2)
      final sunday1 = DateTime(2026, 9, 13, 8, 0);
      final sunday2 = DateTime(2026, 9, 13, 14, 0);
      final tuesday1 = DateTime(2026, 9, 15, 9, 0);
      final tuesday2 = DateTime(2026, 9, 15, 17, 0);

      final entries = [
        SaraKalaiJournalData(
          id: '1',
          timestamp: sunday1.millisecondsSinceEpoch,
          expectedFlow: 'solar',
          actualFlow: 'solar',
          isAligned: true,
          nostril: 'right',
          isPinned: false,
          wasForcedShift: false,
        ),
        SaraKalaiJournalData(
          id: '2',
          timestamp: sunday2.millisecondsSinceEpoch,
          expectedFlow: 'solar',
          actualFlow: 'solar',
          isAligned: true,
          nostril: 'right',
          isPinned: false,
          wasForcedShift: false,
        ),
        SaraKalaiJournalData(
          id: '3',
          timestamp: tuesday1.millisecondsSinceEpoch,
          expectedFlow: 'solar',
          actualFlow: 'lunar',
          isAligned: false,
          nostril: 'left',
          isPinned: false,
          wasForcedShift: false,
        ),
        SaraKalaiJournalData(
          id: '4',
          timestamp: tuesday2.millisecondsSinceEpoch,
          expectedFlow: 'solar',
          actualFlow: 'lunar',
          isAligned: false,
          nostril: 'left',
          isPinned: false,
          wasForcedShift: false,
        ),
      ];

      final patterns = AnalyticsCalculator.calculateMonthlyPatterns(
        entries: entries,
      );

      expect(patterns.bestDayWeekday, equals(DateTime.sunday)); // 7
      expect(patterns.worstDayWeekday, equals(DateTime.tuesday)); // 2
      expect(patterns.totalEntries, equals(4));
      expect(patterns.totalAligned, equals(2));
      expect(patterns.alignmentPercentage, equals(50));
      expect(patterns.activeDays, equals(2));
    });
  });
}
