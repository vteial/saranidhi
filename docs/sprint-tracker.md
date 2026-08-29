[← Back to Root](../README.md)

# Saranidhi — Development Sprint Tracker

---

## Sprint 0: Pre-Development & Project Initialization ✅

- [x] Task 0.1: Initialize Git repository with `main` branch and Flutter `.gitignore`
- [x] Task 0.2: Create Kiro steering files (`pr-workflow.md`, `saranidhi-spec.md`)
- [x] Task 0.3: Create `README.md` with project overview, name etymology, architecture, and tech stack
- [x] Task 0.4: Create `docs/project-plan.md` with full feature modules, data schema, and deployment architecture
- [x] Task 0.5: Create `docs/roadmap.md` with sprint-to-release mapping and milestones
- [x] Task 0.6: Create `docs/sprint-tracker.md` (this file)
- [x] Task 0.7: Create `docs/testing-plan.md` with test strategy and scenario matrix
- [x] Task 0.8: Create app logo SVG (`public/logo.svg`)
- [x] Task 0.9: Create `docs/user-guide.md` with app definition, aim, usefulness, and feature descriptions (serves as in-app guide)
- [x] Task 0.10: Commit all pre-development artifacts and push to `main` on `vteial/saranidhi`

---

## Sprint 1: Project Scaffold & Core Architecture ✅ Complete (Merged PR #1)

- [x] Task 1.1: Initialize Flutter project with `flutter create` (iOS, Android, Web targets)
- [x] Task 1.2: Configure `pubspec.yaml` with core dependencies (Riverpod 3, GoRouter, Drift, Freezed, very_good_analysis)
- [x] Task 1.3: Set up `analysis_options.yaml` with very_good_analysis and strict rules
- [x] Task 1.4: Configure Drift database with initial schema (profiles, sara_kalai_journal, breath_sessions, bird_library tables)
- [x] Task 1.5: Set up Riverpod 3 with code generation scaffold and provider structure
- [x] Task 1.6: Configure GoRouter with StatefulShellRoute (bottom nav: Home, Journal, Settings)
- [x] Task 1.7: Implement Material 3 theming (Light, Dark, Emerald, Gold) with persistence
- [x] Task 1.8: Set up feature-first folder structure (`lib/core/`, `lib/features/`, `lib/database/`)
- [x] Task 1.9: Configure GitHub Actions CI workflow (analyze + test + build web)
- [x] Task 1.10: Configure lefthook pre-commit hooks (format + analyze)
- [x] Task 1.11: Verify clean build on all platforms (`flutter build web`, iOS simulator, Android emulator)

---

## Sprint 2: Astro-Logic Engine (Pure Dart TDD) ✅ Complete (Merged PR #2)

- [x] Task 2.1: Implement sunrise/sunset calculator using NOAA solar position algorithm
- [x] Task 2.2: Implement 5 Yamas calculation (divide daylight into 5 equal segments)
- [x] Task 2.3: Implement Panja Pakshi bird state cycling (weekday + lunar phase matrix)
- [x] Task 2.4: Implement Rahu Kaal calculation (8-segment division, day-index offset mapping)
- [x] Task 2.5: Implement 10% Floor Lockout logic (Oracle score override during Rahu Kaal)
- [x] Task 2.6: Implement Hora (planetary hour) calculation
- [x] Task 2.7: Implement Tattva (element) cycle calculation within Yamas
- [x] Task 2.8: Implement lunar phase determination (waxing/waning from date)
- [x] Task 2.9: Write comprehensive unit tests for all calculation functions (edge cases: equinox, solstice, extreme latitudes)
- [x] Task 2.10: Verify zero network dependency — all calculations work in airplane mode

---

## Sprint 3: Sara Kalai Breath Journal UI + Logic ✅ Complete (Merged PR #3)

- [x] Task 3.1: Build two-click breath entry widget (Solar/Lunar/Sushumna selection)
- [x] Task 3.2: Implement real-time alignment comparison against Astro-Logic Engine output
- [x] Task 3.3: Build breath duration timer UI (inhale/hold/exhale with visual feedback)
- [x] Task 3.4: Implement micro-advice display component (context-aware guidance text)
- [x] Task 3.5: Build Quick Sync Pacer animation (breathing guide to shift dominant nostril)
- [x] Task 3.6: Wire journal entries to Drift local repository (CRUD operations)
- [x] Task 3.7: Build journal history list view (chronological, grouped by date)
- [x] Task 3.8: Implement Riverpod state management for breath journal feature

---

## Sprint 4: Streak & Consistency Engine ✅ Complete (Merged PR #5)

- [x] Task 4.1: Implement streak calculation logic (consecutive aligned days from today backwards)
- [x] Task 4.2: Build 7-day calendar ribbon widget (compact visual checkmarks)
- [x] Task 4.3: Implement 30-day rolling trend calculation (alignment percentage)
- [x] Task 4.4: Build trend visualization component (progress bar or mini chart)
- [x] Task 4.5: Implement Yama-level accuracy tracking (which segments user captures most)
- [x] Task 4.6: Build time-of-day heatmap component
- [x] Task 4.7: Handle edge cases (timezone changes, missed days, streak reset logic)
- [x] Task 4.8: Wire streak data to dashboard home view

---

## Sprint 5: Cloud Backup Integration ✅ Complete (Merged PR #10)

- [x] Task 5.1: Implement abstract `CloudBackupRepository` interface
- [x] Task 5.2: Implement iCloud backup/restore (iOS) — stub with architecture ready
- [x] Task 5.3: Implement Google Drive App Data backup/restore (Android/Web) — stub with architecture ready
- [x] Task 5.4: Build storage mode selector in onboarding (Local / iCloud / Google Drive)
- [x] Task 5.5: Implement Apple Sign-In flow (iOS, for iCloud access) — stub
- [x] Task 5.6: Implement Google Sign-In flow (Android/Web, for Drive access) — stub
- [x] Task 5.7: Build backup/restore settings UI (last backup date, manual trigger, auto-backup toggle)
- [x] Task 5.8: Implement database export/encryption before upload
- [x] Task 5.9: Implement restore flow (detect backup on sign-in, offer import)
- [x] Task 5.10: Test full backup-restore cycle on each platform — unit tests for all providers

---

## Sprint 6: Notifications + Onboarding ✅ Complete (Merged PR #11)

- [x] Task 6.1: Implement local notification scheduling at Yama boundary times
- [x] Task 6.2: Build dynamic wisdom payload injection into notification content
- [x] Task 6.3: Implement idempotent notification queue cleanup on app launch
- [x] Task 6.4: Build notification toggle settings (per-state: Ruling, Eating)
- [x] Task 6.5: Build first-run onboarding flow (welcome → birth star → location → storage mode)
- [x] Task 6.6: Implement birth bird calculation from nakshatra input
- [x] Task 6.7: Implement location permission request + geocoding for sunrise accuracy
- [x] Task 6.8: Persist onboarding profile to local Drift database

---

## Sprint 7: AI Wisdom Engine ✅ Complete (Merged PR #12)

- [x] Task 7.1: Implement context payload builder (streak, accuracy, bird, rahu, tattva, hora)
- [x] Task 7.2: Integrate on-device LLM for mobile platforms — stub (architecture ready)
- [x] Task 7.3: Build rules-based wisdom engine for web platform
- [x] Task 7.4: Curate static wisdom library (spiritual proverbs, Sara Kalai teachings)
- [x] Task 7.5: Implement deterministic fallback handler (no model/no network → static proverbs)
- [x] Task 7.6: Build AI insight card UI with skeleton loading state
- [x] Task 7.7: Implement daily insight caching (one generation per day, stored locally)
- [x] Task 7.8: Test AI layer in airplane mode (fallback must always render)

---

## Sprint 8: Theming, Profile & Core UX ✅ Complete (Merged PR #13)

- [x] Task 8.1: Implement 8 theme variants: 4 colors (Default, Emerald, Gold, Purple) × 2 modes (Light/Dark)
- [x] Task 8.2: Add System theme mode (follow OS) + Light/Dark manual toggle
- [x] Task 8.3: Profile completion flag + GoRouter redirect (first launch → onboarding)
- [x] Task 8.4: Profile display card in Settings (name, birth star, bird, location)
- [x] Task 8.5: Editable profile (name, birth star with warning, location)
- [x] Task 8.6: Display sunrise/sunset time on Home dashboard
- [x] Task 8.7: Display current bird state (name + emoji) on Home dashboard
- [x] Task 8.8: Breath timer: show live running seconds during each phase

---

## Sprint 9: i18n, Animations & Polish ✅ Complete (Merged PR #14)

- [x] Task 9.1: Set up Tamil ARB translations (all user-facing strings)
- [x] Task 9.2: Language switcher in Settings (EN/TA)
- [x] Task 9.3: Smooth page transitions between tabs
- [x] Task 9.4: Pull-to-refresh on Home dashboard
- [x] Task 9.5: "Clear All Data" option in Settings
- [x] Task 9.6: Bird emoji/icons for Pakshi display throughout app
- [x] Task 9.7: Accessibility audit (font scaling, contrast, semantic labels)
- [x] Task 9.8: App icon generation from logo SVG

---

## Sprint 10: Testing & Hardening ✅ Complete (Merged PR #16)

- [x] Task 10.1: Write unit tests for all domain layer logic (Astro-Engine, Streaks, AI context)
- [x] Task 10.2: Write widget tests for core UI components (breath entry, timer, streak ribbon)
- [x] Task 10.3: Write integration tests for full user flows (onboarding, log breath, view streak)
- [x] Task 10.4: Write E2E smoke tests (app launch, navigate, log entry, verify persistence)
- [x] Task 10.5: Performance profiling (app startup time, animation smoothness, DB query speed)
- [x] Task 10.6: Fix all identified defects from testing
- [x] Task 10.7: Verify offline functionality (airplane mode full flow)
- [x] Task 10.8: Security review (no data leaks, encrypted backup verification)

---

## Sprint 11: Smoke Test Plan & CI Polish ✅ Complete (Merged PR #18)

- [x] Task 11.1: Create `docs/manual-smoke-test.md` with full scenario matrix (Accuracy, Core Flow, Settings, Edge Cases)
- [x] Task 11.2: Create `docs/smoke-test-results.md` template (ready for manual execution)
- [x] Task 11.3: Add CI `paths-ignore` for docs-only branches (skip quality gates on .md/.kiro changes)
- [x] Task 11.4: Add `/plan` protocol to `docs/dev-workflow.md`
- [x] Task 11.5: Revise `docs/roadmap.md` — updated sprint mapping (11–14), move cloud backup/auth to 1.1
- [x] Task 11.6: Update `docs/sprint-tracker.md` with Sprints 12–14 definitions
- [x] Task 11.7: Improve Tamil translations (deferred to Sprint 12 — completed via PR #21 + #22)

---

## Sprint 12: Manual Smoke Test Execution & Fixes ✅ Complete (PR #21, Hotfix PR #22)

- [x] Task 12.1: Execute manual smoke test (owner — compare with Align27 on Chennai/Pushya)
- [x] Task 12.2: Record results in `docs/smoke-test-results.md`
- [x] Task 12.3: Fix calculation accuracy issues — rewrite Panja Pakshi algorithm with authentic 2D lookup tables
- [x] Task 12.4: Fix Tamil translation gaps (breath page, settings page, bird names in UI)
- [x] Task 12.5: Fix UX issues surfaced during manual testing
- [x] Task 12.6: Re-execute failed scenarios after fixes → all pass

---

## Sprint 13: Web Production Deployment ✅ Complete (PR #25)

- [x] Task 13.1: Verify Vercel production deployment on `main` (saranidhi.vercel.app)
- [x] Task 13.2: Production deployment via Vercel (auto-deploy from `main`)
- [ ] Task 13.3: Set up custom domain (skipped — using platform default URL)
- [x] Task 13.4: Document deployment workflow and rollback procedures
- [x] Task 13.5: Add privacy policy page
- [x] Task 13.6: Include completed smoke-test-results.md as production pass gate
- [x] Task 13.7: Verify production deployment live and functional
- [x] Task 13.8: Tag release `v1.0.0-web`

---

## Sprint 14: Birth Bird Dashboard + Rahu Kaal + Nostril Chart ✅ Complete (PR #29)

- [x] Task 14.1: Birth bird state card on Home — show user's birth bird + current state + Tamil/English guidance text
- [x] Task 14.2: Full-day 5-yama schedule showing user's birth bird state per yama (color-coded: green/yellow/red)
- [x] Task 14.3: Rahu Kaal time window prominently displayed on Home
- [x] Task 14.4: Yama progress indicator (current yama, time remaining)
- [x] Task 14.5: Align27 bird state comparison row (show what Align27 would display — for 6-month validation)
- [x] Task 14.6: Favorability guidance per state (Ruling=act boldly, Eating=prepare, Walking=routine, Sleeping=avoid, Dying=hard stop)
- [x] Task 14.7: Nostril dominance chart — expected flow per yama, alignment status, next switch countdown
- [x] Task 14.8: Today's average hold time card on Home

---

## Sprint 15: Night Yamas + Full 24h View ✅ Complete (PR #33)

- [x] Task 15.1: Night yama calculations (sunset→sunrise divided into 5 equal segments)
- [x] Task 15.2: Night Pakshi state tables (authentic tables from Pulippani reference for night yamas 6-10)
- [x] Task 15.3: 10-yama full-day view (day + night in single scrollable timeline)
- [x] Task 15.4: Active state display works after sunset (currently shows nothing)
- [x] Task 15.5: Night-specific guidance text (meditation, sleep, spiritual practice timing)

---

## Sprint 16: iCloud Sync + macOS Target ✅ Complete (PR #39)

- [x] Task 16.1: CloudKit container setup + schema (profile, journal entries, streaks)
- [x] Task 16.2: Implement sync-on-open (pull remote changes when app launches)
- [x] Task 16.3: Push local changes to iCloud after each journal entry
- [x] Task 16.4: Primary device configuration in Settings (conflict resolution)
- [x] Task 16.5: Add Flutter macOS target + verify build
- [x] Task 16.6: Test sync across iPhone SE ↔ iPad Mini ↔ iMac (macOS)

---

## Sprint 17: Notifications + Daily Engagement ✅ Complete (PR #41)

- [x] Task 17.1: Implement real local notifications (iOS + macOS) at yama transitions
- [x] Task 17.2: "Your bird is now Ruling" notification with guidance text
- [x] Task 17.3: Configurable notification preferences (which states to notify)
- [x] Task 17.4: Morning daily summary notification (today's best times)
- [x] Task 17.5: Rahu Kaal start/end notification
- [x] Task 17.6: Tamil wisdom library (locale-aware Daily Wisdom content)

---

## Sprint 18: Historical View + Planning ✅ Complete (PR #44)

- [x] Task 18.1: Date picker on Home — view any past date's Pakshi schedule
- [x] Task 18.2: Tomorrow's schedule view (plan ahead)
- [x] Task 18.3: "Best times this week" — scan next 7 days for Ruling yamas
- [x] Task 18.4: Journal entries linked to historical dates (retrospective view)
- [x] Task 18.5: Calendar month view with entry indicators

---

## Sprint 19: Analytics + Export ✅ Complete (PR #46)

- [x] Task 19.1: Weekly alignment summary (% aligned per week)
- [x] Task 19.2: Monthly patterns view (best days, worst days, most active yamas)
- [x] Task 19.3: CSV export of journal data
- [x] Task 19.4: Streak insights (longest, current, average gap between entries)
- [x] Task 19.5: Yama performance breakdown (which yama do you practice most/least)
- [x] Task 19.6: Hold time progression — averages per day/week/month/year, trend line chart, personal best

---

## Sprint 20: UI Polish + Home Layout Redesign ✅ Complete (PR #51)

- [x] Task 20.1: Split Home into two sub-tabs: "Today" (default) and "Explore"
- [x] Task 20.2: Today tab — focused 7 cards (Bird, Rahu, Schedule, Nostril, Wisdom, Hold+Streak, Ribbon)
- [x] Task 20.3: Explore tab — Date Selector, Calendar Month, Historical Entries, Best Times, 30-Day Trend
- [x] Task 20.4: Responsive two-column layout consistency audit (all screens ≥600px)
- [x] Task 20.5: Remove redundant widgets from Today tab (Date Selector, Calendar, Yama Accuracy)
- [x] Task 20.6: Full data export/import in Settings (JSON file — all tables + preferences)

---

## Sprint 21: Pakshi Accuracy (DOB-Based Calculation) ✅ Complete (PR #54)

- [x] Task 21.1: Moon longitude calculator — Pure Dart (Jean Meeus ELP 2000/82)
- [x] Task 21.2: Lahiri Ayanamsa calculator — sidereal correction for given date
- [x] Task 21.3: Nakshatra from DOB — Moon sidereal longitude → nakshatra index (0–26)
- [x] Task 21.4: Enhanced onboarding — add DOB date + time fields, merge into 4-step flow with dual-path "Find Your Bird" UI
- [x] Task 21.5: Auto-calculate vs manual — SegmentedButton toggle ("I know my star" / "Calculate from DOB") + keep manual fallback
- [x] Task 21.6: Extended birth bird attributes — friends, enemies, ruling planet, direction, colour

---

## Sprint 22: Widget Test Coverage + Web Polish ✅ Complete (PR #56)

- [x] Task 22.1: BirthBirdCard widget test
- [x] Task 22.2: RahuKaalCard widget test
- [x] Task 22.3: FullDaySchedule widget test
- [x] Task 22.4: NostrilDominanceChart + HoldTimeCard widget tests
- [x] Task 22.5: StreakFlameWidget + TrendWidget + SevenDayRibbonWidget tests
- [x] Task 22.6: YamaAccuracyWidget + WisdomCard widget tests
- [x] Task 22.7: Vercel COOP/COEP headers for Drift WASM (partial — console errors remain on preview, verify on staging)
- [x] Task 22.8: Custom flutter_bootstrap.js with useColorEmoji:true for emoji font preloading
- [x] Task 22.9: Two-tier CI strategy (ci.yml fast PRs, ci-full.yml on merge)
- [x] Task 22.10: Fix notification scheduler weekday conversion bug (Dart weekday → sun-based)

---

## Sprint 23: Product Polish — About, User Guide & Onboarding Intro ✅ Complete (PR #59)

- [x] Task 23.1: Pre-onboarding intro page (scrollable guide + "Get Started" button — shown before 4-step onboarding)
- [x] Task 23.2: About card in Settings (logo, version via package_info_plus, developer name/email/website, links)
- [x] Task 23.3: Add `package_info_plus` dependency + version provider
- [x] Task 23.4: User Guide screen (flat scrollable, pushed route from About — same content accessible post-onboarding)
- [x] Task 23.5: User Guide content — English (What is Saranidhi, The Science, Your Birth Bird, Daily Rhythm, How to Use, Best Practices, Dashboard Guide, Benefits, FAQ)
- [x] Task 23.6: Wire navigation: About → User Guide, About → Privacy Policy (url_launcher)
- [x] Task 23.7: Consistent dialog sizing — birth star + location edit popups use same AlertDialog pattern with adaptive height
- [x] Task 23.8: Tamil translation for About + Guide + Intro content (all new ARB keys)

---

## Sprint 24: UX Polish — Empty States, Loading & Error Handling ✅ Complete (PR #61)

- [x] Task 24.1: Journal empty state — friendly "get started" message with illustration when no entries exist
- [x] Task 24.2: Analytics empty state — guidance message when insufficient data for charts
- [x] Task 24.3: Dashboard loading state — skeleton/shimmer cards while data loads (first launch on web)
- [x] Task 24.4: Error boundary widget — catch and display friendly error messages instead of blank screens
- [x] Task 24.5: Explore tab empty state — message when no historical entries for selected date
- [x] Task 24.6: Streak zero-state improvement — motivational onboarding hint for new users

---

## Sprint 25: Performance, Accessibility & Smoke Test Refresh ✅ Complete (PR #63)

- [x] Task 25.1: Fix notification timezone — derive from profile location instead of hardcoded IST
- [x] Task 25.2: Keyboard/focus navigation for web (Tab traversal, Enter to submit on Journal)
- [x] Task 25.3: Semantic labels audit — verify all interactive widgets have proper Semantics for screen readers
- [x] Task 25.4: Haptic feedback on breath entry selection + timer tap (mobile, no-op on web)
- [x] Task 25.5: Lazy-load Explore tab data (defer night yama calc until tab is selected)
- [x] Task 25.6: Update `docs/manual-smoke-test.md` — slimmer critical-path version covering Sprints 14–24 (~55 scenarios)
- [x] Task 25.7: Restructure smoke test results — archive v1.0.0, create summary index, prepare v1.2.0 checklist

---

## Sprint 26: Daily Engagement & Delight ✅ Complete (PR #65)

- [x] Task 26.1: "What's New" screen on version update (shown once after app update, dismissible)
- [x] Task 26.2: Celebration animations — streak milestone celebrations (7, 30, 100 days)
- [x] Task 26.3: Breath timer presets (4-7-8, box breathing, custom patterns)
- [x] Task 26.4: Daily summary card at end of day (entries logged, alignment %, best yama)
- [x] Task 26.5: Pin/star favourite entries for quick reference
- [x] Task 26.6: Quick-log from notification — tap notification to pre-fill entry (mobile)

---

## Sprint 27: Layer 1 Gap Fixes — Diagnostic Foundation ✅ Complete (PR #68)

- [x] Task 27.1: Sushumna context-dependent alignment — ActionWindow enum (Artha/Kriya/Yoga), bird-state-to-window mapping, modified AlignmentChecker returns aligned only in Yoga window (Sleeping/Dying states)
- [x] Task 27.2: Guided nostril test — 3-step interactive modal (exhale test → isolation test → auto-populate flow selection) before manual logging
- [x] Task 27.3: Dynamic location on app open — GPS ping on mobile (2s timeout, 50km threshold to trigger update), web silently falls back to profile city
- [x] Task 27.4: Hora + Tattva display in Birth Bird card — subtle sub-row showing current planetary hour + active element cycle
- [x] Task 27.5: Reference table in User Guide — 27 nakshatras, 7 planets, 5 elements in English + Tamil + Sanskrit (always bilingual)
- [x] Task 27.6: Language switch in onboarding — EN/TA toggle at top-right corner of Intro + all 4 onboarding steps
- [x] Task 27.7: DOB recalculation from Settings — "Recalculate from DOB" option in profile section (reuses NakshatraCalculator)

---

## Sprint 27.5: Bugfix + UX Polish (Production Testing Fixes) — Complete (PR #78) ✅

- [x] Task 27.5.1: DB migration — `isPinned` column ALTER TABLE for existing installs
- [x] Task 27.5.2: Lunar phase hardcoded in AlignmentChecker → use `LunarPhaseCalculator.phaseForDate()`
- [x] Task 27.5.3: Birth bird swaps with lunar phase (waxing↔waning) — Vulture↔Peacock, Owl↔Rooster, Crow stays
- [x] Task 27.5.4: Kuligai Kaal calculation + display alongside Rahu Kaal
- [x] Task 27.5.5: Enhanced Rahu card (add sunrise/sunset + moon phase + Kuligai)
- [x] Task 27.5.6: Remove Align27 references from app UI (full day schedule row)
- [x] Task 27.5.7: Sushumna UX redesign — disable timer, show meditation advice, log as moment
- [x] Task 27.5.8: Reorder nostril buttons: Lunar (Left) → Sushumna (Both) → Solar (Right)
- [x] Task 27.5.9: Timer reset/cancel button during active phases
- [x] Task 27.5.10: Export: add app version + schema version to JSON
- [x] Task 27.5.11: Import: validate version before proceeding
- [x] Task 27.5.12: `AppConstants` class — centralize global app data
- [x] Task 27.5.13: Tattva display: "English / Sanskrit" format (EN + TA)
- [x] Task 27.5.14: "Best Times This Week" card not translated
- [x] Task 27.5.15: Calendar month view not translated to Tamil
- [x] Task 27.5.16: DOB calculation result text translation
- [x] Task 27.5.17: User Guide back button alignment (match Settings pattern)
- [x] Task 27.5.18: Monthly Patterns: hide "Needs Attention" if same as "Best Day"
- [x] Task 27.5.19: Create `docs/third-party-comparison.md` (bird state mapping + sources)

---

## Sprint 28: UI Polish + UX Consistency ✅ Complete (PR #95)

- [x] Task 28.1: Best Times card — reorder columns (Y# first, ⏰ time range, date last + "Today" badge right-aligned). Fixes Tamil column width issue.
- [x] Task 28.2: Journal history — show today's entries by default, expand older dates on tap (pagination/lazy load)
- [x] Task 28.3: DOB result text — translate "Calculated:" and "Moon sidereal longitude:" to Tamil + localized nakshatra/bird names
- [x] Task 28.4: Rahu card — add Emakandam (எமகண்டம்) calculator + reorder layout: Row1=Rahu Kaal, Row2=Kuligai+Emakandam, Row3=sunrise/sunset+moon phase, Row4=Tithi+Hora
- [x] Task 28.5: Rename "Today's Schedule" → "☀️ Day Schedule" (pairs with 🌙 Night Schedule)
- [x] Task 28.6: Analytics Yama Performance — "Yama 1" → "Y1" for consistency
- [x] Task 28.7: Explore tab — Rahu card height match Bird card (IntrinsicHeight + stretch)
- [x] Task 28.8: Best Times — day format change to "MMM d, EEE" (e.g., "Jul 12, Sat")
- [x] Task 28.9: Settings — move About card to bottom on narrow screens (after Clear All Data)

---

## Sprint 29: Foundation — Terminology, PWA, Tech Debt (v1.3.0) — Complete (PR #102) ✅

- [x] Task 29.1: Terminology l10n — map Siddha/Swarodaya standard terms (Ida/Idakalai, Pingala/Pingalai, Suzhumunai, Pakshi states) to ARB files from `docs/research/saranidhi-terminology-*.md`
- [x] Task 29.2: UI copy audit — update User Guide, tooltips, dashboard headers to match terminology standard
- [x] Task 29.3: User Guide — add Swara Pada Gamana (Grounding foot step rule) section
- [x] Task 29.4: User Guide — add Swara-Ahara (Dietary Chronobiology) section
- [x] Task 29.5: PWA manifest.json — update name, description, theme_color, background_color
- [x] Task 29.6: PWA icons — generate Saranidhi logo PNGs (192, 512, maskable) from SVG
- [x] Task 29.7: Widget test fix — resolve stream-based provider settling issue (un-skip navigation tests)
- [x] Task 29.8: DB migration strategy — replace try-catch with PRAGMA table_info() check

---

## Sprint 30: Action Windows Engine + UI (v1.3.0) — Complete (PR #104) ✅

- [x] Task 30.1: ActionWindowsEngine — yama-to-window consolidation algorithm (merge consecutive matching windows)
- [x] Task 30.2: ActionWindowSegment model — window type, start, end, birdStateName, duration, contains()
- [x] Task 30.3: Rahu Kaal guardrail — auto-block Artha/Kriya windows during Rahu (score clamp to 10%)
- [x] Task 30.4: Integrate into dashboardDataProvider — compute 24h consolidated segments
- [x] Task 30.5: 24h Action Bar widget — color-coded horizontal timeline (green=Artha, blue=Kriya, purple=Yoga, red=Blocked)
- [x] Task 30.6: Current Mode Focus Card — lifestyle recommendation ("Negotiate now" / "Rest and reflect")
- [x] Task 30.7: Expansion sheet — tap Focus Card → bottom sheet with raw Pakshi/Hora/Tattva details
- [x] Task 30.8: Today tab integration — Action Bar at top + Focus Card above existing cards
- [x] Task 30.9: Notification scheduling — 48h rolling queue using consolidated window boundaries
- [x] Task 30.10: Tamil translations for action window guidance text (bilingual notifications)
- [x] Task 30.11: Unit tests for ActionWindowsEngine (all bird states, Rahu overlap, consolidation)

---

## Sprint 31: Numerology + Oracle Engine + GPS (v1.4.0) — Complete (PR #115) ✅

- [x] Task 31.1: NameBirdParser — phonetic vowel-to-bird fallback (EN + Tamil Unicode)
- [x] Task 31.2: Integrate NameBirdParser into onboarding as tertiary fallback (DOB → Nakshatra → Name) — subtle "Use your name" link below DOB section
- [x] Task 31.3: TaraCategory enum — Navatara modulo-9 formula with multiplier weights (0.2–1.5x)
- [x] Task 31.4: HoraSwaraAffinity — planetary energy classification + alignment multiplier matrix
- [x] Task 31.5: OracleCompositeEngine — composite score: Base × Tarabala × Hora-Swara
- [x] Task 31.6: Category Harmony multipliers — Artha/Kriya/Yoga query vs active Action Window (1.2x–0.5x)
- [x] Task 31.7: Inauspicious windows floor lock — hard lock to 10% if Rahu Kaal OR Emakandam active (Kuligai excluded). Uses DaylightSegmentResolver octant lookup.
- [x] Task 31.8: GPS auto-location for web — `navigator.geolocation` API with permission prompt, update profile if >5km from stored location
- [x] Task 31.9: Unit tests for all Oracle calculators + NameBirdParser
- [x] Task 31.10: Nostril Pattern table — add yama timing column (match Day/Night schedule format)

---

## Sprint 32: Prasanam Oracle UI (v1.4.0) — Complete (PR #118) ✅

- [x] Task 32.1: PrasanamHistory Drift table + schema migration
- [x] Task 32.2: FAB on Today tab — oracle icon (🔮), launches Prasanam flow
- [x] Task 32.3: Query input screen — category selector (Artha/Kriya/Yoga) + free-text field + intention anchor animation
- [x] Task 32.4: 30-minute validation gate — check last journal entry recency, trigger GuidedNostrilTest if stale
- [x] Task 32.5: Oracle result card — score gauge + 5 answer bands (Strong Yes / Favorable / Caution / Delay / Hard No)
- [x] Task 32.6: Prasanam history timeline — on Prasanam screen, chronological past queries
- [x] Task 32.7: Post-event outcome notes — tap old query → add reflective notes
- [x] Task 32.8: Tamil translations for Prasanam UI + guidance text

---

## Sprint 33: Panja Pakshi Accuracy Fix (v1.4.1) — Complete (PR #126) ✅

> **Critical:** Birth bird derivation is wrong for ~50% of users (those born during Krishna Paksha).
> All downstream calculations (daily schedule, alignment, Oracle score) are affected.
> Source: Prof. Pulippani's dual-table system confirmed via vedastro.org + Align27 validation.

- [x] Task 33.1: Dual nakshatra→bird lookup tables — implement Bright Half + Dark Half tables per Pulippani (Chapter 2, Tables 1–2)
- [x] Task 33.2: Birth Paksha determination — compute lunar phase at DOB using `LunarPhaseCalculator.phaseForDate(birthDate)` to determine if user was born during Shukla or Krishna Paksha
- [x] Task 33.3: Correct birth bird derivation — use birth Paksha to select correct table (Bright or Dark), store permanent bird in profile
- [x] Task 33.4: Remove `birthBirdForPhase()` swap logic — bird identity is permanent, remove monthly swap from `dashboardDataProvider` and all references
- [x] Task 33.5: Onboarding update — when user selects nakshatra manually OR calculates from DOB, derive birth Paksha and use correct table. Show derived bird with Paksha context ("Your bird: Rooster (Krishna Paksha)")
- [x] Task 33.6: Existing user migration — on app load, if profile has DOB, recalculate bird using correct dual-table; if no DOB, keep existing bird (manual selection assumed correct)
- [x] Task 33.7: Nostril pattern — implement tithi-based starting nostril per Siva Swarodaya (Sutras 52–56): Shukla days 1-3 start Lunar, 4-6 start Solar, alternating; Krishna reverses
- [x] Task 33.8: Tarabala multiplier — integrate transit nakshatra lookup into Oracle composite engine (replace default 1.0)
- [x] Task 33.9: Unit tests — dual-table derivation, birth Paksha determination, nostril tithi logic, Tarabala calculations
- [x] Task 33.10: Update `docs/research/calculation-methodology.md` — mark issues as resolved, document new correct implementation
- [x] Task 33.11: Five Birds reference table (EN/Tamil/Sanskrit) added to User Guide

---

## Sprint 34: Somatic Intervention Engine (v1.5.0)

- [ ] Task 34.1: SomaticInterventionLogs Drift table + schema migration
- [ ] Task 34.2: SomaticInterventionSession model — type, targetFlow, initialFlow, success evaluation
- [ ] Task 34.3: Intervention Timer Rooms — full-screen Material 3 countdown (180s posture, 300s axillary)
- [ ] Task 34.4: Sama Vritti pacer animation (4:4:4:4 equal-ratio breathing guide)
- [ ] Task 34.5: Cross-lateral instruction cards (contralateral body positions per target flow)
- [ ] Task 34.6: Validation flow — auto-trigger GuidedNostrilTest on timer completion, log outcome
- [ ] Task 34.7: Integration with AlignmentChecker — show [Clear Breath Channel] action when blocked
- [ ] Task 34.8: Tamil translations for intervention UI

---

## Sprint 35: Chronobiology Analytics + Holistic Cards (v1.5.0)

- [ ] Task 35.1: ChronobiologyAnalytics — time-weighted sliding window stagnancy detection (≥6h mild, ≥8h chronic)
- [ ] Task 35.2: Dynamic Somatic Cards — Swara-Ahara dietary fire prompt on Kriya Focus Card
- [ ] Task 35.3: Tattva-Somatic Temperature Regulation tips (Sheetali for excess fire, Surya Bhedana for cold)
- [ ] Task 35.4: Swara Pada Gamana waking advice in morning summary notification
- [ ] Task 35.5: Dashboard stagnancy warning card (heating/cooling lifestyle recommendations)
- [ ] Task 35.6: Cognitive Energy Budgeting labels in Best Times / Explore tab (Artha/Kriya/Yoga activity suggestions)
- [ ] Task 35.7: Tamil translations for all holistic/somatic guidance text

---

## Sprint 36: v2.0.0 Release Polish & Integration Testing

- [ ] Task 36.1: End-to-end feature integration testing (all layers working together)
- [ ] Task 36.2: Performance optimization (startup time, animation smoothness)
- [ ] Task 36.3: Comprehensive smoke test plan for v2.0.0 (all features)
- [ ] Task 36.4: User Guide refresh — complete rewrite covering all v2.0 features
- [ ] Task 36.5: Wire Sprint 26 deferred widgets (WhatsNew startup, PresetSelector, StreakCelebration, isPinned star)

---

## Sprint 37: Panja Pakshi Accuracy Calibration & Validation

> **Prerequisite:** User collects 7-day Align27 data (Task 36.1) + Tamil Panchangam data (Task 36.2) BEFORE sprint starts.

- [ ] Task 36.1: Data Collection — capture 7 consecutive days of Align27 Pancha Pakshi states (all 10 yamas, times, moon phase) for Rooster/Pushya [USER TASK]
- [ ] Task 36.2: Data Collection — capture same 7 days from Tamil Panchangam (drikpanchang.com or physical calendar) [USER TASK]
- [ ] Task 36.3: Saranidhi Diagnostic Dump — generate matching 7-day output programmatically (bird states, sunrise/sunset, lunar phase, weekday)
- [ ] Task 36.4: Three-Way Comparison Matrix — align Saranidhi vs Align27 vs Panchangam, identify exact divergence points
- [ ] Task 36.5: Root Cause Diagnosis — determine if divergence is from (a) lookup tables, (b) lunar phase calculation, (c) weekday convention, (d) bird-phase swap timing
- [ ] Task 36.6: Calibration Fix — implement correction based on diagnosis (table update / phase logic / day-start convention)
- [ ] Task 36.7: Verification — re-run 7-day comparison after fix, confirm match with most authentic source
- [ ] Task 36.8: Document findings in `docs/research/accuracy-calibration.md`

---

## Sprint E2E: Automated End-to-End Testing (Backlog — based on time & situation)

- [ ] Task E2E.1: Set up Playwright (or equivalent) for Flutter Web E2E tests
- [ ] Task E2E.2: Automate critical path scenarios from smoke test (onboarding, log entry, streak)
- [ ] Task E2E.3: Integrate E2E tests into CI (run on merge to main)
- [ ] Task E2E.4: Visual regression snapshots for key screens

---

## Sprint X: App Store Prep & Submission (Deferred — Target ~Aug/Sep 2026)

- [ ] Task X.1: Set up Apple Developer + Google Play accounts
- [ ] Task X.2: App icon variants for all required sizes (iOS, macOS, Android adaptive)
- [ ] Task X.3: Splash/launch screen with branding (replace default white)
- [ ] Task X.4: Store screenshots generation guide (key screens in light+dark, EN+TA)
- [ ] Task X.5: Update `docs/store-listing.md` with final copy (EN + TA descriptions)
- [ ] Task X.6: Build release iOS + macOS + Android apps
- [ ] Task X.7: Submit for review
- [ ] Task X.8: Verify live + tag v1.0.0-mobile

---

[← Back to Root](../README.md)
