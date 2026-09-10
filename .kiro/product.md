# Saranidhi — Product Requirements

## Vision

Saranidhi ("The Treasure House of Breath") is a spiritual life-guidance app enabling users to track and align their breath flow with cosmic rhythms based on the ancient sciences of Siva Swarodaya (Sara Kalai), Panja Pakshi Shastra, and Vedic time systems.

## Target Users

- Practitioners of pranayama and breath awareness (Tamil tradition)
- Users of Align27 or similar Vedic timing apps seeking deeper Sara Kalai features
- Spiritual seekers wanting personalized daily guidance based on birth chart

## Core User Stories

### Breath Alignment
- As a user, I can log my dominant nostril (Solar/Lunar/Sushumna) in two taps
- As a user, I see instantly whether my breath is aligned with the expected cosmic pattern
- As a user, I get micro-advice when unaligned ("Lead with RIGHT foot today")
- As a user, I can time my breath cycles (inhale/hold/exhale) with a visual timer

### Cosmic Guidance (Panja Pakshi)
- As a user, I see my birth bird's current state (Ruling/Eating/Walking/Sleeping/Dying)
- As a user, I see today's full 10-yama schedule (5 day + 5 night) with bird states
- As a user, I get state-specific guidance ("Act boldly" during Ruling, "Rest" during Sleeping)
- As a user, I see Rahu Kaal warnings (avoid new initiatives during this window)

### Streaks & Motivation
- As a user, I see my consecutive alignment streak (daily motivation)
- As a user, I see a 7-day ribbon and 30-day trend of my practice
- As a user, I receive personalized daily wisdom (in English or Tamil)

### Historical View & Planning
- As a user, I can browse any past/future date's Pakshi schedule
- As a user, I see "Best Times This Week" (when my bird is Ruling)
- As a user, I see a calendar month view with dots on days I practiced

### Analytics
- As a user, I can view weekly alignment summaries
- As a user, I see monthly patterns (best day, most active yama)
- As a user, I can export my journal as CSV
- As a user, I track hold time progression with personal best

### Privacy & Sync
- As a user, my data stays on-device by default (zero cloud dependency)
- As a user, I can optionally sync via iCloud across Apple devices
- As a user, no developer can access my breath or location data

### i18n
- As a user, I can switch between English and Tamil instantly
- As a user, daily wisdom shows in my chosen language

### Action Windows (v1.3.0 — Layer 2)
- As a user, I see a color-coded 24h timeline showing when to act, nourish, or meditate
- As a user, I see a "Current Mode" card with lifestyle guidance ("Negotiate now" / "Eat & recover" / "Meditate")
- As a user, I see blocked windows during Rahu Kaal (with clear warning)
- As a user, I can tap the card to see raw details (Pakshi state, Hora, Tattva)

### Prasanam Oracle (v2.0.0 — Layer 3)
- As a user, I can ask a critical question and get an instant tactical prediction
- As a user, the app validates my breath state is fresh before calculating (30-min gate)
- As a user, I hold a 3-second intention anchor before the calculation runs
- As a user, I see a clear tiered result (Strong Yes / Favorable / Caution / Delay / Hard No)
- As a user, I see the diagnostic snapshot (breath, bird, hora, tattva) that drove the prediction
- As a user, I can browse past queries chronologically and add outcome notes
- As a user, Rahu Kaal + Dying state triggers a mandatory "Hard No" floor lockout
- The Oracle is a dedicated 4th bottom-nav tab (`/prasanam`); history is co-located there

### Somatic Interventions (Sprint 35 — active correction)
- As a user, when my breath flow is unaligned, I'm offered a guided intervention to shift it
- As a user, I can choose a protocol (posture shift or axillary pressure) to move the flow to the desired nostril
- As a user, I follow a guided, time-bound timer room (with an equal-ratio Sama Vritti pacer) during the intervention
- As a user, after the session the app verifies my new nostril flow and records whether the shift succeeded
- As a user, my intervention history is logged so I can see what works for me

### What's New & Onboarding
- As a user, after an app update I see a "What's New" screen summarizing this release's changes
- As a user, I go through a guided intro + 4-step onboarding (Welcome → Find Your Bird → Location → Data Storage) before first use
- As a user, onboarding tries browser geolocation first and falls back to an Indian city picker if unavailable

## Non-Functional Requirements

- Fully offline-capable (all calculations are pure Dart, no network needed)
- iPhone SE (375px) as minimum viewport
- Two-column responsive layout on medium+ devices (>=600px)
- App startup < 2 seconds
- 8 theme variants (4 accent colors × Light/Dark) plus a System brightness mode
- 4-tab bottom navigation (Home | Journal | Oracle | Analytics); Settings via top-right gear icon
