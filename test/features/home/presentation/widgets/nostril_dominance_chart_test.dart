import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('NostrilDominanceChart', () {
    final mockStreak = const StreakResult(
      currentStreak: 0,
      longestStreak: 0,
      isActiveToday: false,
    );
    final mockTrend = const TrendResult(
      alignmentPercentage: 0,
      totalDaysWithEntries: 0,
      totalAlignedDays: 0,
      periodDays: 30,
    );
    final mockYamaAccuracy = const YamaAccuracyResult(
      yamaEntries: {},
      totalEntries: 0,
    );

    DashboardData createData({
      YamaResult? yamaResult,
      YamaSegment? activeYama,
      bool isNight = false,
    }) {
      return DashboardData(
        streak: mockStreak,
        trend: mockTrend,
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy,
        yamaResult: yamaResult ??
            YamaResult(
              yamas: List.generate(
                5,
                (i) => YamaSegment(
                  index: YamaIndex.values[i],
                  start: DateTime(2025, 3, 20, 6 + i),
                  end: DateTime(2025, 3, 20, 7 + i),
                ),
              ),
              yamaDuration: const Duration(hours: 1),
            ),
        activeYama: activeYama,
        isNight: isNight,
      );
    }

    testWidgets('returns SizedBox.shrink when yamaResult is null', (tester) async {
      final data = DashboardData(
        streak: mockStreak,
        trend: mockTrend,
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy,
        yamaResult: null,
      );
      await tester.pumpApp(NostrilDominanceChart(data: data));
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders Solar for odd yamas and Lunar for even yamas', (tester) async {
      final data = createData();
      await tester.pumpApp(NostrilDominanceChart(data: data));

      expect(find.textContaining('\u2600'), findsNWidgets(3));
      expect(find.textContaining('\uD83C\uDF19'), findsNWidgets(2));

      expect(find.text('Solar'), findsNWidgets(3));
      expect(find.text('Lunar'), findsNWidgets(2));
    });

    testWidgets('highlights active yama and shows countdown', (tester) async {
      final now = DateTime.now();
      final activeYama = YamaSegment(
        index: YamaIndex.yama1,
        start: now.subtract(const Duration(minutes: 30)),
        end: now.add(const Duration(minutes: 30)),
      );
      final data = createData(activeYama: activeYama);

      await tester.pumpApp(NostrilDominanceChart(data: data));

      expect(find.textContaining('\u2190'), findsOneWidget);
      expect(find.textContaining('30min'), findsOneWidget);
    });

    testWidgets('shows night note when isNight is true', (tester) async {
      final data = createData(isNight: true);
      await tester.pumpApp(NostrilDominanceChart(data: data));

      expect(find.textContaining('night', skipOffstage: false), findsWidgets);
    });
  });
}
