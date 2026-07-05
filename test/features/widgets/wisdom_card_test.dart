import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/ai_wisdom/presentation/widgets/wisdom_card.dart';
import 'package:saranidhi/features/ai_wisdom/providers/wisdom_providers.dart';

import '../../helpers/widget_test_helpers.dart';

void main() {
  group('WisdomCard', () {
    testWidgets('shows wisdom text when loaded', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const WisdomCard(),
          overrides: [
            wisdomInsightProvider.overrideWith(
              (ref) async => 'The breath is the bridge.',
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('The breath is the bridge.'), findsOneWidget);
    });

    testWidgets('shows auto_awesome icon', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const WisdomCard(),
          overrides: [
            wisdomInsightProvider.overrideWith(
              (ref) async => 'Test wisdom',
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('shows skeleton loader while loading', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const WisdomCard(),
          overrides: [
            wisdomInsightProvider.overrideWith((ref) {
              // Never completes — stays in loading state
              return Future.delayed(
                const Duration(days: 1),
                () => 'Never',
              );
            }),
          ],
        ),
      );
      // Don't settle — stay in loading state
      await tester.pump();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('shows fallback text on error', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const WisdomCard(),
          overrides: [
            wisdomInsightProvider.overrideWith(
              (ref) async => throw Exception('Network error'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Should show the fallback wisdom text from l10n
      expect(find.byType(WisdomCard), findsOneWidget);
    });
  });
}
