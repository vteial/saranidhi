[← Back to Root](../README.md)

# Saranidhi — Smoke Test v1.2.0-web

## Execution Details

| Parameter | Value |
|-----------|-------|
| **Tester** | |
| **Date** | |
| **Device** | |
| **Browser/OS** | |
| **Location** | Chennai (13.08, 80.27) |
| **Nakshatra** | Pushya (Owl) |
| **App URL** | https://saranidhi-staging.vercel.app |
| **Reference** | Align27 |
| **Tolerance** | Sunrise/sunset ±2 min, Rahu Kaal ±2 min |

---

## Section A: Calculation Accuracy (vs Align27)

| ID | Scenario | Expected | Our App | Align27 | Pass? | Notes |
|----|----------|----------|---------|---------|-------|-------|
| A-01 | Sunrise time | ±2 min | | | | |
| A-02 | Sunset time | ±2 min | | | | |
| A-03 | Birth bird state (Owl for Pushya) | Exact | | | | |
| A-04 | Rahu Kaal start/end | ±2 min | | | | |
| A-05 | Lunar phase (waxing/waning) | Same day | | | | |

---

## Section B: Core User Flow

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| B-01 | Fresh onboarding (clear data → 4-step flow) | Dashboard with Birth Bird Card | | |
| B-02 | Log aligned breath (correct nostril → timer → submit) | "Aligned" shown, streak increments | | |
| B-03 | Log unaligned breath (wrong nostril → timer → submit) | "Not aligned", micro-advice displayed | | |
| B-04 | Timer full cycle (inhale → hold → exhale → complete) | Live seconds, results display | | |
| B-05 | Streak updates after aligned entry | Flame ≥1 days, ribbon today aligned | | |
| B-06 | Journal history shows past entries | Grouped by date | | |
| B-07 | Pull-to-refresh on Home | Spinner, data reloads | | |

---

## Section C: Settings & Data

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| C-01 | Theme switch (Light → Dark) | Entire app switches immediately | | |
| C-02 | Language switch (EN → TA → EN) | All labels change, persists on reload | | |
| C-03 | Change location (Chennai → Mumbai) | Sunrise/sunset times change immediately | | |
| C-04 | Clear all data | App resets to onboarding | | |
| C-05 | Data persists across browser reload | Entries + streak preserved | | |

---

## Section D: Dashboard Features

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| D-01 | Birth Bird Card | Bird emoji + name + state + progress bar | | |
| D-02 | Rahu Kaal Card | Red when active, amber when soon | | |
| D-03 | Full Day Schedule (10 yamas) | 5 day + 5 night yamas with bird states | | |
| D-04 | Nostril Pattern + countdown | Solar/Lunar per yama, countdown visible | | |
| D-05 | Shimmer loading (hard refresh) | Animated skeleton cards briefly | | |
| D-06 | Error fallback (disconnect → retry) | Cloud-off icon + retry button | | |
| D-07 | Hold Time Card | Average hold or "No entries today" | | |
| D-08 | Streak zero-state (before first entry) | "Build Your Streak" motivational card | | |
| D-09 | Daily Wisdom card | Non-empty wisdom text | | |
| D-10 | 7-Day Ribbon | Circles with check/X/dash indicators | | |

---

## Section E: Home Tabs (Today / Explore)

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| E-01 | Today tab is default on app open | Shows live data cards | | |
| E-02 | Explore tab shows date selector + calendar | Date arrows, month grid visible | | |
| E-03 | Pick past date → schedule changes | Bird state reflects past date | | |
| E-04 | Date with no entries → empty state | "No entries on this day" card | | |
| E-05 | Best Times This Week (on today) | Next Ruling yama windows | | |
| E-06 | 30-Day Trend | Progress bar + percentage | | |

---

## Section F: Analytics

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| F-01 | Analytics empty state (no entries) | "Your Insights Await" message | | |
| F-02 | After logging entries → data shows | Weekly/monthly cards populate | | |
| F-03 | Yama Performance breakdown | Sorted by practice frequency | | |
| F-04 | Hold Time Progression | Averages + trend direction | | |
| F-05 | CSV export button | Downloads/shows CSV data | | |

---

## Section G: Onboarding, About & Engagement

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| G-01 | Pre-onboarding intro screen | Scrollable guide + "Get Started" | | |
| G-02 | DOB calculation path | Date+time → nakshatra auto-calculated | | |
| G-03 | Manual nakshatra selection | Trilingual list (EN / TA) → bird shows | | |
| G-04 | About card in Settings | Logo, version, developer, links | | |
| G-05 | User Guide + Reference tables | Scrollable guide + bilingual tables | | |
| G-06 | What's New screen (v1.2.0) | Feature list, dismiss button, shown once | | |
| G-07 | Timer preset selector | Chips: Manual, 4-7-8, Box, etc. | | |
| G-08 | Daily summary card (after entry) | Entries count, alignment %, avg hold | | |
| G-09 | Streak celebration (milestone) | Animated overlay with emojis | | |
| G-10 | Pin/star entry | Star toggles, persists on reload | | |
| G-11 | Language switch in onboarding | EN/TA toggle, all text changes | | |
| G-12 | Hora + Tattva in Birth Bird card | Planet + element sub-row | | |
| G-13 | Sushumna during Sleeping/Dying | "Aligned" + Yoga window advice | | |
| G-14 | DOB recalculation from Settings | Edit star → "Recalculate from DOB" → works | | |
| G-15 | Reference table in User Guide | Bilingual (planets, elements, nakshatras) | | |

---

## Section H: Tamil Translation

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| H-01 | Bird names in Tamil mode | கழுகு/ஆந்தை/காகம்/சேவல்/மயில் | | |
| H-02 | Dashboard labels in Tamil | All cards show Tamil text | | |
| H-03 | Journal page in Tamil | Breath options, timer, history in Tamil | | |
| H-04 | Empty states in Tamil | Journal/Analytics/Explore in Tamil | | |

---

## Section I: Edge Cases

| ID | Scenario | Expected Outcome | Pass? | Notes |
|----|----------|-----------------|-------|-------|
| I-01 | After sunset (nighttime) | Night yama active, night state shown | | |
| I-02 | Multiple entries same day | All in history, streak correct | | |
| I-03 | Browser reload mid-timer | Timer resets (expected) | | |
| I-04 | Responsive ≥600px | Two-column cards | | |
| I-05 | Responsive <600px | Single column stacked | | |

---

## Verdict

| Section | Scenarios | Required | Result |
|---------|-----------|----------|--------|
| A: Accuracy | 5 | All pass within tolerance | |
| B: Core Flow | 7 | All pass | |
| C: Settings | 5 | All pass | |
| D: Dashboard | 10 | All pass | |
| E: Home Tabs | 6 | All pass | |
| F: Analytics | 5 | All pass | |
| G: Onboarding & Engagement | 15 | At least 12 of 15 | |
| H: Tamil | 4 | At least 3 of 4 | |
| I: Edge Cases | 5 | All pass | |

**Total: 62 scenarios**

**Overall: ⬜ PENDING**

---

## Production Release Gate

| Criterion | Status | Evidence |
|-----------|--------|----------|
| All smoke test sections pass | ⬜ | |
| CI pipeline passes | ⬜ | |
| No open critical/blocker issues | ⬜ | |
| Owner sign-off | ⬜ | |

**Release tag:** `v1.2.0-web` — ⬜ Pending

---

[← Back to Root](../README.md)
