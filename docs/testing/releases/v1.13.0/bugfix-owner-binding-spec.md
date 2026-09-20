# Bug-Fix Spec — Practice Sync owner binding (v1.13.0 release blocker #2)

> **Branch:** `release/v1.13.0` (fix on the SAME release branch — do NOT branch from main, do NOT open a new feature branch).
> **Handoff:** Antigravity (coding setup with local `flutter test`/`flutter analyze`).
> **Authority:** Human is sole merge/release authority. Antigravity implements + local green + pushes to `release/v1.13.0` + fills the dossier note. **Never merge, never tag, never open a main→prod PR.**
> **SCOPE (owner-confirmed):** v1.13.0 = **owner-binding fix ONLY** — the minimum to make cross-device sync (same account, two devices) actually work. First-class **sign-up is DEFERRED to v1.13.1** (§5). Do NOT implement sign-up in this release.

---

## 0. Guiding principle (owner-reaffirmed)

The app's primary promise stays **local-first, zero-backend, no-account**. Sync is a **consent-gated, opt-in facility** for users who genuinely need cross-device; everyone else lives the primary promise untouched. Onboarding stays account-free. This fix must not add any account requirement to onboarding or to non-sync use.

**The one problem being solved here:** sync the owner's own sessions/journal **between their own devices** (same account). NOT multi-user-on-one-device (backlog, §6).

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
2. Call a new `OwnerIdentityService.bindOwnerId(String pbUserId)` (see 3.2) to set the profile `ownerId` = pbUserId.
3. Keep the existing `setUserEmail(email)` call.
4. Set `state.isAuthenticated = transport.isAuthenticated` as today (unchanged from the sign-in-state fix).

### 3.2 `OwnerIdentityService.bindOwnerId` — profile-only binding (CONFIRMED, no row migration)

> **CONFIRMED by Kiro (read `lib/database/tables.dart`):** ONLY the `Profiles` table has an `ownerId` column (`TextColumn get ownerId => text().nullable()()`). `SaraKalaiJournal` and `BreathSessions` have **NO** `ownerId` column — the engine stamps `ownerId` onto each row at PUSH time from the resolved profile `ownerId` (`_*MapToRecordBody`). **Therefore the fix is: bind the PROFILE `ownerId` to the PB user id. There is NO row-level migration** — every local row is stamped with the (now-correct) profile ownerId at push time.

Add to `lib/features/settings/domain/owner_identity_service.dart`:
```dart
/// Binds the local profile's ownerId to the authenticated backend (PocketBase) user id.
/// Idempotent: a no-op if the profile ownerId already equals [backendUserId].
/// Returns the effective ownerId (== backendUserId on success).
Future<String?> bindOwnerId(String backendUserId) async { ... }
```
Behavior:
- If no profile exists, no-op → return null (pre-onboarding; sign-in shouldn't be reachable then, but guard anyway).
- Read current profile `ownerId`. If it already equals `backendUserId`, return it (idempotent).
- UPDATE the profile row `ownerId = backendUserId`. Return `backendUserId`.
- Drift, guarded, idempotent. No session/journal row updates (those tables have no `ownerId` column).

### 3.3 Guard the engine: reconcile owner id with the signed-in user

In `PracticeSyncEngine.performSync`, after resolving `ownerId` and confirming authenticated: if `transport.authUserId != null && transport.authUserId != ownerId`, call `bindOwnerId(transport.authUserId!)` once and re-resolve `ownerId` before pull/push. This makes sync self-healing even if binding was skipped at sign-in (e.g. a user who signed in before this fix shipped). Keep it simple — a single re-bind-and-continue.

## 4. Definition of Done (v1.13.0)

1. Sign in on the preview with `usera@gmail.com` → **Sync Now succeeds** (pull + push, no 400). Journal + session rows appear in PocketBase under that user.
2. **Cross-device round-trip (S3, THE primary goal):** same account in a 2nd window/device → pulls the rows pushed from the 1st. This is the release's core success criterion.
3. **Owner-guard (S5):** a DIFFERENT account (`userb`) does NOT see user A's rows.
4. `flutter analyze` clean; full `flutter test` green (existing 683 + new).
5. **Local-first preserved:** onboarding still requires no account; sync remains opt-in and consent-gated.

## 5. DEFERRED to v1.13.1 (fast-follow — do NOT build in v1.13.0)

**First-class sign-up ("Create account") in the Practice Sync sign-in dialog.** Rationale for deferral: the owner already created backend accounts (usera/userb/userc), so sign-up is NOT on the critical path to prove cross-device sync; shipping owner-binding alone keeps v1.13.0 tight and focused on the one broken thing. Sign-up is genuinely useful (one account, signed into from both devices) and will ship next.

When v1.13.1 is taken up, the sign-up design is:
- Mode toggle in `_SignInDialog`: **"Sign in"** ↔ **"Create account"**.
- `transport.signUp({required email, required passphrase})` → PocketBase: `users.create({email, password, passwordConfirm})` then `authWithPassword(email, passphrase)` (auto sign-in). Add to the `SyncTransport` interface + `PocketBaseSyncTransport`.
- After sign-up (auto-authenticated), run the SAME post-auth path as sign-in (bind ownerId, setUserEmail, set state) — extract a shared `_afterAuth()` helper.
- ARB keys (EN + TA), matching `sync*` style, pure Tamil script.
- Passphrase min length per PocketBase default (8); surface server errors (e.g. email already registered).

## 6. Out of scope (deferred backlog — do NOT build)

- **Multi-user / multi-profile on one device** (fast user switching, per-user local partitions, wipe-on-signout). Owner-confirmed backlog: may or may not ship — lower value vs cost; energy goes to higher-value app betterment. Single active account per install. Do NOT add profile-switching or local-data-partitioning.
- Any change to the deployed PocketBase collection rules (they stay strict — that's the point of Option A).

## 7. Regression tests (add)

- `OwnerIdentityService.bindOwnerId`: sets profile ownerId to the backend id; idempotent on repeat (second call is a no-op); no-op returns null when no profile.
- Notifier: after `signIn` with a mock transport exposing `authUserId = 'pbUser123'`, the resolved `ownerId` (via `ensureOwnerId`) equals `'pbUser123'`.
- Engine: `performSync` with `transport.authUserId` matching `ownerId` proceeds to pull/push; a mismatch triggers the re-bind path (3.3) and then proceeds.
- Keep existing owner-guard / merge / idempotency / sign-in-state tests green.

## 8. Handoff rules (deliverable-completeness — follow exactly)

- Fix ONLY on `release/v1.13.0`. Push there. Do NOT merge, tag, or open a main→prod PR.
- Run `flutter analyze` + full `flutter test` locally; paste real counts.
- Confirm the `pocketbase ^0.25.1` accessor for the auth user id (`authStore.model?.id` vs `authStore.record?.id`) actually compiles — do not guess.
- Do NOT implement sign-up (§5) — it is v1.13.1.
- Fill a dossier note `docs/testing/releases/v1.13.0/bugfix-owner-binding-summary.md` (problem, what changed, the ownerId-column finding, test counts, deviations) + add an "Interim fixes during smoke" line to `smoke-test.md`.
- Do NOT commit any secrets / test-user credentials.
- "Done" = code fixed + local green + pushed to `release/v1.13.0` + dossier filled. Report back ready for Kiro diff review + owner re-smoke.
