import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final now = DateTime.now();
  final baseData = DashboardData(
    streak: const StreakResult(currentStreak: 0, longestStreak: 0, isActiveToday: false),
    trend: const TrendResult(alignmentPercentage: 0, totalDaysWithEntries: 0, totalAlignedDays: 0, periodDays: 30),
    ribbon: [],
    yamaAccuracy: const YamaAccuracyResult(yamaEntries: {}, totalEntries: 0),
  );

  group('NostrilDominanceChart', () {
    testWidgets('renders 5 rows with Solar/Lunar labels', (tester) async {
      final yamaResult = YamaCalculator.calculate(
        sunrise: now.subtract(const Duration(hours: 6)),
        sunset: now.add(const Duration(hours: 6)),
      );

      final data = baseData.copyWith(
        yamaResult: yamaResult,
        activeYama: yamaResult.yamas[0],
      );

      await tester.pumpApp(NostrilDominanceChart(data: data));

      expect(find.text('Solar'), findsNWidgets(3)); // Y1, Y3, Y5
      expect(find.text('Lunar'), findsNWidgets(2)); // Y2, Y4
      expect(find.textContaining('NOW'), findsOneWidget);
    });

    testWidgets('shows next switch countdown when not night', (tester) async {
      final yamaResult = YamaCalculator.calculate(
        sunrise: now.subtract(const Duration(hours: 6)),
        sunset: now.add(const Duration(hours: 6)),
      );

      final data = baseData.copyWith(
        yamaResult: yamaResult,
        activeYama: YamaSegment(
          index: YamaIndex.yama1,
          start: now.subtract(const Duration(minutes: 10)),
          end: now.add(const Duration(minutes: 50)),
        ),
      );

      await tester.pumpApp(NostrilDominanceChart(data: data));

      expect(find.textContaining('50min'), findsOneWidget);
    });
  });
}

extension on DashboardData {
  DashboardData copyWith({
    YamaResult? yamaResult,
    YamaSegment? activeYama,
  }) {
    return DashboardData(
      streak: streak,
      trend: trend,
      ribbon: ribbon,
      yamaAccuracy: yamaAccuracy,
      yamaResult: yamaResult ?? this.yamaResult,
      activeYama: activeYama ?? this.activeYama,
    );
  }
}
