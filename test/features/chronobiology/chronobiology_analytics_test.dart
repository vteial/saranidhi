import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/chronobiology/domain/chronobiology_analytics.dart';

void main() {
  SaraKalaiJournalData makeLog({required int timestamp, required String flow}) {
    return SaraKalaiJournalData(
      id: 'log-$timestamp',
      timestamp: timestamp,
      expectedFlow: flow,
      actualFlow: flow,
      isAligned: true,
      nostril: flow == 'solar' ? 'right' : 'left',
      isPinned: false,
      wasForcedShift: false,
    );
  }

  group('ChronobiologyAnalytics', () {
    final baseTime = DateTime(2026, 9, 12, 12, 0);

    test('returns none when logs count is less than 3', () {
      final logs = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 7))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
      ];

      final result = ChronobiologyAnalytics.analyze(logs);
      expect(result.level, equals(StagnancyLevel.none));
      expect(result.stuckFlow, isNull);
      expect(result.continuousDuration, equals(Duration.zero));
    });

    test('returns mild when duration >= 6h and count >= 3', () {
      final logs = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 3))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 6))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
      ];

      final result = ChronobiologyAnalytics.analyze(logs);
      expect(result.level, equals(StagnancyLevel.mild));
      expect(result.stuckFlow, equals(BreathFlow.solar));
      expect(result.continuousDuration, equals(const Duration(hours: 6)));
    });

    test('returns chronic when duration >= 8h and count >= 4', () {
      final logs = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'lunar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          flow: 'lunar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 5))
              .millisecondsSinceEpoch,
          flow: 'lunar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 8))
              .millisecondsSinceEpoch,
          flow: 'lunar',
        ),
      ];

      final result = ChronobiologyAnalytics.analyze(logs);
      expect(result.level, equals(StagnancyLevel.chronic));
      expect(result.stuckFlow, equals(BreathFlow.lunar));
      expect(result.continuousDuration, equals(const Duration(hours: 8)));
    });

    test('returns mild instead of chronic if duration >= 8h but count < 4', () {
      final logs = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 4))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 8, minutes: 30))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
      ];

      final result = ChronobiologyAnalytics.analyze(logs);
      expect(result.level, equals(StagnancyLevel.mild));
      expect(result.stuckFlow, equals(BreathFlow.solar));
      expect(
        result.continuousDuration,
        equals(const Duration(hours: 8, minutes: 30)),
      );
    });

    test('sushumna entry breaks a run and resets stagnancy', () {
      final logs = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 3))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 6))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        // Sushumna breaks the run at 7h
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 7))
              .millisecondsSinceEpoch,
          flow: 'sushumna',
        ),
      ];

      final result = ChronobiologyAnalytics.analyze(logs);
      expect(result.level, equals(StagnancyLevel.none));
      expect(result.stuckFlow, isNull);
      expect(result.continuousDuration, equals(Duration.zero));
    });

    test('recent flip resets the run to none', () {
      final logs = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 5))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 8))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        // User flipped to lunar recently
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 8, minutes: 15))
              .millisecondsSinceEpoch,
          flow: 'lunar',
        ),
      ];

      final result = ChronobiologyAnalytics.analyze(logs);
      expect(result.level, equals(StagnancyLevel.none));
      expect(result.stuckFlow, isNull);
      expect(result.continuousDuration, equals(Duration.zero));
    });

    test('boundary cases: exactly 5h 59m is none, exactly 6h is mild', () {
      final logsSub6 = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 5, minutes: 59))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
      ];

      expect(
        ChronobiologyAnalytics.analyze(logsSub6).level,
        equals(StagnancyLevel.none),
      );

      final logsExact6 = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 6))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
      ];

      expect(
        ChronobiologyAnalytics.analyze(logsExact6).level,
        equals(StagnancyLevel.mild),
      );
    });

    test(
      'boundary cases: exactly 7h 59m is mild, exactly 8h with 4 logs is chronic',
      () {
        final logsSub8 = [
          makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'lunar'),
          makeLog(
            timestamp: baseTime
                .add(const Duration(hours: 2))
                .millisecondsSinceEpoch,
            flow: 'lunar',
          ),
          makeLog(
            timestamp: baseTime
                .add(const Duration(hours: 4))
                .millisecondsSinceEpoch,
            flow: 'lunar',
          ),
          makeLog(
            timestamp: baseTime
                .add(const Duration(hours: 7, minutes: 59))
                .millisecondsSinceEpoch,
            flow: 'lunar',
          ),
        ];

        expect(
          ChronobiologyAnalytics.analyze(logsSub8).level,
          equals(StagnancyLevel.mild),
        );

        final logsExact8 = [
          makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'lunar'),
          makeLog(
            timestamp: baseTime
                .add(const Duration(hours: 2))
                .millisecondsSinceEpoch,
            flow: 'lunar',
          ),
          makeLog(
            timestamp: baseTime
                .add(const Duration(hours: 4))
                .millisecondsSinceEpoch,
            flow: 'lunar',
          ),
          makeLog(
            timestamp: baseTime
                .add(const Duration(hours: 8))
                .millisecondsSinceEpoch,
            flow: 'lunar',
          ),
        ];

        expect(
          ChronobiologyAnalytics.analyze(logsExact8).level,
          equals(StagnancyLevel.chronic),
        );
      },
    );

    test('normalizes input ordering (newest-first or oldest-first)', () {
      final oldestFirst = [
        makeLog(timestamp: baseTime.millisecondsSinceEpoch, flow: 'solar'),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 3))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
        makeLog(
          timestamp: baseTime
              .add(const Duration(hours: 6))
              .millisecondsSinceEpoch,
          flow: 'solar',
        ),
      ];

      final newestFirst = oldestFirst.reversed.toList();

      final resultOldest = ChronobiologyAnalytics.analyze(oldestFirst);
      final resultNewest = ChronobiologyAnalytics.analyze(newestFirst);

      expect(resultOldest.level, equals(StagnancyLevel.mild));
      expect(resultNewest.level, equals(StagnancyLevel.mild));
      expect(
        resultOldest.continuousDuration,
        equals(resultNewest.continuousDuration),
      );
    });
  });
}
