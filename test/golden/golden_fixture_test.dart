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

// ─── Independent-truth fixture loader (R1/R3.3) ───────────────────────────────
//
// Loaded SEPARATELY from astro_golden.json so the independent set is a runnable
// gate on its own — the independent group must run even if the engine-snapshot
// block were empty (R3.3). Mirrors the resolution fallbacks of the snapshot loader.
File _resolveIndependentFile() {
  const relPath = 'test/golden/astro_independent.json';
  if (File(relPath).existsSync()) {
    return File(relPath);
  }
  if (File('astro_independent.json').existsSync()) {
    return File('astro_independent.json');
  }
  if (File('../golden/astro_independent.json').existsSync()) {
    return File('../golden/astro_independent.json');
  }
  final cwd = Directory.current.path;
  final alt = File('$cwd/$relPath');
  if (alt.existsSync()) {
    return alt;
  }
  throw StateError(
    'Independent-truth fixture not found at "$relPath" (current working dir: $cwd)',
  );
}

Map<String, dynamic> _loadIndependentFixture() {
  final file = _resolveIndependentFile();
  final raw = file.readAsStringSync();
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Root JSON object must be a Map<String, dynamic>');
    }
    return decoded;
  } catch (e) {
    throw FormatException('Failed to parse independent fixture at ${file.path}: $e');
  }
}

void main() {
  final fixture = _loadFixture();
  // Loaded independently (R3.3): neither file's emptiness short-circuits the other.
  final independent = _loadIndependentFixture();

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
          final pakshaStr = input['paksha'] as String?;
          final expectedFlow = expected['flow'] as String?;
          // Pre-dawn cases (R2.7) carry an `anchor` map instead of a literal
          // `sunrise`; they resolve the governing civil-day sunrise via
          // SwaraClock.anchorSunrise. Standard cases carry `sunrise` directly.
          final anchor = input['anchor'] as Map<String, dynamic>?;
          final sunriseStr = input['sunrise'] as String?;

          if (timeStr == null ||
              pakshaStr == null ||
              expectedFlow == null ||
              (sunriseStr == null && anchor == null)) {
            fail('Case $id missing one or more required swara fields');
          }

          final time = DateTime.parse(timeStr);
          final paksha = pakshaStr.toLowerCase() == 'shukla'
              ? LunarPhase.waxing
              : LunarPhase.waning;

          final DateTime sunrise;
          if (anchor != null) {
            final byDate = (anchor['sunriseByDate'] as Map).cast<String, String>();
            sunrise = SwaraClock.anchorSunrise(
              time: time,
              sunriseForDate: (date) {
                final key =
                    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final iso = byDate[key];
                if (iso == null) {
                  fail('Case $id: no sunrise mapping for date $key in anchor');
                }
                return DateTime.parse(iso);
              },
            );
          } else {
            sunrise = DateTime.parse(sunriseStr!);
          }

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

    // ─── 5b. Night Tattva (R2.1) — calculateNight -> NightYamaResult -> tattva
    group('Night Tattva Cycles (CONF-012, night yamas)', () {
      final cases = (fixture['tattvaNight'] as List? ?? const [])
          .cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;

          if (input == null || expected == null) {
            fail('Case $id is missing required input or expected map');
          }

          final timeStr = input['time'] as String?;
          final sunsetStr = input['sunset'] as String?;
          final nextSunriseStr = input['nextSunrise'] as String?;

          final expectedTattva = expected['tattva'] as String?;
          final expectedIndex = expected['index'] as int?;
          final expectedYama = expected['yama'] as String?;

          if (timeStr == null ||
              sunsetStr == null ||
              nextSunriseStr == null ||
              expectedTattva == null ||
              expectedIndex == null ||
              expectedYama == null) {
            fail('Case $id is missing one or more required night-tattva fields');
          }

          final time = DateTime.parse(timeStr);
          final sunset = DateTime.parse(sunsetStr);
          final nextSunrise = DateTime.parse(nextSunriseStr);

          final nightResult = YamaCalculator.calculateNight(
            sunset: sunset,
            nextSunrise: nextSunrise,
          );
          final nightSegment = nightResult.activeYama(time);
          if (nightSegment == null) {
            fail('Case $id: time $timeStr falls outside night yamas');
          }

          // Wrap the night segment as a YamaSegment for the shared tattva
          // sub-division math; the recorded `yama` is the NightYamaIndex label.
          final wrapped = YamaSegment(
            index: YamaIndex.values[nightSegment.index.index],
            start: nightSegment.start,
            end: nightSegment.end,
          );
          final tattvaRes = TattvaCalculator.activeTattva(
            time: time,
            yamaSegment: wrapped,
          );
          if (tattvaRes == null) {
            fail('Case $id: TattvaCalculator returned null for night yama');
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
            nightSegment.index.name,
            equals(expectedYama),
            reason: 'Case $id drift: expected night yama "$expectedYama", got "${nightSegment.index.name}"',
          );
        });
      }
    });

    // ─── 5c. Nakshatra end-to-end (R2.5) — longitude -> nakshatra -> bird ────
    group('Nakshatra End-to-End (longitude->nakshatra->bird)', () {
      final cases = (fixture['nakshatraEndToEnd'] as List? ?? const [])
          .cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;
          final tolerance = (c['tolerance'] as num?)?.toDouble();

          if (input == null || expected == null || tolerance == null) {
            fail('Case $id is missing input, expected, or tolerance');
          }

          final dtStr = input['datetime'] as String?;
          final expectedLon = (expected['longitude'] as num?)?.toDouble();
          final expectedNak = expected['standardName'] as String?;
          final expectedBird = expected['birthBird'] as String?;

          if (dtStr == null ||
              expectedLon == null ||
              expectedNak == null ||
              expectedBird == null) {
            fail('Case $id is missing one or more required end-to-end fields');
          }

          final dt = DateTime.parse(dtStr);
          final lon = MoonLongitudeCalculator.calculate(dt).longitude;
          final nak = NakshatraCalculator.calculate(dt);
          final bird = PakshiCalculator.birthBirdFromNakshatra(nak.standardName).name;

          expect(
            lon,
            closeTo(expectedLon, tolerance),
            reason: 'Case $id drift: expected longitude $expectedLon (±$tolerance), got $lon',
          );
          expect(
            nak.standardName,
            equals(expectedNak),
            reason: 'Case $id drift: expected nakshatra "$expectedNak", got "${nak.standardName}"',
          );
          expect(
            bird,
            equals(expectedBird),
            reason: 'Case $id drift: expected bird "$expectedBird", got "$bird"',
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

  // ═══════════════════════════════════════════════════════════════════════════
  // INDEPENDENT-TRUTH GATE (R1 / R3 / R4) — the correctness proof.
  //
  // Expected values here are TRANSCRIBED FROM EXTERNAL/CORPUS SOURCES, not the
  // engine. A failure is therefore a REVEALED BUG (R4.1), not a drift — do NOT
  // regenerate or loosen it to pass. Reuses the SAME assertion shapes the v1
  // sections use (exact for discrete standardName/birthBird, closeTo for the
  // continuous Moon longitude). Loaded from a SEPARATE file (R3.3), so this
  // group runs even if the engine-snapshot block were empty.
  // ═══════════════════════════════════════════════════════════════════════════
  group('Independent-Truth Gate (TSK-golden-02, R1/R4)', () {
    test('independent fixture has meta.kind == independent-truth and N >= 6', () {
      expect(independent.containsKey('meta'), isTrue, reason: 'Missing "meta" section');
      final meta = independent['meta'] as Map<String, dynamic>?;
      expect(meta, isNotNull);
      expect(
        meta!['kind'],
        equals('independent-truth'),
        reason: 'Independent fixture meta.kind must be "independent-truth"',
      );

      var total = 0;
      for (final section in const ['moonLongitude', 'nakshatra']) {
        final list = independent[section] as List?;
        if (list != null) total += list.length;
      }
      expect(
        total,
        greaterThanOrEqualTo(6),
        reason: 'Independent-truth set must hold >= 6 cases (got $total)',
      );
    });

    // ─── Moon longitude (continuous, within declared tolerance) ──────────────
    group('Independent Moon Longitude (Meeus worked example)', () {
      final cases = (independent['moonLongitude'] as List? ?? const [])
          .cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          // R1.2 fail-closed on provenance: a case missing groundTruth FAILS.
          final groundTruth = c['groundTruth'] as String?;
          if (groundTruth == null || groundTruth.trim().isEmpty) {
            fail('Independent case $id is missing mandatory "groundTruth" (R1.2)');
          }

          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;
          final tolerance = (c['tolerance'] as num?)?.toDouble();
          if (input == null || expected == null || tolerance == null) {
            fail('Independent case $id missing input, expected, or tolerance (R3.1)');
          }

          final dtStr = input['datetime'] as String?;
          final expectedLon = (expected['longitude'] as num?)?.toDouble();
          if (dtStr == null || expectedLon == null) {
            fail('Independent case $id missing input.datetime or expected.longitude');
          }

          final result = MoonLongitudeCalculator.calculate(DateTime.parse(dtStr));
          expect(
            result.longitude,
            closeTo(expectedLon, tolerance),
            reason:
                'REVEALED BUG (R4.1) — independent case $id: expected $expectedLon '
                '(±$tolerance) per [$groundTruth], got ${result.longitude}. '
                'STOP and flag — do NOT regenerate/loosen.',
          );
        });
      }
    });

    // ─── Nakshatra -> Bird (discrete, exact) ─────────────────────────────────
    group('Independent Nakshatra->Bird (CONF-PP-001 5-6-5-5-6 table)', () {
      final cases = (independent['nakshatra'] as List? ?? const [])
          .cast<Map<String, dynamic>>();

      for (final c in cases) {
        final id = c['id'] as String;
        test(id, () {
          final groundTruth = c['groundTruth'] as String?;
          if (groundTruth == null || groundTruth.trim().isEmpty) {
            fail('Independent case $id is missing mandatory "groundTruth" (R1.2)');
          }

          final input = c['input'] as Map<String, dynamic>?;
          final expected = c['expected'] as Map<String, dynamic>?;
          if (input == null || expected == null) {
            fail('Independent case $id missing input or expected map (R3.1)');
          }

          final dobStr = input['dob'] as String?;
          final expectedNak = expected['standardName'] as String?;
          final expectedBird = expected['birthBird'] as String?;
          if (dobStr == null || expectedNak == null || expectedBird == null) {
            fail('Independent case $id missing dob, standardName, or birthBird');
          }

          final nakResult = NakshatraCalculator.calculate(DateTime.parse(dobStr));
          final actualNak = nakResult.standardName;
          final actualBird =
              PakshiCalculator.birthBirdFromNakshatra(actualNak).name;

          expect(
            actualNak,
            equals(expectedNak),
            reason:
                'REVEALED BUG (R4.1) — independent case $id: expected nakshatra '
                '"$expectedNak" per [$groundTruth], got "$actualNak". '
                'STOP and flag — do NOT regenerate.',
          );
          expect(
            actualBird,
            equals(expectedBird),
            reason:
                'REVEALED BUG (R4.1) — independent case $id: expected bird '
                '"$expectedBird" per [$groundTruth], got "$actualBird". '
                'STOP and flag — do NOT regenerate.',
          );
        });
      }
    });
  });
}
