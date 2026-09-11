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
| **Production** | v1.6.0-web | [saranidhi.vercel.app](https://saranidhi.vercel.app) |
| **Staging** | latest `main` | [saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app) |
| **Sprints Delivered** | 36 | — |
| **Total PRs** | ~148 | — |
| **Engineering Hours** | see [valuation report](docs/process/project-valuation-report.md) | AI-assisted (Kiro) |

**Latest:** v1.6.0-web (Stability & Test Hardening, Sprint 36).
**Next:** selected from the [Sprint Backlog](docs/process/sprint-backlog.md) epics during `/plan`.

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  Flutter Widgets + Riverpod 3 + GoRouter             │
│  4 tabs: Home | Journal | Oracle | Analytics         │
│  Settings via gear icon (AppBar action)              │
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
| Routing | GoRouter (StatefulShellRoute, 4 branches) |
| Local Database | Drift (SQLite on mobile, WASM on web) |
| Models | Freezed + json_serializable |
| Cloud Sync | iCloud (CloudKit via MethodChannel) |
| Notifications | flutter_local_notifications (zonedSchedule) |
| Theming | Material 3 (4 colors × Light/Dark + System = 9 modes) |
| Localization | English + Tamil (ARB files, 250+ keys) |
| Linting | very_good_analysis (zero infos allowed) |
| CI/CD | GitHub Actions (two-tier: fast + full both on PRs to main; full also on merge/prod PRs) |
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
├── docs/                    # Docs grouped: process/ product/ testing/ deployment/ reference/ research/
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

> For full iMac setup instructions, see [docs/process/dev-setup.md](docs/process/dev-setup.md).

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
Feature branch → PR → main (staging) → release PR → prod (production)
```

1. `/plan` → brainstorm scope; `/sprint-start` branches from `main`
2. Develop with TDD (unit tests for domain logic)
3. Run validation: `dart analyze && flutter test`
4. Create PR targeting `main` — Vercel creates a preview URL
5. `/sprint-finish` after preview/CI pass → **owner merges** → auto-deploys to [staging](https://saranidhi-staging.vercel.app)
6. `/release-start` → smoke test → `/release-finish` (PR `main` → `prod`) → [production](https://saranidhi.vercel.app) → `/release-update`

> Protocols, gates, and roles: [docs/process/dev-workflow.md](docs/process/dev-workflow.md) and [AI_COLLABORATION_FRAMEWORK.md](AI_COLLABORATION_FRAMEWORK.md). The **owner is the sole merge & release authority.**

---

## Documentation

📖 **Full index: [docs/README.md](docs/README.md)** — all docs grouped by context (process, product, testing, deployment, reference, research).

Quick links:

- [User Guide](docs/product/user-guide.md) — what Saranidhi is, its aim, and feature overview
- [Product Scope](docs/product/product-scope.md) — functional product scope · [Architecture](docs/reference/architecture.md) — technical architecture
- [Sprint Tracker](docs/process/sprint-tracker.md) — delivered + in-progress · [Sprint Backlog](docs/process/sprint-backlog.md) — future/candidate work
- [Dev Workflow](docs/process/dev-workflow.md) — protocols, CI/CD, gates · [Dev Setup](docs/process/dev-setup.md)
- [Smoke Test History](docs/testing/smoke-test-results.md) · [Testing Plan](docs/testing/testing-plan.md)
- [AI Collaboration Framework](AI_COLLABORATION_FRAMEWORK.md) — the AI team operating model
- [Changelog](CHANGELOG.md) — release history

---

## License

Private. All rights reserved.
