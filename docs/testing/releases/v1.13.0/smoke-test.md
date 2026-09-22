[← Release dossier](./README.md) · [Releases index](../../smoke-test-results.md)

# Smoke Test — v1.13.0-web (Sprint 47 — ★ Practice Sync Phase 1)

> **Feature smoke — the first release with a live network backend in the gate.** v1.13.0 adds
> opt-in on-demand cross-device sync to a PocketBase backend. This smoke exercises a **real network
> round-trip** to the Fly instance, not just the Vercel preview. Local suite already green (analyze
> clean; **687 pass** / 4 known CloudKit-on-macOS baseline / 0 regressions; Sprint 47 +16, interim fixes +10).
>
> **Environment:** the release PR's Vercel **preview** (built with
> `--dart-define=POCKETBASE_URL=https://saranidhi-pb.fly.dev`) + the live **Fly PocketBase**
> (`https://saranidhi-pb.fly.dev`). Sign in with the PocketBase **test user** created during setup.

## Pre-flight (must pass before any scenario)

- [ ] Preview reachable at the bypass URL (HTTP 200, app shell renders).
- [ ] **About card reads exactly `Saranidhi v1.13.0`** (wrong version → abort, no fallback).
- [ ] Required CI green on the release PR head (Analyze/Fast + Build; Full Suite + Coverage).
- [ ] **Backend reachable:** `curl https://saranidhi-pb.fly.dev/api/health` → `{"code":200,...}`
      (note: first hit may cold-start ~1–2s — scale-to-zero).

## Scenarios

### S1 — Opt-in gate is OFF by default = zero network (consent gate)
1. [ ] Fresh preview (cleared storage) → Settings → **Sync** card present.
2. [ ] The master **Sync toggle is OFF by default**; no sign-in prompt, no network calls fire.
3. [ ] "Sync now" is unavailable/inert while the toggle is off.

### S2 — Sign in to the PocketBase backend
1. [ ] Enable the Sync toggle → sign-in appears.
2. [ ] Sign in with the test user (email + passphrase) → signed-in state shows; no error.
3. [ ] (Wrong password → a quiet, non-blocking error; app stays usable.)

### S3 — The core sync round-trip (HIGHEST VALUE — device A → device B)
> The exact cross-device flow this whole sprint exists for.
1. [ ] **Device A** (or window A): sign in, ensure some breath sessions + journal entries exist, tap **Sync now** → success status, last-synced timestamp updates.
2. [ ] **Device B** (or a second browser/profile with the *same* Practice ID / signed in as the same user): tap **Sync now**.
3. [ ] Device B now shows **Device A's** sessions + journal entries merged in (aggregate/streak/hold-time span both).
4. [ ] Re-tap **Sync now** on either → **idempotent**: 0 new inserted, no duplicates.

### S4 — Selective scope checkboxes
1. [ ] Both checkboxes (**sync sessions** / **sync journal**) default ON.
2. [ ] Uncheck **journal** → Sync now → only sessions sync (journal untouched remotely/locally).
3. [ ] Re-check journal → Sync now → journal syncs.

### S5 — Owner-guard (server + client): no cross-owner leakage
1. [ ] Signed in as the test user, pulled/pushed rows all carry the user's `ownerId`.
2. [ ] (If a second PocketBase user exists) that user's rows are **not** visible/pulled — server rule `ownerId = @request.auth.id` + client owner-guard both hold. No foreign data enters local.

### S6 — Offline-first preserved (regression)
1. [ ] Toggle Sync OFF → the whole app works exactly as before (no network, no degradation).
2. [ ] With Sync ON but backend unreachable (e.g. airplane mode / bad URL): Sync now surfaces a **quiet error status**, **no crash, no data loss, no blocking modal**; local data intact.

### S7 — Bilingual (EN/TA)
1. [ ] Toggle Tamil → the Sync card (toggle, checkboxes + note, sign-in, Sync now, statuses, errors) renders in Tamil.

### S8 — Regression: existing local-only features unaffected
1. [ ] With Sync off (default), onboarding / dashboard / journal / Aruḍam / Settings Merge-Import all behave as in v1.12.1 (spot-check).

## Result

- **Smoke:** ✅ **PASS** — **owner-run** manual smoke on the PR #265 preview (`https://saranidhi-git-release-v1130-eialarasus-projects.vercel.app`) against live Fly PocketBase, across **three physical devices** for the round-trip. (Role note: this release the OWNER ran QA-Verify manually while Antigravity did the interim coding fixes — a deliberate swap from the usual Antigravity-QA-Verify flow.)
- Four backend/app fixes landed on the release branch during smoke (Fixes 1–4 below); a fifth UX item (raw error message) was found and **deferred to v1.13.1** (see note under Interim fixes).

| # | Scenario | Result | Notes |
|---|----------|:------:|-------|
| S1 | Opt-in OFF = zero network | ✅ | Sync toggle OFF (default) → no calls to `saranidhi-pb.fly.dev`; Sync-now inert. |
| S2 | Sign in to PocketBase | ✅ | Signed in as usera + userb; auth-state surfaces correctly (Fix 1). |
| S3 | **Cross-device sync round-trip** | ✅ | Verified across **3 devices** for usera — push/pull merge + idempotent re-sync. |
| S4 | Scope checkboxes | ✅ | Sessions / journal scope toggles work. |
| S5 | Owner-guard (no cross-owner leak) | ✅ | userB signed in sees **none** of usera's rows (server rule + client guard hold). |
| S6 | Offline-first preserved | ✅ | (a) Sync OFF → app fully works, zero network. (b) Backend unreachable → `net::ERR` surfaced, **no crash, no data loss** (message polish deferred to v1.13.1). |
| S7 | Bilingual EN/TA | ✅ | Sync card (toggle, checkboxes, sign-in, statuses) renders in Tamil. |
| S8 | Local-only regression | ✅ | Onboarding / dashboard / journal / Aruḍam / Settings unaffected. |

## Interim fixes during smoke

### Fix 1 — Practice Sync sign-in state not surfacing (release blocker)
- **Summary doc:** [`bugfix-signin-state-summary.md`](./bugfix-signin-state-summary.md)
- **Spec:** [`bugfix-signin-state-spec.md`](./bugfix-signin-state-spec.md)
- **Fix strategy:** Persistent `SharedPreferencesAuthStore` (`AsyncAuthStore` backed by `pb_auth`) + hoisted `practiceSyncAuthStoreProvider` + selective `practiceSyncTransportProvider` rebuild (`serverUrl` only) + reactive `isAuthenticated` in `PracticeSyncState` & `PracticeSyncCard`.
- **Files changed:**
  - `lib/features/cloud_backup/data/pocketbase_sync_transport.dart`
  - `lib/features/cloud_backup/providers/practice_sync_providers.dart`
  - `lib/features/cloud_backup/presentation/widgets/practice_sync_card.dart`
  - `test/features/cloud_backup/pocketbase_sync_transport_test.dart`
  - `test/features/cloud_backup/practice_sync_providers_test.dart`
  - `test/features/cloud_backup/practice_sync_ui_test.dart`
- **Validation:**
  - `flutter analyze`: clean (0 issues)
  - `flutter test`: 683 passed / 4 expected macOS CloudKit tests failed (+6 new regression tests, 0 regressions)
- **Deviations:** None.

### Fix 2 — Practice Sync profile owner-binding to PocketBase user ID (release blocker)
- **Summary doc:** [`bugfix-owner-binding-summary.md`](./bugfix-owner-binding-summary.md)
- **Spec:** [`bugfix-owner-binding-spec.md`](./bugfix-owner-binding-spec.md)
- **Fix strategy:** Expose `authUserId` on `SyncTransport` / `PocketBaseSyncTransport` (^0.25.1 API) + idempotent `bindOwnerId` in `OwnerIdentityService` + bind & invalidate on `signIn()` in `PracticeSyncNotifier` + self-healing reconciliation check in `PracticeSyncEngine.performSync()`. Sign-up UI deferred to v1.13.1.
- **Files changed:**
  - `lib/features/cloud_backup/domain/sync_transport.dart`
  - `lib/features/cloud_backup/data/pocketbase_sync_transport.dart`
  - `lib/features/settings/domain/owner_identity_service.dart`
  - `lib/features/cloud_backup/providers/practice_sync_providers.dart`
  - `lib/features/cloud_backup/domain/practice_sync_engine.dart`
  - `test/features/settings/owner_identity_service_test.dart`
  - `test/features/cloud_backup/practice_sync_engine_test.dart`
  - `test/features/cloud_backup/practice_sync_providers_test.dart`
- **Validation:**
  - `flutter analyze`: clean (0 issues)
  - `flutter test`: 687 passed / 4 expected macOS CloudKit tests failed (+4 new regression tests, 0 regressions)
- **Deviations:** None.

### Fix 3 — PocketBase `required` rejects falsy values (backend schema; no app change)
- **Summary doc:** [`bugfix-required-fields-summary.md`](./bugfix-required-fields-summary.md)
- **Symptom:** `isAligned:false` (misaligned journal entry) → `400 {isAligned: validation_required}`. PocketBase's `required` validator rejects a type's ZERO VALUE (`bool false`, `number 0`, empty text).
- **Fix:** only `uuid` + `ownerId` stay `required`; all data fields → `required: false`. Original migration updated (fresh deploys) + new `tool/dev/pb_migrations/1710000001_relax_required_data_fields.js` patches live collections. Confirmed live against Fly.
- **Verification:** re-run Sync Now with a misaligned journal entry → no 400. (Cross-device sync then verified working across 3 devices for the same user.)

### Fix 4 — `uuid` unique per-owner, not global (backend schema; no app change)
- **Summary doc:** [`bugfix-uuid-per-owner-summary.md`](./bugfix-uuid-per-owner-summary.md)
- **Symptom:** userB Sync Now → `400 {uuid: validation_not_unique}` when pushing a row whose uuid already exists under userA (same physical data / install). No cross-owner READ leak — write-collision only.
- **Root cause:** global `UNIQUE INDEX (uuid)` vs the engine's `ownerId+uuid` upsert logic.
- **Fix:** composite `UNIQUE INDEX (ownerId, uuid)` on both collections. Original migration updated (fresh deploys) + new `tool/dev/pb_migrations/1710000002_uuid_unique_per_owner.js` patches live collections.
- **Verification:** redeploy Fly → S5 owner-guard with userB on a FRESH install (its own journal) → sync succeeds, no cross-owner data visible. ✅ **PASS**

### Fix 5 — raw `ClientException` shown on sign-in/sync errors → DEFERRED to v1.13.1
- **Spec:** [`bugfix-signin-error-ux-spec.md`](./bugfix-signin-error-ux-spec.md) (targets v1.13.1).
- **Symptom:** wrong password / backend-down surfaces the raw exception dump instead of a friendly localized message.
- **Decision:** UX polish, not a functional blocker (sync works; no crash/data loss). Batched with the deferred first-class **sign-up** into **v1.13.1** per the release-effort heuristic (batch small UX items rather than N separate ~2h releases). Not in v1.13.0 scope.


