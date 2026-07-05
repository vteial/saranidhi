import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('RahuKaalCard', () {
    testWidgets('renders time window text', (tester) async {
      final rahu = createTestRahuKaal(
        start: DateTime(2026, 7, 5, 9, 0),
        end: DateTime(2026, 7, 5, 10, 30),
      );

      await tester.pumpWidget(testableWidget(RahuKaalCard(rahuKaal: rahu)));
      await tester.pumpAndSettle();

      expect(find.textContaining('09:00'), findsOneWidget);
      expect(find.textContaining('10:30'), findsOneWidget);
    });

    testWidgets('shows warning icon when Rahu Kaal is active', (
      tester,
    ) async {
      // Active: now is between start and end
      final now = DateTime.now();
      final rahu = createTestRahuKaal(
        start: now.subtract(const Duration(minutes: 30)),
        end: now.add(const Duration(minutes: 30)),
      );

      await tester.pumpWidget(testableWidget(RahuKaalCard(rahuKaal: rahu)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    });

    testWidgets('shows clock icon when Rahu Kaal is approaching (within 1h)', (
      tester,
    ) async {
      final now = DateTime.now();
      final rahu = createTestRahuKaal(
        start: now.add(const Duration(minutes: 30)),
        end: now.add(const Duration(minutes: 120)),
      );

      await tester.pumpWidget(testableWidget(RahuKaalCard(rahuKaal: rahu)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
    });

    testWidgets('shows info icon when Rahu Kaal is inactive and not soon', (
      tester,
    ) async {
      final now = DateTime.now();
      final rahu = createTestRahuKaal(
        start: now.add(const Duration(hours: 3)),
        end: now.add(const Duration(hours: 5)),
      );

      await tester.pumpWidget(testableWidget(RahuKaalCard(rahuKaal: rahu)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });
  });
}
