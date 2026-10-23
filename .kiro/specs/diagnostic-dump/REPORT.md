<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/diagnostic-dump/REPORT.md
  Verification log for the diagnostic-dump Spec.
-->
# Saranidhi Diagnostic Dump — Verification Report

Spec: `.kiro/specs/diagnostic-dump/` · Spec ID: `diagnostic-dump` · Branch `sprint/diagnostic-dump` → `main`.
Epic: Accuracy & Validation (`BACKLOG.md` → "Accuracy & Validation", `🟡 ⬜ Saranidhi diagnostic dump`).

### Preflight & Seam Read (T0)

- **OQ-1 (Night state table accessor):** Resolved cleanly. `PakshiCalculator.calculateNight(weekday: ..., lunarPhase: ...)` already exists and returns `PakshiDayResult` containing both `entries` (ruling bird per night yama) and `stateTable` (5×5 table of all birds' states per night yama). The night state for any bird is directly callable via `stateForBird(bird, yama)` without any engine modification.
- **OQ-2 (Argument parsing dependency):** Resolved. `package:args` is not in `pubspec.yaml`; argument parsing is hand-rolled in `tool/dump_diagnostic.dart` with zero new dependencies, supporting `--flag value`, `--flag=value`, `-h`, and `--help`.
- **OQ-3 (Location input & UTC offset):** Resolved. `--lat` and `--lng` are required flags. Timezone offset defaults to `TimezoneUtils.offsetForLocation(latitude: lat, longitude: lng)` (IST = 5.5 for India, longitude-derived for other regions), with an optional `--utc-offset` override.
- **Zero `lib/` changes:** All engines (`PakshiCalculator`, `YamaCalculator`, `SunriseCalculator`, `LunarPhaseCalculator`, `NakshatraCalculator`, `TimezoneUtils`) are pure Dart and called strictly via existing public APIs. `git diff main...HEAD -- lib/ test/golden/` is completely empty.

### EARS Definition of Done Verification

| Requirement | Result | Evidence / Finding |
| :--- | :---: | :--- |
| **R1.1** (7 days × 10 yamas) | ✅ PASS | Generates exactly 70 records covering Y1–Y5 (day) and Y6–Y10 (night) via `calculateNight`. |
| **R1.2** (Yama record fields) | ✅ PASS | Each yama record contains `date`, `index` (1–10), `start`, `end`, `rulingBird`, `subjectBird`, and `subjectState`. |
| **R1.3** (Day record fields) | ✅ PASS | Each day record contains `date`, `weekday`, `sunrise`, `sunset`, `lunarPhase`, and `nakshatra`. |
| **R1.4** (Subject bird default) | ✅ PASS | Defaults to `owl` (CONF-PP-001/002); invalid bird exits non-zero (code 1) with valid bird list. |
| **R2.1** (Format JSON & MD) | ✅ PASS | Supports `--format json` (default) and `--format md` (GitHub table). |
| **R2.2** (JSON determinism) | ✅ PASS | Alphabetically sorted keys; two runs on identical inputs produce byte-identical JSON. Pinned by unit test. |
| **R2.3** (Output destination) | ✅ PASS | Emits to stdout by default; writes to `--out <path>` when specified; no unauthorized writes. |
| **R3.1** (Read-only / offline) | ✅ PASS | Zero writes under `lib/` or `test/`, no network calls, offline pure Dart. |
| **R3.2** (Independent of golden) | ✅ PASS | Does not import `regen_golden.dart` or any golden fixture files. |
| **R3.3** (CLI usage) | ✅ PASS | `dart run tool/dump_diagnostic.dart --help` prints usage and exits zero. |
| **R4.1** (No `lib/` or golden diff) | ✅ PASS | `git diff main...HEAD -- lib/ test/golden/` is empty. |
| **R4.2** (Golden suite green) | ✅ PASS | All 66 tests (57 golden cases + independent-truth suite) pass green. |
| **RT** (Tamil mode) | N/A | Developer CLI tool; no user-facing UI or application strings. |
| **RC** (CONF provenance) | ✅ PASS | Subject bird default (Owl) traces to CONF-PP-001/002; reports engine output; asserts no new doctrine. |
| **RQ** (Quality gates) | ✅ PASS | `just validate-local` green: analyze clean (`very_good_analysis`, zero `--fatal-infos`), tests green except 4 known CloudKit macOS baseline, coverage 42.9% (>= 19%), web build compiles. |

### Verification Sample (7-Day Markdown Output)

Command executed:
```bash
dart run tool/dump_diagnostic.dart --bird owl --lat 13.0827 --lng 80.2707 --start 2026-10-23 --days 7 --format md
```

Output:
```markdown
# Saranidhi Diagnostic Dump

- **Bird:** owl
- **Latitude:** 13.0827
- **Longitude:** 80.2707
- **Start Date:** 2026-10-23
- **Days:** 7

| Date | Weekday | Yama | Start | End | Ruling Bird | Subject Bird | Subject State | Sunrise | Sunset | Lunar Phase | Nakshatra |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-10-23 | Fri | 1 | 2026-10-23T06:00:00.000 | 2026-10-23T08:21:12.000 | crow | owl | dying | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 2 | 2026-10-23T08:21:12.000 | 2026-10-23T10:42:24.000 | owl | owl | ruling | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 3 | 2026-10-23T10:42:24.000 | 2026-10-23T13:03:36.000 | peacock | owl | walking | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 4 | 2026-10-23T13:03:36.000 | 2026-10-23T15:24:48.000 | vulture | owl | eating | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 5 | 2026-10-23T15:24:48.000 | 2026-10-23T17:46:00.000 | rooster | owl | sleeping | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 6 | 2026-10-23T17:46:00.000 | 2026-10-23T20:13:00.000 | vulture | owl | eating | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 7 | 2026-10-23T20:13:00.000 | 2026-10-23T22:40:00.000 | peacock | owl | walking | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 8 | 2026-10-23T22:40:00.000 | 2026-10-24T01:07:00.000 | rooster | owl | sleeping | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 9 | 2026-10-24T01:07:00.000 | 2026-10-24T03:34:00.000 | crow | owl | dying | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-23 | Fri | 10 | 2026-10-24T03:34:00.000 | 2026-10-24T06:01:00.000 | owl | owl | ruling | 2026-10-23T06:00:00.000 | 2026-10-23T17:46:00.000 | waxing | Purva Bhadrapada |
| 2026-10-24 | Sat | 1 | 2026-10-24T06:01:00.000 | 2026-10-24T08:21:48.000 | peacock | owl | eating | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 2 | 2026-10-24T08:21:48.000 | 2026-10-24T10:42:36.000 | vulture | owl | walking | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 3 | 2026-10-24T10:42:36.000 | 2026-10-24T13:03:24.000 | owl | owl | ruling | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 4 | 2026-10-24T13:03:24.000 | 2026-10-24T15:24:12.000 | rooster | owl | sleeping | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 5 | 2026-10-24T15:24:12.000 | 2026-10-24T17:45:00.000 | crow | owl | dying | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 6 | 2026-10-24T17:45:00.000 | 2026-10-24T20:12:12.000 | crow | owl | dying | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 7 | 2026-10-24T20:12:12.000 | 2026-10-24T22:39:24.000 | owl | owl | ruling | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 8 | 2026-10-24T22:39:24.000 | 2026-10-25T01:06:36.000 | rooster | owl | sleeping | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 9 | 2026-10-25T01:06:36.000 | 2026-10-25T03:33:48.000 | vulture | owl | eating | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-24 | Sat | 10 | 2026-10-25T03:33:48.000 | 2026-10-25T06:01:00.000 | peacock | owl | walking | 2026-10-24T06:01:00.000 | 2026-10-24T17:45:00.000 | waxing | Uttara Bhadrapada |
| 2026-10-25 | Sun | 1 | 2026-10-25T06:01:00.000 | 2026-10-25T08:21:48.000 | vulture | owl | eating | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 2 | 2026-10-25T08:21:48.000 | 2026-10-25T10:42:36.000 | owl | owl | ruling | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 3 | 2026-10-25T10:42:36.000 | 2026-10-25T13:03:24.000 | rooster | owl | dying | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 4 | 2026-10-25T13:03:24.000 | 2026-10-25T15:24:12.000 | crow | owl | walking | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 5 | 2026-10-25T15:24:12.000 | 2026-10-25T17:45:00.000 | peacock | owl | sleeping | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 6 | 2026-10-25T17:45:00.000 | 2026-10-25T20:12:12.000 | peacock | owl | sleeping | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 7 | 2026-10-25T20:12:12.000 | 2026-10-25T22:39:24.000 | vulture | owl | eating | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 8 | 2026-10-25T22:39:24.000 | 2026-10-26T01:06:36.000 | crow | owl | walking | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 9 | 2026-10-26T01:06:36.000 | 2026-10-26T03:33:48.000 | rooster | owl | dying | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-25 | Sun | 10 | 2026-10-26T03:33:48.000 | 2026-10-26T06:01:00.000 | owl | owl | ruling | 2026-10-25T06:01:00.000 | 2026-10-25T17:45:00.000 | waxing | Revati |
| 2026-10-26 | Mon | 1 | 2026-10-26T06:01:00.000 | 2026-10-26T08:21:48.000 | peacock | owl | eating | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 2 | 2026-10-26T08:21:48.000 | 2026-10-26T10:42:36.000 | vulture | owl | walking | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 3 | 2026-10-26T10:42:36.000 | 2026-10-26T13:03:24.000 | owl | owl | ruling | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 4 | 2026-10-26T13:03:24.000 | 2026-10-26T15:24:12.000 | rooster | owl | sleeping | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 5 | 2026-10-26T15:24:12.000 | 2026-10-26T17:45:00.000 | crow | owl | dying | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 6 | 2026-10-26T17:45:00.000 | 2026-10-26T20:12:12.000 | crow | owl | dying | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 7 | 2026-10-26T20:12:12.000 | 2026-10-26T22:39:24.000 | owl | owl | ruling | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 8 | 2026-10-26T22:39:24.000 | 2026-10-27T01:06:36.000 | rooster | owl | sleeping | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 9 | 2026-10-27T01:06:36.000 | 2026-10-27T03:33:48.000 | vulture | owl | eating | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-26 | Mon | 10 | 2026-10-27T03:33:48.000 | 2026-10-27T06:01:00.000 | peacock | owl | walking | 2026-10-26T06:01:00.000 | 2026-10-26T17:45:00.000 | waxing | Ashwini |
| 2026-10-27 | Tue | 1 | 2026-10-27T06:01:00.000 | 2026-10-27T08:21:36.000 | rooster | owl | dying | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 2 | 2026-10-27T08:21:36.000 | 2026-10-27T10:42:12.000 | vulture | owl | sleeping | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 3 | 2026-10-27T10:42:12.000 | 2026-10-27T13:02:48.000 | owl | owl | ruling | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 4 | 2026-10-27T13:02:48.000 | 2026-10-27T15:23:24.000 | crow | owl | walking | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 5 | 2026-10-27T15:23:24.000 | 2026-10-27T17:44:00.000 | peacock | owl | eating | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 6 | 2026-10-27T17:44:00.000 | 2026-10-27T20:11:36.000 | peacock | owl | eating | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 7 | 2026-10-27T20:11:36.000 | 2026-10-27T22:39:12.000 | crow | owl | dying | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 8 | 2026-10-27T22:39:12.000 | 2026-10-28T01:06:48.000 | rooster | owl | walking | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 9 | 2026-10-28T01:06:48.000 | 2026-10-28T03:34:24.000 | owl | owl | ruling | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-27 | Tue | 10 | 2026-10-28T03:34:24.000 | 2026-10-28T06:02:00.000 | vulture | owl | sleeping | 2026-10-27T06:01:00.000 | 2026-10-27T17:44:00.000 | waning | Bharani |
| 2026-10-28 | Wed | 1 | 2026-10-28T06:02:00.000 | 2026-10-28T08:22:24.000 | owl | owl | ruling | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 2 | 2026-10-28T08:22:24.000 | 2026-10-28T10:42:48.000 | rooster | owl | eating | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 3 | 2026-10-28T10:42:48.000 | 2026-10-28T13:03:12.000 | crow | owl | dying | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 4 | 2026-10-28T13:03:12.000 | 2026-10-28T15:23:36.000 | vulture | owl | sleeping | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 5 | 2026-10-28T15:23:36.000 | 2026-10-28T17:44:00.000 | peacock | owl | walking | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 6 | 2026-10-28T17:44:00.000 | 2026-10-28T20:11:36.000 | rooster | owl | walking | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 7 | 2026-10-28T20:11:36.000 | 2026-10-28T22:39:12.000 | vulture | owl | dying | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 8 | 2026-10-28T22:39:12.000 | 2026-10-29T01:06:48.000 | peacock | owl | eating | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 9 | 2026-10-29T01:06:48.000 | 2026-10-29T03:34:24.000 | owl | owl | ruling | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-28 | Wed | 10 | 2026-10-29T03:34:24.000 | 2026-10-29T06:02:00.000 | crow | owl | sleeping | 2026-10-28T06:02:00.000 | 2026-10-28T17:44:00.000 | waning | Krittika |
| 2026-10-29 | Thu | 1 | 2026-10-29T06:02:00.000 | 2026-10-29T08:22:12.000 | vulture | owl | sleeping | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 2 | 2026-10-29T08:22:12.000 | 2026-10-29T10:42:24.000 | crow | owl | walking | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 3 | 2026-10-29T10:42:24.000 | 2026-10-29T13:02:36.000 | rooster | owl | eating | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 4 | 2026-10-29T13:02:36.000 | 2026-10-29T15:22:48.000 | peacock | owl | dying | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 5 | 2026-10-29T15:22:48.000 | 2026-10-29T17:43:00.000 | owl | owl | ruling | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 6 | 2026-10-29T17:43:00.000 | 2026-10-29T20:10:48.000 | owl | owl | ruling | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 7 | 2026-10-29T20:10:48.000 | 2026-10-29T22:38:36.000 | rooster | owl | eating | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 8 | 2026-10-29T22:38:36.000 | 2026-10-30T01:06:24.000 | vulture | owl | sleeping | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 9 | 2026-10-30T01:06:24.000 | 2026-10-30T03:34:12.000 | crow | owl | walking | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
| 2026-10-29 | Thu | 10 | 2026-10-30T03:34:12.000 | 2026-10-30T06:02:00.000 | rooster | owl | dying | 2026-10-29T06:02:00.000 | 2026-10-29T17:43:00.000 | waning | Rohini |
```

### Evidence Summary (Four Questions)

1. **What am I accepting?** A read-only CLI utility `tool/dump_diagnostic.dart` and its unit test `test/tool/dump_diagnostic_test.dart` that generates a 7-day report of all 10 yamas per day (ruling bird, subject-bird state, sunrise, sunset, lunar phase, nakshatra) in deterministic JSON or Markdown table format.
2. **What could it affect?** No production runtime paths. Zero changes in `lib/` or `test/golden/`. Blast radius is strictly isolated to `tool/dump_diagnostic.dart` and `test/tool/dump_diagnostic_test.dart`.
3. **Why believe it works?**
   - Unit tests assert 70-row shape, valid indices, sunrise-to-sunset daytime constraints, sunset-to-next-sunrise nighttime constraints, and determinism across runs.
   - Golden test suite (66 tests) remains 100% green.
   - `just validate-local` quality gate passed all 4 checks: `dart analyze --fatal-infos` clean (zero issues), `flutter test --coverage` 42.9% (>= 19%), and `flutter build web` compiles cleanly.
4. **What remains unresolved?** None for this tool. Data collection from external sources (Align27 and Tamil Panchangam) is the next owner task in the Accuracy & Validation epic; the CONF-018 miscitation noted in `tasks.md` remains flagged for its own unit.
