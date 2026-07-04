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

## Non-Functional Requirements

- Fully offline-capable (all calculations are pure Dart, no network needed)
- iPhone SE (375px) as minimum viewport
- Two-column responsive layout on medium+ devices (>=600px)
- App startup < 2 seconds
- 8 theme variants (4 colors x Light/Dark + System mode)
