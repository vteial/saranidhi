# Saranidhi — Technical Design

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  Flutter Widgets + GoRouter (StatefulShellRoute)     │
│  4 bottom tabs: Home | Journal | Settings | Analytics│
├─────────────────────────────────────────────────────┤
│  STATE MANAGEMENT                                    │
│  Riverpod 3 (NotifierProvider, FutureProvider)       │
├─────────────────────────────────────────────────────┤
│  DOMAIN LAYER (Pure Dart — zero framework deps)      │
│  Astro Engine: Sunrise, Yama, Rahu, Hora, Pakshi,   │
│  Tattva, LunarPhase, Oracle                          │
│  Analytics: Streak, Trend, Weekly, Monthly, HoldTime │
│  Wisdom: RulesEngine, FallbackHandler, Libraries     │
├─────────────────────────────────────────────────────┤
│  DATA LAYER                                          │
│  Drift (SQLite/WebAssembly) — 4 tables               │
│  SharedPreferences — settings, cache, sync state     │
│  CloudKit (MethodChannel) — iCloud sync              │
├─────────────────────────────────────────────────────┤
│  PLATFORM LAYER                                      │
│  iOS: CloudKitPlugin.swift + entitlements            │
│  macOS: CloudKitPluginMacOS.swift + entitlements     │
│  Android: standard Flutter setup                     │
│  Web: Drift WASM + drift_worker.js                   │
└─────────────────────────────────────────────────────┘
```

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Local-first, zero-backend | Privacy guarantee — no user data on developer servers |
| Pure Dart domain layer | All Vedic calculations offline, testable, no platform deps |
| Drift (SQLite) over Hive/Isar | SQL power, WebAssembly support, typed queries, migrations |
| Riverpod over Bloc | Less boilerplate, better async handling, code generation |
| GoRouter StatefulShellRoute | Persistent tab state, deep linking ready |
| MethodChannel for CloudKit | No dependency on unmaintained third-party packages |
| Feature-first folder structure | Each feature is self-contained (domain/data/presentation/providers) |
| Two-column responsive (>=600px) | Desktop/iPad readability without separate layouts |

## Data Schema (Drift/SQLite)

### profiles
User profile, birth star, location, preferences (1 row per user).

### sara_kalai_journal
Breath journal entries — timestamp, expected/actual flow, alignment, nostril, durations, active yama/bird/state/element.

### breath_sessions
Detailed breath session recordings (cycles, inhale/hold/exhale lengths).

### bird_library
Panja Pakshi bird reference data (nakshatra groups).

## Sync Architecture

- **Strategy:** Record-level sync via CloudKit (not file-based backup)
- **Trigger:** On app open + on resume + on pull-to-refresh + after each write
- **Conflict resolution:** Primary device wins (configurable per device)
- **Container:** `iCloud.com.vteial.saranidhi` (private database)

## Notification Architecture

- **Package:** flutter_local_notifications (zonedSchedule)
- **Types:** Yama transitions (bird state), Rahu Kaal start/end, Morning summary
- **Content:** Personalized with birth bird name + state-specific guidance
- **Platform:** iOS, macOS, Android (web: no-op)

## Localization

- **Languages:** English (en), Tamil (ta)
- **Method:** ARB files → `flutter gen-l10n` (non-synthetic, committed to `lib/l10n/generated/`)
- **Wisdom:** Separate Tamil proverb library (52+ entries), locale-aware selection
