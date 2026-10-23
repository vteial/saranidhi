import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/lunar_phase_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';

import '../../tool/dump_diagnostic.dart';

void main() {
  group('Diagnostic Dump Tool', () {
    const lat = 13.0827;
    const lng = 80.2707;
    final startDate = DateTime(2026, 10, 23);

    test('builds 7-day report with 70 yamas and all required fields', () {
      final report = buildDiagnosticDump(
        bird: PakshiBird.owl,
        latitude: lat,
        longitude: lng,
        startDate: startDate,
      );

      expect(report.bird, equals(PakshiBird.owl));
      expect(report.latitude, equals(lat));
      expect(report.longitude, equals(lng));
      expect(report.startDate, equals('2026-10-23'));
      expect(report.days, equals(7));
      expect(report.records.length, equals(7));

      // 70 total yamas (7 days x 10 yamas)
      expect(report.allYamas.length, equals(70));

      final validWeekdayStrings = {
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      };

      for (var d = 0; d < 7; d++) {
        final day = report.records[d];

        // Day fields
        expect(day.date, matches(r'^\d{4}-\d{2}-\d{2}$'));
        expect(validWeekdayStrings.contains(day.weekday), isTrue);
        expect(day.sunrise.isBefore(day.sunset), isTrue);
        expect(
          [LunarPhase.waxing, LunarPhase.waning].contains(day.lunarPhase),
          isTrue,
        );
        expect(day.nakshatra.isNotEmpty, isTrue);
        expect(day.yamas.length, equals(10));

        // Yamas 1 to 10 indices
        for (var y = 0; y < 10; y++) {
          final yama = day.yamas[y];
          expect(yama.date, equals(day.date));
          expect(yama.index, equals(y + 1));
          expect(yama.start.isBefore(yama.end), isTrue);
          expect(PakshiBird.values.contains(yama.rulingBird), isTrue);
          expect(yama.subjectBird, equals(PakshiBird.owl));
          expect(PakshiState.values.contains(yama.subjectState), isTrue);

          // Day yamas (1-5) must fall within daylight
          if (y < 5) {
            expect(yama.start.isBefore(day.sunset), isTrue);
          } else {
            // Night yamas (6-10) must start at or after sunset
            expect(
              yama.start.isBefore(day.sunset),
              isFalse,
              reason: 'Night yama $y start should be >= sunset',
            );
          }
        }

        // Yama 1 starts at sunrise; Yama 5 ends at sunset
        expect(day.yamas[0].start, equals(day.sunrise));
        expect(day.yamas[4].end, equals(day.sunset));

        // Yama 6 starts at sunset
        expect(day.yamas[5].start, equals(day.sunset));
      }
    });

    test('JSON serialization is byte-identical across multiple runs (determinism)', () {
      final report1 = buildDiagnosticDump(
        bird: PakshiBird.owl,
        latitude: lat,
        longitude: lng,
        startDate: startDate,
      );

      final report2 = buildDiagnosticDump(
        bird: PakshiBird.owl,
        latitude: lat,
        longitude: lng,
        startDate: startDate,
      );

      final json1 = report1.toJsonString();
      final json2 = report2.toJsonString();

      expect(json1, equals(json2));
      expect(json1.isNotEmpty, isTrue);

      // Verify JSON contains expected keys and data structure
      expect(json1, contains('"bird": "owl"'));
      expect(json1, contains('"days": 7'));
      expect(json1, contains('"latitude": 13.0827'));
      expect(json1, contains('"longitude": 80.2707'));
      expect(json1, contains('"startDate": "2026-10-23"'));
      expect(json1, contains('"records": ['));
    });

    test('Markdown serialization renders GitHub table with 70 rows', () {
      final report = buildDiagnosticDump(
        bird: PakshiBird.owl,
        latitude: lat,
        longitude: lng,
        startDate: startDate,
      );

      final md = report.toMarkdown();
      expect(md, startsWith('# Saranidhi Diagnostic Dump'));
      expect(md, contains('- **Bird:** owl'));
      expect(md, contains('- **Latitude:** 13.0827'));
      expect(md, contains('- **Longitude:** 80.2707'));
      expect(
        md,
        contains(
          '| Date | Weekday | Yama | Start | End | Ruling Bird | Subject Bird | Subject State | Sunrise | Sunset | Lunar Phase | Nakshatra |',
        ),
      );

      // Count table data rows (rows starting with "| 2026-")
      final lines = md.split('\n');
      final dataRows = lines.where((l) => l.startsWith('| 2026-')).toList();
      expect(dataRows.length, equals(70));
    });

    test('supports all 5 subject birds', () {
      for (final bird in PakshiBird.values) {
        final report = buildDiagnosticDump(
          bird: bird,
          latitude: lat,
          longitude: lng,
          startDate: startDate,
          days: 1,
        );
        expect(report.bird, equals(bird));
        expect(report.records.length, equals(1));
        for (final yama in report.records.first.yamas) {
          expect(yama.subjectBird, equals(bird));
        }
      }
    });

    test('custom day count generates exact number of records', () {
      final report3Days = buildDiagnosticDump(
        bird: PakshiBird.crow,
        latitude: lat,
        longitude: lng,
        startDate: startDate,
        days: 3,
      );
      expect(report3Days.records.length, equals(3));
      expect(report3Days.allYamas.length, equals(30));

      final report1Day = buildDiagnosticDump(
        bird: PakshiBird.peacock,
        latitude: lat,
        longitude: lng,
        startDate: startDate,
        days: 1,
      );
      expect(report1Day.records.length, equals(1));
      expect(report1Day.allYamas.length, equals(10));
    });

    test('validates validBirds constant includes all 5 birds', () {
      expect(
        validBirds,
        unorderedEquals(['vulture', 'owl', 'crow', 'rooster', 'peacock']),
      );
    });
  });
}
