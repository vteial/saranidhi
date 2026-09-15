[← Back to Sprint Dossier](./README.md)

# Sprint 45 — Implementation Summary

> **Author:** Antigravity IDE coding setup. Written after implementation, before/with the PR.
> Filled against the sprint [`spec.md`](./spec.md). Factual + terse.
> _Placeholder — Antigravity fills this in on implementation._

## PR

- **PR:** Branch `sprint/45-practice-sync-polish` into `main`
- **Commits:** `feat(sync): v1.12.1 practice-sync polish (45.1, 45.2, 45.3)`

## What was implemented (by spec task)

| Spec Task | File(s) | Done | Notes / deviations |
|-----------|---------|:----:|--------------------|
| 45.1 onboarding "Import from another device" entry point | `lib/features/onboarding/presentation/intro_screen.dart`<br>`lib/features/settings/presentation/merge_import_controller.dart`<br>`lib/features/onboarding/providers/onboarding_providers.dart`<br>`lib/features/settings/presentation/data_export_import_widget.dart`<br>`lib/l10n/app_en.arb`<br>`lib/l10n/app_ta.arb` | ✅ | Added subtle "Already using Saranidhi on another device? Import" text button on `IntroScreen`. Extracted shared `MergeImportController` to unify file picking, validation, owner-guard checks (`match`, `emptyLocal`, `legacyNoOwnerId`, `mismatch`), confirmation dialogs, provider invalidation, and onboarding state reload. `onboarding_complete: true` set in SharedPreferences and `onboardingCompleteProvider` reloaded, smoothly routing new devices directly to the main app with adopted Practice ID. |
| 45.2 BUG-v1.12.0-01 — profile card refresh after Restore/Merge | `lib/features/settings/providers/profile_providers.dart`<br>`lib/features/settings/presentation/profile_card.dart`<br>`lib/features/settings/presentation/merge_import_controller.dart` | ✅ | Extracted `profileProvider` (`FutureProvider<Profile?>`). Refactored `ProfileCard` to watch `profileProvider` with `.when(...)` instead of an inline `FutureBuilder`. Added `profileProvider` invalidation in `invalidateAllDataProviders(ref)` (called by both Merge and Restore) and in in-card edits (`_saveProfile`, `_editBirthStar`, `_editLocation`). Practice ID, name, birth bird, and location refresh reactively without page reload. |
| 45.3 Practice ID prefix in export filename | `lib/features/cloud_backup/domain/database_exporter.dart`<br>`lib/features/settings/presentation/data_export_import_widget.dart` | ✅ | Implemented `DatabaseExporter.buildBackupFilename({String? ownerId, DateTime? now})`. Prepends first 8 chars of `ownerId` (e.g. `saranidhi_backup_3f9a1c2b_2026-09-15-1034.json`). Falls back gracefully to unprefixed `saranidhi_backup_<dateStr>.json` when `ownerId` is null or empty. Handles IDs shorter than 8 characters without `RangeError`. |
| Tests | `test/features/cloud_backup/backup_filename_test.dart`<br>`test/features/settings/profile_card_refresh_test.dart`<br>`test/features/onboarding/intro_screen_test.dart`<br>`test/features/settings/data_export_import_widget_test.dart` | ✅ | Added 12 new unit and widget tests (6 filename builder tests, 2 profile card refresh tests, 4 intro import & onboarding adoption tests). All 15 tests pass. |
| User Guide note | `lib/l10n/app_en.arb`<br>`lib/l10n/app_ta.arb` | ✅ | Added "How do I set up a new device using an existing backup?" FAQ entry in English and Tamil. |

## Shared-helper extraction (45.1 — no duplication)

Extracted `MergeImportController` (`lib/features/settings/presentation/merge_import_controller.dart`) providing static methods:
- `pickJsonFile`: Custom or platform file picker invocation, null check, and JSON schema validation.
- `pickAndMerge`: Full guard-aware merge flow handling `OwnerGuardStatus.mismatch` (with optional restore fallback), `OwnerGuardStatus.legacyNoOwnerId` (warning dialog), and `OwnerGuardStatus.match` / `emptyLocal` (summary confirmation dialog displaying Practice ID adoption status and record counts).
- `executeMerge`: Core execution invoking `DatabaseExporter.mergeFromBytes`, calling `invalidateAllDataProviders(ref)`, triggering `onboardingCompleteProvider.notifier.reload()`, and displaying localized SnackBar feedback.
- Shared UI / helper utilities: `SummaryRow`, `formatBackupDate`, and `invalidateAllDataProviders(ref)`.

Both `DataExportImportWidget` (Settings) and `IntroScreen` (Onboarding) delegate file selection, validation, confirmation dialogs, and execution to `MergeImportController`.

## Deviations from the spec

None. All tasks implemented according to spec.
