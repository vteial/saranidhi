// tool/regen_golden.dart
//
// Controlled Golden-Fixture Regeneration Tool (Task T3 / Requirement R4).
//
// ⚠️ MANUALLY RUN ONLY — NEVER AUTOMATIC, NEVER RUN IN CI.
// Changing a golden value is a human decision that must be recorded in the PR
// (and, when doctrinal, in the Decision Journal and relevant CONF document).
// Implementing agents must not control their own acceptance values.
//
// Run via:
//   flutter test tool/regen_golden.dart

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

Map<String, dynamic> generateGoldenFixture() {
  // ─── 1. Moon Longitude cases ───────────────────────────────────────────────
  final moonCases = [
    {
      'id': 'moon-01',
      'input': {'datetime': '2026-10-03T00:00:00Z'},
      'tolerance': 1e-6,
      'source': 'Jean Meeus ELP2000/82 (Ch. 47)',
    },
    {
      'id': 'moon-02',
      'input': {'datetime': '2026-03-20T12:00:00Z'},
      'tolerance': 1e-6,
      'source': 'Jean Meeus ELP2000/82 (Ch. 47)',
    },
    {
      'id': 'moon-03',
      'input': {'datetime': '2000-01-01T00:00:00Z'},
      'tolerance': 1e-6,
      'source': 'Jean Meeus ELP2000/82 (Ch. 47)',
    },
    {
      'id': 'moon-04',
      'input': {'datetime': '1992-04-12T00:00:00Z'},
      'tolerance': 1e-6,
      'source': 'Jean Meeus ELP2000/82 Example 47.a',
    },
    {
      'id': 'moon-05',
      'input': {'datetime': '1990-05-15T06:30:00Z'},
      'tolerance': 1e-6,
      'source': 'Jean Meeus ELP2000/82 (Ch. 47)',
    },
  ];

  final evaluatedMoon = moonCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final dt = DateTime.parse(input['datetime'] as String);
    final res = MoonLongitudeCalculator.calculate(dt);
    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'longitude': res.longitude,
      },
      'tolerance': c['tolerance'],
      'source': c['source'],
    };
  }).toList();

  // ─── 2. Nakshatra & Birth-Bird cases ──────────────────────────────────────
  final nakshatraCases = [
    {
      'id': 'nak-01',
      'input': {'dob': '1990-05-15T06:30:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
    {
      'id': 'nak-02',
      'input': {'dob': '1985-08-20T14:00:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
    {
      'id': 'nak-03',
      'input': {'dob': '1995-12-01T06:00:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
    {
      'id': 'nak-04',
      'input': {'dob': '2000-06-15T12:00:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
    {
      'id': 'nak-05',
      'input': {'dob': '1988-03-22T09:15:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
    {
      'id': 'nak-06',
      'input': {'dob': '2026-01-10T18:00:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
    {
      'id': 'nak-07',
      'input': {'dob': '2026-07-25T03:30:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
    {
      'id': 'nak-08',
      'input': {'dob': '2026-10-03T12:00:00+05:30'},
      'source': 'CONF-PP-001 / CONF-PP-002 (canonical 5-6-5-5-6 star table)',
    },
  ];

  final evaluatedNakshatra = nakshatraCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final dob = DateTime.parse(input['dob'] as String);
    final res = NakshatraCalculator.calculate(dob);
    final bird = PakshiCalculator.birthBirdFromNakshatra(res.standardName);
    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'standardName': res.standardName,
        'birthBird': bird.name,
      },
      'source': c['source'],
    };
  }).toList();

  // ─── 3. Swara Clock cases ──────────────────────────────────────────────────
  final swaraCases = [
    {
      'id': 'swara-01',
      'input': {
        'time': '2026-07-05T06:30:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 / CONF-014 (Sunday dawn seed 1h solar inception)',
    },
    {
      'id': 'swara-02',
      'input': {
        'time': '2026-07-05T07:30:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 / CONF-014 (Sunday block 2 alternating lunar)',
    },
    {
      'id': 'swara-03',
      'input': {
        'time': '2026-07-06T06:30:00+05:30',
        'sunrise': '2026-07-06T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 / CONF-014 (Monday dawn seed 1h lunar inception)',
    },
    {
      'id': 'swara-04',
      'input': {
        'time': '2026-07-07T07:30:00+05:30',
        'sunrise': '2026-07-07T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 / CONF-014 (Tuesday 2h solar inception hour 2)',
    },
    {
      'id': 'swara-05',
      'input': {
        'time': '2026-07-08T07:30:00+05:30',
        'sunrise': '2026-07-08T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 / CONF-014 (Wednesday 2h lunar inception hour 2)',
    },
    {
      'id': 'swara-06',
      'input': {
        'time': '2026-07-09T06:30:00+05:30',
        'sunrise': '2026-07-09T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 (Thursday Shukla 1h lunar inception)',
    },
    {
      'id': 'swara-07',
      'input': {
        'time': '2026-07-23T07:15:00+05:30',
        'sunrise': '2026-07-23T06:00:00+05:30',
        'paksha': 'krishna',
      },
      'source': 'CONF-013 (Thursday Krishna 2h solar inception hour 2)',
    },
    {
      'id': 'swara-08',
      'input': {
        'time': '2026-07-10T07:15:00+05:30',
        'sunrise': '2026-07-10T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 / CONF-014 (Friday 2h lunar inception hour 2)',
    },
    {
      'id': 'swara-09',
      'input': {
        'time': '2026-07-11T06:45:00+05:30',
        'sunrise': '2026-07-11T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-013 / CONF-014 (Saturday 1h solar inception)',
    },
  ];

  final evaluatedSwara = swaraCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final time = DateTime.parse(input['time'] as String);
    final sunrise = DateTime.parse(input['sunrise'] as String);
    final pakshaEnum = input['paksha'] == 'shukla'
        ? LunarPhase.waxing
        : LunarPhase.waning;
    final block = SwaraClock.blockAt(
      time: time,
      sunrise: sunrise,
      paksha: pakshaEnum,
    );
    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'flow': block.flow.name,
      },
      'source': c['source'],
    };
  }).toList();

  // ─── 4. Hora cases ────────────────────────────────────────────────────────
  final horaCases = [
    {
      'id': 'hora-01',
      'input': {
        'time': '2026-07-05T06:15:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'nextSunrise': '2026-07-06T06:00:00+05:30',
        'weekday': 0, // Sunday
      },
      'source': 'Chaldean Planetary Hours order (Sunday day lord Sun)',
    },
    {
      'id': 'hora-02',
      'input': {
        'time': '2026-07-05T07:15:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'nextSunrise': '2026-07-06T06:00:00+05:30',
        'weekday': 0,
      },
      'source': 'Chaldean Planetary Hours order (Sunday hora 2 Venus)',
    },
    {
      'id': 'hora-03',
      'input': {
        'time': '2026-07-06T06:15:00+05:30',
        'sunrise': '2026-07-06T06:00:00+05:30',
        'sunset': '2026-07-06T18:00:00+05:30',
        'nextSunrise': '2026-07-07T06:00:00+05:30',
        'weekday': 1, // Monday
      },
      'source': 'Chaldean Planetary Hours order (Monday day lord Moon)',
    },
    {
      'id': 'hora-04',
      'input': {
        'time': '2026-07-07T18:30:00+05:30',
        'sunrise': '2026-07-07T06:00:00+05:30',
        'sunset': '2026-07-07T18:00:00+05:30',
        'nextSunrise': '2026-07-08T06:00:00+05:30',
        'weekday': 2, // Tuesday
      },
      'source': 'Chaldean Planetary Hours order (Tuesday night hora 1)',
    },
    {
      'id': 'hora-05',
      'input': {
        'time': '2026-07-10T12:30:00+05:30',
        'sunrise': '2026-07-10T06:00:00+05:30',
        'sunset': '2026-07-10T18:00:00+05:30',
        'nextSunrise': '2026-07-11T06:00:00+05:30',
        'weekday': 5, // Friday
      },
      'source': 'Chaldean Planetary Hours order (Friday midday hora)',
    },
  ];

  final evaluatedHora = horaCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final res = HoraCalculator.activeHora(
      time: DateTime.parse(input['time'] as String),
      sunrise: DateTime.parse(input['sunrise'] as String),
      sunset: DateTime.parse(input['sunset'] as String),
      nextSunrise: DateTime.parse(input['nextSunrise'] as String),
      weekday: input['weekday'] as int,
    );
    if (res == null) {
      throw StateError('Hora calculation returned null for ${c['id']}');
    }
    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'planet': res.planet.name,
        'horaIndex': res.horaIndex,
        'isDayHora': res.isDayHora,
      },
      'source': c['source'],
    };
  }).toList();

  // ─── 5. Tattva cases ──────────────────────────────────────────────────────
  final tattvaCases = [
    {
      'id': 'tattva-01',
      'input': {
        'time': '2026-10-03T06:10:00+05:30',
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (Earth element in Yama 1)',
    },
    {
      'id': 'tattva-02',
      'input': {
        'time': '2026-10-03T06:40:00+05:30',
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (Water element in Yama 1)',
    },
    {
      'id': 'tattva-03',
      'input': {
        'time': '2026-10-03T07:10:00+05:30',
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (Fire element in Yama 1)',
    },
    {
      'id': 'tattva-04',
      'input': {
        'time': '2026-10-03T07:40:00+05:30',
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (Air element in Yama 1)',
    },
    {
      'id': 'tattva-05',
      'input': {
        'time': '2026-10-03T08:10:00+05:30',
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (Ether element in Yama 1)',
    },
  ];

  final evaluatedTattva = tattvaCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final time = DateTime.parse(input['time'] as String);
    final sunrise = DateTime.parse(input['sunrise'] as String);
    final sunset = DateTime.parse(input['sunset'] as String);

    final yamaResult = YamaCalculator.calculate(
      sunrise: sunrise,
      sunset: sunset,
    );
    final yamaSegment = yamaResult.activeYama(time);
    if (yamaSegment == null) {
      throw StateError('Yama calculation returned null for ${c['id']}');
    }
    final tattvaRes = TattvaCalculator.activeTattva(
      time: time,
      yamaSegment: yamaSegment,
    );
    if (tattvaRes == null) {
      throw StateError('Tattva calculation returned null for ${c['id']}');
    }
    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'tattva': tattvaRes.tattva.name,
        'index': tattvaRes.index,
        'yama': tattvaRes.yama.name,
      },
      'source': c['source'],
    };
  }).toList();

  // ─── 6. Oracle cases ───────────────────────────────────────────────────────
  final oracleCases = [
    {
      'id': 'oracle-01',
      'input': {
        'queryTime': '2026-07-05T06:30:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0,
        'currentBirdState': 'ruling',
        'currentWindow': 'artha',
        'tarabalaMultiplier': 1.0,
        'horaSwaraMultiplier': 1.0,
        'category': 'artha',
        'actualSwara': 'solar',
      },
      'tolerance': 1e-9,
      'source': 'Sprint 31/38 Integrated Aruḍam composite (Siddha band)',
    },
    {
      'id': 'oracle-02',
      'input': {
        'queryTime': '2026-07-05T06:30:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0,
        'currentBirdState': 'eating',
        'currentWindow': 'kriya',
        'tarabalaMultiplier': 1.0,
        'horaSwaraMultiplier': 1.0,
        'category': 'kriya',
        'actualSwara': 'lunar',
      },
      'tolerance': 1e-9,
      'source': 'Sprint 31/38 Integrated Aruḍam composite (Vardhana band)',
    },
    {
      'id': 'oracle-03',
      'input': {
        'queryTime': '2026-07-05T06:30:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0,
        'currentBirdState': 'sleeping',
        'currentWindow': 'yoga',
        'tarabalaMultiplier': 1.0,
        'horaSwaraMultiplier': 0.8,
        'category': 'artha',
        'actualSwara': 'lunar',
      },
      'tolerance': 1e-9,
      'source': 'Sprint 31/38 Integrated Aruḍam composite',
    },
    {
      'id': 'oracle-04',
      'input': {
        'queryTime': '2026-07-05T06:30:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0,
        'currentBirdState': 'dying',
        'currentWindow': 'yoga',
        'tarabalaMultiplier': 0.7,
        'horaSwaraMultiplier': 0.6,
        'category': 'artha',
        'actualSwara': 'lunar',
      },
      'tolerance': 1e-9,
      'source': 'Sprint 31/38 Integrated Aruḍam composite',
    },
    {
      'id': 'oracle-05',
      'input': {
        'queryTime': '2026-07-05T17:00:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0, // Sunday segment 8 is Rahu Kaal -> floor locked
        'currentBirdState': 'ruling',
        'currentWindow': 'artha',
        'tarabalaMultiplier': 1.0,
        'horaSwaraMultiplier': 1.0,
        'category': 'artha',
        'actualSwara': 'solar',
      },
      'tolerance': 1e-9,
      'source': 'PP-ORACLE Rahu Kaal floor lock (CONF-014/015)',
    },
  ];

  final evaluatedOracle = oracleCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final birdState = PakshiState.values.byName(input['currentBirdState'] as String);
    final window = ActionWindow.values.byName(input['currentWindow'] as String);
    final category = QueryCategory.values.byName(input['category'] as String);

    final res = OracleCompositeEngine.evaluate(
      queryTime: DateTime.parse(input['queryTime'] as String),
      sunrise: DateTime.parse(input['sunrise'] as String),
      sunset: DateTime.parse(input['sunset'] as String),
      weekday: input['weekday'] as int,
      currentBirdState: birdState,
      currentWindow: window,
      tarabalaMultiplier: (input['tarabalaMultiplier'] as num).toDouble(),
      horaSwaraMultiplier: (input['horaSwaraMultiplier'] as num).toDouble(),
      category: category,
      actualSwara: input['actualSwara'] as String,
    );

    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'score': res.score,
        'band': res.band.name,
        'isFloorLocked': res.isFloorLocked,
      },
      'tolerance': c['tolerance'],
      'source': c['source'],
    };
  }).toList();

  return {
    'meta': {
      'generated': '2026-10-03',
      'engineVersion': 'v1.13.0',
      'note': 'known-correct outputs; regen via tool/regen_golden.dart',
      'totalCases': evaluatedMoon.length +
          evaluatedNakshatra.length +
          evaluatedSwara.length +
          evaluatedHora.length +
          evaluatedTattva.length +
          evaluatedOracle.length,
    },
    'moonLongitude': evaluatedMoon,
    'nakshatra': evaluatedNakshatra,
    'swara': evaluatedSwara,
    'hora': evaluatedHora,
    'tattva': evaluatedTattva,
    'oracle': evaluatedOracle,
  };
}

void writeGoldenFile({String targetPath = 'test/golden/astro_golden.json'}) {
  final data = generateGoldenFixture();
  const encoder = JsonEncoder.withIndent('  ');
  final jsonString = encoder.convert(data);

  final file = File(targetPath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync('$jsonString\n');
  // Standalone CLI generator needs to print progress to stdout.
  // ignore: avoid_print
  print('✅ Successfully wrote golden fixture to $targetPath (${(data['meta'] as Map)['totalCases']} cases)');
}

void main() {
  test('regenerate astro golden fixture', () {
    writeGoldenFile();
    expect(File('test/golden/astro_golden.json').existsSync(), isTrue);
  });
}
