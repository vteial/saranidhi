[← Back to Root](../../README.md)

# Saranidhi — Project Evaluation Report

> **Reviewed:** v1.7.0-web · **Next review:** every `/sprint-update` (defects + test baseline).
> **Scope of this doc:** *quality & defects* — the architecture snapshot, quality-control
> baseline, and the resolved-defects log. It deliberately does **not** duplicate delivery
> accounting: for sprints/PRs/hours see [`project-valuation-report.md`](project-valuation-report.md),
> and for the per-feature inventory see [`sprint-tracker.md`](sprint-tracker.md) + [`CHANGELOG.md`](../../CHANGELOG.md).

## 1. Executive Architecture Summary

Saranidhi is a privacy-first, local-first spiritual breath-tracking application built with Flutter (iOS, Android, Web). It uses pure Dart domain logic for all Vedic calculations, Drift (SQLite/WebAssembly) for persistence, and Riverpod for reactive state management.

**Separation of Concerns:**

| Layer | Responsibility | Location |
|-------|---------------|----------|
| **Domain Logic** | Vedic calculations (Sunrise, Yama, Rahu, Hora, Pakshi, Tattva, Lunar Phase), alignment checking, streak math | `lib/features/astro_engine/domain/`, `lib/features/streaks/domain/`, `lib/features/breath_journal/domain/` |
| **Data Persistence** | SQLite (mobile), WebAssembly SQLite (web), Drift ORM with typed queries | `lib/database/`, `lib/features/*/data/` |
| **State Management** | Riverpod providers (manual + codegen), reactive streams | `lib/features/*/providers/`, `lib/database/database_provider.dart` |
| **Presentation** | Material 3 theming, GoRouter shell navigation, responsive layout | `lib/features/*/presentation/`, `lib/core/` |
| **Deployment** | Vercel (web staging), GitHub Actions CI/CD | `scripts/`, `.github/workflows/` |

**Key Architectural Decisions:**
- Zero network dependency for all calculations — fully offline-capable
- Pure Dart domain layer with no framework dependencies
- Drift + WebAssembly SQLite for cross-platform persistence (including web)
- Feature-first folder structure with clear separation of domain/data/presentation
- 1200px max-width responsive wrapper for desktop screens

---

## 2. Feature Scorecard

> The full per-feature / per-sprint inventory is **not duplicated here** — it lives in
> [`sprint-tracker.md`](sprint-tracker.md) (delivered + in-progress, with the Definition
> of Done) and [`CHANGELOG.md`](../../CHANGELOG.md) (release-facing feature notes).
> All 35 delivered sprints (Sprints 1–37, incl. 27.5) are ✅ **Complete**; the only
> remaining domain is **Production Mobile Deployment** (App Store / Play Store) — 🔲 Planned.
> This doc tracks *quality and defects* for that delivered work, below.

---

## 3. Quality Control Baseline

### Test Execution Parameters

| Metric | Value |
|--------|-------|
| Unit/Widget test framework | `flutter_test` + `mocktail` |
| Integration test framework | `integration_test` (Flutter) + headless Chrome |
| Total automated tests | 546 (as of Sprint 37) |
| Pass rate | 100% on CI (macOS local shows 4 known CloudKit-platform failures that pass on Ubuntu — see `dev-setup.md`) |
| Static analysis | `dart analyze --fatal-infos` — zero issues |
| CI enforcement | GitHub Actions two-tier (Fast: analyze + domain tests + build; Full: all tests + coverage + integration, on PRs to `main` and on merge) |
| Coverage threshold | ≥ 19% (domain layer ~95%; UI-heavy blend brings the average down — see `dev-workflow.md`) |
| Linting | `very_good_analysis` |

### Test Count Progression

| Sprint | New Tests | Cumulative Total |
|--------|-----------|-----------------|
| Sprint 1 | 2 (widget navigation) | 2 |
| Sprint 2 | 108 (astro-engine domain) | 110 |
| Sprint 3 | 17 (alignment, micro-advice) | 127 |
| Sprint 4 | 23 (streak, trend, ribbon) | 150 |
| Sprint 5 | 15 (backup repositories, storage mode) | 165 |
| Sprint 6 | 18 (notifications, onboarding, nakshatra) | 183 |
| Sprint 7 | 18 (context payload, rules engine, fallback, library) | 201 |
| Sprint 10 | 63 (new test suites) | 264 |
| Sprint 12 | 0 (test rewrite, same count) | 264 |
| Sprint 20 | 84 (widget/integration test updates) | 348 |
| Sprint 22 | 62 (10 widget tests × ~6 assertions) | 410 |

### Resolved Defects

| Issue | Root Cause | Resolution | Sprint |
|-------|-----------|------------|--------|
| **Birth bird mis-calculated for ~1/3 of nakshatras + all Krishna births** | Shipped `PakshiCalculator` used the modern-secondary **Pulippani 5-5-5-5-7** partition + a dual bright/dark table (Krishna reverse-swap). Lineage-unanimous truth (2025 workshop + master's book + 1930 *Rathinam*) is **5-6-5-5-6** with a **single permanent** birth-star table. Surfaced by the Panja Pakshi corpus audit (CONF-PP-001/002); confirmed against the owner's own profile (Pushya/Krishna → wrongly Cock, correctly Owl). | Partition → 5-6-5-5-6 (Pooram→Owl, Visakam→Crow, Uthiradam→Rooster); single permanent table (no Krishna swap); waning swap isolated to the name-initial fallback (verified 5-cycle); on-load `BirdMigrationService` re-migrates ALL affected existing users (DOB + manual/no-DOB). Attributes (planets, friend/enemy, phase-directions) also corrected (CONF-PP-003/004/005). | Sprint 37 (PR #167) |
| `InvalidTypeException` in Riverpod codegen for `Stream<List<T>>` | `riverpod_generator` incompatible with complex return types | Switched to manual Riverpod providers for journal feature | Sprint 3 |
| `'web' parameter needs to be set` runtime crash on Flutter web | `drift_flutter` requires explicit `DriftWebOptions` on web platform | Added `sqlite3.wasm` + `drift_worker.js` + `DriftWebOptions` config | Sprint 3 (Hotfix PR #4) |
| `pumpAndSettle` timeout in widget tests | Journal `StreamProvider` never completing without real DB | Added provider overrides in test with mocked empty stream | Sprint 3 |
| Node.js 20 deprecation warning in CI | `actions/checkout@v4` uses deprecated Node.js 20 | Upgraded to `@v5` + `FORCE_JAVASCRIPT_ACTIONS_TO_NODE24` env | Sprint 2 |
| Coverage gate failure (16% vs 80%) | New UI code without corresponding widget tests | Lowered threshold to 15% for feature sprints; raise in Sprint 10 | Sprint 3 |
| Integration tests failing (stale assertions) | Home screen changed from placeholder to dashboard; integration test not updated | Updated `integration_test/app_test.dart` to match new dashboard UI | Sprint 4 |
| Bottom nav full-width on desktop | `NavigationBar` not wrapped in responsive constraint | Used `Align` + `ConstrainedBox(maxWidth: 1200)` with `heightFactor: 1` | Sprint 4 (PR #9) |
| Logo only on Home screen | Only `HomeScreen` had logo in AppBar | Created shared `BrandedAppBar` widget used on all tabs | Sprint 4 (PR #9) |
| Entry logged without completing timer | Submit button enabled before timer completion | Disabled button until `TimerPhase.complete`; shows "Complete timer to log" | Sprint 4 (PR #9) |
| UI collapsed after ResponsiveWrapper on bottomNav | `Center` + `ConstrainedBox` inside `Scaffold.bottomNavigationBar` collapsed height | Reverted (PR #8), used `Align(heightFactor: 1)` approach instead (PR #9) | Sprint 4 (PR #7→#8→#9) |
| `flutter_gen` synthetic package not resolvable in CI | `dart analyze` / `flutter analyze` can't resolve `.dart_tool/flutter_gen/` in CI | Used `synthetic-package: false` (deprecated), then committed generated files to `lib/l10n/generated/` | Sprint 9 |
| `directives_ordering` lint failures | `very_good_analysis` requires third-party imports separated from own-package imports by blank line | Grouped imports: third-party → blank line → `package:saranidhi/` | Sprint 9 |
| `flutter build web` fails without `generate: true` | Flutter 3.44 requires the flag for `gen_localizations` build target | Restored `flutter: generate: true` in pubspec.yaml | Sprint 9 |
| Clear All Data doesn't redirect to onboarding | `onboardingCompleteProvider` reads from SharedPreferences; DB clear didn't reset the prefs flag | Added `reset()` to `OnboardingCompleteNotifier`; called after DB clear | Sprint 9 |
| Clear All Data shows "Complete Setup" instead of Welcome | `onboardingNotifierProvider` retained old form state (step 3) | Added `ref.invalidate(onboardingNotifierProvider)` to reset to step 0 | Sprint 9 |
| Widget tests fail in headless CI due to scroll assertions | `scrollUntilVisible`/`dragUntilVisible` unreliable without real viewport | Removed fragile widget tests; rely on existing `widget_test.dart` + pure unit tests | Sprint 10 |
| Coverage threshold 80% unrealistic for UI-heavy codebase | Domain ~95% covered but UI/presentation brings average to 26% | Set realistic threshold at 25%; domain layer verified independently | Sprint 10 |
| Bird state calculation wrong (A-04) | Positional state assignment instead of authentic 2D bird×yama lookup tables | Complete algorithm rewrite using Prof. Pulippani's reference tables (9 day-group matrices) | Sprint 12 |
| Tamil translations incomplete (D-01 to D-05) | UI widgets used `displayName` getter (English) instead of l10n ARB strings | Created `PakshiBirdL10n`/`PakshiStateL10n` extensions + localized all widgets | Sprint 12 |
| Settings page English strings | StorageModeSelector, BackupActionsWidget, color accents hardcoded English | Replaced with l10n calls, added 14+ new ARB keys | Sprint 12 |
| Timer/Pacer English labels | BreathTimerWidget and QuickSyncPacer used hardcoded English | Added 22 new l10n keys for timer phases, instructions, pacer | Sprint 12 |
| Micro-advice in English only | MicroAdvice domain class returns English | Localized at presentation layer with 5 new advice ARB keys | Sprint 12 |
| Widget tests expect '30-Day Trend' on Home | TrendWidget moved from Today tab to Explore tab in layout redesign | Updated widget_test.dart and integration test to assert Today/Explore sub-tab labels instead | Sprint 20 |
| `cascade_invocations` lint failures | Multiple `ref.invalidate()` calls on same receiver without cascade | Used `ref..invalidate()` cascade syntax | Sprint 20 |
| `unnecessary_import` lint (dart:typed_data) | `Uint8List` already re-exported by `drift` and `flutter/foundation` | Removed redundant `dart:typed_data` imports | Sprint 20 |
| `directives_ordering` lint (share_plus) | `share_plus` sorts after `saranidhi` alphabetically, breaking section grouping | Put all `package:` imports in single alphabetically-sorted section | Sprint 20 |
| Settings page full-width on desktop | Settings pushed route was outside ShellScaffold's ResponsiveWrapper | Wrapped body with `Center` + `ConstrainedBox(maxWidth: 1200)` | Sprint 20 |
| Import data not reflecting immediately | Only `dashboardDataProvider` invalidated after JSON import | Added cascade invalidation of 6 providers (dashboard, journal, theme, locale, notifications, onboarding) | Sprint 20 |
| Settings background color inconsistency | Scaffold inside ResponsiveWrapper only covered 1200px; outer area was white | Used full-width Scaffold for theme background, constrained only body content | Sprint 20 |
| Missing favicon in browser tab | `index.html` referenced `favicon.png` which didn't exist | Added `web/favicon.svg` (SVG logo) + updated link tag with PNG fallback | Sprint 20 |
| Date/time pickers crash on Flutter Web | OnboardingGuard renders OnboardingScreen via `MaterialApp.builder` — outside GoRouter Navigator; `showDatePicker` has no Navigator to push dialog route | Wrapped OnboardingScreen in its own `Navigator` widget inside OnboardingGuard | Sprint 21 |
| `context.go()` TypeError after saveProfile on web | After onboarding completes, guard swaps widget tree; `context.go(AppRoutes.home)` tries to use GoRouter from dead Navigator context | Removed explicit navigation — OnboardingGuard handles transition automatically via provider state | Sprint 21 |
| Location step layout shift on wide screens | `SingleChildScrollView` content centered in `Expanded` when short (before selection), snapped to left when tall (after selection) | Wrapped with `Align(alignment: Alignment.topLeft)` to pin content consistently | Sprint 21 |
| Hardcoded 'Analytics' bottom nav label | NavigationDestination label was English-only string literal | Replaced with `l10n.analyticsTitle` (key exists in both EN/TA ARB files) | Sprint 21 |
| Non-Indian cities in preset lists | London, New York, Singapore, Sydney included — irrelevant for Indian birth-based app | Removed; kept only Chennai, Mumbai, Delhi, Bangalore, Hyderabad, Kolkata | Sprint 21 |
| `avoid_redundant_argument_values` lint warnings | `useRootNavigator: true` explicitly passed to `showDatePicker`/`showTimePicker` (already default) | Removed redundant arguments | Sprint 21 |
| Notification scheduler wrong weekday format | Passing Dart's DateTime.weekday (1=Mon..7=Sun) directly to PakshiCalculator/RahuKaalCalculator which expect 0=Sun..6=Sat | Wrapped with PakshiCalculator.dartWeekdayToSunBased() | Sprint 22 |
| Get Started button not responding | OnboardingGuard passed callback through Navigator's cached route — ref became stale | Made IntroScreen a ConsumerWidget + added ValueKey to each Navigator for proper element replacement | Sprint 23 |
| Settings back button misaligned on wide screens | AppBar spanned full viewport while content constrained to 1200px | Replaced with SliverAppBar inside ConstrainedBox using CustomScrollView | Sprint 23 |
| Double divider above Notifications | BackupActionsWidget and SyncDeviceConfigWidget had separate dividers | Consolidated into single group with one divider | Sprint 23 |
| `avoid_redundant_argument_values` lint in ShimmerLoading | `LinearGradient` constructor specified `begin: Alignment.centerLeft` and `end: Alignment.centerRight` (already defaults) | Removed redundant arguments | Sprint 24 |
| Analytics not refreshing after journal entry | Analytics `FutureProvider`s watched `journalRepositoryProvider` (static), not the journal entries stream; cached stale result | Added `await ref.watch(journalEntriesProvider.future)` to create reactive dependency on all 5 analytics providers | Sprint 24 |
| Safari white page (all non-Chrome browsers) | `canvasKitVariant: "chromium"` in `flutter_bootstrap.js` forced Chrome-only CanvasKit renderer | Removed `canvasKitVariant` config; Flutter auto-detects correct renderer per browser | Sprint 25 |
| Safari WASM initialization failure | `Cross-Origin-Opener-Policy: same-origin` header blocked Safari's SharedArrayBuffer support | Removed COOP/COEP headers from `vercel.json`; Drift WASM uses fallback worker mode | Sprint 25 |
| Dashboard not updating after location change | `dashboardDataProvider` and `profileLocationProvider` not invalidated after profile edit in Settings | Added `ref.invalidate()` calls after location and birth star saves | Sprint 25 |
| Night schedule hidden during daytime | Night yamas only computed when `isToday && now.isAfter(sunset)` or before sunrise | Merged daytime-today case into else branch that always computes night schedule for display | Sprint 25 |
| `KeyboardListener` broken on web | Inline `FocusNode()` in stateless widget doesn't work reliably | Replaced with `CallbackShortcuts` + `Focus(autofocus: true)` (proper Flutter keyboard API) | Sprint 25 |
| sqlparser 0.44.6 incompatibility | New sqlparser release removed `.when()` method that drift_dev 2.34.0 uses | Added `dependency_overrides: sqlparser: 0.44.5` as temporary pin | Sprint 25 |

---

## 4. Sprint Delivery Summary

> **Not duplicated here.** The one-row-per-sprint delivery table (focus + PR + status)
> is maintained in [`project-valuation-report.md`](project-valuation-report.md#sprint-delivery-summary).
> The *tests-added-per-sprint* signal that used to live in this section is captured by the
> **Test Count Progression** table in §3 above. This doc's unique contribution is the
> **Resolved Defects** log (§3) — the record of what broke and how it was fixed.

---

[← Back to Root](../../README.md)
