# Bug-Fix Spec — Practice Sync sign-in state not surfacing (v1.13.0 release blocker)

> **Branch:** `release/v1.13.0` (fix on the SAME release branch — do NOT open a new feature branch, do NOT branch from main).
> **Handoff:** Antigravity (coding setup with local `flutter test`/`flutter analyze`).
> **Authority:** Human is sole merge/release authority. Antigravity implements + runs local green + pushes to `release/v1.13.0` + records the impl/test summary. **Never merge, never tag.**

---

## 1. Symptom (owner-reproduced on the PR #265 Vercel preview)

- Owner signs in via Settings → Practice Sync → "Sign in" with valid PocketBase creds (`usera@gmail.com`).
- Network tab: `POST /api/collections/users/auth-with-password` returns **200** (token body ~0.5 kB), preflight **204**. Auth genuinely succeeds server-side.
- UI still shows **"Not signed in"**, the sign-out button never appears, and **"Sync now" stays disabled** (`syncSignInRequired` italic hint remains visible).
- This is NOT the Vercel SSO/protection wall — reproduced with the automation-bypass URL, and the auth call itself succeeds.

## 2. Root cause (confirmed by code trace)

Files involved:
- `lib/features/cloud_backup/providers/practice_sync_providers.dart`
- `lib/features/cloud_backup/presentation/widgets/practice_sync_card.dart`
- `lib/features/cloud_backup/data/pocketbase_sync_transport.dart`

Two compounding defects:

**Defect A — the transport (and its token) is destroyed on every config change.**
`practiceSyncTransportProvider` is a plain `Provider<SyncTransport>` that `ref.watch(practiceSyncConfigProvider)` and constructs a **new** `PocketBaseSyncTransport(baseUrl: config.serverUrl)` each rebuild. `PocketBaseSyncTransport` uses an **in-memory `AuthStore`** (the PocketBase default). So:
- `PracticeSyncNotifier.signIn()` calls `transport.signIn(...)` → token lands in the *current* transport's authStore ✅
- then calls `setUserEmail(email)` → mutates `practiceSyncConfigProvider` → **rebuilds `practiceSyncTransportProvider` → NEW transport with an empty authStore → token discarded.** 💥
- (The sign-in dialog also calls `setServerUrl(...)` before `signIn`, rebuilding the transport an extra time.)

**Defect B — auth state is not reactive.**
The card reads `transport.isAuthenticated` (a plain getter over `_client.authStore.isValid`) off a `ref.watch`ed provider. Riverpod only rebuilds the card when the *provider instance* changes, not when the authStore's internal token mutates. So even without Defect A, a successful sign-in on a persisted transport would not re-render the card.

**Net effect:** after a successful 200 sign-in the card's `_AccountSection`, the "Sync now" enable-gate, and the status line all read `isAuthenticated == false` permanently.

## 3. Required fix

Make the authenticated transport **survive config changes** and make auth state **reactive + persistent across reloads**.

### 3.1 Persist the PocketBase token (survive rebuilds AND page reload)

Give `PocketBaseSyncTransport` a persistent `AuthStore` backed by `SharedPreferences` instead of the default in-memory store. This fixes both "token lost on config rebuild" and "token lost on web reload" (important: the app is web, a refresh currently drops auth).

- Implement an `AsyncAuthStore` (from the `pocketbase` package) wired to `SharedPreferences`:
  - `save`: write the serialized auth payload to a fixed key (e.g. `pb_auth`).
  - `initial`: seed from the same key on construction.
  - `clear` (on sign-out): remove the key.
- Because `SharedPreferences` is async, construct the transport through a small async initializer (e.g. read the stored auth string once at app start / provider init and pass it as `AsyncAuthStore(initial: ...)`), OR load lazily and rehydrate. Keep it web-safe (no dart:io).
- Verify: `PocketBase(baseUrl, authStore: AsyncAuthStore(save: ..., initial: ...))`. Keep the existing `client`/`httpClient`/`authStore` constructor injection points intact for tests.

> If a fully-persistent store adds too much surface for this hotfix, the **minimum viable fix** is: keep ONE shared `AuthStore` instance that is NOT recreated when the transport provider rebuilds (hoist the `AuthStore` into a stable provider that the transport provider reads but does not depend on for identity). But the SharedPreferences-backed `AsyncAuthStore` is preferred because it also fixes web-reload auth loss and is the smaller long-term risk. Choose the persistent store unless it proves infeasible in the time box — document the choice in the impl summary.

### 3.2 Do not rebuild the transport on unrelated config changes

`practiceSyncTransportProvider` currently rebuilds whenever ANY field of `PracticeSyncConfig` changes (scope toggles, userEmail, lastSynced, enabled). It should only depend on `serverUrl`. Change it to `ref.watch(practiceSyncConfigProvider.select((c) => c.serverUrl))` so toggling scopes or setting `userEmail` no longer discards the transport.

Even with `select`, `setServerUrl` + `setUserEmail` on sign-in will still change `serverUrl`? No — `serverUrl` only changes if the user edited the server field. But sign-in DOES call `setUserEmail`, which with `.select` on `serverUrl` will NO LONGER rebuild the transport. Good. Combined with 3.1's persistent store, the token now survives regardless.

### 3.3 Surface auth state reactively into `PracticeSyncState`

Add a reactive `isAuthenticated` (bool) to `PracticeSyncState` so the card watches state, not a plain getter:

- Add `final bool isAuthenticated;` (default `false`) to `PracticeSyncState`, threaded through all `PracticeSyncState(...)` constructions in the notifier.
- On `PracticeSyncNotifier.build()`, initialize `isAuthenticated` from `transport.isAuthenticated` (after the persistent store rehydrates — if async, set it once the store is ready, e.g. via an initial read + `state = state.copyWith(isAuthenticated: ...)`).
- In `signIn()`: after `transport.signIn(...)` succeeds and `setUserEmail(email)` completes, set `state = PracticeSyncState(isAuthenticated: transport.isAuthenticated, lastOutcome: ...)`. Confirm `transport.isAuthenticated` is now `true` (it will be, since the store persists).
- In `signOut()`: set `isAuthenticated: false`.
- Consider adding a `copyWith` to `PracticeSyncState` to make the threading clean.

### 3.4 Update the card to read reactive state

In `practice_sync_card.dart`:
- Replace every `transport.isAuthenticated` read with `syncState.isAuthenticated` (there are 3: `_AccountSection(isAuthenticated: ...)` ~line 89, the "Sync now" `onPressed` gate ~line 138, and the `if (!transport.isAuthenticated)` hint ~line 160).
- The `ref.watch(practiceSyncTransportProvider)` line in `build()` can be removed if `transport` is no longer read in the widget (verify nothing else uses it). The engine still reads the transport via `practiceSyncEngineProvider` — unaffected.

## 4. Definition of Done

1. Sign in on the preview with a valid PocketBase user → card immediately shows **"Signed in as <email>"**, sign-out button appears, **"Sync now" becomes enabled**.
2. A **web page reload** while signed in keeps the signed-in state (persistent authStore).
3. Sign out → returns to "Not signed in", "Sync now" disabled, stored token cleared.
4. `flutter analyze` clean; full `flutter test` green (existing 677 + new).
5. No behavior change to the sync engine, owner-guard, merge logic, or scopes.

## 5. Regression tests (add)

- **Provider identity test:** `practiceSyncTransportProvider` returns the SAME instance (or at least a transport whose `isAuthenticated` stays true) after `setUserEmail(...)` / scope-toggle config changes — i.e. changing `userEmail` does NOT reset auth. (Use a fake transport or an injected persistent `AuthStore`.)
- **Notifier state test:** after `PracticeSyncNotifier.signIn(...)` succeeds (fake transport whose `signIn` marks it authenticated), `state.isAuthenticated == true`; after `signOut()`, `state.isAuthenticated == false`.
- **AuthStore persistence test:** a `PocketBaseSyncTransport` constructed with a SharedPreferences-backed `AsyncAuthStore` seeded with a saved token reports `isAuthenticated == true` (rehydration). Use the existing `authStore`/`client` injection point + a mock SharedPreferences.
- Keep the existing owner-guard / merge / idempotency tests green (do not touch them).

## 6. Handoff rules (deliverable-completeness — follow exactly)

- Fix ONLY on `release/v1.13.0`. Push to that branch. Do **not** merge, do **not** tag, do **not** open a main→prod PR.
- Run `flutter analyze` + full `flutter test` LOCALLY and paste real counts.
- Fill `docs/process/sprints/.../` is N/A here (this is a release-branch hotfix); instead record the fix in the v1.13.0 release dossier: add an "Interim fixes during smoke" note to `docs/testing/releases/v1.13.0/smoke-test-v1.13.0.md` (or a short `bugfix-signin-state-summary.md` next to this spec) with: files changed, which fix strategy chosen (persistent AsyncAuthStore vs hoisted store), test counts, and any deviation from this spec.
- Do NOT commit any secret / test-user credentials.
- Honor scope: touch only the three cloud_backup files (+ tests + the dossier note). Do not refactor unrelated code.
- "Done" = code fixed + local green + pushed to `release/v1.13.0` + dossier note filled. Report back the branch is ready for Kiro's diff review and the owner's re-smoke.
