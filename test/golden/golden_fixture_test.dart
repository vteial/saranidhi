// test/golden/golden_fixture_test.dart
//
// Golden-Fixture Correctness Reconcile Test (Task T2 / Requirement R2).
//
// Evaluates the frozen dataset at `test/golden/astro_golden.json` against the
// real astro-engine implementations in `lib/features/astro_engine/domain/`.
//
// Fail-Closed Guarantees:
// 1. Missing expected field, unparseable fixture, or unevaluable case FAILS immediately.
// 2. Tolerance-based comparisons for continuous floats; exact comparisons for discrete enums/strings.
// 3. Pure and deterministic: NO DateTime.now(), NO database, NO network.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/features/astro_engine/domain/action_window.dart';
import 'package:saranidhi/features/astro_engine/domain/hora_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/moon_longitude_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/nakshatra_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/oracle_engine.dart';
import 'package:saranidhi/features/astro_engine/domain/pakshi_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/swara_clock.dart';
import 'package:saranidhi/features/astro_engine/domain/tattva_calculator.dart';
import 'package:saranidhi/features/astro_engine/domain/yama_calculator.dart';

File _resolveFixtureFile() {
  const relPath = 'test/golden/astro_golden.json';
  if (File(relPath).existsSync()) {
    return File(relPath);
  }
  if (File('astro_golden.json').existsSync()) {
    return File('astro_golden.json');
  }
  if (File('../golden/astro_golden.json').existsSync()) {
    return File('../golden/astro_golden.json');
  }
  final cwd = Directory.current.path;
  final alt = File('$cwd/$relPath');
  if (alt.existsSync()) {
    return alt;
  }
  throw StateError(
    'Golden fixture file not found at "$relPath" (current working dir: $cwd)',
  );
}

Map<String, dynamic> _loadFixture() {
  final file = _resolveFixtureFile();
  final raw = file.readAsStringSync();
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Root JSON object must be a Map<String, dynamic>');
    }
    return decoded;
  } catch (e) {
    throw FormatException('Failed to parse golden fixture at ${file.path}: $e');
  }
}

void main() {
  final fixture = _loadFixture();

  group('Golden-Fixture Reconcile Gate (TSK-golden-01)', () {
    // ─── 0. Fixture Integrity Check (R2.2) ───────────────────────────────────
    test('fixture contains meta and all required sections with N >= 20 cases', () {
      expect(fixture.containsKey('meta'), isTrue, reason: 'Missing "meta" section');
      final meta = fixture['meta'] as Map<String, dynamic>?;
      expect(meta, isNotNull);
      expect(meta!['engineVersion'], isNotNull);

      const requiredSections = [
        'moonLongitude',
        'nakshatra',
        'swara',
        'hora',
        'tattva',
        'oracle',
      ];

      var totalCases = 0;
      for (final section in requiredSections) {
        expect(
          fixture.containsKey(section),
          isTrue,
          reason: 'Missing required section: $section',
        );
        final list = fixture[section] as List?;
        expect(list, isNotNull, reason: 'Section $section must be a List');
        expect(list!.isNotEmpty, isTrue, reason: 'Section $section must not be empty');
        totalCases += list.length;
      }

      // R1.1: N >= 20 cases
      expect(
        totalCases,
        greaterThanOrEqualTo(20),
        reason: 'Total cases across all sections must be >= 20 (got $totalCases)',
      );
    });

    // ─── 1. Moon Longitude (R1.3 continuous tolerance) ───────────────────────
    group('Moon Longitude (ELP 2000/82)', () {
      final cases = (fixture['moonLongitude'] as List).cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;
          final tolerance = (c['tolerance'] as num?)?.toDouble();

          if (input == null || expected == null || tolerance == null) {
            fail('Case $id is missing required fields (input, expected, or tolerance)');
          }

          final dtStr = input['datetime'] as String?;
          final expectedLon = (expected['longitude'] as num?)?.toDouble();

          if (dtStr == null || expectedLon == null) {
            fail('Case $id is missing input.datetime or expected.longitude');
          }

          final dt = DateTime.parse(dtStr);
          final result = MoonLongitudeCalculator.calculate(dt);

          expect(
            result.longitude,
            closeTo(expectedLon, tolerance),
            reason: 'Case $id drift: expected $expectedLon (±$tolerance), got ${result.longitude}',
          );
        });
      }
    });

    // ─── 2. Nakshatra & Birth-Bird (R1.3 discrete exact) ─────────────────────
    group('Nakshatra & Birth-Bird (CONF-PP-001/002)', () {
      final cases = (fixture['nakshatra'] as List).cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;

          if (input == null || expected == null) {
            fail('Case $id is missing required input or expected map');
          }

          final dobStr = input['dob'] as String?;
          final expectedNak = expected['standardName'] as String?;
          final expectedBird = expected['birthBird'] as String?;

          if (dobStr == null || expectedNak == null || expectedBird == null) {
            fail('Case $id is missing input.dob, expected.standardName, or expected.birthBird');
          }

          final dob = DateTime.parse(dobStr);
          final nakResult = NakshatraCalculator.calculate(dob);
          final actualNak = nakResult.standardName;
          final birdResult = PakshiCalculator.birthBirdFromNakshatra(actualNak);
          final actualBird = birdResult.name;

          expect(
            actualNak,
            equals(expectedNak),
            reason: 'Case $id drift: expected nakshatra "$expectedNak", got "$actualNak"',
          );
          expect(
            actualBird,
            equals(expectedBird),
            reason: 'Case $id drift: expected bird "$expectedBird", got "$actualBird"',
          );
        });
      }
    });

    // ─── 3. Swara Clock (R1.3 discrete exact) ────────────────────────────────
    group('Swara Clock (CONF-013/014)', () {
      final cases = (fixture['swara'] as List).cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;

          if (input == null || expected == null) {
            fail('Case $id is missing required input or expected map');
          }

          final timeStr = input['time'] as String?;
          final sunriseStr = input['sunrise'] as String?;
          final pakshaStr = input['paksha'] as String?;
          final expectedFlow = expected['flow'] as String?;

          if (timeStr == null || sunriseStr == null || pakshaStr == null || expectedFlow == null) {
            fail('Case $id missing one or more required swara fields');
          }

          final time = DateTime.parse(timeStr);
          final sunrise = DateTime.parse(sunriseStr);
          final paksha = pakshaStr.toLowerCase() == 'shukla'
              ? LunarPhase.waxing
              : LunarPhase.waning;

          final block = SwaraClock.blockAt(
            time: time,
            sunrise: sunrise,
            paksha: paksha,
          );
          final actualFlow = block.flow.name;

          expect(
            actualFlow,
            equals(expectedFlow),
            reason: 'Case $id drift: expected swara flow "$expectedFlow", got "$actualFlow"',
          );
        });
      }
    });

    // ─── 4. Hora (R1.3 discrete exact) ───────────────────────────────────────
    group('Planetary Horas (Chaldean Order)', () {
      final cases = (fixture['hora'] as List).cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;

          if (input == null || expected == null) {
            fail('Case $id is missing required input or expected map');
          }

          final timeStr = input['time'] as String?;
          final sunriseStr = input['sunrise'] as String?;
          final sunsetStr = input['sunset'] as String?;
          final nextSunriseStr = input['nextSunrise'] as String?;
          final weekday = input['weekday'] as int?;

          final expectedPlanet = expected['planet'] as String?;
          final expectedHoraIndex = expected['horaIndex'] as int?;
          final expectedIsDayHora = expected['isDayHora'] as bool?;

          if (timeStr == null ||
              sunriseStr == null ||
              sunsetStr == null ||
              nextSunriseStr == null ||
              weekday == null ||
              expectedPlanet == null ||
              expectedHoraIndex == null ||
              expectedIsDayHora == null) {
            fail('Case $id is missing one or more required hora fields');
          }

          final res = HoraCalculator.activeHora(
            time: DateTime.parse(timeStr),
            sunrise: DateTime.parse(sunriseStr),
            sunset: DateTime.parse(sunsetStr),
            nextSunrise: DateTime.parse(nextSunriseStr),
            weekday: weekday,
          );

          if (res == null) {
            fail('Case $id: HoraCalculator returned null');
          }

          expect(
            res.planet.name,
            equals(expectedPlanet),
            reason: 'Case $id drift: expected planet "$expectedPlanet", got "${res.planet.name}"',
          );
          expect(
            res.horaIndex,
            equals(expectedHoraIndex),
            reason: 'Case $id drift: expected horaIndex $expectedHoraIndex, got ${res.horaIndex}',
          );
          expect(
            res.isDayHora,
            equals(expectedIsDayHora),
            reason: 'Case $id drift: expected isDayHora $expectedIsDayHora, got ${res.isDayHora}',
          );
        });
      }
    });

    // ─── 5. Tattva (R1.3 discrete exact) ─────────────────────────────────────
    group('Tattva Cycles (CONF-012)', () {
      final cases = (fixture['tattva'] as List).cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;

          if (input == null || expected == null) {
            fail('Case $id is missing required input or expected map');
          }

          final timeStr = input['time'] as String?;
          final sunriseStr = input['sunrise'] as String?;
          final sunsetStr = input['sunset'] as String?;

          final expectedTattva = expected['tattva'] as String?;
          final expectedIndex = expected['index'] as int?;
          final expectedYama = expected['yama'] as String?;

          if (timeStr == null ||
              sunriseStr == null ||
              sunsetStr == null ||
              expectedTattva == null ||
              expectedIndex == null ||
              expectedYama == null) {
            fail('Case $id is missing one or more required tattva fields');
          }

          final time = DateTime.parse(timeStr);
          final sunrise = DateTime.parse(sunriseStr);
          final sunset = DateTime.parse(sunsetStr);

          final yamaResult = YamaCalculator.calculate(
            sunrise: sunrise,
            sunset: sunset,
          );
          final yamaSegment = yamaResult.activeYama(time);

          if (yamaSegment == null) {
            fail('Case $id: time $timeStr falls outside daylight yamas');
          }

          final tattvaRes = TattvaCalculator.activeTattva(
            time: time,
            yamaSegment: yamaSegment,
          );

          if (tattvaRes == null) {
            fail('Case $id: TattvaCalculator returned null');
          }

          expect(
            tattvaRes.tattva.name,
            equals(expectedTattva),
            reason: 'Case $id drift: expected tattva "$expectedTattva", got "${tattvaRes.tattva.name}"',
          );
          expect(
            tattvaRes.index,
            equals(expectedIndex),
            reason: 'Case $id drift: expected index $expectedIndex, got ${tattvaRes.index}',
          );
          expect(
            tattvaRes.yama.name,
            equals(expectedYama),
            reason: 'Case $id drift: expected yama "$expectedYama", got "${tattvaRes.yama.name}"',
          );
        });
      }
    });

    // ─── 6. Oracle Composite (R1.3 exact band/lock + tolerance score) ────────
    group('Prasanam Oracle Composite (Sprint 31/38)', () {
      final cases = (fixture['oracle'] as List).cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;
          final tolerance = (c['tolerance'] as num?)?.toDouble() ?? 1e-9;

          if (input == null || expected == null) {
            fail('Case $id is missing required input or expected map');
          }

          final queryTimeStr = input['queryTime'] as String?;
          final sunriseStr = input['sunrise'] as String?;
          final sunsetStr = input['sunset'] as String?;
          final weekday = input['weekday'] as int?;
          final currentBirdStateStr = input['currentBirdState'] as String?;
          final currentWindowStr = input['currentWindow'] as String?;
          final tarabalaMultiplier = (input['tarabalaMultiplier'] as num?)?.toDouble();
          final horaSwaraMultiplier = (input['horaSwaraMultiplier'] as num?)?.toDouble();
          final categoryStr = input['category'] as String?;
          final actualSwara = input['actualSwara'] as String?;

          final expectedScore = (expected['score'] as num?)?.toDouble();
          final expectedBand = expected['band'] as String?;
          final expectedIsFloorLocked = expected['isFloorLocked'] as bool?;

          if (queryTimeStr == null ||
              sunriseStr == null ||
              sunsetStr == null ||
              weekday == null ||
              currentBirdStateStr == null ||
              currentWindowStr == null ||
              tarabalaMultiplier == null ||
              horaSwaraMultiplier == null ||
              categoryStr == null ||
              actualSwara == null ||
              expectedScore == null ||
              expectedBand == null ||
              expectedIsFloorLocked == null) {
            fail('Case $id is missing one or more required oracle fields');
          }

          final birdState = PakshiState.values.byName(currentBirdStateStr);
          final window = ActionWindow.values.byName(currentWindowStr);
          final category = QueryCategory.values.byName(categoryStr);

          final result = OracleCompositeEngine.evaluate(
            queryTime: DateTime.parse(queryTimeStr),
            sunrise: DateTime.parse(sunriseStr),
            sunset: DateTime.parse(sunsetStr),
            weekday: weekday,
            currentBirdState: birdState,
            currentWindow: window,
            tarabalaMultiplier: tarabalaMultiplier,
            horaSwaraMultiplier: horaSwaraMultiplier,
            category: category,
            actualSwara: actualSwara,
          );

          expect(
            result.band.name,
            equals(expectedBand),
            reason: 'Case $id drift: expected band "$expectedBand", got "${result.band.name}"',
          );
          expect(
            result.isFloorLocked,
            equals(expectedIsFloorLocked),
            reason: 'Case $id drift: expected isFloorLocked $expectedIsFloorLocked, got ${result.isFloorLocked}',
          );
          expect(
            result.score.toDouble(),
            closeTo(expectedScore, tolerance),
            reason: 'Case $id drift: expected score $expectedScore (±$tolerance), got ${result.score}',
          );
        });
      }
    });
  });
}
