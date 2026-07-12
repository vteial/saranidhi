# Smoke Test — v1.3.0-web

**Release:** v1.3.0-web (Sprint 29 + 30)
**Date:** 2026-07-11
**Tester:** ___
**Device/Browser:** ___
**URL:** https://saranidhi-staging.vercel.app (or PR preview)

---

## A. Sprint 29 — Terminology & PWA (7 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | User Guide — Swara Pada Gamana section | Settings → About → User Guide → scroll to "Swara Pada Gamana" | New section visible with grounding foot step instructions | Yes |
| A2 | User Guide — Swara-Ahara section | Scroll to "Swara-Ahara (Dietary Alignment)" | New section visible with digestive fire alignment tips | Yes |
| A3 | User Guide — terminology in Science section | Read "The Science Behind It" section | Mentions Idakalai/Pingalai/Suzhumunai, Arasu/Uun/Nadai/Thuyil/Saavu | Yes |
| A4 | User Guide — terminology in Rhythm section | Read "Daily Rhythm" section | Shows Tamil state names (Arasu, Uun, Nadai, Thuyil, Saavu) with Action Window labels | Yes |
| A5 | Tamil mode — new sections | Switch to Tamil → User Guide | Pada Gamana + Ahara sections display in Tamil | Yes |
| A6 | PWA manifest | Install as PWA (Add to Home Screen) | App title = "Saranidhi — The Treasure House of Breath", emerald theme | Yes |
| A7 | PWA icon | Check home screen / app switcher icon | Shows Saranidhi golden bird logo (not Flutter default) | Yes |

---

## B. Sprint 30 — Action Windows Engine + UI (12 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | Action Bar visible | Open Today tab (logged in, profile set) | 24h color-coded horizontal bar at top with green/blue/purple segments | Yes |
| B2 | Action Bar — current time marker | View Action Bar during daytime | Thin vertical line at current time position | Yes |
| B3 | Action Bar — legend | Below the bar | 3 legend dots: Artha (green), Kriya (blue), Yoga (purple) | Yes |
| B4 | Focus Card — visible | Below Action Bar | Card showing current window name (Artha/Kriya/Yoga) + advice text | Yes |
| B5 | Focus Card — time remaining | Check right side of Focus Card | Shows minutes remaining in current window | Yes |
| B6 | Focus Card — tap to expand | Tap the Focus Card | Bottom sheet opens with full day schedule | Yes |
| B7 | Expansion sheet — current segment | Check bottom sheet content | Current segment highlighted with "NOW" badge | Yes |
| B8 | Expansion sheet — full schedule | Scroll through bottom sheet | All action windows for the day listed with times + bird states | Yes |
| B9 | Rahu Kaal blocking | View during Rahu Kaal period | Action Bar shows diagonal stripe, Focus Card shows "RAHU" badge + blocked text | Not Verified|
| B10 | Tamil mode — Focus Card | Switch to Tamil | Focus Card shows Tamil advice text | Yes |
| B11 | Tamil mode — expansion sheet | Tap Focus Card in Tamil mode | Sheet title + schedule labels in Tamil | No |
| B12 | Night time display | View after sunset | Action Bar shows night segments, Focus Card shows appropriate night window | Yes |

---

## C. Regression — Critical Path (6 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | App loads without errors | Open app in browser | Dashboard loads, no white screen or console errors | Yes |
| C2 | Birth Bird card | Check Today tab | Birth bird + current state + guidance + yama progress visible | Yes |
| C3 | Rahu Kaal card | Check Today tab | Rahu Kaal time window displayed with sunrise/sunset/moon phase | Yes |
| C4 | Journal — log entry | Journal tab → select nostril → log | Entry saved, alignment shown, history updated | Yes |
| C5 | Tamil language switch | Settings → Language → Tamil | All UI switches to Tamil immediately | Yes |
| C6 | DB migration (fresh install) | Clear data → reload | App loads onboarding without errors (PRAGMA migration works) | Yes |

---

## Summary

| Section | Scenarios | Pass | Fail |
|---------|-----------|------|------|
| A. Terminology & PWA | 7 | 7 | 0 |
| B. Action Windows | 12 | | |
| C. Regression | 6 | 6 | 0 |
| **Total** | **25** | | |

---

**Release decision:**
- [ ] All pass → proceed to `/release-finish`
- [ ] Failures found → hotfix first, re-test
