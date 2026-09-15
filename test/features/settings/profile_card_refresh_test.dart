import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/settings/presentation/profile_card.dart';
import 'package:saranidhi/features/settings/providers/profile_providers.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('ProfileCard & profileProvider refresh (Sprint 45.2)', () {
    test(
      'profileProvider re-reads updated profile after invalidation',
      () async {
        final container = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);

        // 1. Initial state: empty database -> null profile
        final initialProfile = await container.read(profileProvider.future);
        expect(initialProfile, isNull);

        // 2. Insert initial profile
        await db
            .into(db.profiles)
            .insert(
              ProfilesCompanion.insert(
                id: 'prof-1',
                ownerId: const drift.Value('initial-owner-uuid-1111'),
                displayName: const drift.Value('Original Practitioner'),
                createdAt: 1710000000000,
                updatedAt: 1710000000000,
              ),
            );

        container.invalidate(profileProvider);
        final insertedProfile = await container.read(profileProvider.future);
        expect(insertedProfile, isNotNull);
        expect(insertedProfile!.ownerId, equals('initial-owner-uuid-1111'));
        expect(insertedProfile.displayName, equals('Original Practitioner'));

        // 3. Simulate Restore/Merge: update profile with new ownerId
        await (db.update(
          db.profiles,
        )..where((t) => t.id.equals('prof-1'))).write(
          const ProfilesCompanion(
            ownerId: drift.Value('adopted-practice-uuid-9999'),
            displayName: drift.Value('Adopted Practitioner'),
          ),
        );

        // 4. Invalidate profileProvider (as done in _invalidateAllDataProviders)
        container.invalidate(profileProvider);
        final updatedProfile = await container.read(profileProvider.future);
        expect(updatedProfile, isNotNull);
        expect(updatedProfile!.ownerId, equals('adopted-practice-uuid-9999'));
        expect(updatedProfile.displayName, equals('Adopted Practitioner'));
      },
    );

    testWidgets(
      'ProfileCard automatically refreshes Practice ID and name upon provider invalidation without page reload',
      (tester) async {
        // Insert initial profile
        await db
            .into(db.profiles)
            .insert(
              ProfilesCompanion.insert(
                id: 'prof-card-1',
                ownerId: const drift.Value('initial-practice-id-1234'),
                displayName: const drift.Value('Initial Name'),
                birthStarNakshatra: const drift.Value('Ashwini'),
                birthBird: const drift.Value('vulture'),
                createdAt: 1710000000000,
                updatedAt: 1710000000000,
              ),
            );

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
              home: Scaffold(body: SingleChildScrollView(child: ProfileCard())),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify initial ownerId and name are rendered
        expect(find.text('initial-practice-id-1234'), findsOneWidget);
        expect(find.text('Initial Name'), findsOneWidget);

        // Simulate a Merge or Restore that overwrites the profile in DB
        await (db.update(
          db.profiles,
        )..where((t) => t.id.equals('prof-card-1'))).write(
          const ProfilesCompanion(
            ownerId: drift.Value('restored-practice-id-8888'),
            displayName: drift.Value('Restored Name'),
          ),
        );

        // Invalidate profileProvider without rebuilding the screen widget tree
        container.invalidate(profileProvider);
        await tester.pumpAndSettle();

        // Verify that the ProfileCard refreshed to the new Practice ID and name
        expect(find.text('restored-practice-id-8888'), findsOneWidget);
        expect(find.text('Restored Name'), findsOneWidget);
        expect(find.text('initial-practice-id-1234'), findsNothing);
        expect(find.text('Initial Name'), findsNothing);
      },
    );
  });
}
