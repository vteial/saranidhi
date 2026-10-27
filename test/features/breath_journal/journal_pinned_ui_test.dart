import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/data/journal_repository.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/journal_history_list.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

class _MockJournalRepository implements JournalRepository {
  final Map<String, bool> pinnedStates = {};

  @override
  Future<int> setPinned(String id, bool isPinned) async {
    pinnedStates[id] = isPinned;
    return 1;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JournalHistoryList isPinned UI (R4 / T2 / RT)', () {
    testWidgets('renders pinned section at top when entries are pinned', (tester) async {
      final now = DateTime.now();
      final entries = [
        SaraKalaiJournalData(
          id: 'pinned-1',
          timestamp: now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
          expectedFlow: 'solar',
          actualFlow: 'solar',
          isAligned: true,
          nostril: 'right',
          isPinned: true,
          wasForcedShift: false,
        ),
        SaraKalaiJournalData(
          id: 'unpinned-1',
          timestamp: now.subtract(const Duration(minutes: 10)).millisecondsSinceEpoch,
          expectedFlow: 'lunar',
          actualFlow: 'lunar',
          isAligned: true,
          nostril: 'left',
          isPinned: false,
          wasForcedShift: false,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalEntriesProvider.overrideWith((ref) => Stream.value(entries)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: SingleChildScrollView(child: JournalHistoryList())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Pinned section exists
      expect(find.text('Pinned'), findsOneWidget);
      expect(find.text('(1)'), findsOneWidget);

      // Star icons: 1 filled (pinned), 1 border (unpinned)
      expect(find.byIcon(Icons.star), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    testWidgets('star toggle button calls repository.setPinned', (tester) async {
      final now = DateTime.now();
      final mockRepo = _MockJournalRepository();
      final entries = [
        SaraKalaiJournalData(
          id: 'entry-to-pin',
          timestamp: now.millisecondsSinceEpoch,
          expectedFlow: 'solar',
          actualFlow: 'solar',
          isAligned: true,
          nostril: 'right',
          isPinned: false,
          wasForcedShift: false,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalEntriesProvider.overrideWith((ref) => Stream.value(entries)),
            journalRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: SingleChildScrollView(child: JournalHistoryList())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final starButton = find.byIcon(Icons.star_border);
      expect(starButton, findsOneWidget);

      await tester.tap(starButton);
      await tester.pump();

      expect(mockRepo.pinnedStates['entry-to-pin'], isTrue);
    });

    testWidgets('renders pure Tamil script in Tamil locale (RT)', (tester) async {
      final now = DateTime.now();
      final entries = [
        SaraKalaiJournalData(
          id: 'pinned-ta',
          timestamp: now.millisecondsSinceEpoch,
          expectedFlow: 'solar',
          actualFlow: 'solar',
          isAligned: true,
          nostril: 'right',
          isPinned: true,
          wasForcedShift: false,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalEntriesProvider.overrideWith((ref) => Stream.value(entries)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ta'),
            home: Scaffold(body: SingleChildScrollView(child: JournalHistoryList())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Pure Tamil for "Pinned" header
      expect(find.text('பின் செய்தவை'), findsOneWidget);
      // Tooltip/semantics for unpin in Tamil (BUG-POLISH-01: distinct from delete 'நீக்கு')
      expect(find.byTooltip('பின் அகற்று'), findsOneWidget);
    });
  });
}
