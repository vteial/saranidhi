import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/streak_calculator.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/streak_flame_widget.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('StreakFlameWidget', () {
    testWidgets('displays current streak count', (tester) async {
      const streak = StreakResult(
        currentStreak: 5,
        longestStreak: 10,
        isActiveToday: true,
      );

      await tester.pumpWidget(testableWidget(StreakFlameWidget(streak: streak)));
      await tester.pumpAndSettle();

      expect(find.textContaining('5'), findsOneWidget);
    });

    testWidgets('shows flame icon', (tester) async {
      const streak = StreakResult(
        currentStreak: 3,
        longestStreak: 3,
        isActiveToday: false,
      );

      await tester.pumpWidget(testableWidget(StreakFlameWidget(streak: streak)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('shows longest streak when greater than current', (
      tester,
    ) async {
      const streak = StreakResult(
        currentStreak: 3,
        longestStreak: 10,
        isActiveToday: true,
      );

      await tester.pumpWidget(testableWidget(StreakFlameWidget(streak: streak)));
      await tester.pumpAndSettle();

      // Longest streak should appear as '10'
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('does not show longest when equal to current', (tester) async {
      const streak = StreakResult(
        currentStreak: 5,
        longestStreak: 5,
        isActiveToday: true,
      );

      await tester.pumpWidget(testableWidget(StreakFlameWidget(streak: streak)));
      await tester.pumpAndSettle();

      // Should not show a separate 'best' column — longest only shows
      // when longestStreak > currentStreak
      expect(find.textContaining('5'), findsOneWidget);
    });

    testWidgets('shows zero state message when no streak', (tester) async {
      const streak = StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        isActiveToday: false,
      );

      await tester.pumpWidget(testableWidget(StreakFlameWidget(streak: streak)));
      await tester.pumpAndSettle();

      expect(find.textContaining('0'), findsOneWidget);
    });
  });
}
