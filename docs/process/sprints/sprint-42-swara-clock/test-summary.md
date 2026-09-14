[← Back to Sprint Dossier](./README.md)

# Sprint 42 — Local Test Summary

> **Author:** Antigravity IDE coding setup (Saranidhi local dev).
> **When:** after the local `flutter analyze` + `flutter test` run, before the PR
> (correctness-critical code must be GREEN locally, not CI-only — v1.2.1 lesson).
> This is the audit record of the local gate result.

## Environment

- Flutter: `___` · Dart: `___` · Platform: macOS · Chrome: `___`

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected
> failures**, all in `test/features/cloud_backup/backup_repository_test.dart`
> (CloudKit "on non-Apple platform" cases that only fail because `Platform.isMacOS`
> locally; they PASS on CI Ubuntu). The gate = "green **except those same 4**."

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ⬜ no issues / ❌ … |
| Full test | `flutter test` | ___ pass / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ⬜ compiles / ❌ … |

**Regression check:** the only failures are the 4 known CloudKit cases → ⬜ / ❌ (list any other failure).

## New / updated tests this sprint

> Per spec §7.

- `test/features/astro_engine/swara_clock_test.dart` — weekday seeds (incl. Thu paksha split), 1h vs 2h inception, hourly alternation (worked oracle §3.5), day/night + **pre-dawn cross-midnight** anchoring, sunrise anchoring, `blockAt` ≤60-min countdown:
- `alignment_checker` — `expectedFlow` from swara clock + **non-`now` entry-time honored** (latent-bug fix):
- `nostril_dominance_chart` — hourly blocks + ~1h next-switch (not yama rows / `yama.end`):
- Regression: bird/yama/oracle-Moment tests unchanged & green:

## Notes

-
