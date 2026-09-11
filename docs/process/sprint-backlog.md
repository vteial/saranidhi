[← Back to Root](../../README.md)

# Saranidhi — Sprint Backlog

Candidate work not yet scheduled into a numbered sprint, organized by **logical
named epics** rather than sprint number. Items graduate into the
[Sprint Tracker](sprint-tracker.md) (with a Delivery Checklist) when picked up
during `/plan`. Keep entries small and outcome-focused.

> The product's Release Vision and current functional scope live in
> [`docs/product/product-scope.md`](../product/product-scope.md); the technical
> design lives in [`docs/reference/architecture.md`](../reference/architecture.md).

> Status legend: ⬜ Not started · 🔄 In progress · ✅ Done (moved to tracker)
>
> Priority legend: 🔴 High · 🟡 Medium · 🟢 Low

---

## Table of Contents

- [Chronobiology & Holistic Guidance](#chronobiology--holistic-guidance)
- [Analytics & Insights](#analytics--insights)
- [Prasanam Oracle UX](#prasanam-oracle-ux)
- [Accuracy & Validation](#accuracy--validation)
- [Quality, CI & E2E](#quality-ci--e2e)
- [Release Polish & v2.0](#release-polish--v20)
- [Distribution (App Store)](#distribution-app-store)
- [Sync & Platform](#sync--platform)
- [Ideas / Unscoped](#ideas--unscoped)
- [Confirmed Decisions](#confirmed-decisions)

---

## Chronobiology & Holistic Guidance

> Spec: [`research/advanced_somatic_mastery.md`](../research/advanced_somatic_mastery.md) §2.

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | ⬜ | ChronobiologyAnalytics — time-weighted sliding-window stagnancy detection (≥6h mild, ≥8h chronic) |
| 🟡 | ⬜ | Dynamic Somatic Cards — Swara-Ahara dietary fire prompt on the Kriya Focus Card |
| 🟡 | ⬜ | Tattva-Somatic temperature-regulation tips (Sheetali for excess fire, Surya Bhedana for cold) |
| 🟡 | ⬜ | Swara Pada Gamana waking advice in the morning summary notification |
| 🟡 | ⬜ | Dashboard stagnancy warning card (heating/cooling lifestyle recommendations) |
| 🟢 | ⬜ | Cognitive Energy Budgeting labels in Best Times / Explore (Artha/Kriya/Yoga suggestions) |
| 🔴 | ⬜ | Tamil translations for all holistic/somatic guidance text |

---

## Analytics & Insights

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | ⬜ | **Analytics export — reconsider.** The Analytics screen's `_ExportCard` exports journal-only CSV; Settings already has full data export/import (JSON, a superset). Decide: (1) remove CSV from Analytics and replace the slot with a higher-value card (alignment-rate insight, hold-time chart expansion, streak heatmap, or a shareable summary report); (2) move CSV to Settings alongside JSON; or (3) keep as-is. *(CSV = human-readable/journal-only vs JSON = full machine backup — weigh before removing.)* |
| 🟢 | ⬜ | Shareable summary / PDF report of alignment and hold-time progress. |

---

## Prasanam Oracle UX

> Single canonical home for the consultation-ritual friction set (previously
> duplicated across the backlog Deferred section and the old project plan).

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | **Prasanam "sacred consultation" UX** — cooldown, pre-query breath ritual, intention-anchor hold, daily query limit, deity/mantra prompt, session-quality score. Deferred post-v1.4. |
| 🟢 | ⬜ | **Sacred Consultation Mode** (opt-in) — see brief below. |

#### Brief — Sacred Consultation Mode (opt-in)

> **Status: brainstormed, provisional — re-confirm before implementation.** Owner-brainstormed with Kiro. Origin: the South-Indian practice of travelling to one's **family-deity temple** to ask a prasanam via an authorized temple person.

**Insight.** The temple ritual's power is not the *place* granting cosmic accuracy — it is the **effort + reverence + ancestral respect → calm, focused mind → naturally aligned breath (toward Sushumna)**. That calm state already flows through the **breath signal the oracle reads**, so it needs no separate reward.

**Decision — reverence & friction, NOT a score multiplier.** An opt-in "Sacred Consultation" for important questions that:
- **Raises friction, not score:** enforces the full pre-query ritual (breath centering, longer intention anchor, deity/Ishta-Devata invocation prompt), optionally a stricter cooldown — filtering out frivolous/playful use.
- **Lets the user designate a sacred place** (family-deity temple, home shrine — *user-defined*; the app does NOT verify a temple or reward GPS) and **records it as context** in Prasanam history — reverence-as-journaling, for the user's own reflection.
- **Score stays breath-honest:** the verdict comes ONLY from the actual breath/bird/hora/tattva. If the sacred setting truly calms the user, their breath reflects it and the score rises *legitimately* — no double-counting.
- **Optional agency-preserving nudge:** in a likely-chaotic context, gently suggest "find a calm space and re-center before asking" (nudge toward the calm state, never score the place).

**Explicitly rejected:** ❌ adding score weightage for being at a registered/GPS-matched location. Rewards the *place* not the *state*; double-counts the calm effect already carried by the breath; unreliable + gameable proxy; dents the *Agency, not Fate* North Star.

**Provenance:** owner tradition (family-deity prasanam) · CONF-026 (Sushumna = calm equilibrium) · existing Prasanam sacred-UX set · North Star (`product-scope.md`).

---

## Accuracy & Validation

> **Prerequisite:** Owner collects 7-day Align27 + Tamil Panchangam data BEFORE calibration work starts.

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | ⬜ | Collect 7 consecutive days of Align27 Pancha Pakshi states (all 10 yamas, times, moon phase) for Rooster/Pushya *[owner task]* |
| 🔴 | ⬜ | Collect the same 7 days from a Tamil Panchangam (drikpanchang.com or physical calendar) *[owner task]* |
| 🟡 | ⬜ | Saranidhi diagnostic dump — generate matching 7-day output (bird states, sunrise/sunset, lunar phase, weekday) |
| 🟡 | ⬜ | Three-way comparison matrix — Saranidhi vs Align27 vs Panchangam; identify divergence points |
| 🟡 | ⬜ | Root-cause diagnosis — lookup tables / lunar-phase calc / weekday convention / phase-swap timing |
| 🔴 | ⬜ | Calibration fix based on diagnosis |
| 🟡 | ⬜ | Re-run the 7-day comparison; confirm match with the most authentic source |
| 🟢 | ⬜ | Document findings in `docs/research/accuracy-calibration.md` |
| 🟡 | ⬜ | Validate the dual-table birth-bird derivation against a labeled 7-day dataset. |

---

## Quality, CI & E2E

> Ties to the in-repo web integration tests (now fixed and re-gated as REQUIRED)
> and the future Playwright E2E repo.

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | ⬜ | Set up Playwright for Flutter Web E2E tests (separate repo `vteial/saranidhi-e2e`) |
| 🟡 | ⬜ | Automate critical-path scenarios from the smoke test (onboarding, log entry, streak, intervention) |
| 🟡 | ⬜ | Integrate E2E into CI (run against deployed staging URL) |
| 🟢 | ⬜ | Visual regression snapshots for key screens |
| 🟡 | ⬜ | Notification de-duplication / cooldown to avoid repeats during a sustained window. |
| 🟢 | ⬜ | Periodic staging-data / smoke-data hygiene as the app grows. |
| 🟡 | ⬜ | Revisit the 19% coverage gate once UI/E2E coverage exists — raise it then. |
| — | ✅ | Two-tier CI (fast PRs + full on merge/prod, with ci-full now also running on PRs to main) — in place. |

---

## Release Polish & v2.0

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | ⬜ | End-to-end feature integration testing (all layers together) |
| 🟡 | ⬜ | Performance optimization (startup time, animation smoothness) |
| 🔴 | ⬜ | Comprehensive smoke test plan for v2.0.0 (all features) |
| 🟡 | ⬜ | User Guide refresh — complete rewrite covering all v2.0 features |
| 🟢 | ⬜ | Wire Sprint 26 deferred widgets (WhatsNew startup, PresetSelector, StreakCelebration, isPinned star) |

---

## Distribution (App Store)

> Deferred — target when the web app is compelling enough to retain users.

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | Apple Developer + Google Play accounts |
| 🟢 | ⬜ | App icon variants for all required sizes (iOS, macOS, Android adaptive) |
| 🟢 | ⬜ | Splash/launch screen with branding |
| 🟢 | ⬜ | Store screenshots guide (key screens, light+dark, EN+TA) |
| 🟢 | ⬜ | Finalize `docs/deployment/store-listing.md` copy (EN + TA) |
| 🟢 | ⬜ | Build release iOS + macOS + Android |
| 🟢 | ⬜ | Submit for review |
| 🟢 | ⬜ | Verify live + tag `v1.0.0-mobile` |

---

## Sync & Platform

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | **Google Drive sync** (web + Android) — deferred to v1.1+ (architecture stub exists). |
| 🟢 | ⬜ | **Ayanamsa variants** (Raman, KP, Vakya) — deferred to v2.0 (Lahiri sufficient for ~99%). |
| 🟢 | ⬜ | **Derive nakshatra from DOB + Time** — deferred to v2.0. |
| 🟢 | ⬜ | **Home tab restructure** (Today / Past / Future) — deferred post-v1.4. |

---

## Ideas / Unscoped

| Priority | Status | Item |
|----------|--------|------|
| Priority | Status | Item |
|----------|--------|------|
| 🟢 | ⬜ | **The "Now" Surface — Ambient Alignment** (widget / watch / macOS). See epic brief below. |
| 🟢 | ⬜ | Additional languages beyond EN + TA. |
| 🟢 | ⬜ | Configurable detection thresholds via config (avoid code edits for tuning). |
| 🟢 | ⬜ | Breath session guided programs (was roadmap-deferred v1.2; breath_sessions table is live). |

### Epic Brief — The "Now" Surface (Ambient Alignment)

> **Status: brainstormed, provisional — re-confirm/validate every decision before implementation.** Owner-brainstormed with Kiro (this session). Supersedes the old "Widget support" + "Apple Watch companion" idea stubs.

**Vision.** The embodiment of the *Agency, not Fate* North Star as a **2-second glance**: an ambient surface (phone widget → watch complication → macOS menu-bar/widget) that answers *"is now the moment to act, and if not, how do I fix it?"* The agency loop: **see the moment → compare actual vs expected breath → if misaligned, shift the breath → then act.** This is the **Integrated Aruḍam** (Sara Kalai × Panja Pakshi × Prasanam) rendered as a single ambient signal.

**Provisional design decisions (Kiro "best-option" defaults — NOT final):**

- **Q2 — the ONE verdict = 3-state traffic signal** (glanceable, maps to action):
  - 🟢 **ACT NOW** — breath aligned + no blocking window.
  - 🟡 **SHIFT FIRST** — timing fine but breath misaligned (fixable). Sushumna/both = neutral "observe/meditate, don't initiate" (per CONF-026).
  - 🔴 **WAIT** — hard block (Rahu Kaal, or bird Dying/Sleeping).
  - Finer numeric detail lives one tap deeper (reuse existing Prasanam/oracle composite).
- **Q1 — actual-nostril input = widget tri-tap [L] [R] [Both] + freshness decay.** One tap logs current nostril (native widget → app-group storage, no app open). A reading is trusted ~1 hr (CONF-014 swara cycle): fresh (<~30–45 min) → show full verdict; stale → **degrade to "expected + Check your breath →"**, never fabricate a match. **[✅ CONFIRMED tension #1: honest-but-partial when stale, no nagging.]**
- **Q3 — "shift then act" is honest, never a guarantee.** 🟡 expands to a correct **contralateral** instruction (CONF-002: compress the OPPOSITE side ~5–10 min) or the உயிர் கொடுக்கும் revival breath; language = "improves your odds / aligns you," never "guarantees success" (CONF-016: switching is a nudge, ~10–60 min, can revert; CONF-017: reliability over forcing). Loop ends with **"re-check,"** not "done."
- **Q4 — ambient-first; proactive nudges opt-in + deferred.** Core is glanceable (pull, not push). Optional calendar-aware proactive nudge (*"Right nostril expected at your 3 PM — check at 2:45"*) is privacy-sensitive (zero-backend must hold) → later stage, off by default.

**Staged rollout (de-risks native work):**
1. **Stage 1 (pure Dart, in-app):** a dedicated **"Now" view** unifying the verdict + actual/expected + one-tap shift guidance. Validates the synthesis logic + UX with zero native risk. (Partly exists today across Today tab + Action Windows — this *unifies* it into one decisive screen.)
2. **Stage 2:** phone home-screen widget (WidgetKit / App Widgets — highest reach).
3. **Stage 3:** Apple Watch complication (highest glance-value; needs watchOS companion).
4. **Stage 4:** macOS widget / menu-bar (macOS target already shipped).

**Open items to resolve before build:**
- **Tension #2 (OPEN):** confirm the Now Surface is a new *presentation* layer over the **existing Action Window engine + oracle composite** (Kiro's recommendation), not a new engine.
- **Flutter constraint:** native widgets/complications are Swift/Kotlin extensions sharing data via app-group storage + method channels — real native work, not Dart-only.
- Exact freshness threshold (30 vs 45 vs 60 min); widget tap-target UX on small complications; localization of the verdict states (EN/TA).

**Provenance:** North Star "Agency, not Fate" (`product-scope.md`) · CONF-002 (contralateral) · CONF-014 (1-hr cycle) · CONF-016 (switching is a nudge) · CONF-017 (reliability) · CONF-026 (Sushumna neutral) · existing Action Window engine + Prasanam oracle.

---

## Confirmed Decisions

Standing decisions (also captured as Kiro learnings):

- ✅ **On-device LLM** — removed from plan (rules-based wisdom engine sufficient).
- ✅ **Sushumna = sacred observation** — no breath holding; log duration only; brief (~4 min max).
- ✅ **Birth bird is permanent** — derived from birth Paksha (dual-table); no monthly swap.
- ✅ **North Star: Agency, not Fate** — present-moment betterment, never fate-prediction; palm/thumb/Nadi Jothidam + interpretive predictive natal astrology excluded (see `product-scope.md`).
- ✅ **"Now" Surface: honest-but-partial when stale** — if the user's logged nostril is stale (>~1 hr), the ambient surface degrades to "expected + check prompt"; never nag, never fabricate a match.
- ✅ **No geo/location score-weighting for Prasanam** — the family-deity-temple practice is honored via opt-in **Sacred Consultation Mode** (reverence + intentional friction + context-journaling), NOT a GPS-based score bonus. The calm state already flows through the breath the oracle reads; a location bonus would double-count it and dent the *Agency, not Fate* North Star.

---

[← Back to Root](../../README.md)
