import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('RahuKaalCard', () {
    final now = DateTime.now();

    RahuKaalResult createRahuKaal({
      required DateTime start,
      required DateTime end,
    }) {
      return RahuKaalResult(
        start: start,
        end: end,
        weekday: 0,
      );
    }

    testWidgets('renders formatted time range', (tester) async {
      final start = DateTime(2025, 3, 20, 10, 30);
      final end = DateTime(2025, 3, 20, 12, 0);
      final rahuKaal = createRahuKaal(start: start, end: end);

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.textContaining('10:30 - 12:00'), findsOneWidget);
    });

    testWidgets('shows active state when current time is within window', (tester) async {
      final start = now.subtract(const Duration(minutes: 30));
      final end = now.add(const Duration(minutes: 30));
      final rahuKaal = createRahuKaal(start: start, end: end);

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    });

    testWidgets('shows soon state when starting within 1 hour', (tester) async {
      final start = now.add(const Duration(minutes: 45));
      final end = now.add(const Duration(minutes: 105));
      final rahuKaal = createRahuKaal(start: start, end: end);

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
    });

    testWidgets('shows subtle state otherwise', (tester) async {
      final start = now.add(const Duration(hours: 3));
      final end = now.add(const Duration(hours: 4, minutes: 30));
      final rahuKaal = createRahuKaal(start: start, end: end);

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });
  });
}
