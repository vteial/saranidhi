[← Back to Sprint Dossier](./README.md)

# Sprint 38 — Local Test Summary

> **Author:** Antigravity IDE coding setup. The local gate result, run before the PR
> (correctness-critical — Task 38.3 touches shipped calc logic). Fill from the run.

## Environment

- Flutter: `___` · Dart: `___` · Platform: macOS · Chrome: `___`

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected
> failures**, all in `test/features/cloud_backup/backup_repository_test.dart`
> (CloudKit cases that pass on CI Ubuntu). Gate = "green except those same 4".

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ⬜ |
| Full test | `flutter test` | ___ pass / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ⬜ |

**Regression check:** only the 4 known CloudKit cases failed → ⬜ (list any other).

## New / updated tests this sprint

- `IntegratedArudamEngine` unit tests (Moment × Readiness, misalignment penalty, Sushumna-in-Yoga, night floor-lock)
- Oracle-unchanged regression tests (day-time verdict parity)
- Verdict-card widget test

## Notes

-
