import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/database/app_database.dart';
import 'package:saranidhi/features/somatic/data/somatic_intervention_repository.dart';

void main() {
  late AppDatabase db;
  late SomaticInterventionRepository repo;

  setUp(() {
    // In-memory database; `onCreate` runs `createAll()` so the
    // somatic_intervention_logs table exists.
    db = AppDatabase(NativeDatabase.memory());
    repo = SomaticInterventionRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SomaticInterventionRepository', () {
    test('insertLog returns an id and the row is retrievable', () async {
      final id = await repo.insertLog(
        protocolType: 'postureShift',
        targetFlow: 'left',
        initialFlow: 'right',
        durationSeconds: 180,
      );

      expect(id, isNotEmpty);

      final all = await repo.getAllLogs();
      expect(all, hasLength(1));

      final row = all.single;
      expect(row.id, id);
      expect(row.protocolType, 'postureShift');
      expect(row.targetFlow, 'left');
      expect(row.initialFlow, 'right');
      expect(row.durationSeconds, 180);
      // Outcome fields default until updateOutcome runs.
      expect(row.resolvedFlow, isNull);
      expect(row.isSuccess, isFalse);
    });

    test('getRecentLogs returns rows newest-first and honours limit',
        () async {
      await repo.insertLog(
        protocolType: 'postureShift',
        targetFlow: 'left',
        initialFlow: 'right',
        durationSeconds: 180,
      );
      await repo.insertLog(
        protocolType: 'axillaryPressure',
        targetFlow: 'right',
        initialFlow: 'left',
        durationSeconds: 300,
      );

      final recent = await repo.getRecentLogs(limit: 1);
      expect(recent, hasLength(1));

      final allRecent = await repo.getRecentLogs();
      expect(allRecent, hasLength(2));
    });

    test('updateOutcome sets resolvedFlow and isSuccess', () async {
      final id = await repo.insertLog(
        protocolType: 'postureShift',
        targetFlow: 'left',
        initialFlow: 'right',
        durationSeconds: 180,
      );

      await repo.updateOutcome(id: id, resolvedFlow: 'left', isSuccess: true);

      final row = (await repo.getAllLogs()).single;
      expect(row.resolvedFlow, 'left');
      expect(row.isSuccess, isTrue);
    });

    test('deleteLog removes the row', () async {
      final id = await repo.insertLog(
        protocolType: 'postureShift',
        targetFlow: 'left',
        initialFlow: 'right',
        durationSeconds: 180,
      );

      final deleted = await repo.deleteLog(id);
      expect(deleted, 1);
      expect(await repo.getAllLogs(), isEmpty);
    });

    test('watchAllLogs emits the current list', () async {
      await repo.insertLog(
        protocolType: 'axillaryPressure',
        targetFlow: 'right',
        initialFlow: 'left',
        durationSeconds: 300,
      );

      final logs = await repo.watchAllLogs().first;
      expect(logs, hasLength(1));
      expect(logs.single.protocolType, 'axillaryPressure');
    });
  });
}
