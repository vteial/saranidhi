import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('NostrilDominanceChart', () {
    testWidgets('renders nothing when sunrise and yamaResult are null', (
      tester,
    ) async {
      final data = createTestDashboardData(sunrise: null, yamaResult: null);

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets(
      'renders 5 hourly swara blocks and Now chip when sunrise present',
      (tester) async {
        final sunrise = DateTime(2026, 7, 5, 6);
        final data = createTestDashboardData(sunrise: sunrise);

        await tester.pumpWidget(
          testableWidget(NostrilDominanceChart(data: data)),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Nostril Pattern'), findsOneWidget);
        // Active block has the "Now" chip
        expect(find.textContaining('NOW'), findsOneWidget);
      },
    );

    testWidgets('shows Solar/Lunar labels', (tester) async {
      final sunrise = DateTime(2026, 7, 5, 6);
      final data = createTestDashboardData(sunrise: sunrise);

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      // Displays Solar and Lunar blocks across the hourly cycle
      expect(find.textContaining('Solar'), findsWidgets);
      expect(find.textContaining('Lunar'), findsWidgets);
    });

    testWidgets('shows next switch countdown', (tester) async {
      final sunrise = DateTime(2026, 7, 5, 6);
      final data = createTestDashboardData(sunrise: sunrise);

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Next switch: in'), findsOneWidget);
    });

    testWidgets(
      'shows live expected blocks and night wellness note when isNight is true',
      (tester) async {
        final sunrise = DateTime(2026, 7, 5, 6);
        final data = createTestDashboardData(sunrise: sunrise, isNight: true);

        await tester.pumpWidget(
          testableWidget(NostrilDominanceChart(data: data)),
        );
        await tester.pumpAndSettle();

        // Live nostril pattern continues at night
        expect(find.byType(Card), findsOneWidget);
        expect(find.textContaining('NOW'), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Text &&
                (w.data?.contains('Solar') == true ||
                    w.data?.contains('Lunar') == true),
          ),
          findsWidgets,
        );

        // Night wellness note shown
        expect(find.textContaining('Night cycle'), findsOneWidget);
      },
    );

    testWidgets('renders cleanly when pre-dawn with coordinates provided', (
      tester,
    ) async {
      final sunrise = DateTime(2026, 7, 5, 6);
      final data = createTestDashboardData(
        sunrise: sunrise,
        isNight: true,
        latitude: 13.08,
        longitude: 80.27,
        utcOffset: 5.5,
      );

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('NOW'), findsOneWidget);
    });
  });
}
