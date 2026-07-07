[← Back to Root](../README.md)

# Saranidhi — Smoke Test Results (v1.2.0-web)

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

---

## Section A: Calculation Accuracy

| ID | Check | Our App | Align27 | Pass? | Notes |
|----|-------|---------|---------|-------|-------|
| A-01 | Sunrise | | | | |
| A-02 | Sunset | | | | |
| A-03 | Birth bird state | | | | |
| A-04 | Rahu Kaal | | | | |
| A-05 | Lunar phase | | | | |

---

## Section B: Core User Flow

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| B-01 | Fresh onboarding | | |
| B-02 | Log aligned breath | | |
| B-03 | Log unaligned breath | | |
| B-04 | Timer full cycle | | |
| B-05 | Streak updates | | |
| B-06 | Journal history | | |
| B-07 | Pull-to-refresh | | |

---

## Section C: Settings & Data

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| C-01 | Theme switch | | |
| C-02 | Language switch (EN↔TA) | | |
| C-03 | Change location (Mumbai) | | |
| C-04 | Clear all data | | |
| C-05 | Data persists reload | | |

---

## Section D: Dashboard Features

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| D-01 | Birth Bird Card | | |
| D-02 | Rahu Kaal Card | | |
| D-03 | Full Day Schedule (10 yamas) | | |
| D-04 | Nostril Pattern + countdown | | |
| D-05 | Shimmer loading on first load | | |
| D-06 | Error fallback + retry | | |
| D-07 | Hold Time Card | | |
| D-08 | Streak zero-state | | |
| D-09 | Daily Wisdom card | | |
| D-10 | 7-Day Ribbon | | |

---

## Section E: Home Tabs

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| E-01 | Today tab default | | |
| E-02 | Explore tab (date + calendar) | | |
| E-03 | Past date schedule change | | |
| E-04 | Empty state for date with no entries | | |
| E-05 | Best Times This Week | | |
| E-06 | 30-Day Trend | | |

---

## Section F: Analytics

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| F-01 | Analytics empty state | | |
| F-02 | Analytics populates after entries | | |
| F-03 | Yama Performance | | |
| F-04 | Hold Time Progression | | |
| F-05 | CSV export | | |

---

## Section G: Onboarding, About & Engagement

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| G-01 | Pre-onboarding intro | | |
| G-02 | DOB calculation path | | |
| G-03 | Manual nakshatra selection (trilingual) | | |
| G-04 | About card in Settings | | |
| G-05 | User Guide + Reference tables | | |
| G-06 | What's New screen (v1.2.0) | | |
| G-07 | Timer preset selector | | |
| G-08 | Daily summary card | | |
| G-09 | Streak celebration (milestone) | | |
| G-10 | Pin/star entry | | |
| G-11 | Language switch in onboarding | | |
| G-12 | Hora + Tattva in Birth Bird card | | |
| G-13 | Sushumna context alignment | | |
| G-14 | DOB recalculation from Settings | | |
| G-15 | Reference table bilingual | | |

---

## Section H: Tamil Translation

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| H-01 | Bird names Tamil | | |
| H-02 | Dashboard labels Tamil | | |
| H-03 | Journal page Tamil | | |
| H-04 | Empty states Tamil | | |

---

## Section I: Edge Cases

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| I-01 | After sunset (night yama) | | |
| I-02 | Multiple entries same day | | |
| I-03 | Browser reload mid-timer | | |
| I-04 | Responsive ≥600px (two-col) | | |
| I-05 | Responsive <600px (stacked) | | |

---

## Verdict

| Section | Result | Blocker? |
|---------|--------|----------|
| A: Accuracy | | |
| B: Core Flow | | |
| C: Settings | | |
| D: Dashboard | | |
| E: Home Tabs | | |
| F: Analytics | | |
| G: Onboarding & Engagement | | |
| H: Tamil | | |
| I: Edge Cases | | |

**Overall: ⬜ PENDING**

---

## Production Release Gate

| Criterion | Status | Evidence |
|-----------|--------|----------|
| All smoke test sections pass | ⬜ | |
| CI pipeline passes | ⬜ | |
| No open critical/blocker issues | ⬜ | |
| Owner sign-off | ⬜ | |

**Total scenarios:** 62

**Release tag:** `v1.2.0-web` — ⬜ Pending

---

[← Back to Root](../README.md)
