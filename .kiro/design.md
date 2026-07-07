# Saranidhi — Technical Design

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  Flutter Widgets + GoRouter (StatefulShellRoute)     │
│  3 tabs: Home | Journal | Analytics                  │
│  Settings via gear icon (AppBar action)              │
│  Prasanam FAB on Today tab (v2.0)                    │
├─────────────────────────────────────────────────────┤
│  STATE MANAGEMENT                                    │
│  Riverpod 3 (NotifierProvider, FutureProvider)       │
├─────────────────────────────────────────────────────┤
│  DOMAIN LAYER (Pure Dart — zero framework deps)      │
│  Astro Engine: Sunrise, Yama, Rahu, Hora, Pakshi,   │
│  Tattva, LunarPhase, Oracle, ActionWindow            │
│  Action Windows: ActionWindowEngine, Schedule (v1.3) │
│  Prasanam: OracleCalculator, 3 Vectors (v2.0)       │
│  Analytics: Streak, Trend, Weekly, Monthly, HoldTime │
│  Wisdom: RulesEngine, FallbackHandler, Libraries     │
├─────────────────────────────────────────────────────┤
│  DATA LAYER                                          │
│  Drift (SQLite/WebAssembly) — 5 tables               │
│  (+PrasanamHistory in v2.0)                          │
│  SharedPreferences — settings, cache, sync state     │
│  CloudKit (MethodChannel) — iCloud sync              │
├─────────────────────────────────────────────────────┤
│  PLATFORM LAYER                                      │
│  iOS: CloudKitPlugin.swift + entitlements            │
│  macOS: CloudKitPluginMacOS.swift + entitlements     │
│  Android: standard Flutter setup                     │
│  Web: Drift WASM + drift_worker.js (no COOP/COEP)   │
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



## v1.3.0 — Layer 2: Action Windows Architecture

### ActionWindowEngine

Computes a full 24h schedule of action windows from the diagnostic data:

```
Input: sunrise, sunset, nextSunrise, weekday, lunarPhase, birthBird, rahuKaal
Output: ActionWindowSchedule (list of timed windows with type + blocked status)
```

**Rules:**
1. For each yama (day + night), derive `ActionWindow` from birth bird's state via `ActionWindow.fromBirdState()`
2. If a window's time range overlaps Rahu Kaal → mark as "Blocked" (10% floor lockout)
3. Merge adjacent windows of same type for cleaner timeline display

### UI: Progressive Disclosure

1. **24h Action Bar** — thin color-coded timeline at top (always visible)
2. **Current Mode Focus Card** — lifestyle text, not technical (largest card on Today)
3. **Expansion Sheet** — tap Focus Card → reveals raw Pakshi + Hora + Tattva

## v2.0.0 — Layer 3: Prasanam Oracle Architecture

### Calculation Engine (3 Vectors)

**Oracle Score = V1 × 0.35 + V2 × 0.40 + V3 × 0.25** (weighted compound)

| Vector | Input | Scoring Logic |
|--------|-------|---------------|
| V1: Saram × Tattva | Current nostril + active element | Solar+Fire/Air=1.0, Solar+Earth/Water=0.3, Lunar inverse, Sushumna+Ether=1.0 |
| V2: Saram × Bird State | Current nostril + bird favorability | Ruling+Solar=1.0, Sleeping/Dying=floor(0.1) |
| V3: Query × Hora | Question category + planetary hour | Commerce+Jupiter/Venus=1.0, Conflict+Mars=0.8, mismatch=0.3 |

**Floor Lockout:** If `isRahuKaal && birdState == dying` → score capped at 0.1, output = "Hard No"

### Tiered Output

| Score | Tier | Guidance |
|-------|------|----------|
| ≥ 0.80 | Strong Yes | Proceed with full confidence. Cosmic alignment supports this action. |
| ≥ 0.60 | Favorable | Conditions are good. Proceed with normal caution. |
| ≥ 0.40 | Caution | Mixed signals. Consider waiting for a better window. |
| ≥ 0.20 | Delay | Significant friction ahead. Postpone if possible. |
| < 0.20 | Hard No | Do not proceed. Active cosmic resistance. Wait. |

### Data: PrasanamHistory Table

Stores the full diagnostic snapshot at time of asking + oracle output + optional post-event notes for retrospective audit.

### UX Flow

```
FAB tap → Validation (breath <30 min?) → Intention anchor (3s) → Type question → Calculate → Result card
```
