[← Back to Sprint Dossier](./README.md)

# Sprint 45 — Local Test Summary

> **Author:** Antigravity IDE coding setup. Records the **local** `flutter test` + `flutter analyze`
> run **before** the PR (Kiro Web cannot run Flutter locally). Factual + terse.
> _Placeholder — Antigravity fills this in on implementation._

## Local run

- `flutter analyze`: Passed (0 issues found, ran in 1.8s).
- `flutter test`: **661** passed, 4 failed (standing baseline of 4 known CloudKit-on-macOS tests in `backup_repository_test.dart` due to Apple CloudKit container mock on non-Apple test runners, zero regressions). Net +12 tests added over the 649 baseline.

## New tests added

| Task | Test File | Tests | What it proves |
|------|-----------|:-----:|----------------|
| 45.1 | `test/features/onboarding/intro_screen_test.dart` | 4 | Intro Import link renders in EN & TA; tapping Get Started sets `introSeenProvider` without regression; tapping Import link runs guard-aware merge, adopts source device's Practice ID into local DB, persists `onboarding_complete: true`, and updates Riverpod state. |
| 45.2 | `test/features/settings/profile_card_refresh_test.dart` | 2 | `profileProvider` re-reads updated profile after invalidation; `ProfileCard` automatically refreshes Practice ID and practitioner display name upon provider invalidation without manual page reload. |
| 45.3 | `test/features/cloud_backup/backup_filename_test.dart` | 6 | `DatabaseExporter.buildBackupFilename` prefixes filename with first 8 characters of owner UUID; falls back to unprefixed filename when `ownerId` is null or empty string; safely handles IDs shorter than 8 characters and 1-character IDs without `RangeError`; defaults to current date when timestamp parameter is omitted. |

## Regression

- Baseline tests: All 649 baseline tests continue to pass (4 standing Apple CloudKit mock failures unchanged).
- `DataExportImportWidget` tests (`test/features/settings/data_export_import_widget_test.dart`): 3/3 passing.
- Onboarding happy path: Unaffected and verified.
- Riverpod state invalidation: Verified smooth reload across all data layers.

## Result

**PASS** — Clean analyze, zero regressions, 12 new tests passing, all Definition of Done criteria satisfied.
