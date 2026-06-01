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

- **Track your breath** — Log which nostril is dominant (left/right/both), with optional duration tracking
- **Align with cosmic rhythms** — Compare your breath flow to the expected pattern from Siva Swarodaya
- **Build consistency** — Streaks, 7-day ribbons, and 30-day trend tracking
- **Receive guidance** — On-device AI insights and traditional wisdom matched to your current state
- **Know your time** — Panja Pakshi bird states, Rahu Kaal awareness, Hora strength, Tattva cycles

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                  │
│  Flutter Widgets + Riverpod 3 + GoRouter             │
├─────────────────────────────────────────────────────┤
│  DOMAIN LAYER (Pure Dart)                            │
│  Vedic Math: Sunrise, Yama, Rahu, Hora, Pakshi      │
│  Entities: Freezed models                            │
├─────────────────────────────────────────────────────┤
│  DATA LAYER                                          │
│  ┌─────────────────┐  ┌──────────────────────────┐ │
│  │ LocalRepository  │  │ CloudBackupRepository    │ │
│  │ (Drift/SQLite)   │  │ iOS: iCloud              │ │
│  │                  │  │ Android/Web: Google Drive │ │
│  └─────────────────┘  └──────────────────────────┘ │
├─────────────────────────────────────────────────────┤
│  AI LAYER                                            │
│  Mobile: On-device LLM │ Web: Rules-based engine    │
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
| Framework | Flutter (iOS, Android, Web) |
| State Management | Riverpod 3 (@riverpod code gen) |
| Routing | GoRouter (StatefulShellRoute) |
| Local Database | Drift (SQLite) |
| Models | Freezed + json_serializable |
| Cloud Backup | iCloud (iOS) / Google Drive (Android, Web) |
| Local AI | On-device LLM (mobile) / Rules engine (web) |
| Theming | Material 3 (Light, Dark, Emerald, Gold) |
| Localization | EN, TA (ARB files) |
| Linting | very_good_analysis |
| CI/CD | GitHub Actions |

---

## Platform Support

| Platform | Storage | Cloud Backup | AI |
|----------|---------|--------------|-----|
| iOS | SQLite | iCloud (Apple Sign-In) | On-device |
| Android | SQLite | Google Drive (Google Sign-In) | On-device |
| Web | IndexedDB/sql.js | Google Drive (Google Sign-In) | Rules-based |

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

- Flutter SDK (latest stable)
- Dart SDK (bundled with Flutter)

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

### Sprint Workflow

1. Branch from `main`: `feature/sprintX-topic`
2. Develop with TDD (unit tests for domain logic)
3. Run validation: `dart analyze && flutter test`
4. Create PR targeting `main`
5. Merge after CI passes

---

## Documentation

- [User Guide](docs/user-guide.md) — What is Saranidhi, its aim, how it helps, and feature overview
- [Project Plan](docs/project-plan.md) — Features, architecture, deployment targets
- [Release 1.0 Plan](docs/release-1.0-plan.md) — Sprint-to-release milestones
- [Sprint Tracker](docs/sprint-tracker.md) — Current progress
- [Testing Plan](docs/testing-plan.md) — Test strategy and scenarios

---

## License

Private. All rights reserved.
