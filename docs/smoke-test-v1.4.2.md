# Smoke Test — v1.4.2-web

**Release:** v1.4.2-web (Sprint 34 — Migration + Onboarding UX Polish)
**Date:** 2026-07-14
**Tester:** Eialarasu + Kiro
**Device/Browser:** Desktop browser + mobile
**URL:** https://saranidhi-staging.vercel.app (staging) / PR #131 Vercel preview

> **Focus:** UX/migration polish — auto-recalc bird on load, onboarding
> redesign (3 tabs + summary + validation), guided nostril test reset,
> Oracle desktop delete, and web geolocation on startup.
>
> **Legend:** ✅ Pass · ⚠️ Accepted (known/deferred) · ⏸️ Deferred (not yet tested) · ❌ Fail

---

## A. Auto-Recalculate Birth Bird on Load (Task 34.1) — (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | Corrects an old-logic profile | Open app with existing DOB profile whose bird was Bright-Half-only | Bird silently corrected via dual-table; dashboard refreshes | ⏸️ Deferred |
| A2 | One-time notice shown | Same as A1 | SnackBar: "Your bird has been updated to {Bird}…" | ⏸️ Deferred |
| A3 | No-DOB profile untouched | Open app with a manual "I know my star" profile (no DOB) | Bird unchanged; no notice | ⏸️ Deferred |
| A4 | Idempotent | Reopen app after correction | No repeat notice | ⏸️ Deferred |
| A5 | Notice localized | A1/A2 in Tamil mode | Notice text in Tamil | ⏸️ Deferred |

> **Note:** Owner deferred manual verification of Task 34.1 to a later session.

---

## B. Onboarding — 3 Co-Equal Tabs (Task 34.2) — (6 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | Three equal tabs render | Clear data → onboarding → Find Your Bird step | Tabs: "I know my star" / "From DOB" / "From name" | ✅ Pass |
| B2 | Labels fit narrow width | View on mobile/narrow | No truncation | ✅ Pass |
| B3 | Star path derives bird | "I know my star" → pick Nakshatra | Bird derived | ✅ Pass |
| B4 | DOB path derives bird | "From DOB" → DOB + time + place → Calculate | Correct Nakshatra + Paksha-aware bird | ✅ Pass |
| B5 | Name path derives bird | "From name" → enter name | First-vowel → bird | ✅ Pass |
| B6 | DOB IST note localized | "From DOB" tab in Tamil mode | IST-assumption note in Tamil | ✅ Pass (fix `aeedbf9`) |

> **Fix during testing:** B6 — the IST-assumption note was a hardcoded English
> string; moved to l10n key `onboardingIstAssumption` (EN + TA).

---

## C. Onboarding — Summary Confirmation + Validation (Task 34.3) — (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | Summary page shows | Complete steps → reach Summary (step 5 of 5) | Bird (+ derivation), location, storage shown | ✅ Pass |
| C2 | Per-row Edit jumps back | Tap Edit on any row | Returns to the correct step | ✅ Pass |
| C3 | Complete Setup finishes | All set → tap Complete Setup | Onboarding done → dashboard | ✅ Pass |
| C4 | Blocked when incomplete | Reach Summary with missing bird or location | Complete Setup **disabled**; warning banner names what's missing | ✅ Pass (fix `aeedbf9`) |
| C5 | Warning localized | C4 in Tamil mode | Warning banner in Tamil | ✅ Pass |

> **Fix during testing:** C4 — Complete Setup was tappable with missing data.
> Added `OnboardingState.isComplete` (requires birth bird + location); button
> now disabled until complete + summary warning banner
> (`summaryIncompleteBird` / `summaryIncompleteLocation`).

---

## D. Guided Nostril Test — Reset + Reorder (Task 34.4) — (3 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| D1 | Button order | Breath Journal → guided nostril test → Step 1 | Order: Lunar (Left) → Sushumna (Both) → Solar (Right) | ✅ Pass |
| D2 | Start over resets | Mid-test → tap Start over | Test resets to beginning | ✅ Pass |
| D3 | Labels localized | Tamil mode | "Start over" + button labels in Tamil | ✅ Pass |

---

## E. Oracle History — Desktop Delete (Task 34.5) — (4 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| E1 | History renders | Prasanam Oracle → history | List renders (regression after bracket fix) | ✅ Pass |
| E2 | Desktop hover delete | Hover a row → click trash icon → confirm | Entry deleted after confirmation | ✅ Pass |
| E3 | Touch swipe delete | Swipe a row → confirm | Same confirm dialog; entry deleted | ✅ Pass |
| E4 | Cancel keeps entry | Open confirm → Cancel | Entry retained | ✅ Pass |

---

## F. Web Geolocation on Startup (Task 34.6) — web only (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| F1 | Permission prompt | Open app (web, first time) | Browser location prompt appears | ✅ Pass |
| F2 | Denial graceful | Deny/dismiss permission | Uses stored location; no error | ✅ Pass |
| F3 | Moved >5 km updates | Override coords (devtools) → reload | Location updates + one-time "Location updated…" notice | ⚠️ Partially tested (works as expected) |
| F4 | Moved <5 km no-op | Small coord change → reload | No update, no notice | ⏸️ Deferred |
| F5 | Bird unchanged by move | After a location move | Birth bird unchanged; only daily rhythm shifts | ⚠️ Partially tested |

> **Note:** Task 34.6 partially tested by owner and working as expected.
> Full >5 km / <5 km boundary verification deferred (requires devtools
> geolocation override).

---

## G. Regression — Critical Path (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| G1 | App loads without errors | Open app | Dashboard loads; startup widgets stack cleanly | ✅ Pass |
| G2 | Journal log works | Journal → select nostril → log | Entry saved with alignment | ✅ Pass |
| G3 | Full Day Schedule | Today tab → schedule | 5 yamas with bird states | ✅ Pass |
| G4 | Tamil mode | Switch to Tamil | All labels render correctly | ✅ Pass |
| G5 | About shows v1.4.2 | Settings → About card | Version = 1.4.2 | ⏸️ Deferred (verify at release) |

---

## Summary

| Section | Scenarios | Pass | Accepted | Deferred | Fail |
|---------|-----------|------|----------|----------|------|
| A. Auto-Recalc Bird | 5 | 0 | 0 | 5 | 0 |
| B. Onboarding 3 Tabs | 6 | 6 | 0 | 0 | 0 |
| C. Summary + Validation | 5 | 5 | 0 | 0 | 0 |
| D. Guided Nostril Test | 3 | 3 | 0 | 0 | 0 |
| E. Oracle Desktop Delete | 4 | 4 | 0 | 0 | 0 |
| F. Web Geolocation | 5 | 2 | 2 | 1 | 0 |
| G. Regression | 5 | 4 | 0 | 1 | 0 |
| **Total** | **33** | **24** | **2** | **7** | **0** |

---

**Fixes applied during testing (folded into PR #131):**
- Localized DOB tab IST-assumption note (`onboardingIstAssumption`, EN + TA) — commit `aeedbf9`.
- Gated onboarding Complete Setup with `OnboardingState.isComplete` + summary warning banner — commit `aeedbf9`.

**Deferred items (tracked in sprint-tracker):**
- Task 34.1 auto-recalc (Section A) — owner to verify in a later session.
- Task 34.8 (follow-up, NOT in this release): geolocation-first Location step with **city picker as fallback**; >5 km auto-update stays **silent**. (Owner-confirmed strategy.)

**Release decision:**
- [x] No failures → proceed to `/release-start` when ready
- [ ] Failures found → hotfix first, re-test
