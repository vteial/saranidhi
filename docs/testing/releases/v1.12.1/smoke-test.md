[← Release dossier](./README.md) · [Releases index](../../smoke-test-results.md)

# Smoke Test — v1.12.1-web (Sprint 45 — Practice Sync polish)

> **Targeted patch smoke.** v1.12.1 is a light polish patch with **no schema change** — so this is
> a focused smoke on the 3 changed behaviors + EN/TA + regression, NOT the full 6-scenario matrix
> a feature release gets. Local suite already green (analyze clean; 661 pass / 4 known
> CloudKit-on-macOS baseline / 0 regressions; +12 tests). Run on the **release PR's Vercel preview**
> (see the pre-flight gate in [`qa-verify-prompt.md`](./qa-verify-prompt.md)).

## Pre-flight (must pass before any scenario)

- [x] Preview reachable at the bypass URL (HTTP 200, app shell renders).
- [x] **About card reads exactly `Saranidhi v1.12.1 (1)`** (verified visually, build matches release candidate).
- [x] Required CI green on the release PR head (Analyze/Fast + Build: PASS; Full Suite + Coverage: PASS; Integration Tests (Web): PASS).

## Scenarios

### S1 — New-device import BEFORE onboarding (45.1, the 🔴 fix)
> Highest-value scenario — the exact gap the v1.12.0 owner smoke found.
1. [x] Start on a **fresh** preview (no local data → welcome/intro screen shows).
2. [x] Confirm a subtle **"Already using Saranidhi on another device? Import"** link appears under **Get Started**.
3. [x] Tap it → file picker → choose a valid backup exported from another device.
4. [x] Confirm the **"Merge Practice Data?"** dialog shows **"adopting Practice ID"** (new device).
5. [x] Confirm the merge → app lands on the **main app** (does NOT force you through onboarding).
6. [x] Settings → About/Profile shows the **Practice ID matching the source device** (adopted, not a new one).
7. [x] The imported journal/sessions are present.

### S2 — Practice ID refreshes in place after Restore/Merge (45.2, BUG-v1.12.0-01)
1. [x] On a device with existing data, Settings → note the current Practice ID.
2. [x] Merge (or Restore) a backup.
3. [x] Confirm the Settings profile card shows the correct Practice ID **without reloading the page**.

### S3 — Export filename carries the Practice ID (45.3)
1. [x] Settings → Export all data.
2. [x] Confirm the downloaded/shared filename is `saranidhi_backup_<first8-of-PracticeID>_<timestamp>.json`.

### S4 — Regression: normal onboarding happy-path unchanged
1. [x] Fresh device → tap **Get Started** (ignore the Import link) → complete onboarding normally.
2. [x] Confirm a Practice ID is minted and the app works as before.

### S5 — Regression: Settings Merge/Restore + owner-guard unchanged
1. [x] Same-Practice-ID file → Merge succeeds (union, no dup).
2. [x] Different-Practice-ID file → Merge is **refused** (mismatch); the **Restore-overwrite fallback** is still offered.

### S6 — Bilingual (EN/TA)
1. [x] Toggle Tamil on the intro screen → the Import link reads `மற்றொரு சாதனத்தில் ஏற்கனவே சரணிதி பயன்படுத்துகிறீர்களா? இறக்குமதி செய்யவும்`.
2. [x] Merge dialog copy renders in Tamil.

## Result

- **Smoke:** ✅ **PASS** — executed 2026-09-15 against deployed Vercel preview `https://saranidhi-git-release-v1121-eialarasus-projects.vercel.app` (PR #246, commit `e507b96`).
- **Verified Build:** Settings → About reads `Saranidhi v1.12.1 (1)`.

| # | Scenario | Result | Notes |
|---|----------|:------:|-------|
| S1 | New-device import before onboarding | ✅ PASS | Intro link rendered; picking backup opened merge dialog showing "adopting Practice ID"; on confirm bypassed onboarding directly to dashboard; Profile card shows adopted Practice ID `e1a10001-1111-4000-8000-000000000001`; 1 imported journal entry present. |
| S2 | Practice ID refresh in place | ✅ PASS | Restored foreign backup (`backup_device_c.json` with ID `e3c30003-3333-4000-8000-000000000003`); Settings Profile card immediately updated in place without page reload to Device C Foreign / Ashwini / Vulture / `e3c30003-3333-4000-8000-000000000003`. |
| S3 | Export filename prefix | ✅ PASS | Exported data with Practice ID `e3c30003...`; filename intercepted as `saranidhi_backup_e3c30003_2026-09-15-1536.json` (matches `saranidhi_backup_<first8>_<timestamp>.json`). |
| S4 | Onboarding happy-path regression | ✅ PASS | Fresh install / cleared storage; tapped "Get Started" (ignoring import link); completed onboarding wizard (Ashwini, Chennai, local storage); landed on main dashboard; Settings Profile card displays freshly minted Practice ID `63b57cfe-a4df-4ad3-b05e-fee90a6db5d1`. |
| S5 | Settings Merge/Restore + owner-guard regression | ✅ PASS | S5.1: Same-PID file merge succeeded with "Matches this device" (0 duplicates). S5.2: Mismatched PID file merge refused by owner guard ("Practice ID Mismatch" red shield dialog); offered Cancel and Restore-overwrite fallback. |
| S6 | Bilingual EN/TA | ✅ PASS | S6.1: Intro screen in Tamil showed `மற்றொரு சாதனத்தில் ஏற்கனவே சரணிதி பயன்படுத்துகிறீர்களா? இறக்குமதி செய்யவும்`. S6.2: Merge dialog rendered in Tamil with `பயிற்சி தரவை இணைக்கவா?`, `பயிற்சி அடையாளம்: இந்த சாதனத்துடன் பொருந்துகிறது`, `ரத்து`, `இணை`. |

