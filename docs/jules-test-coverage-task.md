[← Back to Root](../README.md)

# Test Coverage Enhancement — Google Jules Task Brief

## Overview

| Parameter | Value |
|-----------|-------|
| **Repository** | https://github.com/vteial/saranidhi |
| **Agent** | Google Jules (AI coding agent) |
| **Base branch** | `main` |
| **Target** | Increase test coverage from 20% to 60%+ |
| **Timeline** | Parallel with ongoing sprint development |
| **Scope** | Test files ONLY — no source code changes |

---

## Rules

1. **ONLY** create/modify files in the `test/` directory
2. Do **NOT** modify any files in `lib/`, `docs/`, `.kiro/`, or `.github/`
3. All tests must pass: `flutter test`
4. Follow existing test patterns in `test/features/`
5. Use `flutter_test` + `mocktail` for mocking
6. Create **separate branches** for each PR:
   - `test/domain-coverage`
   - `test/new-widget-coverage`
   - `test/existing-widget-coverage`

---

## PR 1: Domain Layer Tests

**Branch:** `test/domain-coverage`

**Focus:** `lib/features/astro_engine/domain/` and `lib/features/streaks/providers/`

### 1. Night Yama Calculator (`lib/features/astro_engine/domain/yama_calculator.dart`)

- `calculateNight()` divides sunset→sunrise into 5 equal segments
- `NightYamaSegment.contains()` returns correct yama for given time
- `nightYamaResult.activeYama()` returns null for daytime
- Night yama durations are equal
- Edge: sunset == nextSunrise throws ArgumentError

### 2. Night Pakshi Calculator (`lib/features/astro_engine/domain/pakshi_calculator.dart`)

- `calculateNight()` returns correct state tables for all day groups
- Night bright half: 4 groups (A=Sun/Tue, B=Mon/Wed/Sat, C=Thu, D=Fri)
- Night dark half: 5 groups (A=Sun/Tue, B=Mon/Sat, C=Wed, D=Thu, E=Fri)
- Each night yama has exactly 1 ruling bird
- Each bird rules exactly 1 night yama
- Night tables differ from daytime tables

### 3. Rahu Kaal Calculator (`lib/features/astro_engine/domain/rahu_kaal_calculator.dart`)

- All 7 weekdays produce correct segment index
- `isActive()` returns true when time is within window
- `isActive()` returns false outside window
- Duration matches 1/8 of daylight

### 4. Extended DashboardData Provider Logic

- Birth bird extracted from profile correctly
- `stateForBird` returns correct state for given yama
- Night detection: `isNight=true` after sunset
- Today's average hold calculated correctly

---

## PR 2: New Widget Tests (Sprint 14-15)

**Branch:** `test/new-widget-coverage`

**Focus:** `lib/features/home/presentation/widgets/` (Sprint 14-15 widgets)

### 1. BirthBirdCard

- Renders bird emoji + localized name + state
- Shows guidance text matching state
- Progress bar visible when `activeYama` is set
- Returns `SizedBox.shrink` when `birthBird` is null
- Color: green for ruling/eating, orange for walking, red for sleeping/dying

### 2. RahuKaalCard

- Shows time range in HH:mm format
- Red styling when `isActive` (mock time within window)
- Amber when starting within 1 hour
- Subtle when not active/soon

### 3. FullDaySchedule

- Renders 5 daytime yama rows with times
- Renders 5 nighttime yama rows (if `pakshiNight` provided)
- Highlights active yama with "NOW"
- Shows "Best time!" for ruling yama
- State emojis displayed (crown, plate, walking, zzz, skull)
- Align27 row shows ruling bird for current yama

### 4. NostrilDominanceChart

- Renders 5 rows (Y1-Y5)
- Odd yamas show Solar, even show Lunar
- Active yama highlighted
- Next switch countdown displays minutes

### 5. HoldTimeCard

- Shows "No entries today" when `avgHoldMs` is null
- Shows formatted average when data present
- Shows entry count

---

## PR 3: Existing Widget Tests

**Branch:** `test/existing-widget-coverage`

**Focus:** Previously untested widgets

### 1. StreakFlameWidget

- Shows correct day count
- "Active today!" when `isActiveToday`
- "Start your streak" when streak is 0
- "Best" shown when `longestStreak > currentStreak`

### 2. TrendWidget

- Shows percentage
- Shows aligned/total summary
- Color: green >=70%, orange >=40%, red <40%

### 3. SevenDayRibbonWidget

- Renders 7 day chips
- Aligned days show green check
- Unaligned days show red X
- No-entry days show grey dash

### 4. YamaAccuracyWidget

- Shows "Log entries..." when `totalEntries` is 0
- Shows percentage
- Shows 5 yama bars with correct labels
- Progress bars proportional to entry count

### 5. WisdomCard

- Shows "Daily Wisdom" title
- Shows wisdom text when loaded
- Shows skeleton loader when loading
- Shows fallback text on error

---

## Reference: Existing Test Patterns

See these files for style reference:
- `test/features/astro_engine/pakshi_calculator_test.dart`
- `test/features/astro_engine/yama_calculator_test.dart`
- `test/features/providers/theme_provider_test.dart`

For widget tests, use:
- `MaterialApp` wrapper with localization delegates
- `ProviderScope` with overrides for Riverpod providers
- `pump()` / `pumpAndSettle()` for rendering
- `find.text()` / `find.byType()` for assertions

---

## Validation (Before Each PR)

1. `flutter test` — all pass (0 failures)
2. `flutter test --coverage` — coverage increased
3. `dart analyze` — 0 issues
4. PR targets `main` branch
5. PR title format: `test: <area> coverage enhancement`

---

## Coordination

- Sprint development happens in parallel on separate branches (`feature/sprintX-*`)
- Jules PRs should NOT conflict since they only modify `test/` files
- If a sprint changes `lib/` files that Jules is testing, Jules may need to rebase
- Merge order: Sprint PRs first, then Jules test PRs (to avoid conflicts)

---

[← Back to Root](../README.md)
