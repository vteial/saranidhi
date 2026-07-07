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

| ID | Scenario | Expected | Tolerance |
|----|----------|----------|-----------|
| A-01 | Sunrise time matches Align27 | ±2 min | ±2 min |
| A-02 | Sunset time matches Align27 | ±2 min | ±2 min |
| A-03 | Birth bird state matches Align27 (Owl for Pushya) | Exact state name | Exact |
| A-04 | Rahu Kaal start/end matches Align27 | ±2 min | ±2 min |
| A-05 | Lunar phase (waxing/waning) correct for today | Matches Align27 | Same day |

---

## Section B: Core User Flow

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| B-01 | Fresh onboarding (clear data → complete 4-step flow) | Dashboard appears with Birth Bird Card |
| B-02 | Log aligned breath (correct nostril → timer → submit) | "Aligned" shown, streak increments |
| B-03 | Log unaligned breath (wrong nostril → timer → submit) | "Not aligned" shown, micro-advice displayed |
| B-04 | Timer full cycle (inhale → hold → exhale → complete) | Each phase shows live seconds, results display |
| B-05 | Streak updates after aligned entry | Flame shows ≥1 days, ribbon shows today aligned |
| B-06 | Journal history shows past entries | Entries listed, grouped by date |
| B-07 | Pull-to-refresh on Home | Spinner appears, data reloads |

---

## Section C: Settings & Data

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| C-01 | Theme switch (Light → Dark) | Entire app switches immediately |
| C-02 | Language switch (EN → TA → EN) | All labels change, persists on reload |
| C-03 | Change location (Chennai → Mumbai) | Sunrise/sunset times change |
| C-04 | Clear all data | App resets to onboarding |
| C-05 | Data persists across browser reload | Entries + streak preserved |

---

## Section D: Dashboard Features (Sprints 14–24)

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| D-01 | Birth Bird Card shows state + guidance | Bird emoji + name + state + progress bar |
| D-02 | Rahu Kaal Card shows time window | Red when active, amber when soon |
| D-03 | Full Day Schedule (10 yamas, day + night) | 5 day yamas + 5 night yamas with bird states |
| D-04 | Nostril Pattern with next switch countdown | Solar/Lunar per yama, countdown visible |
| D-05 | Shimmer loading on first load (hard refresh) | Animated skeleton cards appear briefly |
| D-06 | Error fallback (disconnect network → retry) | Cloud-off icon + retry button |
| D-07 | Hold Time Card | Average hold or "No entries today" |
| D-08 | Streak zero-state (clear data, before first entry) | "Build Your Streak" motivational card |
| D-09 | Daily Wisdom card shows text | Non-empty wisdom content |
| D-10 | 7-Day Ribbon shows last 7 days | Circles with check/X/dash indicators |

---

## Section E: Home Tabs (Today / Explore)

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| E-01 | Today tab is default on app open | Shows live data cards |
| E-02 | Explore tab shows date selector + calendar | Date arrows, month grid visible |
| E-03 | Pick past date in Explore → schedule changes | Birth bird state reflects past date |
| E-04 | Pick date with no entries → empty state shows | "No entries on this day" card |
| E-05 | Best Times This Week card (on today) | Shows next Ruling yama windows |
| E-06 | 30-Day Trend shows alignment percentage | Progress bar + percentage |

---

## Section F: Analytics

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| F-01 | Analytics empty state (no entries) | "Your Insights Await" full-screen message |
| F-02 | After logging entries → analytics shows data | Weekly/monthly cards populate |
| F-03 | Yama Performance breakdown | Bar chart sorted by practice frequency |
| F-04 | Hold Time Progression | Weekly/monthly averages + trend direction |
| F-05 | CSV export button | Downloads/shows CSV data |

---

## Section G: Onboarding, About & Engagement

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| G-01 | Pre-onboarding intro screen shows | Scrollable guide + "Get Started" button |
| G-02 | DOB calculation path in onboarding | Enter date+time → nakshatra auto-calculated |
| G-03 | Manual nakshatra selection path | Trilingual list (EN / TA) → bird shows immediately |
| G-04 | About card in Settings | Logo, version, developer name, links |
| G-05 | User Guide accessible from About | Flat scrollable guide + Reference tables at bottom |
| G-06 | What's New screen on first v1.2.0 launch | Feature list with dismiss button, shown once |
| G-07 | Timer preset selector visible | Horizontal chips (Manual, 4-7-8, Box, etc.) |
| G-08 | Daily summary card after logging entry | Entries count, alignment %, avg hold shown |
| G-09 | Streak celebration at milestone (7 days) | Animated overlay with confetti emojis |
| G-10 | Pin/star an entry in journal history | Star icon toggles, persists on reload |
| G-11 | Language switch in onboarding | EN/TA toggle at top-right, all text changes |
| G-12 | Hora + Tattva sub-row in Birth Bird card | Planet emoji + name • Element emoji + Sanskrit name |
| G-13 | Sushumna during Sleeping/Dying → aligned | "Aligned" result with Yoga window advice |
| G-14 | DOB recalculation from Settings | Profile → edit star → "Recalculate from DOB" → date/time → updates |
| G-15 | Reference table in User Guide | Bilingual tables (planets, elements, 27 nakshatras) |

---

## Section H: Tamil Translation

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| H-01 | Bird names in Tamil mode | கழுகு/ஆந்தை/காகம்/சேவல்/மயில் |
| H-02 | Dashboard labels in Tamil | All cards show Tamil text |
| H-03 | Journal page in Tamil | Breath options, timer, history in Tamil |
| H-04 | Empty states in Tamil | Journal/Analytics/Explore empty text in Tamil |

---

## Section I: Edge Cases

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| I-01 | After sunset (nighttime) | Night yama active, night state shown |
| I-02 | Multiple entries same day | All appear in history, streak correct |
| I-03 | Browser reload mid-timer | Timer resets (expected) |
| I-04 | Responsive layout (≥600px) | Two-column cards |
| I-05 | Responsive layout (<600px) | Single column stacked |

---

## Pass Criteria

| Section | Required |
|---------|----------|
| A: Accuracy (5 checks) | All pass within tolerance |
| B: Core Flow (7 checks) | All pass |
| C: Settings (5 checks) | All pass |
| D: Dashboard (10 checks) | All pass |
| E: Home Tabs (6 checks) | All pass |
| F: Analytics (5 checks) | All pass |
| G: Onboarding, About & Engagement (15 checks) | At least 12 of 15 pass |
| H: Tamil (4 checks) | At least 3 of 4 pass |
| I: Edge Cases (5 checks) | All pass |

**Total: 62 scenarios**

**Overall Verdict:** ALL sections must pass for production release.

---

## Execution Notes

- Execute on staging URL after sprint merge
- Compare Section A with Align27 on same device at same time
- Record results in `docs/smoke-test-results-v{version}.md`
- Any failures → logged for hotfix before release tag

---

[← Back to Root](../README.md)
