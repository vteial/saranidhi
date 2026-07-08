import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/full_day_schedule.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('FullDaySchedule', () {
    testWidgets('renders nothing when bird is null', (tester) async {
      final data = createTestDashboardData(birthBird: null);

      await tester.pumpWidget(testableWidget(FullDaySchedule(data: data)));
      await tester.pumpAndSettle();

      expect(find.text('Y1'), findsNothing);
    });

    testWidgets('renders nothing when pakshiDay is null', (tester) async {
      final data = createTestDashboardData(
        birthBird: PakshiBird.crow,
        pakshiDay: null,
      );

      await tester.pumpWidget(testableWidget(FullDaySchedule(data: data)));
      await tester.pumpAndSettle();

      expect(find.text('Y1'), findsNothing);
    });

    testWidgets('renders 5 day yama rows when data is present', (
      tester,
    ) async {
      final yamaResult = createTestYamaResult();
      final pakshiDay = PakshiCalculator.calculate(
        weekday: 6, // Saturday
        lunarPhase: LunarPhase.waxing,
      );

      final data = createTestDashboardData(
        birthBird: PakshiBird.crow,
        pakshiDay: pakshiDay,
        yamaResult: yamaResult,
      );

      await tester.pumpWidget(testableWidget(FullDaySchedule(data: data)));
      await tester.pumpAndSettle();

      expect(find.text('Y1'), findsOneWidget);
      expect(find.text('Y2'), findsOneWidget);
      expect(find.text('Y3'), findsOneWidget);
      expect(find.text('Y4'), findsOneWidget);
      expect(find.text('Y5'), findsOneWidget);
    });

    testWidgets('shows night section when night data present', (
      tester,
    ) async {
      final yamaResult = createTestYamaResult();
      final pakshiDay = PakshiCalculator.calculate(
        weekday: 6,
        lunarPhase: LunarPhase.waxing,
      );
      final nightYamas = YamaCalculator.calculateNight(
        sunset: DateTime(2026, 7, 5, 18, 30),
        nextSunrise: DateTime(2026, 7, 6, 6, 0),
      );
      final pakshiNight = PakshiCalculator.calculateNight(
        weekday: 6,
        lunarPhase: LunarPhase.waxing,
      );

      final data = createTestDashboardData(
        birthBird: PakshiBird.crow,
        pakshiDay: pakshiDay,
        yamaResult: yamaResult,
        nightYamaResult: nightYamas,
        pakshiNight: pakshiNight,
      );

      await tester.pumpWidget(testableWidget(FullDaySchedule(data: data)));
      await tester.pumpAndSettle();

      // Night yamas Y6-Y10
      expect(find.text('Y6'), findsOneWidget);
      expect(find.text('Y7'), findsOneWidget);
      expect(find.text('Y8'), findsOneWidget);
      expect(find.text('Y9'), findsOneWidget);
      expect(find.text('Y10'), findsOneWidget);
    });
  });
}
