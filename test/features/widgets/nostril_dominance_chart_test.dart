import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/home/presentation/widgets/nostril_dominance_chart.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('NostrilDominanceChart', () {
    testWidgets('renders nothing when yamaResult is null', (tester) async {
      final data = createTestDashboardData(yamaResult: null);

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      // Widget returns SizedBox.shrink when no yama data
      expect(find.textContaining('Y1'), findsNothing);
    });

    testWidgets('renders 5 yama rows when yamaResult present', (
      tester,
    ) async {
      final yamaResult = createTestYamaResult();
      final data = createTestDashboardData(
        yamaResult: yamaResult,
        activeYama: yamaResult.yamas[2],
      );

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Y1'), findsOneWidget);
      expect(find.text('Y2'), findsOneWidget);
      expect(find.text('Y3'), findsOneWidget);
      expect(find.text('Y4'), findsOneWidget);
      expect(find.text('Y5'), findsOneWidget);
    });

    testWidgets('shows Solar/Lunar labels', (tester) async {
      final yamaResult = createTestYamaResult();
      final data = createTestDashboardData(yamaResult: yamaResult);

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      // Odd yamas = Solar (Right), Even = Lunar (Left)
      expect(find.textContaining('Solar'), findsWidgets);
      expect(find.textContaining('Lunar'), findsWidgets);
    });

    testWidgets('shows night message when isNight is true', (tester) async {
      final yamaResult = createTestYamaResult();
      final data = createTestDashboardData(
        yamaResult: yamaResult,
        isNight: true,
      );

      await tester.pumpWidget(
        testableWidget(NostrilDominanceChart(data: data)),
      );
      await tester.pumpAndSettle();

      // Night message about no nostril pattern
      expect(find.textContaining('Night'), findsOneWidget);
    });
  });
}
