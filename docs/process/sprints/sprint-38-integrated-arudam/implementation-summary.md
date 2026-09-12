[← Back to Sprint Dossier](./README.md)

# Sprint 38 — Implementation Summary

> **Author:** Antigravity IDE coding setup. Fill after implementation, with the PR,
> against [`spec.md`](./spec.md). Factual and terse — the audit record of what was
> actually built.

## PR

- **PR:** #181 (`feature/sprint38-integrated-arudam` → `main`)

## What was implemented (by spec task)

| Spec Task | File(s) | Done | Notes / deviations |
|-----------|---------|:----:|--------------------|
| 38.1 — Extract `IntegratedArudamEngine` | `lib/features/astro_engine/domain/integrated_arudam_engine.dart` | ✅ | Pure domain engine with `evaluate()`, `IntegratedArudamResult`, `OracleBand`, `QueryCategory`, composite scoring `Moment (0-100) × Readiness (0.0-1.0)`, and floor-lock. |
| 38.2 — Wire Oracle to extracted engine | `lib/features/astro_engine/domain/oracle_engine.dart` | ✅ | `OracleCompositeEngine.evaluate` retains exact public signature and delegates to `IntegratedArudamEngine.evaluate`. Daytime Oracle behavior preserved 100%. |
| 38.3 — Verify 24h inauspicious floor-lock & star input | `lib/features/streaks/providers/streak_providers.dart` | ✅ | `rahuKaal?.isActive(now)` & `emakandam?.isActive(now)` provide 24h window containment. Added `birthStarNakshatra` to `DashboardData` and `dashboardDataProvider`. |
| 38.4 — Ambient "Aruḍam Now" verdict card on Home | `lib/features/home/presentation/widgets/arudam_now_card.dart`, `lib/features/home/presentation/today_tab.dart` | ✅ | Placed at top of Row 0 on Today tab. Shows band, score, two-clock breakdown (Moment ceiling & You readiness), and degrades to timing ceiling when swara is stale (>30m). |
| 38.5 — Natural-vs-forced framing & urgent guidance | `lib/features/home/presentation/widgets/arudam_now_card.dart` | ✅ | Primary guidance on misalignment is wait/accept/note. Low-emphasis "Urgent worldly need?" link opens warning-toned modal with contralateral shift guidance and verification loop. |
| 38.6 — Schema migration for `wasForcedShift` | `lib/database/tables.dart`, `lib/database/app_database.dart`, `lib/features/breath_journal/data/journal_repository.dart`, `lib/features/breath_journal/providers/journal_providers.dart`, `lib/features/cloud_backup/domain/database_exporter.dart` | ✅ | Added `wasForcedShift` (default `false`) to `SaraKalaiJournal`. Bumped `schemaVersion` to 6 with guarded migration check. Logged as `true` exclusively via urgent re-check loop. |
| 38.7 — Bilingual copy (Tamil & English) | `lib/l10n/app_en.arb`, `lib/l10n/app_ta.arb`, `lib/l10n/generated/` | ✅ | Added 13 new localized string keys in English and Tamil covering card titles, two-clock labels, status badges, guidance prose, and modal shift callouts. |

## Deviations from the spec

- None. All tasks implemented strictly according to `spec.md`.

## Regression evidence (Task 38.1 / 38.3)

> Prove the Oracle's existing day-time verdicts are UNCHANGED by the extraction +
> floor-lock refactor, AND that night verdicts now gate correctly.

- **Oracle Daytime Parity:** All 28 tests in `test/oracle_engine_test.dart` pass, confirming identical daytime behavior, band mappings, and score calculations. Added explicit test verifying aligned (1.0) vs misaligned (0.75) score scaling.
- **24h Inauspicious Floor-Lock:** Verified in unit tests (`test/features/astro_engine/integrated_arudam_engine_test.dart`) and widget tests (`test/features/widgets/arudam_now_card_test.dart`) that both Rahu Kaal and Emakandam hard-lock verdict score to 10 (Band: Sunya) regardless of bird state or breath alignment.
- **Staleness Degradation:** Verified that when the latest journal entry is >30m old or null, readiness defaults to 1.0 (ceiling only) and UI indicates breath observation is needed rather than fabricating alignment.

## Open questions / follow-ups

- Slice 2 (Sprint 39): Provenance breakdown ("Why?" accordion) deferred per spec.
- Slice 2 (Sprint 39): Home screen widgets / watch surfaces deferred per spec.
- Future analytics: Correlation reporting between `wasForcedShift == true` and task success/failure.
