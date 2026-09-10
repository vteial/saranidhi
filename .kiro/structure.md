# Saranidhi — Project Structure

> Reflects the codebase as of **v1.6.0** (Sprint 36). Kept in sync during
> `/sprint-update`. If this file disagrees with the code, the code wins —
> open a docs fix.

## Root Layout

```
saranidhi/
├── .kiro/                  # Kiro configuration (steering, product, design, structure)
├── .github/workflows/      # CI pipelines (ci.yml = Tier 1 PR gate, ci-full.yml = Tier 2 + integration)
├── lib/                    # Dart source code
├── test/                   # Unit + widget tests
├── integration_test/       # Web E2E integration tests (app_test.dart)
├── test_driver/            # flutter drive entrypoint (integration_test.dart)
├── ios/                    # iOS platform (Runner, CloudKitPlugin, entitlements)
├── macos/                  # macOS platform (Runner, CloudKitPluginMacOS, entitlements)
├── android/                # Android platform
├── web/                    # Web assets (sqlite3.wasm, drift_worker.js, privacy-*.html, flutter_bootstrap.js)
├── docs/                   # Project documentation (nested — see below, ~53 files)
├── public/                 # Static brand assets (logo.svg + 3 logo variants)
├── data/                   # Local-only working data (data/exports — gitignored artifacts)
├── scripts/                # Build/support scripts (vercel_build.sh)
└── pubspec.yaml            # Dependencies and project config (version: 1.6.0+1)
```

## Documentation (docs/)

Organized into topic folders (not a flat list):

```
docs/
├── README.md                     # Docs index / table of contents
├── deployment/                   # deployment.md, icloud-sync-testing.md,
│                                 #   mobile-release-guide.md, offline-verification.md, store-listing.md
├── process/                      # dev-setup, dev-workflow, project-evaluation,
│                                 #   project-valuation-report, sprint-backlog, sprint-tracker
├── product/                      # product-scope.md (living scope), user-guide.md
├── reference/                    # architecture.md, security-review.md, third-party-comparison.md
├── research/                     # Sara Kalai knowledge corpus + engine research + terminology
│                                 #   (sarakalai-workshop-knowledge.md, transcripts/sarakalai-2025/, etc.)
└── testing/                      # testing-plan.md, smoke-test-results.md, qa-verify-agent-prompt.md
```

## Source Code (lib/)

```
lib/
├── main.dart
├── l10n/                   # ARB files + generated localizations (en, ta)
├── core/                   # Shared infrastructure (see below)
├── database/               # Drift schema + migrations
└── features/               # 14 feature modules (feature-first)
```

### Core (shared infrastructure)

| File | Role |
|------|------|
| `core/router/app_router.dart` | GoRouter config — StatefulShellRoute with 4 branches (Home, Journal, Prasanam, Analytics) + top-level Settings + Onboarding routes |
| `core/router/shell_scaffold.dart` | Bottom NavigationBar (4 destinations) with responsive constraint |
| `core/router/onboarding_guard.dart` | Redirects to intro/onboarding if profile not complete |
| `core/theme/app_theme.dart` | Material 3 theme — `ThemeAccent` (4 seed colors) × `ThemeBrightness` (Light/Dark/System) |
| `core/theme/theme_provider.dart` | Theme state with SharedPreferences persistence |
| `core/l10n/locale_provider.dart` | Locale state (en/ta) with persistence |
| `core/providers/profile_location_provider.dart` | Cached profile lat/lng FutureProvider |
| `core/providers/location_on_open_provider.dart` | Silent >5km location auto-update on app open |
| `core/services/location_service.dart` | Haversine distance + threshold check |
| `core/services/location_on_open_service.dart` | Geolocation-on-open orchestration |
| `core/utils/geolocation.dart` + `web_geolocation.dart` / `web_geolocation_stub.dart` | Browser geolocation (conditional web import) |
| `core/utils/timezone_utils.dart` | UTC offset from lat/lng (Indian bounding box → IST) |
| `core/utils/branded_app_bar.dart` | Shared AppBar with logo + Settings gear icon |
| `core/utils/bird_emoji.dart` | Bird emoji utility for consistent Pakshi display |
| `core/utils/pakshi_l10n.dart` | Localized bird/state names |
| `core/utils/nakshatra_l10n.dart` | Trilingual nakshatra names (27 EN + TA + Sanskrit) |
| `core/utils/responsive_wrapper.dart` | Max-width centering wrapper |
| `core/utils/app_constants.dart` | Shared constants |
| `core/widgets/empty_state_widget.dart` | Reusable empty state (icon + title + subtitle) |
| `core/widgets/shimmer_loading.dart` | Animated skeleton loading cards |
| `core/widgets/error_boundary.dart` | ErrorBoundary + ErrorFallback widgets |

### Database

| File | Role |
|------|------|
| `database/tables.dart` | Drift table definitions — **6 tables** (Profiles, SaraKalaiJournal, BreathSessions, PrasanamHistory, SomaticInterventionLogs, BirdLibrary) |
| `database/app_database.dart` | Database class with WebAssembly config — **schemaVersion = 5** |
| `database/database_provider.dart` | Riverpod provider (singleton) |
| `database/migration_helpers.dart` | Tested column-existence / migration utilities (Sprint 36 — replaces ad-hoc `sqlite_master` checks) |

### Features (14 modules)

#### astro_engine (Pure Dart — domain only, no UI)
| File | Role |
|------|------|
| `sunrise_calculator.dart` | NOAA solar position → sunrise/sunset |
| `yama_calculator.dart` | 5 day yamas + 5 night yamas |
| `pakshi_calculator.dart` | Bird state tables (day/night groups) |
| `pakshi_attributes.dart` | Extended bird attributes (friends, enemies, ruling planet, direction, colour) |
| `rahu_kaal_calculator.dart` | Inauspicious window calculation |
| `emakandam_calculator.dart` / `kuligai_calculator.dart` | Additional inauspicious/auspicious sub-windows |
| `hora_calculator.dart` | Planetary hours (Chaldean order) |
| `hora_swara_affinity.dart` | Hora ↔ swara affinity scoring |
| `tattva_calculator.dart` | Element cycles within yamas |
| `lunar_phase_calculator.dart` | Waxing/waning from synodic month |
| `moon_longitude_calculator.dart` | Jean Meeus ELP 2000/82 Moon longitude |
| `lahiri_ayanamsa.dart` | Lahiri ayanamsa correction |
| `nakshatra_calculator.dart` | Nakshatra + Paksha from DOB (birth-bird derivation) |
| `name_bird_parser.dart` | Name-based bird lookup path |
| `nostril_pattern.dart` | Expected nostril flow pattern per yama |
| `tara_category.dart` | Tara (star) categorisation |
| `action_window.dart` / `action_window_segment.dart` / `action_windows_engine.dart` | Layer 2 action-window model + 24h schedule |
| `daylight_segment_resolver.dart` | Day/night segment resolution for the timeline |
| `oracle_calculator.dart` / `oracle_engine.dart` | Prasanam oracle scoring (Layer 3) |

#### home (Dashboard — `/` Today)
`presentation/home_screen.dart` + `presentation/widgets/` (birth_bird_card, rahu_kaal_card, full_day_schedule, nostril_dominance_chart, hold_time_card, date_selector, best_times_card, historical_entries_card, calendar_month_view, action-window/focus cards).

#### journal (Journal tab — `/journal`)
`presentation/journal_screen.dart` — screen host for the breath journal (entry/timer/history widgets live in `breath_journal`).

#### breath_journal (Journal domain/data)
`data/journal_repository.dart`, `domain/` (alignment_checker, breath_flow, micro_advice), `presentation/widgets/` (entry, timer, history list, pacer), `providers/journal_providers.dart`.

#### prasanam (Oracle tab — `/prasanam`)
`data/prasanam_repository.dart`, `presentation/prasanam_screen.dart`, `presentation/widgets/` (oracle_result_card, outcome_notes_dialog, prasanam_history_card), `providers/prasanam_providers.dart`.

#### somatic (Guided nostril-shift interventions — Sprint 35)
`data/somatic_intervention_repository.dart`, `domain/somatic_intervention_session.dart`, `presentation/somatic_timer_room.dart`, `presentation/widgets/` (cross_lateral_instruction_card, intervention_selector_sheet, sama_vritti_pacer), `providers/somatic_providers.dart`.

#### streaks (Streak engine + dashboard data)
`data/streak_repository.dart`, `domain/` (streak_calculator, trend_calculator, seven_day_ribbon), `providers/streak_providers.dart` (DashboardData + selectedDateProvider + dashboardDataProvider), `presentation/widgets/`.

#### analytics (Analytics tab — `/analytics`)
`domain/analytics_calculator.dart` (weekly, monthly, streak insights, hold time, CSV export), `providers/analytics_providers.dart`, `presentation/analytics_screen.dart`.

#### ai_wisdom (Daily wisdom)
`domain/` (wisdom_library EN, wisdom_library_ta, rules_engine, fallback_handler), `data/wisdom_cache.dart`.

#### cloud_backup (iCloud sync)
`data/cloudkit/` (sync_service, sync_engine, record_mapper, schema), `providers/` (sync_providers, sync_trigger_service).

#### notifications
`data/notification_service.dart`, `domain/notification_scheduler.dart`, `providers/notification_providers.dart`.

#### onboarding
`presentation/onboarding_screen.dart` (Welcome → Find Your Bird → Location → Data Storage; intro shown first via guard), `providers/onboarding_providers.dart`.

#### settings
`presentation/settings_screen.dart` (theme, language, backup, sync, notifications, data export/import, recalculate bird, clear data).

#### whats_new
`presentation/whats_new_screen.dart` — post-update changelog surface (version tracked via SharedPreferences `whats_new_last_seen_version`).

## Routes

| Route | Screen | Nav |
|-------|--------|-----|
| `/` | HomeScreen | Bottom tab 1 (Home) |
| `/journal` | JournalScreen | Bottom tab 2 (Journal) |
| `/prasanam` | PrasanamScreen | Bottom tab 3 (Oracle) |
| `/analytics` | AnalyticsScreen | Bottom tab 4 (Analytics) |
| `/settings` | SettingsScreen | Top-level (gear icon in AppBar) |
| `/onboarding` | OnboardingScreen | Top-level (guard-driven) |

## Test Structure

```
test/
├── features/astro_engine/      # calculator test files
├── features/breath_journal/    # alignment_checker, micro_advice
├── features/cloud_backup/      # backup repo, record mapper, sync service, metadata
├── features/streaks/           # streak, trend, ribbon calculators
├── features/somatic/           # somatic repository + widgets (Sprint 35/36)
├── features/prasanam/          # oracle engine + repository
├── features/ai_wisdom/         # wisdom engine
├── features/notifications/     # scheduler
├── features/providers/         # bird_emoji, timer, dashboard, locale, theme, onboarding
├── features/l10n/              # localization
├── database/                   # migration_helpers
└── widget_test.dart            # App rendering + navigation

integration_test/app_test.dart  # Web E2E (run via test_driver/integration_test.dart)
```
