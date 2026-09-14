import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/core/utils/app_constants.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/analytics/domain/analytics_calculator.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase dbA;
  late AppDatabase dbB;
  late DatabaseExporter exporterA;
  late DatabaseExporter exporterB;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    dbA = AppDatabase(NativeDatabase.memory());
    dbB = AppDatabase(NativeDatabase.memory());
    exporterA = DatabaseExporter(dbA);
    exporterB = DatabaseExporter(dbB);
  });

  tearDown(() async {
    await dbA.close();
    await dbB.close();
  });

  group('DatabaseExporter — Export & Validation', () {
    test(
      'exportToBytes stamps ownerId, version: 2, and schemaVersion: 7',
      () async {
        await dbA
            .into(dbA.profiles)
            .insert(
              ProfilesCompanion.insert(
                id: 'prof-1',
                ownerId: const drift.Value('owner-practice-uuid-1'),
                displayName: const drift.Value('Practitioner 1'),
                createdAt: 1710000000000,
                updatedAt: 1710000000000,
              ),
            );

        await dbA
            .into(dbA.somaticInterventionLogs)
            .insert(
              SomaticInterventionLogsCompanion.insert(
                id: 'somatic-1',
                timestamp: 1710000001000,
                protocolType: 'postureShift',
                targetFlow: 'right',
                initialFlow: 'left',
                durationSeconds: 180,
                isSuccess: const drift.Value(true),
              ),
            );

        final bytes = await exporterA.exportToBytes();
        expect(bytes, isNotEmpty);

        final jsonStr = utf8.decode(bytes);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;

        expect(data['version'], equals(AppConstants.exportVersion)); // 2
        expect(data['version'], equals(2));
        expect(data['schemaVersion'], equals(AppConstants.schemaVersion)); // 7
        expect(data['schemaVersion'], equals(7));
        expect(data['ownerId'], equals('owner-practice-uuid-1'));

        final profiles = data['profiles'] as List;
        expect(profiles.length, equals(1));
        expect(
          (profiles.first as Map)['ownerId'],
          equals('owner-practice-uuid-1'),
        );

        final somatic = data['somatic'] as List;
        expect(somatic.length, equals(1));
        expect((somatic.first as Map)['id'], equals('somatic-1'));
      },
    );

    test(
      'validateExportData accepts valid v1 and v2 files up to current schema',
      () async {
        final validV2 = Uint8List.fromList(
          utf8.encode(
            jsonEncode({
              'version': 2,
              'schemaVersion': 7,
              'profiles': [],
              'journal': [],
              'sessions': [],
              'birds': [],
            }),
          ),
        );
        expect(DatabaseExporter.validateExportData(validV2), isNull);

        final validV1 = Uint8List.fromList(
          utf8.encode(
            jsonEncode({
              'version': 1,
              'schemaVersion': 6,
              'profiles': [],
              'journal': [],
              'sessions': [],
              'birds': [],
            }),
          ),
        );
        expect(DatabaseExporter.validateExportData(validV1), isNull);

        // Rejects newer version > 2
        final newerVersion = Uint8List.fromList(
          utf8.encode(
            jsonEncode({
              'version': 3,
              'schemaVersion': 7,
              'profiles': [],
              'journal': [],
              'sessions': [],
              'birds': [],
            }),
          ),
        );
        expect(
          DatabaseExporter.validateExportData(newerVersion),
          contains('Unsupported version'),
        );

        // Rejects newer schema > 7
        final newerSchema = Uint8List.fromList(
          utf8.encode(
            jsonEncode({
              'version': 2,
              'schemaVersion': 8,
              'profiles': [],
              'journal': [],
              'sessions': [],
              'birds': [],
            }),
          ),
        );
        expect(
          DatabaseExporter.validateExportData(newerSchema),
          contains('newer app version'),
        );
      },
    );

    test('summarizeExportData reports counts and ownerId', () async {
      final bytes = Uint8List.fromList(
        utf8.encode(
          jsonEncode({
            'version': 2,
            'schemaVersion': 7,
            'ownerId': 'owner-sum-1',
            'exportedAt': '2026-09-14T10:00:00Z',
            'profiles': [
              {'id': 'p1'},
            ],
            'journal': [
              {'id': 'j1'},
              {'id': 'j2'},
            ],
            'sessions': [
              {'id': 's1'},
            ],
            'birds': [],
            'prasanam': [
              {'id': 'pr1'},
            ],
            'somatic': [
              {'id': 'sm1'},
            ],
          }),
        ),
      );

      final summary = DatabaseExporter.summarizeExportData(bytes);
      expect(summary['profiles'], equals(1));
      expect(summary['journal'], equals(2));
      expect(summary['sessions'], equals(1));
      expect(summary['prasanam'], equals(1));
      expect(summary['somatic'], equals(1));
      expect(summary['ownerId'], equals('owner-sum-1'));
    });
  });

  group('DatabaseExporter — Owner Guard', () {
    const ownerId1 = 'shared-owner-uuid-1';
    const ownerId2 = 'different-owner-uuid-2';

    setUp(() async {
      await dbA
          .into(dbA.profiles)
          .insert(
            ProfilesCompanion.insert(
              id: 'prof-a',
              ownerId: const drift.Value(ownerId1),
              displayName: const drift.Value('Owner A'),
              createdAt: 1710000000000,
              updatedAt: 1710000000000,
            ),
          );
    });

    test('match allows merge silently', () async {
      final matchingData = {
        'version': 2,
        'schemaVersion': 7,
        'ownerId': ownerId1,
        'profiles': [
          {'id': 'prof-b', 'ownerId': ownerId1},
        ],
        'journal': [],
        'sessions': [],
        'birds': [],
      };

      final check = await exporterA.checkOwnerGuard(matchingData);
      expect(check.status, equals(OwnerGuardStatus.match));
      expect(check.isMatch, isTrue);
    });

    test('mismatch REFUSES merge and makes 0 DB mutations', () async {
      // Seed journal in DB-A
      await dbA
          .into(dbA.saraKalaiJournal)
          .insert(
            SaraKalaiJournalCompanion.insert(
              id: 'j-local-1',
              timestamp: 1710000000000,
              expectedFlow: 'solar',
              actualFlow: 'solar',
              isAligned: true,
              nostril: 'right',
            ),
          );

      final mismatchBytes = Uint8List.fromList(
        utf8.encode(
          jsonEncode({
            'version': 2,
            'schemaVersion': 7,
            'ownerId': ownerId2,
            'profiles': [
              {'id': 'prof-mismatch', 'ownerId': ownerId2},
            ],
            'journal': [
              {
                'id': 'j-incoming-danger',
                'timestamp': 1710000001000,
                'expectedFlow': 'lunar',
                'actualFlow': 'lunar',
                'isAligned': true,
                'nostril': 'left',
              },
            ],
            'sessions': [],
            'birds': [],
          }),
        ),
      );

      final check = await exporterA.checkOwnerGuard(
        jsonDecode(utf8.decode(mismatchBytes)),
      );
      expect(check.status, equals(OwnerGuardStatus.mismatch));
      expect(check.isMismatch, isTrue);

      // Attempting mergeFromBytes throws OwnerMismatchException
      expect(
        () => exporterA.mergeFromBytes(mismatchBytes),
        throwsA(isA<OwnerMismatchException>()),
      );

      // Verify ZERO database mutations in DB-A
      final journalRows = await dbA.select(dbA.saraKalaiJournal).get();
      expect(journalRows.length, equals(1));
      expect(journalRows.first.id, equals('j-local-1'));
    });

    test('empty local profile adopts imported profile and ownerId', () async {
      // dbB has no profile
      final emptyCheck = await exporterB.checkOwnerGuard({
        'version': 2,
        'schemaVersion': 7,
        'ownerId': ownerId1,
        'profiles': [
          {
            'id': 'prof-new',
            'ownerId': ownerId1,
            'displayName': 'Adopting User',
            'createdAt': 1710000000000,
            'updatedAt': 1710000000000,
          },
        ],
      });
      expect(emptyCheck.status, equals(OwnerGuardStatus.emptyLocal));
      expect(emptyCheck.isEmptyLocal, isTrue);

      final importBytes = Uint8List.fromList(
        utf8.encode(
          jsonEncode({
            'version': 2,
            'schemaVersion': 7,
            'ownerId': ownerId1,
            'profiles': [
              {
                'id': 'prof-new',
                'ownerId': ownerId1,
                'displayName': 'Adopting User',
                'createdAt': 1710000000000,
                'updatedAt': 1710000000000,
              },
            ],
            'journal': [],
            'sessions': [],
            'birds': [],
          }),
        ),
      );

      final result = await exporterB.mergeFromBytes(importBytes);
      expect(result.adoptedProfile, isTrue);

      final bProfiles = await dbB.select(dbB.profiles).get();
      expect(bProfiles.length, equals(1));
      expect(bProfiles.first.ownerId, equals(ownerId1));
      expect(bProfiles.first.displayName, equals('Adopting User'));
    });

    test(
      'legacy file with no ownerId requires explicit confirmation',
      () async {
        final legacyBytes = Uint8List.fromList(
          utf8.encode(
            jsonEncode({
              'version': 1,
              'schemaVersion': 6,
              'profiles': [
                {'id': 'p-leg', 'displayName': 'Legacy'},
              ],
              'journal': [],
              'sessions': [],
              'birds': [],
            }),
          ),
        );

        final check = await exporterA.checkOwnerGuard(
          jsonDecode(utf8.decode(legacyBytes)),
        );
        expect(check.status, equals(OwnerGuardStatus.legacyNoOwnerId));
        expect(check.isLegacy, isTrue);

        // Throws without allowLegacy: true
        expect(
          () => exporterA.mergeFromBytes(legacyBytes),
          throwsA(isA<LegacyBackupException>()),
        );

        // Succeeds with allowLegacy: true
        final result = await exporterA.mergeFromBytes(
          legacyBytes,
          allowLegacy: true,
        );
        expect(result, isNotNull);
      },
    );
  });

  group('DatabaseExporter — Union Merge & Idempotency', () {
    const ownerId = 'fleet-owner-1234';

    setUp(() async {
      await dbA
          .into(dbA.profiles)
          .insert(
            ProfilesCompanion.insert(
              id: 'prof-a',
              ownerId: const drift.Value(ownerId),
              displayName: const drift.Value('Local Fleet Profile'),
              createdAt: 1710000000000,
              updatedAt: 1710000000000,
            ),
          );

      await dbB
          .into(dbB.profiles)
          .insert(
            ProfilesCompanion.insert(
              id: 'prof-b',
              ownerId: const drift.Value(ownerId),
              displayName: const drift.Value('Remote Fleet Profile'),
              createdAt: 1710000000000,
              updatedAt: 1710000000000,
            ),
          );
    });

    test(
      'union-merges disjoint event records and preserves existing local records',
      () async {
        // Seed DB-A with local records
        await dbA
            .into(dbA.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'j-a1',
                timestamp: 1710000000000,
                expectedFlow: 'solar',
                actualFlow: 'solar',
                isAligned: true,
                nostril: 'right',
              ),
            );
        await dbA
            .into(dbA.breathSessions)
            .insert(
              BreathSessionsCompanion.insert(
                id: 's-a1',
                timestamp: 1710000000000,
                totalDurationMs: 300000,
                nostril: 'right',
                inhaleLengthMs: 4000,
                holdAfterInhaleMs: 8000,
                exhaleLengthMs: 4000,
                holdAfterExhaleMs: 0,
                completedCycles: 15,
              ),
            );

        // Seed DB-B with disjoint records
        await dbB
            .into(dbB.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'j-b1',
                timestamp: 1710086400000,
                expectedFlow: 'lunar',
                actualFlow: 'lunar',
                isAligned: true,
                nostril: 'left',
              ),
            );
        await dbB
            .into(dbB.breathSessions)
            .insert(
              BreathSessionsCompanion.insert(
                id: 's-b1',
                timestamp: 1710086400000,
                totalDurationMs: 400000,
                nostril: 'left',
                inhaleLengthMs: 5000,
                holdAfterInhaleMs: 10000,
                exhaleLengthMs: 5000,
                holdAfterExhaleMs: 0,
                completedCycles: 20,
              ),
            );

        final exportBytesB = await exporterB.exportToBytes();

        // Merge B into A
        final result = await exporterA.mergeFromBytes(exportBytesB);
        expect(result.insertedJournal, equals(1));
        expect(result.insertedSessions, equals(1));
        expect(result.adoptedProfile, isFalse);

        // Verify DB-A now contains union {A ∪ B}
        final journalA = await dbA.select(dbA.saraKalaiJournal).get();
        expect(journalA.length, equals(2));
        expect(journalA.map((r) => r.id).toSet(), equals({'j-a1', 'j-b1'}));

        final sessionsA = await dbA.select(dbA.breathSessions).get();
        expect(sessionsA.length, equals(2));
        expect(sessionsA.map((r) => r.id).toSet(), equals({'s-a1', 's-b1'}));

        // Local profile untouched
        final profileA = (await dbA.select(dbA.profiles).get()).first;
        expect(profileA.displayName, equals('Local Fleet Profile'));
      },
    );

    test('re-merging is idempotent (0 duplicate records inserted)', () async {
      await dbB
          .into(dbB.saraKalaiJournal)
          .insert(
            SaraKalaiJournalCompanion.insert(
              id: 'j-b-repeat',
              timestamp: 1710000000000,
              expectedFlow: 'solar',
              actualFlow: 'solar',
              isAligned: true,
              nostril: 'right',
            ),
          );

      final exportBytesB = await exporterB.exportToBytes();

      // First merge
      final res1 = await exporterA.mergeFromBytes(exportBytesB);
      expect(res1.insertedJournal, equals(1));

      // Second merge of identical file
      final res2 = await exporterA.mergeFromBytes(exportBytesB);
      expect(res2.insertedJournal, equals(0));
      expect(res2.totalInserted, equals(0));

      // Still exactly 1 journal entry in DB-A
      final journal = await dbA.select(dbA.saraKalaiJournal).get();
      expect(journal.length, equals(1));
      expect(journal.first.id, equals('j-b-repeat'));
    });

    test('restoreFromBytes performs full destructive replacement', () async {
      await dbA
          .into(dbA.saraKalaiJournal)
          .insert(
            SaraKalaiJournalCompanion.insert(
              id: 'j-old-to-delete',
              timestamp: 1710000000000,
              expectedFlow: 'solar',
              actualFlow: 'solar',
              isAligned: true,
              nostril: 'right',
            ),
          );

      await dbB
          .into(dbB.saraKalaiJournal)
          .insert(
            SaraKalaiJournalCompanion.insert(
              id: 'j-new-restored',
              timestamp: 1710000000000,
              expectedFlow: 'lunar',
              actualFlow: 'lunar',
              isAligned: true,
              nostril: 'left',
            ),
          );

      final exportBytesB = await exporterB.exportToBytes();

      await exporterA.restoreFromBytes(exportBytesB);

      final journal = await dbA.select(dbA.saraKalaiJournal).get();
      expect(journal.length, equals(1));
      expect(journal.first.id, equals('j-new-restored'));
      expect(journal.first.nostril, equals('left'));
    });
  });

  group('Task 44.5 — Aggregate Correctness After Merge', () {
    const ownerId = 'aggregate-test-owner';

    test(
      'hold-time personal-best, daily averages, and session totals span A ∪ B',
      () async {
        await dbA
            .into(dbA.profiles)
            .insert(
              ProfilesCompanion.insert(
                id: 'p-a',
                ownerId: const drift.Value(ownerId),
                createdAt: 1710000000000,
                updatedAt: 1710000000000,
              ),
            );
        await dbB
            .into(dbB.profiles)
            .insert(
              ProfilesCompanion.insert(
                id: 'p-b',
                ownerId: const drift.Value(ownerId),
                createdAt: 1710000000000,
                updatedAt: 1710000000000,
              ),
            );

        // Day 1 on Device A: hold duration 30s (30,000 ms)
        final day1 = DateTime(2026, 9, 10, 8, 0).millisecondsSinceEpoch;
        await dbA
            .into(dbA.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'j-day1-deviceA',
                timestamp: day1,
                expectedFlow: 'solar',
                actualFlow: 'solar',
                isAligned: true,
                nostril: 'right',
                holdDurationMs: const drift.Value(30000),
              ),
            );

        // Baseline aggregate on Device A before merge
        final initialA = await dbA.select(dbA.saraKalaiJournal).get();
        final initialProgressionA =
            AnalyticsCalculator.calculateHoldTimeProgression(entries: initialA);
        expect(initialProgressionA.personalBestMs, equals(30000));
        expect(initialProgressionA.totalSessions, equals(1));

        // Day 2 on Device B: hold duration 45s (45,000 ms) - New personal best!
        final day2 = DateTime(2026, 9, 11, 8, 0).millisecondsSinceEpoch;
        await dbB
            .into(dbB.saraKalaiJournal)
            .insert(
              SaraKalaiJournalCompanion.insert(
                id: 'j-day2-deviceB',
                timestamp: day2,
                expectedFlow: 'lunar',
                actualFlow: 'lunar',
                isAligned: true,
                nostril: 'left',
                holdDurationMs: const drift.Value(45000),
              ),
            );

        // Export B and Merge into A
        final bytesB = await exporterB.exportToBytes();
        await exporterA.mergeFromBytes(bytesB);

        // Recompute aggregates on Device A
        final mergedEntriesA = await dbA.select(dbA.saraKalaiJournal).get();
        expect(mergedEntriesA.length, equals(2));

        final mergedProgression =
            AnalyticsCalculator.calculateHoldTimeProgression(
              entries: mergedEntriesA,
            );

        // Personal best correctly spans both devices (max of 30s and 45s = 45s)
        expect(mergedProgression.personalBestMs, equals(45000));
        expect(mergedProgression.totalSessions, equals(2));
        expect(mergedProgression.dailyAverages.length, equals(2));
        expect(mergedProgression.allTimeAverage, equals(37500.0));
      },
    );
  });
}
