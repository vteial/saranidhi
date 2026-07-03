[← Back to Root](../README.md)

# Saranidhi — Development Sprint Tracker

---

## Sprint 0: Pre-Development & Project Initialization ✅

- [x] Task 0.1: Initialize Git repository with `main` branch and Flutter `.gitignore`
- [x] Task 0.2: Create Kiro steering files (`pr-workflow.md`, `saranidhi-spec.md`)
- [x] Task 0.3: Create `README.md` with project overview, name etymology, architecture, and tech stack
- [x] Task 0.4: Create `docs/project-plan.md` with full feature modules, data schema, and deployment architecture
- [x] Task 0.5: Create `docs/release-1.0-plan.md` with sprint-to-release mapping and milestones
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
- [x] Task 11.5: Revise `docs/release-1.0-plan.md` — updated sprint mapping (11–14), move cloud backup/auth to 1.1
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

## Sprint 18: Historical View + Planning (Current Sprint)

- [ ] Task 18.1: Date picker on Home — view any past date's Pakshi schedule
- [ ] Task 18.2: Tomorrow's schedule view (plan ahead)
- [ ] Task 18.3: "Best times this week" — scan next 7 days for Ruling yamas
- [ ] Task 18.4: Journal entries linked to historical dates (retrospective view)
- [ ] Task 18.5: Calendar month view with entry indicators

---

## Sprint 19: Analytics + Export

- [ ] Task 19.1: Weekly alignment summary (% aligned per week)
- [ ] Task 19.2: Monthly patterns view (best days, worst days, most active yamas)
- [ ] Task 19.3: CSV export of journal data
- [ ] Task 19.4: Streak insights (longest, current, average gap between entries)
- [ ] Task 19.5: Yama performance breakdown (which yama do you practice most/least)
- [ ] Task 19.6: Hold time progression — averages per day/week/month/year, trend line chart, personal best

---

## Sprint X: App Store Submission (Deferred — Target ~Aug/Sep 2026)

- [ ] Task X.1: Set up Apple Developer + Google Play accounts
- [ ] Task X.2: Build release iOS + macOS app
- [ ] Task X.3: Build release Android app (if needed)
- [ ] Task X.4: Screenshots + store listing submission (see docs/store-listing.md)
- [ ] Task X.5: Submit for review
- [ ] Task X.6: Verify live + tag v1.0.0

---

[← Back to Root](../README.md)
