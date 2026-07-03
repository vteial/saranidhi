import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('FullDaySchedule', () {
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
      PakshiBird? birthBird = PakshiBird.vulture,
      PakshiDayResult? pakshiDay,
      YamaResult? yamaResult,
      YamaSegment? activeYama,
      NightYamaResult? nightYamaResult,
      NightYamaSegment? activeNightYama,
      PakshiDayResult? pakshiNight,
      bool isNight = false,
    }) {
      return DashboardData(
        streak: mockStreak,
        trend: mockTrend,
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy,
        birthBird: birthBird,
        pakshiDay: pakshiDay ??
            PakshiDayResult(
              entries: [],
              stateTable: List.generate(
                5,
                (_) => List.generate(5, (_) => PakshiState.walking),
              ),
            ),
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
        nightYamaResult: nightYamaResult,
        activeNightYama: activeNightYama,
        pakshiNight: pakshiNight,
        isNight: isNight,
      );
    }

    testWidgets('returns SizedBox.shrink when required data is missing', (tester) async {
      final data = DashboardData(
        streak: mockStreak,
        trend: mockTrend,
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy,
        birthBird: null,
      );
      await tester.pumpApp(FullDaySchedule(data: data));
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders 5 daytime yama rows', (tester) async {
      final data = createData();
      await tester.pumpApp(FullDaySchedule(data: data));

      expect(find.text('Y1'), findsOneWidget);
      expect(find.text('Y2'), findsOneWidget);
      expect(find.text('Y3'), findsOneWidget);
      expect(find.text('Y4'), findsOneWidget);
      expect(find.text('Y5'), findsOneWidget);
    });

    testWidgets('renders night section when night data provided', (tester) async {
      final nightYamas = NightYamaResult(
        yamas: List.generate(
          5,
          (i) => NightYamaSegment(
            index: NightYamaIndex.values[i],
            start: DateTime(2025, 3, 20, 18 + i),
            end: DateTime(2025, 3, 20, 19 + i),
          ),
        ),
        yamaDuration: const Duration(hours: 1),
      );
      final data = createData(
        nightYamaResult: nightYamas,
        pakshiNight: PakshiDayResult(
          entries: [],
          stateTable: List.generate(
            5,
            (_) => List.generate(5, (_) => PakshiState.walking),
          ),
        ),
      );

      await tester.pumpApp(FullDaySchedule(data: data));

      expect(find.text('Y6'), findsOneWidget);
      expect(find.text('Y7'), findsOneWidget);
      expect(find.text('Y8'), findsOneWidget);
      expect(find.text('Y9'), findsOneWidget);
      expect(find.text('Y10'), findsOneWidget);
      expect(find.text('\uD83C\uDF19'), findsOneWidget);
    });

    testWidgets('highlights active yama with NOW', (tester) async {
      final data = createData(
        activeYama: YamaSegment(
          index: YamaIndex.yama2,
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 1)),
        ),
      );

      await tester.pumpApp(FullDaySchedule(data: data));

      expect(find.textContaining('\u2190'), findsWidgets);
    });

    testWidgets('shows best time for ruling state', (tester) async {
      final pakshiDay = PakshiDayResult(
        entries: [],
        stateTable: [
          [PakshiState.ruling, PakshiState.walking, PakshiState.walking, PakshiState.walking, PakshiState.walking],
          ...List.generate(4, (_) => List.generate(5, (_) => PakshiState.walking)),
        ],
      );
      final data = createData(pakshiDay: pakshiDay);

      await tester.pumpApp(FullDaySchedule(data: data));

      expect(find.textContaining('Best time!'), findsOneWidget);
    });

    testWidgets('renders Align27 comparison row', (tester) async {
      final data = createData(
        activeYama: YamaSegment(
          index: YamaIndex.yama1,
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 1)),
        ),
      );

      await tester.pumpApp(FullDaySchedule(data: data));

      expect(find.textContaining('Align27'), findsOneWidget);
    });
  });
}
