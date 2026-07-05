import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/trend_calculator.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/trend_widget.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('TrendWidget', () {
    testWidgets('displays alignment percentage', (tester) async {
      const trend = TrendResult(
        alignmentPercentage: 75,
        totalDaysWithEntries: 10,
        totalAlignedDays: 8,
        periodDays: 30,
      );

      await tester.pumpWidget(testableWidget(TrendWidget(trend: trend)));
      await tester.pumpAndSettle();

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('displays progress indicator', (tester) async {
      const trend = TrendResult(
        alignmentPercentage: 50,
        totalDaysWithEntries: 6,
        totalAlignedDays: 3,
        periodDays: 30,
      );

      await tester.pumpWidget(testableWidget(TrendWidget(trend: trend)));
      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows summary text with aligned/total days', (tester) async {
      const trend = TrendResult(
        alignmentPercentage: 80,
        totalDaysWithEntries: 15,
        totalAlignedDays: 12,
        periodDays: 30,
      );

      await tester.pumpWidget(testableWidget(TrendWidget(trend: trend)));
      await tester.pumpAndSettle();

      // Summary text contains aligned and total day counts
      expect(find.textContaining('12'), findsWidgets);
      expect(find.textContaining('15'), findsWidgets);
    });

    testWidgets('shows 0% for empty trend', (tester) async {
      const trend = TrendResult(
        alignmentPercentage: 0,
        totalDaysWithEntries: 0,
        totalAlignedDays: 0,
        periodDays: 30,
      );

      await tester.pumpWidget(testableWidget(TrendWidget(trend: trend)));
      await tester.pumpAndSettle();

      expect(find.text('0%'), findsOneWidget);
    });
  });
}
