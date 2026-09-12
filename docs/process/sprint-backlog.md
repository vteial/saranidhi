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

- [★ FLAGSHIP — Integrated Aruḍam](#-flagship--integrated-aruḍam)
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

## ★ FLAGSHIP — Integrated Aruḍam

> **Status: epic scoped via `/plan` (Phase 2b, this session) — decisions confirmed
> with the owner; first slice ready to schedule.** This is the app's thesis: the
> single surface where the separate engines (Sara Kalai swara × Panja Pakshi bird-state
> × Hora/Tarabala × inauspicious windows) become **one answer** to the user's real
> question — *"is now a good moment, and what should I do?"*
>
> **This epic UNIFIES two previously-separate backlog items:** the flagship *Integrated
> Aruḍam* and *The "Now" Surface (Ambient Alignment)*. The Now Surface **is** Integrated
> Aruḍam rendered as an ambient glance; they are the same epic at two fidelities (ambient
> card ↔ deep consultation). The former "Now" Surface brief is folded in below.

### North Star — the ultimate aim

**The app cultivates *natural* alignment with the universe as a lifelong practice — it
does not hand out shortcuts.** Every design choice must pass one test: *does it nudge the
user toward natural alignment as a cultivated habit, or tempt them with a shortcut?*
Human aligning with the universe is the journey until death; the app is the daily companion
for that cultivation. (Embodies the *Agency, not Fate* North Star — `product-scope.md`.)

### Design decisions (owner-confirmed, Phase 2b `/plan`)

| # | Decision | Confirmed |
|---|----------|-----------|
| **Two surfaces, one engine** | An **always-on ambient "Aruḍam Now" verdict** on Home (no question asked) **+** the **Prasanam Oracle stays the sacred, intention-anchored consultation**. Same underlying engine, two intensities. | Q1-A ✅ |
| **Alignment feeds the score** | Breath-alignment is part of the verdict, not a side note — indirectly cultivating alignment for longevity + the present Aruḍam. | Q2-A ✅ |
| **Moment × Readiness model** | **Moment** (Pakshi × Hora × Tarabala × Category) sets the *ceiling* (inherent quality of now); **breath readiness** is a *multiplier* on top. Aligned → full (~1.0); misaligned → **penalty (~0.75) but NEVER a floor-lock**; Sushumna keeps the context rule (aligned only in Yoga). The two clocks (CONF-014: ~1h swara vs ~1.5h yama) are computed **independently, then combined** — never averaged into mush. | Q3 ✅ |
| **24h-correct from slice 1** | Fix the day-only floor-lock (`DaylightSegmentResolver` is sunrise→sunset); the ambient verdict must be honest at night too. | Q4-A ✅ |
| **Reward NATURAL alignment, not forced** | Streaks/analytics reward *"logged while **naturally** aligned"*; force-shifted sessions are **distinguished and NOT rewarded** (or clearly marked). This is the enforcement mechanism for the North Star — the app trains the habit, it doesn't reward gaming it. | ✅ |
| **Forced shifting = urgency-only, WARNING tone** | Per the master's teaching: **wait for natural alignment unless there is valid urgency.** The app must **never present shifting as the "fix"/success path.** Default remedy for misalignment = *wait / accept / note*. Forced shifting appears only behind a secondary, de-emphasized affordance carrying a **warning** (it is depleting; an exception, not a habit). | ✅ |
| **"Why?" surface, no tooltips, no raw math** | The verdict card **always shows the two clocks in plain language** (Moment: … / You: …). A tap-to-expand **"Why?"** accordion explains the verdict *doctrinally* with **provenance** (corpus practice + CONF). **Never** show raw arithmetic; **no tooltips** (touch-hostile, hides trust content). | ✅ |

### The verdict card (shape)

```
🦅 ARUḌAM NOW — Vardhana (78)               ← fused Moment×Readiness score + band
Moment: Bird Ruling · Jupiter hora  (strong) ← the Pakshi/Hora ceiling
You: naturally aligned  ✓                    ← readiness (celebrated when natural)
                                             ← if misaligned: "not naturally aligned —
                                               the higher path is to wait. [Urgent? ⚠]"
▸ Why?                                        ← tap: doctrinal explanation + provenance
```

### Engine reality (grounds the estimate — from a codebase map this session)

The integration is **~80% already built but trapped in the Oracle and pull-only:**
- `OracleCompositeEngine.evaluate()` **already fuses** bird-state × Tarabala × Hora-Swara ×
  category-harmony + Rahu/Emakandam floor-lock + 5 bands + bilingual guidance — but only
  fires when the user opens the Oracle, picks a category, and passes the 30-min swara gate.
- `dashboardDataProvider` **already assembles every ingredient** (bird state, active window,
  Hora, Rahu/Emakandam, sunrise/sunset) for the current moment, 24h, refreshing every 30s —
  it just never calls the engine.
- **Two real gaps:** (1) `AlignmentChecker`'s alignment boolean is *never fused into the
  score* (Sushumna only changes prose); (2) the floor-lock is **day-only**.

So the epic is: **extract the fusion out of the Oracle screen into a shared engine, feed it
the dashboard ingredients + the missing alignment signal, make it 24h-correct, and surface
an always-on verdict** — with the Oracle becoming the deep-dive form of the same verdict.

### First shippable slice (scope-locked)

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | ⬜ | **Extract an `IntegratedArudamEngine`** from `OracleCompositeEngine` so the fusion is callable from the dashboard (not only the Oracle screen). Reuse existing bird/Hora/Tarabala/category logic. |
| 🔴 | ⬜ | **Fuse breath-alignment as the Readiness multiplier** (Moment × Readiness): wire `AlignmentChecker`'s result in; aligned → ~1.0, misaligned → ~0.75 (uniform for v1, tune later via Accuracy Calibration), Sushumna → existing Yoga-context rule. Never a floor-lock. |
| 🔴 | ⬜ | **24h-correct the inauspicious floor-lock** — replace/extend the day-only `DaylightSegmentResolver` path so Rahu/Emakandam (and night equivalents) gate correctly after sunset. |
| 🔴 | ⬜ | **Ambient "Aruḍam Now" verdict card on Home** — always-on, reads `dashboardDataProvider`, shows band + the **two-clock plain-language breakdown** (Moment / You). Honest-but-partial when swara is stale (reuse the confirmed staleness rule — never fabricate a match). |
| 🔴 | ⬜ | **Natural-vs-forced framing** — misalignment default = *wait/accept/note*; forced-shift behind a secondary, **warning**-toned affordance ("depleting; urgency only"); language never promises success (CONF-016/017: a nudge, not a guarantee). |
| 🟡 | ⬜ | **Reward natural alignment in streaks/analytics** — mark/exclude force-shifted sessions from the alignment reward (design the data flag; full analytics rework can follow). |
| 🔴 | ⬜ | Bilingual (EN/TA) verdict states + framing; keep the sacred tone. |

> **Suggested vehicle:** a stability-sized feature sprint (spec → coding-setup → review).
> Most work is *extraction + wiring + one card* over proven engines, plus the night
> floor-lock fix — a good fit for one sprint. Schedule the sprint number at the next `/plan`.

### Fast-follows (same epic, after slice 1 — named, parked)

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | ⬜ | **Expandable "Why?" accordion** with doctrinal explanation + **provenance** (corpus practice + CONF citation) — needs the corpus-citation wiring. |
| 🟡 | ⬜ | **The "Now" Surface — native ambient** (Stage 2 phone widget → Stage 3 watch complication → Stage 4 macOS menu-bar). Native Swift/Kotlin extensions + app-group storage + method channels; zero-backend must hold. Widget tri-tap [L]/[R]/[Both] nostril input + freshness decay. |
| 🟢 | ⬜ | Calendar-aware **proactive nudge** (opt-in, off by default; privacy-sensitive). |
| 🟢 | ⬜ | Tune the readiness penalty (uniform ~0.75 → possibly window-dependent) using the 7-day 3-way data from the **Accuracy & Validation** epic. |

### Explicitly parked as SEPARATE sibling epics (do not absorb)

To hold scope, these stay their own epics and are **not** pulled into Integrated Aruḍam:
**Chronobiology & Holistic Guidance**, **Accuracy & Validation** (the calibration that will
tune the penalty), **Prasanam Sacred Consultation Mode** (the Oracle's reverence layer —
Aruḍam links to it but does not rebuild it), and **Analytics** rework beyond the single
natural-alignment reward flag.

**Provenance:** North Star "Agency, not Fate" + "cultivate natural alignment for life"
(`product-scope.md`) · CONF-014 (two clocks: ~1h swara vs ~1.5h yama) · CONF-016/017
(switching is a nudge, favor reliability over forcing) · CONF-026 (Sushumna = calm
observation) · CONF-002 (contralateral shift) · existing `OracleCompositeEngine`,
`ActionWindowsEngine`, `AlignmentChecker`, `dashboardDataProvider`.

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
| 📋 | → S37 | **CONF-PP-001/002 + re-migration + 003/004/005** — birth-bird engine correction. **Scheduled as Sprint 37 (v1.7.0)** — see [sprint-tracker](sprint-tracker.md) + [dossier](sprints/sprint-37-birth-bird/README.md). Implemented in the coding setup; Kiro Web reviews. |
| 🟡 | ⬜ | **CONF-PP-006 fix** (deferred past Sprint 37) — `_subYamaDuration` supports both models: default equal 28.8-min (workshop), classical weighted (48/36/30/18/12) as a user-selectable option + settings toggle. *Owner-confirmed; a new user option, not a correction.* |
| 🔴 | ⬜ | Collect 7 consecutive days of Align27 Pancha Pakshi states (all 10 yamas, times, moon phase) for Owl/Pushya *(owner's corrected bird per CONF-PP-001/002)* *[owner task]* |
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
| 🟢 | ⬜ | **The "Now" Surface — Ambient Alignment** (widget / watch / macOS) — **now folded into the [★ FLAGSHIP — Integrated Aruḍam](#-flagship--integrated-aruḍam) epic** (native ambient = its fast-follow). Brief retained below for the native-rollout detail. |
| 🟢 | ⬜ | Additional languages beyond EN + TA. |
| 🟢 | ⬜ | Configurable detection thresholds via config (avoid code edits for tuning). |
| 🟢 | ⬜ | Breath session guided programs (was roadmap-deferred v1.2; breath_sessions table is live). |

### Epic Brief — The "Now" Surface (Ambient Alignment)

> **Status: brainstormed, provisional — re-confirm/validate every decision before implementation.** Owner-brainstormed with Kiro (this session). Supersedes the old "Widget support" + "Apple Watch companion" idea stubs.

**Vision.** The embodiment of the *Agency, not Fate* North Star as a **2-second glance**: an ambient surface (phone widget → watch complication → macOS menu-bar/widget) that answers *"is now the moment to act, and if not, how do I fix it?"* The agency loop: **see the moment → compare actual vs expected breath → if misaligned, shift the breath → then act.** This is the **Integrated Aruḍam** (Sara Kalai × Panja Pakshi × Prasanam) rendered as a single ambient signal.

**Provisional design decisions (Kiro "best-option" defaults — NOT final):**

- **Q2 — the ONE verdict = 3-state traffic signal** (glanceable, maps to action). **Framing corrected in Phase 2b `/plan` to the natural-alignment stance** — the 🟡 state is NOT "shift to win":
  - 🟢 **ACT NOW** — strong moment + breath **naturally** aligned (the state to cultivate).
  - 🟡 **NOT NATURALLY ALIGNED** — timing is fine but your breath isn't aligned; the **default guidance is to wait / accept / note it**, not to force a shift. Forced shifting is offered only behind a secondary, **warning**-toned "Urgent?" affordance (depleting; an exception, not a habit). Sushumna/both = neutral "observe/meditate, don't initiate" (CONF-026).
  - 🔴 **WAIT** — hard block (Rahu Kaal, or bird Dying/Sleeping).
  - Finer numeric detail lives one tap deeper (reuse the shared Integrated Aruḍam engine).
- **Q1 — actual-nostril input = widget tri-tap [L] [R] [Both] + freshness decay.** One tap logs current nostril (native widget → app-group storage, no app open). A reading is trusted ~1 hr (CONF-014 swara cycle): fresh (<~30–45 min) → show full verdict; stale → **degrade to "expected + Check your breath →"**, never fabricate a match. **[✅ CONFIRMED tension #1: honest-but-partial when stale, no nagging.]**
- **Q3 — forced shifting is urgency-only, never the success path (corrected Phase 2b).** The higher path is **natural** alignment; the app must never teach "misaligned → shift → win." Only when the user opens the **warning**-gated "Urgent?" affordance does it show the correct **contralateral** instruction (CONF-002: compress the OPPOSITE side ~5–10 min) or the உயிர் கொடுக்கும் revival breath — framed as depleting and exceptional, language = "improves your odds / aligns you," never "guarantees success" (CONF-016: a nudge, ~10–60 min, can revert; CONF-017: reliability over forcing). Loop ends with **"re-check,"** not "done." **Streaks reward *natural* alignment; force-shifted sessions are not rewarded.**
- **Q4 — ambient-first; proactive nudges opt-in + deferred.** Core is glanceable (pull, not push). Optional calendar-aware proactive nudge (*"Right nostril expected at your 3 PM — check at 2:45"*) is privacy-sensitive (zero-backend must hold) → later stage, off by default.

**Staged rollout (de-risks native work):**
1. **Stage 1 (pure Dart, in-app):** the **ambient Aruḍam Now verdict card** (flagship slice 1) unifying the verdict + the two-clock breakdown + wait/accept-or-urgency guidance. Validates the synthesis logic + UX with zero native risk. (Partly exists today across Today tab + Action Windows — this *unifies* it into one decisive card.)
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
- ✅ **Integrated Aruḍam = flagship, unifies "Now" Surface** (Phase 2b `/plan`) — one epic, two fidelities (ambient Home card ↔ Oracle consultation) over ONE shared engine (extracted from `OracleCompositeEngine`); NOT a new engine. Scoring = **Moment × Readiness** (Moment sets the ceiling; breath is a multiplier, aligned ~1.0 / misaligned ~0.75, never a floor-lock). 24h-correct from slice 1.
- ✅ **Cultivate NATURAL alignment; forced shifting is urgency-only (Phase 2b)** — the app's ultimate aim is training natural alignment as a lifelong habit, never a shortcut. The app must **never present forced shifting as the "fix"/success path**; misalignment's default guidance is *wait / accept / note*, with forced shifting behind a secondary, **warning**-toned affordance (depleting, exceptional — per the master's "wait for natural alignment unless valid urgency"). **Streaks/analytics reward *natural* alignment and do NOT reward force-shifted sessions.** This is the enforcement mechanism for the North Star.
- ✅ **Verdict transparency: "Why?" accordion, no tooltips, no raw math (Phase 2b)** — the verdict card always shows the two clocks in plain language (Moment / You); a tap-to-expand "Why?" gives the *doctrinal* explanation + provenance (corpus practice + CONF). Never show raw arithmetic; no tooltips (touch-hostile).
- ✅ **No geo/location score-weighting for Prasanam** — the family-deity-temple practice is honored via opt-in **Sacred Consultation Mode** (reverence + intentional friction + context-journaling), NOT a GPS-based score bonus. The calm state already flows through the breath the oracle reads; a location bonus would double-count it and dent the *Agency, not Fate* North Star.
- ✅ **Google Jules stays RETIRED (do not reopen)** — re-affirmed after "local testing is slow" came up. Jules was already paused on this project for cause (hangs + Dart/Flutter SDK version-mismatch), and as an async cloud coding agent it **cannot do the interactive visual browser QA** (e.g. the v1.7.0 A1 iPad migration check) that is the actual value — so it wouldn't even solve the slowness problem. **The sanctioned answers to slow local testing:** (1) split — fast headless unit/widget tests + a *targeted* human visual spot-check (don't visually drive every scenario); (2) lean on GitHub Actions CI for the heavy full suite + integration tests; (3) long-term, the separate **Playwright E2E repo `vteial/saranidhi-e2e`** (tests the deployed URL, own CI, off-machine) — a dedicated **Sprint E2E**. Antigravity visual runs are a stopgap reserved for eyes-on scenarios. Division of labor unchanged (Kiro Web = specs/docs/review/release; Antigravity IDE = local Dart impl + green baseline + targeted visual QA; owner = merge/release authority).

---

[← Back to Root](../../README.md)
