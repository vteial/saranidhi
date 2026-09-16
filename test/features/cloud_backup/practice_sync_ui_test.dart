import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/practice_sync_card.dart';
import 'package:saranidhi/features/cloud_backup/providers/practice_sync_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _createTestWidget({
  required Widget child,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('PracticeSyncCard — UI & Consent Gate Tests', () {
    testWidgets(
      'default state: toggle is OFF and consent notice is shown (zero network)',
      (tester) async {
        await tester.pumpWidget(
          _createTestWidget(child: const PracticeSyncCard()),
        );
        await tester.pumpAndSettle();

        // Card title & subtitle
        expect(find.text('Practice Sync'), findsOneWidget);
        expect(find.text('Enable Sync'), findsOneWidget);

        // Consent gate notice is visible while OFF
        expect(
          find.text(
            'When enabled, your practice data is stored in your personal account on your chosen backend.',
          ),
          findsOneWidget,
        );

        // Detailed sync controls are hidden while disabled
        expect(find.text('Breath Sessions'), findsNothing);
        expect(find.text('Breath Journal'), findsNothing);
        expect(find.text('Sync Now'), findsNothing);
      },
    );

    testWidgets(
      'when enabled: account row, scope checkboxes, and Sync Now button appear',
      (tester) async {
        SharedPreferences.setMockInitialValues({'sync_enabled': true});

        await tester.pumpWidget(
          _createTestWidget(child: const PracticeSyncCard()),
        );
        await tester.pumpAndSettle();

        // Master switch is ON
        final switchFinder = find.byType(Switch);
        expect(switchFinder, findsOneWidget);
        final switchWidget = tester.widget<Switch>(switchFinder);
        expect(switchWidget.value, isTrue);

        // Account row
        expect(find.text('Not signed in'), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);

        // Scope checkboxes (both present and checked by default)
        expect(find.text('Breath Sessions'), findsOneWidget);
        expect(find.text('Breath Journal'), findsOneWidget);
        expect(
          find.text('Journal drives your streak & hold-time stats.'),
          findsOneWidget,
        );

        // Sync Now button and quiet status
        expect(find.text('Sync Now'), findsOneWidget);
        expect(find.text('Not yet synced'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping Sign In opens dialog with email, passphrase, and server URL fields',
      (tester) async {
        SharedPreferences.setMockInitialValues({'sync_enabled': true});

        await tester.pumpWidget(
          _createTestWidget(child: const PracticeSyncCard()),
        );
        await tester.pumpAndSettle();

        // Tap Sign In button
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        // Dialog is displayed
        expect(find.text('Sign in to Practice Sync'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Passphrase'), findsOneWidget);
        expect(find.text('Server URL'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        // Tap Cancel to dismiss
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Sign in to Practice Sync'), findsNothing);
      },
    );

    testWidgets('Tamil localization renders pure Tamil copy correctly', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'sync_enabled': true});

      await tester.pumpWidget(
        _createTestWidget(
          child: const PracticeSyncCard(),
          locale: const Locale('ta'),
        ),
      );
      await tester.pumpAndSettle();

      // Card title & toggle in Tamil
      expect(find.text('பயிற்சி ஒத்திசைவு'), findsOneWidget);
      expect(find.text('ஒத்திசைவை இயக்கு'), findsOneWidget);

      // Account & scopes in Tamil
      expect(find.text('உள்நுழையவில்லை'), findsOneWidget);
      expect(find.text('உள்நுழைக'), findsOneWidget);
      expect(find.text('மூச்சு அமர்வுகள்'), findsOneWidget);
      expect(find.text('மூச்சுக் குறிப்பேடு'), findsOneWidget);
      expect(find.text('இப்போது ஒத்திசை'), findsOneWidget);
      expect(find.text('இன்னும் ஒத்திசைக்கப்படவில்லை'), findsOneWidget);
    });
  });
}
