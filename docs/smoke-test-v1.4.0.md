# Smoke Test — v1.4.0-web

**Release:** v1.4.0-web (Sprint 31 + 32)
**Date:** 2026-07-14
**Tester:** Eialarasu + Kiro
**Device/Browser:** ___
**URL:** https://saranidhi-staging.vercel.app (staging after merge)

---

## A. Sprint 31 — Numerology + Oracle Engine + GPS (8 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | Name Bird Parser — English | Onboarding → "Use your name" link → enter English name | Shows derived bird based on first vowel | |
| A2 | Name Bird Parser — Tamil | Enter Tamil Unicode name | Shows derived bird from Tamil vowel mapping | |
| A3 | GPS auto-location (web) | Allow location permission on browser prompt | Profile location updates if >5km from stored | |
| A4 | GPS denied gracefully | Deny location permission | No error, uses stored profile location | |
| A5 | Nostril Pattern table — yama timing | Today tab → Nostril Pattern card | Shows Y1-Y5 with time column (HH:mm format) | |
| A6 | Nostril Pattern card — icon | Check card title | Air icon (💨) visible next to "Nostril Pattern" title | |
| A7 | Inauspicious floor lock (Rahu) | View during Rahu Kaal → ask Oracle | Score locked at 10, Sunya band | |
| A8 | Inauspicious floor lock (Emakandam) | View during Emakandam → ask Oracle | Score locked at 10, Sunya band | |

---

## B. Sprint 32 — Prasanam Oracle UI (16 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | Oracle tab in bottom nav | Check bottom navigation | 4 tabs visible: Home, Journal, Oracle, Analytics | |
| B2 | Oracle tab opens Prasanam screen | Tap Oracle tab | Prasanam screen with intention animation + category selector | |
| B3 | Window status banner — favorable | Open Oracle during non-Rahu time | Green banner: "Artha/Kriya/Yoga window — favorable for X queries" | |
| B4 | Window status banner — void | Open Oracle during Rahu Kaal | Red banner: "Rahu Kaal active — readings are void-locked at 10%" | |
| B5 | Category selector | Tap each segment (Artha/Kriya/Yoga) | Highlights selection, shows contextual description below | |
| B6 | Category descriptions | Select each category | Artha="Business, finance...", Kriya="Actions, travel...", Yoga="Spiritual practice..." | |
| B7 | Query text field | Type intention text | Accepts input, shows character counter (max 200) | |
| B8 | Ask Oracle — no recent entry | Clear journal → tap "Ask the Oracle" | GuidedNostrilTest bottom sheet appears (3-step flow) | |
| B9 | Ask Oracle — recent entry | Log journal entry → within 30min tap "Ask the Oracle" | Evaluates directly (no nostril test prompt) | |
| B10 | Oracle result card — score gauge | Complete oracle query | Semi-circular gauge with score (0-100) | |
| B11 | Oracle result card — band label | Check result | Shows band name (Strong Yes/Favorable/Caution/Delay/Hard No) with color | |
| B12 | Oracle result card — guidance | Check result text | Guidance text in current locale (EN or TA) | |
| B13 | Save to History — button | After result shows | "Save to History" button visible below result | |
| B14 | Save to History — confirm | Tap "Save to History" | Button replaced with "Saved to history" confirmation | |
| B15 | Ask Another | Tap "Ask Another Question" | Resets to input screen (category, text field cleared) | |
| B16 | No save — silent query | Get result → tap "Ask Another" without saving | No entry appears in history section | |

---

## C. Prasanam History (6 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | History appears after save | Save a query → scroll down | "Oracle History" card visible with saved entry | |
| C2 | History entry details | Check saved entry | Shows score badge, category, date/time, query text | |
| C3 | Tap history entry | Tap on a saved entry | "Outcome Reflection" dialog opens | |
| C4 | Outcome notes — save | Enter notes → tap Save | Dialog closes, note icon appears on entry | |
| C5 | Outcome notes — pre-filled | Re-open same entry | Previously saved notes pre-filled in text field | |
| C6 | Swipe to delete | Swipe entry left | Confirmation dialog → "Delete" removes entry from history | |

---

## D. Tamil Mode (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| D1 | Oracle tab label | Switch to Tamil | Bottom nav shows Tamil label for Oracle tab | |
| D2 | Prasanam screen — all labels | Open Oracle in Tamil mode | Title, category labels, descriptions, button text — all Tamil | |
| D3 | Band names in Tamil | Get oracle result in Tamil mode | Band shows Tamil name (சிறப்பான ஆம் / சாதகமான / எச்சரிக்கை / தாமதம் / கடுமையான இல்லை) | |
| D4 | Guidance text in Tamil | Check result guidance | Tamil guidance text (not English) | |
| D5 | History + dialog in Tamil | Save query → tap entry → dialog | All labels, dialog title, button text in Tamil | |

---

## E. Regression — Critical Path (6 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| E1 | App loads without errors | Open app in browser | Dashboard loads, no white screen or console errors | |
| E2 | Birth Bird card | Check Today tab | Birth bird + current state + guidance visible | |
| E3 | Journal — log entry | Journal tab → select nostril → log | Entry saved, alignment shown | |
| E4 | Action Bar + Focus Card | Today tab top section | 24h action bar + Focus Card with current window | |
| E5 | Data export includes prasanam | Settings → Export → check JSON | JSON contains "prasanam" key (empty array if no saved queries) | |
| E6 | DB migration (fresh install) | Clear data → reload | App loads onboarding without errors (schema v4 migration works) | |

---

## Summary

| Section | Scenarios | Pass | Fail | Accepted |
|---------|-----------|------|------|----------|
| A. Numerology + Oracle Engine + GPS | 8 | | | |
| B. Prasanam Oracle UI | 16 | | | |
| C. Prasanam History | 6 | | | |
| D. Tamil Mode | 5 | | | |
| E. Regression | 6 | | | |
| **Total** | **41** | | | |

---

**Hotfixes applied during testing:**
- (none yet)

**Release decision:**
- [ ] All pass → proceed to `/release-finish`
- [ ] Failures found → hotfix first, re-test
