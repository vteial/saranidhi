---
inclusion: fileMatch
fileMatchPattern: ["**/*_test.dart", "test/**/*.dart"]
---

# Saranidhi — Test-Authoring Rules

> Loads only when working on Dart test files. Prevents the recurring
> compile-error-on-CI cycle. (Full runs happen in the Antigravity IDE — Kiro Web
> cannot run `flutter test`, so these must be right before the PR.)

## Verify against real source before writing test code

1. **Check all required constructor parameters by reading the actual class source.**
   Do NOT assume a signature. Example burned before: `RahuKaalResult` requires
   `weekday`. Grep/read the class first.
2. **Only reference publicly exported types** in annotations/imports. Some package
   types are not exported (e.g. Riverpod's `Override`) — using them fails to compile.
3. **Match the exact API signatures from existing working tests.** The reference
   pattern is `test/widget_test.dart` and the current per-feature tests under
   `test/features/...`. Mirror their provider-override + `testableWidget` setup.
4. **Never `pumpAndSettle` with stream-based provider overrides** — it hangs. Use the
   established explicit-pump pattern from the existing widget tests.

## Baseline & structure

- **Known-GREEN baseline (NOT a regression):** `flutter test` shows **4 expected
  failures**, all in `test/features/cloud_backup/backup_repository_test.dart` (CloudKit
  "on non-Apple platform" cases — they pass on CI Ubuntu, fail only on local macOS). The
  gate is "green **except those same 4**."
- **Bilingual widget tests:** the `testableWidget` helper accepts a `locale` param
  (defaults to `en`); use `Locale('ta')` to assert pure-Tamil rendering and no English
  leakage.
- **Regression tests are mandatory** for correctness-critical changes — pin the behavior
  that must stay unchanged (e.g. bird/Pakshi outputs when only the nostril clock moves).
- Keep tests in sync with UI changes — stale assertions referencing removed UI are a
  known failure class (the flaky/stale in-repo web integration tests).
