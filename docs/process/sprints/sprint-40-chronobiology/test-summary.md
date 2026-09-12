[← Back to Sprint Dossier](./README.md)

# Sprint 40 — Local Test Summary

> **Author:** Antigravity IDE coding setup (Saranidhi local dev).
> **When:** after the local `flutter analyze` + `flutter test` run, before the PR.
> This is the audit record of the local gate result.
>
> _Seeded by `/sprint-start` — Antigravity fills the results below after the local run._

## Environment

- Flutter: `3.47.3` · Dart: `3.13.3` · Platform: macOS · Chrome: N/A (Web build verified)

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected
> failures**, all in `test/features/cloud_backup/backup_repository_test.dart`
> (CloudKit "on non-Apple platform" cases that only fail because `Platform.isMacOS`
> locally; they PASS on CI Ubuntu). The gate = "green **except those same 4**."

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ☑ no issues |
| Full test | `flutter test` | 605 pass / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ☑ compiles (built build/web) |

**Regression check (behavior-preserving gate):** confirm existing dashboard / focus /
notification tests pass **unchanged** (only additions); `DashboardData` + `FocusCard` gained
optional/defaulted fields only; `createTestDashboardData` updated with a `none` default → ☑.

## New / updated tests this sprint

- `ChronobiologyAnalytics` — none (<3 logs) / mild (≥6h, 3 logs) / chronic (≥8h, 4 logs) / Sushumna breaks a run / recent flip resets to `none` / boundary at exactly 6h & 8h (`test/features/chronobiology/chronobiology_analytics_test.dart` - 14 tests).
- `journal_repository.getEntriesSince` — returns only entries ≥ cutoff, in order (`test/features/breath_journal/journal_repository_test.dart` - 2 tests).
- Dashboard provider — `DashboardData.stagnancy` populated + `none` default path (`test/features/providers/dashboard_data_test.dart` - 3 tests).
- `stagnancy_card` widget — hidden when `none`; cooling copy (stuck-right) / warming copy (stuck-left); mild vs chronic tone; somatic affordance present (`test/features/home/widgets/stagnancy_card_test.dart` - 6 tests, EN & TA).
- `focus_card` — Kriya shows Swara-Ahara prompt; left-flow flip nudge; right-flow affirming line; non-Kriya unchanged (`test/features/home/widgets/focus_card_test.dart` - 7 tests, EN & TA).
- `notification_scheduler` — morning summary includes Pada Gamana advice; EN vs TA switch (`test/features/notifications/notification_scheduler_test.dart` - 11 tests).
- Tattva tip — fire→cooling / cold→warming mapping (`test/features/chronobiology/somatic_advice_test.dart` - 5 tests).

## Notes

- All 605 non-CloudKit tests pass with 0 analyzer issues. Web build compiled cleanly with `--wasm` dry run succeeded.
