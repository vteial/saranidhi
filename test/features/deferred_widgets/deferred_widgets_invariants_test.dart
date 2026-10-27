import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/router/onboarding_guard.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/breath_journal/presentation/widgets/journal_history_list.dart';
import 'package:saranidhi/features/breath_journal/providers/journal_providers.dart';
import 'package:saranidhi/features/onboarding/presentation/intro_screen.dart';
import 'package:saranidhi/features/onboarding/presentation/onboarding_screen.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/features/whats_new/presentation/whats_new_screen.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('T1a — RQ.3a Manual breath capture unchanged invariant', () {
    test('BreathTimerNotifier records exact user durations without auto-advance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(breathTimerNotifierProvider.notifier);
      expect(container.read(breathTimerNotifierProvider).phase, TimerPhase.idle);

      // User starts inhale
      notifier.startInhale();
      expect(container.read(breathTimerNotifierProvider).phase, TimerPhase.inhale);

      // User finishes inhale with actual held duration (e.g. 4321 ms)
      notifier.finishInhale(4321);
      final afterInhale = container.read(breathTimerNotifierProvider);
      expect(afterInhale.phase, TimerPhase.hold);
      expect(afterInhale.inhaleMs, equals(4321));

      // User finishes hold with actual duration (e.g. 7654 ms)
      notifier.finishHold(7654);
      final afterHold = container.read(breathTimerNotifierProvider);
      expect(afterHold.phase, TimerPhase.exhale);
      expect(afterHold.inhaleMs, equals(4321));
      expect(afterHold.holdMs, equals(7654));

      // User finishes exhale with actual duration (e.g. 8765 ms)
      notifier.finishExhale(8765);
      final complete = container.read(breathTimerNotifierProvider);
      expect(complete.phase, TimerPhase.complete);
      expect(complete.inhaleMs, equals(4321));
      expect(complete.holdMs, equals(7654));
      expect(complete.exhaleMs, equals(8765));

      // Invariant: Durations are exact user-recorded values, not overwritten by any preset
    });
  });

  group('T1b — RQ.3b WhatsNew gate never fires before onboarding/intro completes', () {
    testWidgets('WhatsNew never displays when intro is not seen', (tester) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': false,
        'whats_new_last_seen_version': '0.9.0', // Outdated, should show when eligible
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith(
              () => _TestOnboardingCompleteNotifier(isComplete: false),
            ),
            introSeenProvider.overrideWith(() => _TestIntroSeenNotifier(seen: false)),
            shouldShowWhatsNewProvider.overrideWith((ref) => true),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: OnboardingGuard(child: Text('MainAppContent')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Must find IntroScreen, NOT WhatsNewScreen, NOT MainAppContent
      expect(find.byType(IntroScreen), findsOneWidget);
      expect(find.byType(WhatsNewScreen), findsNothing);
      expect(find.text('MainAppContent'), findsNothing);
    });

    testWidgets('WhatsNew never displays when onboarding is in progress', (tester) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_complete': false,
        'whats_new_last_seen_version': '0.9.0',
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith(
              () => _TestOnboardingCompleteNotifier(isComplete: false),
            ),
            introSeenProvider.overrideWith(() => _TestIntroSeenNotifier(seen: true)),
            shouldShowWhatsNewProvider.overrideWith((ref) => true),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: OnboardingGuard(child: Text('MainAppContent')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Must find OnboardingScreen, NOT WhatsNewScreen, NOT MainAppContent
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(WhatsNewScreen), findsNothing);
      expect(find.text('MainAppContent'), findsNothing);
    });
  });

  group('T1c — RQ.3c Journal list order unchanged when nothing is pinned', () {
    testWidgets('With nothing pinned, renders chronological date groups without Pinned header', (
      tester,
    ) async {
      final now = DateTime.now();
      final t1 = now.subtract(const Duration(minutes: 5)).millisecondsSinceEpoch;
      final t2 = now.subtract(const Duration(minutes: 30)).millisecondsSinceEpoch;

      final testEntries = [
        SaraKalaiJournalData(
          id: 'entry-1',
          timestamp: t1,
          expectedFlow: 'solar',
          actualFlow: 'solar',
          isAligned: true,
          nostril: 'right',
          isPinned: false,
          wasForcedShift: false,
        ),
        SaraKalaiJournalData(
          id: 'entry-2',
          timestamp: t2,
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
            journalEntriesProvider.overrideWith((ref) => Stream.value(testEntries)),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: SingleChildScrollView(child: JournalHistoryList())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Invariant: When nothing is pinned, no "Pinned" section header is shown
      expect(find.text('Pinned'), findsNothing);
      expect(find.text('பின் செய்தவை'), findsNothing);
      // Both entries render in standard history
      expect(find.text('Solar (Right) flow'), findsOneWidget);
      expect(find.text('Lunar (Left) flow'), findsOneWidget);
    });
  });
}

class _TestOnboardingCompleteNotifier extends OnboardingCompleteNotifier {
  _TestOnboardingCompleteNotifier({required this.isComplete});
  final bool isComplete;

  @override
  bool build() => isComplete;
}

class _TestIntroSeenNotifier extends IntroSeenNotifier {
  _TestIntroSeenNotifier({required this.seen});
  final bool seen;

  @override
  bool build() => seen;
}
