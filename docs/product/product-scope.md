[← Back to Root](../../README.md)

# Saranidhi — Product Scope

*The functional scope of Saranidhi: what the product does for the user, and why.
For how it is built, see [`docs/reference/architecture.md`](../reference/architecture.md).*

## Release Vision

Saranidhi aims to be a **daily-use spiritual breath companion** that provides genuine value through personalized Panja Pakshi guidance, cross-device sync, and progressive breath practice tracking. Quality and daily usefulness take priority over store publication timeline.

---

## 1. Intent & Objectives

Saranidhi (Tamil: "The Treasure House of Breath") is a spiritual life-guidance app built on the ancient sciences of **Siva Swarodaya (Sara Kalai)**, **Panja Pakshi Shastra**, and **Vedic time systems**. It enables users to:

- **Track and align** their breath flow (left/right/both nostril) with cosmic rhythms
- **Observe** planetary hours (Horas), elemental cycles (Tattvas), and bird states (Panja Pakshi)
- **Build consistency** through streaks, trends, and visual feedback
- **Receive personalized guidance** from a rules-based wisdom engine rooted in traditional teaching
- **Maintain absolute privacy** — data stays on-device by default, or in the user's own cloud account if they choose

The system is **local-first and privacy-first** with a **zero-backend architecture** — no developer-owned servers, no third-party data storage, no user data liability. The app works fully without any sign-in.

---

## 2. Core Feature Modules

Each module below is described by what it does for the user. The algorithms, tables, and data structures behind them live in [`docs/reference/architecture.md`](../reference/architecture.md).

### Astro-Logic Guidance

Computes the user's cosmic context entirely on-device: sunrise/sunset, the five daily Yamas, Panja Pakshi bird states, Rahu Kaal, planetary hours (Hora), and elemental cycles (Tattva). This is the deterministic foundation that every guidance surface reads from, and it works fully offline.

### Sara Kalai Breath Journal

The core daily interaction. In two clicks the user logs their dominant nostril — Solar (Right/Pingala), Lunar (Left/Ida), or Sushumna (Both) — and immediately sees whether their actual flow matches the expected cosmic pattern. An optional breath duration timer records inhale, hold, and exhale lengths, and a quick sync pacer helps shift the dominant nostril when unaligned. Micro-advice turns the alignment state into a concrete suggestion.

### Streak & Consistency Engine

Turns daily logging into a habit through immediate visual reward: a current streak count, a 7-day calendar ribbon, a rolling 30-day alignment trend, a time-of-day heatmap, and per-Yama accuracy so users can see where they are most consistent.

### Somatic Intervention Engine

When a breath entry is unaligned, the user can take action instead of just noting it. A **Clear Breath Channel** flow offers guided, time-bound protocols (Posture Shift, ~3 min; Axillary Pressure, ~5 min). A full-screen room shows the contralateral instruction, a Sama Vritti (4:4:4:4) breathing pacer, and a countdown; on completion a guided nostril test verifies the result. Added in Sprint 35.

### Smart Local Notifications (Mobile)

Proactive touchpoints scheduled by the device OS, with no server dependency: alerts at Yama transitions, contextual wisdom payloads, and user-controlled toggles for which bird states trigger a reminder.

### Wisdom Engine (Rules-Based)

A contextual guidance layer that delivers personalized coaching by matching the user's current context (streak, accuracy, active bird and state, Rahu Kaal, Tattva, Hora) against a curated wisdom library. The engine is **rules-based**, running the same way on every platform, with a static proverbs fallback. An optional user-provided API key for an external model remains a possible future enhancement, not a requirement.

### Prasanam Oracle

A point-in-time micro-oracle for decision moments ("Should I do this now?"). Prasanam Oracle is a **bottom-navigation tab** (Home | Journal | Oracle | Analytics), reachable from any screen. The user picks a category (Artha / Kriya / Yoga), optionally states an intention, and receives a readiness score with clear guidance. Readings are saved only when the user chooses to, respecting the silent/mental Prasanam tradition. Consultation-ritual refinements (cooldown, pre-query breath ritual, intention-anchor hold, daily limits) are tracked in the [Prasanam Oracle UX epic](../process/sprint-backlog.md#prasanam-oracle-ux).

### Cross-Device Sync

Lets a user carry their profile, journal entries, streaks, and preferences across their own devices using the user's own cloud account (never a developer server). Sync merges remote and local data on app open, with a configurable primary-device conflict rule, and queues changes when offline.

---

## 3. Product Principles

- **Local-first, privacy-first** — data lives on-device by default. Cloud is opt-in and always the user's own account. No developer-owned backend, no telemetry that leaks user data, no account required to use the app.
- **Bilingual (EN + TA)** — the full experience is available in English and Tamil, including guidance text, onboarding, and notifications.
- **Daily-use companion** — every surface is designed for repeated, low-friction daily use: two-click logging, at-a-glance context, and actionable micro-advice rather than dense readouts.

---

## 4. Monetization

| Model | Description |
|-------|-------------|
| **Freemium** | Core breath logging + alignment free; premium unlocks advanced analytics, extended wisdom, and themes |
| **One-Time Unlock** | Single IAP to unlock all premium features permanently |
| **Platform** | RevenueCat for cross-platform purchase management |
| **Cost to Developer** | $0 ongoing (no servers, no cloud DB) |

---

## 5. What Saranidhi is NOT — Scope Boundaries

- **Not a backend product.** There is no developer-owned server, no hosted user database, and no account system. All personal data stays on-device or in the user's own cloud.
- **Not a telemetry or tracking product.** No third-party analytics that leak user data.
- **Not an on-device LLM product.** The wisdom engine is rules-based, not a shipped language model. Any external-model integration would be optional and user-supplied.
- **Not a medical or clinical tool.** Saranidhi offers spiritual and lifestyle guidance rooted in traditional sciences, not medical advice.
- **Not a social network.** There is no feed, no sharing-by-default, and no public profile — the experience is personal and private.

---

[← Back to Root](../../README.md)
