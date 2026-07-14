[← Back to Root](../README.md)

# Saranidhi — Master Project Plan & Architectural Blueprint

## 1. Intent & Objectives

Saranidhi (Tamil: "The Treasure House of Breath") is a spiritual life-guidance app built on the ancient sciences of **Siva Swarodaya (Sara Kalai)**, **Panja Pakshi Shastra**, and **Vedic time systems**. It enables users to:

- **Track and align** their breath flow (left/right/both nostril) with cosmic rhythms
- **Observe** planetary hours (Horas), elemental cycles (Tattvas), and bird states (Panja Pakshi)
- **Build consistency** through streaks, trends, and visual feedback
- **Receive personalized guidance** from on-device AI rooted in traditional wisdom
- **Maintain absolute privacy** — data stays on-device or in the user's own cloud account

The system enforces a strict **local-first, zero-backend architecture** — no developer-owned servers, no third-party data storage, no user data liability.

---

## 2. Core Feature Modules

### Module 1: The Astro-Logic Engine (Deterministic Vedic Math)

A pure Dart utility library performing all calculations on-device, independent of network state.

| Feature | Algorithm | Input |
|---------|-----------|-------|
| **Sunrise/Sunset** | Offline solar position calculation | User's `lat/lng` + date |
| **5 Yamas** | Divide daylight (sunrise→sunset) into 5 equal segments | Sunrise, Sunset |
| **Panja Pakshi States** | Map bird activity sequence by weekday + lunar phase | Weekday index (0–6), Waxing/Waning moon |
| **Rahu Kaal** | Divide daylight into 8 segments; apply day-index offset | Sun(8th), Mon(2nd), Tue(7th), Wed(5th), Thu(6th), Fri(4th), Sat(3rd) |
| **10% Floor Lockout** | If current time is in Rahu Kaal → Oracle Readiness = 10% | Current time, Rahu window |
| **Hora (Planetary Hour)** | Divide day/night into 12 segments each; assign planet by weekday lord sequence | Sunrise, Sunset, Weekday |
| **Tattva (Element Cycle)** | Map 5 elements to breath cycles within each Yama | Active Yama, breath count |

**Bird Activity States:** Ruling → Eating → Walking → Sleeping → Dying
**Five Birds:** Vulture (Hawk), Owl, Crow, Rooster (Cock), Peacock
**Five Elements:** Earth (Prithvi), Water (Apas), Fire (Tejas), Air (Vayu), Ether (Akasha)

---

### Module 2: Sara Kalai Breath Journal

The core interaction model — minimalist, habit-forming, spiritually meaningful.

| Feature | Description |
|---------|-------------|
| **Two-Click Flow Entry** | Instantly log dominant nostril: Solar (Right/Pingala), Lunar (Left/Ida), or Sushumna (Both) |
| **Real-Time Alignment Check** | Compare actual flow to expected cosmic pattern; display alignment status |
| **Breath Duration Timer** | Optional: measure inhale length, hold time, exhale length with precision timer |
| **Micro-Advice Display** | Show actionable guidance based on alignment state (e.g., "Lead with RIGHT foot today") |
| **Quick Sync Pacer** | Animated breathing guide to help shift dominant nostril if unaligned |
| **Nostril + Duration Logging** | Store left/right/both + durations for long-term pattern analysis |

---

### Module 3: Streak & Consistency Engine

Provides immediate psychological rewards through visual trend synthesis.

| Feature | Description |
|---------|-------------|
| **Current Streak** | Count consecutive days with `isAligned == true` entries |
| **7-Day Calendar Ribbon** | Compact row of last 7 days with checkmarks/status indicators |
| **30-Day Trend Weight** | Rolling alignment percentage as macro-health tracker |
| **Time-of-Day Heatmap** | Visualize when user typically logs (morning/afternoon/evening patterns) |
| **Yama-Level Accuracy** | Track which of the 5 daily Yamas user most consistently captures |

---

### Module 4: Smart Local Notifications (Mobile Only)

Proactive touchpoints via local OS scheduling — no server dependency.

| Feature | Description |
|---------|-------------|
| **Yama Transition Alerts** | Fire at exact boundary millisecond when bird state changes |
| **Dynamic Wisdom Payload** | Inject contextual advice from static local asset maps into notification |
| **Configurable Toggles** | User controls: notify on Ruling state, Eating state, or both |
| **Idempotent Queue Cleanup** | Purge stale scheduled IDs on every app launch/profile change |

---

### Module 5: AI Wisdom Engine (Ambient Intelligence)

Contextual guidance layer delivering personalized spiritual coaching.

| Platform | Approach | Fallback |
|----------|----------|----------|
| **Mobile** | On-device LLM with context payload (streak, accuracy, bird, rahu, tattva) | Static proverbs array |
| **Web** | Rules-based engine matching conditions to curated wisdom library | Static proverbs array |
| **Future** | Optional user-provided API key (Gemini/OpenAI) for enhanced insights | — |

**Context Payload:** `{ currentStreak, weeklyAccuracy, activeBird, activeState, isRahuKaal, activeTattva, activeHora }`

---

### Module 6: Cross-Device Sync (iCloud)

| Feature | Implementation |
|---------|---------------|
| **Sync trigger** | On app open (pull remote → merge → push local) |
| **Data synced** | Profile, journal entries, streak data, preferences |
| **Conflict resolution** | Primary device wins (configurable in Settings) |
| **Schema** | CloudKit record types matching Drift tables |
| **Platforms** | iOS, macOS (shared CloudKit container) |
| **Offline support** | Queue local changes, sync when connection available |

---

## 3. Data Architecture

### Local Database Schema (Drift/SQLite)

#### `profiles` Table
| Column | Type | Notes |
|--------|------|-------|
| id | TEXT (UUID) | Primary Key |
| display_name | TEXT | User's chosen name |
| birth_star_nakshatra | TEXT | Birth lunar mansion |
| birth_bird | TEXT | Calculated: Vulture/Owl/Crow/Rooster/Peacock |
| location_lat | REAL | For sunrise/sunset calculation |
| location_lng | REAL | For sunrise/sunset calculation |
| theme | TEXT | light/dark/emerald/gold |
| language | TEXT | en/ta |
| storage_mode | TEXT | local/icloud/gdrive |
| notify_ruling | INTEGER | 0 or 1 |
| notify_eating | INTEGER | 0 or 1 |
| last_ai_note | TEXT | Nullable |
| last_ai_note_date | TEXT | YYYY-MM-DD, Nullable |
| created_at | INTEGER | Unix epoch ms |
| updated_at | INTEGER | Unix epoch ms |

#### `sara_kalai_journal` Table
| Column | Type | Notes |
|--------|------|-------|
| id | TEXT (UUID) | Primary Key |
| timestamp | INTEGER | Unix epoch ms |
| expected_flow | TEXT | solar/lunar |
| actual_flow | TEXT | solar/lunar/sushumna |
| is_aligned | INTEGER | 1 if expected == actual |
| nostril | TEXT | left/right/both |
| inhale_duration_ms | INTEGER | Nullable |
| hold_duration_ms | INTEGER | Nullable |
| exhale_duration_ms | INTEGER | Nullable |
| active_yama | TEXT | Nullable (yama1–yama5) |
| active_bird | TEXT | Nullable (vulture/owl/crow/rooster/peacock) |
| active_bird_state | TEXT | Nullable (ruling/eating/walking/sleeping/dying) |
| active_element | TEXT | Nullable (earth/water/fire/air/ether) |
| notes | TEXT | Nullable |

#### `breath_sessions` Table
| Column | Type | Notes |
|--------|------|-------|
| id | TEXT (UUID) | Primary Key |
| timestamp | INTEGER | Unix epoch ms |
| total_duration_ms | INTEGER | Total session length |
| nostril | TEXT | left/right/both |
| inhale_length_ms | INTEGER | Per-cycle inhale |
| hold_after_inhale_ms | INTEGER | Per-cycle hold |
| exhale_length_ms | INTEGER | Per-cycle exhale |
| hold_after_exhale_ms | INTEGER | Per-cycle hold |
| completed_cycles | INTEGER | Number of rounds |
| mood | TEXT | Nullable (before/after label) |
| consciousness_rating | INTEGER | Nullable (1–10) |
| notes | TEXT | Nullable |

#### `bird_library` Table
| Column | Type | Notes |
|--------|------|-------|
| id | TEXT | Composite key: bird_name |
| bird_name | TEXT | vulture/owl/crow/rooster/peacock |
| nakshatra_group | TEXT | Comma-separated nakshatra names |
| favorited | INTEGER | 0 or 1 |

---

## 4. Interface Blueprint (iPhone SE Optimized)

| Section | Component | Viewport Allocation | Purpose |
|---------|-----------|-------------------|---------|
| **Top Header** | Mini-Oracle Bar | ~15% | Active bird icon, readiness bar, Rahu indicator |
| **Primary Row** | Streak & Calendar | ~20% | Active streak flame, 7-day checkmark ribbon |
| **Mid-Section** | AI Wisdom Card | ~25% | Coaching insight with skeleton loading |
| **Bottom Body** | Action Grid | Remaining | Breath logger, Hora strength, Tattva display |

---

## 5. Platform & Deployment Architecture

### Storage Mode Per Platform

| Platform | Default Mode | Options | Auth Required |
|----------|-------------|---------|---------------|
| iOS | Local | Local / iCloud | Apple Sign-In (for iCloud) |
| Android | Local | Local / Google Drive | Google Sign-In (for Drive) |
| Web | Google Drive | Google Drive only | Google Sign-In (mandatory) |

### Cloud Backup Strategy

- **What's backed up:** Encrypted SQLite database export (single file)
- **Where:** iOS → iCloud Documents container; Android/Web → Google Drive App Data folder
- **When:** User-initiated + optional auto-backup (daily/weekly)
- **Restore:** On new device install, sign in → detect backup → offer restore

### Deployment Targets

| Environment | Branch | Hosting | Purpose |
|-------------|--------|---------|---------|
| Production (Web) | `main` | Vercel | Live web app (saranidhi.vercel.app) |
| Preview | PR branches | Vercel | PR previews, QA testing |
| Production (iOS) | `main` | App Store | Live iOS distribution |
| Production (Android) | `main` | Play Store | Live Android distribution |
| Production (macOS) | `main` | Mac App Store | Live macOS distribution |

---

## 6a. Navigation Architecture (as of Sprint 20)

### Bottom Navigation (3 tabs)
| Tab | Route | Screen |
|-----|-------|--------|
| Home | `/` | HomeScreen (Today/Explore sub-tabs) |
| Journal | `/journal` | JournalScreen |
| Analytics | `/analytics` | AnalyticsScreen |

### Top-Right Actions
| Icon | Route | Access |
|------|-------|--------|
| Gear (⚙️) | `/settings` | Pushed route via `context.push` — full-screen with back button |

### Home Sub-Tabs (TabBarView)
| Tab | Content | Purpose |
|-----|---------|---------|
| Today (default) | Bird, Rahu, Schedule, Nostril, Wisdom, Hold+Streak, Ribbon | Focused live data |
| Explore | Date Selector, Calendar, Historical Entries, Best Times, Trend | Date navigation + history |

---

## 6b. Data Export/Import Architecture (Sprint 20)

### Export Format (JSON)
```json
{
  "version": 1,
  "exportedAt": "2026-07-04T12:00:00.000Z",
  "profiles": [...],
  "journal": [...],
  "sessions": [...],
  "birds": [...],
  "preferences": {
    "theme_accent": "defaultPurple",
    "theme_brightness": "system",
    "app_locale": "en",
    "storage_mode": "local",
    "notify_ruling": true,
    ...
  }
}
```

### Import Flow
1. File picker (`.json` only)
2. Validation (`DatabaseExporter.validateExportData`)
3. Summary dialog (record counts + export date)
4. Destructive import (clear all → insert rows → restore preferences)
5. Provider invalidation (6 providers cascaded)

### Dependencies
| Package | Purpose |
|---------|---------|
| `share_plus` | Share sheet / download on export |
| `file_picker` | JSON file selection on import |

---

## 6c. Nakshatra Calculation Architecture (Sprint 21)

### DOB-Based Birth Bird Derivation

The classic Sara Kalai approach: birth bird is **fixed from birth** (natal chart), while daily rhythm (yamas, sunrise/sunset) follows **current geographical position**.

#### Calculation Pipeline
```
DOB (date + time) → IST assumed (UTC+5:30)
    → Julian Day Number
    → Moon Longitude (Jean Meeus ELP 2000/82, pure Dart)
    → Lahiri Ayanamsa correction (sidereal longitude)
    → Nakshatra index (sidereal_longitude ÷ 13.33°)
    → Birth Bird (nakshatra → bird mapping)
```

#### Key Design Decisions
| Decision | Rationale |
|----------|-----------|
| IST assumption for all births | Moon moves ~0.5°/hour; India's ±30min timezone span is negligible vs 13.33° nakshatra width |
| No separate birth place field | Removes UX friction; accuracy impact < 0.25° for anywhere in India |
| ~0.5° tolerance acceptable | Boundary warning shown when Moon is within 1° of nakshatra edge |
| Pure Dart (no ephemeris files) | Zero network dependency, works offline, small binary size |

#### Onboarding Dual-Path UI
```
Step 1: "Find Your Bird"
├── Path A: "I know my star" → Nakshatra list (27 items) → Bird
└── Path B: "Calculate from DOB" → Date + Time pickers → Calculate → Bird
```

#### OnboardingGuard Navigator Pattern
`MaterialApp.builder` renders widgets **above** the GoRouter Navigator. The `OnboardingGuard` wraps `OnboardingScreen` in its own `Navigator` widget so that `showDatePicker`/`showTimePicker` have a valid overlay to push dialog routes onto (required for Flutter Web).

### Profiles Table — Sprint 21 Columns

| Column | Type | Notes |
|--------|------|-------|
| birth_date_epoch | INTEGER | DOB as Unix epoch ms (nullable) |
| birth_time | TEXT | "HH:mm" format (nullable) |
| birth_place_name | TEXT | City name (nullable — not used in current flow) |
| birth_place_lat | REAL | Birth latitude (nullable — not used in current flow) |
| birth_place_lng | REAL | Birth longitude (nullable — not used in current flow) |

---

## 6d. UX Polish Infrastructure (Sprint 24)

### Reusable Widget Library (`lib/core/widgets/`)

| Widget | Purpose | Pattern |
|--------|---------|---------|
| `EmptyStateWidget` | Configurable empty state (icon + title + subtitle + optional action) | Used by Journal, Analytics, Explore |
| `ShimmerLoading` | Animated gradient skeleton cards mimicking dashboard layout | Replaces `CircularProgressIndicator` on loading |
| `ErrorBoundary` | Stateful widget catching errors in child subtree | Wraps sections for graceful degradation |
| `ErrorFallback` | Standalone error display (cloud-off icon, message, retry) | Used in AsyncValue.when() error handlers |

### Loading State Strategy

| State | Previous | Sprint 24 |
|-------|----------|-----------|
| Dashboard loading | `CircularProgressIndicator` | `ShimmerLoading` (animated skeleton matching card layout) |
| Analytics loading | `SizedBox.shrink()` (invisible) | Shows loading shimmer, then cards appear |
| Error states | Raw error text + retry button | `ErrorFallback` with friendly message + retry |

### Empty State Design Principles

1. **Motivational tone** — guide users toward first action, never shame for empty data
2. **Visual hierarchy** — prominent icon, clear title, supportive subtitle
3. **Actionable hints** — point users to what to do next (e.g., arrow toward entry widget)
4. **Consistent styling** — all empty states use theme colors at reduced opacity
5. **Responsive** — adapts to narrow/wide layouts

### Reactive Analytics Fix

Analytics `FutureProvider`s now include `await ref.watch(journalEntriesProvider.future)` as a reactive dependency, ensuring they auto-refresh when journal entries change (add/delete). This eliminates the stale cache problem where analytics showed "empty" state until page reload.

---

## 6e. Performance & Accessibility Infrastructure (Sprint 25)

### Timezone Derivation

All hardcoded `const utcOffset = 5.5` removed. New `TimezoneUtils.offsetForLocation(lat, lng)` derives UTC offset:
- **Indian bounding box** (lat 6°–36°, lng 68°–98°) → always returns IST (5.5)
- **Other locations** → `longitude / 15` rounded to nearest 0.5

`ProfileLocationProvider` (FutureProvider) caches the profile's lat/lng for synchronous access from the breath alignment checker.

### Safari/Cross-Browser Compatibility

| Issue | Root Cause | Fix |
|-------|-----------|-----|
| White page on Safari | `canvasKitVariant: "chromium"` forced Chrome-only renderer | Removed — Flutter auto-detects |
| WASM init failure on Safari | COOP/COEP headers broke SharedArrayBuffer | Removed headers; Drift uses fallback worker mode |

**Rule:** Never force browser-specific rendering in `flutter_bootstrap.js`. Let Flutter auto-detect.

### Keyboard & Accessibility

- `CallbackShortcuts` + `Focus(autofocus: true)` is the correct Flutter pattern for web keyboard shortcuts (not `KeyboardListener` with inline `FocusNode`)
- All interactive widgets should have `Semantics(button: true, label, hint/selected)` for screen reader support
- `HapticFeedback.lightImpact()` / `.mediumImpact()` from `flutter/services.dart` is automatically no-op on web

### Provider Invalidation Pattern

When profile data changes (location, birth star), always invalidate dependent providers:
```dart
ref
  ..invalidate(profileLocationProvider)
  ..invalidate(dashboardDataProvider);
```

---

## 6f. Layer 1 Gap Fixes — Diagnostic Foundation (Sprint 27)

### ActionWindow Architecture (Seeds Layer 2)

The `ActionWindow` enum provides the bridge between raw Pakshi bird states and lifestyle recommendations:

```
PakshiState → ActionWindow.fromBirdState() → ActionWindow (artha/kriya/yoga)
```

| Bird State | Action Window | Sushumna Alignment |
|-----------|---------------|-------------------|
| Ruling | Artha (Material) | Blocked (0.0) |
| Walking | Artha (Material) | Blocked (0.0) |
| Eating | Kriya (Nourishment) | Blocked (0.0) |
| Sleeping | Yoga (Spiritual) | Aligned (1.0) |
| Dying | Yoga (Spiritual) | Aligned (1.0) |

This mapping is the **core of Layer 2** (Action Windows Engine) — when Layer 2 is built, the UI layer just renders the already-computed window type.

### Hora + Tattva Integration

`DashboardData` now includes `activeHora` (HoraResult) and `activeTattva` (TattvaResult). These are computed from existing calculators (`HoraCalculator.activeHora()`, `TattvaCalculator.activeTattva()`) only when viewing today. The BirthBirdCard shows them as a subtle sub-row.

### Guided Diagnostic Test

The `GuidedNostrilTest` widget provides a structured 3-step verification flow:
1. Exhale test (gross detection)
2. Isolation test (fine confirmation)
3. Auto-populate result

This replaces blind manual selection for users unsure of their dominant nostril.

---

## 6g. Prasanam Oracle UI Architecture (Sprint 32)

### Navigation

Prasanam Oracle is the **4th bottom nav tab** (Home | Journal | Oracle | Analytics), accessible from any screen. The FAB approach was replaced with a dedicated tab for discoverability and daily-use pattern.

### Data Model

New Drift table `PrasanamHistory` (schema v4):
- `id`, `timestamp`, `category`, `queryText`, `score`, `band`, `guidanceEn`, `guidanceTa`, `isFloorLocked`, `swara`, `birdState`, `actionWindow`, `outcomeNotes`, `outcomeTimestamp`

### Oracle Flow

```
User opens Oracle tab
    → Window status banner (favorable/void-locked)
    → Category selector (Artha/Kriya/Yoga) + contextual description
    → Free-text intention field (optional)
    → "Ask the Oracle" button
    → 30-min validation gate:
        ├── Recent journal entry (≤30min) → use recorded swara
        └── Stale/none → trigger GuidedNostrilTest bottom sheet
    → OracleCompositeEngine.evaluate() → PrasanamResult
    → Result card (score gauge + band + guidance)
    → "Save to History" button (user-initiated, not auto-save)
```

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| User-initiated save (Option C) | Respects mental/silent Prasanam tradition — casual queries leave no trace |
| History co-located on Oracle screen | Same pattern as Journal — feature owns its own history |
| Window status banner (not blocking) | Informational friction — user sees but isn't prevented from querying |
| Swipe-to-delete history | Clean up old readings (same UX as journal delete) |
| Category descriptions | First-time users need context for Artha/Kriya/Yoga meaning |

### Future: Sacred Consultation UX (Post v1.4)

Planned intentional friction to prevent casual/playful misuse:
- Cooldown period (2-4h between queries)
- Pre-query breath ritual (3-breath centering)
- Intention anchor hold duration (10-15s meditation)
- Daily query limit (max 2-3/day)
- Deity/mantra invocation prompt

---

### On Every PR to `main`
```
dart analyze              → Must pass (zero warnings)
flutter test              → Must pass (all green)
flutter build web         → Must compile successfully
```

### On Merge to `main`
```
flutter build web --release    → Vercel auto-deploys to saranidhi.vercel.app
flutter build ios --release    → Archive for App Store (manual, Sprint X)
flutter build apk --release    → Upload to Play Store (manual, Sprint X)
```

### Tooling
- **CI Runner:** GitHub Actions
- **Pre-commit:** lefthook (format + analyze)
- **Linting:** very_good_analysis
- **Code Gen:** build_runner (Freezed, Drift, Riverpod)
- **Localization:** `flutter gen-l10n` with `synthetic-package: false`; generated Dart committed to `lib/l10n/generated/`

---

## 7. Monetization

| Model | Description |
|-------|-------------|
| **Freemium** | Core breath logging + alignment free; premium unlocks AI wisdom, advanced analytics, themes |
| **One-Time Unlock** | Single IAP to unlock all premium features permanently |
| **Platform** | RevenueCat for cross-platform purchase management |
| **Cost to Developer** | $0 ongoing (no servers, no cloud DB) |

---

## 8. Security & Privacy

| Principle | Implementation |
|-----------|---------------|
| No server-side data | All data in local SQLite or user's own cloud |
| No telemetry | Zero third-party analytics that leak user data |
| Encrypted backup | Database encrypted before upload to iCloud/Drive |
| Minimal permissions | Location (for sunrise calc), Notifications (optional) |
| No account required | App works fully without sign-in (local mode) |
| GDPR compliant | No user data on developer infrastructure |

---

[← Back to Root](../README.md)
