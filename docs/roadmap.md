[← Back to Root](../README.md)

# Saranidhi — Release Plan (Revised July 2026)

## Release Vision

Saranidhi aims to be a **daily-use spiritual breath companion** that provides genuine value through personalized Panja Pakshi guidance, cross-device sync, and progressive breath practice tracking. Quality and daily usefulness take priority over store publication timeline.

---

## Current State

| Milestone | Status |
|-----------|--------|
| Web production (v1.2.0-web) | ✅ Live at [saranidhi.vercel.app](https://saranidhi.vercel.app) |
| Staging environment | ✅ Live at [saranidhi-staging.vercel.app](https://saranidhi-staging.vercel.app) |
| Core Pakshi engine (day + night) | ✅ Authentic 2D tables + Hora + Tattva |
| Full Tamil + English | ✅ 200+ ARB keys |
| Smoke test passed | ✅ 62 scenarios (v1.2.0) |
| 27 sprints delivered | ✅ 76 PRs merged |
| Production safety gate | ✅ `prod` branch + `/release-start/finish/update` protocol |

---

## Phase 1: Core Value Enhancement (Sprints 14–15)

**Goal:** Make the app genuinely useful for daily spiritual practice.

| Sprint | Deliverables |
|--------|-------------|
| Sprint 14 | Birth bird personalized dashboard, full-day schedule, Rahu Kaal, nostril dominance chart, hold time card, Align27 validation |
| Sprint 15 | Night yamas (5 night segments), 10-yama 24h view, after-sunset functionality |

**Success criteria:** User opens app multiple times daily and gets actionable guidance at any hour.

---

## Phase 2: Multi-Device (Sprint 16)

**Goal:** Use the app seamlessly across iPhone SE, iPad Mini, and iMac.

| Sprint | Deliverables |
|--------|-------------|
| Sprint 16 | iCloud (CloudKit) sync, macOS native target, primary device conflict resolution |

**Success criteria:** Log breath on iPhone, see it on iPad/Mac without manual transfer.

---

## Phase 3: Engagement (Sprints 17–18)

**Goal:** Build daily habit through passive reminders and planning tools.

| Sprint | Deliverables |
|--------|-------------|
| Sprint 17 | Real local notifications (yama transitions, daily summary, Rahu Kaal) |
| Sprint 18 | Historical date view, tomorrow's schedule, "best times this week" |

**Success criteria:** App reminds user at the right moments; user can plan important activities.

---

## Phase 4: Insights (Sprint 19)

**Goal:** Show progress and motivate continued practice.

| Sprint | Deliverables |
|--------|-------------|
| Sprint 19 | Weekly/monthly analytics, hold time progression (day/week/month/year averages + trend), CSV export, streak insights |

**Success criteria:** User can see measurable improvement in breath hold and alignment consistency.

---

## Phase 5: Distribution (Sprint X — Target Aug/Sep 2026)

**Goal:** Publish to app stores when the app is compelling enough to retain users.

| Sprint | Deliverables |
|--------|-------------|
| Sprint X | Apple Developer + Play Console accounts, iOS/macOS/Android builds, store listings, screenshots, submission |

**Success criteria:** App approved and live on App Store + Play Store.

---

## Deferred (Post v1.0)

| Feature | Target |
|---------|--------|
| Google Drive sync (web + Android) | v1.1 |
| On-device LLM (mobile AI) | v1.1 |
| Breath session guided programs | v1.2 |
| Widget support (iOS/macOS home screen) | v1.2 |
| Apple Watch / Wear OS | v2.0 |
| Advanced analytics (PDF reports) | v2.0 |
| Additional languages | v2.0 |
| RevenueCat premium tier | v2.0 |
| Derive nakshatra from DOB + Time | v2.0 |

---

## v1.2.0-web Release (✅ Released — 2026-07-08)

**Status:** Released to production. Tag: `v1.2.0-web`

| Deliverable | Sprint |
|-------------|--------|
| Empty states, shimmer loading, error handling | Sprint 24 |
| Safari fix, timezone, accessibility, keyboard nav | Sprint 25 |
| What's New, celebrations, timer presets, daily summary, pin/star | Sprint 26 |
| Sushumna context alignment, guided nostril test, Hora/Tattva, reference table, onboarding i18n, DOB recalc, trilingual nakshatras | Sprint 27 |

---

## v1.3.0-web — Layer 2: Action Windows (Sprints 28–29)

**Goal:** Transform raw bird state data into practical lifestyle recommendations.

| Sprint | Deliverables |
|--------|-------------|
| Sprint 28 | ActionWindowEngine (24h schedule), Rahu Kaal guardrail, unit tests |
| Sprint 29 | 24h Action Bar, Current Mode Focus Card, expansion sheet, Today tab integration |

**Success criteria:** User opens app and sees "Negotiate now" / "Eat & recover" / "Meditate" — no technical jargon needed.

---

## v2.0.0-web — Layer 3: Prasanam Oracle (Sprints 30–31)

**Goal:** Point-in-time micro-oracle for critical decision-making.

| Sprint | Deliverables |
|--------|-------------|
| Sprint 30 | Prasanam calculation engine (3 vectors), PrasanamHistory table, oracle score, guidance matrix |
| Sprint 31 | FAB trigger, query input + validation gate + intention anchor, result card, history timeline, post-event notes |

**Success criteria:** User asks "Should I sign the lease?" → instant tactical prediction with confidence score + clear guidance.

---

[← Back to Root](../README.md)
