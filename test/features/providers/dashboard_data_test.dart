import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

void main() {
  group('DashboardData', () {
    test('constructs with all required fields', () {
      final data = DashboardData(
        streak: const StreakResult(
          currentStreak: 5,
          longestStreak: 10,
          isActiveToday: true,
        ),
        trend: const TrendResult(
          alignmentPercentage: 80,
          totalDaysWithEntries: 20,
          totalAlignedDays: 16,
          periodDays: 30,
        ),
        ribbon: SevenDayRibbon.generate(
          summaries: [],
          today: DateTime(2025, 3, 20),
        ),
        yamaAccuracy: const YamaAccuracyResult(
          yamaEntries: {
            'yama1': 5,
            'yama2': 3,
            'yama3': 2,
            'yama4': 0,
            'yama5': 0,
          },
          totalEntries: 10,
        ),
      );

      expect(data.streak.currentStreak, equals(5));
      expect(data.trend.alignmentPercentage, equals(80));
      expect(data.ribbon.length, equals(7));
      expect(data.yamaAccuracy.yamaCoverage, equals(60));
    });
  });

  group('StreakResult', () {
    test('properties are accessible', () {
      const result = StreakResult(
        currentStreak: 7,
        longestStreak: 12,
        isActiveToday: false,
      );

      expect(result.currentStreak, equals(7));
      expect(result.longestStreak, equals(12));
      expect(result.isActiveToday, isFalse);
    });
  });

  group('TrendResult', () {
    test('properties are accessible', () {
      const result = TrendResult(
        alignmentPercentage: 55,
        totalDaysWithEntries: 15,
        totalAlignedDays: 8,
        periodDays: 30,
      );

      expect(result.alignmentPercentage, equals(55));
      expect(result.totalDaysWithEntries, equals(15));
      expect(result.totalAlignedDays, equals(8));
      expect(result.periodDays, equals(30));
    });
  });

  group('YamaAccuracyResult', () {
    test('yamaCoverage calculates correctly', () {
      const result = YamaAccuracyResult(
        yamaEntries: {
          'yama1': 3,
          'yama2': 0,
          'yama3': 2,
          'yama4': 0,
          'yama5': 1,
        },
        totalEntries: 6,
      );

      // 3 out of 5 yamas captured = 60%
      expect(result.yamaCoverage, equals(60));
    });

    test('mostCapturedYama returns highest', () {
      const result = YamaAccuracyResult(
        yamaEntries: {
          'yama1': 10,
          'yama2': 5,
          'yama3': 8,
          'yama4': 2,
          'yama5': 1,
        },
        totalEntries: 26,
      );

      expect(result.mostCapturedYama, equals('yama1'));
    });

    test('empty entries returns 0 coverage', () {
      const result = YamaAccuracyResult(
        yamaEntries: {
          'yama1': 0,
          'yama2': 0,
          'yama3': 0,
          'yama4': 0,
          'yama5': 0,
        },
        totalEntries: 0,
      );

      expect(result.yamaCoverage, equals(0));
      expect(result.mostCapturedYama, isNull);
    });
  });
}
