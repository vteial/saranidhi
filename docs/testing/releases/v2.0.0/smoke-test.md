[← Release dossier](./README.md) · [Releases index](../../smoke-test-results.md)

# Smoke Test — v2.0.0-web (v2.0.0 Major Release)

> **Major-release full-surface re-characterization.** v1.13.0 → **v2.0.0** is the firm's first
> major-version increment. This smoke characterizes the complete accumulated `[Unreleased]` feature set
> shipped across Sprints and targeted specs since v1.13.0 (deferred UX widgets wiring, startup performance &
> reduced-motion accessibility, Tamil localization polish, Prasanam Oracle consultation, corpus-aligned
> Adhikara/Padu engine correction with null-bird no-op, golden correctness gates, and Practice Sync auto-on-open)
> alongside the standing full-surface regression.
>
> **Environment:** the release PR's Vercel **preview** (built with
> `--dart-define=POCKETBASE_URL=https://saranidhi-pb.fly.dev`) + the live **Fly PocketBase**
> (`https://saranidhi-pb.fly.dev`).
> **Preview Auth:** `?x-vercel-protection-bypass=<secret>&x-vercel-set-bypass-cookie=true`
> using `VERCEL_AUTOMATION_BYPASS_SECRET` from local `.env`. Sign in with the PocketBase **test user**
> created during setup.

## Pre-flight (must pass before any scenario)

- [ ] Preview reachable at the bypass URL (HTTP 200, app shell renders).
- [ ] **About card reads exactly `Saranidhi v2.0.0`** (wrong version → abort, no fallback).
- [ ] Required CI green on the release PR head (Analyze/Fast + Build; Full Suite + Coverage; Integration Tests (Web)).
- [ ] **Backend reachable:** `curl https://saranidhi-pb.fly.dev/api/health` → `{"code":200,...}`
      (note: first hit may cold-start ~1–2s — scale-to-zero).

## Scenarios

### S1 — UX Wiring (WhatsNew + Journal Widgets + Streak Celebration)
> Covers deferred widgets activated in PR #312 (`deferred-widgets-wiring`).
1. [ ] **WhatsNew gate:** On cold open post-onboarding, the `WhatsNewScreen` modal appears once, highlighting Practice Sync and v2.0 features (`AppConstants.appVersion` 2.0.0). It never interrupts or precedes intro/onboarding. Dismissing persists the version marker; subsequent opens do not re-show.
2. [ ] **Journal pin/star affordance:** In Journal history, tap the star icon on any entry → entry moves into the pinned-first block at the top of the history list. Pinned entries sort chronologically descending. Tap star again → entry unpins and returns to its standard chronological group.
3. [ ] **Guided PresetSelector:** In Journal entry panel, the preset selector defaults to "Manual". Selecting a guided breath preset (e.g. 4-7-8, Box Breathing) displays the target rhythm guidance copy without overwriting or auto-advancing manual breath capture inputs.
4. [ ] **StreakCelebration trigger:** When current practice streak reaches a milestone (7, 30, 100, or 365 days), the celebratory overlay dialog (`showStreakCelebration`) triggers in the Today tab, de-duplicated by the persisted `last_celebrated_streak_milestone` preference.

### S2 — Performance & Accessibility (Startup Latency & Reduced-Motion)
> Covers startup unblocking and reduced-motion adaptation from PR #315 (`performance-pass`).
1. [ ] **Startup off critical path:** Cold launch app in browser. First frame paints immediately without blocking on native timezone database initialization or notification plugin setup (both run post-first-frame).
2. [ ] **Run-once side effects:** Navigating between tabs (Home, Journal, Oracle, Analytics) and Settings does not re-trigger redundant sync, location checks, or migration scans.
3. [ ] **Reduced-motion awareness (`MediaQuery.disableAnimations` ON):** Enable OS "Reduce Motion" setting:
   - Repeating pacers (`SamaVrittiPacer`, `QuickSyncPacer`) display static target states rather than continuous animated expansion/contraction loops.
   - Shimmer loaders (`ShimmerLoading`) display static neutral placeholders rather than looping gradient sweeps.
   - Prasanam breathing circle displays static calm state.
   - Streak celebration overlay renders directly without entrance bounce/scaling.
   - Entire app remains fully interactive and usable with reduced motion active.

### S3 — Localization Polish Sweep (Unpin Disambiguation & Yama Title)
> Covers Tamil l10n fixes from PR #317 (`l10n-polish-sweep`).
1. [ ] **Tamil unpin disambiguation (`BUG-POLISH-01`):** Switch app language to Tamil. On a pinned journal entry, hover/long-press the unpin affordance → tooltip reads `பின் அகற்று` ("un-pin"), distinctly differentiated from delete (`நீக்கு`). In English, reads `Unpin` vs `Delete`.
2. [ ] **Yama notification title (`BUG-v1.11.1-03`):** Verify yama transition notification titles format as `Saranidhi — யாம N` in Tamil mode and `Saranidhi — Yama N` in English mode (localized via `l10n.yamaPrefix`). AI wisdom payload retains stable English keys.

### S4 — Prasanam Oracle Consultation
> Covers Prasanam Oracle tab and User Guide guidance from PR #319 (`user-guide-refresh`).
1. [ ] **Prasanam consultation tab:** Navigate to the 4th bottom navigation tab (Prasanam Oracle). Tap to initiate omen consultation. Reading calculates composite score and resolves into one of the 5 canonical guidance bands (Favorable, Mixed/Neutral, Inauspicious, etc.).
2. [ ] **Window friction banner:** Ambient condition banner reflects real-time friction (Sushumna alignment status, active Hora & Tattva alignment).
3. [ ] **User-initiated save:** Tap "Save to History" button → persists reading to local Oracle history. Verify readings are never saved automatically without user intent.

### S5 — Engine: Adhikara & Padu-Pakshi Correction + Null-Bird No-Op
> Covers corpus alignment under CONF-PP-007 (Kottumozhi Sathya pp. 14, 17, 18, 22).
1. [ ] **Adhikara boost & Padu penalty:** For an onboarded profile with an active birth bird, Adhikara ruling authority (×1.15 boost) and Padu-Pakshi downtime (×0.5 penalty) reflect in the Oracle reading score and Home ambient card (`arudam_now_card.dart`).
2. [ ] **Null-bird no-op invariant:** For an un-onboarded profile (null bird), multiplier evaluates to exactly 1.0 (byte-identical calculation to pre-Adhikara baseline).
3. [ ] **Floor-lock override:** Inauspicious Rahu Kaal and Emakandam floor-locks (score=10, sunya) take absolute precedence over the ×1.15 Adhikara boost; score remains clamped at 10.

### S6 — Practice Sync: Auto-on-Open Fast-Follow & Cross-Device Round-Trip
> Covers Practice Sync auto-on-open fast-follow (PR #294) and Sprint 47 core sync round-trip.
1. [ ] **Opt-in gate & zero network:** Sync master toggle in Settings is OFF by default. Zero network requests made to PocketBase backend when disabled. "Sync now" is inert.
2. [ ] **Auto-on-open trigger:** When enabled and authenticated, auto pull-merge-push fires once on cold app launch and debounced on resume after 5+ minutes in background.
3. [ ] **Offline-first resilience:** With sync enabled but backend unreachable (airplane mode / network down), auto-sync fails quietly with non-blocking status; startup is not blocked, zero modal disruption, zero data loss.
4. [ ] **Cross-device round-trip:** Device A (signed in) creates sessions/journal entries and syncs. Device B (same user/Practice ID) syncs and receives merged data. Re-running sync on either device is idempotent (0 new duplicates inserted).
5. [ ] **Selective scope & owner guard:** Scope toggles (sessions vs journal) respected; foreign user rows not accessible (owner guard holds).

### S7 — Standing Regression Sweep (Full Surface)
> Covers always-checked standing baseline functionality across all core surfaces.
1. [ ] **Dual-path onboarding:** Standard "Get Started" completes wizard and mints new Practice ID; "Import from another device" link adopts existing backup and Practice ID before onboarding.
2. [ ] **Dashboard core engines:** Verify accurate rendering of Birth Bird card, Rahu Kaal / Gulika Kaal / Yamagandam timers, 10-Yama timeline (day Y1–Y5, night Y6–Y10), Chaldean Horas, and Tattva cycles.
3. [ ] **Breath practice & journal:** Breath timer session records hold times and counts; manual journal entry saves with mood and tags; history filters work.
4. [ ] **Analytics & trends:** Analytics tab renders practice consistency, weekly trends, and milestone progress.
5. [ ] **Settings & data portability:** Export all data generates JSON filename `saranidhi_backup_<first8-of-PracticeID>_<timestamp>.json`. Merge/Restore with owner-guard checks: same Practice ID merges non-destructively; mismatched Practice ID refused with restore-overwrite fallback.
6. [ ] **Complete offline-first integrity:** When Sync is OFF, the entire application operates seamlessly offline without any network traffic.

### S8 — Bilingual (EN/TA) Sweep (Pure Tamil Gate)
> Standing RT gate: pure Tamil script across all new v2.0 surfaces; zero English leakage.
1. [ ] Toggle app language to Tamil. Verify all new and updated v2.0 surfaces render in pure Tamil script:
   - **Prasanam Oracle tab:** title, consultation prompt, 5 guidance bands, window friction banner, provenance accordion, Save to History button.
   - **WhatsNew modal screen:** release title, feature bullet points, dismiss button.
   - **Journal preset selector & guidance copy:** `பயிற்சி முறை வழிகாட்டுதல்` and preset names.
   - **Streak celebration overlay modal:** congratulatory title, milestone counter, continue button.
   - **Journal pin affordance:** star tooltip (`பின் அகற்று` / `பின் செய்`).
   - **In-app User Guide screen:** Prasanam Oracle section, updated navigation overview (Home, Journal, Oracle, Analytics), Practice Sync FAQ entry.

## Result

- **Smoke:** ⬜ **Pending owner execution** on release PR preview against live Fly PocketBase.
- **Verified Build:** Settings → About reads `Saranidhi v2.0.0`.

| # | Scenario | Result | Notes |
|---|----------|:------:|-------|
| S1 | UX Wiring (WhatsNew + Journal Widgets + Streak Celebration) | ⬜ | |
| S2 | Performance & Accessibility (Startup Latency & Reduced-Motion) | ⬜ | |
| S3 | Localization Polish Sweep (Unpin Disambiguation & Yama Title) | ⬜ | |
| S4 | Prasanam Oracle Consultation | ⬜ | |
| S5 | Engine: Adhikara & Padu-Pakshi Correction + Null-Bird No-Op | ⬜ | |
| S6 | Practice Sync: Auto-on-Open Fast-Follow & Cross-Device Round-Trip | ⬜ | |
| S7 | Standing Regression Sweep (Full Surface) | ⬜ | |
| S8 | Bilingual (EN/TA) Sweep (Pure Tamil Gate) | ⬜ | |

## Known-Defect Handling & Release Doctrine

- **Cosmetic / Minor Pre-existing Defect:** If a minor cosmetic or non-blocking pre-existing issue is discovered, it may be recorded in the smoke notes and shipped as an owner-accepted backlogged defect (logged in `BACKLOG.md`), avoiding release stalls for non-functional polish.
- **Functional Blocker:** Any functional blocker (crash, calculation error, data loss, sync corruption, or English leakage in Tamil mode) must be fixed directly on the **SAME release branch**. After the fix lands, the affected scenario must be re-verified before release sign-off.
