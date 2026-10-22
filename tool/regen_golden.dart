// tool/regen_golden.dart
//
// Controlled Golden-Fixture Regeneration Tool (Task T3 / Requirement R4).
//
// ⚠️ MANUALLY RUN ONLY — NEVER AUTOMATIC, NEVER RUN IN CI.
// Changing a golden value is a human decision that must be recorded in the PR
// (and, when doctrinal, in the Decision Journal and relevant CONF document).
// Implementing agents must not control their own acceptance values.
//
// ─── INDEPENDENT-TRUTH GUARD (golden-fixture-gate-v2, R1.4) ───────────────────
// This tool regenerates ONLY `test/golden/astro_golden.json` (engine snapshots).
// It NEVER opens, reads, or writes `test/golden/astro_independent.json`.
// The independent-truth cases are hand-authored literals transcribed from external
// sources (Meeus's printed worked example; the canonical CONF-PP-001 5-6-5-5-6 star
// table) — they are NEVER regenerated, because regenerating them from the engine
// would re-introduce the self-reference that golden-fixture-gate-v2 removed (an
// engine that writes its own expectations can only ever confirm it still matches
// yesterday, never that it matches the corpus). Do NOT add the independent file here.
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
    // ─── R2.5: peacock appears >= 2x in the snapshot section ─────────────────
    // (snapshot coverage; the independent-truth peacock proof lives in
    //  astro_independent.json). DOBs chosen to land on peacock stars.
    {
      'id': 'nak-09',
      'input': {'dob': '2024-04-07T18:00:00Z'}, // mid uttara bhadrapada (peacock)
      'source': 'CONF-PP-001 / CONF-PP-002 (peacock coverage, Uttara Bhadrapada) [R2.5]',
    },
    {
      'id': 'nak-10',
      'input': {'dob': '2024-06-02T09:00:00Z'}, // mid revati (peacock)
      'source': 'CONF-PP-001 / CONF-PP-002 (peacock coverage, Revati) [R2.5]',
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

  // ─── 2b. Nakshatra END-TO-END (R2.5): longitude -> nakshatra -> bird ──────
  // Records the full chain for ONE datetime: raw Moon longitude, the derived
  // nakshatra, and the final bird — so a single case pins the whole pipeline.
  final nakshatraEndToEndCases = [
    {
      'id': 'nak-e2e-01',
      'input': {'datetime': '2024-06-02T09:00:00Z'},
      'tolerance': 1e-6,
      'source': 'End-to-end longitude->nakshatra->bird chain (Revati/Peacock) [R2.5]',
    },
  ];

  final evaluatedNakshatraE2E = nakshatraEndToEndCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final dt = DateTime.parse(input['datetime'] as String);
    final lon = MoonLongitudeCalculator.calculate(dt).longitude;
    final nak = NakshatraCalculator.calculate(dt);
    final bird = PakshiCalculator.birthBirdFromNakshatra(nak.standardName);
    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'longitude': lon,
        'standardName': nak.standardName,
        'birthBird': bird.name,
      },
      'tolerance': c['tolerance'],
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
    // ─── R2.7: late-day alternating-block flip (deep into the day) ───────────
    {
      'id': 'swara-10',
      'input': {
        'time': '2026-07-05T16:30:00+05:30', // ~10.5h after Sunday sunrise
        'sunrise': '2026-07-05T06:00:00+05:30',
        'paksha': 'shukla',
      },
      'source': 'CONF-014 (Sunday late-day alternating-block flip, hour ~10) [R2.7]',
    },
    // ─── R2.7: PRE-DAWN case — exercises SwaraClock.anchorSunrise ────────────
    // time is BEFORE the calendar date's sunrise, so the governing civil day
    // began at YESTERDAY's sunrise. The test resolves the anchored sunrise via
    // SwaraClock.anchorSunrise using the sunriseByDate map below (R2.7).
    {
      'id': 'swara-11',
      'input': {
        'time': '2026-07-06T02:00:00+05:30', // pre-dawn Monday (before 06:00)
        'paksha': 'shukla',
        'anchor': {
          // ISO date (yyyy-MM-dd) -> that date's sunrise
          'sunriseByDate': {
            '2026-07-06': '2026-07-06T06:00:00+05:30',
            '2026-07-05': '2026-07-05T06:00:00+05:30',
          },
        },
      },
      'source': 'CONF-001/CONF-013 (pre-dawn anchorSunrise: governing day is Sunday) [R2.7]',
    },
  ];

  DateTime anchoredSunriseForSwara(Map<String, dynamic> input) {
    final anchor = input['anchor'] as Map<String, dynamic>?;
    if (anchor == null) {
      return DateTime.parse(input['sunrise'] as String);
    }
    final byDate = (anchor['sunriseByDate'] as Map).cast<String, String>();
    final time = DateTime.parse(input['time'] as String);
    return SwaraClock.anchorSunrise(
      time: time,
      sunriseForDate: (date) {
        final key =
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final iso = byDate[key];
        if (iso == null) {
          throw StateError('No sunrise mapping for date $key in swara anchor case');
        }
        return DateTime.parse(iso);
      },
    );
  }

  final evaluatedSwara = swaraCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final time = DateTime.parse(input['time'] as String);
    final sunrise = anchoredSunriseForSwara(input);
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
    // ─── R2.6: complete the 7 weekday day-lords (Wed, Thu, Sat missing) ──────
    {
      'id': 'hora-06',
      'input': {
        'time': '2026-07-08T06:15:00+05:30',
        'sunrise': '2026-07-08T06:00:00+05:30',
        'sunset': '2026-07-08T18:00:00+05:30',
        'nextSunrise': '2026-07-09T06:00:00+05:30',
        'weekday': 3, // Wednesday day lord Mercury
      },
      'source': 'Chaldean Planetary Hours order (Wednesday day lord Mercury) [R2.6]',
    },
    {
      'id': 'hora-07',
      'input': {
        'time': '2026-07-09T06:15:00+05:30',
        'sunrise': '2026-07-09T06:00:00+05:30',
        'sunset': '2026-07-09T18:00:00+05:30',
        'nextSunrise': '2026-07-10T06:00:00+05:30',
        'weekday': 4, // Thursday day lord Jupiter
      },
      'source': 'Chaldean Planetary Hours order (Thursday day lord Jupiter) [R2.6]',
    },
    {
      'id': 'hora-08',
      'input': {
        'time': '2026-07-11T06:15:00+05:30',
        'sunrise': '2026-07-11T06:00:00+05:30',
        'sunset': '2026-07-11T18:00:00+05:30',
        'nextSunrise': '2026-07-12T06:00:00+05:30',
        'weekday': 6, // Saturday day lord Saturn
      },
      'source': 'Chaldean Planetary Hours order (Saturday day lord Saturn) [R2.6]',
    },
    {
      'id': 'hora-10',
      'input': {
        'time': '2026-07-07T06:15:00+05:30',
        'sunrise': '2026-07-07T06:00:00+05:30',
        'sunset': '2026-07-07T18:00:00+05:30',
        'nextSunrise': '2026-07-08T06:00:00+05:30',
        'weekday': 2, // Tuesday day lord Mars
      },
      'source': 'Chaldean Planetary Hours order (Tuesday day lord Mars) [R2.6]',
    },
    {
      'id': 'hora-11',
      'input': {
        'time': '2026-07-10T06:15:00+05:30',
        'sunrise': '2026-07-10T06:00:00+05:30',
        'sunset': '2026-07-10T18:00:00+05:30',
        'nextSunrise': '2026-07-11T06:00:00+05:30',
        'weekday': 5, // Friday day lord Venus (first day hora)
      },
      'source': 'Chaldean Planetary Hours order (Friday day lord Venus) [R2.6]',
    },
    // ─── R2.6: day -> night boundary hora (first night hora, isDayHora flip) ──
    {
      'id': 'hora-09',
      'input': {
        'time': '2026-07-05T18:05:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'nextSunrise': '2026-07-06T06:00:00+05:30',
        'weekday': 0, // Sunday, just after sunset -> first NIGHT hora
      },
      'source': 'Chaldean Planetary Hours order (Sunday day->night boundary, first night hora) [R2.6]',
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
    // ─── R2.2: tattva cases landing in yama2..yama5 (not just yama1) ─────────
    // Day 2026-10-03: sunrise 06:00, sunset 18:00 -> 5 yamas of 2h24m each.
    // yama2 08:24-10:48, yama3 10:48-13:12, yama4 13:12-15:36, yama5 15:36-18:00.
    {
      'id': 'tattva-06',
      'input': {
        'time': '2026-10-03T09:00:00+05:30', // yama2
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (tattva in Yama 2) [R2.2]',
    },
    {
      'id': 'tattva-07',
      'input': {
        'time': '2026-10-03T11:30:00+05:30', // yama3
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (tattva in Yama 3) [R2.2]',
    },
    {
      'id': 'tattva-08',
      'input': {
        'time': '2026-10-03T14:00:00+05:30', // yama4
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (tattva in Yama 4) [R2.2]',
    },
    {
      'id': 'tattva-09',
      'input': {
        'time': '2026-10-03T16:30:00+05:30', // yama5
        'sunrise': '2026-10-03T06:00:00+05:30',
        'sunset': '2026-10-03T18:00:00+05:30',
      },
      'source': 'CONF-012 (tattva in Yama 5) [R2.2]',
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

  // ─── 5b. NIGHT tattva (R2.1): calculateNight -> NightYamaResult -> tattva ──
  // Night 2026-10-03 18:00 -> 2026-10-04 06:00 (12h) -> 5 night yamas of 2h24m.
  // yama6 18:00-20:24, yama7 20:24-22:48, yama8 22:48-01:12, yama9 01:12-03:36,
  // yama10 03:36-06:00. The tattva (5-element) cycle subdivides each night yama
  // identically to the daytime path; TattvaCalculator.activeTattva consumes a
  // YamaSegment, so the night segment's [start,end] is wrapped into one for the
  // computation while the recorded `yama` is the authentic NightYamaIndex label.
  final nightTattvaCases = [
    {
      'id': 'tattva-night-01',
      'input': {
        'time': '2026-10-03T18:30:00+05:30', // night yama6, element 1 (earth)
        'sunset': '2026-10-03T18:00:00+05:30',
        'nextSunrise': '2026-10-04T06:00:00+05:30',
        'night': true,
      },
      'source': 'CONF-012 (night tattva in Night Yama 6) [R2.1]',
    },
    {
      'id': 'tattva-night-02',
      'input': {
        'time': '2026-10-03T21:30:00+05:30', // night yama7
        'sunset': '2026-10-03T18:00:00+05:30',
        'nextSunrise': '2026-10-04T06:00:00+05:30',
        'night': true,
      },
      'source': 'CONF-012 (night tattva in Night Yama 7) [R2.1]',
    },
  ];

  final evaluatedNightTattva = nightTattvaCases.map((c) {
    final input = c['input']! as Map<String, dynamic>;
    final time = DateTime.parse(input['time'] as String);
    final sunset = DateTime.parse(input['sunset'] as String);
    final nextSunrise = DateTime.parse(input['nextSunrise'] as String);

    final nightResult = YamaCalculator.calculateNight(
      sunset: sunset,
      nextSunrise: nextSunrise,
    );
    final nightSegment = nightResult.activeYama(time);
    if (nightSegment == null) {
      throw StateError('Night yama calculation returned null for ${c['id']}');
    }
    // Wrap the night segment as a daytime YamaSegment for the shared tattva
    // sub-division math (positional index yama1..yama5 is irrelevant here — only
    // start/end drive activeTattva; the recorded `yama` below is the true label).
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
      throw StateError('Night tattva calculation returned null for ${c['id']}');
    }
    return {
      'id': c['id'],
      'input': input,
      'expected': {
        'tattva': tattvaRes.tattva.name,
        'index': tattvaRes.index,
        'yama': nightSegment.index.name, // authentic NightYamaIndex label (yama6..)
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
    // ─── R2.3: Sushumna recorded flow INSIDE the Yoga window (isAligned) ─────
    // Query at 10:00 Sunday (segment 3 — neither Rahu seg8 nor Emakandam seg5),
    // Yoga window + recorded sushumna -> ActionWindow.isSushumnaAligned == true.
    {
      'id': 'oracle-06',
      'input': {
        'queryTime': '2026-07-05T10:00:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0,
        'currentBirdState': 'sleeping', // -> yoga
        'currentWindow': 'yoga',
        'tarabalaMultiplier': 1.0,
        'horaSwaraMultiplier': 1.0,
        'category': 'yoga',
        'actualSwara': 'sushumna',
      },
      'tolerance': 1e-9,
      'source': 'Sushumna aligned in Yoga window (oracle_engine.dart:116-118) [R2.3]',
    },
    // ─── R2.3: Sushumna recorded flow OUTSIDE the Yoga window (not aligned) ──
    // Same clean segment 3, but Artha window -> isSushumnaAligned == false.
    {
      'id': 'oracle-07',
      'input': {
        'queryTime': '2026-07-05T10:00:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0,
        'currentBirdState': 'ruling', // -> artha
        'currentWindow': 'artha',
        'tarabalaMultiplier': 1.0,
        'horaSwaraMultiplier': 1.0,
        'category': 'artha',
        'actualSwara': 'sushumna',
      },
      'tolerance': 1e-9,
      'source': 'Sushumna NOT aligned outside Yoga window (oracle_engine.dart:116-118) [R2.3]',
    },
    // ─── R2.4: Emakandam-active lockout ──────────────────────────────────────
    // Sunday Emakandam = daylight segment 5 (daylight_segment_resolver:[5,...]).
    // 12h daylight 06:00-18:00 -> segment 5 = 12:00-13:30; query 12:30 -> locked.
    {
      'id': 'oracle-08',
      'input': {
        'queryTime': '2026-07-05T12:30:00+05:30',
        'sunrise': '2026-07-05T06:00:00+05:30',
        'sunset': '2026-07-05T18:00:00+05:30',
        'weekday': 0, // Sunday Emakandam segment 5 -> floor locked
        'currentBirdState': 'ruling',
        'currentWindow': 'artha',
        'tarabalaMultiplier': 1.0,
        'horaSwaraMultiplier': 1.0,
        'category': 'artha',
        'actualSwara': 'solar',
      },
      'tolerance': 1e-9,
      'source': 'Emakandam lockout (oracle_engine.dart:71 isEmakandamActive) [R2.4]',
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
          evaluatedNakshatraE2E.length +
          evaluatedSwara.length +
          evaluatedHora.length +
          evaluatedTattva.length +
          evaluatedNightTattva.length +
          evaluatedOracle.length,
    },
    'moonLongitude': evaluatedMoon,
    'nakshatra': evaluatedNakshatra,
    'nakshatraEndToEnd': evaluatedNakshatraE2E,
    'swara': evaluatedSwara,
    'hora': evaluatedHora,
    'tattva': evaluatedTattva,
    'tattvaNight': evaluatedNightTattva,
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
