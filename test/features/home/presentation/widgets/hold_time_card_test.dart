import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/home/presentation/widgets/hold_time_card.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('HoldTimeCard', () {
    testWidgets('shows "No entries today" when avgHoldMs is null', (tester) async {
      await tester.pumpApp(const HoldTimeCard(avgHoldMs: null, entryCount: 0));
      expect(find.text('No entries yet today'), findsOneWidget);
    });

    testWidgets('shows formatted average when data present', (tester) async {
      await tester.pumpApp(const HoldTimeCard(avgHoldMs: 15500, entryCount: 3));
      // 15.5s, 3 entries
      expect(find.textContaining('15.5s'), findsOneWidget);
      expect(find.textContaining('3 entries'), findsOneWidget);
    });
  });
}
