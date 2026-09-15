[← Back to Dossier](./README.md)

# Sprint 45 Spec — v1.12.1 fast-follow: Practice-Sync polish

> **Author:** Kiro Web · **Implementer:** Antigravity (local green before PR) · **Reviewer:** Kiro Web
> **Target release:** v1.12.1-web (patch) · **Schema:** unchanged (v7) · **Export version:** unchanged (2)

This spec is ready-to-implement. Every touchpoint below was verified against the current `main`
this session. Tasks are independent; implement in any order. **No schema/migration change.**

---

## Context (why these three)

The v1.12.0 owner cross-device smoke surfaced one structural gap + two quality issues, all deferred
to this fast-follow (backlog PR #240):

1. A brand-new device shows onboarding, but Merge/Restore live in **Settings** — reachable only
   *after* onboarding completes. So "import on the new device to adopt my existing Practice ID
   *before* setting up a fresh profile" is not directly reachable. Workaround today: complete a
   throwaway onboarding, then Restore-overwrite in Settings.
2. After a Restore/Merge the Settings **profile card** shows the *old* Practice ID until a manual
   page reload (cosmetic; DB is correct).
3. Exported files are all named `saranidhi_backup_<timestamp>.json` — indistinguishable across
   devices, so it's easy to Restore the wrong file.

---

## Task 45.1 — Onboarding "Import from another device" entry point (🔴 structural)

### Goal
On a genuinely new device, let the user **import an existing backup before completing onboarding**,
so the device **adopts the existing Practice ID** (`ownerId`) instead of minting a fresh one.

### Design decision (owner-confirmed)
**Option (a): a subtle link on the intro screen** — least intrusive, matches the "adopt existing
Practice ID" intent. NOT a new onboarding step, NOT a prominent button.

### Key grounding — the domain layer already supports this
Verified in `lib/features/cloud_backup/domain/database_exporter.dart`:
- `mergeFromBytes` (l.219) handles the **empty-local** case: when `localProfiles.isEmpty` it inserts
  the file's profile **adopting the file's `ownerId`** (l.242–286) AND calls `_importPreferences`
  (l.289), which includes the `onboarding_complete` key (`_exportedPrefKeys`, l.19).
- `checkOwnerGuard` returns `OwnerGuardStatus.emptyLocal` for a fresh device → merge is allowed and
  adopts the ownerId. No mismatch is possible on an empty device.
- `data_export_import_widget.dart` `_invalidateAllDataProviders()` already invalidates
  `onboardingCompleteProvider`.

**Therefore:** once a fresh device merges a backup, `onboarding_complete` becomes `true` (from the
file's preferences) and — after invalidating `onboardingCompleteProvider` — `OnboardingGuard`
(`lib/core/router/onboarding_guard.dart`) flips straight to the main app. **45.1 is primarily a UI
entry point that drives the existing merge path.**

### Where the link goes
`lib/features/onboarding/presentation/intro_screen.dart` — the intro screen is the first thing a new
device sees. Add the link **directly below the "Get Started" `FilledButton.icon`** (inside the
bottom `Padding`, after the existing `SizedBox`), as a subtle `TextButton`:

- Label (new ARB key `introImportFromDevice`): EN "Already using Saranidhi on another device? Import"
  / TA "மற்றொரு சாதனத்தில் ஏற்கனவே சரணிதி பயன்படுத்துகிறீர்களா? இறக்குமதி செய்யவும்".
- Style: `TextButton` (no fill), small; visually secondary to Get Started.

### Behavior
Convert `IntroScreen` from `ConsumerWidget` to `ConsumerStatefulWidget` (it needs a busy flag + a
`BuildContext` with a Navigator/overlay for the file picker + dialogs). On tap:

1. Pick a JSON file (reuse the picker + validation logic — see "Shared helper" below).
2. If cancelled/invalid → snackbar, stay on intro.
3. Run the same guard-aware merge flow as Settings for the **empty-local** device:
   - `checkOwnerGuard(data)` → on a fresh device this is `emptyLocal` (adopt) — proceed to a
     **confirm dialog** summarizing what will be imported (reuse the existing merge summary dialog
     copy: `mergeConfirmTitle` / `mergeConfirmMessage` + `_SummaryRow`s + `practiceIdAdopting`).
   - `legacyNoOwnerId` (an old backup with no ownerId) → the existing legacy-warn confirm dialog,
     then `mergeFromBytes(bytes, allowLegacy: true)`.
   - `mismatch` is **not reachable** on an empty device, but if it somehow occurs, show the same
     refuse dialog Settings uses and stay on intro (do NOT silently overwrite).
4. On successful merge: invalidate the data providers **including `onboardingCompleteProvider` and
   `ownerIdProvider`** (reuse the same invalidation set as Settings). The guard then flips to the
   main app. Show a success snackbar.

### Avoid duplication — extract a shared helper
`_handleMerge` / `_pickJsonFile` / the three guard dialogs currently live privately in
`data_export_import_widget.dart`. To reuse them from the intro screen **without copy-paste**,
extract the merge-from-picked-file flow into a small reusable place. **Preferred:** a
`MergeImportController` (or top-level function) in
`lib/features/settings/domain/` (or `lib/features/cloud_backup/presentation/`) that takes a
`BuildContext` + `WidgetRef` and runs: pick → validate → guard → dialog → `mergeFromBytes` →
invalidate → snackbar, returning a `bool merged`. Then:
- `DataExportImportWidget._handleMerge` calls it.
- `IntroScreen`'s new link calls it.

If a full controller extraction is too invasive for a patch, the acceptable fallback is a shared
**mixin or static helper** that both widgets call — but **do not duplicate the guard/dialog logic**.
Reviewer will check for duplication.

### Copy / i18n
- New ARB key `introImportFromDevice` in **both** `app_en.arb` and `app_ta.arb`.
- Reuse existing merge/guard ARB keys (`mergeConfirmTitle`, `mergeConfirmMessage`,
  `mergeConfirmButton`, `merging`, `mergeSuccess`, `practiceIdAdopting`, `legacyBackupWarningTitle`,
  `legacyBackupWarningMessage`, `continueMerge`, `importInvalidFile`, `importFailedReadFile`,
  `cancel`, `importJournalEntries`, `importBreathSessions`, etc.). Do NOT invent duplicates.

### Regression / DoD
- New device: intro → tap Import → pick a valid backup → confirm → lands on the **main app** with
  the imported data and the **adopted Practice ID** (matches the source device).
- The normal happy path (tap **Get Started**, no import) is **unchanged**.
- EN + TA copy present for the new link and any new snackbar.

---

## Task 45.2 — BUG-v1.12.0-01: Practice ID not refreshed after Restore/Merge (🟢)

### Root cause (verified)
`lib/features/settings/presentation/profile_card.dart` builds from its **own `FutureBuilder`**
(l.59–62) that reads `ref.read(appDatabaseProvider).select(...profiles).get()` directly. A
`FutureBuilder` created inside `build` only re-runs its future when the widget rebuilds; nothing
tells it to after an import. `data_export_import_widget.dart` `_invalidateAllDataProviders()`
invalidates dashboard/journal/**ownerId**/theme/locale/notifications/onboarding — but the profile
card doesn't *watch* any of those, so it never rebuilds. The DB row is already correct; it self-heals
on a manual reload.

### Fix
Make the profile card rebuild when the profile changes, by watching a Riverpod provider that IS in
the invalidate list:

**Preferred:** introduce a `profileProvider` (a `FutureProvider<Profile?>` that reads the first
profile row) in an appropriate providers file (e.g.
`lib/features/settings/providers/profile_providers.dart`, or alongside `ownerIdProvider`). Then:
1. In `profile_card.dart`, replace the inline `FutureBuilder(future: ...get())` with
   `ref.watch(profileProvider)` (use `.when`/`AsyncValue`), keeping the existing empty-state
   (`SizedBox.shrink()`) and the whole rendered `Card` unchanged.
2. Add `profileProvider` to `_invalidateAllDataProviders()` in `data_export_import_widget.dart` so
   Merge **and** Restore both refresh it.
3. Also invalidate `profileProvider` where the profile is mutated in-card (name save, birth-star
   edit, location edit) so those in-place edits stay consistent — OR keep the existing `setState`
   there; either is acceptable as long as import-refresh works. (The existing `_loadProfile` /
   `setState(_isEditing)` name-edit flow can remain.)

**Acceptable lighter alternative** if a new provider is undesirable: have the profile card
`ref.watch(ownerIdProvider)` (already invalidated on import) and rebuild the `FutureBuilder` off that
value (e.g. key the `FutureBuilder` on the watched ownerId, or move the query into a provider keyed
by it). The profile card already imports from streaks/onboarding providers, so adding a provider
watch is idiomatic here.

### DoD
- After a Merge or Restore in Settings, the profile card's **Practice ID (and name/bird/location if
  changed) update without a page reload**.
- No regression to the in-card edit (name / birth-star / location) flows.

---

## Task 45.3 — Practice ID prefix in export filename (🟢)

### Change (string-only, no logic/schema)
`lib/features/settings/presentation/data_export_import_widget.dart` `_handleExport` (l.195–196):

```dart
final dateStr = DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now());
final filename = 'saranidhi_backup_$dateStr.json';
```

Change to include the first 8 chars of the owner id when available:

```dart
final ownerId = ref.read(ownerIdProvider).valueOrNull; // or read the profile row
final prefix = (ownerId != null && ownerId.isNotEmpty)
    ? '${ownerId.substring(0, ownerId.length < 8 ? ownerId.length : 8)}_'
    : '';
final dateStr = DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now());
final filename = 'saranidhi_backup_$prefix$dateStr.json';
// e.g. saranidhi_backup_3f9a1c2b_2026-09-15-1034.json
```

- Use whatever the codebase already exposes for the current owner id (`ownerIdProvider` — confirm its
  type; if it's an `AsyncValue`, use `.valueOrNull`; if a plain `String?` provider, read directly).
  If reading it synchronously is awkward inside `_handleExport`, query the profile row you already
  have access to via `databaseExporterProvider`/`appDatabaseProvider`.
- **Guard null/empty `ownerId`** (pre-onboarding / legacy) → fall back to the current unprefixed name.
- Forward-compatible: at Phase 1 the prefix label becomes the account id / email — keep the prefix
  construction in one obvious place.

### DoD
- Exported filename is `saranidhi_backup_<first8-of-ownerId>_<timestamp>.json` when an ownerId
  exists; unprefixed fallback otherwise.

---

## Tests (add with the implementation)

- **45.1:** widget test — intro screen renders the Import link; tapping it (with a stubbed picker
  returning a valid empty-local backup) runs the merge and results in `onboardingCompleteProvider`
  becoming `true` (guard would flip). Verify the adopted ownerId equals the file's ownerId. Verify
  the Get-Started happy path is unaffected.
- **45.2:** widget/provider test — after invalidating `profileProvider` (simulating an import), the
  profile card shows the new ownerId without a manual rebuild trigger. (Or a provider-level test
  that `profileProvider` re-reads after invalidation.)
- **45.3:** unit test on the filename builder — with an ownerId → prefixed; null/empty → unprefixed;
  short (<8 char) ownerId → uses full length (no `RangeError`).
- **Regression:** existing merge/restore/guard tests stay green; onboarding happy-path test stays
  green.

## Definition of Done (Sprint 45)

- [ ] 45.1 — new device can import/adopt an existing Practice ID **without first completing
      onboarding**; adopts the file's `ownerId`; lands on the main app; EN/TA copy present; guard/
      dialog logic **not duplicated** (shared helper/controller).
- [ ] 45.2 — profile card Practice ID refreshes **without a page reload** after Merge/Restore.
- [ ] 45.3 — export filename carries the first-8 of the owner id; null/empty falls back; no `RangeError`.
- [ ] Onboarding happy-path + existing Merge/Restore-in-Settings flows unchanged (regression).
- [ ] Local `flutter analyze` clean + full test suite green **before** PR.
- [ ] User Guide: short "set up a new device by importing" note added.
- [ ] New tests for the intro-import route, the profile refresh, and the filename builder.
