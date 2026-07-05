import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/ai_wisdom/presentation/widgets/wisdom_card.dart';
import 'package:saranidhi/features/ai_wisdom/providers/wisdom_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

Widget _wisdomTestApp({required List overrides}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const Scaffold(body: WisdomCard()),
    ),
  );
}

void main() {
  group('WisdomCard', () {
    testWidgets('shows wisdom text when loaded', (tester) async {
      await tester.pumpWidget(
        _wisdomTestApp(
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
        _wisdomTestApp(
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

    testWidgets('shows loading state before data arrives', (tester) async {
      await tester.pumpWidget(
        _wisdomTestApp(
          overrides: [
            wisdomInsightProvider.overrideWith((ref) {
              return Future.delayed(
                const Duration(days: 1),
                () => 'Never arrives',
              );
            }),
          ],
        ),
      );
      // Single pump — provider is still loading
      await tester.pump();

      // The card renders but wisdom text is not yet present
      expect(find.byType(WisdomCard), findsOneWidget);
      expect(find.text('Never arrives'), findsNothing);
    });

    testWidgets('shows fallback on error', (tester) async {
      await tester.pumpWidget(
        _wisdomTestApp(
          overrides: [
            wisdomInsightProvider.overrideWith(
              (ref) async => throw Exception('fail'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Card still renders (with error/fallback state)
      expect(find.byType(WisdomCard), findsOneWidget);
    });
  });
}
