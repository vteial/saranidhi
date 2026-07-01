---
inclusion: auto
---

# Saranidhi — Unified Application Specification

## 1. System Objective & Guardrails

* **Core Purpose:** A spiritual breath-tracking and life-guidance app rooted in Siva Swarodaya (Sara Kalai) science, Panja Pakshi Shastra, and Vedic time systems. Helps users align their daily breath patterns with cosmic rhythms for conscious living.
* **Architecture Pattern:** Local-first, zero-backend. All data resides on-device (SQLite via Drift) with optional encrypted backup to user's own cloud (iCloud on iOS, Google Drive on Android/Web).
* **UI Philosophy:** Mobile-first, minimalist, spiritually evocative. Material 3 design language with custom theming (Light, Dark, Emerald, Gold). iPhone SE viewport as minimum target.
* **Strict Exclusions:** No server-side database, no Supabase, no Firebase Firestore, no third-party analytics that leak user data, no social features, no user-to-user interaction.
* **Privacy Guarantee:** User data never touches developer-owned infrastructure. Cloud backup is to user's OWN Apple/Google account only.
* **Type-Safety:** Strict Dart analysis. Zero usage of `dynamic` except where framework-mandated. Freezed models for all entities.

## 2. Technical Stack Definition

| Layer | Choice |
|-------|--------|
| **Framework** | Flutter (iOS, Android, Web) |
| **State Management** | Riverpod 3 (@riverpod code generation) |
| **Routing** | GoRouter (StatefulShellRoute, auth redirects, deep linking) |
| **Local Database** | Drift (SQLite) — works on mobile + web (sql.js/IndexedDB) |
| **Models** | Freezed + json_serializable |
| **Cloud Backup (iOS)** | iCloud via `icloud_storage` package |
| **Cloud Backup (Android/Web)** | Google Drive App Data folder via `googleapis` |
| **Auth (iOS)** | Apple Sign-In (for iCloud access only) |
| **Auth (Android/Web)** | Google Sign-In (for Google Drive access only) |
| **Local AI** | On-device LLM (mobile), rules-based engine (web) |
| **Notifications** | flutter_local_notifications (mobile only) |
| **Theming** | Material 3 (4 variants: Light, Dark, Emerald, Gold) |
| **Localization** | ARB files (EN, TA — 130+ keys) + `flutter gen-l10n` (non-synthetic, committed output to `lib/l10n/generated/`) |
| **Linting** | very_good_analysis |
| **CI/CD** | GitHub Actions |
| **Web Staging** | Vercel (PR previews) |
| **Web Production** | Vercel (auto-deploy from main) |
| **Mobile Distribution** | App Store (iOS) + Play Store (Android) |
| **Pre-commit** | lefthook |

## 3. Architecture Layers

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  Flutter Widgets + Riverpod State + GoRouter         │
├─────────────────────────────────────────────────────┤
│  DOMAIN LAYER                                        │
│  Entities (Freezed), Use Cases, Pure Vedic Math      │
│  (Sunrise, Yama, Rahu, Hora, Panja Pakshi, Tattva)  │
├─────────────────────────────────────────────────────┤
│  DATA LAYER                                          │
│  ┌─────────────────┐  ┌──────────────────────────┐ │
│  │ LocalRepository  │  │ CloudBackupRepository    │ │
│  │ (Drift/SQLite)   │  │ (iCloud / Google Drive)  │ │
│  └─────────────────┘  └──────────────────────────┘ │
├─────────────────────────────────────────────────────┤
│  AI LAYER                                            │
│  On-device LLM (mobile) / Rules engine (web)         │
└─────────────────────────────────────────────────────┘
```

## 4. Platform Behavior Matrix

| Platform | Local DB | Cloud Backup | Auth | AI | Notifications |
|----------|----------|--------------|------|-----|---------------|
| **iOS** | Drift (SQLite) | iCloud | Apple Sign-In | On-device LLM | Local push |
| **Android** | Drift (SQLite) | Google Drive App Data | Google Sign-In | On-device LLM | Local push |
| **Web** | Drift (IndexedDB/sql.js) | Google Drive App Data | Google Sign-In (mandatory) | Rules-based + wisdom library | In-app only |

**Mobile users choose at onboarding:** Local Only OR Cloud Backup.
**Web users:** Google Drive is mandatory (browser storage is unreliable).

## 5. Core Domain Entities

### Profile
```
id, displayName, birthStarNakshatra, birthBird, locationLat, locationLng,
theme, language, storageMode, notifyRuling, notifyEating, lastAiNote, lastAiNoteDate
```

### SaraKalaiEntry (Breath Journal)
```
id, timestamp, expectedFlow (solar/lunar), actualFlow (solar/lunar/sushumna),
isAligned, nostril (left/right/both), inhaleDuration, holdDuration, exhaleDuration,
notes, activeYama, activeBird, activeElement
```

### BreathSession (Detailed Practice)
```
id, timestamp, totalDuration, nostril (left/right/both),
inhaleLength, holdAfterInhale, exhaleLength, holdAfterExhale,
completedCycles, mood, notes, consciousnessRating
```

### AppSettings
```
storageMode (local/icloud/gdrive), theme, language,
notifyRuling, notifyEating, lastBackupDate
```

## 6. Core Feature Modules

### Module 1: Astro-Logic Engine (Pure Dart, Deterministic)
- Sunrise/Sunset calculator (offline, lat/lng-based)
- 5 Yamas (daylight divided into 5 equal segments)
- Panja Pakshi bird state cycling (authentic 2D lookup tables from Prof. Dr. U.S. Pulippani's "Biorhythms of Natal Moon" — 9 day-group matrices × bright/dark half)
- Rahu Kaal calculation (8 segments, day-index offset)
- 10% Floor Lockout (Oracle score forced to 10% during Rahu Kaal)
- Hora (planetary hour) calculation
- Tattva (element) cycle (Earth/Water/Fire/Air/Ether per breath cycle)

### Module 2: Sara Kalai Breath Journal
- Two-click flow logging (Solar/Lunar/Sushumna)
- Real-time alignment comparison to cosmic pattern
- Breath duration timer (inhale/hold/exhale)
- Actionable micro-advice display
- Quick Sync Pacer (breathing guidance animation)

### Module 3: Streak & Consistency Engine
- Current streak (consecutive aligned days)
- 7-day calendar ribbon (visual checkmarks)
- 30-day trend weight (alignment percentage)
- Time-of-day heatmap
- Yama-level accuracy tracking

### Module 4: Smart Local Notifications (Mobile Only)
- Yama state transition alerts
- Dynamic wisdom in notification payload
- Idempotent queue cleanup on app launch
- Configurable per-state toggles

### Module 5: AI Wisdom Engine
- On-device LLM (mobile): contextual insights from streak/accuracy/bird/rahu data
- Rules-based engine (web): curated wisdom library
- Deterministic fallback: static spiritual proverbs array
- Future: optional user-provided API key for enhanced insights

## 7. Deployment Targets

| Environment | Branch | Hosting | Purpose |
|-------------|--------|---------|---------|
| **Production (Web)** | `main` | Vercel | Live web app (saranidhi.vercel.app) |
| **Preview** | PR branches | Vercel | PR previews, QA |
| **Production (iOS)** | `main` | App Store | Live iOS app |
| **Production (Android)** | `main` | Play Store | Live Android app |

## 8. Monetization Model

- **App purchase** (one-time or freemium with premium unlock)
- **Zero server costs** — user-owned cloud storage
- **Zero data liability** — no user data on developer infrastructure
- Revenue from RevenueCat in-app purchases

## 9. Verification Checklist (Per Sprint)

- [ ] `dart analyze` — zero warnings/errors
- [ ] `flutter test` — all tests pass
- [ ] Type safety: zero `dynamic` usage outside framework boundaries
- [ ] Drift schema migrations tested
- [ ] Offline functionality verified (airplane mode)
- [ ] Cloud backup/restore cycle tested (where applicable)
- [ ] Material 3 theming consistent across all new views

---
