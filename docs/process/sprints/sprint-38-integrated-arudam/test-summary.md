[← Back to Sprint Dossier](./README.md)

# Sprint 38 — Local Test Summary

> **Author:** Antigravity IDE coding setup. The local gate result, run before the PR
> (correctness-critical — Task 38.3 touches shipped calc logic). Fill from the run.

## Environment

- Flutter: `3.47.3` · Dart: `3.13.3` · Platform: macOS

## Results (vs known baseline)

> **Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected
> failures**, all in `test/features/cloud_backup/backup_repository_test.dart`
> (CloudKit cases that pass on CI Ubuntu). Gate = "green except those same 4".

| Check | Command | Result |
|-------|---------|--------|
| Analyze | `flutter analyze` | ✅ Clean (0 issues) |
| Full test | `flutter test` | 564 pass / **4 known CloudKit** / **0 other failures** |
| Build web | `flutter build web` | ✅ Succeeded (26.8s) |

**Regression check:** only the 4 known CloudKit cases failed → ✅ Pass (strictly the 4 expected macOS CloudKit tests failed; zero other failures across entire test suite).

## New / updated tests this sprint

- `test/features/astro_engine/integrated_arudam_engine_test.dart`: 11 unit tests covering Moment × Readiness composite scoring, aligned (1.0) vs misaligned (0.75) multipliers, Sushumna in Yoga (1.0) vs Sushumna in Artha (0.6), active Rahu Kaal and Emakandam floor-lock, and band classifications.
- `test/oracle_engine_test.dart`: 28 tests verifying OracleCompositeEngine delegation to IntegratedArudamEngine while maintaining 100% daytime behavioral parity and validating score differentials between aligned and misaligned states.
- `test/features/widgets/arudam_now_card_test.dart`: 6 widget tests verifying the ambient verdict card:
  - Renders title, band, score, and two-clock breakdown.
  - Shows "naturally aligned ✓" when fresh breath matches expected flow.
  - Shows "not naturally aligned ⚠" + "Urgent worldly need?" when misaligned.
  - Opens modal bottom sheet with warning tone and re-check loop on urgent tap.
  - Degrades gracefully to timing ceiling with breath check prompt when swara is stale (>30m).
  - Enforces floor-lock (Hard No / 10) during active Rahu Kaal and Emakandam.
- `test/database/migration_helpers_test.dart`: Verified database schema migration to version 6 including `wasForcedShift` column addition.

## Notes

- Baseline protected completely.
- Zero lint loosening — `analysis_options.yaml` untouched.
