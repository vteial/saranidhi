# Saranidhi Diagnostic Dump — Requirements

> **Spec id:** `diagnostic-dump`
> **Class:** sprint deliverable (correctness-*adjacent* — reads the engine, changes no engine logic).
> **Epic:** Accuracy & Validation (`BACKLOG.md` → "Accuracy & Validation", the `🟡 ⬜ Saranidhi
> diagnostic dump` row). This is the FIRST deliverable of that epic and the tool that **unblocks the
> owner's data-collection prerequisite**: it generates Saranidhi's own "Saranidhi" column of the
> three-way comparison matrix (Saranidhi vs Align27 vs Tamil Panchangam).
> **Vehicle:** `/spec-run` → Executor (Antigravity) → `/review-pr` → owner merge.

## Current-state facts (verified against the repo, HEAD `297cb46`)

- The engines the dump reads already ship and are pure Dart:
  `pakshi_calculator.dart` (`PakshiDayResult`, `PakshiBird`, `PakshiState`, 5×yama `stateTable`),
  `yama_calculator.dart` (day Y1–Y5 + `NightYamaResult` Y6–Y10 via `calculateNight`),
  `sunrise_calculator.dart`, `lunar_phase_calculator.dart` (`LunarPhase.waxing/waning`),
  `nakshatra_calculator.dart`, `swara_clock.dart`, `tattva_calculator.dart`.
- The only existing `tool/` script is `regen_golden.dart` (snapshot regen). **No diagnostic/export
  tool exists yet.** The dump is a NEW `tool/` script — additive, no `lib/` change.
- The three-way matrix is a human/owner artifact; Saranidhi must emit its column in a shape that
  slots straight in (one row per yama per day, machine- and eyeball-readable).

## Scope

**In:** a read-only CLI script `tool/dump_diagnostic.dart` that, given a bird, location (lat/lng),
and a start date + day-count, prints/writes a 7-day (default) report of Saranidhi's own engine output.

**Out of scope (flag, don't fold):**
- Any `lib/` engine change, any calibration/tuning of the readiness penalty (that is the epic's LAST
  task and needs the measured data).
- The Align27 / Panchangam data collection itself (owner task — the separate collection plan).
- The `integrated_arudam_engine.dart` **CONF-018 miscitation** the epic notes — real, but it belongs
  to the Swara-Clock/Aruḍam context, NOT this dump. Left untouched; flagged for its own unit.

## EARS Definition of Done

### R1 — Full 7-day engine output
- **R1.1** WHEN run with `--bird <name> --lat <x> --lng <y> --start <ISO date> [--days N]`, the tool
  SHALL emit, for each of N days (default 7), one record per yama covering **all 10 yamas** (day
  Y1–Y5 via the day engine, night Y6–Y10 via `calculateNight`).
- **R1.2** Each yama record SHALL carry: date, yama index (1–10), yama start/end local times, the
  **ruling bird**, and the **subject bird's state** (`ruling/eating/walking/sleeping/dying`) read
  from the `stateTable`.
- **R1.3** Each day record SHALL carry: sunrise, sunset, weekday, lunar phase (`waxing/waning`), and
  the day's nakshatra — the fields the three-way matrix diffs against Align27/Panchangam.
- **R1.4** The subject bird SHALL default to the CLI `--bird` (the owner's corrected bird per
  CONF-PP-001/002 is **Owl**); an invalid bird name SHALL exit non-zero with the valid list.

### R2 — Matrix-ready output
- **R2.1** The tool SHALL support `--format json` (default) and `--format md` (a GitHub-renderable
  table) so the owner can paste it straight into the comparison matrix.
- **R2.2** JSON output SHALL be deterministic (stable key order, no wall-clock-dependent fields other
  than the requested dates) so two runs on the same inputs are byte-identical.
- **R2.3** The tool SHALL write to stdout by default and to a file with `--out <path>`; it SHALL NOT
  write anywhere unless `--out` is given.

### R3 — Read-only & self-contained
- **R3.1** The tool SHALL make **zero** writes under `lib/` or `test/`, run no `build_runner`, and
  make no network calls (all engines are offline pure Dart).
- **R3.2** The tool SHALL NOT import or touch `regen_golden.dart` or any golden fixture — it is a
  reader, not a fixture producer, and must never be able to launder output into a snapshot.
- **R3.3** `dart run tool/dump_diagnostic.dart --help` SHALL print usage and exit zero.

### R4 — No regression
- **R4.1** `git diff main...HEAD -- lib/ test/golden/` SHALL be empty.
- **R4.2** The existing golden suite (57 cases) SHALL stay green — the dump adds a `tool/` script and
  its own unit test only.

## Standing criteria

- **RT (Tamil):** N/A — a developer/owner CLI tool, no user-facing strings. State N/A explicitly.
- **RC (CONF provenance):** the dump REPORTS engine output; it asserts no new doctrine. The README/
  REPORT SHALL note the subject-bird default (Owl) traces to CONF-PP-001/002, nothing more.
- **RQ (regression):** R4 above — `lib/`/golden untouched, suite green.

## Verification
- `dart run tool/dump_diagnostic.dart --bird owl --lat <Chennai> --lng <Chennai> --start 2026-10-23 --days 7`
  produces a 7×10 = 70-yama report with all R1 fields; `--format md` renders a clean table.
- `--format json` is byte-identical across two runs (R2.2).
- A `test/tool/dump_diagnostic_test.dart` asserts record shape, 70-row count, and determinism.
- `git status` after a stdout run shows **no** changes; a `--out` run shows only the named file.
