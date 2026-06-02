import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';

void main() {
  group('TrendCalculator', () {
    final today = DateTime(2025, 3, 20);

    DailyAlignmentSummary _day(int daysAgo, {bool aligned = true}) {
      return DailyAlignmentSummary(
        date: today.subtract(Duration(days: daysAgo)),
        hasAlignedEntry: aligned,
        totalEntries: 1,
        alignedEntries: aligned ? 1 : 0,
      );
    }

    group('C-06: 30-day trend with 20 aligned out of 30', () {
      test('trend equals 66%', () {
        final summaries = [
          ...List.generate(20, (i) => _day(i)),
          ...List.generate(10, (i) => _day(20 + i, aligned: false)),
        ];

        final result = TrendCalculator.calculate(summaries: summaries);

        expect(result.alignmentPercentage, equals(66));
        expect(result.totalDaysWithEntries, equals(30));
        expect(result.totalAlignedDays, equals(20));
      });
    });

    group('C-07: 30-day trend with zero entries', () {
      test('trend equals 0%', () {
        final result = TrendCalculator.calculate(summaries: []);

        expect(result.alignmentPercentage, equals(0));
        expect(result.totalDaysWithEntries, equals(0));
      });
    });

    group('All aligned', () {
      test('100% when all days aligned', () {
        final summaries = List.generate(15, (i) => _day(i));

        final result = TrendCalculator.calculate(summaries: summaries);

        expect(result.alignmentPercentage, equals(100));
      });
    });

    group('None aligned', () {
      test('0% when all days unaligned', () {
        final summaries = List.generate(10, (i) => _day(i, aligned: false));

        final result = TrendCalculator.calculate(summaries: summaries);

        expect(result.alignmentPercentage, equals(0));
      });
    });
  });

  group('TrendCalculator.calculateYamaAccuracy', () {
    group('C-10: 3/5 Yamas logged', () {
      test('60% coverage', () {
        final yamaValues = ['yama1', 'yama1', 'yama3', 'yama5'];

        final result = TrendCalculator.calculateYamaAccuracy(yamaValues);

        expect(result.yamaCoverage, equals(60));
        expect(result.totalEntries, equals(4));
        expect(result.yamaEntries['yama1'], equals(2));
        expect(result.yamaEntries['yama2'], equals(0));
        expect(result.yamaEntries['yama3'], equals(1));
      });
    });

    test('no entries gives 0 coverage', () {
      final result = TrendCalculator.calculateYamaAccuracy([]);

      expect(result.yamaCoverage, equals(0));
      expect(result.totalEntries, equals(0));
    });

    test('all 5 yamas covered gives 100%', () {
      final yamaValues = ['yama1', 'yama2', 'yama3', 'yama4', 'yama5'];

      final result = TrendCalculator.calculateYamaAccuracy(yamaValues);

      expect(result.yamaCoverage, equals(100));
    });

    test('null values are ignored', () {
      final yamaValues = [null, 'yama1', null, 'yama2'];

      final result = TrendCalculator.calculateYamaAccuracy(yamaValues);

      expect(result.totalEntries, equals(2));
    });

    test('mostCapturedYama returns correct value', () {
      final yamaValues = ['yama1', 'yama1', 'yama1', 'yama3', 'yama5'];

      final result = TrendCalculator.calculateYamaAccuracy(yamaValues);

      expect(result.mostCapturedYama, equals('yama1'));
    });
  });
}
