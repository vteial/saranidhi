[← Back to Sprint Dossier](./README.md)

# Sprint 44 — Implementation Summary

> **Author:** Antigravity IDE coding setup. Written after implementation, before/with the PR.
> Filled against the sprint [`spec.md`](./spec.md). Factual + terse.

## PR

- **PR:** [#236](https://github.com/vteial/saranidhi/pull/236) (`feature/sprint44-practice-sync-p0` → `main`)
- **Commits:** `3270009` (`feat(sync): Sprint 44 — Practice Sync Phase 0 owner-stamped safe merge-import (v1.12.0)`)

## What was implemented (by spec task)

| Spec Task | File(s) | Done | Notes / deviations |
|-----------|---------|:----:|--------------------|
| 44.1 owner ID + v6→v7 guarded migration + backfill + Settings display | `tables.dart`, `app_database.dart`, `onboarding_providers.dart`, `profile_card.dart`, `owner_identity_service.dart` | ✅ | Added `ownerId` to `Profiles`, guarded migration with `columnExists`, backfill UUID v4, fresh-install assignment, on-load ensure safety net, copyable Practice ID tile in Settings |
| 44.2 stamp export w/ ownerId + fix versions (schema 4→7, exportVersion→2) | `database_exporter.dart`, `app_constants.dart`, `pubspec.yaml` | ✅ | Stamped top-level envelope + profile maps with `ownerId`, included `somatic` logs, updated `appVersion = '1.12.0'`, `schemaVersion = 7`, `exportVersion = 2` |
| 44.3 MERGE import (union-by-UUID, all event tables) + Restore(overwrite) | `database_exporter.dart` | ✅ | `mergeFromBytes` unions all event tables (`sara_kalai_journal`, `breath_sessions`, `prasanam_history`, `somatic_intervention_logs`, `bird_library`) by UUID; skips existing IDs, never deletes; `restoreFromBytes` preserved as explicit overwrite |
| 44.4 owner-identity guard (match→merge / mismatch→REFUSE / empty→adopt / legacy→confirm) | `database_exporter.dart`, `data_export_import_widget.dart` | ✅ | Typed `checkOwnerGuard`, `OwnerMismatchException` with 0 DB mutations, `LegacyBackupException` with explicit confirmation, adoption on empty local profile |
| 44.5 aggregate correctness post-merge (test) | `database_exporter_test.dart` | ✅ | Verified hold-time personal-best (`holdDurationMs`), daily averages, and session totals correctly span A ∪ B |
| 44.6 bilingual EN/TA + Settings UI (Merge vs Restore, summary dialog) | `data_export_import_widget.dart`, `app_en.arb`, `app_ta.arb` | ✅ | "Merge from file" (primary), "Restore (overwrite everything)", summary & mismatch refusal dialogs, 100% EN/TA parity |
| Latent-bug fixes | `app_constants.dart` (schema 4→7), `database_exporter.dart` (`validateExportData` ceiling) | ✅ | Fixed stale schema version (was 4, real was 6, now 7), corrected `validateExportData` schema ceiling comparison |

## Deviations from the spec

None — implemented exactly as specced.

## Identity-propagation decision (spec §2/§4 crux — confirm)

When `mergeFromBytes` runs on a device where the local `profiles` table is empty (fresh install), it adopts the imported profile including its `ownerId`, and imports preferences. Subsequent exports from this new device will share the exact same `ownerId`, enabling seamless, bidirectional safe practice merges across the fleet without an account system.

## Source-derived / behavior decisions flagged for owner review

- Merge conflict policy for existing ids: Skip-existing (sessions and journals are immutable event records once logged; local rows are never overwritten).
- Preferences on merge: Left local if local profile exists; imported only if local device is fresh/empty.
- Which tables union-merged: `sara_kalai_journal`, `breath_sessions`, `prasanam_history`, `somatic_intervention_logs`, `bird_library`.

## Local gate

- `flutter analyze`: clean (0 issues) · `flutter test`: 649 pass / 4 known CloudKit / 0 other.

## Open questions / follow-ups

None.

