import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/router/onboarding_guard.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';
import 'package:saranidhi/features/onboarding/presentation/intro_screen.dart';
import 'package:saranidhi/features/onboarding/providers/onboarding_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFilePicker extends FilePicker {
  FilePickerResult? resultToReturn;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    dynamic onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    return resultToReturn;
  }

  @override
  Future<bool?> clearTemporaryFiles() async => true;

  @override
  Future<String?> getDirectoryPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) async => null;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late MockFilePicker mockPicker;

  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    mockPicker = MockFilePicker();
    FilePicker.platform = mockPicker;
  });

  tearDown(() async {
    await db.close();
  });

  group('IntroScreen — Import link and Onboarding adoption (Sprint 45.1)', () {
    testWidgets('renders Get Started button and Import link in English', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: IntroScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
      expect(
        find.text('Already using Saranidhi on another device? Import'),
        findsOneWidget,
      );
    });

    testWidgets('renders Get Started button and Import link in Tamil', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ta'),
            home: IntroScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('தொடங்கு'), findsOneWidget);
      expect(
        find.text(
          'மற்றொரு சாதனத்தில் ஏற்கனவே சரணிதி பயன்படுத்துகிறீர்களா? இறக்குமதி செய்யவும்',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'tapping Get Started sets introSeenProvider to true (happy path unaffected)',
      (tester) async {
        final container = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: IntroScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(container.read(introSeenProvider), isFalse);

        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();

        expect(container.read(introSeenProvider), isTrue);
      },
    );

    testWidgets(
      'tapping Import link with valid empty-local backup runs merge, adopts ownerId, and flips onboardingCompleteProvider',
      (tester) async {
        const remoteOwnerId = 'device-source-practice-uuid-12345';
        final backupData = {
          'version': 2,
          'schemaVersion': 7,
          'ownerId': remoteOwnerId,
          'profiles': [
            {
              'id': 'remote-prof-1',
              'ownerId': remoteOwnerId,
              'displayName': 'Source Device Practitioner',
              'birthStarNakshatra': 'Rohini',
              'birthBird': 'owl',
              'locationLat': 13.0827,
              'locationLng': 80.2707,
              'createdAt': 1710000000000,
              'updatedAt': 1710000000000,
            },
          ],
          'journal': [],
          'sessions': [],
          'birds': [],
          'prasanam': [],
          'somatic': [],
          'preferences': {
            'theme_accent': 'saffron',
            'app_locale': 'en',
            'onboarding_complete': true,
          },
        };
        final backupBytes = Uint8List.fromList(
          utf8.encode(jsonEncode(backupData)),
        );

        mockPicker.resultToReturn = FilePickerResult([
          PlatformFile(
            name: 'saranidhi_backup_device-s_2026-09-15-1000.json',
            size: backupBytes.length,
            bytes: backupBytes,
          ),
        ]);

        final container = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(body: IntroScreen()),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initial state: onboarding not complete, no local profile
        expect(container.read(onboardingCompleteProvider), isFalse);
        final initialProfiles = await db.select(db.profiles).get();
        expect(initialProfiles, isEmpty);

        // Tap the import link
        final importButton = find.text(
          'Already using Saranidhi on another device? Import',
        );
        expect(importButton, findsOneWidget);
        await tester.tap(importButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Confirmation dialog appears with "Merge Practice Data?" title and "New device: adopting Practice ID" status
        expect(find.text('Merge Practice Data?'), findsOneWidget);
        expect(find.text('New device: adopting Practice ID'), findsOneWidget);

        // Confirm merge
        final mergeConfirmBtn = find.widgetWithText(FilledButton, 'Merge');
        expect(mergeConfirmBtn, findsOneWidget);
        await tester.tap(mergeConfirmBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // Database now has the adopted profile with the source device's Practice ID
        final localProfiles = await db.select(db.profiles).get();
        expect(localProfiles, isNotEmpty);
        expect(localProfiles.first.ownerId, equals(remoteOwnerId));
        expect(
          localProfiles.first.displayName,
          equals('Source Device Practitioner'),
        );

        // onboardingCompleteProvider is flipped to true!
        expect(container.read(onboardingCompleteProvider), isTrue);

        // SnackBar feedback
        expect(find.textContaining('Merged'), findsOneWidget);
      },
    );
  });
}
