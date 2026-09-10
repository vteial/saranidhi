# Saranidhi — Technical Design

> Reflects the codebase as of **v1.6.0** (Sprint 36). Kept in sync during
> `/sprint-update`.

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  Flutter Widgets + GoRouter (StatefulShellRoute)     │
│  4 tabs: Home | Journal | Oracle (Prasanam) | Analytics │
│  Settings + Onboarding as top-level routes           │
│  Settings via gear icon (AppBar action)              │
├─────────────────────────────────────────────────────┤
│  STATE MANAGEMENT                                    │
│  Riverpod 3 (NotifierProvider, FutureProvider)       │
├─────────────────────────────────────────────────────┤
│  DOMAIN LAYER (Pure Dart — zero framework deps)      │
│  Astro Engine: Sunrise, Yama, Rahu, Emakandam,      │
│  Kuligai, Hora, Pakshi(+Attributes), Tattva,        │
│  LunarPhase, Moon longitude (Meeus), Lahiri ayanamsa,│
│  Nakshatra, NostrilPattern, Tara, Oracle             │
│  Action Windows: ActionWindowsEngine, Segments (v1.3)│
│  Prasanam: OracleEngine, 3 Vectors (v2.0)           │
│  Somatic: guided nostril-shift protocols (Sprint 35) │
│  Analytics: Streak, Trend, Weekly, Monthly, HoldTime │
│  Wisdom: RulesEngine, FallbackHandler, Libraries     │
├─────────────────────────────────────────────────────┤
│  DATA LAYER                                          │
│  Drift (SQLite/WebAssembly) — 6 tables, schemaVersion 5 │
│  (Profiles, SaraKalaiJournal, BreathSessions,       │
│   PrasanamHistory, SomaticInterventionLogs,          │
│   BirdLibrary) + migration_helpers                   │
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

## Data Schema (Drift/SQLite) — 6 tables, `schemaVersion = 5`

### profiles
User profile, birth star, location, preferences (1 row per user).

### sara_kalai_journal
Breath journal entries — timestamp, expected/actual flow, alignment, nostril, durations, active yama/bird/state/element, `isPinned`.

### breath_sessions
Detailed breath session recordings (cycles, inhale/hold/exhale lengths).

### prasanam_history (v2.0 — Layer 3)
Oracle query snapshots — category, query text, score/band, EN+TA guidance, floor-lock flag, diagnostic snapshot (swara, birdState, actionWindow) + optional post-event outcome notes/timestamp.

### somatic_intervention_logs (Sprint 35)
Guided nostril-shift session logs — `protocolType` (postureShift / axillaryPressure), `targetFlow`, `initialFlow`, `resolvedFlow` (post-verification, nullable), `isSuccess`, `durationSeconds`.

### bird_library
Panja Pakshi bird reference data (nakshatra groups).

### Migrations
`database/migration_helpers.dart` provides tested column-existence utilities. Never `ALTER TABLE`/`addColumn` without checking existence first (Sprint 36 — replaces the ad-hoc `sqlite_master` / try-catch pattern that caused historical failures).

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



## Sprint 35 — Somatic Interventions Architecture

When the diagnostic layer flags the user's breath channel (nostril dominance) as **unaligned** with the expected cosmic pattern, the app offers a guided, time-bound **intervention** to actively shift the flow — moving beyond passive observation to active correction.

### Engine / Flow

```
Detect unaligned flow → offer intervention → user selects protocol
  → SomaticTimerRoom (guided, time-bound) → post-session GuidedNostrilTest
  → log resolvedFlow + isSuccess to SomaticInterventionLogs
```

### Protocols

| Protocol (`protocolType`) | Technique |
|---------------------------|-----------|
| `postureShift` | Lie/lean on the side opposite the desired nostril (cross-lateral pressure) |
| `axillaryPressure` | Apply pressure under the armpit opposite the desired nostril |

Supporting UI: `SomaticTimerRoom` (guided countdown), `CrossLateralInstructionCard`, `InterventionSelectorSheet`, `SamaVrittiPacer` (equal-ratio breath pacer). Each session records target vs. initial vs. resolved flow and whether the shift succeeded, feeding future analytics on intervention efficacy.

> Note: Somatic interventions are an **active** complement to the passive diagnostic layer. The birth bird and daily rhythm are never altered — only the user's current nostril flow is coached toward alignment.
