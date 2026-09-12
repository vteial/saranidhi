[← Back to Sprint Dossier](./README.md)

# Sprint 37 — Local Test Summary

> **Author:** Antigravity IDE coding setup (Saranidhi local dev).
> Local gate result run before PR #167. Backfilled at the process-dossier restructure.

## Environment

- Flutter: 3.47.3 · Dart: 3.13.3 · Platform: macOS · Chrome: 152

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected
> failures**, all in `test/features/cloud_backup/backup_repository_test.dart` (CloudKit
> "on non-Apple platform" cases that fail only because `Platform.isMacOS` locally; they
> PASS on CI Ubuntu). The gate = "green **except those same 4**."

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ✅ no issues |
| Full test | `flutter test` | 546 pass / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ✅ compiles |

**Regression check:** only the 4 known CloudKit cases failed → ✅ no Sprint 37 regression.
Confirmed green on CI (Ubuntu) on PR #167 — "Full Test Suite + Coverage" + "Integration
Tests (Web)" both passed.

## New / updated tests this sprint

- `pakshi_calculator_test.dart` — updated to 5-6-5-5-6; added Pooram→Owl, Visakam→Crow,
  Uthiradam→Rooster, and Pushya+Krishna→Owl.
- `pakshi_attributes_test.dart` — corrected planet / friend-enemy / direction values.
- `bird_migration_service_test.dart` — DOB-profile correction, manual/no-DOB correction,
  idempotent no-op, empty-DB no-op.
- `onboarding_test.dart` — corrected expected birds.

## Notes

- Correctness-critical (core calc) → local GREEN was required before the PR per the
  v1.2.1 lesson; CI-only was explicitly not sufficient.
