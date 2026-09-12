import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window_segment.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/home/presentation/widgets/focus_card.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('FocusCard Widget', () {
    final now = DateTime.now();

    ActionWindowSegment makeSegment(
      ActionWindow window, {
      bool isBlocked = false,
    }) {
      return ActionWindowSegment(
        window: window,
        start: now.subtract(const Duration(minutes: 15)),
        end: now.add(const Duration(minutes: 45)),
        birdStateName: 'Ruling',
        isBlockedByRahu: isBlocked,
      );
    }

    testWidgets(
      'non-Kriya window (Artha) renders normally without Swara-Ahara prompt',
      (tester) async {
        final segment = makeSegment(ActionWindow.artha);

        await tester.pumpWidget(testableWidget(FocusCard(segment: segment)));

        expect(find.text('Artha'), findsOneWidget);
        expect(find.textContaining('Eating soon?'), findsNothing);
        expect(find.textContaining('digestive fire'), findsNothing);
      },
    );

    testWidgets(
      'non-Kriya window (Yoga) renders normally without Swara-Ahara prompt',
      (tester) async {
        final segment = makeSegment(ActionWindow.yoga);

        await tester.pumpWidget(testableWidget(FocusCard(segment: segment)));

        expect(find.text('Yoga'), findsOneWidget);
        expect(find.textContaining('Eating soon?'), findsNothing);
      },
    );

    testWidgets(
      'Kriya window with null currentFlow renders generic Swara-Ahara prompt',
      (tester) async {
        final segment = makeSegment(ActionWindow.kriya);

        await tester.pumpWidget(testableWidget(FocusCard(segment: segment)));

        expect(find.text('Kriya'), findsOneWidget);
        expect(
          find.text(
            'Eating soon? Favour a right-nostril (solar) flow to strengthen digestive fire.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('Kriya window with solar currentFlow renders affirming line', (
      tester,
    ) async {
      final segment = makeSegment(ActionWindow.kriya);

      await tester.pumpWidget(
        testableWidget(
          FocusCard(segment: segment, currentFlow: BreathFlow.solar),
        ),
      );

      expect(find.text('Kriya'), findsOneWidget);
      expect(
        find.text(
          'Right nostril active — digestive fire (Jatharagni) is well-placed.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      expect(find.text('Flip to right'), findsNothing);
    });

    testWidgets(
      'Kriya window with lunar currentFlow renders nudge and flip button',
      (tester) async {
        final segment = makeSegment(ActionWindow.kriya);

        await tester.pumpWidget(
          testableWidget(
            FocusCard(segment: segment, currentFlow: BreathFlow.lunar),
          ),
        );

        expect(find.text('Kriya'), findsOneWidget);
        expect(
          find.text(
            'Left nostril currently active. Tap to shift to right before eating.',
          ),
          findsOneWidget,
        );
        expect(find.text('Flip to right'), findsOneWidget);

        // Tap the flip button to verify it launches the InterventionSelectorSheet
        await tester.tap(find.text('Flip to right'));
        await tester.pumpAndSettle();

        expect(find.text('Shift Your Breath Channel'), findsOneWidget);
      },
    );

    testWidgets('Rahu-blocked Kriya window hides Swara-Ahara prompt', (
      tester,
    ) async {
      final segment = makeSegment(ActionWindow.kriya, isBlocked: true);

      await tester.pumpWidget(
        testableWidget(
          FocusCard(segment: segment, currentFlow: BreathFlow.lunar),
        ),
      );

      expect(find.text('RAHU'), findsOneWidget);
      expect(find.textContaining('Eating soon?'), findsNothing);
      expect(find.text('Flip to right'), findsNothing);
    });

    testWidgets('renders Kriya Swara-Ahara prompt properly in Tamil', (
      tester,
    ) async {
      final segment = makeSegment(ActionWindow.kriya);

      await tester.pumpWidget(
        testableWidget(
          FocusCard(segment: segment, currentFlow: BreathFlow.lunar),
          locale: const Locale('ta'),
        ),
      );

      expect(find.text('கிரியா'), findsOneWidget);
      expect(
        find.text(
          'இடது நாசி தற்போது செயலில் உள்ளது. உண்பதற்கு முன் வலது நாசிக்கு மாற்ற தட்டவும்.',
        ),
        findsOneWidget,
      );
      expect(find.text('வலதுக்கு மாற்றவும்'), findsOneWidget);
    });
  });
}
