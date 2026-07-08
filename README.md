# Saranidhi

**The Treasure House of Breath** — A spiritual life-guidance app rooted in ancient Sara Kalai science.

---

## The Name

**Saranidhi** (சரநிதி) is a Sanskrit/Tamil compound:

- **Sara (சர)** — Refers to *Swara* or *Charam*, the sacred flow of breath through the nostrils (Prana). In *Siva Swarodaya* and traditional Tamil *Sara Kalai* sciences, Sara is the dynamic life-force energy that shifts between the Solar channel (Pingala/Right) and Lunar channel (Ida/Left).
- **Nidhi (நிதி)** — Means *Treasure*, *Repository*, or *Wealth*. An inexhaustible storehouse of divine value.

> **Saranidhi** literally translates to **"The Treasure House of Breath"** or **"The Repository of Cosmic Flow."**

The app teaches users to treat their daily breath patterns as a form of divine wealth, aligning internal rhythms with external cosmic currents — the hours of planetary power (Horas) and the biological rhythms of the five elements (Panja Pakshi).

---

## What It Does

Saranidhi helps you:

- **Track your breath** — Log which nostril is dominant (Solar/Lunar/Sushumna), with guided nostril test and duration tracking
- **Align with cosmic rhythms** — Context-dependent alignment (Sushumna aligned in Yoga windows, blocked in Artha/Kriya)
- **See your cosmic state** — Planetary hour (Hora), element cycle (Tattva), and Action Window displayed live
- **Build consistency** — Streaks with milestone celebrations (7/30/100 days), 7-day ribbons, 30-day trends
- **Receive guidance** — Rules-based wisdom matched to your current bird state, in English or Tamil
- **Know your time** — Panja Pakshi bird states (day + night), Rahu Kaal awareness, full 10-yama 24h schedule
- **Plan ahead** — Browse any date's schedule, "Best Times This Week", calendar month view
- **Analyze patterns** — Weekly/monthly analytics, hold time progression, yama performance, CSV export

---

## Current Status

| Milestone | Version | URL |
|-----------|---------|-----|
| **Production** | v1.0.0-web (Sprint 13) | [saranidhi.vercel.app](https://saranidhi.vercel.app) |
| **Staging** | v1.2.0-web (Sprint 27) | [saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app) |
| **Sprints Delivered** | 27 | — |
| **Total PRs** | 70 | — |
| **Engineering Hours** | ~71h | AI-assisted (Kiro) |

**Next release:** v1.2.0-web (pending smoke test) → v1.3.0 (Action Windows) → v2.0.0 (Prasanam Oracle)

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  Flutter Widgets + Riverpod 3 + GoRouter             │
│  3 tabs: Home | Journal | Analytics                  │
│  Settings via gear icon (AppBar action)              │
│  Prasanam FAB on Today tab (v2.0 planned)            │
├─────────────────────────────────────────────────────┤
│  DOMAIN LAYER (Pure Dart)                            │
│  Vedic Math: Sunrise, Yama, Rahu, Hora, Pakshi,     │
│  Tattva, LunarPhase, ActionWindow, Oracle            │
│  Analytics: Streak, Trend, Weekly, Monthly, HoldTime │
│  Wisdom: RulesEngine, FallbackHandler (EN + TA)      │
├─────────────────────────────────────────────────────┤
│  DATA LAYER                                          │
│  ┌─────────────────┐  ┌──────────────────────────┐ │
│  │ LocalRepository  │  │ CloudBackupRepository    │ │
│  │ (Drift/SQLite)   │  │ iOS: iCloud (CloudKit)   │ │
│  │ Web: WASM SQLite  │  │ Android: stub            │ │
│  └─────────────────┘  └──────────────────────────┘ │
├─────────────────────────────────────────────────────┤
│  PLATFORM LAYER                                      │
│  iOS/macOS: CloudKit MethodChannel + Notifications   │
│  Web: Drift WASM (sqlite3.wasm + drift_worker.js)    │
│  All: flutter_local_notifications                    │
└─────────────────────────────────────────────────────┘
```

### Design Principles

- **Local-first** — All data lives on your device. Zero server dependency.
- **Privacy by design** — Your data never touches our servers. Cloud backup goes to YOUR iCloud/Google Drive account.
- **Zero backend costs** — No Supabase, no Firebase, no server to maintain.
- **Offline-capable** — Every feature works without internet.
- **Cross-platform** — iOS, Android, and Web from a single Flutter codebase.

---

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.44+ (iOS, Android, Web, macOS) |
| State Management | Riverpod 3 (NotifierProvider, FutureProvider) |
| Routing | GoRouter (StatefulShellRoute, 3 branches) |
| Local Database | Drift (SQLite on mobile, WASM on web) |
| Models | Freezed + json_serializable |
| Cloud Sync | iCloud (CloudKit via MethodChannel) |
| Notifications | flutter_local_notifications (zonedSchedule) |
| Theming | Material 3 (4 colors × Light/Dark + System = 9 modes) |
| Localization | English + Tamil (ARB files, 200+ keys) |
| Linting | very_good_analysis (zero infos allowed) |
| CI/CD | GitHub Actions (two-tier: fast PRs + full on merge) |
| Hosting | Vercel (staging + production + PR previews) |

---

## Platform Support

| Platform | Storage | Cloud Sync | Notifications |
|----------|---------|------------|---------------|
| iOS | SQLite | iCloud (CloudKit) | flutter_local_notifications |
| macOS | SQLite | iCloud (CloudKit) | flutter_local_notifications |
| Android | SQLite | Stub (future) | flutter_local_notifications |
| Web | WASM SQLite (sqlite3.wasm) | N/A | N/A (no-op) |

---

## Project Structure

```
saranidhi/
├── .kiro/steering/          # Development conventions & app spec
├── docs/                    # Project plan, sprint tracker, testing plan
├── public/                  # Static assets (logo, icons)
├── lib/                     # Flutter application source
│   ├── core/                # Router, theme, utils, constants
│   ├── features/            # Feature modules (breath_journal, astro_engine, etc.)
│   ├── database/            # Drift schema & DAOs
│   └── main.dart
├── test/                    # Unit & widget tests
├── integration_test/        # Integration tests
└── pubspec.yaml
```

---

## Development

### Prerequisites

- Flutter SDK (stable channel, ≥3.44)
- Dart SDK ≥3.12.1 (bundled with Flutter)
- Xcode 15+ (for iOS/macOS builds + CloudKit)

> For full iMac setup instructions, see [docs/dev-setup.md](docs/dev-setup.md).

### Getting Started

```bash
# Clone
git clone https://github.com/vteial/saranidhi.git

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Development Workflow

```
Feature branch → PR → main (staging) → /release PR → prod (production)
```

1. Branch from `main`: `feature/sprintX-topic`
2. Develop with TDD (unit tests for domain logic)
3. Run validation: `dart analyze && flutter test`
4. Create PR targeting `main` — Vercel creates preview URL
5. Merge after CI passes → auto-deploys to [staging](https://saranidhi-staging.vercel.app)
6. When ready: `/release` PR from `main` → `prod` → deploys to [production](https://saranidhi.vercel.app)

---

## Documentation

- [User Guide](docs/user-guide.md) — What is Saranidhi, its aim, how it helps, and feature overview
- [Project Plan](docs/project-plan.md) — Features, architecture, deployment targets
- [Release Plan](docs/release-1.0-plan.md) — Phased release milestones (5 phases)
- [Sprint Tracker](docs/sprint-tracker.md) — Current progress
- [Testing Plan](docs/testing-plan.md) — Test strategy and scenarios
- [Smoke Test History](docs/smoke-test-results.md) — Release index linking to per-version test files
- [Smoke Test v1.2.0](docs/smoke-test-v1.2.0.md) — Current smoke test (plan + results in one file)
- [Dev Workflow](docs/dev-workflow.md) — CI/CD, deployment, protocols (`/start-sprint`, `/finish-sprint`, `/release`)
- [Dev Setup](docs/dev-setup.md) — iMac development environment setup (10-step guide)
- [Deployment Guide](docs/deployment.md) — Prod/Staging/Preview architecture, rollback, monitoring
- [iCloud Sync Testing](docs/icloud-sync-testing.md) — Multi-device CloudKit sync verification guide
- [Store Listing](docs/store-listing.md) — App Store & Play Store listing text (for Sprint X)
- [Mobile Release Guide](docs/mobile-release-guide.md) — iOS/Android build & submission steps (for Sprint X)
- [Security Review](docs/security-review.md) — Architecture security assessment, data protection
- [Offline Verification](docs/offline-verification.md) — Offline capability matrix, zero-network verification
- [Project Evaluation](docs/project-evaluation.md) — Feature scorecard, quality metrics, defect log
- [Project Valuation Report](docs/project-valuation-report.md) — Time investment, commit timeline, sprint delivery
- [Changelog](CHANGELOG.md) — Release history and notable changes

---

## License

Private. All rights reserved.
