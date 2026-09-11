# Smoke Test - v1.7.0-web

**Release:** v1.7.0-web (Sprint 37 — Birth-Bird Engine Correction)  
**Date:** 2026-09-11 (release-start)  
**Tester:** Antigravity IDE Pair  
**URL:** https://saranidhi-staging.vercel.app (staging)  

> **Focus:** This is a **correctness release** updating the core Panja Pakshi birth-bird engine from the Pulippani 5-5-5-5-7 dual-table model to the canonical Tamil Siddha 5-6-5-5-6 single permanent table model (CONF-PP-001…005).
> The highest-value validations are:
> 1. Existing Pushya/Krishna user auto-corrected on load: Cock → Owl (Section A).
> 2. Existing manual-star user auto-corrected on load: Pooram (Crow → Owl), Visakam (Rooster → Crow), Uthiradam (Peacock → Rooster).
> 3. New onboarding derivation produces canonical 5-6-5-5-6 birds (Section B).
> 4. Name-initial method correctly applies Valarpirai/Theipirai phase swap (Section C).
>
> **Legend:** ✅ Pass · ⚠️ Accepted (known/deferred) · ⏸️ Deferred · ❌ Fail

> ⚠️ **Staging manual-verification still required.** The ✅ marks below are the
> **unit-test cross-references** captured during implementation — they show the logic is
> covered, but they are NOT the manual staging pass. Before `/release-finish`, run each
> scenario against the **staging build** (https://saranidhi-staging.vercel.app) and record
> the **manual** result. The single most important one is **A1** (an existing Pushya/Krishna
> user's bird visibly auto-corrects **Cock → Owl** on app open with the notification) —
> this is the whole point of the release and must be verified on a real deployed build, not
> just in unit tests. Add a **"Staging Result"** note per row as you go.

---

## A. Existing-Profile Auto-Recalculation (Migration Path) — CRITICAL (4 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | Existing DOB profile corrected on load (Pushya/Krishna: Cock → Owl) | Open app with existing profile born under Pushya during Krishna Paksha (stored as `rooster`) | Stored bird silently corrected to `owl` in DB; SnackBar notification displayed ("Your birth bird was recalculated to Owl"); dashboard shows Owl | ✅ Pass (Unit test verified in `bird_migration_service_test.dart`: `Pushya stored rooster -> owl`) |
| A2 | Existing manual-star profile corrected on load (Pooram: Crow → Owl) | Open app with existing manual-star profile with Purva Phalguni (stored as `crow`) | Stored bird corrected to `owl`; SnackBar displayed; dashboard shows Owl | ✅ Pass (Unit test verified in `bird_migration_service_test.dart`: `Pooram stored crow -> owl`) |
| A3 | Affected manual stars Visakam & Uthiradam corrected | Open app with manual profiles for Visakam (`rooster` → `crow`) and Uthiradam (`peacock` → `rooster`) | Birds updated to `crow` and `rooster` respectively | ✅ Pass (Unit test verified in `bird_migration_service_test.dart`) |
| A4 | Already-correct profile is idempotent | Reopen app after migration | No changes made; no repeat SnackBar; DB profile untouched | ✅ Pass (Unit test verified: `recalculateIfNeeded` returns `noChange`) |

---

## B. Onboarding 5-6-5-5-6 Canonical Derivation (3 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | "I know my star" path | Select Purva Phalguni (Pooram) | Derived bird is Owl | ✅ Pass (`onboarding_test.dart`) |
| B2 | "Calculate from DOB" path | Enter DOB yielding Pushya during Krishna Paksha | Derived bird is Owl (single permanent table) | ✅ Pass (`pakshi_calculator_test.dart`) |
| B3 | All 27 Nakshatras mapped | Test each of 27 stars | Exact 5-6-5-5-6 distribution (5 Vulture, 6 Owl, 5 Crow, 5 Rooster, 6 Peacock) | ✅ Pass (`onboarding_test.dart`) |

---

## C. Name-Initial Fallback & Phase Swap (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | Valarpirai (Waxing) Name derivation | Calculate from name 'Arun' (vowel 'a') in waxing phase | Returns Vulture | ✅ Pass (`oracle_engine_test.dart`) |
| C2 | Theipirai (Waning) Name swap | Calculate from name 'Arun' in waning phase | Applies 5-cycle swap (Vulture → Rooster) | ✅ Pass (`oracle_engine_test.dart`) |

---

## D. Bird Attributes Integrity (3 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| D1 | Correct Ruling Planets & Colours | Inspect Vulture, Owl, Crow, Rooster, Peacock attributes | Vulture=Jupiter/Yellow, Owl=Venus/White, Crow=Mars/Red, Rooster=Mercury/Green, Peacock=Saturn/Black | ✅ Pass (`pakshi_attributes_test.dart`) |
| D2 | Unified Friend/Enemy Matrix | Verify mutual symmetry for all 5 birds | Symmetrical relations; Vulture allies Peacock+Owl, enemies Crow+Rooster | ✅ Pass (`pakshi_attributes_test.dart`) |
| D3 | Phase-dependent directions | Verify directions in waxing vs waning | Waxing: East/South/West/North/Center; Waning: East/North/South/Center/West | ✅ Pass (`pakshi_attributes_test.dart`) |


---

## Staging Verification Log (manual — fill during the run)

> The ✅ marks in Sections A–D above are **unit-test cross-references** from implementation.
> Record the **manual staging result** for each scenario here.
>
> **Environment for this run:** owner's **iPad** on staging (https://saranidhi-staging.vercel.app),
> using a **real existing (pre-v1.7.0) profile** — the ideal A1 condition (a genuine old profile
> auto-migrating on app open; no DevTools seeding needed).
>
> **Confirm first:** About card shows **1.7.0** (else staging deploy not finished).

| # | Staging Result (PASS/FAIL/BLOCKED) | Evidence / Notes |
|---|---|---|
| **A1** (CRITICAL — Cock→Owl on load) | | Existing Pushya/Krishna profile: bird visibly corrects to **Owl** + one-time notification on app open? |
| A2/A3 (Pooram/Visakam/Uthiradam) | | Only if such a profile is available on the device |
| A4 (idempotent reopen) | | No repeat notification on 2nd open |
| B1–B3 (fresh onboarding 5-6-5-5-6) | | Spot-check Pooram→Owl + DOB Pushya/Krishna→Owl |
| C1/C2 (name-initial phase swap) | | |
| D1–D3 (attributes) | | Planets / friend-enemy / directions |
| Happy path (no regression) | | onboarding → dashboard → journal entry → alignment |

**Overall verdict:** _(PASS / PASS-WITH-NOTES / FAIL)_ · **Date:** _____ · **Device/Browser:** iPad Safari _____ · **Version tested:** 1.7.0 · **Staging URL:** https://saranidhi-staging.vercel.app

---

## Appendix — QA-Verify prompt used for this release (audit record)

> This is the filled v1.7.0 prompt handed to Antigravity QA-Verify (derived from
> `docs/testing/qa-verify-agent-prompt.md`). Kept here for the audit trail.

```text
ROLE: QA-Verify agent for Saranidhi. You execute the smoke test on the DEPLOYED (staging)
build, record results, log bugs + root cause. You DO NOT edit source, merge, or tag.

RELEASE: v1.7.0 (Sprint 37 — Birth-Bird Engine Correction).
ENVIRONMENT: Staging https://saranidhi-staging.vercel.app. Confirm About card = 1.7.0 first.
TEST PLAN: docs/testing/releases/smoke-test-v1.7.0.md (Sections A–D). The ✅ marks are
UNIT-TEST cross-refs, NOT results — record your MANUAL staging result per row.

WHAT CHANGED (do not test beyond this + a happy-path spot-check):
- Partition 5-5-5-5-7 → 5-6-5-5-6 (Pooram→Owl, Visakam→Crow, Uthiradam→Rooster).
- Single permanent birth-star table; no Krishna reverse-swap.
- Corrected attributes (planets, friend/enemy, phase-dependent directions).
- Existing users auto-corrected on app open (DOB + manual-star), one-time notification.
- Waxing/waning swap now only on the name-initial fallback.

HIGHEST PRIORITY:
- A1 (CRITICAL): existing Pushya/Krishna profile auto-corrects Cock→Owl on app open with the
  notification; dashboard then shows Owl. (Owner runs this on an iPad with a REAL old profile.)
- A2/A3 manual-star corrections; A4 idempotent reopen; B fresh onboarding 5-6-5-5-6.

EXECUTION: Chrome/Safari (record version+viewport). Screenshot every scenario, esp. A1
before/after. PASS/FAIL/BLOCKED + expected vs actual. For FAIL: repro + console + root-cause
hypothesis; do NOT fix. Spot-check happy path (onboarding→dashboard→journal→alignment).

DELIVERABLE: fill smoke-test-v1.7.0.md Staging Verification Log with manual results + top
verdict (PASS/PASS-WITH-NOTES/FAIL, date, device/browser, version, URL). Commit to
release/v1.7.0 (results-only, no source). Do NOT merge PR #169, do NOT tag.

GATE: sign-off needs staging functionally correct AND CI green. A1 on the real build is the gate.
```
