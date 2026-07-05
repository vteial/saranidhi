import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/birth_bird_card.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('BirthBirdCard', () {
    testWidgets('renders nothing when birthBird is null', (tester) async {
      final data = createTestDashboardData(birthBird: null);
      await tester.pumpWidget(testableWidget(BirthBirdCard(data: data)));
      await tester.pumpAndSettle();

      // SizedBox.shrink renders nothing visible
      expect(find.byType(BirthBirdCard), findsOneWidget);
      expect(find.textContaining('Crow'), findsNothing);
    });

    testWidgets('displays bird name and state when data is present', (
      tester,
    ) async {
      final yamaResult = createTestYamaResult();
      final data = createTestDashboardData(
        birthBird: PakshiBird.crow,
        birthBirdState: PakshiState.ruling,
        yamaResult: yamaResult,
        activeYama: yamaResult.yamas.first,
      );

      await tester.pumpWidget(testableWidget(BirthBirdCard(data: data)));
      await tester.pumpAndSettle();

      expect(find.textContaining('Crow'), findsOneWidget);
      expect(find.textContaining('Ruling'), findsOneWidget);
    });

    testWidgets('shows guidance text for ruling state', (tester) async {
      final data = createTestDashboardData(
        birthBird: PakshiBird.owl,
        birthBirdState: PakshiState.ruling,
      );

      await tester.pumpWidget(testableWidget(BirthBirdCard(data: data)));
      await tester.pumpAndSettle();

      // Guidance text should be non-empty for ruling state
      expect(find.textContaining('Owl'), findsOneWidget);
    });

    testWidgets('shows progress bar when activeYama is present', (
      tester,
    ) async {
      final yamaResult = createTestYamaResult(
        sunrise: DateTime.now().subtract(const Duration(hours: 3)),
        sunset: DateTime.now().add(const Duration(hours: 9)),
      );
      final data = createTestDashboardData(
        birthBird: PakshiBird.peacock,
        birthBirdState: PakshiState.eating,
        yamaResult: yamaResult,
        activeYama: yamaResult.yamas.first,
      );

      await tester.pumpWidget(testableWidget(BirthBirdCard(data: data)));
      await tester.pumpAndSettle();

      // Should show yama progress text (e.g., "Yama 1 — Xmin")
      expect(find.textContaining('Yama'), findsWidgets);
    });

    testWidgets('shows night state when isNight is true', (tester) async {
      final nightYamas = YamaCalculator.calculateNight(
        sunset: DateTime.now().subtract(const Duration(hours: 2)),
        nextSunrise: DateTime.now().add(const Duration(hours: 8)),
      );

      final data = createTestDashboardData(
        birthBird: PakshiBird.vulture,
        birthBirdNightState: PakshiState.sleeping,
        isNight: true,
        nightYamaResult: nightYamas,
        activeNightYama: nightYamas.yamas.first,
      );

      await tester.pumpWidget(testableWidget(BirthBirdCard(data: data)));
      await tester.pumpAndSettle();

      expect(find.textContaining('Vulture'), findsOneWidget);
      expect(find.textContaining('Sleeping'), findsOneWidget);
    });
  });
}
