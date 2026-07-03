import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final baseData = DashboardData(
    streak: const StreakResult(currentStreak: 0, longestStreak: 0, isActiveToday: false),
    trend: const TrendResult(alignmentPercentage: 0, totalDaysWithEntries: 0, totalAlignedDays: 0, periodDays: 30),
    ribbon: [],
    yamaAccuracy: const YamaAccuracyResult(yamaEntries: {}, totalEntries: 0),
  );

  group('BirthBirdCard', () {
    testWidgets('returns SizedBox.shrink when birthBird is null', (tester) async {
      await tester.pumpApp(BirthBirdCard(data: baseData));
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders bird name and state when birthBird is provided', (tester) async {
      final data = baseData.copyWith(
        birthBird: PakshiBird.vulture,
        birthBirdState: PakshiState.ruling,
        activeYama: YamaSegment(
          index: YamaIndex.yama1,
          start: DateTime.now().subtract(const Duration(minutes: 10)),
          end: DateTime.now().add(const Duration(minutes: 10)),
        ),
      );

      await tester.pumpApp(BirthBirdCard(data: data));

      expect(find.textContaining('Vulture'), findsOneWidget);
      expect(find.textContaining('Ruling'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows guidance text matching state', (tester) async {
      final data = baseData.copyWith(
        birthBird: PakshiBird.owl,
        birthBirdState: PakshiState.sleeping,
      );

      await tester.pumpApp(BirthBirdCard(data: data));
      // "Rest and avoid major decisions" is the typical guidance for sleeping
      expect(find.textContaining('Rest'), findsOneWidget);
    });

    testWidgets('color is primary for ruling/eating', (tester) async {
      final data = baseData.copyWith(
        birthBird: PakshiBird.crow,
        birthBirdState: PakshiState.eating,
      );

      await tester.pumpApp(BirthBirdCard(data: data));
      final text = tester.widget<Text>(find.textContaining('Eating'));
      final theme = Theme.of(tester.element(find.byType(BirthBirdCard)));
      expect(text.style?.color, equals(theme.colorScheme.primary));
    });
  });
}

extension on DashboardData {
  DashboardData copyWith({
    PakshiBird? birthBird,
    PakshiState? birthBirdState,
    YamaSegment? activeYama,
  }) {
    return DashboardData(
      streak: streak,
      trend: trend,
      ribbon: ribbon,
      yamaAccuracy: yamaAccuracy,
      birthBird: birthBird ?? this.birthBird,
      birthBirdState: birthBirdState ?? this.birthBirdState,
      activeYama: activeYama ?? this.activeYama,
    );
  }
}
