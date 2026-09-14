[← Back to Sprint Dossier](./README.md)

# Sprint 44 — Local Test Summary

> **Author:** Antigravity IDE coding setup. After local `flutter analyze` + `flutter test`,
> before the PR (correctness-critical: migration + data-merge + identity guard → GREEN locally,
> not CI-only).

## Environment

- Flutter: `3.47.3` · Dart: `3.13.3` · Platform: macOS

## Results (vs known baseline)

> **Known macOS baseline:** 4 expected CloudKit failures in `backup_repository_test.dart` (pass on
> CI Ubuntu). Gate = "green **except those same 4**." NB: this sprint touches `cloud_backup/` — do
> not confuse a *new* failure with the known 4; read the test names.

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ✅ Clean (0 issues) |
| Full test | `flutter test` | ✅ **649 pass** / **4 known CloudKit** / **0 other** |
| Build web | `flutter build web` | ✅ Built `build/web` |

## New / updated tests this sprint (per spec §7)

- Migration v6→v7: existing profile → ownerId backfilled (UUID), no data loss; fresh install has ownerId; idempotent: ✅ Passed (`test/database/schema_migration_v6_to_v7_test.dart`, 3 tests)
- Merge union-by-id: disjoint → union; overlap → idempotent (no dup); never deletes local: ✅ Passed (`test/features/cloud_backup/database_exporter_test.dart`)
- Owner guard: match→merges; **mismatch→refuses (no DB mutation)**; empty-local→adopts file ownerId; legacy no-ownerId→needs-confirm: ✅ Passed (`test/features/cloud_backup/database_exporter_test.dart`)
- Owner identity safety service: null on empty, backfills on missing, idempotent: ✅ Passed (`test/features/settings/owner_identity_service_test.dart`, 3 tests)
- Aggregate over A∪B: streak / hold-time personal-best / totals correct (journal-sourced): ✅ Passed (`test/features/cloud_backup/database_exporter_test.dart`)
- Validation: `validateExportData` accepts schema 7 + exportVersion 2, rejects genuinely-newer; `summarizeExportData` reports ownerId + match: ✅ Passed (`test/features/cloud_backup/database_exporter_test.dart`)
- Regression: `restoreFromBytes` still fully replaces (old behavior intact): ✅ Passed (`test/features/cloud_backup/database_exporter_test.dart`)
- Widget test: updated for Merge from file, Restore, CSV export in EN and TA: ✅ Passed (`test/features/settings/data_export_import_widget_test.dart`, 3 tests)

## Notes

- Baseline before sprint: 632 pass / 4 known CloudKit / 0 other.
- After Sprint 44: 649 pass (+17 new/updated tests) / 4 known CloudKit / 0 other.
- The 4 CloudKit failures are the exact known non-Apple platform stubs in `backup_repository_test.dart`. Zero regressions.
