import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/home/presentation/widgets/hold_time_card.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('HoldTimeCard', () {
    testWidgets('shows No entries today when avgHoldMs is null', (tester) async {
      await tester.pumpApp(
        const HoldTimeCard(avgHoldMs: null, entryCount: 0),
      );

      expect(find.textContaining('No entries'), findsOneWidget);
    });

    testWidgets('shows No entries today when entryCount is 0', (tester) async {
      await tester.pumpApp(
        const HoldTimeCard(avgHoldMs: 1000, entryCount: 0),
      );

      expect(find.textContaining('No entries'), findsOneWidget);
    });

    testWidgets('shows formatted average and entry count when data present', (tester) async {
      await tester.pumpApp(
        const HoldTimeCard(avgHoldMs: 5500, entryCount: 3),
      );

      expect(find.textContaining('5.5s'), findsOneWidget);
      expect(find.textContaining('3'), findsOneWidget);
    });
  });
}
