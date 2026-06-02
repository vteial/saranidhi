import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/main.dart';

void main() {
  testWidgets('App renders with bottom navigation', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SaranidhiApp()));

    // Verify bottom navigation tabs are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify home screen content
    expect(find.text('Saranidhi'), findsOneWidget);
    expect(find.text('The Treasure House of Breath'), findsOneWidget);
  });

  testWidgets('Navigation between tabs works', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SaranidhiApp()));

    // Navigate to Journal tab
    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    expect(find.text('Sara Kalai Breath Journal'), findsOneWidget);

    // Navigate to Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Theme'), findsOneWidget);

    // Navigate back to Home tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('The Treasure House of Breath'), findsOneWidget);
  });
}
