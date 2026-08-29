# Smoke Test — v1.4.1-web

**Release:** v1.4.1-web (Sprint 33 — Panja Pakshi Accuracy Fix)
**Date:** ___
**Tester:** Eialarasu + Kiro
**Device/Browser:** ___
**URL:** https://saranidhi-staging.vercel.app (staging after merge)

> **Focus:** This is an accuracy patch release. The critical validation is that
> birth bird derivation is now correct (dual-table based on birth Paksha),
> the bird is permanent (no monthly swap), and the nostril pattern is tithi-based.

---

## A. Birth Bird Derivation (Dual-Table) — CRITICAL (7 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | DOB Krishna Paksha → Rooster | Clear data → Onboarding → Calculate from DOB → Oct 27, 1975, 8:00 PM, Chennai | Bird = **Rooster (Cock)** — NOT Owl | |
| A2 | DOB Shukla Paksha birth | Calculate from DOB → a known waxing-moon birth date | Bird derived from Bright Half table | |
| A3 | Bird is permanent (no swap) | After onboarding → Explore → navigate several dates | Same bird shown every day (no waxing/waning swap) | |
| A4 | Manual path — "I know my star" | Clear data → "I know my star" → select Pushya | Bird = Owl (Bright Half default — expected for manual path) | |
| A5 | Settings DOB recalculation | Settings → Profile → Recalculate from DOB → enter DOB | Bird updates via dual-table (Rooster for Oct 27, 1975) | |
| A6 | Birth Bird card display | Today tab → Birth Bird card | Correct bird + state + guidance shown | |
| A7 | Existing user (has DOB) migration | Load app with existing profile that has DOB | Bird recalculated correctly on load | |

---

## B. Nostril Pattern (Tithi-Based) — (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | Nostril pattern shows | Today tab → Nostril Pattern card | 5 yamas (Y1-Y5) with Solar/Lunar + times | |
| B2 | Alternates per yama | Check Y1-Y5 | Odd yamas (1,3,5) same flow; Even (2,4) opposite | |
| B3 | Varies by selected date | Explore → pick a date 3+ days ahead | Pattern may start differently (tithi block change) | |
| B4 | Alignment uses pattern | Journal → log breath → check "Expected" | Expected flow matches Nostril Pattern card | |
| B5 | Air icon in title | Nostril Pattern card header | 💨 air icon visible next to title | |

---

## C. Oracle (Tarabala Integrated) — (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | Oracle end-to-end works | Oracle tab → Ask → complete flow | Result card with score + band + guidance | |
| C2 | Score reflects Tarabala | Ask Oracle on different days | Score varies (Tarabala weight applied) | |

---

## D. User Guide Reference Tables — (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| D1 | Five Birds table | Settings → User Guide → Reference section | Birds table: EN / Tamil / Sanskrit (Vulture/கழுகு/Gridhra, etc.) | |
| D2 | All 4 reference tables | Reference section | Planets, Elements, Five Birds, Nakshatras tables all present | |

---

## E. Regression — Critical Path (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| E1 | App loads without errors | Open app | Dashboard loads, no crash/white screen | |
| E2 | Journal log works | Journal → select nostril → log | Entry saved with alignment result | |
| E3 | Full Day Schedule | Today tab → schedule | 5 yamas with bird states | |
| E4 | Tamil mode | Switch to Tamil | All labels render correctly | |
| E5 | About shows v1.4.1 | Settings → About card | Version = 1.4.1 | |

---

## Summary

| Section | Scenarios | Pass | Fail | Accepted |
|---------|-----------|------|------|----------|
| A. Birth Bird Derivation | 7 | | | |
| B. Nostril Pattern | 5 | | | |
| C. Oracle | 2 | | | |
| D. User Guide Tables | 2 | | | |
| E. Regression | 5 | | | |
| **Total** | **21** | | | |

---

**Hotfixes applied during testing:**
- (none yet)

**Release decision:**
- [ ] All pass → proceed to `/release-finish`
- [ ] Failures found → hotfix first, re-test
