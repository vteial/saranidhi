import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/cloud_backup/domain/database_exporter.dart';

void main() {
  group('DatabaseExporter.buildBackupFilename (Sprint 45.3)', () {
    final fixedTime = DateTime(2026, 9, 15, 10, 34);

    test('prefixes filename with first 8 chars of full ownerId UUID', () {
      const ownerId = '3f9a1c2b-4567-89ab-cdef-0123456789ab';
      final filename = DatabaseExporter.buildBackupFilename(
        ownerId: ownerId,
        now: fixedTime,
      );

      expect(
        filename,
        equals('saranidhi_backup_3f9a1c2b_2026-09-15-1034.json'),
      );
    });

    test('falls back to unprefixed filename when ownerId is null', () {
      final filename = DatabaseExporter.buildBackupFilename(
        ownerId: null,
        now: fixedTime,
      );

      expect(filename, equals('saranidhi_backup_2026-09-15-1034.json'));
    });

    test('falls back to unprefixed filename when ownerId is empty string', () {
      final filename = DatabaseExporter.buildBackupFilename(
        ownerId: '',
        now: fixedTime,
      );

      expect(filename, equals('saranidhi_backup_2026-09-15-1034.json'));
    });

    test(
      'handles short ownerId (<8 chars) using full length without RangeError',
      () {
        const shortOwnerId = 'abc12';
        final filename = DatabaseExporter.buildBackupFilename(
          ownerId: shortOwnerId,
          now: fixedTime,
        );

        expect(filename, equals('saranidhi_backup_abc12_2026-09-15-1034.json'));
      },
    );

    test('handles single character ownerId without RangeError', () {
      final filename = DatabaseExporter.buildBackupFilename(
        ownerId: 'x',
        now: fixedTime,
      );

      expect(filename, equals('saranidhi_backup_x_2026-09-15-1034.json'));
    });

    test('defaults to DateTime.now() when now parameter is omitted', () {
      final filename = DatabaseExporter.buildBackupFilename(
        ownerId: '3f9a1c2b-test',
      );

      expect(filename, startsWith('saranidhi_backup_3f9a1c2b_'));
      expect(filename, endsWith('.json'));
    });
  });
}
