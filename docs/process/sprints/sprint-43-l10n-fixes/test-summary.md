[← Back to Sprint Dossier](./README.md)

# Sprint 43 — Local Test Summary

> **Author:** Antigravity IDE coding setup. After the local `flutter analyze` + `flutter test`
> run, before the PR (43.2 changes domain + widget → GREEN locally, not CI-only). Audit record
> of the local gate.

## Environment

- Flutter: `3.47.3` · Dart: `3.13.3` · Platform: macOS · Chrome: `152.0.7977.84`

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** 4 expected failures in
> `test/features/cloud_backup/backup_repository_test.dart` (CloudKit "on non-Apple platform";
> pass on CI Ubuntu). Gate = "green **except those same 4**."

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ✅ no issues found |
| Full test | `flutter test` | 632 pass / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ✅ compiles (`✓ Built build/web` in 27.3s) |

**Regression check:** only the 4 known CloudKit failures → ✅ (0 other failures).

## New / updated tests this sprint

> Per spec §43.2.

- Domain: `MonthlyPatterns.bestDayWeekday` / `worstDayWeekday` = correct int (e.g. Sunday → 7): Added test group `AnalyticsCalculator.calculateMonthlyPatterns` in `test/features/analytics/analytics_calculator_test.dart` asserting null weekdays on empty input and integer weekdays (Sunday=7, Tuesday=2) on populated entries.
- Widget: Monthly-Patterns card renders localized weekday — Tamil `ஞாயிறு` (not `Sunday`) in `ta` locale, `Sunday` in `en`: Added assertions in `test/features/analytics/analytics_screen_l10n_test.dart` verifying `Sunday`/`Tuesday` under `en` and `ஞாயிறு`/`செவ்வாய்` under `ta`.
- Updated any existing tests referencing the old string `bestDay`/`worstDay`: Updated `sampleMonthly` fixture in `test/features/analytics/analytics_screen_l10n_test.dart` to use integer fields (`bestDayWeekday: 7, worstDayWeekday: 2`).
- `integrated_arudam_engine_test.dart` — readiness `conf` string (if pinned) updated to `CONF-014`: Updated lines 284 & 305 to expect `CONF-014`; updated `test/features/widgets/arudam_now_card_test.dart` to expect `findsNWidgets(2)` as both horaSwara and readiness factors cite `CONF-014`.
- Added `test/features/settings/presentation/about_card_test.dart`: Widget test locking AboutCard developer name and copyright in `en` (`Eialarasu`) and `ta` (`இயலரசு`).

## ARB parity

- `flutter gen-l10n` clean; EN/TA key parity (new `aboutDeveloperName` in both): ✅

## Notes

- Baseline before changes: 628 passed, 4 failed (CloudKit).
- Post-implementation: 632 passed, 4 failed (CloudKit). +4 passed tests net.

