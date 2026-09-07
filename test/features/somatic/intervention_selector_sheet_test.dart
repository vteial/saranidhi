import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/intervention_selector_sheet.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('InterventionSelectorSheet', () {
    testWidgets('renders the selector title/subtitle and both protocol tiles',
        (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const InterventionSelectorSheet(
            targetFlow: 'left',
            initialFlow: 'right',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Selector header.
      expect(find.text('Shift Your Breath Channel'), findsOneWidget);
      expect(
        find.textContaining('Choose a guided protocol'),
        findsOneWidget,
      );

      // Both protocol tiles.
      expect(find.text('Posture Shift'), findsOneWidget);
      expect(find.text('Axillary Pressure'), findsOneWidget);

      // Duration labels: posture = 3 min, axillary = 5 min.
      expect(find.text('3 min'), findsOneWidget);
      expect(find.text('5 min'), findsOneWidget);
    });

    testWidgets('renders the protocol icons', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const InterventionSelectorSheet(
            targetFlow: 'right',
            initialFlow: 'left',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.airline_seat_flat), findsOneWidget);
      expect(find.byIcon(Icons.pan_tool_outlined), findsOneWidget);
    });
  });
}
