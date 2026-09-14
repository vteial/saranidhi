import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/settings/presentation/about_card.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('AboutCard Localization', () {
    testWidgets('renders English Developer name and copyright in en locale', (
      tester,
    ) async {
      await tester.pumpWidget(
        testableWidget(
          const AboutCard(),
          locale: const Locale('en'),
          overrides: [
            appVersionProvider.overrideWith((ref) => Future.value('1.11.1')),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Developer row
      expect(find.text('Developer'), findsOneWidget);
      expect(find.text('Eialarasu'), findsOneWidget);

      // Copyright line
      expect(
        find.text('© 2026 Eialarasu. All rights reserved.'),
        findsOneWidget,
      );

      // No Tamil text leaked
      expect(find.text('உருவாக்குநர்'), findsNothing);
      expect(find.text('இயலரசு'), findsNothing);
    });

    testWidgets(
      'renders Tamil Developer name matching copyright in ta locale',
      (tester) async {
        await tester.pumpWidget(
          testableWidget(
            const AboutCard(),
            locale: const Locale('ta'),
            overrides: [
              appVersionProvider.overrideWith((ref) => Future.value('1.11.1')),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Developer row in Tamil
        expect(find.text('உருவாக்குநர்'), findsOneWidget);
        expect(find.text('இயலரசு'), findsOneWidget);

        // Copyright line in Tamil
        expect(
          find.text('© 2026 இயலரசு. அனைத்து உரிமைகளும் பாதுகாக்கப்பட்டவை.'),
          findsOneWidget,
        );

        // Name must NOT appear as Latin Eialarasu anywhere in Tamil mode
        expect(find.text('Eialarasu'), findsNothing);
        expect(find.text('Developer'), findsNothing);
      },
    );
  });
}
