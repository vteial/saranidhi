[← Back to Sprint Dossier](./README.md) · [Sprint Tracker](../../sprint-tracker.md)

# Sprint 44 — Practice Sync Phase 0: owner-stamped safe merge-import (v1.12.0) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup.** **Correctness-critical** — a
> schema migration + a data-merge + an identity guard, all touching the user's real practice
> data. Implement with local `flutter analyze` + full `flutter test` **GREEN before the PR** (not
> CI-only). Kiro Web reviews the real diff. Ships as **v1.12.0-web**. Owner-confirmed epic:
> [Practice Sync](../../sprint-backlog.md#-practice-sync--cross-device-aggregate).

## 0. Prerequisite — env + known-GREEN baseline (do FIRST)

Per [`dev-setup.md`](../../dev-setup.md).
```bash
flutter pub get && flutter analyze && flutter test
```
**Known macOS baseline (NOT a regression):** 4 expected CloudKit failures in
`test/features/cloud_backup/backup_repository_test.dart` (pass on CI Ubuntu). Gate = "green
**except those same 4**." Note this sprint touches `cloud_backup/` — do not conflate a *new*
backup_repository failure with the known 4; read the test names.

---

## 1. Why (the problem + the hazard)

The core value of Saranidhi is improving breath-hold time through **consistent practice, any
time / any place** — logged on whichever device is in hand (owner's fleet: iPad Mini primary,
iPhone SE, MBP, iMac — all the **web** app). But the app is per-device local-first, so practice
data lives in **separate local stores** with **no aggregate** streak / trend / hold-time / PB.

**The hazard we're fixing:** the only cross-device path today is Settings → Export/Import JSON,
and **`DatabaseExporter.importFromBytes` is destructive** — it `delete()`s **every table** then
re-inserts (`database_exporter.dart` l.90–94). There is **no owner-identity guard**. So importing
Device B's file onto Device A **wipes A's data**, and importing *another person's* file **replaces
your profile + mixes their practice into yours**. This sprint makes the manual path **safe** (a
non-destructive **merge** + an **owner-identity guard**) so the owner can aggregate across their
devices today with **zero backend**, and lays the `ownerId` foundation for Phase-1 auto-sync.

**Architecture reframe (owner-confirmed):** *local-first → local-first **with optional,
user-owned data portability**.* Offline still works fully; no network, no login in Phase 0.

### ⚠️ Critical grounding fact — the hold-time aggregate is JOURNAL-sourced, not sessions
Verified in code: hold-time **progression + personal-best** are computed from the **journal**
(`analytics_calculator.dart:301` filters `entries.holdDurationMs`), where `entries` = the
`sara_kalai_journal` table — **not** `breath_sessions`. Streaks/alignment also read the journal.
So **the merge MUST cover `sara_kalai_journal`** (the data the owner actually wants aggregated),
**and** `breath_sessions`, **and** `prasanam_history` + `somatic_intervention_logs` for
completeness. In short: **merge ALL user-generated event tables by UUID; never delete.** (The
epic said "sessions first" loosely — the real hold-time source is the journal; cover both.)

### Grounding facts (verified this session)
- All event tables use **UUID v4** `TextColumn id` primary keys (`journal_repository.dart`
  `_uuid.v4()`) → **union-merge is collision-free**: insert only rows whose `id` isn't already local.
- DB **schemaVersion = 6** (`app_database.dart`); migration uses guarded `from < N` blocks with
  `columnExists`/`tableExists` (Sprint 36 lesson). This sprint adds a guarded **v6 → v7** block.
- **Two latent bugs to fix in passing** (they will actively break this sprint if ignored):
  1. `AppConstants.schemaVersion = 4` is **stale** (real DB is 6). Exports stamp the wrong schema.
     → set it correct and keep it in step.
  2. `DatabaseExporter.validateExportData` rejects `schemaVersion > 4` ("update the app") — once
     we bump the real export schema this would **reject valid files**. → fix the comparison to
     use the real current schema (accept `<= current`, reject only genuinely-newer).

---

## 2. Task 44.1 — Locally-generated owner ID (schema v6 → v7)

**Files:** `lib/database/tables.dart` (Profiles), `lib/database/app_database.dart` (migration),
profile creation in `lib/features/onboarding/providers/onboarding_providers.dart` (~l.317),
Settings display.

- **Add `TextColumn get ownerId => text().nullable()();`** to the `Profiles` table. Nullable so
  the migration can backfill without a NOT NULL violation on existing rows.
- **Bump `schemaVersion` 6 → 7** and add a guarded migration block:
  ```dart
  if (from < 7) {
    // Sprint 44: Practice Sync Phase 0 — owner identity for safe merge.
    if (!await columnExists(this, 'profiles', 'owner_id')) {
      await m.addColumn(profiles, profiles.ownerId);
    }
    // Backfill: any profile without an ownerId gets a fresh UUID v4.
    final rows = await select(profiles).get();
    for (final p in rows) {
      if (p.ownerId == null || p.ownerId!.isEmpty) {
        await (update(profiles)..where((t) => t.id.equals(p.id)))
            .write(ProfilesCompanion(ownerId: Value(const Uuid().v4())));
      }
    }
  }
  ```
- **New-profile path:** set `ownerId: Value(const Uuid().v4())` when a profile is first created
  in onboarding (so fresh installs get one immediately, not only via migration).
- **Ensure-on-load safety net:** add a tiny idempotent check on app start (or in the profile
  read) that assigns an `ownerId` if somehow still null — mirrors the birth-bird on-load pattern;
  guarantees every device has a stable ID before any export/import.
- **Settings display (read-only):** show the ownerId in the profile/About area labeled
  **"Practice ID"** (EN) / appropriate TA — short, copyable, so the owner can confirm two devices
  share the same ID. Do NOT make it editable.

> **Interpretation to confirm with owner at review:** "same person's devices share one ownerId."
> In Phase 0 there is no login, so a *fresh install on a new device generates a NEW ownerId*. To
> aggregate, the owner seeds the new device by **importing** an export from an existing device —
> and the merge (44.3) must **adopt the imported file's ownerId onto this device** when the local
> profile is brand-new/unonboarded (so subsequent exports match). Spell this out in the impl
> summary; it's the crux of how Phase-0 identity actually propagates without accounts. See §4.

---

## 3. Task 44.2 — Stamp the export with `ownerId` + correct versions

**File:** `database_exporter.dart` (`exportToBytes`, `_profileToMap`), `app_constants.dart`.

- Add `ownerId` to the profile map (`_profileToMap`) and to the top-level export envelope
  (e.g. `'ownerId': <the single profile's ownerId>`) so a reader can check identity **without**
  parsing profiles. If multiple profiles ever exist, use the primary/first; document the choice.
- **Fix `AppConstants.schemaVersion`** to the real current schema (**7** after 44.1) and
  **`exportVersion`** bump to **2** (the envelope shape changed — now carries `ownerId`). Keep
  `appVersion` in step with pubspec (1.12.0).
- **Backward-compatible:** older exports have `exportVersion: 1` / no `ownerId` → treated as
  "unknown owner" (see §4 guard). New importer must read both v1 and v2 envelopes.

---

## 4. Task 44.3 + 44.4 — MERGE import (replace destructive) + owner-identity guard

**File:** `database_exporter.dart` — replace `importFromBytes` with two clearly-named paths.

### 4.1 Two explicit modes (no silent behavior)
- **`mergeFromBytes(bytes)`** — the NEW default, non-destructive:
  - For **every event table** (`sara_kalai_journal`, `breath_sessions`, `prasanam_history`,
    `somatic_intervention_logs`, `bird_library`): **insert only rows whose `id` is not already
    present locally.** Use `insertOnConflictUpdate`-free logic — prefer *skip existing* (a session
    is immutable once logged; do NOT overwrite local edits). Never `delete`.
  - **Idempotent:** re-merging the same file inserts nothing new.
  - **Profile:** do NOT delete/replace the local profile. If the local device has no profile yet
    (fresh/unonboarded), adopt the imported profile **including its `ownerId`** (this is how a new
    device joins the owner's identity — see §2 note). If a local profile exists, **keep it**
    (ignore the imported profile's mutable fields) — only sessions/journal merge.
  - **Preferences:** do NOT overwrite on merge (local prefs win) — or merge only if absent.
    Confirm with owner; default = leave local prefs untouched on merge.
- **`restoreFromBytes(bytes)`** — the OLD destructive behavior, kept but **explicitly labeled
  "Restore (overwrite everything)"** in the UI, gated behind a confirm dialog. Reuses the current
  delete-all + insert logic.

### 4.2 Owner-identity guard (the safety core)
Before merging, compare the file's `ownerId` to the **local** `ownerId`:
- **Match** → merge silently (same person's device).
- **Local profile is empty/unonboarded** → allowed: adopt the file's ownerId + profile (joining).
- **Mismatch** (both present, different) → **REFUSE the merge.** Show a dialog:
  *"This backup belongs to a different Practice ID. To protect your data, merging is disabled.
  You can Cancel, or Restore-overwrite (replaces ALL local data)."* — never silently mix.
- **Legacy file with no `ownerId`** (exportVersion 1) → **warn + require explicit confirm**
  ("This older backup has no Practice ID; continue merging? It will be treated as yours.").

### 4.3 Validation
- Fix `validateExportData` (§1 latent bug #2): accept `schemaVersion <= AppConstants.schemaVersion`
  (currently rejects `> 4`); reject only genuinely-newer-than-this-app files. Add `exportVersion`
  2 to the accepted set. Extend `summarizeExportData` to surface the file's `ownerId` (or
  "unknown") + whether it matches local, so the pre-import summary dialog can show it.

---

## 5. Task 44.5 — Aggregate correctness after merge

The aggregates (streak, 7/30-day trend, **hold-time progression + personal-best**, alignment %)
read the local DB, so a correct union merge makes them correct automatically. Lock it with tests:
- Seed DB-A with a disjoint set of journal entries (with `holdDurationMs`) + sessions; merge a
  file exported from DB-B (different ids, same ownerId) → assert the aggregate now spans **both**
  sets (e.g. personal-best = max across both; total count = A ∪ B; streak spans both days).
- Overlapping ids (re-merge) → **idempotent** (no duplicates, aggregates unchanged).

---

## 6. Task 44.6 — Bilingual (EN/TA) + UI wiring

**File:** `data_export_import_widget.dart` + ARBs.
- Rework the Settings UI: **Export** (unchanged), **Merge from file** (new default import), and
  **Restore (overwrite)** (relabeled old path). Pre-import **summary dialog** shows counts +
  Practice-ID match/mismatch (from `summarizeExportData`).
- New ARB keys (EN+TA, parity): Practice ID label, "Merge from file", "Restore (overwrite
  everything)", the mismatch-refusal dialog, the legacy-no-ownerId warning, the merge-result
  toast (e.g. "Merged N new sessions"). Pre-PR Tamil gate: verify all render in pure Tamil.

---

## 7. Tests (local green before PR)

- **Migration:** existing DB at v6 (profile w/o ownerId) → upgrade → ownerId backfilled (UUID),
  no data loss; fresh install gets ownerId; idempotent (re-run no-op). Guarded `columnExists`.
- **Merge:** union-by-id (disjoint → union; overlap → idempotent, no dup); never deletes local rows.
- **Owner guard:** match → merges; mismatch → **refuses** (throws/returns a typed refusal, no DB
  mutation); empty-local → adopts file ownerId; legacy no-ownerId → flagged needs-confirm.
- **Aggregate:** streak / hold-time PB / totals correct over A ∪ B (the §5 test).
- **Validation:** `validateExportData` accepts current schema (7) + exportVersion 2, rejects
  genuinely-newer; `summarizeExportData` reports ownerId + match.
- **Regression:** `restoreFromBytes` still fully replaces (old behavior intact); existing
  export/import widget tests updated for the new modes.
- **Local gate:** `flutter analyze` clean + full `flutter test` = same 4 CloudKit only.

---

## 8. Out of scope (Phase 0)

- **No network / no auto-sync / no account** — that is **Phase 1** (transport TBD:
  Vercel-serverless-+-passphrase vs Google Drive). Phase 0 is manual export → safe merge only.
- **No device registry / cap** — Phase 1 management-UX layer.
- **No CloudKit / Google Drive** wiring (the CloudKit engine + gdrive stub stay parked).
- Do not widen merge to overwrite mutable profile/prefs fields — sessions/journal union only.

---

## 9. Definition of Done

See the Sprint 44 Delivery Checklist in [`sprint-tracker.md`](../../sprint-tracker.md). Key gates:
1. **Local `flutter analyze` clean + full `flutter test` green** (same 4 CloudKit only) BEFORE PR
   — correctness-critical (migration + data-merge + identity guard).
2. **Guarded v6→v7 migration** tested on an **existing-profile upgrade path** (not just fresh
   install); ownerId backfilled with no data loss.
3. **Merge is non-destructive + idempotent; owner-ID mismatch REFUSES**; the old overwrite path
   survives as a relabeled "Restore".
4. **Aggregate correct** over a merged (A ∪ B) session/journal set.
5. **Two latent bugs fixed** (`AppConstants.schemaVersion` stale 4→7; `validateExportData`
   schema-ceiling).
6. **Docs:** User Guide "use Saranidhi on more than one device — export & merge" section
   (**NOT `n/a`** — real capability) + architecture note on the ownerId + union-merge model.
7. **Bilingual EN/TA**; fill [`implementation-summary.md`](./implementation-summary.md) +
   [`test-summary.md`](./test-summary.md); Kiro Web reviews the real diff before owner merge.
