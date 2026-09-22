# Bug-Fix Summary — Practice Sync Profile Owner-Binding (v1.13.0 Release Blocker)

> **Branch:** `release/v1.13.0`  
> **Spec:** [`bugfix-owner-binding-spec.md`](./bugfix-owner-binding-spec.md)  
> **Smoke Test:** [`smoke-test.md`](./smoke-test.md)  
> **Role / Handoff:** Antigravity (implementation + local QA-Verify) → Kiro Web (diff review) & Owner (sole merge/release authority).

---

## 1. Problem & Root Cause

During S3 cross-device smoke testing of Practice Sync on the PR #265 Vercel preview deployment, the owner signed in with valid PocketBase credentials (`usera@gmail.com`). When attempting "Sync now", the server rejected all push writes with HTTP 400:
```json
{"code":400,"message":"Failed to create record.","data":{"ownerId":{"code":"validation_not_unique_or_invalid","message":"Only the owner can manage their records."}}}
```

### Root Cause
PocketBase collection API rules enforce:
```text
@request.auth.id != "" && ownerId = @request.auth.id
```
In Saranidhi, practice records (`SaraKalaiJournal` and `BreathSessions`) do not store an `ownerId` column locally in SQLite. Instead, `PracticeSyncEngine` stamps the outgoing payload's `ownerId` dynamically by querying `OwnerIdentityService.ensureOwnerId()`, which retrieves the `ownerId` column from the singleton `Profiles` table row.

On first launch, Saranidhi generates a random UUID (e.g. `2358fb96-a83d-495c-a5b5-f48529329068`) as the local profile's `ownerId`. PocketBase user record IDs, however, are 15-character alphanumeric strings (e.g. `1vszgbbj9x4r0x9`). Because the local profile `ownerId` was never rebound to the PocketBase authenticated user ID on sign-in, the sync engine pushed records stamped with the local UUID. PocketBase rejected them because `ownerId != @request.auth.id`. Furthermore, pull queries filter by `ownerId = '<ownerId>'`, which would yield zero records across devices if the IDs do not match.

---

## 2. Chosen Fix Strategy

Per §3 of [`bugfix-owner-binding-spec.md`](./bugfix-owner-binding-spec.md):

1. **Expose Authenticated User ID on Transport:**
   - Added `String? get authUserId;` to the `SyncTransport` domain interface.
   - Implemented `authUserId` in `PocketBaseSyncTransport` using the PocketBase Dart SDK `^0.25.1` API:
     ```dart
     @override
     String? get authUserId {
       if (!isAuthenticated) return null;
       final id = _client.authStore.record?.id;
       return (id != null && id.isNotEmpty) ? id : null;
     }
     ```
2. **Add Idempotent `bindOwnerId` to `OwnerIdentityService`:**
   - Added `Future<String?> bindOwnerId(String backendUserId)` to `OwnerIdentityService`:
     - Queries `profilesDao.getProfile()`.
     - If no profile exists, returns `null` (safe no-op).
     - If `profile.ownerId == backendUserId`, already bound; returns `backendUserId` immediately.
     - Otherwise updates the single profile row with `ownerId = backendUserId` and returns `backendUserId`.
3. **Bind on Successful Sign-In:**
   - In `PracticeSyncNotifier.signIn()`, immediately after `transport.signIn()` returns true, retrieves `transport.authUserId`.
   - Calls `await _ref.read(ownerIdentityServiceProvider).bindOwnerId(pbUserId)`.
   - Invalidates `ref.invalidate(ownerIdProvider)` to ensure all downstream watchers get the updated ID.
4. **Self-Healing Reconciliation in Sync Engine:**
   - In `PracticeSyncEngine.performSync()`, added an automated check before pulling or pushing:
     ```dart
     if (transport.authUserId != null && transport.authUserId != ownerId) {
       await ownerIdentityService.bindOwnerId(transport.authUserId!);
       ownerId = transport.authUserId!;
     }
     ```
   - This ensures existing signed-in sessions or edge cases automatically reconcile without requiring the user to sign out and sign back in.
5. **Strict Scope Discipline — Deferred Sign-Up (§5):**
   - As mandated by the handoff rules, first-class account creation ("Create account", §5 of the spec) is strictly deferred to v1.13.1.
   - Onboarding remains 100% account-free and local-first.

---

## 3. Files Changed

| File | Change |
|---|---|
| `lib/features/cloud_backup/domain/sync_transport.dart` | Added `String? get authUserId;` to interface. |
| `lib/features/cloud_backup/data/pocketbase_sync_transport.dart` | Implemented `authUserId` via `_client.authStore.record?.id`. |
| `lib/features/settings/domain/owner_identity_service.dart` | Added `bindOwnerId(String backendUserId)` method. |
| `lib/features/cloud_backup/providers/practice_sync_providers.dart` | In `signIn()`, call `bindOwnerId(pbUserId)` and `ref.invalidate(ownerIdProvider)`. |
| `lib/features/cloud_backup/domain/practice_sync_engine.dart` | Added self-healing ownerId reconciliation before pull/push in `performSync()`. |
| `test/features/settings/owner_identity_service_test.dart` | Added unit tests for `bindOwnerId` (no-op on empty profiles, updates profile ownerId, idempotent on repeat). |
| `test/features/cloud_backup/practice_sync_engine_test.dart` | Added `authUserId` to `FakeSyncTransport` and added test verifying `performSync` reconciles mismatched `ownerId` and pulls/pushes with it. |
| `test/features/cloud_backup/practice_sync_providers_test.dart` | Added unit test verifying `PracticeSyncNotifier.signIn` binds profile `ownerId` to `transport.authUserId`. |
| `docs/testing/releases/v1.13.0/smoke-test.md` | Added Fix 2 entry under "Interim fixes during smoke". |
| `docs/testing/releases/v1.13.0/bugfix-owner-binding-summary.md` | This summary document. |

---

## 4. Test Verification Counts

### Static Analysis
```bash
flutter analyze
```
- **Result:** `No issues found! (ran in 4.0s)` — clean (0 issues).

### Unit & Widget Test Suite
```bash
flutter test
```
- **Baseline before fix:** 683 passed / 4 expected macOS CloudKit tests failed.
- **After fix:** 687 passed / 4 expected macOS CloudKit tests failed.
- **Delta:** **+4 new passing regression tests**, **0 regressions**.
- **Failed tests:** Exactly the 4 expected macOS platform stubs in `backup_repository_test.dart` (`ICloudBackupRepository` non-Apple platform tests).

---

## 5. Scope & Deviations

- **Scope:** Strictly confined to the owner-binding defect on `release/v1.13.0`.
- **Sign-Up UI (§5):** Omitted entirely; deferred to v1.13.1.
- **Secrets / Credentials:** Zero secrets or credentials committed.
- **Git State:** No git tags or merges to main/prod performed.
