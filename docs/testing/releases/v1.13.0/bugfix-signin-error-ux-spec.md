# Bug-Fix Spec — graceful sign-in / sync error messages (v1.13.0 UX polish)

> **Branch:** `release/v1.13.0` (fix on the SAME release branch — do NOT branch from main).
> **Handoff:** Antigravity (coding setup with local `flutter test`/`flutter analyze`).
> **Authority:** Human is sole merge/release authority. Implement + local green + push to
> `release/v1.13.0` + fill the dossier note. **Never merge, never tag, never open a main→prod PR.**

---

## 1. Symptom (owner-caught in S2/S5 re-smoke)

On a wrong password (or any auth/sync failure), the Practice Sync sign-in dialog shows the **raw
exception string** — e.g.:
```
ClientException {url: https://saranidhi-pb.fly.dev/api/collections/users/auth-with-password,
isAbort: false, statusCode: 400, response: {code: 400, message: Failed to authenticate.},
originalError: null}
```
This is ugly, untranslated, and leaks internal URLs/library detail to the user.

## 2. Root cause

- `PracticeSyncNotifier.signIn()` catch block sets `errorMessage: e.toString` (the full
  `ClientException` dump) — `lib/features/cloud_backup/providers/practice_sync_providers.dart` ~line 331–335.
- The dialog (`_SignInDialog._submit` in `practice_sync_card.dart` ~line 300) shows
  `notifier.errorMessage ?? syncSignInFailed` — so once `errorMessage` holds the raw string, the
  friendly `syncSignInFailed` fallback is never reached.
- The same raw-string path feeds `syncFailedStatus(errorMessage)` for the Sync-now flow (the quiet
  status line), so a sync failure also shows raw text.

## 3. Required fix — classify exceptions into friendly, localized messages

Add a small mapper that turns a caught error into a **localized, user-facing** message, and use it in
BOTH the sign-in path and the sync-now path. Never surface `e.toString()` to the UI.

### 3.1 Error classifier
Add a pure helper (e.g. `lib/features/cloud_backup/domain/sync_error.dart`) that maps an error to an
enum, with NO raw text:
```dart
enum SyncErrorKind { invalidCredentials, network, server, unknown }

SyncErrorKind classifySyncError(Object e) {
  // PocketBase throws ClientException with a statusCode.
  // 400/401/403 on auth  → invalidCredentials
  // 0 / SocketException / timeout / isAbort → network
  // 5xx → server
  // else → unknown
}
```
- Inspect `ClientException` fields available in `pocketbase ^0.25.1` (`statusCode`, `isAbort`,
  `originalError`, `response`). Confirm the actual field names against the package — do not guess.
- Keep it defensive: any unrecognized error → `unknown`.
- For the **auth** call specifically, a 400/401/403 should map to `invalidCredentials` (PocketBase
  returns 400 "Failed to authenticate" on wrong password).

### 3.2 Thread a stable code, not a raw string, through state
- Change `PracticeSyncNotifier.signIn()` catch to store a `SyncErrorKind` (or a stable message key),
  NOT `e.toString()`. Suggested: add `final SyncErrorKind? errorKind;` to `PracticeSyncState`
  (or reuse `errorMessage` but only ever put a localization-key-resolved string into it — the enum is
  cleaner). Do the same for the `syncNow()` failure path (map `outcome.error` via the classifier too;
  if `outcome.error` is already a raw string, classify on the original exception at the engine boundary
  or re-map by string sniffing as a fallback).
- Optional: keep the raw detail only for logging (`debugPrint`), never for display.

### 3.3 Localized copy (EN + TA)
Add ARB keys to BOTH `lib/l10n/app_en.arb` and `lib/l10n/app_ta.arb`, matching existing `sync*` style,
pure Tamil script:
- `syncErrorInvalidCredentials` — EN e.g. "Incorrect email or passphrase. Please try again."
- `syncErrorNetwork` — EN e.g. "Can't reach the sync server. Check your connection and try again."
- `syncErrorServer` — EN e.g. "The sync server had a problem. Please try again later."
- (reuse existing `syncSignInFailed` for `unknown`, or add `syncErrorUnknown`.)
Provide natural Tamil translations for each.

### 3.4 Use the friendly message in the UI
- `_SignInDialog._submit`: set `_errorMessage` from the classified/localized message (map
  `errorKind → l10n.*`), never from the raw `notifier.errorMessage`.
- `_SyncStatusDisplay` (sync-now quiet status): render the classified/localized message via
  `syncFailedStatus(...)` or a direct localized string — not the raw text.

## 4. Definition of Done

1. Wrong password → dialog shows a clean localized line (e.g. "Incorrect email or passphrase…"), no
   `ClientException`, no URL, no `statusCode`.
2. Backend unreachable (bad URL / offline) → "Can't reach the sync server…" (network kind).
3. Tamil mode → all new messages render in Tamil.
4. Correct credentials still sign in fine; the earlier fixes (auth-state, owner-binding) unaffected.
5. `flutter analyze` clean; full `flutter test` green (existing 687 + new).

## 5. Regression tests (add)

- `classifySyncError`: a `ClientException` with `statusCode 400/401` on auth → `invalidCredentials`;
  a network/socket/abort error → `network`; a 5xx → `server`; anything else → `unknown`.
- Notifier: `signIn` failure sets the error KIND/localized message (NOT a raw `ClientException` string);
  assert the stored value does not contain "ClientException" or "http".
- (Widget, optional) the sign-in dialog renders the friendly string on a failed sign-in.
- Keep all existing cloud_backup tests green.

## 6. Handoff rules (deliverable-completeness — follow exactly)

- Fix ONLY on `release/v1.13.0`. Push there. Do NOT merge, tag, or open a main→prod PR.
- Confirm the `pocketbase ^0.25.1` `ClientException` field names actually compile — do not guess.
- Run `flutter analyze` + full `flutter test` locally; paste real counts.
- Fill a dossier note `docs/testing/releases/v1.13.0/bugfix-signin-error-ux-summary.md` (symptom, the
  classifier design, ARB keys added, test counts, deviations) + add an "Interim fixes during smoke"
  entry (Fix 5) to `smoke-test.md`.
- Do NOT commit secrets / test-user credentials.
- "Done" = code fixed + local green + pushed to `release/v1.13.0` + dossier filled. Report back ready
  for Kiro diff review + owner re-smoke.
