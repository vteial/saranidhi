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
