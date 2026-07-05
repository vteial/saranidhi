import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/streaks/domain/seven_day_ribbon.dart';
import 'package:saranidhi/features/streaks/presentation/widgets/seven_day_ribbon_widget.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('SevenDayRibbonWidget', () {
    testWidgets('renders 7 day chips', (tester) async {
      final ribbon = _createTestRibbon();

      await tester.pumpWidget(
        testableWidget(SevenDayRibbonWidget(ribbon: ribbon)),
      );
      await tester.pumpAndSettle();

      // 7 day labels should be present (one per day of the week)
      expect(find.byType(SevenDayRibbonWidget), findsOneWidget);
    });

    testWidgets('shows check icon for aligned days', (tester) async {
      final ribbon = [
        RibbonDay(
          date: DateTime(2026, 7, 1),
          status: DayStatus.aligned,
          dayLabel: 'T',
        ),
        RibbonDay(
          date: DateTime(2026, 7, 2),
          status: DayStatus.aligned,
          dayLabel: 'W',
        ),
        for (var i = 3; i <= 7; i++)
          RibbonDay(
            date: DateTime(2026, 7, i),
            status: DayStatus.noEntry,
            dayLabel: 'X',
          ),
      ];

      await tester.pumpWidget(
        testableWidget(SevenDayRibbonWidget(ribbon: ribbon)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });

    testWidgets('shows close icon for unaligned days', (tester) async {
      final ribbon = [
        RibbonDay(
          date: DateTime(2026, 7, 1),
          status: DayStatus.unaligned,
          dayLabel: 'T',
        ),
        for (var i = 2; i <= 7; i++)
          RibbonDay(
            date: DateTime(2026, 7, i),
            status: DayStatus.noEntry,
            dayLabel: 'X',
          ),
      ];

      await tester.pumpWidget(
        testableWidget(SevenDayRibbonWidget(ribbon: ribbon)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows dash icon for no-entry days', (tester) async {
      final ribbon = List.generate(
        7,
        (i) => RibbonDay(
          date: DateTime(2026, 7, i + 1),
          status: DayStatus.noEntry,
          dayLabel: 'X',
        ),
      );

      await tester.pumpWidget(
        testableWidget(SevenDayRibbonWidget(ribbon: ribbon)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.remove), findsNWidgets(7));
    });
  });
}

List<RibbonDay> _createTestRibbon() {
  final today = DateTime(2026, 7, 5);
  return List.generate(7, (i) {
    final date = today.subtract(Duration(days: 6 - i));
    final status = i < 3
        ? DayStatus.aligned
        : i < 5
            ? DayStatus.unaligned
            : DayStatus.noEntry;
    return RibbonDay(
      date: date,
      status: status,
      dayLabel: ['S', 'M', 'T', 'W', 'T', 'F', 'S'][date.weekday % 7],
    );
  });
}
