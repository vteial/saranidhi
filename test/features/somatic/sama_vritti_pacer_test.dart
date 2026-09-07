import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/somatic/presentation/widgets/sama_vritti_pacer.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('SamaVrittiPacer', () {
    testWidgets('lays out a 220x220 pacer with a phase label and second count',
        (tester) async {
      await tester.pumpWidget(testableWidget(const SamaVrittiPacer()));
      // NEVER pumpAndSettle: the controller repeats forever and would time
      // out. Pump a couple of explicit frames instead.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // The pacer sizes itself to 220x220.
      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(SamaVrittiPacer),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.width, 220);
      expect(sizedBox.height, 220);

      // First phase (t ~= 0) is Inhale.
      expect(find.text('Inhale'), findsOneWidget);
      // A per-phase second count (1..phaseSeconds) is rendered.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('advances phase labels as the animation progresses',
        (tester) async {
      // phaseSeconds:1 → one full cycle is 4s: inhale, hold, exhale, hold.
      await tester.pumpWidget(
        testableWidget(const SamaVrittiPacer(phaseSeconds: 1)),
      );
      await tester.pump();

      // t ~= 0 → inhale.
      expect(find.text('Inhale'), findsOneWidget);

      // Advance ~1.1s into the second (hold-in) phase.
      await tester.pump(const Duration(milliseconds: 1100));
      expect(find.text('Hold'), findsOneWidget);

      // Advance into the third (exhale) phase (~2.1s total).
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('Exhale'), findsOneWidget);
    });
  });
}
