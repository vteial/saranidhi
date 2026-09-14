[← Back to Sprint Dossier](./README.md)

# Sprint 44 — Local Test Summary

> **Author:** Antigravity IDE coding setup. After local `flutter analyze` + `flutter test`,
> before the PR (correctness-critical: migration + data-merge + identity guard → GREEN locally,
> not CI-only).

## Environment

- Flutter: `___` · Dart: `___` · Platform: macOS · Chrome: `___`

## Results (vs known baseline)

> **Known macOS baseline:** 4 expected CloudKit failures in `backup_repository_test.dart` (pass on
> CI Ubuntu). Gate = "green **except those same 4**." NB: this sprint touches `cloud_backup/` — do
> not confuse a *new* failure with the known 4; read the test names.

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ⬜ |
| Full test | `flutter test` | ___ pass / **4 known CloudKit** / **0 other** |
| Build web | `flutter build web` | ⬜ |

## New / updated tests this sprint (per spec §7)

- Migration v6→v7: existing profile → ownerId backfilled (UUID), no data loss; fresh install has ownerId; idempotent:
- Merge union-by-id: disjoint → union; overlap → idempotent (no dup); never deletes local:
- Owner guard: match→merges; **mismatch→refuses (no DB mutation)**; empty-local→adopts file ownerId; legacy no-ownerId→needs-confirm:
- Aggregate over A∪B: streak / hold-time personal-best / totals correct (journal-sourced):
- Validation: `validateExportData` accepts schema 7 + exportVersion 2, rejects genuinely-newer; `summarizeExportData` reports ownerId + match:
- Regression: `restoreFromBytes` still fully replaces (old behavior intact):

## Notes

-
