import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/cloud_backup/domain/practice_sync_engine.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_transport.dart';
import 'package:saranidhi/features/settings/domain/owner_identity_service.dart';

class FakeSyncTransport implements SyncTransport {
  FakeSyncTransport({
    this.configured = true,
    this.authenticated = true,
    this.remoteData = const RemoteSyncData(),
    this.throwOnPull = false,
    this.throwOnPush = false,
  });

  bool configured;
  bool authenticated;
  RemoteSyncData remoteData;
  bool throwOnPull;
  bool throwOnPush;

  RemoteSyncData? lastPushed;
  String? lastPushedOwnerId;
  Set<SyncScope>? lastPushedScopes;
  Set<SyncScope>? lastPulledScopes;

  @override
  bool get isConfigured => configured;

  @override
  bool get isAuthenticated => authenticated;

  @override
  Future<void> signIn({
    required String email,
    required String passphrase,
  }) async {
    authenticated = true;
  }

  @override
  Future<void> signOut() async {
    authenticated = false;
  }

  @override
  Future<RemoteSyncData> pull({
    required String ownerId,
    required Set<SyncScope> scopes,
  }) async {
    if (throwOnPull) throw Exception('Network connection timed out');
    lastPulledScopes = scopes;
    return remoteData;
  }

  @override
  Future<void> push({
    required String ownerId,
    required RemoteSyncData local,
    required Set<SyncScope> scopes,
  }) async {
    if (throwOnPush) throw Exception('Server 500 Internal Error');
    lastPushed = local;
    lastPushedOwnerId = ownerId;
    lastPushedScopes = scopes;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase db;
  late OwnerIdentityService ownerService;
  const ownerId = 'practice-owner-uuid-1';

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    ownerService = OwnerIdentityService(db);

    // Seed profile with stable ownerId
    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: 'profile-1',
            ownerId: const drift.Value(ownerId),
            displayName: const drift.Value('Test Practitioner'),
            createdAt: 1710000000000,
            updatedAt: 1710000000000,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('PracticeSyncEngine — On-Demand Sync Cycle', () {
    test(
      'pulls remote records, merges into local DB, and pushes local records',
      () async {
        final remoteSessions = [
          {
            'id': 'remote-sess-1',
            'uuid': 'remote-sess-1',
            'ownerId': ownerId,
            'timestamp': 1710000001000,
            'totalDurationMs': 60000,
            'nostril': 'right',
            'inhaleLengthMs': 4000,
            'holdAfterInhaleMs': 8000,
            'exhaleLengthMs': 4000,
            'holdAfterExhaleMs': 0,
            'completedCycles': 4,
          },
        ];

        final remoteJournal = [
          {
            'id': 'remote-jour-1',
            'uuid': 'remote-jour-1',
            'ownerId': ownerId,
            'timestamp': 1710000002000,
            'expectedFlow': 'right',
            'actualFlow': 'right',
            'isAligned': true,
            'nostril': 'right',
          },
        ];

        final transport = FakeSyncTransport(
          remoteData: RemoteSyncData(
            sessions: remoteSessions,
            journal: remoteJournal,
          ),
        );

        final engine = PracticeSyncEngine(
          db: db,
          transport: transport,
          ownerIdentityService: ownerService,
        );

        final outcome = await engine.performSync();

        expect(outcome.isSuccess, isTrue);
        expect(outcome.pulledInserted, equals(2));
        expect(outcome.syncedAt, isNotNull);

        // Verify local DB mutations
        final localSessions = await db.select(db.breathSessions).get();
        final localJournal = await db.select(db.saraKalaiJournal).get();
        expect(localSessions.length, equals(1));
        expect(localSessions.first.id, equals('remote-sess-1'));
        expect(localJournal.length, equals(1));
        expect(localJournal.first.id, equals('remote-jour-1'));

        // Verify transport push received the merged local records
        expect(transport.lastPushed, isNotNull);
        expect(transport.lastPushed!.sessions.length, equals(1));
        expect(transport.lastPushed!.journal.length, equals(1));
        expect(transport.lastPushedOwnerId, equals(ownerId));
      },
    );

    test(
      'is 100% idempotent: second immediate sync inserts 0 new records',
      () async {
        final remoteSessions = [
          {
            'id': 'remote-sess-idempotent',
            'uuid': 'remote-sess-idempotent',
            'ownerId': ownerId,
            'timestamp': 1710000001000,
            'totalDurationMs': 60000,
            'nostril': 'left',
            'inhaleLengthMs': 4000,
            'holdAfterInhaleMs': 8000,
            'exhaleLengthMs': 4000,
            'holdAfterExhaleMs': 0,
            'completedCycles': 4,
          },
        ];

        final transport = FakeSyncTransport(
          remoteData: RemoteSyncData(sessions: remoteSessions),
        );

        final engine = PracticeSyncEngine(
          db: db,
          transport: transport,
          ownerIdentityService: ownerService,
        );

        final outcome1 = await engine.performSync();
        expect(outcome1.pulledInserted, equals(1));

        // Second immediate sync run
        final outcome2 = await engine.performSync();
        expect(outcome2.isSuccess, isTrue);
        expect(
          outcome2.pulledInserted,
          equals(0),
        ); // 0 duplicate records inserted!

        final sessions = await db.select(db.breathSessions).get();
        expect(sessions.length, equals(1));
      },
    );

    test(
      'owner guard on pull: foreign ownerId aborts sync with zero local mutations',
      () async {
        const foreignOwnerId = 'foreign-practice-uuid-999';

        final foreignRemoteData = RemoteSyncData(
          sessions: [
            {
              'id': 'foreign-sess-1',
              'uuid': 'foreign-sess-1',
              'ownerId': foreignOwnerId, // Foreign Practice ID!
              'timestamp': 1710000001000,
              'totalDurationMs': 60000,
              'nostril': 'right',
              'inhaleLengthMs': 4000,
              'holdAfterInhaleMs': 8000,
              'exhaleLengthMs': 4000,
              'holdAfterExhaleMs': 0,
              'completedCycles': 4,
            },
          ],
        );

        final transport = FakeSyncTransport(remoteData: foreignRemoteData);
        final engine = PracticeSyncEngine(
          db: db,
          transport: transport,
          ownerIdentityService: ownerService,
        );

        final outcome = await engine.performSync();

        expect(outcome.isSuccess, isFalse);
        expect(outcome.error, contains('Owner guard check failed'));
        expect(outcome.error, contains(foreignOwnerId));

        // Ensure zero local database mutations occurred
        final sessions = await db.select(db.breathSessions).get();
        expect(sessions, isEmpty);
      },
    );

    test('scope checkboxes restrict sync to selected tables', () async {
      final remoteSessions = [
        {
          'id': 'sess-scoped-1',
          'uuid': 'sess-scoped-1',
          'ownerId': ownerId,
          'timestamp': 1710000001000,
          'totalDurationMs': 60000,
          'nostril': 'right',
          'inhaleLengthMs': 4000,
          'holdAfterInhaleMs': 8000,
          'exhaleLengthMs': 4000,
          'holdAfterExhaleMs': 0,
          'completedCycles': 4,
        },
      ];
      final remoteJournal = [
        {
          'id': 'jour-scoped-1',
          'uuid': 'jour-scoped-1',
          'ownerId': ownerId,
          'timestamp': 1710000002000,
          'expectedFlow': 'right',
          'actualFlow': 'right',
          'isAligned': true,
          'nostril': 'right',
        },
      ];

      final transport = FakeSyncTransport(
        remoteData: RemoteSyncData(
          sessions: remoteSessions,
          journal: remoteJournal,
        ),
      );

      final engine = PracticeSyncEngine(
        db: db,
        transport: transport,
        ownerIdentityService: ownerService,
      );

      // Sync journal ONLY
      final outcome = await engine.performSync(scopes: {SyncScope.journal});

      expect(outcome.isSuccess, isTrue);
      expect(outcome.pulledInserted, equals(1)); // Only journal inserted
      expect(transport.lastPulledScopes, equals({SyncScope.journal}));

      final sessions = await db.select(db.breathSessions).get();
      final journal = await db.select(db.saraKalaiJournal).get();
      expect(sessions, isEmpty);
      expect(journal.length, equals(1));
    });

    test(
      'offline resilience: transport error is quietly caught without crashing or data loss',
      () async {
        final transport = FakeSyncTransport(throwOnPull: true);
        final engine = PracticeSyncEngine(
          db: db,
          transport: transport,
          ownerIdentityService: ownerService,
        );

        final outcome = await engine.performSync();

        expect(outcome.isSuccess, isFalse);
        expect(outcome.error, contains('Network connection timed out'));

        // Local DB is untouched
        final sessions = await db.select(db.breathSessions).get();
        expect(sessions, isEmpty);
      },
    );

    test(
      'unauthenticated transport surfaces clean sign-in prompt error',
      () async {
        final transport = FakeSyncTransport(authenticated: false);
        final engine = PracticeSyncEngine(
          db: db,
          transport: transport,
          ownerIdentityService: ownerService,
        );

        final outcome = await engine.performSync();

        expect(outcome.isSuccess, isFalse);
        expect(outcome.error, contains('Please sign in'));
      },
    );
  });
}
