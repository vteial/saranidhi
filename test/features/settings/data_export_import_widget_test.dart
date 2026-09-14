import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/analytics/providers/analytics_providers.dart';
import 'package:saranidhi/features/settings/presentation/data_export_import_widget.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import '../../helpers/widget_test_helpers.dart';

class MockSharePlatform extends SharePlatform {
  List<XFile>? sharedFiles;
  String? sharedSubject;
  List<String>? sharedFileNames;

  @override
  Future<ShareResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
    List<String>? fileNameOverrides,
  }) async {
    sharedFiles = files;
    sharedSubject = subject;
    sharedFileNames = fileNameOverrides;
    return const ShareResult('success', ShareResultStatus.success);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSharePlatform mockShare;

  setUp(() {
    mockShare = MockSharePlatform();
    SharePlatform.instance = mockShare;
  });

  group('DataExportImportWidget', () {
    testWidgets(
      'renders JSON export, import, and CSV export buttons in English',
      (tester) async {
        await tester.pumpWidget(
          testableWidget(
            const DataExportImportWidget(),
            overrides: [
              csvExportProvider.overrideWith((ref) async => 'Date,Time...'),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Data Export / Import'), findsOneWidget);
        expect(find.text('Export All Data'), findsOneWidget);
        expect(find.text('Merge from file'), findsOneWidget);
        expect(find.text('Restore (overwrite everything)'), findsOneWidget);
        expect(find.text('Export journal as CSV'), findsOneWidget);
        expect(find.byIcon(Icons.table_chart_outlined), findsOneWidget);
      },
    );

    testWidgets('renders all buttons in Tamil locale', (tester) async {
      await tester.pumpWidget(
        testableWidget(
          const DataExportImportWidget(),
          locale: const Locale('ta'),
          overrides: [
            csvExportProvider.overrideWith((ref) async => 'Date,Time...'),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('தரவு ஏற்றுமதி / இறக்குமதி'), findsOneWidget);
      expect(find.text('அனைத்து தரவையும் ஏற்றுமதி செய்'), findsOneWidget);
      expect(find.text('கோப்பிலிருந்து இணை'), findsOneWidget);
      expect(find.text('மீட்டமை (அனைத்தையும் மேலெழுது)'), findsOneWidget);
      expect(find.text('நாட்குறிப்பை CSV ஆக ஏற்றுமதி செய்க'), findsOneWidget);
    });

    testWidgets('tapping CSV button triggers export and share_plus', (
      tester,
    ) async {
      const mockCsvContent = 'Date,Time,Expected Flow\n2026-09-13,10:00,solar';

      await tester.pumpWidget(
        testableWidget(
          const DataExportImportWidget(),
          overrides: [
            csvExportProvider.overrideWith((ref) async => mockCsvContent),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final csvButton = find.text('Export journal as CSV');
      expect(csvButton, findsOneWidget);

      await tester.tap(csvButton);
      await tester.pumpAndSettle();

      expect(mockShare.sharedFiles, isNotNull);
      expect(mockShare.sharedFiles!.length, equals(1));
      final file = mockShare.sharedFiles!.first;
      expect(file.mimeType, equals('text/csv'));
      expect(mockShare.sharedSubject, equals('Saranidhi Journal CSV Export'));

      final content = await file.readAsString();
      expect(content, equals(mockCsvContent));

      // Success snackbar shown
      expect(find.text('Data exported successfully'), findsOneWidget);
    });
  });
}
