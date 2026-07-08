# Saranidhi — Project Structure

## Root Layout

```
saranidhi/
├── .kiro/                  # Kiro configuration (steering, product, design, structure)
├── .github/workflows/      # CI pipeline (analyze + test + build web)
├── lib/                    # Dart source code
├── test/                   # Unit + widget tests
├── integration_test/       # E2E integration tests
├── ios/                    # iOS platform (Runner, CloudKitPlugin, entitlements)
├── macos/                  # macOS platform (Runner, CloudKitPluginMacOS, entitlements)
├── android/                # Android platform
├── web/                    # Web assets (sqlite3.wasm, drift_worker.js)
├── docs/                   # Project documentation (16 files)
├── public/                 # Static assets (logo.svg)
└── pubspec.yaml            # Dependencies and project config
```

## Source Code (lib/)

### Core (shared infrastructure)

| File | Role |
|------|------|
| `core/router/app_router.dart` | GoRouter config — 3 branches (Home, Journal, Analytics) + Settings route + onboarding route |
| `core/router/shell_scaffold.dart` | Bottom NavigationBar with responsive 1200px constraint |
| `core/router/onboarding_guard.dart` | Redirects to onboarding if profile not complete |
| `core/theme/app_theme.dart` | Material 3 theme definitions (8 variants) |
| `core/theme/theme_provider.dart` | Theme state with SharedPreferences persistence |
| `core/l10n/locale_provider.dart` | Locale state (en/ta) with persistence |
| `core/utils/responsive_wrapper.dart` | 1200px max-width centering wrapper |
| `core/utils/branded_app_bar.dart` | Shared AppBar with logo + Settings gear icon |
| `core/utils/bird_emoji.dart` | Bird emoji utility for consistent Pakshi display |
| `core/utils/pakshi_l10n.dart` | Localized bird/state names |
| `core/utils/nakshatra_l10n.dart` | Trilingual nakshatra names (27 EN + TA + Sanskrit) |
| `core/utils/timezone_utils.dart` | UTC offset from lat/lng (Indian bounding box → IST) |
| `core/providers/profile_location_provider.dart` | Cached profile lat/lng FutureProvider |
| `core/services/location_service.dart` | Haversine distance + 50km threshold |
| `core/widgets/empty_state_widget.dart` | Reusable empty state (icon + title + subtitle) |
| `core/widgets/shimmer_loading.dart` | Animated skeleton loading cards |
| `core/widgets/error_boundary.dart` | ErrorBoundary + ErrorFallback widgets |

### Database

| File | Role |
|------|------|
| `database/tables.dart` | Drift table definitions (Profiles, SaraKalaiJournal, BreathSessions, BirdLibrary) |
| `database/app_database.dart` | Database class with WebAssembly config |
| `database/database_provider.dart` | Riverpod provider (singleton) |

### Features

#### astro_engine (Pure Dart — domain only, no UI)
| File | Role |
|------|------|
| `sunrise_calculator.dart` | NOAA solar position → sunrise/sunset |
| `yama_calculator.dart` | 5 day yamas + 5 night yamas |
| `pakshi_calculator.dart` | Bird state tables (9 day-groups + 9 night-groups) |
| `rahu_kaal_calculator.dart` | Inauspicious window calculation |
| `hora_calculator.dart` | Planetary hours (Chaldean order) |
| `tattva_calculator.dart` | Element cycles within yamas |
| `lunar_phase_calculator.dart` | Waxing/waning from synodic month |
| `oracle_calculator.dart` | 10% floor lockout during Rahu Kaal |
| `action_window.dart` | ActionWindow enum + fromBirdState() mapping (seeds Layer 2) |
| `action_window_engine.dart` | Full 24h window schedule calculation (v1.3) |
| `prasanam_engine.dart` | 3-vector oracle score calculation (v2.0) |

#### home (Dashboard)
| File | Role |
|------|------|
| `presentation/home_screen.dart` | Main dashboard with date selector + all cards |
| `presentation/widgets/birth_bird_card.dart` | Hero: birth bird state + guidance + progress |
| `presentation/widgets/rahu_kaal_card.dart` | Rahu Kaal time window with urgency styling |
| `presentation/widgets/full_day_schedule.dart` | 10-yama timeline with bird states |
| `presentation/widgets/nostril_dominance_chart.dart` | Expected flow per yama |
| `presentation/widgets/hold_time_card.dart` | Today's average hold duration |
| `presentation/widgets/date_selector.dart` | Date navigation (arrows + picker + Today/Tomorrow) |
| `presentation/widgets/best_times_card.dart` | 7-day Ruling yama scan |
| `presentation/widgets/historical_entries_card.dart` | Past date journal entries |
| `presentation/widgets/calendar_month_view.dart` | Month grid with entry indicators |

#### breath_journal (Journal tab)
| File | Role |
|------|------|
| `data/journal_repository.dart` | CRUD for journal entries (Drift) |
| `domain/alignment_checker.dart` | Compare actual vs expected flow |
| `domain/breath_flow.dart` | BreathFlow enum (solar/lunar/sushumna) |
| `domain/micro_advice.dart` | Context-aware guidance text |
| `presentation/widgets/` | Entry widget, timer, history list, pacer |
| `providers/journal_providers.dart` | State management + sync trigger hooks |

#### streaks (Streak engine + dashboard data)
| File | Role |
|------|------|
| `data/streak_repository.dart` | Daily summary queries from DB |
| `domain/streak_calculator.dart` | Consecutive day streak logic |
| `domain/trend_calculator.dart` | 30-day trend + yama accuracy |
| `domain/seven_day_ribbon.dart` | 7-day checkmark ribbon |
| `providers/streak_providers.dart` | DashboardData model + selectedDateProvider + dashboardDataProvider |
| `presentation/widgets/` | Streak flame, trend, ribbon, yama accuracy |

#### analytics (Analytics tab)
| File | Role |
|------|------|
| `domain/analytics_calculator.dart` | Weekly, monthly, streak insights, hold time, CSV export |
| `providers/analytics_providers.dart` | FutureProviders for each analytics feature |
| `presentation/analytics_screen.dart` | Full screen with 6 insight cards |

#### ai_wisdom (Daily wisdom)
| File | Role |
|------|------|
| `domain/wisdom_library.dart` | 60+ English proverbs |
| `domain/wisdom_library_ta.dart` | 52+ Tamil proverbs |
| `domain/rules_engine.dart` | Priority-based wisdom selection (locale-aware) |
| `domain/fallback_handler.dart` | Deterministic date-seeded fallback |
| `data/wisdom_cache.dart` | SharedPreferences daily cache (locale-tracked) |

#### cloud_backup (iCloud sync)
| File | Role |
|------|------|
| `data/cloudkit/cloudkit_sync_service.dart` | MethodChannel CRUD with native Swift |
| `data/cloudkit/cloudkit_sync_engine.dart` | Pull→merge→push orchestrator |
| `data/cloudkit/cloudkit_record_mapper.dart` | Drift ↔ CloudKit field conversion |
| `data/cloudkit/cloudkit_schema.dart` | Record type + field name constants |
| `providers/sync_providers.dart` | Sync state + device management |
| `providers/sync_trigger_service.dart` | Push-after-write hooks |

#### notifications
| File | Role |
|------|------|
| `data/notification_service.dart` | flutter_local_notifications wrapper |
| `domain/notification_scheduler.dart` | Generate notifications for yama boundaries + Rahu + morning |
| `providers/notification_providers.dart` | Preferences + auto-refresh scheduling |

#### onboarding + settings
| File | Role |
|------|------|
| `onboarding/presentation/onboarding_screen.dart` | 4-step flow (name→star→location→storage) |
| `onboarding/providers/onboarding_providers.dart` | Form state + profile save |
| `settings/presentation/settings_screen.dart` | Theme, language, backup, sync, notifications, clear data |

## Test Structure

```
test/
├── features/astro_engine/      # 8 calculator test files (110+ tests)
├── features/breath_journal/    # alignment_checker, micro_advice
├── features/cloud_backup/      # backup repo, record mapper, sync service, metadata
├── features/streaks/           # streak, trend, ribbon calculators
├── features/ai_wisdom/         # wisdom engine
├── features/notifications/     # scheduler
├── features/providers/         # bird_emoji, timer, dashboard, locale, theme, onboarding
├── features/l10n/              # localization
└── widget_test.dart            # App rendering + navigation
```
