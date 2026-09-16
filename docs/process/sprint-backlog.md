[← Back to Root](../../README.md)

# Saranidhi — Sprint Backlog

> **Reviewed:** v1.12.1-web · **Next review:** every release + at each `/plan`.

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
- [★ Practice Sync — cross-device aggregate](#-practice-sync--cross-device-aggregate)
- [Chronobiology & Holistic Guidance](#chronobiology--holistic-guidance)
- [Analytics & Insights](#analytics--insights)
- [Prasanam Oracle UX](#prasanam-oracle-ux)
- [User Guide — Book-Style Navigation & Search](#user-guide--book-style-navigation--search)
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

### First shippable slice (scope-locked) — 📋 SCHEDULED as Sprint 38 (v1.8.0)

> Scheduled via `/plan`. Full task list + Delivery Checklist live in the
> **[Sprint 38 entry in the tracker](sprint-tracker.md#sprint-38-integrated-aruḍam--slice-1-v180--planned)**.

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | → S38 | **Extract an `IntegratedArudamEngine`** from `OracleCompositeEngine` so the fusion is callable from the dashboard (not only the Oracle screen). Reuse existing bird/Hora/Tarabala/category logic. |
| 🔴 | → S38 | **Fuse breath-alignment as the Readiness multiplier** (Moment × Readiness): wire `AlignmentChecker`'s result in; aligned → ~1.0, misaligned → ~0.75 (uniform for v1, tune later via Accuracy Calibration), Sushumna → existing Yoga-context rule. Never a floor-lock. |
| 🔴 | → S38 | **24h-correct the inauspicious floor-lock** — replace/extend the day-only `DaylightSegmentResolver` path so Rahu/Emakandam (and night equivalents) gate correctly after sunset. |
| 🔴 | → S38 | **Ambient "Aruḍam Now" verdict card on Home** — always-on, reads `dashboardDataProvider`, shows band + the **two-clock plain-language breakdown** (Moment / You). Honest-but-partial when swara is stale (reuse the confirmed staleness rule — never fabricate a match). |
| 🔴 | → S38 | **Natural-vs-forced framing** — misalignment default = *wait/accept/note*; forced-shift behind a secondary, **warning**-toned affordance ("depleting; urgency only"); language never promises success (CONF-016/017: a nudge, not a guarantee). |
| 🟡 | → S38 | **Reward natural alignment — flag only.** Add the data flag marking force-shifted sessions so they're not rewarded as natural alignment; full analytics rework is a fast-follow. |
| 🔴 | → S38 | Bilingual (EN/TA) verdict states + framing; keep the sacred tone. |

> **Vehicle:** Sprint 38, a stability-sized feature sprint (spec → coding-setup → review).
> Most work is *extraction + wiring + one card* over proven engines, plus the night
> floor-lock fix. Correctness note: the floor-lock task touches shipped logic → the
> Delivery Checklist carries a regression gate (Oracle day-time verdicts unchanged).

### Fast-follows (same epic, after slice 1 — named, parked)

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | 📋 → S39 | **Expandable "Why?" accordion** with doctrinal explanation + **provenance** (corpus practice + CONF citation). **Scheduled as Sprint 39 (v1.9.0)** — see [sprint-tracker](sprint-tracker.md#sprint-39--integrated-aruḍam--why-provenance-accordion-v190--planned) + [dossier](sprints/sprint-39-why-accordion/README.md). |
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

## ★ Practice Sync — cross-device aggregate

> **Status: epic scoped via `/plan` (owner-confirmed this session).** **Phase 0 scheduled as
> Sprint 44 (v1.12.0)** — see [sprint-tracker](sprint-tracker.md#sprint-44--practice-sync--phase-0-owner-stamped-safe-merge-import-v1120--planned).
>
> **The problem (a universal user problem, not just the owner's).** The core value of Saranidhi is
> improving breath-hold time through **consistent practice, any time / any place** — logged on
> *whichever device is in hand*. But the app is per-device local-first, so sessions live in
> **separate stores** on each device (owner's fleet: iPad Mini [primary] · iPhone SE · MBP · iMac,
> all the **web** app). There is **no aggregate** streak / 30-day trend / hold-time average /
> personal-best across devices — which breaks the exact metrics the practice is judged by. Left
> unsolved, this is a silent churn driver for every future user (owner plans ~5 trusted validators
> post-2.0, on **mixed** platforms).
>
> **Owner-confirmed decisions:**
> - **Reframe the principle, don't abandon it:** *local-first **with optional, user-owned sync**.*
>   Offline still works fully; sync/portability is additive.
> - **Scope: session/practice data first** (breath-sessions + journal) — append-only, UUID-keyed,
>   **union-merges with no real conflicts**. Not full profile/prefs sync (that can follow).
> - **Owner identity is the load-bearing safety mechanism** (not the device cap): every export/DB
>   carries an `ownerId`; sync/merge only ever unions rows of the **same** owner — structurally
>   preventing "merge another person's data." A device registry / cap is a *management-UX* layer on
>   top (nice for the validator phase), **not** relied on for correctness.
> - **Phase 0 = locally-generated owner ID, no login, zero backend.** Accounts (if any) enter at
>   Phase 1 with the chosen transport.
> - **Phase 1 transport = OPEN** (decide at Phase-1 `/plan`): **Vercel serverless + passphrase** (owner
>   already hosts on Vercel; full control) **vs Google Drive App Data** (user's own account,
>   cross-platform, zero custom backend). Owner: "or maybe will go for best" → evaluate both then.
> - **Native CloudKit is OUT for now** (web-first; the built `CloudKitSyncEngine` is Apple-native-only
>   and doesn't work from Safari/web) — revisit when the native App Store track happens.
> - **Sync cadence = on app open** (not real-time) — matches the existing sync-on-open design and is
>   far cheaper.

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | 📋 → S44 | **Phase 0 — owner-stamped SAFE merge-import (zero backend).** Locally-generated `ownerId` (guarded v6→v7 migration); stamp exports with `ownerId`+versions; replace the **destructive** import (`database_exporter.dart` deletes all tables) with a **union-by-UUID merge**; **owner-ID mismatch refuses the merge** (the safety core); keep overwrite/restore as a separate labeled option; aggregate (streak/trend/PB) correct post-merge; bilingual. **Scheduled as Sprint 44 (v1.12.0)** — the near-term win before the Now Surface. |
| 🟡 | ⬜ | **Phase 1 — on-open auto-sync of the session log.** Auto pull-merge-push the breath-session table on app open via the chosen transport (Vercel-serverless-+-passphrase **or** Google-Drive-App-Data — decide at Phase-1 `/plan`), union-merged by (`ownerId`, `sessionId`). Reopens the account/network boundary → **security-review redo required**. |
| 🟡 | ⬜ | **Device registry / trusted-device management (UX layer).** Name + list registered devices, "device N of max", revoke. Abuse/cost control + user clarity for the validator phase — NOT the data-integrity guard (that's `ownerId`). |
| 🔴 | ✅ v1.12.1 | **v1.12.1 fast-follow — onboarding "Import from another device" entry point.** *(Scheduled as Sprint 45, v1.12.1 — owner chose a subtle onboarding-screen link; see [sprint-tracker](sprint-tracker.md#sprint-45-v1121-fast-follow--practice-sync-polish----planned).)* *(Surfaced in the v1.12.0 owner smoke.)* A genuinely new device shows onboarding first, but Merge/Restore live in Settings (only reachable *after* onboarding) — so the intended "import-before-onboarding to adopt the existing Practice ID" flow is **not directly reachable** in v1.12.0. Current workaround: onboard, then **Settings → Restore (overwrite)** with the other device's export (adopts its Practice ID). Fix: add an "Already using Saranidhi on another device? Import your data" action on the intro/onboarding screen → file picker → `mergeFromBytes`/adopt → skip onboarding. Makes the safe-Merge path reachable without the destructive-Restore dance. |
| 🟢 | ✅ v1.12.1 | **v1.12.1 fast-follow — BUG-v1.12.0-01: Practice ID not refreshed in Settings after Restore/Merge.** *(v1.12.0 owner smoke.)* After Restore, the profile card shows the *old* Practice ID until a manual page reload. Root cause: `profile_card.dart` uses its own `FutureBuilder` querying `profiles` directly; `_invalidateAllDataProviders()` (in `data_export_import_widget.dart`) invalidates dashboard/journal/ownerId/theme/locale but **not** the profile card's local future. Cosmetic — DB is correct, self-heals on reload. Fix: profile card watches a profile provider that's in the invalidate list (or add + invalidate a `profileProvider`). |
| 🟢 | ✅ v1.12.1 | **v1.12.1 fast-follow — Practice ID prefix in export filename.** *(Owner idea, v1.12.0.)* Name exports `saranidhi-backup-<first8-of-ownerId>-<timestamp>.json` so files are identifiable across devices (avoids Restoring the wrong file). Forward-compatible: at Phase 1 the label becomes the account id / email. Filename-string change only, no logic/schema. |
| 🟢 | ⬜ | **Widen sync scope** (profile / preferences) if wanted, after sessions prove out. |
| 🟢 | ⬜ | **Evaluate a local-first CRDT / hosted sync layer** if the validator group grows or real-time is needed; fold into native **CloudKit** when the Apple track ships (the built engine is Apple-native). |

**Grounding facts (verified in code):** all tables use **UUID v4** `TextColumn id` PKs
(`journal_repository.dart` `_uuid.v4()`) → union-merge is collision-free; schema **v6**
(Phase 0 → v7 for `ownerId`); `DatabaseExporter.importFromBytes` is **destructive** today
(l.77–94 deletes every table) — the exact thing Phase 0 replaces; the built
`CloudKitSyncEngine` (primary-wins, pull-merge-push, device IDs) is Apple-native-only and parked
for the native track; the Google-Drive repo is a **stub**. **Provenance:** owner's real
cross-device practice pain (2026-09-14) · existing `DatabaseExporter` + `cloud_backup/*` scaffold ·
offline-first / zero-backend principle (`product-scope.md`) — consciously reframed to
"local-first with optional user-owned sync."

---

## Chronobiology & Holistic Guidance

> Spec: [`research/advanced_somatic_mastery.md`](../research/advanced_somatic_mastery.md) §2.
>
> **Status: core scoped as Sprint 40 (v1.10.0)** via `/plan` — see
> [sprint-tracker](sprint-tracker.md#sprint-40-chronobiology--holistic-guidance-v1100--planned)
> + [dossier](sprints/sprint-40-chronobiology/README.md). The five items below marked
> `→ S40` are in that sprint; the remainder stay as fast-follows.

| Priority | Status | Item |
|----------|--------|------|
| 🔴 | 📋 → S40 | ChronobiologyAnalytics — time-weighted sliding-window stagnancy detection (≥6h mild, ≥8h chronic) |
| 🟡 | 📋 → S40 | Dynamic Somatic Cards — Swara-Ahara dietary fire prompt on the Kriya Focus Card |
| 🟡 | 📋 → S40 | Tattva-Somatic temperature-regulation tips (Sheetali for excess fire, Surya Bhedana for cold) |
| 🟡 | 📋 → S40 | Swara Pada Gamana waking advice in the morning summary notification |
| 🟡 | 📋 → S40 | Dashboard stagnancy warning card (heating/cooling lifestyle recommendations) |
| 🟢 | ⬜ | Cognitive Energy Budgeting labels in Best Times / Explore (Artha/Kriya/Yoga suggestions) |
| 🔴 | 📋 → S40 | Tamil translations for all holistic/somatic guidance text (bilingual is a DoD gate on S40) |

---

## Analytics & Insights

> **✅ DECIDED (`/plan`):** keep the journal CSV (built + genuinely useful, just mis-placed) →
> **move it from Analytics to Settings** alongside the JSON export. **Scheduled as Sprint 41
> (v1.10.1)** together with the Analytics-page Tamil-localization fixes — see
> [sprint-tracker](sprint-tracker.md#sprint-41-analytics-tidy--tamil-l10n-fixes-v1101--planned).

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | 📋 → S41 | **Analytics export — move CSV to Settings** (owner-decided option 2). Relocate the Analytics `_ExportCard` (journal-only CSV) next to the Settings full JSON export/import; free the Analytics slot. Keep CSV (human-readable/spreadsheet path) — do NOT remove. |
| 🟡 | 📋 → S41 | **Analytics-page Tamil l10n fixes** — hardcoded-English / untranslated strings on the Analytics screen (the recurring partially-localized-widget miss). Audit + localize. |
| 🟢 | ⬜ | Shareable summary / PDF report of alignment and hold-time progress. *(The higher-value slot filler if the Analytics real estate is reconsidered later.)* |
| 🟢 | 📋 → S43 | **BUG-v1.10.1-01 — Monthly Patterns "Best Day" / "Worst Day" value unlocalized.** In Tamil mode the *label* is localized (`சிறந்த நாள்`) but the *value* renders the English day name (`Sunday`, not `ஞாயிறு`). Root cause: `AnalyticsCalculator._weekdayName()` (`analytics_calculator.dart:434–443`) returns hardcoded English day strings, stored on `patterns.bestDay`/`worstDay` and rendered raw by `_MonthlyPatternsCard` (`analytics_screen.dart:225–226`). **Pre-existing** l10n debt (not a Sprint 41 regression — out of the S41 spec's targeted scope; surfaced by the v1.10.1 slim smoke). Minor/cosmetic, shipped as a known defect in v1.10.1. **Fix:** carry the integer weekday on the domain model and map via `DateFormat.EEEE(Localizations.localeOf(context).toString())` in the widget (localize `worstDay` too); add a localized-weekday test. **Scheduled as Sprint 43 (v1.11.1) Task 43.2.** |
| 🟢 | 📋 → S43 | **BUG-v1.11.1-01 — About-card Developer name not localized.** In Tamil mode the About-card **Developer** row shows the hardcoded Latin `Eialarasu` (`about_card.dart:87` `value: 'Eialarasu'`) while the **copyright** line already localizes the name to `இயலரசு` (`aboutCopyright`) — the same person's name renders two ways. Same class as BUG-v1.10.1-01 + the v1.8.1 notification-l10n hotfix (label localized, value not). **Fix:** add ARB key `aboutDeveloperName` (EN `Eialarasu` / TA `இயலரசு`) and use it for the Developer row value; leave email + website as literal identifiers. Surfaced by owner (2026-09-14). **Scheduled as Sprint 43 (v1.11.1) Task 43.1.** |
| 🟢 | 📋 → S43 | **BUG-v1.11.1-02 — Yama prefix not localized (Best Times + Day/Night Schedule).** Hardcoded `'Y…'` yama badges: the Home "Best Times This Week" card (`best_times_card.dart:183`) AND the ☀️ Day / 🌙 Night Schedule card (`full_day_schedule.dart:142`, shown on Today + Explore) both showed `Y1` in Tamil while Analytics already used the localized `yamaShortPrefix` (`யா`). Same class as BUG-v1.11.1-01 / BUG-v1.10.1-01. **Fix:** `'${l10n.yamaShortPrefix}…'` in both (`l10n` already in scope). Owner-found (2026-09-14). **Fixed in Sprint 43 (v1.11.1) Task 43.5** — Best Times first, Full Day Schedule added during the v1.11.1 smoke (the initial fix missed it; exhaustive `lib/features/home` grep now clean). |
| 🟢 | ⬜ | **BUG-v1.11.1-03 — `YamaSegment.label` unlocalized in notification title + AI payload.** `YamaSegment.label` / `NightYamaSegment.label` return hardcoded `'Yama N'` (`yama_calculator.dart:10,64`), surfaced unlocalized in the yama-transition **notification title** (`notification_scheduler.dart:203` `'Saranidhi — ${yama.label}'`) and the AI-wisdom context payload (`wisdom_context.dart:52`). Lower severity (notification layer, not the dashboard); **out of v1.11.1's cosmetic-UI scope** — surfaced during the v1.11.1 smoke sweep. **Fix (later patch):** localize the notification title via `l10n.yamaShortPrefix`/`yamaPrefix` (the AI payload can stay a stable English key or be localized per design). |

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

## User Guide — Book-Style Navigation & Search

> **Status: scoped via `/plan` (owner-confirmed); medium priority, sequenced AFTER the native
> "Now" Surface.** The in-app User Guide's *content* is already the right shape — code-tied,
> versioned, bilingual (12 `_Section`s + a bilingual reference section, sourced from `guide*`
> ARB keys in `user_guide_screen.dart`). The gap is **navigation**: it's a single flat
> `CustomScrollView` (top-to-bottom scroll only — no ToC, no jump-to-section, no search, no
> collapse), which gets unwieldy as the guide grows (Swara Clock, Chronobiology, and soon the
> Now Surface all add sections).
>
> **Decision (owner-confirmed):** deliver **book-like UX qualities natively in Dart** — keep
> content in Dart/ARB (offline-first, bilingual pipeline intact); upgrade only the presentation.
> **Explicitly NOT** by embedding the separate `saranidhi-book` Astro/Starlight site (a WebView
> breaks offline-first + native feel + bundle size, and couples the app to a separately-deployed
> site). The book repo stays a **distinct** general-audience artifact; this epic is purely the
> *in-app* guide's navigation.
>
> **Keystone = a structured content model.** Replace the hardcoded inline `_Section(...)` calls
> with a `List<GuideSection>` (id · title · body · keywords · optional subsections), each still
> pulling its `l10n` strings. The ToC, search, and per-section views then all derive from that
> one list — adding a chapter becomes a single entry, 100% Dart/ARB/bilingual.

| Priority | Status | Item |
|----------|--------|------|
| 🟡 | ⬜ | **Structured `GuideSection` content model** — `List<GuideSection>` (id, title, body, keywords, subsections) sourced from `guide*` ARB keys; single source of truth that drives ToC + search + section views. Replaces inline `_Section(...)` widget calls. |
| 🟡 | ⬜ | **Table of Contents / chapter landing** — guide opens to a tappable section list (not a wall of text); tap → open/scroll to that section. The #1 navigation win. |
| 🟡 | ⬜ | **Collapsible sections** — `_Section` → `ExpansionTile` (Flutter built-in), collapsed by default = scannable; zero new deps. |
| 🟡 | ⬜ | **Offline in-guide search** — search field filtering sections by title/body/keywords (data is already in-memory ARB strings → trivial filter + highlight); fully offline, no backend. |
| 🟢 | ⬜ | **Jump-to-section / deep anchors** — `ScrollController` + `GlobalKey` per section (or per-section routes) so other surfaces can deep-link into the guide. |
| 🟢 | ⬜ | **Deep-link help from feature surfaces** — the Aruḍam "Why?" accordion / Now Surface link straight into the relevant guide section (synergy with the structured model). |
| 🔴 | ⬜ | **Bilingual (EN/TA)** — ToC labels, search field/placeholder, empty-search state, section titles all localized; keep the reference tables bilingual. DoD gate. |

> **Guardrails / scope discipline:**
> - Keep content in **Dart/ARB** — do NOT move to asset Markdown (loses the bilingual ARB
>   pipeline) or a WebView (loses offline-first).
> - Right-size it: the guide is ~12 sections → it needs **navigation + search + collapse**, not
>   a full CMS.
> - **User Guide DoD = NOT `n/a`** for this sprint — it *is* the user-facing capability.
>
> **Sequencing:** medium priority, **after the native "Now" Surface** — the Now Surface adds a
> guide section anyway, so upgrade the guide once *after* that chapter lands (not right before).
> Natural synergy: the structured model enables the Now Surface's deep-linkable "Why?" help.
>
> **Vehicle:** feature sprint (spec → Antigravity local-green → Kiro review). New content model +
> ToC screen + search + section routing + widget tests. **Provenance:** in-app guide
> (`user_guide_screen.dart`, `guide*` ARB keys) · three-artifact vision (app guide ≠ book — see
> `product-scope.md` North Star) · offline-first / zero-backend principle.

---

## Swara Clock Engine & Weekday Udhaya (Nostril Pattern correction)

> **Status: ✅ SHIPPED as Sprint 42 (v1.11.0-web).** Retained for provenance — see
> [sprint-tracker](sprint-tracker.md#sprint-42-swara-clock-engine--weekday-udhaya-calibration-v1110--planned).
> A **correctness-critical calculation fix** to how the app predicts the *expected nostril* —
> the readiness half of the flagship Aruḍam verdict.
>
> **The bug (owner-adjudicated, doctrinal):** today the app predicts expected-nostril on the
> **Pakshi bird-state yama clock** (daylight ÷ 5 ≈ 2.4h segments, tithi-seeded alternation, in
> `nostril_pattern.dart` → consumed by `AlignmentChecker`, the Nostril Pattern dashboard card,
> **and the Aruḍam Now readiness multiplier**). Per **CONF-014** the swara clock is a **separate
> ~1-hour / 24-cycle clock** (12h R + 12h L, the 21,600-breath ledger) — *the thing a user can
> physically verify by checking their nostril.* Predicting it on the ~2.4h yama clock creates
> artificial "misalignment" for ~half of every daytime hour, wrongly dampens the verdict (×0.75),
> and fails the self-verifiable North Star.
>
> **The two owner-confirmed fixes (this epic):**
> 1. **Rebuild expected-nostril on the 1-hour / 24-cycle swara clock (CONF-014)** — fully decouple
>    it from the Pakshi bird-state yama clock. The yama clock keeps driving bird states.
> 2. **Seed the day's first swara at dawn from the CONF-013 Weekday Udhaya table** (NOT the tithi):
>    1-hour dawn days — Sun **R**, Mon **L**, Thu-Shukla **L**, Sat **R**; 2-hour dawn days —
>    Tue **R**, Wed **L**, Thu-Krishna **R**, Fri **L** (mnemonic: Heating Sun/Tue/Sat = R,
>    Cooling Mon/Wed/Fri = L; Thu flips by paksha). Progression: 1-hour days alternate hourly from
>    the seed; 2-hour days hold the seed for the 2-hour Udhaya inception window, then alternate hourly.
>
> **Why before the calibration pause (the dependency paradox):** the 7-day Accuracy Calibration
> compares Saranidhi vs Align27 vs Panchangam vs *actual breath*. If the swara clock is still on
> the broken yama model, **every breath observation collected during the pause tests the wrong
> engine** — invalid calibration data. So this MUST land before the data-collection pause.
>
> **Cleanup folded in:** re-key the `integrated_arudam_engine.dart` floor-lock citation — it cites
> `CONF-018`, but CONF-018 is Topic 10 (Daytime-Left/Nighttime-Right macro-seal), not the
> inauspicious-window rule. Fix the citation; CONF-018 can then properly back the optional day/night
> macro framing.
>
> **Vehicle:** correctness-critical → the **Sprint 37 birth-bird protocol** (formal spec →
> Antigravity coding-setup with local green baseline + isolated test cases against the workshop
> transcripts → Kiro Web reviews the real diff). **Regression gate:** pin that bird-state / Pakshi
> logic is UNCHANGED (only the nostril clock moves); add explicit swara-clock tests (weekday seeds,
> 1h vs 2h dawn, hourly progression, day boundary).

**Provenance:** CONF-014 (two clocks — 1h swara / 24-cycle vs 1.5h yama) · CONF-013 (Weekday Udhaya
dawn table + Thu paksha split) · CONF-001 (sunrise-anchored civil day) · CONF-018 (Day/Night
macro-seal — for the citation fix + optional framing) · `nostril_pattern.dart`, `alignment_checker.dart`,
`nostril_dominance_chart.dart`, `integrated_arudam_engine.dart`.

---

## Accuracy & Validation

> **Prerequisite:** Owner collects 7-day Align27 + Tamil Panchangam data BEFORE calibration work starts.
> **HARD PRE-REQUISITE (added `/plan`):** the **Swara Clock Engine fix (Sprint 42)** MUST ship
> before the 7-day data collection — otherwise every breath log calibrates the broken yama-clock
> model (the dependency paradox). Collect data only after v1.11.0 is live.

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
| 🟡 | ✅ S46 | Set up Playwright for Flutter Web E2E tests (separate repo `vteial/saranidhi-e2e`) — **done in Sprint 46** ([e2e PR #1](https://github.com/vteial/saranidhi-e2e/pull/1)); harness scaffolded, 1m24s green run |
| 🟡 | ✅ S46 | Automate critical-path scenarios from the smoke test — **done**: Step 0 + S1–S6 (onboarding, import-before-onboarding, in-place refresh, filename, Merge/Restore + owner-guard, EN/TA), per-step screenshot evidence |
| 🟡 | ✅ S46 | Integrate E2E into CI — **done**: `workflow_dispatch` against a preview URL, OFF the Flutter PR path |
| 🟢 | ⬜ | **Harden the E2E harness (Sprint 46 follow-ups, Kiro review):** replace the few soft `waitForTimeout` settle-waits with predicates; remove the hardcoded pixel fallbacks in `navigateToSettings`/`goBackFromSettings` (make the semantic gear/back locator reliable) — **required before E2E ever becomes a *blocking* release gate** (avoids the quarantined-ChromeDriver flake trap). |
| 🟢 | ⬜ | Visual regression snapshots for key screens |
| — | ✅ | **Ad-hoc-run stopgaps adopted (v1.12.1 post-mortem):** selective state-reset (never wipe the Vercel bypass cookie) + event-driven waiting (no fixed `sleep()`s), in [`qa-verify-agent-prompt.md`](../testing/qa-verify-agent-prompt.md). Superseded by the Sprint 46 harness. |
| 🟡 | ⬜ | Notification de-duplication / cooldown to avoid repeats during a sustained window. |
| 🟢 | ⬜ | Periodic staging-data / smoke-data hygiene as the app grows. |
| 🟡 | ⬜ | Revisit the 19% coverage gate once UI/E2E coverage exists — raise it then. |
| — | ✅ | Two-tier CI (fast PRs + full on merge/prod, with ci-full now also running on PRs to main) — in place. |

### Process Hardening (post-v1.8.0 batch)

> Deferred **until after v1.8.0 ships** to avoid colliding with the in-flight release
> (Antigravity writing smoke-test results on `release/v1.8.0`). Surfaced during the
> v1.8.0 release cycle.

| Priority | Status | Item |
|----------|--------|------|
| 🟢 | 🔄 | **Vercel preview-auth bypass for QA-Verify — remaining polish.** The durable fix is **DONE** (PR #188): Vercel "Protection Bypass for Automation" is enabled, the secret lives in local `.env` (gitignored), and the QA-Verify template uses the `x-vercel-protection-bypass` query param — protection stays ON for humans. *Remaining:* add the bypass step to the `/release-start` protocol in `dev-workflow.md`, and port the mechanism into `vteial/project-blueprint`. *(Refs: [Vercel automated-access docs](https://vercel.com/docs/deployment-protection/automated-agent-access).)* |
| 🟡 | ⬜ | **Group release transactional docs into per-release folders** (mirror the sprint-dossier convention). `docs/testing/releases/vX.Y.Z/` containing `README.md` (index) + `smoke-test.md` + `release-notes.md` + `docs-audit.md` + `qa-verify-prompt.md` (drop the `-vX.Y.Z` suffix — the folder carries it). **Scope: migrate the "rich" releases only (v1.7.0 + v1.8.0); leave the 11 legacy single-smoke-test files flat** (a lone historical smoke record doesn't need a folder). Update all cross-links (smoke-test-results index, framework §8, dossier READMEs, dev-workflow, templates) in the same PR; fold v1.8.0 into the new shape during its `/release-update`. Add the folder convention to `/release-start` + the blueprint so future releases are born as folders. |
| 🟡 | ⬜ | **Port the Vercel skip-doc-builds `ignoreCommand` into `vteial/project-blueprint`** (`templates/deployment/`) — a generic app-path-allowlist ignore script (from Saranidhi PR #185). Every Vercel-hosted project benefits. |
| 🔴 | 🔄 | **Vercel deployment-quota strategy — finish the fix.** The v1.10.0 release-branch preview build **failed on the Hobby 100-deployments/day cap** (2026-09-12). Root cause: a **skipped `ignoreCommand` build still counts** as a deployment, **two** connected projects double every push, and the release lifecycle is push-dense. **DONE (PR #206 + blueprint PR #4):** `vercel.json` `git.deploymentEnabled` denies `docs/**` + `plan/**` on the prod project; strategy documented in `deployment.md` + `dev-workflow.md`; generalized into the blueprint. **REMAINING — owner dashboard action (not in-repo):** set the **`saranidhi-staging`** project → Settings → Environments → Preview → **Branch Tracking OFF** (deploy only `main`). **VERIFY next release:** confirm a `docs/*` / `plan/*` push produces **0** deployments and a `release/*` push produces exactly **1** (prod-project preview) — i.e. the v1.10.0 release-finish cycle stays well under the cap. *(Refs: [community](https://community.vercel.com/t/monorepo-initiates-deployment-even-if-skip-built-is-enabled/27233), [discussion #5716](https://github.com/vercel/vercel/discussions/5716).)* |

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
