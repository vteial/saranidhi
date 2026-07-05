import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/home/presentation/widgets/hold_time_card.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('HoldTimeCard', () {
    testWidgets('shows "no entries" when entryCount is 0', (tester) async {
      await tester.pumpWidget(
        testableWidget(const HoldTimeCard(avgHoldMs: null, entryCount: 0)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HoldTimeCard), findsOneWidget);
      // Should show the "no entries today" message
      expect(find.textContaining('No'), findsOneWidget);
    });

    testWidgets('shows average hold in seconds when data exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        testableWidget(
          const HoldTimeCard(avgHoldMs: 3500, entryCount: 4),
        ),
      );
      await tester.pumpAndSettle();

      // 3500ms = 3.5 seconds
      expect(find.textContaining('3.5'), findsOneWidget);
    });

    testWidgets('shows entry count', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const HoldTimeCard(avgHoldMs: 2000, entryCount: 7),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('7'), findsOneWidget);
    });
  });
}
