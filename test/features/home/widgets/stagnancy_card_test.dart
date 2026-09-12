import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/chronobiology/domain/chronobiology_analytics.dart';
import 'package:saranidhi/features/home/presentation/widgets/stagnancy_card.dart';
import 'package:saranidhi/features/streaks/providers/streak_providers.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('StagnancyCard Widget', () {
    testWidgets('renders nothing when stagnancy level is none', (tester) async {
      final data = createTestDashboardData(
        stagnancy: const StagnancyAnalysisResult(
          level: StagnancyLevel.none,
          stuckFlow: null,
          continuousDuration: Duration.zero,
        ),
      );

      await tester.pumpWidget(testableWidget(StagnancyCard(data: data)));

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders mild cooling copy when stuck right (solar)', (
      tester,
    ) async {
      final data = createTestDashboardData(
        stagnancy: const StagnancyAnalysisResult(
          level: StagnancyLevel.mild,
          stuckFlow: BreathFlow.solar,
          continuousDuration: Duration(hours: 6),
        ),
      );

      await tester.pumpWidget(testableWidget(StagnancyCard(data: data)));

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Breath Stagnancy (Mild)'), findsOneWidget);
      expect(find.textContaining('Sheetali'), findsOneWidget);
      expect(find.text('Rebalance channel'), findsOneWidget);
    });

    testWidgets('renders chronic warming copy when stuck left (lunar)', (
      tester,
    ) async {
      final data = createTestDashboardData(
        stagnancy: const StagnancyAnalysisResult(
          level: StagnancyLevel.chronic,
          stuckFlow: BreathFlow.lunar,
          continuousDuration: Duration(hours: 8),
        ),
      );

      await tester.pumpWidget(testableWidget(StagnancyCard(data: data)));

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Breath Stagnancy (Chronic)'), findsOneWidget);
      expect(find.textContaining('Surya Bhedana'), findsOneWidget);
      expect(find.text('Rebalance channel'), findsOneWidget);
    });

    testWidgets('renders Tattva tip when active element has thermal tip', (
      tester,
    ) async {
      final now = DateTime.now();
      final data = createTestDashboardData(
        stagnancy: const StagnancyAnalysisResult(
          level: StagnancyLevel.mild,
          stuckFlow: BreathFlow.solar,
          continuousDuration: Duration(hours: 6),
        ),
      );

      // Create DashboardData with activeTattva = fire
      final dataWithFire = DashboardData(
        streak: data.streak,
        trend: data.trend,
        ribbon: data.ribbon,
        yamaAccuracy: data.yamaAccuracy,
        stagnancy: data.stagnancy,
        activeTattva: TattvaResult(
          tattva: Tattva.fire,
          index: 2,
          start: now.subtract(const Duration(minutes: 10)),
          end: now.add(const Duration(minutes: 14)),
          yama: YamaIndex.yama1,
        ),
      );

      await tester.pumpWidget(
        testableWidget(StagnancyCard(data: dataWithFire)),
      );

      expect(
        find.textContaining('Active Fire element (Tejas)'),
        findsOneWidget,
      );
    });

    testWidgets(
      'tapping rebalance affordance opens intervention selector sheet',
      (tester) async {
        final data = createTestDashboardData(
          stagnancy: const StagnancyAnalysisResult(
            level: StagnancyLevel.mild,
            stuckFlow: BreathFlow.solar,
            continuousDuration: Duration(hours: 6),
          ),
        );

        await tester.pumpWidget(testableWidget(StagnancyCard(data: data)));

        final button = find.text('Rebalance channel');
        expect(button, findsOneWidget);

        await tester.tap(button);
        await tester.pumpAndSettle();

        // The InterventionSelectorSheet should be displayed
        expect(find.text('Shift Your Breath Channel'), findsOneWidget);
      },
    );

    testWidgets('renders properly in Tamil locale', (tester) async {
      final data = createTestDashboardData(
        stagnancy: const StagnancyAnalysisResult(
          level: StagnancyLevel.mild,
          stuckFlow: BreathFlow.solar,
          continuousDuration: Duration(hours: 6),
        ),
      );

      await tester.pumpWidget(
        testableWidget(StagnancyCard(data: data), locale: const Locale('ta')),
      );

      expect(find.text('சுவாசத் தேக்கம் (மிதமானது)'), findsOneWidget);
      expect(find.textContaining('சீதளி'), findsOneWidget);
      expect(find.text('சுவாசத்தை சமநிலைப்படுத்து'), findsOneWidget);
    });
  });
}
