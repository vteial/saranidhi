import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/database/database_provider.dart';
import 'package:saranidhi/features/cloud_backup/domain/backup_repository.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_transport.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/practice_sync_auto_trigger.dart';
import 'package:saranidhi/features/cloud_backup/presentation/widgets/sync_on_open_widget.dart';
import 'package:saranidhi/features/cloud_backup/providers/backup_providers.dart';
import 'package:saranidhi/features/cloud_backup/providers/practice_sync_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSyncTransport implements SyncTransport {
  _FakeSyncTransport({
    this.configured = true,
    this.authenticated = true,
    this.userId = 'pb_user_test_1',
    this.shouldThrow = false,
  });

  bool configured;
  bool authenticated;
  String? userId;
  bool shouldThrow;

  int pullCount = 0;
  int pushCount = 0;
  int signInCount = 0;
  int signOutCount = 0;

  @override
  bool get isConfigured => configured;

  @override
  bool get isAuthenticated => authenticated;

  @override
  String? get authUserId => userId;

  @override
  Future<void> signIn({
    required String email,
    required String passphrase,
  }) async {
    signInCount++;
    authenticated = true;
  }

  @override
  Future<void> signOut() async {
    signOutCount++;
    authenticated = false;
  }

  @override
  Future<RemoteSyncData> pull({
    required String ownerId,
    required Set<SyncScope> scopes,
  }) async {
    pullCount++;
    if (shouldThrow) {
      throw Exception('Network unreachable (fake error)');
    }
    return const RemoteSyncData();
  }

  @override
  Future<void> push({
    required String ownerId,
    required RemoteSyncData local,
    required Set<SyncScope> scopes,
  }) async {
    pushCount++;
    if (shouldThrow) {
      throw Exception('Push failed (fake error)');
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late _FakeSyncTransport transport;

  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    transport = _FakeSyncTransport();

    // Seed local profile with Practice ID (ownerId)
    await db.into(db.profiles).insert(
          ProfilesCompanion.insert(
            id: 'test-profile-1',
            ownerId: const drift.Value('owner-uuid-auto-test'),
            displayName: const drift.Value('Practitioner'),
            createdAt: 1710000000000,
            updatedAt: 1710000000000,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildTestApp({
    required Widget child,
    List<Override> overrides = const [],
    Duration minInterval = kAutoSyncMinInterval,
    DateTime Function()? clock,
  }) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        practiceSyncTransportProvider.overrideWithValue(transport),
        ...overrides,
      ],
      child: MaterialApp(
        home: Scaffold(
          body: PracticeSyncAutoTrigger(
            minInterval: minInterval,
            clock: clock,
            child: child,
          ),
        ),
      ),
    );
  }

  group('PracticeSyncAutoTrigger — Gate Matrix Tests (R1.2, R2.4, R4.2, RS.1)', () {
    testWidgets(
      'G1: enabled=false, authed=false -> ZERO sync calls, ZERO transport traffic',
      (tester) async {
        transport.authenticated = false;

        await tester.pumpWidget(
          buildTestApp(
            child: const Text('App Content'),
          ),
        );
        await tester.pumpAndSettle();

        expect(transport.pullCount, equals(0));
        expect(transport.pushCount, equals(0));
        expect(transport.signInCount, equals(0));
        expect(find.text('App Content'), findsOneWidget);
      },
    );

    testWidgets(
      'G2: enabled=false, authed=true -> ZERO sync calls, ZERO transport traffic',
      (tester) async {
        transport.authenticated = true;

        await tester.pumpWidget(
          buildTestApp(
            child: const Text('App Content'),
          ),
        );
        await tester.pumpAndSettle();

        expect(transport.pullCount, equals(0));
        expect(transport.pushCount, equals(0));
        expect(transport.signInCount, equals(0));
      },
    );

    testWidgets(
      'G3: enabled=true, authed=false -> ZERO sync calls, ZERO transport traffic',
      (tester) async {
        transport.authenticated = false;

        // Config enabled = true, but not authenticated
        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(transport.pullCount, equals(0));
        expect(transport.pushCount, equals(0));
        expect(transport.signInCount, equals(0));
      },
    );

    testWidgets(
      'G4: enabled=true, authed=true, isSyncing=true -> in-flight guard prevents duplicate trigger',
      (tester) async {
        transport.authenticated = true;

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        // Artificially mark isSyncing = true
        container.read(practiceSyncNotifierProvider.notifier).state =
            container.read(practiceSyncNotifierProvider).copyWith(isSyncing: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(transport.pullCount, equals(0));
        expect(transport.pushCount, equals(0));
      },
    );

    testWidgets(
      'G5: enabled=true, authed=true, isSyncing=false -> auto-sync triggers on app open without user tap',
      (tester) async {
        transport.authenticated = true;

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Exactly 1 auto-sync cycle executed
        expect(transport.pullCount, equals(1));
        expect(transport.pushCount, equals(1));
        expect(find.text('App Content'), findsOneWidget);

        // State reflects successful sync
        final outcome =
            container.read(practiceSyncNotifierProvider).lastOutcome;
        expect(outcome, isNotNull);
        expect(outcome!.isSuccess, isTrue);
      },
    );
  });

  group('PracticeSyncAutoTrigger — Debounce & Lifecycle Tests (R2.1, R2.2, R2.3)', () {
    testWidgets(
      'rebuild / re-pump within same session does NOT trigger a second sync',
      (tester) async {
        transport.authenticated = true;

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('Session 1'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(transport.pullCount, equals(1));

        // Rebuild the tree with different content/theme in same session
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('Session 1 Rebuilt'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Still only 1 sync call
        expect(transport.pullCount, equals(1));
        expect(transport.pushCount, equals(1));
      },
    );

    testWidgets(
      'cold open within 5-min debounce window does NOT auto-sync',
      (tester) async {
        transport.authenticated = true;
        final now = DateTime(2026, 10, 22, 12, 0);

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);
        // Last synced 2 minutes ago
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setLastSynced(now.subtract(const Duration(minutes: 2)));

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                clock: () => now,
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Debounced: zero calls
        expect(transport.pullCount, equals(0));
        expect(transport.pushCount, equals(0));
      },
    );

    testWidgets(
      'cold open after 5-min debounce window DOES auto-sync',
      (tester) async {
        transport.authenticated = true;
        final now = DateTime(2026, 10, 22, 12, 10);

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);
        // Last synced 6 minutes ago
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setLastSynced(now.subtract(const Duration(minutes: 6)));

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                clock: () => now,
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Fired because > 5 minutes
        expect(transport.pullCount, equals(1));
        expect(transport.pushCount, equals(1));
      },
    );

    testWidgets(
      'app resume within 5-min debounce window does NOT auto-sync',
      (tester) async {
        transport.authenticated = true;
        var currentTime = DateTime.now();

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                clock: () => currentTime,
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(transport.pullCount, equals(1));

        // Advance clock by only 2 minutes and trigger app resume
        currentTime = currentTime.add(const Duration(minutes: 2));
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pumpAndSettle();

        // Still only 1 sync call
        expect(transport.pullCount, equals(1));
      },
    );

    testWidgets(
      'app resume after 5-min debounce window DOES auto-sync',
      (tester) async {
        transport.authenticated = true;
        var currentTime = DateTime.now();

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                clock: () => currentTime,
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(transport.pullCount, equals(1));

        // Advance clock by 6 minutes and trigger app resume
        currentTime = currentTime.add(const Duration(minutes: 6));
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pumpAndSettle();

        // A second sync fired!
        expect(transport.pullCount, equals(2));
        expect(transport.pushCount, equals(2));
      },
    );

    testWidgets(
      'manual Sync Now resets debounce window',
      (tester) async {
        transport.authenticated = true;
        var currentTime = DateTime.now();

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                clock: () => currentTime,
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(transport.pullCount, equals(1));

        // Advance 4 minutes (still within window)
        currentTime = currentTime.add(const Duration(minutes: 4));

        // User manually taps "Sync now"
        await container.read(practiceSyncNotifierProvider.notifier).syncNow();
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setLastSynced(currentTime);
        expect(transport.pullCount, equals(2));

        // Advance 2 more minutes from manual sync (6 min from start, but only 2 min from manual sync)
        currentTime = currentTime.add(const Duration(minutes: 2));
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pumpAndSettle();

        // Debounced by manual sync! No third sync call
        expect(transport.pullCount, equals(2));
      },
    );
  });

  group('PracticeSyncAutoTrigger — Silent Failure & Error Containment (R3.1, R3.2)', () {
    testWidgets(
      'transport exception fails silently without crashing or blocking startup',
      (tester) async {
        transport.authenticated = true;
        transport.shouldThrow = true; // Simulates offline / network unreachable

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        // App launches and mounts trigger
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('App Runs Fine Offline'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // UI is intact and visible
        expect(find.text('App Runs Fine Offline'), findsOneWidget);

        // Sync state passively recorded error without breaking the app
        final state = container.read(practiceSyncNotifierProvider);
        expect(state.isSyncing, isFalse);
        expect(state.errorMessage, contains('fake error'));
      },
    );
  });

  group('PracticeSyncAutoTrigger — Security & Scope Invariants (RS.1)', () {
    testWidgets(
      'default-OFF: initial config is disabled, zero transport interactions',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(practiceSyncConfigProvider).enabled,
          isFalse,
          reason: 'Master opt-in must be default false',
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('Fresh Install'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(transport.pullCount, equals(0));
        expect(transport.pushCount, equals(0));
        expect(transport.signInCount, equals(0));
      },
    );

    testWidgets(
      'trigger never calls signIn (no auto sign-in guarantee)',
      (tester) async {
        transport.authenticated = true;

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(transport.signInCount, equals(0));
      },
    );

    testWidgets(
      'toggling sync OFF stops all future auto-open and resume syncs',
      (tester) async {
        transport.authenticated = true;
        var currentTime = DateTime.now();

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: true);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: PracticeSyncAutoTrigger(
                clock: () => currentTime,
                child: const Text('App Content'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(transport.pullCount, equals(1));

        // User turns sync OFF in Settings
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setEnabled(enabled: false);

        // Resume after 10 minutes
        currentTime = currentTime.add(const Duration(minutes: 10));
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pumpAndSettle();

        // No new sync calls because sync is OFF
        expect(transport.pullCount, equals(1));
        expect(transport.pushCount, equals(1));
      },
    );
  });

  group('PracticeSyncAutoTrigger — iCloud & Regression Independence (RQ.3)', () {
    testWidgets(
      'SyncOnOpenWidget and PracticeSyncAutoTrigger can be nested without conflict',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            practiceSyncTransportProvider.overrideWithValue(transport),
            storageModeProvider.overrideWith(
              () => _StorageModeFixedNotifier(StorageMode.local),
            ),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: SyncOnOpenWidget(
                child: PracticeSyncAutoTrigger(
                  child: Text('Nested Shell'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Nested Shell'), findsOneWidget);
        expect(transport.pullCount, equals(0));
      },
    );
  });
}

class _StorageModeFixedNotifier extends StorageModeNotifier {
  _StorageModeFixedNotifier(this.initialMode);
  final StorageMode initialMode;

  @override
  StorageMode build() => initialMode;
}
