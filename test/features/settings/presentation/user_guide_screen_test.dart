import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/settings/presentation/user_guide_screen.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

Widget testableGuideScreen({Locale locale = const Locale('en')}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: const UserGuideScreen(),
  );
}

void main() {
  const surfaceSize = Size(800, 6000);

  group('UserGuideScreen regression invariants (RQ.1, RQ.2)', () {
    testWidgets('renders flat CustomScrollView with ordered sections in EN', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(testableGuideScreen());
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.text('User Guide'), findsOneWidget);

      // Section titles in expected reading order (including new Prasanam Oracle section)
      final expectedTitles = [
        'What is Saranidhi?',
        'The Science Behind It',
        'Your Birth Bird',
        'Daily Rhythm',
        'How to Use the App',
        'Best Practices',
        'Swara Pada Gamana (The Grounding First Step)',
        'Swara-Ahara (Dietary Alignment)',
        'Understanding the Dashboard',
        'Prasanam Oracle',
        'Benefits',
        'Frequently Asked Questions',
      ];

      for (final title in expectedTitles) {
        expect(
          find.text(title),
          findsOneWidget,
          reason: 'Expected section title "$title" to be present',
        );
      }

      // Assert R1: Oracle section content present
      expect(
        find.textContaining('The Oracle tab (the fourth destination in bottom navigation)'),
        findsOneWidget,
      );

      // Assert R2: Stale "Explore" tab references removed, replaced with current nav
      expect(find.textContaining("'Explore' tab"), findsNothing);
      expect(find.textContaining('Home Tab'), findsOneWidget);
      expect(find.textContaining('Journal & Presets'), findsOneWidget);
      expect(find.textContaining('Prasanam Oracle'), findsWidgets);
      expect(find.textContaining('Analytics & Milestones'), findsOneWidget);
      expect(find.textContaining('Settings & Sync'), findsOneWidget);

      // Assert R3 & R4: Journal features, Hora & Tattva, Streak milestones
      expect(
        find.textContaining('Hora & Tattva — Real-time planetary hour (Horai) and active element (Tattvam)'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Streak & Milestones — Consecutive practice days with special milestone celebrations at 7, 30, 100, and 365 days.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('star/pin meaningful entries to the top'),
        findsOneWidget,
      );

      // Assert R5: Practice Sync in FAQ and Benefits
      expect(
        find.textContaining('Q: What is Practice Sync?'),
        findsOneWidget,
      );
      expect(
        find.textContaining('optional, opt-in Practice Sync across your personal devices'),
        findsOneWidget,
      );
    });

    testWidgets('renders all four bilingual reference tables (RQ.2)', (
      tester,
    ) async {
      await tester.pumpWidget(testableGuideScreen());
      await tester.pumpAndSettle();

      // Scroll to Reference section header
      final refHeader = find.text('Reference / \u0B89\u0BB3\u0BCD\u0BA8\u0BBF\u0BB2\u0BC8');
      await tester.scrollUntilVisible(refHeader, 500);
      expect(refHeader, findsOneWidget);

      // Scroll to each table and verify
      final horaTitle = find.text('Planetary Hours (Hora) / \u0B95\u0BBF\u0BB0\u0B95 \u0BA8\u0BC7\u0BB0\u0BAE\u0BCD (\u0BB9\u0BCB\u0BB0\u0BBE)');
      await tester.scrollUntilVisible(horaTitle, 500);
      expect(horaTitle, findsOneWidget);

      final elementsTitle = find.text('Five Elements (Tattva) / \u0B90\u0BA8\u0BCD\u0BA4\u0BC1 \u0BAA\u0BC2\u0BA4\u0B99\u0BCD\u0B95\u0BB3\u0BCD (\u0BA4\u0BA4\u0BCD\u0BB5\u0BAE\u0BCD)');
      await tester.scrollUntilVisible(elementsTitle, 500);
      expect(elementsTitle, findsOneWidget);

      final birdsTitle = find.text('Five Birds (Pakshi) / \u0B90\u0BA8\u0BCD\u0BA4\u0BC1 \u0BAA\u0BB1\u0BB5\u0BC8\u0B95\u0BB3\u0BCD (\u0BAA\u0B9F\u0BCD\u0B9A\u0BBF)');
      await tester.scrollUntilVisible(birdsTitle, 500);
      expect(birdsTitle, findsOneWidget);

      final nakshatraTitle = find.text('Nakshatras & Birds / \u0BA8\u0B9F\u0BCD\u0B9A\u0BA4\u0BCD\u0BA4\u0BBF\u0BB0\u0BAE\u0BCD & \u0BAA\u0BB1\u0BB5\u0BC8');
      await tester.scrollUntilVisible(nakshatraTitle, 500);
      expect(nakshatraTitle, findsOneWidget);

      // Verify at least one Table is rendered
      expect(find.byType(Table), findsWidgets);
    });

    testWidgets('renders all sections in pure Tamil in ta locale (RT)', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(testableGuideScreen(locale: const Locale('ta')));
      await tester.pumpAndSettle();

      expect(find.text('பயனர் வழிகாட்டி'), findsOneWidget);

      final expectedTamilTitles = [
        'சரநிதி என்றால் என்ன?',
        'பின்னணி அறிவியல்',
        'உங்கள் பிறப்பு பறவை',
        'தினசரி தாளம்',
        'பயன்பாட்டை எவ்வாறு பயன்படுத்துவது',
        'சிறந்த பயிற்சிகள்',
        'ஸ்வர பாத கமன (நிலமிடும் முதல் அடி)',
        'ஸ்வர ஆகாரம் (உணவு ஒத்திசைவு)',
        'டாஷ்போர்டை புரிந்துகொள்ளுதல்',
        'பிரசன்னம் ஆரக்கிள்',
        'நன்மைகள்',
        'அடிக்கடி கேட்கப்படும் கேள்விகள்',
      ];

      for (final title in expectedTamilTitles) {
        expect(
          find.text(title),
          findsOneWidget,
          reason: 'Expected Tamil section title "$title" to be present',
        );
      }

      // Assert Tamil Oracle section content present
      expect(
        find.textContaining('கீழ் வழிசெலுத்தலில் நான்காவது தாவலான ஆரக்கிள்'),
        findsOneWidget,
      );

      // Assert stale 'ஆராய்' tab removed
      expect(find.textContaining("'ஆராய்' தாவலை"), findsNothing);

      // Assert Tamil Practice Sync content present
      expect(
        find.textContaining('கே: பயிற்சி ஒத்திசைவு என்றால் என்ன?'),
        findsOneWidget,
      );

      // No English titles leaked
      expect(find.text('What is Saranidhi?'), findsNothing);
      expect(find.text('The Science Behind It'), findsNothing);
      expect(find.text('Your Birth Bird'), findsNothing);
      expect(find.text('Daily Rhythm'), findsNothing);
      expect(find.text('Prasanam Oracle'), findsNothing);
    });
  });
}
