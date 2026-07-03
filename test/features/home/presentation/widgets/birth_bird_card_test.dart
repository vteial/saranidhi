import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('BirthBirdCard', () {
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
      PakshiBird? birthBird,
      PakshiState? birthBirdState,
      bool isNight = false,
      YamaSegment? activeYama,
      NightYamaSegment? activeNightYama,
      PakshiState? birthBirdNightState,
    }) {
      return DashboardData(
        streak: mockStreak,
        trend: mockTrend,
        ribbon: [],
        yamaAccuracy: mockYamaAccuracy,
        birthBird: birthBird,
        birthBirdState: birthBirdState,
        isNight: isNight,
        activeYama: activeYama,
        activeNightYama: activeNightYama,
        birthBirdNightState: birthBirdNightState,
      );
    }

    testWidgets('returns SizedBox.shrink when birthBird is null', (tester) async {
      final data = createData(birthBird: null);
      await tester.pumpApp(BirthBirdCard(data: data));

      expect(find.byType(Card), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders bird emoji, name, and state', (tester) async {
      final data = createData(
        birthBird: PakshiBird.peacock,
        birthBirdState: PakshiState.ruling,
      );
      await tester.pumpApp(BirthBirdCard(data: data));

      expect(find.textContaining('\u{1F99A}'), findsOneWidget);
      expect(find.textContaining('Peacock'), findsOneWidget);
      expect(find.textContaining('Ruling'), findsOneWidget);
    });

    testWidgets('uses correct colors for states', (tester) async {
      final data = createData(
        birthBird: PakshiBird.owl,
        birthBirdState: PakshiState.walking,
      );
      await tester.pumpApp(BirthBirdCard(data: data));
      final text = tester.widget<Text>(find.textContaining('Owl'));
      expect(text.style?.color, equals(Colors.orange));
    });

    testWidgets('shows progress bar and text when active yama is present', (tester) async {
      final now = DateTime.now();
      final activeYama = YamaSegment(
        index: YamaIndex.yama1,
        start: now.subtract(const Duration(minutes: 30)),
        end: now.add(const Duration(minutes: 30)),
      );

      final data = createData(
        birthBird: PakshiBird.crow,
        birthBirdState: PakshiState.walking,
        activeYama: activeYama,
      );

      await tester.pumpApp(BirthBirdCard(data: data));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.textContaining('Y1'), findsOneWidget);
      expect(find.textContaining('30min'), findsOneWidget);
    });

    testWidgets('shows night guidance and yama during nighttime', (tester) async {
      final now = DateTime.now();
      final activeNightYama = NightYamaSegment(
        index: NightYamaIndex.yama6,
        start: now.subtract(const Duration(minutes: 45)),
        end: now.add(const Duration(minutes: 15)),
      );

      final data = createData(
        birthBird: PakshiBird.rooster,
        birthBirdNightState: PakshiState.sleeping,
        isNight: true,
        activeNightYama: activeNightYama,
      );

      await tester.pumpApp(BirthBirdCard(data: data));

      expect(find.textContaining('Rooster'), findsOneWidget);
      expect(find.textContaining('Sleeping'), findsOneWidget);
      expect(find.textContaining('Y6'), findsOneWidget);
      expect(find.textContaining('15min'), findsOneWidget);
    });
  });
}
