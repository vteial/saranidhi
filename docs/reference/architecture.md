[← Back to Root](../../README.md)

# Saranidhi — Architecture Reference

> **Reviewed:** v1.8.1-web · **Next review:** every release (or when infra/schema/patterns change).

*The technical design of Saranidhi: how the product is built. For what it does
and why, see [`docs/product/product-scope.md`](../product/product-scope.md).*

*CI, coverage gates, and the test tiers are documented in
[`docs/process/dev-workflow.md`](../process/dev-workflow.md) — this reference does
not duplicate gate numbers.*

---

## 1. Astro-Logic Engine (Deterministic Vedic Math)

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

### Nakshatra Calculation Pipeline

Birth bird is **fixed from birth** (natal chart) and permanent, while the daily rhythm (yamas, sunrise/sunset) follows the user's **current geographical position**. The two live in separate tables so daily location changes never alter the birth bird.

```
DOB (date + time) → IST assumed (UTC+5:30)
    → Julian Day Number
    → Moon Longitude (Jean Meeus ELP 2000/82, pure Dart)
    → Lahiri Ayanamsa correction (sidereal longitude)
    → Nakshatra index (sidereal_longitude ÷ 13.33°)
    → Birth Bird (nakshatra → bird mapping)
```

| Decision | Rationale |
|----------|-----------|
| IST assumption for all births | Moon moves ~0.5°/hour; India's ±30min timezone span is negligible vs 13.33° nakshatra width |
| No separate birth place field | Removes UX friction; accuracy impact < 0.25° for anywhere in India |
| ~0.5° tolerance acceptable | Boundary warning shown when Moon is within 1° of nakshatra edge |
| Pure Dart (no ephemeris files) | Zero network dependency, works offline, small binary size |

The onboarding offers dual paths — "I know my star" (nakshatra list → bird) and "Calculate from DOB" (date + time pickers → bird) — plus a name-based path.

---

## 2. Data Architecture

### Local Database Schema (Drift/SQLite)

**Current schema version: v5.** The `somatic_intervention_logs` table was added
in Sprint 35 (confirmed in [`CHANGELOG.md`](../../CHANGELOG.md)); the v4→v5
migration is idempotent and safe for both fresh installs and upgrades.

#### `profiles` Table
| Column | Type | Notes |
|--------|------|-------|
| id | TEXT (UUID) | Primary Key |
| display_name | TEXT | User's chosen name |
| birth_star_nakshatra | TEXT | Birth lunar mansion |
| birth_bird | TEXT | Calculated: Vulture/Owl/Crow/Rooster/Peacock (permanent) |
| location_lat | REAL | For sunrise/sunset calculation |
| location_lng | REAL | For sunrise/sunset calculation |
| theme | TEXT | light/dark/emerald/gold |
| language | TEXT | en/ta |
| storage_mode | TEXT | local/icloud/gdrive |
| notify_ruling | INTEGER | 0 or 1 |
| notify_eating | INTEGER | 0 or 1 |
| last_ai_note | TEXT | Nullable |
| last_ai_note_date | TEXT | YYYY-MM-DD, Nullable |
| birth_date_epoch | INTEGER | DOB as Unix epoch ms (nullable) |
| birth_time | TEXT | "HH:mm" format (nullable) |
| birth_place_name | TEXT | City name (nullable — not used in current flow) |
| birth_place_lat | REAL | Birth latitude (nullable — not used in current flow) |
| birth_place_lng | REAL | Birth longitude (nullable — not used in current flow) |
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

#### `prasanam_history` Table (schema v4)
Columns: `id`, `timestamp`, `category`, `queryText`, `score`, `band`, `guidanceEn`, `guidanceTa`, `isFloorLocked`, `swara`, `birdState`, `actionWindow`, `outcomeNotes`, `outcomeTimestamp`. The feature owns its own history, co-located on the Oracle screen (same pattern as the Journal).

#### `somatic_intervention_logs` Table (schema v5)
Records completed Clear Breath Channel sessions (protocol type, timing, and guided-nostril-test verification result). Added Sprint 35.

---

## 3. Platform & Deployment Architecture

### Storage Mode Per Platform

Saranidhi is **local-first**: every platform defaults to on-device storage and works fully without sign-in. Cloud is opt-in and always the user's own account.

| Platform | Default Mode | Options | Auth Required |
|----------|-------------|---------|---------------|
| iOS | Local | Local / iCloud | Apple Sign-In (only if the user opts into iCloud) |
| Android | Local | Local / Google Drive | Google Sign-In (only if the user opts into Drive) |
| Web | Local | Local / Google Drive | Google Sign-In (only if the user opts into Drive) |

> Web has **no mandatory sign-in**. The default is local storage in the browser; Google Drive is an optional backup the user can enable.

### Cloud Backup Strategy

- **What's backed up:** Encrypted SQLite database export (single file)
- **Where:** iOS → iCloud Documents container; Android/Web → Google Drive App Data folder (when the user opts in)
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

Tooling: GitHub Actions CI, lefthook pre-commit (format + analyze), very_good_analysis linting, build_runner code generation (Freezed, Drift, Riverpod), and `flutter gen-l10n` with `synthetic-package: false` (generated Dart committed to `lib/l10n/generated/`). CI tiers, coverage gate, and integration-test gating are defined in [`docs/process/dev-workflow.md`](../process/dev-workflow.md).

---

## 4. Security & Privacy

| Principle | Implementation |
|-----------|---------------|
| No server-side data | All data in local SQLite or the user's own cloud |
| No telemetry | Zero third-party analytics that leak user data |
| Encrypted backup | Database encrypted before upload to iCloud/Drive |
| Minimal permissions | Location (for sunrise calc), Notifications (optional) |
| No account required | App works fully without sign-in (local default on every platform) |
| GDPR compliant | No user data on developer infrastructure |

---

## 5. Architectural Patterns

Durable patterns that any future work should preserve.

### Navigation Architecture

Bottom navigation is **4 tabs**: **Home | Journal | Oracle | Analytics**. Prasanam Oracle is a dedicated tab (a FAB approach was considered and replaced) for discoverability and daily-use rhythm. Settings is a pushed full-screen route (`context.push`) with a back button, reached from a top-right gear action. The Home tab hosts Today (focused live data) and Explore (date navigation + history) sub-tabs via a `TabBarView`.

### OnboardingGuard / Navigator Overlay Pattern

`MaterialApp.builder` renders widgets **above** the GoRouter Navigator. `OnboardingGuard` wraps `OnboardingScreen` in its own `Navigator` widget so that `showDatePicker`/`showTimePicker` have a valid overlay to push dialog routes onto (required for Flutter Web).

### ActionWindow → Bird-State Mapping

The `ActionWindow` enum bridges raw Pakshi bird states and lifestyle recommendations via `ActionWindow.fromBirdState()`:

| Bird State | Action Window | Sushumna Alignment |
|-----------|---------------|-------------------|
| Ruling | Artha (Material) | Blocked (0.0) |
| Walking | Artha (Material) | Blocked (0.0) |
| Eating | Kriya (Nourishment) | Blocked (0.0) |
| Sleeping | Yoga (Spiritual) | Aligned (1.0) |
| Dying | Yoga (Spiritual) | Aligned (1.0) |

The UI layer renders the already-computed window type rather than recomputing it.

### Provider-Invalidation Pattern

When profile data changes (location, birth star), always invalidate dependent providers so downstream data recomputes:
```dart
ref
  ..invalidate(profileLocationProvider)
  ..invalidate(dashboardDataProvider);
```
Destructive data import cascades invalidation across the affected providers (profile, journal, sessions, birds, and dependent dashboards).

### Reactive-Analytics Dependency Pattern

Analytics `FutureProvider`s include `await ref.watch(journalEntriesProvider.future)` as a reactive dependency so they auto-refresh when journal entries change (add/delete). This eliminates the stale-cache problem where analytics showed an empty state until page reload.

### Timezone Derivation

There are no hardcoded UTC offsets. `TimezoneUtils.offsetForLocation(lat, lng)` derives the offset:
- **Indian bounding box** (lat 6°–36°, lng 68°–98°) → always IST (5.5)
- **Other locations** → `longitude / 15` rounded to the nearest 0.5

`ProfileLocationProvider` caches the profile's lat/lng for synchronous access from the breath alignment checker.

### Browser-Rendering Rule (Safari / CanvasKit)

**Never force browser-specific rendering** in `flutter_bootstrap.js`; let Flutter auto-detect the renderer. Forcing `canvasKitVariant: "chromium"` caused white pages on Safari, and COOP/COEP headers broke SharedArrayBuffer / WASM init — both were removed, with Drift falling back to worker mode where needed.

### Data Export/Import (JSON) Architecture

Full data portability is a single JSON document (profiles, journal, sessions, birds, preferences) with a top-level `version` field:

```json
{
  "version": 1,
  "exportedAt": "2026-07-04T12:00:00.000Z",
  "profiles": [...],
  "journal": [...],
  "sessions": [...],
  "birds": [...],
  "preferences": { "theme_accent": "defaultPurple", "app_locale": "en", "storage_mode": "local", "notify_ruling": true }
}
```

Import flow: file picker (`.json`) → `DatabaseExporter.validateExportData` → summary dialog (record counts + export date) → destructive import (clear all → insert rows → restore preferences) → provider invalidation. `share_plus` handles export/download; `file_picker` handles import selection.

### Prasanam Oracle — Consultation Model

The Oracle tab runs a 30-minute swara-validation gate: a recent journal entry (≤30 min) supplies the recorded swara, otherwise a `GuidedNostrilTest` bottom sheet is triggered. `OracleCompositeEngine.evaluate()` returns a `PrasanamResult` (score gauge + band + guidance). Saves are **user-initiated**, respecting the silent/mental Prasanam tradition; a window-status banner is informational, not blocking. Consultation-ritual friction (cooldown, breath ritual, intention anchor, daily limits) is tracked as product work in the [Prasanam Oracle UX epic](../process/sprint-backlog.md#prasanam-oracle-ux), not specified here.

---

[← Back to Root](../../README.md)
