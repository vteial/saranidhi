import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/rahu_kaal_calculator.dart';
import 'package:saranidhi/features/home/presentation/widgets/rahu_kaal_card.dart';

import '../../../helpers/pump_app.dart';

void main() {
  final now = DateTime.now();

  group('RahuKaalCard', () {
    testWidgets('shows time range in HH:mm format', (tester) async {
      final rahuKaal = RahuKaalResult(
        start: DateTime(2025, 3, 20, 10, 30),
        end: DateTime(2025, 3, 20, 12, 0),
        weekday: 4,
      );

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.textContaining('10:30 - 12:00'), findsOneWidget);
    });

    testWidgets('shows warning when isActive', (tester) async {
      final rahuKaal = RahuKaalResult(
        start: now.subtract(const Duration(minutes: 30)),
        end: now.add(const Duration(minutes: 30)),
        weekday: 0,
      );

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
      // "Active" text should be present
    });

    testWidgets('shows access_time icon when starting soon', (tester) async {
      final rahuKaal = RahuKaalResult(
        start: now.add(const Duration(minutes: 45)),
        end: now.add(const Duration(minutes: 135)),
        weekday: 0,
      );

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
    });

    testWidgets('shows info icon when not active or soon', (tester) async {
      final rahuKaal = RahuKaalResult(
        start: now.add(const Duration(hours: 3)),
        end: now.add(const Duration(hours: 4, minutes: 30)),
        weekday: 0,
      );

      await tester.pumpApp(RahuKaalCard(rahuKaal: rahuKaal));

      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });
  });
}
