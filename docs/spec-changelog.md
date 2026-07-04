[← Back to Root](../README.md)

# Saranidhi — Spec Changelog

> Cumulative record of all specification changes, ordered by sprint (newest first).
> This file is **append-only** — entries are never rewritten or removed.
> See the [delta tracking guide](https://github.com/vteial/project-blueprint/blob/main/guides/10-delta-tracking.md) for conventions.

---

## Sprint 19: Analytics + Export

**Date:** 2026-07-04 | **PR:** #46

### ADDED
- Analytics screen as 4th bottom navigation tab (insights icon)
- `AnalyticsCalculator` domain class: weekly, monthly, streak, hold time, CSV calculations
- `WeeklySummary` model: alignment % per 7-day window
- `MonthlyPatterns` model: best/worst day, most/least active yama
- `StreakInsights` model: total practice days, avg gap, consistency %
- `HoldTimeProgression` model: daily/weekly/monthly averages, personal best, trend direction
- `generateCsv()`: full 14-column journal export
- 6 analytics Riverpod providers
- `/analytics` route in GoRouter

### MODIFIED
- Bottom navigation: 3 tabs → 4 tabs (Home, Journal, Settings, Analytics)
- Shell scaffold: added NavigationDestination for Analytics

### REMOVED
- (none)

---

## Sprint 18: Historical View + Planning

**Date:** 2026-07-03 | **PR:** #44

### ADDED
- `selectedDateProvider` (NotifierProvider): drives dashboard date
- `isViewingTodayProvider`: computed bool for today detection
- `DateSelector` widget: arrows, date picker dialog, Tomorrow, Today reset
- `BestTimesCard` + `bestTimesProvider`: 7-day Ruling yama scan
- `HistoricalEntriesCard` + `historicalEntriesProvider`: past date journal entries
- `CalendarMonthView` + `monthEntryDaysProvider` + `calendarMonthProvider`: month grid with entry dots

### MODIFIED
- `dashboardDataProvider`: parameterized by `selectedDate` (was hardcoded `DateTime.now()`)
- Active yama/night detection: only fires when `isViewingToday`
- Hold time query: scoped to selected date (was always "today")
- Auto-refresh timer: only active when viewing today

### REMOVED
- (none)

---

## Sprint 17: Notifications + Daily Engagement

**Date:** 2026-07-03 | **PR:** #41

### ADDED
- `flutter_local_notifications` + `timezone` packages
- `NotificationService` singleton: initialize, permission, zonedSchedule, cancelAll
- Personalized notification content: "Your [Bird] is now [State]" with guidance text
- Rahu Kaal start/end notifications
- Morning summary notification at sunrise (best Ruling yama time)
- `notifyRahuKaal` + `notifyMorningSummary` preferences (persisted)
- `WisdomLibraryTa`: 52+ Tamil proverbs (locale-aware)
- `WisdomCache`: locale-tracked caching with invalidation on language switch

### MODIFIED
- `NotificationScheduler`: full rewrite with bird state, Rahu Kaal, morning summary
- `NotificationPreferences`: expanded from 2 to 4 toggles
- `RulesEngine.generate()`: accepts `locale` parameter
- `FallbackHandler.todaysProverb()`: accepts `locale` parameter
- `wisdomInsightProvider`: watches `localeProvider`, passes locale through pipeline
- Settings: 4 notification toggles (was 2)

### REMOVED
- (none)

---

## Sprint 16: iCloud Sync + macOS Target

**Date:** 2026-07-03 | **PR:** #39

### ADDED
- CloudKit schema: 4 record types (Profile, JournalEntry, BreathSession, SyncMetadata)
- `CloudKitSyncService`: MethodChannel CRUD with native Swift
- `CloudKitSyncEngine`: pull→merge→push orchestrator with conflict resolution
- `CloudKitRecordMapper`: Drift ↔ CloudKit field conversion
- `SyncOnOpenWidget`: triggers sync on app launch + resume
- `SyncTriggerService`: push-after-write hooks (journal, profile)
- `SyncDeviceConfigWidget`: Settings UI (primary toggle, device name, status, other devices)
- iOS native: `CloudKitPlugin.swift` + entitlements
- macOS target: full scaffold + `CloudKitPluginMacOS.swift` + entitlements
- `docs/dev-setup.md`: iMac development environment guide
- `docs/icloud-sync-testing.md`: 7 multi-device test scenarios

### MODIFIED
- `ICloudBackupRepository`: upgraded from stub to real CloudKit service
- `backup_providers.dart`: uses real `CloudKitSyncService`
- `main.dart`: `SyncOnOpenWidget` wraps `OnboardingGuard`
- Home pull-to-refresh: also triggers iCloud sync

### REMOVED
- Old stub-only `ICloudBackupRepository` implementation

---

## Sprint 15: Night Yamas + Full 24h View

**Date:** 2026-07-03 | **PR:** #33

### ADDED
- `NightYamaIndex` enum, `NightYamaSegment`, `NightYamaResult` classes
- `YamaCalculator.calculateNight()`: sunset→sunrise divided into 5 night yamas
- 9 nighttime Pakshi lookup tables (4 bright + 5 dark half)
- `PakshiCalculator.calculateNight()`: night bird states
- `DashboardData`: nightYamaResult, activeNightYama, pakshiNight, birthBirdNightState, isNight
- Night section in `FullDaySchedule` (10-yama view)
- Night guidance text (5 l10n keys EN + TA)

### MODIFIED
- `BirthBirdCard`: shows night bird state + night yama progress after sunset
- `NostrilDominanceChart`: shows "Night — no expected pattern" note
- Dashboard provider: night detection (after sunset / before sunrise)

### REMOVED
- (none)

---

<!--
CONVENTIONS:
- Newest sprint at top (reverse chronological)
- ADDED/MODIFIED/REMOVED sections per sprint
- Name specific entities, types, components, routes
- For MODIFIED: include "was X, now Y" where helpful
- Append during /project-update protocol
- This file is append-only (never rewrite old entries)
-->

[← Back to Root](../README.md)
