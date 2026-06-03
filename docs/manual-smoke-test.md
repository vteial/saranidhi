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

---

## Section A: Calculation Accuracy (vs Align27)

Compare our app's output with Align27 for the **same date, same location (Chennai)**.

| ID | Scenario | What to Check | Expected | Tolerance |
|----|----------|---------------|----------|-----------|
| A-01 | Sunrise time | Home → Astro Info Bar → Sunrise value | Match Align27 | ±2 min |
| A-02 | Sunset time | Home → Astro Info Bar → Sunset value | Match Align27 | ±2 min |
| A-03 | Current Pakshi bird | Home → Astro Info Bar → Bird name | Match for Pushya (Owl birth bird) | Exact |
| A-04 | Current bird state | Home → Astro Info Bar → State (Ruling/Eating/etc.) | Match Align27 Panja Pakshi | Exact |
| A-05 | Rahu Kaal window | Not displayed directly — verify via breath alignment timing | Match Align27 Rahu Kaal start/end | ±2 min |
| A-06 | Active Yama (time of day) | Log breath → check which Yama is shown | Sunrise divided by 5 equals Yama boundaries | ±1 min |
| A-07 | Lunar phase (waxing/waning) | Affects bird sequence — verify bird matches expected for current phase | Match Align27 moon phase | Same day |

### How to Verify A-03/A-04 (Pakshi)

1. Open Align27 → Panja Pakshi section
2. Note the ruling bird + state for current time
3. Open Saranidhi → Home → check bird emoji + state
4. They should match (both use Pushya = Owl as birth bird)

---

## Section B: Core User Flow

| ID | Scenario | Steps | Expected Outcome |
|----|----------|-------|-----------------|
| B-01 | Fresh install onboarding | Clear data → app shows Welcome → enter name → select Pushya → select Chennai → select Local → Complete Setup | Dashboard appears with astro info |
| B-02 | Log aligned breath | Journal → select the nostril matching expected flow → timer → complete → Log | Entry saved, "aligned" shown, streak increments |
| B-03 | Log unaligned breath | Journal → select opposite nostril → timer → complete → Log | Entry saved, "not aligned" shown, micro-advice displayed |
| B-04 | Timer full cycle | Journal → select flow → Start Timer → complete inhale/hold/exhale | Each phase shows live seconds, button enables after complete |
| B-05 | Streak updates | Log aligned breath today → Home → streak shows ≥1 | Streak flame shows "X days", ribbon shows today as aligned |
| B-06 | Journal history | Journal → scroll down → History section | Previous entries listed, grouped by date |
| B-07 | Wisdom card | Home → Daily Wisdom card | Non-empty wisdom text (proverb or rules-based insight) |
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
| C-08 | Clear all data | Settings → Clear All Data → confirm | App resets to Welcome onboarding screen (step 1) |
| C-09 | Data persists across reload | Log entry → reload browser/app | Entry still in journal history, streak preserved |

---

## Section D: Tamil Translation Quality

| ID | Check | Where | Expected |
|----|-------|-------|----------|
| D-01 | Pakshi bird names in Tamil | Home astro bar (in Tamil mode) | கழுகு/ஆந்தை/காகம்/சேவல்/மயில் |
| D-02 | Pakshi state names in Tamil | Home astro bar (in Tamil mode) | ஆளுகை/உண்ணுதல்/நடத்தல்/தூக்கம்/மரணம் |
| D-03 | Onboarding text in Tamil | Clear data → onboarding in Tamil | சரநிதிக்கு வரவேற்கிறோம் |
| D-04 | Breath options in Tamil | Journal tab (Tamil mode) | சூரிய (வலது) / சந்திர (இடது) / சுழுமுனை |
| D-05 | Settings labels in Tamil | Settings tab (Tamil mode) | தோற்றம், மொழி, அறிவிப்புகள் visible |

---

## Section E: Edge Cases

| ID | Scenario | Steps | Expected Outcome |
|----|----------|-------|-----------------|
| E-01 | Before sunrise | Check app before 5:30 AM IST | No active Yama shown, lunar flow expected (pre-dawn default) |
| E-02 | After sunset | Check app after 18:30 IST | No active Yama shown, appropriate default behavior |
| E-03 | Different city (London) | Settings → edit location → London | Sunrise/sunset times change dramatically (~4:45 / ~21:15 in summer) |
| E-04 | Multiple entries same day | Log 3 breath entries in one day | All appear in history, streak counts day as aligned if any entry aligned |
| E-05 | App reload mid-timer | Start timer → reload browser | Timer resets (expected — no persistence for in-progress timer) |

---

## Pass Criteria

| Category | Required to Pass |
|----------|-----------------|
| Section A (Accuracy) | All 7 checks pass within tolerance |
| Section B (Core Flow) | All 8 scenarios pass |
| Section C (Settings) | All 9 scenarios pass |
| Section D (Tamil) | At least 4 of 5 pass (minor translation gaps acceptable for 1.0) |
| Section E (Edge Cases) | All 5 pass |

**Overall Verdict:** ALL sections must pass for production deployment gate.

---

## Execution Notes

- Execute on **saranidhi.vercel.app** (web staging from `main`)
- Compare with **Align27** on same device at same time
- Record results in `docs/smoke-test-results.md`
- Any failures → logged as issues for Sprint 12 fixes

---

[← Back to Root](../README.md)
