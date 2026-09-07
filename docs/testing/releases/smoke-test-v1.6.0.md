# Smoke Test - v1.6.0-web

**Release:** v1.6.0-web (Sprint 36 - Stability & Test Hardening)
**Date:** _TBD (release-start)_
**Tester:** _TBD (owner runs on staging)_
**Shipping Commit:** _TBD (set at release-start)_
**Device/Browser:** Desktop browser + mobile
**URL:** https://saranidhi-staging.vercel.app (staging) - verify version reads **1.6.0** on the release branch build

> **Focus:** This is a **hardening release** with no new user-facing capability.
> The scenarios below are deliberately **slimmer / critical-path**: verify that the
> paid-down test and migration debt did not regress real behavior. The two
> highest-value validations are the **existing-profile upgrade with birth-bird
> auto-recalc** (Section A) and the **geolocation-first onboarding flow**
> (Section G). Also re-confirm **DB migration idempotency** (Section H) now that
> the shared existence-check helper backs every step.
>
> **Legend:** ✅ Pass · ⚠️ Accepted (known/deferred) · ⏸️ Deferred (not yet tested) · ❌ Fail

---

## A. Existing-Profile Upgrade - Birth-Bird Auto-Recalc (Task 36.4) - CRITICAL (4 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | Stale-bird DOB profile corrected silently | Open staging with an existing DOB profile whose `birthBird` was computed by the old Bright-Half-only logic | Bird silently recalculated via the dual-table (paksha + nakshatra) logic; dashboard reflects the corrected bird; no crash | ⏸️ Deferred |
| A2 | No-DOB profile untouched | Open app with a "I know my star" profile (no `birthDateEpoch`) | Bird unchanged; recalc does not run (requires both DOB **and** nakshatra) | ⏸️ Deferred |
| A3 | Idempotent on reopen | Reopen the app after A1 | Bird already correct; no further change; no repeat side effects | ⏸️ Deferred |
| A4 | Existing data intact after recalc | After A1, use journal / oracle / streak | All read/write normally; only the bird field was corrected | ⏸️ Deferred |

> **Gate:** A1 + A2 MUST pass before `/release-start`. The upgrade path is the
> primary risk for a hardening release with an existing production install base.

---

## G. Onboarding - Geolocation-First Location Step (Task 36.6) - CRITICAL (3 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| G1 | Web attempts geolocation first | Fresh onboarding on **web**, reach Location step | Browser geolocation is attempted first; on grant, location is set from coordinates and the step is satisfied | ⏸️ Deferred |
| G2 | City-picker fallback on denial | Web onboarding, **deny** the geolocation prompt (or unavailable) | City-picker ChoiceChips remain available as fallback; selecting a city sets the location; no error/dead-end | ⏸️ Deferred |
| G3 | Mobile/desktop use the picker | Onboarding on mobile/desktop (non-web) | City picker is the source of truth; no web-geolocation attempt; flow completes | ⏸️ Deferred |

> **Note:** the >5 km on-open auto-update stays **silent** (`LocationOnOpenService`
> unchanged this sprint); it is not part of this checklist.

---

## H. DB Migration Idempotency - Existence-Check Helper (Task 36.3) - (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| H1 | Upgrade from an older schema | Open staging with a DB created on an earlier schema version (existing profile + journal + oracle history) | App loads; no crash/white screen; all data intact; every migrated table/column present exactly once (no "duplicate column name") | ⏸️ Deferred |
| H2 | Fresh install | Clear all site data, open app | Onboarding runs; DB created fresh at the current schema; no migration errors | ⏸️ Deferred |

> **Gate:** H1 + H2 MUST pass before `/release-start`. Migration is historically
> the highest-risk area (see v1.2.1 hotfix lessons); the shared helper now backs
> every existence check.

---

## N. Regression - Critical Path (4 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| N1 | App loads without errors | Open app | Dashboard loads; startup widgets stack cleanly; no white screen | ⏸️ Deferred |
| N2 | Journal log works | Journal, select nostril, log | Entry saved with alignment | ⏸️ Deferred |
| N3 | Tamil mode | Switch to Tamil | All labels render; no missing keys | ⏸️ Deferred |
| N4 | About shows v1.6.0 | Settings, About card | Version = 1.6.0 | ⏸️ Deferred |

---

## Summary

| Section | Scenarios | Pass | Accepted | Deferred | Fail |
|---------|-----------|------|----------|----------|------|
| A. Auto-Recalc Upgrade (CRITICAL) | 4 | 0 | 0 | 4 | 0 |
| G. Geolocation-First Onboarding (CRITICAL) | 3 | 0 | 0 | 3 | 0 |
| H. Migration Idempotency | 2 | 0 | 0 | 2 | 0 |
| N. Regression | 4 | 0 | 0 | 4 | 0 |
| **Total** | **13** | **0** | **0** | **13** | **0** |

> All results are ⏸️ **Deferred / to-be-executed**. The owner runs this checklist
> on staging at `/release-start`, then fills in the Pass?/Notes columns.

---

**CRITICAL gates before `/release-start`:**
- [ ] A1 (stale-bird corrected) + A2 (no-DOB untouched) pass
- [ ] G1 (web geolocation-first) + G2 (city-picker fallback) pass
- [ ] H1 (upgrade migration) + H2 (fresh install) pass
- [ ] N4 shows version 1.6.0

**Release decision:**
- [ ] All critical + core pass, ready to proceed with release
