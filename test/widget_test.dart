import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/main.dart';

void main() {
  testWidgets('App renders with bottom navigation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalEntriesProvider.overrideWith(
            (ref) => Stream.value(<SaraKalaiJournalData>[]),
          ),
        ],
        child: const SaranidhiApp(),
      ),
    );
    await tester.pump();

    // Verify bottom navigation tabs are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify home screen content
    expect(find.text('Saranidhi'), findsOneWidget);
    expect(find.text('The Treasure House of Breath'), findsOneWidget);
  });

  testWidgets('Navigation between tabs works', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalEntriesProvider.overrideWith(
            (ref) => Stream.value(<SaraKalaiJournalData>[]),
          ),
        ],
        child: const SaranidhiApp(),
      ),
    );
    await tester.pump();

    // Navigate to Journal tab
    await tester.tap(find.text('Journal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Breath Journal'), findsOneWidget);

    // Navigate to Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Theme'), findsOneWidget);

    // Navigate back to Home tab
    await tester.tap(find.text('Home'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('The Treasure House of Breath'), findsOneWidget);
  });
}
