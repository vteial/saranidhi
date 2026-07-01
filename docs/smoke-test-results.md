[← Back to Root](../README.md)

# Saranidhi — Smoke Test Results

## Execution Details

| Parameter | Value |
|-----------|-------|
| **Tester** | Eialarasu |
| **Date** | 2026-07-01 |
| **Device** | iMac M3 |
| **Browser/OS** | Chrome / macOS |
| **Location** | Chennai (13.08, 80.27) |
| **Nakshatra** | Pushya (Owl) |
| **App URL** | https://saranidhi.vercel.app |
| **Reference** | Align27 v1.80 |

---

## Section A: Calculation Accuracy

| ID | Check | Our App | Align27 | Diff | Pass? |
|----|-------|---------|---------|------|-------|
| A-01 | Sunrise | — | — | — | Not tested |
| A-02 | Sunset | — | — | — | Not tested |
| A-03 | Current bird | Crow (earlier), Rooster (later) | Cock | Rooster=Cock (same bird) | ✅ Yes |
| A-04 | Bird state | Sleeping | Energize (=Eating) | Wrong state assignment | ❌ No |
| A-05 | Rahu Kaal | — | — | — | Not tested |
| A-06 | Active Yama | — | — | — | Not tested |
| A-07 | Lunar phase | — | — | — | Not tested |

### Root Cause Analysis (A-04)

The Panja Pakshi algorithm assigns states by **array position** (position 0=Ruling, 1=Eating, 2=Walking, 3=Sleeping, 4=Dying). The authentic system uses **independent 2D lookup tables** where each bird has its own state per yama, varying by day-group and lunar phase.

- **Our code:** Rooster at position 3 → always "Sleeping"
- **Correct:** Rooster on Tuesday (dark half), Yama 2 → "Eating" (Align27 shows as "Energize")

Align27 terminology mapping: Succeed=Ruling, Energize=Eating, Action=Walking, Relax=Sleeping, Caution=Dying.

---

## Section B: Core User Flow

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| B-01 | Fresh onboarding | ✅ Yes | |
| B-02 | Log aligned breath | ✅ Yes | |
| B-03 | Log unaligned breath | ✅ Yes | |
| B-04 | Timer full cycle | ✅ Yes | |
| B-05 | Streak updates | ✅ Yes | |
| B-06 | Journal history | ✅ Yes | |
| B-07 | Wisdom card | ✅ Yes | |
| B-08 | Pull-to-refresh | ✅ Yes | |

---

## Section C: Settings & Data

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| C-01 | Theme → Dark | ✅ Yes | |
| C-02 | Color → Emerald | ✅ Yes | |
| C-03 | Language EN→TA | ✅ Yes | |
| C-04 | Language TA→EN | ✅ Yes | |
| C-05 | Language persists | ✅ Yes | |
| C-06 | Profile edit name | ✅ Yes | |
| C-07 | Birth star change | ✅ Yes | |
| C-08 | Clear all data | ✅ Yes | |
| C-09 | Data persists reload | ⬜ N/A | Not tested |

---

## Section D: Tamil Quality

| ID | Check | Pass? | Notes |
|----|-------|-------|-------|
| D-01 | Bird names Tamil | ❌ No | Bird names not displayed in Tamil in the UI |
| D-02 | Bird states Tamil | ❌ No | State names not displayed in Tamil in the UI |
| D-03 | Onboarding Tamil | ✅ Yes | |
| D-04 | Breath options Tamil | ❌ No | Whole page content not translated |
| D-05 | Settings labels Tamil | ❌ No | "Storage Mode" and "Backup & Restore" not translated; Color Accent values not in Tamil |

---

## Section E: Edge Cases

| ID | Scenario | Pass? | Notes |
|----|----------|-------|-------|
| E-01 | Before sunrise | ✅ Yes | |
| E-02 | After sunset | ✅ Yes | |
| E-03 | Different city | ✅ Yes | |
| E-04 | Multiple entries/day | ✅ Yes | |
| E-05 | Reload mid-timer | ✅ Yes | |

---

## Verdict

| Section | Result | Blocker? |
|---------|--------|----------|
| A: Accuracy | ❌ FAIL | Yes — bird state calculation wrong |
| B: Core Flow | ✅ PASS | No |
| C: Settings | ✅ PASS | No |
| D: Tamil | ❌ FAIL | No (minor for 1.0, but fixing in this sprint) |
| E: Edge Cases | ✅ PASS | No |

**Overall: ❌ FAIL**

### Blockers

1. **A-04: Bird state calculation incorrect** — Panja Pakshi algorithm uses wrong state assignment method. Must rewrite with authentic 2D lookup tables per day-group × bird × yama. This is a critical accuracy bug that undermines the app's core value proposition.

### Non-Blocking Fixes (Sprint 12)

2. **D-01/D-02: Bird/state names not shown in Tamil** — UI uses `displayName` getter (English only) instead of localized ARB strings.
3. **D-04: Breath page not translated** — Missing Tamil translations for breath journal page content.
4. **D-05: Settings gaps** — "Storage Mode", "Backup & Restore" labels and Color Accent values missing Tamil translations.

---

[← Back to Root](../README.md)
