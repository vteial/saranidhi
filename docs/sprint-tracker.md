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

## Sprint 8: Theming, i18n & Polish (Current Sprint)

- [ ] Task 8.1: Finalize Material 3 theme variants (Light, Dark, Emerald, Gold)
- [ ] Task 8.2: Implement theme persistence (shared_preferences)
- [ ] Task 8.3: Set up ARB localization files (English + Tamil)
- [ ] Task 8.4: Translate all user-facing strings to Tamil
- [ ] Task 8.5: Add smooth page transitions and micro-animations
- [ ] Task 8.6: Responsive layout finalization (iPhone SE → iPad → Desktop)
- [ ] Task 8.7: Accessibility audit (semantic labels, contrast ratios, font scaling)
- [ ] Task 8.8: App icon generation (all platform sizes from logo SVG)

---

## Sprint 9: Testing & Hardening

- [ ] Task 9.1: Write unit tests for all domain layer logic (Astro-Engine, Streaks, AI context)
- [ ] Task 9.2: Write widget tests for core UI components (breath entry, timer, streak ribbon)
- [ ] Task 9.3: Write integration tests for full user flows (onboarding, log breath, view streak)
- [ ] Task 9.4: Write E2E smoke tests (app launch, navigate, log entry, verify persistence)
- [ ] Task 9.5: Performance profiling (app startup time, animation smoothness, DB query speed)
- [ ] Task 9.6: Fix all identified defects from testing
- [ ] Task 9.7: Verify offline functionality (airplane mode full flow)
- [ ] Task 9.8: Security review (no data leaks, encrypted backup verification)

---

## Sprint 10: Production Deployment

- [ ] Task 10.1: Create `prod` branch from `main`
- [ ] Task 10.2: Configure Cloudflare Pages for web production deployment
- [ ] Task 10.3: Prepare App Store listing (screenshots, description, keywords, privacy policy)
- [ ] Task 10.4: Prepare Play Store listing (screenshots, description, keywords, privacy policy)
- [ ] Task 10.5: Submit iOS app for App Store review
- [ ] Task 10.6: Submit Android app for Play Store review
- [ ] Task 10.7: Configure production CI/CD workflow with manual approval gate
- [ ] Task 10.8: Verify all platforms live and functional
- [ ] Task 10.9: Tag release `v1.0.0` on `prod` branch

---

[← Back to Root](../README.md)
