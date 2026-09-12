[← Back to Root](../../README.md)

# Saranidhi — Product Scope

> **Reviewed:** v1.8.0-web · **Next review:** every release + at each `/plan`.

*The functional scope of Saranidhi: what the product does for the user, and why.
For how it is built, see [`docs/reference/architecture.md`](../reference/architecture.md).*

## Release Vision

Saranidhi aims to be a **daily-use spiritual breath companion** that provides genuine value through personalized Panja Pakshi guidance, cross-device sync, and progressive breath practice tracking. Quality and daily usefulness take priority over store publication timeline.

---

## North Star — Agency, not Fate

> **Saranidhi helps users act better in the present moment — it does not predict a fixed future.**

The app's guiding premise is that **Sara Kalai (breath science) is practical, self-observable, present-moment evidence for the user's *betterment*** — you can *influence* your outcome by aligning your breath and actions *now*. This is the app's philosophical identity, and it is the single filter for what belongs in the product.

**The test for any feature:** does it help the user *act better right now* (betterment through agency), or does it *predict a pre-written fate*? Betterment is in scope; fate-telling is not.

### The integrated core (primary focus)

The three flagship surfaces are **not three separate features — they are three lenses on the same live cosmic moment**, and they deliver the most value when used *together*:

| Lens | Reads | Question it answers |
|------|-------|---------------------|
| **Sara Kalai** (சர கலை) | which breath channel is active in me *now* | *What is my current state?* |
| **Panja Pakshi Aruḍam** (பஞ்ச பட்சி அருடம்) | my birth-bird's state / cosmic timing *now* | *What is my timing?* |
| **Prasanam Aruḍam** (சர பிரசன்னம்) | the synthesis of breath + bird + hora + tattva | *Is now the moment to act?* |

Stabilizing and validating this **integrated Sara Kalai × Panja Pakshi × Prasanam engine** (to the ≥95% source-fidelity goal) is the primary product focus. See the Phase-2b epic *"Integrated Aruḍam."*

### Long-term intent (backlog, not now)

- **Numerology (Sankhya Sastra)** — descriptive, character/name-based (NOT fate-prediction), so philosophically compatible. Currently only a thin utility (name→bird phonetic fallback). Broader numerology is a **long-term backlog item**, alongside the **"Saranidhi" book** and a future **animated film** — all narrative artifacts derived from the same corpus spine.

### Explicitly excluded — deterministic fate-prediction

**Palm reading, thumb reading, Nadi Jothidam (நாடி ஜோதிடம்), and interpretive/predictive natal astrology are deliberately out of scope** — not merely unbuilt, but **philosophically incompatible**. They rest on the premise that destiny is *pre-written and readable*; Saranidhi rests on the opposite premise that the future is *influenceable through present-moment agency*. Excluding them is also a **trust/safety stance**: the app does not answer "what is my fixed fate" questions (this mirrors the sensitive-content guardrails on the future AI-chat and the document-only classical divination material in the corpus).

**Two uses of DOB + time — keep the calculation, reject the prediction.** Birth date/time is used in Saranidhi *only* as **astronomical input to derive a fixed structural fact** — the birth bird, via moon → nakshatra → paksha (`nakshatra_calculator`, `lahiri_ayanamsa`). This is positional arithmetic that yields a permanent attribute (like a blood type), not a forecast, and Panja Pakshi genuinely requires it. Saranidhi does **NOT** do **interpretive predictive astrology** — natal-chart life-outcome readings, transit/dasha forecasts, "marriage at 28 / career loss this year" claims. Such prediction is excluded not only on the agency principle but on an **epistemic one**: it validates itself by *retro-fitting past events* to the chart (post-hoc, unfalsifiable pattern-matching), which is the opposite of Sara Kalai's *self-verifiable, present-moment, testable-right-now* evidence. Present-moment timing windows that need no natal chart — Rahu Kaal, Hora, Ayana/Sankranti alignment — are **present-moment guidance ("is now a good window to act?"), not natal fate-prediction**, and remain in scope.

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
- **Not a fate-prediction / fortune-telling product.** No palm reading, thumb reading, Nadi Jothidam (நாடி ஜோதிடம்), or **interpretive predictive natal astrology** (life-outcome chart readings, transit/dasha forecasts). These deterministic fate systems are philosophically incompatible with the app's *agency-not-fate* North Star, and epistemically weak (they self-validate by retro-fitting past events rather than making testable present claims). The app guides present-moment action for betterment; it never predicts a fixed future or answers "what is my destiny" queries. **DOB + time is used ONLY as astronomical input to derive a fixed structural fact (the birth bird via nakshatra + paksha) — never for prediction.** Present-moment timing windows (Rahu Kaal, Hora, Ayana) are guidance, not natal forecasting.
- **Not a social network.** There is no feed, no sharing-by-default, and no public profile — the experience is personal and private.

---

[← Back to Root](../../README.md)
