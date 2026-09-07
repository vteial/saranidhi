import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/somatic/domain/somatic_intervention_session.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/cross_lateral_instruction_card.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('CrossLateralInstructionCard', () {
    testWidgets('posture shift renders the lateral-recumbency icon + '
        'instruction (left side)', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const CrossLateralInstructionCard(
            type: InterventionType.postureShift,
            bodySide: BodySide.left,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.airline_seat_flat), findsOneWidget);
      // 'Lie on your left side (lateral recumbency)...'
      expect(find.textContaining('Lie on your left'), findsOneWidget);
    });

    testWidgets('posture shift renders the right-side instruction',
        (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const CrossLateralInstructionCard(
            type: InterventionType.postureShift,
            bodySide: BodySide.right,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.airline_seat_flat), findsOneWidget);
      expect(find.textContaining('Lie on your right'), findsOneWidget);
    });

    testWidgets('axillary pressure renders the pan_tool icon + instruction '
        '(left side)', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const CrossLateralInstructionCard(
            type: InterventionType.axillaryPressure,
            bodySide: BodySide.left,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pan_tool_outlined), findsOneWidget);
      // 'Apply firm pressure under your left armpit...'
      expect(find.textContaining('under your left armpit'), findsOneWidget);
    });

    testWidgets('axillary pressure renders the right-side instruction',
        (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const CrossLateralInstructionCard(
            type: InterventionType.axillaryPressure,
            bodySide: BodySide.right,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pan_tool_outlined), findsOneWidget);
      expect(find.textContaining('under your right armpit'), findsOneWidget);
    });
  });
}
