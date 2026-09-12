[← Back to Sprint Dossier](./README.md)

# Sprint 39 — Implementation Summary

> **Author:** Antigravity IDE coding setup (Saranidhi local dev).
> **When:** written after implementation, before/with the PR.
> Filled against the sprint [`spec.md`](./spec.md). Keep it factual and terse —
> this is the audit record of *what was actually built*, not a re-plan.

## PR

- **PR:** #196 (`sprint/39-why-accordion` → `main`)
- **Commits:** `783c2f2`

## What was implemented (by spec task)

| Spec Task | File(s) | Done | Notes / deviations |
|-----------|---------|:----:|--------------------|
| 39.1 — engine factor breakdown (`ArudamFactor` / `FactorStrength` / `ArudamReason` + `reasons` field) | `lib/features/astro_engine/domain/integrated_arudam_engine.dart` | ☑ | Behavior-preserving: added `final List<ArudamReason> reasons` to `IntegratedArudamResult`, constructed in `evaluate()`. |
| 39.2 — factor→CONF provenance mapping (data = source of truth) | `integrated_arudam_engine.dart` | ☑ | Data is single source of truth: doc-comments and `conf` strings match corpus citations. |
| 39.3 — `_WhySection` accordion (collapsed by default) + `arudamWhy*` ARB (EN/TA) | `lib/features/home/presentation/widgets/arudam_now_card.dart`, `lib/l10n/app_en.arb`, `lib/l10n/app_ta.arb` | ☑ | Stateful `_WhySection` (collapsed by default, ≥44×44 tap target), groups Moment / You or single Blocked reason; 100% localized via bilingual ARB keys in pure Tamil. |
| 39.4 — Oracle path unaffected | `lib/features/astro_engine/domain/oracle_engine.dart`, `prasanam_screen.dart` | ☑ | `OracleEngine` delegates to `evaluate()` and maps score/band/guidance unchanged. |
| 39.5 — tests (engine reasons + card collapse/expand/provenance/floor-lock) | `test/features/astro_engine/integrated_arudam_engine_test.dart`, `test/features/widgets/arudam_now_card_test.dart` | ☑ | 5 new engine tests + 4 new card tests (collapse/expand, floor-lock single reason, misaligned, Tamil locale). All existing tests pass unchanged. |

## Deviations from the spec

> Anything that differs from the spec (a different code shape, an extra file, a
> renamed symbol). If none: "None — implemented exactly as specced."

- None — implemented exactly as specced.

## Source-derived values flagged for owner review

> The factor→CONF citations (39.2) are doctrinal. List the final `conf` string chosen per
> `ArudamFactor` and the CONF it cites, so Kiro Web / owner can cross-verify against the
> corpus before merge. Flag any citation you changed from the spec's suggested mapping.

| ArudamFactor | Citation used | Matches spec? |
|--------------|---------------|:-------------:|
| birdState | `CONF-PP-004` | Yes |
| horaSwara | `CONF-014` | Yes |
| tarabala | `CONF-PP-001/002` | Yes |
| categoryHarmony | `CONF-015` | Yes |
| readiness | `CONF-016 / CONF-017` | Yes |
| sushumna | `CONF-026` | Yes |
| floorLock | `CONF-018` | Yes |

## Open questions / follow-ups

- None. Ready for Kiro Web review.
