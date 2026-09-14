[← Back to Sprint Dossier](./README.md)

# Sprint 42 — Local Test Summary

> **Author:** Antigravity IDE coding setup (Saranidhi local dev).
> **When:** after the local `flutter analyze` + `flutter test` run, before the PR
> (correctness-critical code must be GREEN locally, not CI-only — v1.2.1 lesson).
> This is the audit record of the local gate result.

## Environment

- Flutter: `3.47.3` · Dart: `3.13.3` · Platform: macOS (Darwin 24.3.0) · Chrome: `152.0.7977.84`

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected
> failures**, all in `test/features/cloud_backup/backup_repository_test.dart`
> (CloudKit "on non-Apple platform" cases that only fail because `Platform.isMacOS`
> locally; they PASS on CI Ubuntu). The gate = "green **except those same 4**."

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ✅ no issues found (0 issues) |
| Full test | `flutter test` | 628 passed / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ✅ compiles cleanly (28.0s) |

**Regression check:** the only failures are the 4 known CloudKit cases → ✅ Confirmed (0 other failures, 0 regressions).

## New / updated tests this sprint

> Per spec §7.

- `test/features/astro_engine/swara_clock_test.dart` — 12 tests covering: weekday seeds (incl. Thu paksha split), 1h vs 2h inception, hourly alternation (worked oracle §3.5), day/night + **pre-dawn cross-midnight** anchoring, sunrise anchoring, `blockAt` ≤60-min countdown. All passing.
- `alignment_checker` (`test/features/breath_journal/alignment_checker_test.dart`) — 12 tests covering: `expectedFlow` from swara clock + **non-`now` entry-time honored** (latent-bug fix) with deterministic sunrise matching and pre-dawn anchoring. All passing.
- `nostril_dominance_chart` (`test/features/widgets/nostril_dominance_chart_test.dart`) — 6 tests covering: 5 hourly blocks displayed + `← NOW` chip + countdown to next swara switch (SwaraClock.blockAt.end - now, ~1h) + live night blocks with gentle wellness text + pre-dawn rendering with location coordinates. All passing.
- `oracle_engine_test.dart` — 29 tests passing (updated alignment assertions matching Swara Clock solar day calculations + pre-dawn location coordinates evaluation test).
- `nostril_pattern_test.dart` — 2 tests passing (deprecated shim delegation).
- `integrated_arudam_engine_test.dart` & `arudam_now_card_test.dart` — PP-ORACLE floor-lock lockout assertions passing.
- Regression: bird/yama/oracle-Moment tests unchanged & green (Panja Pakshi bird-state & YamaIndex calculations byte-for-byte intact).

## Notes

- Total test count increased from baseline 615 passed to 628 passed (+13 net passed tests across the suite).
- All 4 failing tests are the pre-existing macOS CloudKit host environment tests in `backup_repository_test.dart`.

