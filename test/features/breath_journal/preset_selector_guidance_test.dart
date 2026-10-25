import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/breath_journal/domain/breath_flow.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/preset_selector.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/journal/presentation/journal_screen.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PresetSelector Guidance (R2 / T4 / RT)', () {
    testWidgets('renders PresetSelector with Manual selected by default, shows guidance when preset picked', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer(
        overrides: [
          journalEntriesProvider.overrideWith((ref) => Stream.value(<SaraKalaiJournalData>[])),
          latestJournalEntryProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );
      addTearDown(container.dispose);

      // Select Solar flow so the timer panel and preset selector become visible
      container.read(breathEntryNotifierProvider.notifier).selectFlow(BreathFlow.solar);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: JournalScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // PresetSelector is rendered
      expect(find.byType(PresetSelector), findsOneWidget);
      expect(find.text('Manual'), findsOneWidget);
      expect(find.text('4-7-8'), findsOneWidget);
      expect(find.text('Box'), findsOneWidget);

      // Manual is selected by default; guidance card is NOT shown
      expect(find.textContaining('Guided:'), findsNothing);

      // Tap '4-7-8' chip
      await tester.tap(find.text('4-7-8'));
      await tester.pumpAndSettle();

      // Guidance card appears with target rhythm (R2.2)
      expect(find.textContaining('Guided: 4-7-8: 4s In • 7s Hold • 8s Out'), findsOneWidget);

      // Switch back to 'Manual'
      await tester.tap(find.text('Manual'));
      await tester.pumpAndSettle();

      // Guidance card hidden again
      expect(find.textContaining('Guided:'), findsNothing);
    });

    testWidgets('renders pure Tamil script guidance in Tamil locale (RT)', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer(
        overrides: [
          journalEntriesProvider.overrideWith((ref) => Stream.value(<SaraKalaiJournalData>[])),
          latestJournalEntryProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );
      addTearDown(container.dispose);

      container.read(breathEntryNotifierProvider.notifier).selectFlow(BreathFlow.solar);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ta'),
            home: JournalScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tamil chip labels
      expect(find.text('கையால்'), findsOneWidget);
      expect(find.text('பெட்டி'), findsOneWidget);

      // Tap 'பெட்டி' (Box breathing: 4-4-4-4)
      await tester.tap(find.text('பெட்டி'));
      await tester.pumpAndSettle();

      // Pure Tamil guidance text: வழிகாட்டி: பெட்டி: 4s உள் • 4s நிறுத்து • 4s வெளி • 4s நிறுத்து
      expect(find.textContaining('வழிகாட்டி: பெட்டி: 4s உள் • 4s நிறுத்து • 4s வெளி • 4s நிறுத்து'), findsOneWidget);
    });
  });
}
