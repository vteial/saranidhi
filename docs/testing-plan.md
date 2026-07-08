[← Back to Root](../README.md)

# Saranidhi — Master Testing Plan

## Overview

This document defines the structured testing strategy for Saranidhi across all layers: unit (domain logic), widget (UI components), integration (full flows), and end-to-end (platform-specific smoke tests).

**Tag Legend:**
- `[Smoke]` — Critical path validation, run on every PR
- `[Regression]` — Feature stability checks, run on sprint merges
- `[Platform]` — Platform-specific behavior verification
- `[Edge]` — Boundary conditions and edge case handling

---

## Testing Framework Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Unit Tests | `flutter_test` + `mocktail` | Pure Dart domain logic, calculations, repositories |
| Widget Tests | `flutter_test` | UI component rendering, interaction, state |
| Integration Tests | `integration_test` (Flutter) | Full user flows on device/simulator |
| E2E (future) | Patrol or Maestro | Cross-platform smoke tests |
| Coverage | `flutter test --coverage` + `lcov` | Track coverage metrics |

---

## 1. Astro-Logic Engine — Domain Unit Tests `[Smoke]`

### Sunrise/Sunset Calculator

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| A-01 | Sunrise at equator on equinox | ~06:00 local time (within 2-minute tolerance) |
| A-02 | Sunrise at high latitude (60°N) summer solstice | Very early sunrise (~03:30) |
| A-03 | Sunrise at high latitude (60°N) winter solstice | Late sunrise (~09:30) |
| A-04 | Sunset minus sunrise = daylight duration | Duration matches known astronomical data |
| A-05 | Invalid coordinates (lat > 90) | Throws ArgumentError or returns fallback |
| A-06 | Southern hemisphere produces inverted seasons | December sunrise earlier than June |

### 5 Yamas Calculation

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| A-10 | Divide 12-hour daylight into 5 Yamas | Each Yama = 144 minutes exactly |
| A-11 | Divide 8-hour winter daylight into 5 Yamas | Each Yama = 96 minutes |
| A-12 | Current time in middle of Yama 3 | Returns `yama3` with correct bird state |
| A-13 | Current time exactly at Yama boundary | Returns the new (next) Yama |
| A-14 | Time before sunrise | Returns null or "pre-dawn" state |
| A-15 | Time after sunset | Returns night Yama calculation (implemented Sprint 15) |

### Rahu Kaal Calculation

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| A-20 | Sunday → 8th segment of daylight | Correct start/end times |
| A-21 | Monday → 2nd segment | Correct start/end times |
| A-22 | Saturday → 3rd segment | Correct start/end times |
| A-23 | Current time inside Rahu Kaal | `isRahuKaal == true` |
| A-24 | Current time outside Rahu Kaal | `isRahuKaal == false` |
| A-25 | 10% Floor Lockout during Rahu | Oracle score forced to exactly 10 |
| A-26 | Oracle score outside Rahu | Normal calculated value (not 10) |

### Hora (Planetary Hour) Calculation

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| A-30 | Sunday first hora | Sun (lord of the day) |
| A-31 | Monday first hora | Moon |
| A-32 | Hora sequence follows Chaldean order | Sun→Venus→Mercury→Moon→Saturn→Jupiter→Mars cycle |
| A-33 | Day horas (12 segments sunrise→sunset) | Correct planet assignment per segment |
| A-34 | Night horas (12 segments sunset→next sunrise) | Correct planet assignment |

### Panja Pakshi Bird States

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| A-40 | Waxing moon + Sunday | Correct bird states per 2D lookup table (day group × bird × yama) |
| A-41 | Waning moon + Sunday | Different bird sequence (phase-shifted) |
| A-42 | Birth nakshatra → birth bird mapping | Correct bird for all 27 nakshatras |
| A-43 | Bird state at current Yama | Returns one of: ruling/eating/walking/sleeping/dying |
| A-44 | All 7 weekdays produce different sequences | No two days have identical full-day patterns |

### Tattva (Element) Cycle

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| A-50 | Elements cycle in order | Earth→Water→Fire→Air→Ether |
| A-51 | Each element duration within Yama | Correct sub-division timing |
| A-52 | Current active element at given time | Returns correct element |

### Lunar Phase

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| A-60 | Known full moon date | Returns `waning` (day after full moon) |
| A-61 | Known new moon date | Returns `waxing` (day after new moon) |
| A-62 | Mid-waxing phase | Returns `waxing` |
| A-63 | Mid-waning phase | Returns `waning` |

---

## 2. Breath Journal — Domain & Widget Tests `[Smoke]`

### Domain Logic

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| B-01 | Log Solar flow when Solar expected | `isAligned == true` |
| B-02 | Log Lunar flow when Solar expected | `isAligned == false` |
| B-03 | Log Sushumna flow | `isAligned` based on Sushumna rules |
| B-04 | Save entry to Drift DB | Entry persisted, retrievable by ID |
| B-05 | Delete entry from DB | Entry removed, not retrievable |
| B-06 | Query entries by date range | Returns only entries within range |

### Widget Tests

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| B-10 | Breath entry widget renders 3 options | Solar, Lunar, Sushumna buttons visible |
| B-11 | Tap Solar button | Triggers state update, shows alignment result |
| B-12 | Breath timer starts on tap | Timer counting up, UI shows elapsed time |
| B-13 | Breath timer stop | Duration recorded, entry created |
| B-14 | Alignment result shows correct icon | Green check (aligned) or amber warning (unaligned) |
| B-15 | Micro-advice text displays | Non-empty guidance string rendered |

---

## 3. Streak & Consistency — Domain Tests `[Regression]`

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| C-01 | 5 consecutive aligned days | Streak = 5 |
| C-02 | 3 aligned, 1 missed, 2 aligned | Streak = 2 (resets after gap) |
| C-03 | No entries ever | Streak = 0 |
| C-04 | Entry today not yet logged | Streak based on yesterday backwards |
| C-05 | 7-day ribbon with mixed results | Correct checkmark/X pattern for last 7 days |
| C-06 | 30-day trend with 20 aligned out of 30 | Trend = 66% (rounded) |
| C-07 | 30-day trend with zero entries | Trend = 0% |
| C-08 | Multiple entries same day | Best alignment counts (any aligned = day aligned) |
| C-09 | Timezone change mid-streak | Streak not broken by travel |
| C-10 | Yama-level accuracy: 3/5 Yamas logged | 60% Yama coverage for that day |

---

## 4. Cloud Backup — Integration Tests `[Platform]`

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| D-01 | Export database to encrypted file | File created at expected path, non-empty |
| D-02 | Import encrypted file restores data | All entries, profile, settings restored |
| D-03 | Backup to Google Drive (Android/Web) | File appears in App Data folder |
| D-04 | Restore from Google Drive | Data restored, matches original |
| D-05 | Backup to iCloud (iOS) | File uploaded to iCloud container |
| D-06 | Restore from iCloud | Data restored, matches original |
| D-07 | No network during backup attempt | Graceful error message, no crash |
| D-08 | Backup with empty database | Succeeds (empty but valid file) |
| D-09 | Restore on fresh install | Onboarding skipped, data loaded |
| D-10 | Storage mode switch (local → cloud) | Prompts backup, transitions cleanly |

---

## 5. Notifications — Platform Tests `[Platform]`

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| E-01 | Schedule notification at Yama boundary | Notification fires within 1-minute tolerance |
| E-02 | Cancel all notifications on setting toggle off | No pending notifications in queue |
| E-03 | App launch clears stale scheduled notifications | Fresh queue based on today's times |
| E-04 | Notification payload contains wisdom text | Non-empty, contextually appropriate string |
| E-05 | Permission denied gracefully | App continues without notifications, setting disabled |
| E-06 | Web platform skips notification scheduling | No errors, feature silently disabled |

---

## 6. AI Wisdom Engine — Unit Tests `[Regression]`

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| F-01 | Context payload builds correctly | All fields populated (streak, accuracy, bird, rahu, tattva) |
| F-02 | Fallback proverbs array is non-empty | At least 50 entries |
| F-03 | Fallback returns different proverb each day | Deterministic by date seed, not random |
| F-04 | Rules-based engine matches condition | Returns appropriate wisdom for given context |
| F-05 | On-device model unavailable → fallback | Graceful degradation, proverb displayed |
| F-06 | AI card caches result for 24 hours | Second call same day returns cached insight |
| F-07 | New day resets cache | Fresh insight generated |

---

## 7. Onboarding & Settings — Widget Tests `[Regression]`

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| G-01 | Fresh app launch → onboarding screen | Welcome view displayed |
| G-02 | Complete onboarding → dashboard | Profile saved, main view shown |
| G-03 | Birth star selection → bird calculated | Correct bird displayed |
| G-04 | Location permission granted | Lat/Lng stored in profile |
| G-05 | Location permission denied | Fallback to manual city entry or default |
| G-06 | Storage mode selection persists | App uses chosen mode on next launch |
| G-07 | Theme switch (Light → Dark) | Theme applied immediately, persisted |
| G-08 | Language switch (EN → TA) | All strings switch, persisted |
| G-09 | Profile edit and save | Updated values in Drift DB |
| G-10 | Completed onboarding → app launch skips onboarding | Directly to dashboard |

---

## 8. Navigation & App Shell — Widget Tests `[Smoke]`

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| H-01 | Bottom nav shows correct tabs | Home, Journal, Analytics visible |
| H-02 | Tap Journal tab | Navigates to journal view |
| H-03 | Tap Settings gear icon | Navigates to settings view (pushed route) |
| H-04 | Deep link to journal entry | Opens specific entry detail |
| H-05 | Back navigation preserves state | Tab state maintained across navigation |
| H-06 | App resume from background | State preserved, no re-onboarding |

---

## 9. Data Persistence — Integration Tests `[Edge]`

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| I-01 | Insert 1000 journal entries | No performance degradation on query |
| I-02 | Drift migration (schema update) | Existing data preserved after upgrade |
| I-03 | Concurrent read/write operations | No SQLite lock errors |
| I-04 | App killed during write | Data either committed or rolled back (no corruption) |
| I-05 | Clear all data from settings | All tables emptied, profile reset |
| I-06 | Export data as JSON | Valid JSON containing all user data |
| I-07 | Import data from JSON | All data restored correctly |

---

## Execution Strategy

| Tier | Trigger | Environment | Tool |
|------|---------|-------------|------|
| `[Smoke]` | Every PR via GitHub Actions CI | flutter_test (headless) | `flutter test` |
| `[Regression]` | Sprint merge PRs | flutter_test (headless) | `flutter test` |
| `[Platform]` | Sprint 5+ (cloud) and Sprint 6+ (notifications) | Real device / simulator | `integration_test` |
| `[Edge]` | Sprint 10 dedicated hardening | Real device / simulator | `integration_test` + profiling |

---

## Test Count Progression

| Sprint | Tests Added | Cumulative | Notes |
|--------|------------|-----------|-------|
| Sprint 2 | 153 | 153 | Astro-Logic Engine (pure Dart TDD) |
| Sprint 3 | 8 | 161 | Widget tests for journal + integration scaffold |
| Sprint 4 | 24 | 185 | Streak engine domain tests |
| Sprint 5 | 0 | 185 | Cloud backup (stubs, no new test assertions) |
| Sprint 6 | 0 | 185 | Notifications (platform stubs) |
| Sprint 7 | 16 | 201 | AI Wisdom Engine unit tests |
| Sprint 8 | 0 | 201 | Theming/profile (UI-only, no new tests) |
| Sprint 9 | 0 | 201 | i18n/polish (UI-only; G-08, I-05 covered in Sprint 10) |
| Sprint 10 | 63 | 264 | Unit tests: BirdEmoji, BreathTimer, DashboardData, Locale, Theme, OnboardingState, AppLocalizations |
| Sprint 12 | 0 | 264 | Pakshi calculator tests rewritten — validates authentic 2D lookup tables (bright/dark half, day groups, per-bird state verification) |
| Sprint 14 | 0 | 264 | UI-heavy sprint (5 new widgets), no new test assertions |
| Sprint 15 | 0 | 264 | Night yama calculator + night Pakshi tables, no new tests |
| Sprint 20 | 84 | 348 | Widget/integration test rewrites for Today/Explore tabs, Settings gear icon nav, new assertions for sub-tab labels |
| Sprint 21 | 0 | 348 | Moon longitude, Lahiri Ayanamsa, Nakshatra calculators + onboarding UX redesign; existing test expectations updated (totalSteps 5→4), no new test files |
| Sprint 22 | 62 | 410 | 10 widget test files (BirthBirdCard, RahuKaalCard, FullDaySchedule, NostrilDominanceChart, HoldTimeCard, StreakFlame, Trend, SevenDayRibbon, YamaAccuracy, WisdomCard) + shared widget_test_helpers.dart |
| Sprint 23 | 0 | 410 | UI features (IntroScreen, AboutCard, UserGuide, dialog consistency), no new test files |
| Sprint 24 | 0 | 410 | UX polish (empty states, shimmer loading, error boundary); streak_flame_widget_test updated for zero-state behavior change, no new test files |
| Sprint 25 | 0 | 410 | Performance/accessibility polish (timezone, keyboard, haptics, semantics); no new test files, existing tests unaffected |
| Sprint 26 | 0 | 410 | Daily engagement features (What's New, celebrations, presets, summary, pin, quick-log); new widgets not yet wired into existing tests |
| Sprint 27 | 0 | 410 | Layer 1 gap fixes (ActionWindow, Sushumna alignment, Hora/Tattva, guided test, i18n); alignment_checker_test updated for context-dependent Sushumna |

### Scenarios Awaiting Automated Test Coverage (Sprint 10)

| ID | Scenario | Implemented In |
|----|----------|---------------|
| G-08 | Language switch (EN → TA) persistence | Sprint 9 |
| I-05 | Clear all data from settings → onboarding reset | Sprint 9 |
| H-01 | Bottom nav localized labels | Sprint 9 |

---

## Coverage Targets

| Layer | Target | Measured By |
|-------|--------|-------------|
| Domain (Astro-Logic Engine) | ≥ 95% | Unit test line coverage |
| Domain (Streak, Journal logic) | ≥ 90% | Unit test line coverage |
| Widget (Core components) | ≥ 80% | Widget test coverage |
| Integration (User flows) | All critical paths | Manual + automated scenario pass rate |
| Overall project | ≥ 20% (current; will increase with widget test coverage) | `flutter test --coverage` aggregate |

---

## CI Pipeline Integration

```yaml
# Runs on every PR to main
jobs:
  test:
    steps:
      - flutter pub get
      - dart run build_runner build --delete-conflicting-outputs
      - dart analyze
      - flutter test --coverage
      - # Coverage threshold check (fail if < 20%)
```

---

## Implemented Feature Scenarios (Sprints 14–15)

### Sprint 14: Birth Bird Dashboard

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| D-01 | Birth bird state matches yama lookup table | Owl shows correct state for current weekday + phase + yama |
| D-02 | Full-day schedule shows 5 yama entries | All 5 with correct bird states, times, and colors |
| D-03 | Rahu Kaal window matches Align27 | Start/end times within ±2 min tolerance |
| D-04 | Yama progress updates in real-time | Progress bar advances, time remaining decrements |
| D-05 | Nostril dominance matches odd/even yama rule | Odd=Solar, Even=Lunar displayed correctly |
| D-06 | Hold time card shows today's average | Computed from all entries with hold data today |

### Sprint 15: Night Yamas

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| N-01 | Night yama calculation (sunset→sunrise ÷ 5) | Each yama ~2h 24m in duration |
| N-02 | Night Pakshi states match reference tables | Bird states for night yamas 6-10 correct per Pulippani |
| N-03 | App shows active state after sunset | Night bird state displayed, not blank |
| N-04 | 10-yama view shows continuous day→night | Seamless transition at sunset |

---

## Future Test Scenarios (Sprints 16–19)

### Sprint 16: iCloud Sync

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| S-01 | Journal entry syncs to iCloud | Entry appears on second device after opening app |
| S-02 | Profile changes sync | Name/star/location propagate |
| S-03 | Conflict resolution uses primary device | Primary device entry wins |
| S-04 | Offline entries queue and sync later | Entries made offline push when connection restored |
| S-05 | macOS build runs and syncs | Flutter macOS target builds, reads same CloudKit container |

### Sprint 17: Notifications

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| NT-01 | Yama transition fires notification | Alert within 1 min of yama boundary |
| NT-02 | Notification shows bird state | "Your Owl is now Ruling" with guidance |
| NT-03 | Disabled states don't fire | If user disables Sleeping notifications, none fire for Sleeping |
| NT-04 | Morning summary shows best times | Today's Ruling yama times listed |

### Sprint 19: Analytics

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| AN-01 | Hold time average correct per day | Sum of hold durations ÷ count for that day |
| AN-02 | Weekly trend shows 7 data points | Each day's average hold shown |
| AN-03 | CSV export contains all journal fields | Downloadable, correct column headers, all entries |
| AN-04 | Personal best updates on new record | Highlighted when user beats their longest hold |

### Sprint 20: UI Polish + Data Export/Import

| ID | Scenario | Expected Outcome |
|----|----------|-----------------|
| UI-01 | Home shows Today/Explore sub-tabs | TabBar visible, Today is default |
| UI-02 | Today tab shows 7 focused cards | Bird, Rahu, Schedule, Nostril, Wisdom, Hold+Streak, Ribbon |
| UI-03 | Explore tab shows date navigation | Date Selector, Calendar, Trend, Historical entries |
| UI-04 | Responsive layout ≥600px all screens | Two-column on Journal, Settings, Analytics |
| UI-05 | Settings accessible via top-right gear icon | Icon visible on all screens, navigates to Settings |
| UI-06 | JSON export produces valid file | share sheet/download triggers with correct JSON structure |
| UI-07 | JSON import with valid file | Validation passes, confirmation dialog shows summary, data imports |
| UI-08 | JSON import with invalid file | Error message shown, no data modified |
| UI-09 | Import reflects changes immediately | All providers invalidated, UI updates without page reload |
| UI-10 | Schedule row order | Yama → Time → Bird → State name → State icon |

---

[← Back to Root](../README.md)
