[← Back to Root](../../README.md)
[← Back to Root](../../README.md)

# Saranidhi — Development Sprint Tracker

> **Reviewed:** v1.9.0-web · **Next review:** every release (docs-audit gate).

Tracks delivery as a sequence of sprints. **Completed and in-progress** sprints
live here; **candidate / future** work lives in the
[Sprint Backlog](sprint-backlog.md). Each sprint carries a **Delivery Checklist
(Definition of Done)** — see the template below.

> Legend: ✅ Done · 🔄 In progress · ⬜ Not started · 🚀 Released

---

## Sprint Overview

Owner: **Eialarasu (@vteial)** for all sprints (solo, AI-assisted via Kiro).

| Sprint | Theme | Release | Status |
| :-- | :-- | :-- | :--: |
| 0 | Pre-Development & Project Init | — | ✅ |
| 1–13 | Scaffold → Core Pakshi engine → Web production | v1.0.0-web | ✅ |
| 14–19 | Daily value, multi-device (iCloud), engagement, analytics | v1.1–v1.2 | ✅ |
| 20–27 | Home redesign, Sara Kalai accuracy, polish, Sushumna/Hora/Tattva | v1.2.x | ✅ |
| 28–29 | Layer 2 — Action Windows engine + UI | v1.3.0 | ✅ |
| 30–32 | Numerology + Prasanam Oracle | v1.4.0 | ✅ |
| 33 | Panja Pakshi Accuracy Fix (dual-table birth bird) | v1.4.1 | ✅ |
| 34 | Migration + Onboarding UX Polish | *(bundled)* | ✅ |
| 35 | Somatic Intervention Engine | **v1.5.0** | ✅ 🚀 |
| 36 | Stability & Test Hardening | **v1.6.0** | ✅ 🚀 (PR #141) |
| 37 | Birth-Bird Engine Correction | **v1.7.0** | ✅ 🚀 (PR #167) |
| 38 | ★ Integrated Aruḍam — Slice 1 (ambient "Aruḍam Now" verdict) | **v1.8.0** | ✅ 🚀 (PR #181) |
| 39 | ★ Integrated Aruḍam — "Why?" provenance accordion | **v1.9.0** | ✅ 🚀 (PR #196) |
| 40 | Chronobiology & Holistic Guidance | **v1.10.0** | ⬜ (planned) |
| 41+ | v2.0 polish, accuracy calibration, native "Now" surface, E2E, App Store | *see [backlog](sprint-backlog.md)* | ⬜ |

> **Current state:** **v1.9.0-web is now live in production (2026-09-12)** — Sprint 39,
> the flagship's verdict-transparency **"Why?" provenance accordion** on the "Aruḍam Now"
> card (feature PR #196 → release-start PR #199 → main→prod promotion PR #200, tag
> `v1.9.0-web` @ `prod`; smoke test ✅ PASS 6/6 + regression on the PR preview). It explains
> the verdict doctrinally — reasons grouped **Moment / You** (or **Blocked**), each citing
> the corpus practice + CONF it rests on; no raw math, no tooltips, bilingual EN/TA;
> **transparency-only** (scoring / bands / floor-lock / Oracle unchanged). The preceding
> feature release **v1.8.0-web** (Sprint 38 — Integrated Aruḍam Slice 1) shipped the
> always-on **"Aruḍam Now"** ambient verdict card (Moment × Readiness over a shared
> `IntegratedArudamEngine`), the natural-vs-forced framing, and the 24h-correct inauspicious
> floor-lock; **v1.8.1-web** was a Tamil-l10n hotfix. Both corpora (Sara Kalai, Panja Pakshi)
> remain fully CONF-resolved.
> **Phase 2b continues** — **Sprint 39** (Integrated Aruḍam "Why?" provenance accordion,
> v1.9.0) and **Sprint 40** (Chronobiology & Holistic Guidance, v1.10.0) are now
> **scheduled** via `/plan` (this PR); both are unblocked feature work. Deferred after
> them: accuracy calibration (7-day 3-way comparison, **blocked on owner data collection**,
> to be collected during the planned ~10-day Saranidhi pause) and the native "Now" surface.

> **Historical note (Sprints 1–7).** Early sprints predate the one-PR-per-sprint
> workflow and were merged via a mix of direct commits and early PRs; a clean
> PR-per-sprint mapping does not exist for them. Recorded honestly rather than
> back-filled.

---

## Delivery Checklist (Definition of Done)

Every sprint from Sprint 28 onward carries this checklist. Copy it per sprint:

```markdown
**Delivery Checklist:**
- [ ] **Code merged** — on `main` (PR #N).
- [ ] **PR link** — #N (CI green: Analyze/Fast Tests/Build).
- [ ] **Docs updated** — user-guide / calc-methodology / relevant docs.
- [ ] **Tests** — unit/widget suite green; new tests for new logic.
- [ ] **Smoke test** — scenarios added to the next `smoke-test-v*.md`.
- [ ] **Valuation report** — sprint row added (+20% over AI-estimated time).
- [ ] **Tracker updated** — status ✅.
```

> **Epic-boundary rule:** stakeholder-facing docs (User Guide, valuation) are
> updated when a sprint delivers a real capability shift; internal-only sprints
> mark them `n/a` with a one-line reason.

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

## Sprint 34: Migration + Onboarding UX Polish — Complete (PR #131) ✅ — bundled into v1.5.0

> **Note:** Merged to `main`/staging but NOT released as a standalone v1.4.2.
> Bundled with Sprint 35 into a single **v1.5.0** release (owner decision). The prior
> "v1.4.2" label is retained only in `smoke-test-v1.4.2.md` (scenarios carried into v1.5.0).

> Clears the UX/migration backlog from v1.4.0/v1.4.1 preview + prod testing.
> Leads with the missing auto-recalculation (Task 33.6 was never actually implemented).

- [x] Task 34.1: Auto-recalculate birth bird on app load — if profile has `birthDateEpoch`, recompute via `birthBirdFromNakshatraAndPaksha()` and update if different from stored value. Show a one-time notice ("Your bird has been updated to {Bird} based on corrected calculations") when a change occurs. *(`BirdMigrationService` + `birdMigrationProvider` + `BirdMigrationOnLoadWidget` wired into main.dart.)*
- [x] Task 34.2: Onboarding — 3 equal-weight tabs: "I know my star" / "Calculate from DOB" / "Calculate from name" (promote NameBirdParser from subtle link to co-equal tab)
- [x] Task 34.3: Onboarding — summary confirmation page: shows name, derived bird (+ how it was derived: nakshatra/DOB/name), location, storage mode. Each row has "Edit" to jump back; final "Complete Setup" button. *(New step 4; totalSteps 4→5; `goToStep()`.)*
- [x] Task 34.4: GuidedNostrilTest — add reset/restart button + reorder buttons to anatomical order: Lunar (Left) → Sushumna (Both) → Solar (Right)
- [x] Task 34.5: Oracle history — desktop delete: trash icon on hover (mouse), keep swipe-to-delete for touch. Both trigger same confirmation dialog.
- [x] Task 34.6: Wire WebGeolocation into app startup — call `WebGeolocation.getCurrentPosition()` on app open (web), update profile location if >5km from stored. Graceful fallback if permission denied. *(Conditional-export facade `geolocation.dart` + stub keeps mobile builds clean; `LocationOnOpenService`/`Widget`.)*
- [x] Task 34.7: Unit tests (`location_service_test.dart`; auto-recalc + name-path derivation already covered by existing pakshi/oracle tests) + updated calculation-methodology.md / user-guide.md for onboarding + location changes

**Preview-testing fixes (folded into PR #131):**
- [x] Localized the DOB tab's IST-assumption note (`onboardingIstAssumption`, EN + TA) — was a hardcoded English string.
- [x] Gated onboarding **Complete Setup**: added `OnboardingState.isComplete` (requires birth bird + current location); button disabled until complete, summary shows a warning banner naming what is missing.

**Deferred / follow-up (NOT in PR #131):**
- [ ] Task 34.8: Geolocation-first Location step — on web, attempt browser geolocation first with the **city picker as fallback** on denial/unavailable; keep the >5 km auto-update **silent**. Mobile/desktop keep the picker as source of truth. (Owner-confirmed strategy.)
- [ ] Deferred manual verification: Task 34.1 auto-recalc (owner to test later).

---

## Sprint 35: Somatic Intervention Engine (v1.5.0) — Complete (PR #132) ✅ — 🚀 Released v1.5.0-web (2026-09-04)

> **Released:** v1.5.0-web shipped to production 2026-09-04 (tag `v1.5.0-web`),
> bundling Sprint 34 + Sprint 35. Promotion PRs: #133 (release/v1.5.0→main),
> #134 (main→prod). Two CI fixes were needed during release: #135 (coverage
> gate 19%→18%) and #136 (web integration tests made non-blocking — flaky +
> stale; fate to be decided in a planning session).

> **Release batching decision (owner-approved):** Sprint 34 (was v1.4.2) and Sprint 35
> are bundled into a **single v1.5.0 release**. Sprint 34 is already merged to `main`/staging
> but NOT released separately — v1.4.2 does not ship on its own. One combined smoke test on
> staging covers BOTH sprints (Sprint 34 deferred items + all of Sprint 35), then one
> `/release-start` → `/release-finish` cycle for v1.5.0. Batch capped at two sprints.
>
> **Smoke-test structure:** carry the `smoke-test-v1.4.2.md` scenarios (34.1 auto-recalc still
> to be verified) forward into `smoke-test-v1.5.0.md`, appended with Sprint 35 sections.
> **CRITICAL gate:** Task 35.1 schema migration must be smoke-tested for BOTH fresh install
> and upgrade-from-existing-profile (migration is historically the highest-risk area).
>
> **Spec reference:** `docs/research/advanced_somatic_mastery.md` §1 + §3 (fully specified —
> Dart domain models, Drift schema, cross-lateral mapping table, timer durations, state machine).

- [x] Task 35.1: SomaticInterventionLogs Drift table + schema migration *(schema v4→5; idempotent onUpgrade checks sqlite_master; SomaticInterventionRepository)*
- [x] Task 35.2: SomaticInterventionSession model — type, targetFlow, initialFlow, success evaluation *(+ CrossLateralMapping, BodySide, InterventionType durations)*
- [x] Task 35.3: Intervention Timer Rooms — full-screen Material 3 countdown (180s posture, 300s axillary) *(SomaticTimerRoom)*
- [x] Task 35.4: Sama Vritti pacer animation (4:4:4:4 equal-ratio breathing guide) *(SamaVrittiPacer)*
- [x] Task 35.5: Cross-lateral instruction cards (contralateral body positions per target flow) *(CrossLateralInstructionCard)*
- [x] Task 35.6: Validation flow — auto-trigger GuidedNostrilTest on timer completion, log outcome *(wired in SomaticTimerRoom._onCompleted → repo.insertLog)*
- [x] Task 35.7: Integration with AlignmentChecker — show [Clear Breath Channel] action when blocked *(AlignmentResultWidget + InterventionSelectorSheet)*
- [x] Task 35.8: Tamil translations for intervention UI *(19 keys EN+TA, parity + no mixed-script verified)*
- [x] Task 35.9: Unit tests (SomaticInterventionSession domain) + user-guide.md feature section + spec status update

---
## Sprint 36: Stability & Test Hardening (v1.6.0) — ✅ Shipped v1.6.0-web (PR #141)

> **Goal:** pay down the CI/testing debt exposed during the v1.5.0 release before
> adding new features — so the product and its quality signals are trustworthy.
> No new user-facing features; this is a hardening release. Priority-ordered.

- [x] Task 36.1: **Fix + re-gate the in-repo web integration tests.** Repair the two failing tests — the onboarding-launch `ConnectionClosedException` (ChromeDriver stability) and the stale dashboard assertion (`"Last 7…"` / current UI) — then remove `continue-on-error` so `Integration Tests (Web)` is a trustworthy gate again. *(Migration to the Playwright E2E repo is deferred to a future decision.)* → `app_test.dart` stabilized (stable `pump()`, stale assertion dropped, nav test un-skipped); `ci-full.yml` `continue-on-error` removed + bounded ChromeDriver readiness poll. *(Integration job runs on `push:[main]` / `pull_request:[prod]` — validated at merge + prod promotion.)*
- [x] Task 36.2: **Un-skip the navigation widget test** (`test/widget_test.dart:109`, `skip: true`) — fix the stale `"3 days"` assertion and use a stable `pump()` pattern (no `pumpAndSettle` with stream providers), then remove the skip. → done; un-skipped and green in CI Fast (Tier 1).
- [x] Task 36.3: **DB migration existence-check helper.** Add a small, unit-tested utility (e.g., `tableExists` / `columnExists` via `PRAGMA`/`sqlite_master`) to replace the ad-hoc per-migration checks; refactor existing migrations onto it. Addresses the #1 historical failure class (v1.2.1). → `lib/database/migration_helpers.dart` + `onUpgrade` refactor + `test/database/migration_helpers_test.dart`.
- [x] Task 36.4: **Deep-verify auto-recalc (Task 34.1) on the existing-profile upgrade path** + add a regression test proving an old-logic profile is corrected on load (and a no-DOB profile is left untouched). → `test/features/onboarding/bird_migration_service_test.dart` (corrected / untouched / idempotent / empty-DB).
- [x] Task 36.5: **Lift coverage + re-raise the gate.** Add unit/widget tests for the Sprint 35 somatic UI (timer room, pacer, selector, instruction card) to bring line coverage back to ≥19%, then raise `ci-full.yml` `THRESHOLD` 18 → 19. → 5 somatic tests added; gate raised 18 → 19. *(Coverage % is validated by the full-suite job on `push:[main]`.)*
- [x] Task 36.6: **Geolocation-first onboarding (Task 34.8).** On web, try browser geolocation first on the Location step with the city picker as fallback; keep the >5 km auto-update silent. Mobile/desktop keep the picker as source of truth. → `onboarding_screen.dart` location step; city-picker fallback preserved; +4 EN/TA l10n keys.
- [ ] Task 36.7: **Housekeeping** — backfill the missing `v1.4.1-web` git tag. → **prepared for owner** (tag `v1.4.1-web` @ `bc959c0`); Kiro does not create tags.

**Delivery Checklist (Definition of Done):**
- [x] **Code merged** - on `main` (PR #141). _(owner/orchestrator - Kiro cannot merge)_
- [x] **PR link** - [#141](https://github.com/vteial/saranidhi/pull/141) (CI Fast green: Analyze / Tier 1 tests 403 passing / Build web; full-suite coverage 18→19 + re-gated integration tests validated on merge-to-main / prod promotion). _(owner/orchestrator)_
- [x] **Docs updated** - dev-workflow Lessons/Gotchas (DB migration existence-check helper, integration-test fix + re-gate), any relevant docs.
- [x] **Tests** - full suite intended green; skipped navigation test un-skipped; new migration-helper + auto-recalc + somatic-UI tests added (CI is the authoritative gate).
- [x] **Smoke test** - verification scenarios added to `smoke-test-v1.6.0.md` (existing-profile upgrade auto-recalc + onboarding geolocation-first + migration idempotency + regression).
- [x] **Valuation report** - Sprint 36 row added (+20% over AI-estimated time).
- [x] **Tracker updated** - status ✅. _(owner/orchestrator - flips only on merge)_
- [x] **User Guide** - `n/a`: internal hardening sprint with no user-facing capability change, so there is nothing new to document for end users (per the epic-boundary rule).

> **Epic-boundary rule:** internal hardening sprint — User Guide update is `n/a`
> (no user-facing capability change); reasoning noted in the checklist above.

---

## Sprint 37: Birth-Bird Engine Correction (v1.7.0) — ✅ Complete (PR #167)

> **Goal:** correct a **live calculation error** in the shipped Panja Pakshi engine —
> the birth-bird derivation — surfaced by the Panja Pakshi corpus audit and
> owner-adjudicated in **CONF-PP-001…005**. The shipped `PakshiCalculator` uses a
> Pulippani 5-5-5-5-7 nakshatra partition and a dual bright/dark table; the
> lineage-unanimous truth is **5-6-5-5-6** with a **single permanent birth-star
> table**. This mis-assigns the birth bird (and therefore every downstream state,
> yama, and oracle result) for real users. Correctness release; no new features.
>
> **Process:** per the confirmed division of labor, **the implementation is done in
> the Antigravity IDE coding setup** (Saranidhi local dev; local `flutter test`/`analyze` before PR);
> **Kiro Web authored the spec** ([`docs/process/sprints/sprint-37-birth-bird/spec.md`](sprints/sprint-37-birth-bird/README.md))
> and will **review the resulting PR**. Bird calc is correctness-critical → local
> green test run is required before it ships (v1.2.1 lesson).

- [x] Task 37.1: **CONF-PP-001 — nakshatra partition 5-5-5-5-7 → 5-6-5-5-6.** Update the bright/single table in `pakshi_calculator.dart` so Pooram/Purva Phalguni → Owl, Visakam/Vishakha → Crow, Uthiradam/Uttara Ashadha → Rooster. (See spec §2.)
- [x] Task 37.2: **CONF-PP-002 — single permanent birth-star table.** The known-birth-star path uses ONE permanent (Valarpirai) table — no Krishna reverse-swap. Neutralize `birthPaksha` in `birthBirdFromNakshatraAndPaksha`; retire/collapse the dark table for the birth-star path. (Spec §3.)
- [x] Task 37.3: **Name-initial fallback carries the paksha swap.** Add `birthBirdFromNameInitialAndPaksha(initial, paksha)` — the waxing/waning bird split applies ONLY to the name-initial (Nama Pakshi) path, per lineage. Wire it as the fallback when both nakshatra and DOB are unknown. (Spec §4.)
- [x] Task 37.4: **Existing-user re-migration — cover ALL affected users.** The wired `BirdMigrationService` already re-derives DOB-based profiles on load; **extend it to also correct manual "known-star / no-DOB" profiles** (owner decision: re-migrate them via the corrected single table — the old bird is simply wrong). Add regression tests for both paths + idempotency. (Spec §5.)
- [x] Task 37.5: **CONF-PP-003 — friend/enemy matrix** in `pakshi_attributes.dart` → unified: Vulture allies Peacock+Owl, enemies Crow+Rooster (etc., full table in spec §6).
- [x] Task 37.6: **CONF-PP-004 — ruling planets** → Vulture=Jupiter, Owl=Venus, Crow=Mars, Rooster=Mercury, Peacock=Saturn (+ dependent colour associations). (Spec §6.)
- [x] Task 37.7: **CONF-PP-005 — cardinal directions** → phase-dependent (Valarpirai/Theipirai sets), replacing the static assignments. (Spec §6.)
- [x] Task 37.8: **Tests + docs.** Update `pakshi_calculator_test`, `pakshi_attributes_test`, `onboarding_test`, `bird_migration_service_test` to the corrected values; add the 3 disputed-star cases (Pooram→Owl, Visakam→Crow, Uthiradam→Rooster) + owner's Pushya/Krishna→**Owl** case; refresh `calculation-methodology.md` §1 and cross-link the CONF-PP resolutions.

> **Deferred:** CONF-PP-006 (dual equal/weighted sub-yama modes + settings toggle) — it is a **new user-facing option**, not a correction; scheduled to a later sprint to keep v1.7.0 a tight correctness release.

**Delivery Checklist (Definition of Done):**
- [x] **Code merged** — on `main` (PR #167). _(owner/orchestrator — Kiro cannot merge)_
- [x] **PR link** — [#167](https://github.com/vteial/saranidhi/pull/167) (CI green: Analyze / Fast Tests / Build + Full Suite; local run 546 pass / 4 known-CloudKit baseline, analyze clean, `build web` clean). Implemented in the Antigravity IDE coding setup; Kiro Web reviewed (incl. Antigravity source-verification of the name-initial waning 5-cycle — exact match to workshop + master book).
- [x] **Docs updated** — `calculation-methodology.md` §1 rewritten to 5-6-5-5-6 + single permanent table; CONF-PP cross-links.
- [x] **Tests** — corrected derivation + 3 disputed stars + Pushya/Krishna→Owl + re-migration (DOB & manual paths) + idempotency; local green before PR (macOS baseline = same 4 known CloudKit failures and no others).
- [x] **Smoke test** — scenarios in `releases/v1.7.0/smoke-test.md`: existing Pushya/Krishna user sees bird change Cock→Owl on load; manual-star user corrected; onboarding new user gets 5-6-5-5-6 bird.
- [x] **Valuation report** — Sprint 37 row added (+20% over AI-estimated time).
- [x] **Tracker updated** — status ✅ (this update).
- [x] **User Guide** — update the birth-bird section (corrected partition; note existing users may see a one-time corrected bird) — real capability/accuracy change, so **not** `n/a`.

> **Migration note (v1.4.1 lesson):** this changes existing users'' stored birth
> bird. The on-load `BirdMigrationService` must re-derive on app open (not rely on
> manual "Recalculate from DOB"), and Task 37.4 extends it to the manual/no-DOB
> profiles too. Test the existing-user UPGRADE path explicitly, not just fresh
> onboarding.

---

## Sprint 38: Integrated Aruḍam — Slice 1 (v1.8.0) — ✅ 🚀 Shipped v1.8.0-web (PR #181)

> **Goal:** ship the first slice of the flagship **[★ Integrated Aruḍam](sprint-backlog.md#-flagship--integrated-aruḍam)**
> epic — an **always-on "Aruḍam Now" verdict card on Home** that fuses the separate
> engines (Sara Kalai swara × Panja Pakshi bird-state × Hora/Tarabala × inauspicious
> windows) into ONE answer to *"is now a good moment, and what should I do?"*.
> Scoring = **Moment × Readiness** (Moment sets the ceiling; breath is a readiness
> multiplier — aligned ~1.0 / misaligned ~0.75, **never a floor-lock**). Owner-confirmed
> in the Phase-2b `/plan` (PR #179).
>
> **North Star:** the app cultivates **natural** alignment as a lifelong practice — it
> never sells shortcuts. Forced shifting is **urgency-only + warning-toned**; the app
> must never present it as the "fix"/success path.
>
> **Process:** spec → coding-setup → review (Kiro Web authors the spec + reviews;
> Antigravity IDE implements + local green before PR). **Correctness-critical:** Task
> 38.3 touches shipped calculation logic (`DaylightSegmentResolver`) → local `analyze`
> + full `flutter test` green before the PR is required (v1.2.1 lesson), and the
> refactor must be **behavior-preserving for existing day-time Oracle verdicts**.
>
> **Engine reality:** the fusion is ~80% already built inside `OracleCompositeEngine`
> but trapped in the Oracle screen (pull-only); `dashboardDataProvider` already
> assembles every ingredient 24h. So most of this slice is **extraction + wiring + one
> card**, plus the night floor-lock fix.

- [x] Task 38.1: **Extract `IntegratedArudamEngine`** from `OracleCompositeEngine` so the composite fusion (bird-state × Tarabala × Hora-Swara × category) is callable from the dashboard, not only the Oracle screen. Reuse the existing bands (Siddha/Vardhana/Mandha/Stambhana/Sunya) + bilingual guidance. **Behavior-preserving:** the Oracle keeps producing identical verdicts through the extracted engine.
- [x] Task 38.2: **Fuse breath-alignment as the Readiness multiplier** (Moment × Readiness): wire `AlignmentChecker`'s result into the score — aligned → ~1.0, misaligned → ~0.75 (uniform for v1; tuned later via Accuracy Calibration), Sushumna → existing Yoga-context rule. Never a floor-lock.
- [x] Task 38.3: **24h-correct the inauspicious floor-lock** — replace/extend the day-only `DaylightSegmentResolver` path so Rahu/Emakandam (and night equivalents) gate correctly after sunset. **Regression-critical** (see DoD).
- [x] Task 38.4: **Ambient "Aruḍam Now" verdict card on Home** — always-on, reads `dashboardDataProvider`, shows band + the **two-clock plain-language breakdown** (Moment: bird/Hora · You: aligned?). Honest-but-partial when swara is stale (reuse the confirmed staleness rule — degrade to "expected + check", never fabricate a match).
- [x] Task 38.5: **Natural-vs-forced framing** — misalignment default guidance = *wait / accept / note*; forced-shift only behind a secondary, **warning**-toned "Urgent?" affordance ("depleting; an exception, not a habit"); language never promises success (CONF-016/017: a nudge, not a guarantee). Loop ends with "re-check", not "done".
- [x] Task 38.6: **Reward natural alignment — flag only (analytics rework deferred).** Add the data flag distinguishing force-shifted sessions so they are **not** rewarded as natural alignment. Scope = design + persist the flag; the full streak/analytics rework is a fast-follow, not this sprint.
- [x] Task 38.7: **Bilingual (EN/TA) verdict states + framing**, keeping the sacred tone.

> **Explicitly out of scope (named fast-follows, not this slice):** the "Why?"
> provenance accordion; native ambient surface (widget/watch/macOS); calendar-aware
> proactive nudge; tuning the 0.75 penalty via the 7-day 3-way comparison; the full
> streak/analytics natural-alignment rework.

**Delivery Checklist (Definition of Done):**
- [x] **Code merged** — on `main` (PR #181, merge `d83347d`). _(owner merged — Kiro cannot merge)_
- [x] **PR link** — [#181](https://github.com/vteial/saranidhi/pull/181) (CI green pre-merge: Analyze / Fast Tests / Build + Full Suite + Integration; local run 564 pass / 4 known-CloudKit baseline / 0 regressions, analyze clean, web build clean). Implemented in the Antigravity IDE coding setup; **Kiro Web reviewed the real diff and APPROVED** (regression gate verified — Oracle day-time behavior preserved, alignment-feeds-score is the authorized Q2-A change, night floor-lock now gates).
- [x] **Regression gate (Task 38.3/38.1)** — **existing Prasanam Oracle day-time verdicts are UNCHANGED** by the engine extraction + floor-lock refactor (add/keep tests pinning current day-time scores), **AND** night verdicts now gate correctly (Rahu/Emakandam after sunset). Extraction refactors are exactly where behavior silently drifts — this must be proven, not assumed.
- [x] **Docs updated** — `calculation-methodology.md` (integrated verdict + Moment × Readiness + night floor-lock); User Guide gets the "Aruḍam Now" card + the natural-vs-forced philosophy.
- [x] **Tests** — `IntegratedArudamEngine` unit tests (Moment × Readiness math, misalignment penalty, Sushumna-in-Yoga, night floor-lock); Oracle-unchanged regression tests; verdict-card widget test; local green before PR.
- [x] **Smoke test** — scenarios authored for v1.8.0 (verdict card day + night; aligned vs misaligned; stale-swara degrade; forced-shift warning tone; EN/TA); relocated at `/release-start` to `docs/testing/releases/v1.8.0/smoke-test.md` (repo convention) and executed ✅ PASS.
- [ ] **Valuation report** — Sprint 38 row (+20%) — deferred to `/sprint-update`.
- [x] **Tracker updated** — status ✅ (this `/sprint-finish`).
- [x] **User Guide** — "Aruḍam Now" section + the natural-alignment philosophy — real capability change, so **not** `n/a`.

---

## Sprint 39: ★ Integrated Aruḍam — "Why?" Provenance Accordion (v1.9.0) — ✅ 🚀 Shipped (PR #196)

> **Shipped to production** as **v1.9.0-web** (2026-09-12, tag `v1.9.0-web` @ `prod`).
> Feature PR [#196](https://github.com/vteial/saranidhi/pull/196) (merge `8a7aa62`) →
> release-start PR #199 → main→prod promotion PR #200. Smoke test ✅ **PASS** (6/6 + regression
> eyeball + version confirm, on the PR #199 Vercel preview via the automation-bypass).
> Antigravity implemented + local green (573 pass / 4 known-CloudKit / 0 other);
> **Kiro Web reviewed the real diff and approved** — behavior-preserving (zero test-assertion
> deletions), full EN/TA parity (pure Tamil script), doctrinal copy honors the North Star.
> Release dossier: [`docs/testing/releases/v1.9.0/`](../testing/releases/v1.9.0/README.md).

> **Dossier:** [`sprints/sprint-39-why-accordion/`](sprints/sprint-39-why-accordion/README.md)
> ([spec](sprints/sprint-39-why-accordion/spec.md)). A named **fast-follow** of the flagship
> [★ Integrated Aruḍam](sprint-backlog.md#-flagship--integrated-aruḍam) epic — it delivers
> the **verdict-transparency** promise slice 1 (Sprint 38) deliberately deferred.
>
> **What:** a tap-to-expand **"Why?"** accordion on the always-on "Aruḍam Now" verdict card
> that explains the verdict **doctrinally, in plain language, with provenance** — each
> contributing factor cites the corpus practice + CONF id it rests on. Owner-confirmed rules:
> **no raw math, no tooltips**, **collapsed by default**, bilingual EN/TA.
>
> **Process:** spec → coding-setup → review (Kiro Web authors + reviews; Antigravity IDE
> implements + local green before PR). **Transparency sprint, not a scoring sprint** — the
> scoring math, bands, and floor-lock are untouched (behavior-preserving; see DoD).

- [x] Task 39.1: **Add a structured factor breakdown to the engine result** — `ArudamFactor` enum + `FactorStrength` + `ArudamReason{factor, strength, conf}`; add a `List<ArudamReason> reasons` field to `IntegratedArudamResult`, built inside `evaluate()` from the factors already computed there. **Behavior-preserving:** one new field only; no existing field changes; Oracle path unaffected.
- [x] Task 39.2: **Provenance/citation source of truth** — each `ArudamReason` carries its CONF id (bird-state → CONF-PP-004, hora-swara → CONF-014, tarabala → CONF-PP-001/002, harmony → CONF-015, readiness → CONF-016/017, Sushumna → CONF-026, floor-lock → CONF-018). Documented in the engine (data = source of truth), not duplicated in the widget.
- [x] Task 39.3: **Render the "Why?" accordion in the card** — a small stateful `_WhySection` (collapsed by default) inserted as the last child of the card `Column`; reasons grouped **Moment / You**, or a single **Blocked** reason when floor-locked; new bilingual `arudamWhy*` ARB keys; **zero hardcoded `Text()`**.
- [x] Task 39.4: **Keep the Oracle path unaffected** — `OracleCompositeEngine` delegate output identical; the Oracle screen renders identically (leaving `reasons` unread is fine).
- [x] Task 39.5: **Tests** — engine `reasons` per case (aligned / misaligned / stale-omits-readiness / Sushumna / floor-lock single-reason + `conf` strings); card collapse-by-default → expand → provenance text + `CONF-` citation + floor-lock + misaligned; existing engine + card tests pass **unchanged**.

**Delivery Checklist (Definition of Done):**
- [x] **Code merged** — on `main` (PR #196, merge `8a7aa62`). _(owner merged — Kiro cannot merge)_
- [x] **PR link** — [#196](https://github.com/vteial/saranidhi/pull/196) (CI green: Analyze / Fast Tests / Build + Full Suite). Antigravity implemented + local green before PR; **Kiro Web reviewed the real diff and approved**.
- [x] **Regression gate** — `IntegratedArudamResult` gains one field (`reasons`) only; `evaluate()` returns identical `score/momentScore/readinessMultiplier/band/isFloorLocked/guidance`; Oracle output + screen unchanged; the collapsed card renders exactly as today. **Verified: zero deletions in existing engine/card test assertions.**
- [ ] **Docs updated** — User Guide ("Why?" accordion + how provenance is surfaced) + `calculation-methodology.md` (factor→CONF note) — **deferred to `/sprint-update`** (PR #196 was code+l10n only; stakeholder docs are the `/sprint-update` + docs-audit job).
- [x] **Tests** — engine + card tests extended (reasons per case; collapse/expand/provenance/floor-lock/misaligned + Tamil-locale); existing tests unchanged; local green (573 / 4 CloudKit / 0 other) before PR.
- [ ] **Smoke test** — scenarios added to the next `smoke-test` (collapse/expand; provenance visible; floor-lock explanation; EN/TA "Why?") — **at `/release-start` v1.9.0**.
- [ ] **Valuation report** — Sprint 39 row (+20%) — **at `/sprint-update`**.
- [x] **Tracker updated** — status ✅ (this `/sprint-finish`).
- [ ] **User Guide** — real capability change (verdict transparency), so **not** `n/a` — **updated at `/sprint-update`**.

---

## Sprint 40: Chronobiology & Holistic Guidance (v1.10.0) — Planned

> **Dossier:** [`sprints/sprint-40-chronobiology/`](sprints/sprint-40-chronobiology/README.md)
> ([spec](sprints/sprint-40-chronobiology/spec.md)). Derives from the
> [Chronobiology & Holistic Guidance](sprint-backlog.md#chronobiology--holistic-guidance)
> backlog epic.
>
> **What:** turns the app from "what is my rhythm now" into "your rhythm has drifted — here
> is a holistic correction," grounded in the chronobiology corpus. All bilingual EN/TA,
> gentle/reliability-first tone (CONF-017), never medical-diagnostic.
>
> **Reuse, don't rebuild:** the "shift your breath" action routes into the shipped **Sprint 35
> somatic engine** (`lib/features/somatic/`) — no new timed protocol; Pada Gamana / Swara-Ahara
> doctrine prose is **already localized** (`guidePadaGamanaBody`, `guideSwaraAharaBody`).
>
> **Process:** spec → coding-setup → review (Kiro Web authors + reviews; Antigravity IDE
> implements + local green before PR).

- [ ] Task 40.1: **`ChronobiologyAnalytics`** — time-weighted sliding-window nostril-**stagnancy** detection (`StagnancyLevel{none,mild,chronic}`, `StagnancyAnalysisResult{level, stuckFlow, continuousDuration}`) over the rolling-24h journal per `advanced_somatic_mastery.md` §2: **mild ≥6h & ≥3 logs; chronic ≥8h & ≥4 logs**; Sushumna breaks a run. Pure Dart, unit-tested.
- [ ] Task 40.2: **Wire stagnancy into the dashboard** — add `getEntriesSince(cutoff)` to the journal repo; add `DashboardData.stagnancy` (defaults to `none`); `dashboardDataProvider` reads the last 24h (mirror the hold-time query) and calls the analytics.
- [ ] Task 40.3: **Dashboard stagnancy-warning card** — heating (stuck-left/cold → Surya Bhedana + warming) vs cooling (stuck-right/hot → Sheetali + cooling); mild vs chronic tone; **hidden when healthy**; a low-emphasis affordance routes into the existing somatic timer (target = opposite flow).
- [ ] Task 40.4: **Swara-Ahara dietary "fire" prompt on the Kriya Focus Card** — flow-aware (`FocusCard` gains an optional `currentFlow`); left-flow at a Kriya/eating moment → flip-to-right nudge into the somatic engine; right-flow → affirming line; short-form ARB keys.
- [ ] Task 40.5: **Tattva temperature-regulation tips** — `Tattva.fire`/excess heat → Sheetali (cooling), cold/stuck-left → Surya Bhedana (warming); advisory text only (no new timed protocol); surfaced on the stagnancy card or the tattva row.
- [ ] Task 40.6: **Swara Pada Gamana waking advice in the morning summary** — thread a `languageCode` through `generateForToday`/`_generateMorningSummary` (like the window path) so the currently-hardcoded-English body becomes **bilingual**, and append the grounding foot/nostril waking advice. Gated by the existing `notifyMorningSummary` pref.

> **Explicitly out of scope (fast-follows):** Cognitive Energy Budgeting labels; ≥6h/≥8h
> *notification* nudges (vs the dashboard card); a new **timed** Sheetali/Surya Bhedana
> breathwork protocol (advisory text only this sprint); Analytics-screen CSV decision
> (separate `/plan` item); any rewrite of the Sprint 35 somatic engine.

**Delivery Checklist (Definition of Done):**
- [ ] **Code merged** — on `main` (PR #N). _(owner merges — Kiro cannot merge)_
- [ ] **PR link** — #N (CI green: Analyze / Fast Tests / Build + Full Suite). Antigravity implements + local green before PR; **Kiro Web reviews the real diff**.
- [ ] **Regression gate** — `DashboardData` + `FocusCard` gain optional/defaulted fields only; no existing field changes type/meaning; existing dashboard / focus / notification tests pass **unchanged**; `createTestDashboardData` updated with a `none` default.
- [ ] **Docs updated** — User Guide: stagnancy card, Swara-Ahara Kriya prompt, Pada Gamana morning advice, temperature tips; `calculation-methodology.md` for the stagnancy thresholds.
- [ ] **Tests** — `ChronobiologyAnalytics` unit tests (none / mild / chronic / Sushumna-breaks-run / boundary 6h/8h); `getEntriesSince` repo test; dashboard-provider stagnancy test; stagnancy-card + focus-card widget tests; morning-summary EN/TA test; tattva-tip mapping test; local green before PR.
- [ ] **Smoke test** — scenarios added (stagnancy card mild/chronic + heating/cooling; Kriya prompt flow states; morning-summary Pada Gamana EN/TA).
- [ ] **Valuation report** — Sprint 40 row (+20%) at `/sprint-update`.
- [ ] **Tracker updated** — status ✅.
- [ ] **User Guide** — real capability change, so **not** `n/a`.

---

## Future Sprints

The flagship **Integrated Aruḍam** slice 1 (Sprint 38) shipped; its "Why?" accordion
fast-follow is now **Sprint 39** and **Chronobiology** is **Sprint 40** (above).
Remaining future/candidate sprints (Accuracy Calibration — blocked on the 7-day data;
the native "Now" Surface; v2.0 Polish; E2E Automation; App Store Prep) live in the
**[Sprint Backlog](sprint-backlog.md)** with full task lists. They graduate into this
tracker (with a Delivery Checklist) when scheduled via `/plan`.

> **Note on numbering:** Sprint 37 was reassigned from "Chronobiology" to
> "Birth-Bird Engine Correction" — the CONF-PP audit surfaced a live calculation
> bug that takes priority over feature work. Chronobiology shifts later.

---

[← Back to Root](../../README.md)
