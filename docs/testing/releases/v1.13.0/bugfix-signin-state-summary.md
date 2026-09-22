# Bug-Fix Summary — Practice Sync Sign-In State Surfacing (v1.13.0 Release Blocker)

> **Branch:** `release/v1.13.0`  
> **Spec:** [`bugfix-signin-state-spec.md`](./bugfix-signin-state-spec.md)  
> **Smoke Test:** [`smoke-test.md`](./smoke-test.md)  
> **Role / Handoff:** Antigravity (implementation + local QA-Verify) → Kiro Web (diff review) & Owner (sole merge/release authority).

---

## 1. Problem & Root Cause

During smoke testing on the PR #265 Vercel preview deployment, the owner signed in with valid PocketBase credentials (`usera@gmail.com`). The server returned HTTP 200 with the auth token, but the UI stayed in "Not signed in", the Sign Out button never showed, and "Sync now" remained disabled.

Code trace confirmed two compounding defects:
1. **Defect A (Transport destruction on config change):** `practiceSyncTransportProvider` watched the entire `practiceSyncConfigProvider` and created a fresh `PocketBaseSyncTransport` on every rebuild. `PracticeSyncNotifier.signIn()` authenticated the current transport and then called `setUserEmail(email)`, which mutated `PracticeSyncConfig`, triggering a rebuild of `practiceSyncTransportProvider` and instantiating a brand-new transport with an empty in-memory `AuthStore`.
2. **Defect B (Non-reactive auth state):** `PracticeSyncCard` inspected `transport.isAuthenticated` directly (a non-reactive getter on a provider), meaning internal token mutations never scheduled widget rebuilds.
3. **Web Reload Auth Loss:** The default in-memory `AuthStore` in the PocketBase client loses auth tokens whenever a web page is reloaded.

---

## 2. Chosen Fix Strategy

We selected the **preferred persistent store + hoisted store** architecture outlined in §3.1–3.4 of the spec:

1. **Persistent `SharedPreferencesAuthStore`:**
   - Implemented `SharedPreferencesAuthStore` extending `AsyncAuthStore` (from `package:pocketbase/pocketbase.dart`) backed by key `pb_auth`.
   - Populates initial state synchronously when provided or cached, saves JSON on `save()`, removes key on `clear()`, and rehydrates on demand via `rehydrate()`.
   - Safely catches uninitialized bindings in pure non-widget unit tests.
2. **Hoisted AuthStore & Selective Transport Rebuilding:**
   - Added `practiceSyncAuthStoreProvider = Provider<AuthStore>((ref) => SharedPreferencesAuthStore());`.
   - Updated `practiceSyncTransportProvider` to depend only on `practiceSyncConfigProvider.select((c) => c.serverUrl)`, injecting the hoisted `authStore`.
   - Mutations to `userEmail`, `scopeSessions`, `scopeJournal`, `enabled`, or `lastSynced` no longer rebuild or discard the transport.
3. **Reactive `isAuthenticated` in `PracticeSyncState`:**
   - Added `final bool isAuthenticated;` and `copyWith` to `PracticeSyncState`.
   - `PracticeSyncNotifier` watches `practiceSyncTransportProvider`, syncs state on `build()`, listens to `transport.authStore.onChange`, triggers `transport.rehydrateAuth()`, and explicitly updates `isAuthenticated` on `signIn()`, `signOut()`, and `syncNow()`.
4. **Reactive UI in `PracticeSyncCard`:**
   - Replaced all 3 reads of `transport.isAuthenticated` with `syncState.isAuthenticated` (`_AccountSection`, `onPressed` gate for "Sync now", and italic explanatory hint).
   - Removed the unused `practiceSyncTransportProvider` watch from `PracticeSyncCard.build()`.

---

## 3. Files Changed

| File | Change |
|---|---|
| `lib/features/cloud_backup/data/pocketbase_sync_transport.dart` | Added `kPocketBaseAuthStoreKey`, `SharedPreferencesAuthStore` (subclass of `AsyncAuthStore`), `rehydrateAuth()` helper, and `authStore` getter on `PocketBaseSyncTransport`. |
| `lib/features/cloud_backup/providers/practice_sync_providers.dart` | Added `practiceSyncAuthStoreProvider`, updated `practiceSyncTransportProvider` to select `serverUrl` + inject hoisted store, added `isAuthenticated` and `copyWith` to `PracticeSyncState`, resolved `_load` race condition in `PracticeSyncConfigNotifier`, and added reactive auth stream listener + rehydration in `PracticeSyncNotifier`. |
| `lib/features/cloud_backup/presentation/widgets/practice_sync_card.dart` | Replaced `transport.isAuthenticated` with `syncState.isAuthenticated`, removed unused transport watch. |
| `test/features/cloud_backup/pocketbase_sync_transport_test.dart` | Added regression tests for `SharedPreferencesAuthStore` token rehydration and lazy loading. |
| `test/features/cloud_backup/practice_sync_providers_test.dart` | Added provider identity test (transport preserved on email/scope changes) and notifier state tests (`signIn` → `isAuthenticated: true`, `signOut` → `false`). |
| `test/features/cloud_backup/practice_sync_ui_test.dart` | Added widget test verifying signed-in state UI renders email, "Sign Out", and enables "Sync Now". |
| `docs/testing/releases/v1.13.0/smoke-test.md` | Added "Interim fixes during smoke" note linking this fix. |

---

## 4. Test Verification Counts

### Static Analysis
```bash
flutter analyze
```
- **Result:** `No issues found! (ran in 4.7s)` — clean (0 issues).

### Unit & Widget Test Suite
```bash
flutter test
```
- **Baseline before fix:** 677 passed / 4 expected macOS CloudKit tests failed.
- **After fix:** 683 passed / 4 expected macOS CloudKit tests failed.
- **Delta:** **+6 new passing regression tests**, **0 regressions**.
- **Failed tests:** Exactly the 4 expected macOS platform stubs in `backup_repository_test.dart` (`ICloudBackupRepository` non-Apple platform tests).

---

## 5. Scope & Deviations

- **Scope:** Strictly confined to the three `cloud_backup` files, their tests, and the release dossier notes.
- **Secrets / Credentials:** Zero secrets or test credentials committed.
- **Deviations from Spec:** None.
