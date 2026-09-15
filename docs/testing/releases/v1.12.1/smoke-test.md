[← Release dossier](./README.md) · [Releases index](../../smoke-test-results.md)

# Smoke Test — v1.12.1-web (Sprint 45 — Practice Sync polish)

> **Targeted patch smoke.** v1.12.1 is a light polish patch with **no schema change** — so this is
> a focused smoke on the 3 changed behaviors + EN/TA + regression, NOT the full 6-scenario matrix
> a feature release gets. Local suite already green (analyze clean; 661 pass / 4 known
> CloudKit-on-macOS baseline / 0 regressions; +12 tests). Run on the **release PR's Vercel preview**
> (see the pre-flight gate in [`qa-verify-prompt.md`](./qa-verify-prompt.md)).

## Pre-flight (must pass before any scenario)

- [ ] Preview reachable at the bypass URL (HTTP 200, app shell renders).
- [ ] **About card reads exactly `Saranidhi v1.12.1`** (wrong version → abort, do NOT fall back to staging/prod/local).
- [ ] Required CI green on the release PR head (Analyze/Fast + Build; Full Suite + Coverage).

## Scenarios

### S1 — New-device import BEFORE onboarding (45.1, the 🔴 fix)
> Highest-value scenario — the exact gap the v1.12.0 owner smoke found.
1. [ ] Start on a **fresh** preview (no local data → welcome/intro screen shows).
2. [ ] Confirm a subtle **"Already using Saranidhi on another device? Import"** link appears under **Get Started**.
3. [ ] Tap it → file picker → choose a valid backup exported from another device.
4. [ ] Confirm the **"Merge Practice Data?"** dialog shows **"adopting Practice ID"** (new device).
5. [ ] Confirm the merge → app lands on the **main app** (does NOT force you through onboarding).
6. [ ] Settings → About/Profile shows the **Practice ID matching the source device** (adopted, not a new one).
7. [ ] The imported journal/sessions are present.

### S2 — Practice ID refreshes in place after Restore/Merge (45.2, BUG-v1.12.0-01)
1. [ ] On a device with existing data, Settings → note the current Practice ID.
2. [ ] Merge (or Restore) a backup.
3. [ ] Confirm the Settings profile card shows the correct Practice ID **without reloading the page**.

### S3 — Export filename carries the Practice ID (45.3)
1. [ ] Settings → Export all data.
2. [ ] Confirm the downloaded/shared filename is `saranidhi_backup_<first8-of-PracticeID>_<timestamp>.json`.

### S4 — Regression: normal onboarding happy-path unchanged
1. [ ] Fresh device → tap **Get Started** (ignore the Import link) → complete onboarding normally.
2. [ ] Confirm a Practice ID is minted and the app works as before.

### S5 — Regression: Settings Merge/Restore + owner-guard unchanged
1. [ ] Same-Practice-ID file → Merge succeeds (union, no dup).
2. [ ] Different-Practice-ID file → Merge is **refused** (mismatch); the **Restore-overwrite fallback** is still offered.

### S6 — Bilingual (EN/TA)
1. [ ] Toggle Tamil on the intro screen → the Import link reads `மற்றொரு சாதனத்தில் ஏற்கனவே சரணிதி பயன்படுத்துகிறீர்களா? இறக்குமதி செய்யவும்`.
2. [ ] Merge dialog copy renders in Tamil.

## Result

- **Smoke:** ⏳ _pending_ — recorded here during release verification.

| # | Scenario | Result | Notes |
|---|----------|:------:|-------|
| S1 | New-device import before onboarding | ⬜ | |
| S2 | Practice ID refresh in place | ⬜ | |
| S3 | Export filename prefix | ⬜ | |
| S4 | Onboarding happy-path regression | ⬜ | |
| S5 | Settings Merge/Restore + owner-guard regression | ⬜ | |
| S6 | Bilingual EN/TA | ⬜ | |
