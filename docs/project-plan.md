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
| Staging | `main` | Vercel | PR previews, QA testing |
| Production (Web) | `prod` | Cloudflare Pages | Live web app |
| Production (iOS) | `prod` | App Store | Live iOS distribution |
| Production (Android) | `prod` | Play Store | Live Android distribution |

---

## 6. CI/CD Pipeline

### On Every PR to `main`
```
dart analyze              → Must pass (zero warnings)
flutter test              → Must pass (all green)
flutter build web         → Must compile successfully
```

### On Merge to `prod`
```
flutter build web --release    → Deploy to Cloudflare Pages
flutter build ios --release    → Archive for App Store (manual)
flutter build apk --release    → Upload to Play Store (manual)
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
