# Bug-Fix Spec — Practice Sync owner binding (v1.13.0 release blocker #2)

> **Branch:** `release/v1.13.0` (fix on the SAME release branch — do NOT branch from main, do NOT open a new feature branch).
> **Handoff:** Antigravity (coding setup with local `flutter test`/`flutter analyze`).
> **Authority:** Human is sole merge/release authority. Antigravity implements + local green + pushes to `release/v1.13.0` + fills the dossier note. **Never merge, never tag, never open a main→prod PR.**

---

## 1. Symptom (owner-reproduced on the PR #265 preview)

Sign-in works (card shows "Signed in as usera@gmail.com", "Sync Now" enabled), but tapping **Sync Now** fails:
```
Sync failed: ClientException: url: https://saranidhi-pb.fly.dev/api/collections/journal/records,
statusCode: 400, response: {code: 400, message: Failed to create record., data: {}}
```
Network tab: GET pulls return 200, but `POST .../journal/records` returns **400 with empty `data:{}`**. The request payload shows `ownerId: "712dda6f-c58e-46b4-ae64-2f958bc1d25a"` (a device UUID v4).

## 2. Root cause (confirmed by reproducing against live Fly PocketBase)

The PocketBase collections (`sessions`, `journal`) have:
```
createRule: @request.auth.id != "" && ownerId = @request.auth.id
```
This requires the **record's `ownerId` to equal the authenticated PocketBase user's record id** (`@request.auth.id`).

But the app writes `ownerId` = a **device-generated Practice ID** (`OwnerIdentityService.ensureOwnerId()` → local UUID v4 on the profile row), which has NO relationship to the PB user id. So:
- **Pull returns 200** but silently matches ZERO rows (the `listRule` filters `ownerId = @request.auth.id`; the device UUID never matches → empty list, no error → looks fine but syncs nothing).
- **Push fails 400 with empty `data:{}`** — an empty-`data` 400 is PocketBase's signature for a **createRule denial** (not field validation). Verified live: a fully-valid unauthenticated create returns `400 data:{}`; the same body with a field-level problem returns named field errors. The app's `data:{}` = rule denial.

**Decision (owner-confirmed): Option A — bind the app's `ownerId` to the PocketBase user id.** One PocketBase account = one owner. Keep the strict server-side rules exactly as deployed (no backend change). This makes per-user isolation server-enforced, not just client-side.

## 3. Required fix

### 3.1 Stamp `ownerId` to the PB user id on successful sign-in

In `PracticeSyncNotifier.signIn()` (`lib/features/cloud_backup/providers/practice_sync_providers.dart`), after `transport.signIn(...)` succeeds:
1. Read the authenticated PocketBase user record id. Expose it from the transport, e.g. add to `PocketBaseSyncTransport`:
   ```dart
   String? get authUserId => _client.authStore.isValid ? _client.authStore.model?.id as String? : null;
   ```
   (Confirm the exact accessor against the pinned `pocketbase: ^0.25.1` — it may be `_client.authStore.record?.id` in newer versions. Use whichever compiles; verify `flutter analyze` clean.)
   Add a matching `String? get authUserId;` to the `SyncTransport` interface returning null for non-PB transports.
2. Call a new `OwnerIdentityService.bindOwnerId(String pbUserId)` (see 3.2) to set the profile `ownerId` = pbUserId AND migrate existing local rows.
3. Keep the existing `setUserEmail(email)` call.
4. Set `state.isAuthenticated = transport.isAuthenticated` as today.

> **CONFIRMED by Kiro (read `lib/database/tables.dart`):** ONLY the `Profiles` table has an `ownerId` column (`TextColumn get ownerId => text().nullable()()`). `SaraKalaiJournal` and `BreathSessions` have NO `ownerId` column — the engine stamps `ownerId` onto each row at PUSH time from the resolved profile `ownerId` (`_*MapToRecordBody`). **Therefore the fix is simply: bind the PROFILE `ownerId` to the PB user id. There is NO row-level migration to do** — every local row is stamped with the (now-correct) profile ownerId at push time. The row-migration loop below is therefore OMITTED; implement profile-only binding.

### 3.2 `OwnerIdentityService.bindOwnerId` — set profile owner (profile-only, confirmed)

Add to `lib/features/settings/domain/owner_identity_service.dart`:
```dart
/// Binds the local profile's ownerId to the authenticated backend user id.
/// Migrates any existing local session/journal rows that still carry the OLD
/// ownerId over to the new id, so pre-sign-in history syncs under this account.
/// Idempotent: a no-op if the profile ownerId already equals [backendUserId].
Future<void> bindOwnerId(String backendUserId) async { ... }
```
Behavior:
- If no profile exists, no-op (pre-onboarding — sign-in shouldn't be reachable then, but guard anyway).
- Read current profile `ownerId`.
- If it already equals `backendUserId`, return (idempotent).
- UPDATE the profile row `ownerId = backendUserId`.
- Use Drift, guarded, idempotent. (No session/journal row updates — those tables have no ownerId column; they're stamped at push time.)

> Note: check whether `breathSessions`/`saraKalaiJournal` currently even HAVE an `ownerId` column locally. Sprint 47 added `ownerId` to the PUSH BODY (`_*MapToRecordBody`) sourced from the resolved `ownerId`, but `sessionToMap`/`journalToMap` in `database_exporter.dart` do NOT emit `ownerId` from a local column — the engine stamps `ownerId` at push time from `ensureOwnerId()`. CONFIRM in `lib/database/tables.dart`: if the local session/journal tables have no `ownerId` column, then there is nothing to migrate at the row level — the push simply uses the profile `ownerId` at send time, so binding the PROFILE ownerId is sufficient and 3.2's row-migration loop is a no-op / omit it. **Verify this and state it in the impl summary.** (Only the `profiles` table is known to have `ownerId`.) The correct, minimal fix is: bind the PROFILE `ownerId` to the PB user id; the engine then pushes every local row stamped with that id.

### 3.3 Guard the engine: fail fast if owner id ≠ signed-in user

In `PracticeSyncEngine.performSync`, after resolving `ownerId` and confirming authenticated, add a defensive check: if `transport.authUserId != null && transport.authUserId != ownerId`, attempt `bindOwnerId(transport.authUserId!)` once and re-resolve, OR return a clear error ("Account not linked to this practice — please sign in again"). This prevents the silent zero-row pull / 400-push if binding ever gets skipped. Keep it simple; a single re-bind-and-continue is fine.

## 4. Add sign-up (create account) — owner-requested, same release

Owner wants the traditional auth flow available at the point of opt-in (NOT forced at onboarding — local-first stays account-free). In the sign-in dialog (`_SignInDialog` in `practice_sync_card.dart`):
- Add a mode toggle: **"Sign in"** ↔ **"Create account"**.
- Create-account mode calls a new `transport.signUp({required email, required passphrase})` which, for PocketBase, does:
  ```dart
  await _client.collection('users').create(body: {
    'email': email, 'password': passphrase, 'passwordConfirm': passphrase,
  });
  await _client.collection('users').authWithPassword(email, passphrase); // auto sign-in
  ```
  Add `Future<void> signUp({required String email, required String passphrase})` to the `SyncTransport` interface + `PocketBaseSyncTransport`.
- After successful sign-up (which auto-authenticates), run the SAME post-sign-in path (bind ownerId, setUserEmail, set state). Reuse `PracticeSyncNotifier.signIn`'s tail or extract a shared `_afterAuth()` helper.
- Add ARB keys (EN + TA) for the new UI strings (e.g. `syncCreateAccountAction`, `syncCreateAccountSubmit`, `syncHaveAccountToggle`, `syncNeedAccountToggle`, `syncSignUpFailed`). Match existing `sync*` key style; keep Tamil pure-script.
- Validation: passphrase min length per PocketBase default (8). Show the server error message on failure (e.g. email already registered).

> If sign-up meaningfully expands scope/time, it MAY be split to a fast-follow — but the owner asked for it this release; include it unless it destabilizes the fix. State the decision in the impl summary.

## 5. Out of scope (explicitly deferred — do NOT build)

- **Multi-user / multi-profile on one device** (fast user switching, per-user local partitions, wipe-on-signout). This is a separate future epic; single active account per install for now. Do not add profile-switching or local-data-partitioning.
- Any change to the deployed PocketBase collection rules (they stay strict — that's the point of Option A).

## 6. Definition of Done

1. Sign in on the preview with `usera@gmail.com` → Sync Now → **succeeds** (pull + push, no 400). Journal + session rows appear in PocketBase under that user.
2. Cross-device round-trip (S3): same account in a 2nd window → pulls the pushed rows.
3. Owner-guard (S5): a DIFFERENT account (`userb`) does NOT see user A's rows.
4. New account via "Create account" → auto signs in → sync works.
5. `flutter analyze` clean; full `flutter test` green (existing 683 + new).
6. Local-first preserved: onboarding still requires no account; sync remains opt-in.

## 7. Regression tests (add)

- `OwnerIdentityService.bindOwnerId`: sets profile ownerId to the backend id; idempotent on repeat; (if row-level migration applies per 3.2, assert rows migrate — otherwise assert profile-only).
- Notifier: after `signIn` with a mock transport exposing `authUserId = 'pbUser123'`, the resolved `ownerId` (via `ensureOwnerId`) equals `'pbUser123'`.
- Transport: `signUp` calls create + authWithPassword (mock HTTP 200) → `isAuthenticated == true`.
- Engine: `performSync` with `transport.authUserId` matching ownerId pushes; mismatch triggers the re-bind path (3.3).
- Keep existing owner-guard / merge / idempotency / sign-in-state tests green.

## 8. Handoff rules (deliverable-completeness — follow exactly)

- Fix ONLY on `release/v1.13.0`. Push there. Do NOT merge, tag, or open a main→prod PR.
- Run `flutter analyze` + full `flutter test` locally; paste real counts.
- Confirm the `pocketbase ^0.25.1` accessor for the auth user id (`authStore.model?.id` vs `authStore.record?.id`) actually compiles — do not guess.
- Confirm (§3.2 note) whether local session/journal tables have an `ownerId` column; state it and adjust the migration accordingly.
- Fill a dossier note `docs/testing/releases/v1.13.0/bugfix-owner-binding-summary.md` (problem, what changed, sign-up include/defer decision, the ownerId-column finding, test counts, deviations) + add an "Interim fixes during smoke" line to `smoke-test.md`.
- Do NOT commit any secrets / test-user credentials.
- "Done" = code fixed + local green + pushed to `release/v1.13.0` + dossier filled. Report back ready for Kiro diff review + owner re-smoke.
