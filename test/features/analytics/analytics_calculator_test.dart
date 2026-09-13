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
}
