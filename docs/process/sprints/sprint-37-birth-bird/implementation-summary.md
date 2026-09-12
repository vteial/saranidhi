[← Back to Sprint Dossier](./README.md)

# Sprint 37 — Implementation Summary

> **Author:** Antigravity IDE coding setup (Saranidhi local dev).
> Filled against [`spec.md`](./spec.md). Backfilled from PR #167 at the process-dossier
> restructure — this is the first sprint retrofitted into the dossier convention.

## PR

- **PR:** [#167](https://github.com/vteial/saranidhi/pull/167) (`feature/sprint37-birth-bird-correction` → `main`)
- **Merge commit:** `df303e9` · **Feature commit:** `4fe5ee6`

## What was implemented (by spec task)

| Spec Task | File(s) | Done | Notes |
|-----------|---------|:----:|-------|
| 37.1 partition → 5-6-5-5-6 | `pakshi_calculator.dart` | ✅ | Pooram→Owl, Visakam→Crow, Uthiradam→Rooster |
| 37.2 single permanent birth-star table (no Krishna swap) | `pakshi_calculator.dart` | ✅ | known-star path ignores paksha; dark reversed sets retired from birth-star derivation |
| 37.3 name-initial fallback carries the paksha swap | `name_bird_parser.dart` | ✅ | waning 5-cycle V→R→P→C→O→V — **verified exact against source** (see below) |
| 37.4 re-migrate ALL affected users (incl. manual/no-DOB) | `bird_migration_service.dart` (+ test) | ✅ | idempotent; one-time SnackBar; DOB + manual-star paths both re-derived |
| 37.5–37.7 attribute corrections (planet / friend-enemy / direction) | `pakshi_attributes.dart` | ✅ | CONF-PP-003/004/005 |
| 37.8 tests & docs | test suites + `calculation-methodology.md` + `user-guide.md` | ✅ | new cases: Pooram→Owl, Visakam→Crow, Uthiradam→Rooster, Pushya+Krishna→Owl |

## Deviations from the spec

- None material — implemented per spec. Code-shape choice for 37.2 kept the
  `birthBirdFromNakshatraAndPaksha` signature but ignores `paksha` for known stars
  (spec option (a)).

## Source-derived values flagged for owner review

- **Name-initial waning swap 5-cycle** (spec §4 flagged "derive-from-source → owner
  review"): implemented as **V→R→P→C→O→V**. Cross-verified via a read-only Antigravity
  source check against the workshop transcript (`pp-class-01.md` @34:00–46:00) + the
  master's 56-pg book p.8 — confirmed **exact**. No rework needed.

## Open questions / follow-ups

- CONF-PP-006 (equal vs classical-weighted sub-yama durations + settings toggle) — out
  of scope this sprint, deferred to a later sprint (a new user option, not a correction).
