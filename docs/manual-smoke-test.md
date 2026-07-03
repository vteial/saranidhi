[← Back to Root](../README.md)

# Saranidhi — Manual Smoke Test Plan

## Test Context

| Parameter | Value |
|-----------|-------|
| **Location** | Chennai (13.08, 80.27) |
| **Nakshatra** | Pushya |
| **Birth Bird** | Owl |
| **UTC Offset** | +5.5 (IST) |
| **Reference App** | Align27 (for calculation cross-verification) |
| **Tolerance** | Sunrise/sunset ±2 min, Rahu Kaal ±2 min |
| **Staging URL** | [saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app) |
| **Production URL** | [saranidhi.vercel.app](https://saranidhi.vercel.app) |

---

## Section A: Calculation Accuracy (vs Align27)

Compare our app's output with Align27 for the **same date, same location (Chennai)**.

| ID | Scenario | What to Check | Expected | Tolerance |
|----|----------|---------------|----------|-----------|
| A-01 | Sunrise time | Home → Birth Bird Card or Full Day Schedule | Match Align27 | ±2 min |
| A-02 | Sunset time | Home → Full Day Schedule (night section start) | Match Align27 | ±2 min |
| A-03 | Current Pakshi bird state | Home → Birth Bird Card → state name | Match Align27 Panja Pakshi for Owl | Exact |
| A-04 | Align27 validation row | Home → Full Day Schedule → Align27 row | Ruling bird matches what Align27 shows | Exact |
| A-05 | Rahu Kaal window | Home → Rahu Kaal Card → time range | Match Align27 Rahu Kaal start/end | ±2 min |
| A-06 | Active Yama | Home → Birth Bird Card → yama progress | Correct yama number for current time | ±1 min |
| A-07 | Lunar phase (waxing/waning) | Affects bird sequence — verify bird state matches expected for current phase | Match Align27 moon phase | Same day |

### How to Verify A-03/A-04 (Pakshi)

1. Open Align27 → Panja Pakshi section
2. Note the ruling bird + your birth bird's state for current time
3. Open Saranidhi → Home → Birth Bird Card shows YOUR owl's state
4. Full Day Schedule → Align27 row shows the ruling bird
5. Both should match Align27's display

---

## Section B: Core User Flow

| ID | Scenario | Steps | Expected Outcome |
|----|----------|-------|-----------------|
| B-01 | Fresh install onboarding | Clear data → app shows Welcome → enter name → select Pushya → select Chennai → select Local → Complete Setup | Dashboard appears with Birth Bird Card |
| B-02 | Log aligned breath | Journal → select the nostril matching expected flow → timer → complete → Log | Entry saved, "aligned" shown, streak increments |
| B-03 | Log unaligned breath | Journal → select opposite nostril → timer → complete → Log | Entry saved, "not aligned" shown, micro-advice displayed |
| B-04 | Timer full cycle | Journal → select flow → tap timer → complete inhale/hold/exhale | Each phase shows live seconds |
| B-05 | Streak updates | Log aligned breath today → Home → streak shows ≥1 | Streak flame shows "X days", ribbon shows today as aligned |
| B-06 | Journal history | Journal → scroll down → History section | Previous entries listed, grouped by date |
| B-07 | Wisdom card | Home → scroll down → Daily Wisdom card | Non-empty wisdom text |
| B-08 | Pull-to-refresh | Home → pull down from top | Spinner appears, dashboard reloads |

---

## Section C: Settings & Data Integrity

| ID | Scenario | Steps | Expected Outcome |
|----|----------|-------|-----------------|
| C-01 | Theme switch | Settings → Appearance → tap Dark | Entire app switches to dark mode immediately |
| C-02 | Color accent | Settings → Color Accent → tap Emerald | Color scheme changes throughout app |
| C-03 | Language switch EN→TA | Settings → Language → tap தமிழ் | All labels switch to Tamil |
| C-04 | Language switch TA→EN | Settings → Language → tap English | All labels revert to English |
| C-05 | Language persists | Switch to Tamil → reload app | App loads in Tamil |
| C-06 | Profile edit name | Settings → Profile → edit icon → change name → save | Name updated, persists after reload |
| C-07 | Profile birth star change | Settings → Profile → edit → change birth star → confirm warning | Bird updates to new star's bird |
| C-08 | Clear all data | Settings → Clear All Data → confirm | App resets to Welcome onboarding screen |
| C-09 | Data persists across reload | Log entry → reload browser/app | Entry still in journal history, streak preserved |

---

## Section D: Tamil Translation Quality

| ID | Check | Where | Expected |
|----|-------|-------|----------|
| D-01 | Bird names in Tamil | Home → Birth Bird Card (Tamil mode) | கழுகு/ஆந்தை/காகம்/சேவல்/மயில் |
| D-02 | Bird state names in Tamil | Home → Birth Bird Card (Tamil mode) | ஆளுகை/உண்ணுதல்/நடத்தல்/தூக்கம்/மரணம் |
| D-03 | Guidance text in Tamil | Home → Birth Bird Card guidance | State-specific Tamil guidance |
| D-04 | Breath options in Tamil | Journal tab (Tamil mode) | சூரிய (வலது) / சந்திர (இடது) / சுழுமுனை |
| D-05 | Settings labels in Tamil | Settings tab (Tamil mode) | தோற்றம், மொழி, அறிவிப்புகள் visible |
| D-06 | Schedule labels in Tamil | Home → Full Day Schedule (Tamil mode) | இன்றைய அட்டவணை, சிறந்த நேரம் |
| D-07 | Nakshatra in Tamil | Settings → Profile (Tamil mode) | புஷ்யம் (Pushya) |

---

## Section E: Edge Cases

| ID | Scenario | Steps | Expected Outcome |
|----|----------|-------|-----------------|
| E-01 | Before sunrise | Check app before 5:30 AM IST | Night yama active, birth bird night state shown |
| E-02 | After sunset | Check app after 18:30 IST | Night yama active, night schedule visible (Y6-Y10) |
| E-03 | Different city (London) | Settings → edit location → London | Sunrise/sunset times change dramatically |
| E-04 | Multiple entries same day | Log 3 breath entries in one day | All appear in history, streak counts correctly |
| E-05 | App reload mid-timer | Start timer → reload browser | Timer resets (expected — no persistence) |

---

## Section F: Dashboard Features (Sprint 14-15)

| ID | Scenario | Steps | Expected Outcome |
|----|----------|-------|-----------------|
| F-01 | Birth Bird Card displays | Home → top card | Shows bird emoji + name + state + guidance + progress bar |
| F-02 | Yama progress accurate | Home → Birth Bird Card → progress bar | Bar matches time elapsed in current yama |
| F-03 | Rahu Kaal Card | Home → Rahu Kaal section | Shows correct time window, red when active |
| F-04 | Full Day Schedule (day) | Home → Today's Schedule | 5 daytime yamas with bird states + color dots |
| F-05 | Full Day Schedule (night) | Home → Night Schedule section | 5 nighttime yamas (Y6-Y10) with bird states |
| F-06 | Align27 comparison row | Home → bottom of schedule | Shows ruling bird for current yama |
| F-07 | Nostril Dominance Chart | Home → Nostril Pattern | 5 yamas with Solar/Lunar pattern, current highlighted |
| F-08 | Next switch countdown | Home → Nostril Pattern → bottom | "Next switch: in X min" displayed |
| F-09 | Hold Time Card | Home → Today's Hold | Shows average hold or "No entries today" |
| F-10 | State emojis in schedule | Home → Today's Schedule → each row | 👑🍽️🚶💤💀 next to bird emoji |
| F-11 | Responsive layout (wide) | View on iMac/iPad | Two-column: Bird+Rahu, Nostril+Schedule, Hold+Streak |
| F-12 | Responsive layout (narrow) | View on iPhone SE | Single column, all cards stacked |
| F-13 | Night state after sunset | Check after 18:30 | Birth Bird Card shows night state + night guidance |

---

## Pass Criteria

| Category | Required to Pass |
|----------|-----------------|
| Section A (Accuracy) | All 7 checks pass within tolerance |
| Section B (Core Flow) | All 8 scenarios pass |
| Section C (Settings) | All 9 scenarios pass |
| Section D (Tamil) | At least 6 of 7 pass |
| Section E (Edge Cases) | All 5 pass |
| Section F (Dashboard) | All 13 pass |

**Overall Verdict:** ALL sections must pass for `/release` production deployment.

---

## Execution Notes

- Execute on **[saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app)** (staging from `main`)
- Compare with **Align27** on same device at same time
- Record results in `docs/smoke-test-results.md`
- Any failures → logged as issues for hotfix
- **Must pass before `/release` PR is created**

---

[← Back to Root](../README.md)
