[← Back to Sprint Dossier](./README.md) · [Sprint Tracker](../../sprint-tracker.md)

# Sprint 39 — Integrated Aruḍam: "Why?" Provenance Accordion (v1.9.0) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup.** Implement with local
> `flutter analyze` + `flutter test` **GREEN before opening the PR**. This sprint touches
> the shipped `IntegratedArudamEngine` (adds fields, behavior-preserving) and the shipped
> `ArudamNowCard` — the Oracle path and the existing verdict rendering must remain
> unchanged (see the regression gate in §9). Kiro Web reviews the PR.
> All design decisions are **owner-confirmed** in the Phase-2b `/plan` (PR #179) — see the
> [flagship epic](../../sprint-backlog.md#-flagship--integrated-aruḍam), the "Why?" surface
> row and the verdict-transparency confirmed decision.

## 0. Prerequisite — environment + known-GREEN baseline (do FIRST)

Per [`docs/process/dev-setup.md`](../../dev-setup.md). Establish the baseline before
touching Sprint 39 code:

```bash
flutter --version      # stable ≥3.44 / Dart ≥3.12.1
flutter pub get
flutter analyze        # expect: no issues
flutter test           # baseline: green EXCEPT the 4 known CloudKit failures
```

**Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected failures**
in `test/features/cloud_backup/backup_repository_test.dart` (CloudKit "on non-Apple
platform" cases — pass on CI Ubuntu). The gate = "green **except those same 4**." If
`analyze` isn't clean, or `test` shows any failure beyond those 4, **STOP and report before
starting.**

Cleanest noise-free subset for this sprint (no CloudKit):
`flutter test test/features/astro_engine/ test/features/widgets/arudam_now_card_test.dart`

## 1. What this slice is

Delivers the **verdict-transparency** promise the flagship made but slice 1 did not build:
a tap-to-expand **"Why?"** accordion on the always-on "Aruḍam Now" verdict card that
explains the verdict **doctrinally, in plain language, with provenance** (the corpus
practice + CONF number each factor rests on).

**Owner-confirmed design rules (do not deviate):**
- The verdict card **always shows the two clocks in plain language** (Moment / You) — that
  already ships. The **"Why?"** is a **collapsed-by-default**, tap-to-expand section.
- **Never show raw arithmetic** (no "80 × 0.75 = 60"). Explain in doctrine and factor
  language ("your bird is *Ruling* — a strong moment; breath not naturally aligned, so the
  window is dampened, not blocked").
- **No tooltips** anywhere (touch-hostile; hides the trust content). The explanation lives
  in the expandable body, always reachable by tap.
- **Provenance is the point:** each explanation cites the corpus practice + CONF id it
  implements (e.g. "*Two clocks — swara ~1h, bird-yama ~1.5h · CONF-014*"). This is what
  makes the ≥95% doctrinal-fidelity claim auditable at the surface.
- **Bilingual EN/TA**, matching the sacred tone of the rest of the card.

### The card, after this sprint

```
🦅 ARUḌAM NOW — Vardhana (78)
Moment: Bird Ruling · Jupiter hora  (strong)
You: naturally aligned  ✓
[ guidance prose box ]
▸ Why?                                         ← collapsed by default
   ── expanded ──────────────────────────────
   Moment (the timing): your birth bird is
   Ruling — the strongest state to act; the
   Jupiter hora harmonises with your breath.
   · Panja Pakshi bird-state — CONF-PP-004
   You (your readiness): your breath is
   naturally aligned with this window, so the
   moment stands at its full height.
   · Swara alignment — CONF-014
   ▸ (if floor-locked) An inauspicious window
   (Rahu Kaal) overrides all — the higher path
   is to rest. · CONF-018 / inauspicious windows
```

## 2. Engine + card reality (what exists — from a codebase map this session)

- **`lib/features/astro_engine/domain/integrated_arudam_engine.dart`** —
  `IntegratedArudamEngine.evaluate({birdState, window, category, tarabalaMultiplier,
  horaSwaraMultiplier, isAligned, actualSwara, isRahuActive, isEmakandamActive})` →
  `IntegratedArudamResult{score, momentScore, readinessMultiplier, band(OracleBand),
  englishGuidance, tamilGuidance, isFloorLocked}`. **GAP:** the driving factors
  (`baseScore`, `categoryHarmony`, `tarabalaMultiplier`, `horaSwaraMultiplier`) are computed
  as locals in `evaluate()` and **discarded** — the result exposes no per-factor breakdown
  and no CONF citations. Building "Why?" needs a **structured factor breakdown**.
- **`lib/features/home/presentation/widgets/arudam_now_card.dart`** — a **stateless**
  `ConsumerWidget`. The verdict is computed inline in `build()` (call at ~lines 134–144);
  the two-clock rows render at ~216–290; the guidance `Container` closes at ~331. **All the
  driving factors are live local variables at that point** (`birdState`, `window`,
  `category`, `tarabalaMultiplier`, `horaSwaraMultiplier`, `isAligned`, `actualSwara`,
  `isRahuActive`, `isEmakandamActive`, `verdict`). **There is no `ExpansionTile` anywhere in
  the codebase**; the only expand/collapse precedent is the hand-rolled `Set` + `setState`
  in `lib/features/breath_journal/presentation/widgets/journal_history_list.dart`.
- **Provenance:** CONF ids live only in the corpus docs
  (`docs/research/sarakalai-workshop-knowledge.md` — CONF-001..026, all resolved;
  `docs/research/panja-pakshi-workshop-knowledge.md` — CONF-PP-001..006) and as inline Dart
  **comments**. **There is no Dart-side factor→CONF map** — that mapping is net-new.
- **L10n:** `lib/l10n/app_en.arb` + `lib/l10n/app_ta.arb`, each key paired with an `@key`
  metadata entry; placeholders supported (see `arudamMomentBreakdown`). The card already
  localizes every string via `l10n.*`.

## 3. Task 39.1 — Add a structured factor breakdown to the engine result

**File:** `lib/features/astro_engine/domain/integrated_arudam_engine.dart`.

**Goal:** make the verdict *self-explaining* so the card renders "Why?" from data, not from
re-deriving factors in the widget. Add a **new field** to `IntegratedArudamResult`; do
**not** change existing fields (behavior-preserving — see §9).

- Define a small enum for provenance keys (kept next to the engine):

  ```dart
  /// A single doctrinal reason contributing to an Aruḍam verdict, with provenance.
  /// `messageKey` selects the localized explanation; `conf` is the citation shown verbatim.
  enum ArudamFactor {
    birdState,        // Panja Pakshi bird-state ceiling — CONF-PP-004 (ruling planets/state)
    horaSwara,        // Hora × swara affinity — CONF-014 (two clocks) / CONF-012 (tattva)
    tarabala,         // Navatara category weight — Panja Pakshi tarabala
    categoryHarmony,  // Action-window vs query-category harmony
    readiness,        // breath alignment multiplier — CONF-014 / CONF-016 / CONF-017
    sushumna,         // Sushumna neutral — CONF-026
    floorLock,        // Rahu/Emakandam override — CONF-018 (inauspicious windows)
  }

  /// One line of the "Why?" explanation: which factor, its qualitative strength,
  /// and the CONF id to cite. NO raw numbers.
  class ArudamReason {
    const ArudamReason({
      required this.factor,
      required this.strength,   // FactorStrength — strong / moderate / weak / blocking
      required this.conf,       // e.g. 'CONF-014', 'CONF-PP-004'
    });
    final ArudamFactor factor;
    final FactorStrength strength;
    final String conf;
  }

  enum FactorStrength { strong, moderate, weak, blocking }
  ```

- In `evaluate()`, **as you already compute** `baseScore`, `categoryHarmony`,
  `tarabalaMultiplier`, `horaSwaraMultiplier`, and `readiness`, also build a
  `List<ArudamReason> reasons` classifying each into a `FactorStrength` band. Suggested
  thresholds (qualitative only — never surfaced as numbers):
  - bird base ≥ 80 → `strong`; 40–79 → `moderate`; < 40 → `weak`.
  - a multiplier ≥ 1.1 → `strong`; 0.9–1.1 → `moderate`; < 0.9 → `weak`.
  - readiness 1.0 → `strong` (naturally aligned); 0.75 → `weak` (not aligned);
    `actualSwara == null` → omit the readiness reason (stale — nothing honest to say).
  - Sushumna active → emit the `sushumna` reason instead of `readiness`.
  - When floor-locked (Rahu/Emakandam): the `reasons` list is **just** the single
    `floorLock` reason with `strength: blocking` (it overrides everything — do not also list
    Moment factors, per the North Star "the higher path is to rest").
- Add `final List<ArudamReason> reasons;` to `IntegratedArudamResult` (required in the
  constructor). All existing call sites construct the result inside `evaluate()`, so only
  that one construction site changes.
- **Do NOT** put localized prose in the engine. The engine emits `ArudamFactor` +
  `FactorStrength` + `conf` (data); the **card** maps them to localized strings (§5). This
  keeps the engine pure-Dart/testable and the localization in one place.

## 4. Task 39.2 — The provenance/citation source of truth

The `conf` strings above are the *citations*. Record the factor→CONF mapping in **one
place** so it is auditable and matches the corpus:

| ArudamFactor | Citation shown | Corpus basis |
|--------------|----------------|--------------|
| `birdState` | `CONF-PP-004` | Panja Pakshi bird-state / ruling-planet table |
| `horaSwara` | `CONF-014` | Two clocks — swara ~1h vs Pakshi yama ~1.5h |
| `tarabala` | `CONF-PP-001/002` | Birth-star Navatara partition |
| `categoryHarmony` | `CONF-015` | Tattva/action-type contextual harmony |
| `readiness` | `CONF-016 / CONF-017` | Switching is a nudge; reliability over forcing |
| `sushumna` | `CONF-026` | Sushumna = transcendent neutral (meditation-favourable) |
| `floorLock` | `CONF-018` | Day/Night inauspicious-window seal |

- The mapping lives in the engine (as the `conf` value each `ArudamReason` carries), so the
  **data** is the single source of truth. Add a short doc-comment above `ArudamFactor`
  linking each to its CONF, mirroring the existing inline-comment convention
  (`pakshi_attributes.dart` etc.). Do **not** duplicate the mapping in the widget.
- These CONF ids are already the cited provenance for this epic in
  [`sprint-backlog.md`](../../sprint-backlog.md#-flagship--integrated-aruḍam) — keep them
  consistent; if the implementer finds a better-matching resolved CONF, flag it in the
  implementation summary for Kiro Web review rather than silently changing it.

## 5. Task 39.3 — Render the "Why?" accordion in the card (bilingual)

**File:** `lib/features/home/presentation/widgets/arudam_now_card.dart`.

- **Expand state:** the card is a stateless `ConsumerWidget`. Extract a small
  **`_WhySection`** as a `StatefulWidget` (holds a single `bool _expanded = false`) rather
  than converting the whole card — keeps the verdict computation in the existing `build()`
  and localizes the new state. Pass it `verdict.reasons`, `verdict.isFloorLocked`, and the
  `l10n`. (An `ExpansionTile` is acceptable if it themes cleanly, but a hand-rolled
  header-row + `AnimatedCrossFade`/conditional body matches the existing
  `journal_history_list.dart` precedent and gives full control of the "▸ Why?" affordance.)
- **Placement:** insert `_WhySection` as the **last child of the outer `Column`**, after the
  guidance `Container` closes (~after line 331). Full-width, below the guidance box.
- **Collapsed:** a single tappable row — a chevron/triangle that rotates + the label
  `l10n.arudamWhyLabel` ("Why?"). Minimum 44×44 tap target.
- **Expanded body:** for each `ArudamReason` in `verdict.reasons`, render one line:
  `<localized factor explanation for its FactorStrength>` followed by a subdued
  `· <conf>` citation chip/text. Group under two subheads when not floor-locked —
  **Moment (the timing)** for `birdState/horaSwara/tarabala/categoryHarmony`, and
  **You (your readiness)** for `readiness/sushumna`. When floor-locked, render the single
  `floorLock` reason under a **Blocked** subhead (no Moment/You split).
- **Localized strings (new ARB keys, BOTH `app_en.arb` + `app_ta.arb`):** add one key per
  (factor × strength) explanation that can actually occur, plus the structural labels. Keep
  them doctrinal and plain-language — no numbers. Suggested keys:
  - `arudamWhyLabel` ("Why?")
  - `arudamWhyMomentHeading` ("Moment — the timing"), `arudamWhyYouHeading` ("You — your
    readiness"), `arudamWhyBlockedHeading` ("Blocked")
  - `arudamWhyBirdStrong` / `arudamWhyBirdModerate` / `arudamWhyBirdWeak`
    (e.g. strong → "Your birth bird is in a strong, favourable state — a good moment to
    act.")
  - `arudamWhyHoraStrong` / `arudamWhyHoraModerate` / `arudamWhyHoraWeak`
  - `arudamWhyTarabalaStrong` / `arudamWhyTarabalaModerate` / `arudamWhyTarabalaWeak`
  - `arudamWhyHarmonyStrong` / `arudamWhyHarmonyModerate` / `arudamWhyHarmonyWeak`
  - `arudamWhyReadinessAligned` ("Your breath is naturally aligned, so the window stands at
    its full height.") / `arudamWhyReadinessMisaligned` ("Your breath isn't naturally
    aligned, so the moment is dampened — not blocked. The higher path is to wait.")
  - `arudamWhySushumna` ("Sushumna flows — energy turns inward. Favourable for stillness and
    meditation, not for worldly action." → CONF-026)
  - `arudamWhyFloorLock` ("An inauspicious window is active and overrides all other factors.
    The higher path is to rest and turn inward." → CONF-018)
  - `arudamWhyCitation` — a `"· {conf}"` wrapper with a `{conf}` placeholder (String).
  - Provide the exact EN strings in the PR; Tamil must be **pure Tamil script** (no
    transliteration placeholders), matching the existing `arudam*` Tamil keys.
- Every new string is an `l10n.*` getter — **no hardcoded English `Text()`** (the recurring
  miss; the v1.8.1 hotfix was exactly this class of bug). Run the Pre-PR Tamil-mode
  eyeball.

## 6. Task 39.4 — Keep the Oracle path unaffected

The `OracleCompositeEngine` delegates to `IntegratedArudamEngine`. Adding the `reasons`
field must not change any existing Oracle behavior:
- The Oracle screen (`prasanam_screen.dart`) does not render `reasons` — it keeps using
  `score/band/guidance` exactly as today. Leaving `reasons` unread is fine.
- If the Oracle ever wants the same "Why?", that is a **fast-follow**, out of scope here.

## 7. Out of scope (explicitly — do not build)

- Native ambient surface (widget/watch/macOS) — separate fast-follow.
- Tuning the 0.75 readiness penalty — blocked on the 7-day Accuracy & Validation data.
- A "Why?" on the Oracle deep-consultation screen — fast-follow.
- Any change to the scoring math, bands, or floor-lock logic (this is a *transparency*
  sprint, not a scoring sprint).

## 8. Tests (add; keep the suite green)

- **`test/features/astro_engine/integrated_arudam_engine_test.dart`** (extend): assert the
  new `reasons` list — (a) a strong/aligned case lists `birdState:strong` +
  `readiness:strong`; (b) a misaligned case lists `readiness:weak`; (c) `actualSwara==null`
  (stale) **omits** the readiness reason; (d) Sushumna case emits `sushumna` not
  `readiness`; (e) floor-locked case → `reasons` is exactly one `floorLock:blocking` (no
  Moment factors); (f) each reason carries the expected `conf` string. Keep all existing
  `score/momentScore/readinessMultiplier/band/isFloorLocked/guidance` assertions unchanged.
- **`test/features/widgets/arudam_now_card_test.dart`** (extend): (a) "Why?" label renders
  and the body is **collapsed by default** (reason prose not found); (b) tapping "Why?"
  reveals the doctrinal prose + a CONF citation (`find.textContaining('CONF-')`);
  (c) floor-locked (Rahu active) → expanded body shows the single blocked explanation +
  `CONF-018`, and does **not** show Moment/You subheads; (d) misaligned → expanded body
  shows the "dampened, not blocked / wait" readiness line. Keep the existing 6 cases green.
- **Tamil:** a widget test (or the existing Tamil harness) asserting the "Why?" label and at
  least one reason line render in Tamil script under a `ta` locale, if the harness supports
  locale override; otherwise cover via the Pre-PR Tamil-mode manual eyeball and note it.

## 9. Delivery constraints / regression gate

- **Behavior-preserving:** `IntegratedArudamResult` gains one field (`reasons`); **no**
  existing field changes type or meaning; `evaluate()` returns identical
  `score/momentScore/readinessMultiplier/band/isFloorLocked/guidance` for every existing
  test input. The engine's existing tests must pass **unchanged** (only additions).
- **Oracle unchanged:** `OracleCompositeEngine.evaluate` output is identical; the Oracle
  screen renders identically.
- **Card:** the header + two-clock rows + guidance box render exactly as today when the
  "Why?" section is collapsed (its default). The only visual addition is the collapsed
  "▸ Why?" row.
- **No raw math, no tooltips, no hardcoded English.** All new copy bilingual.
- Local `flutter analyze` clean + `flutter test` green (except the 4 CloudKit baseline)
  **before** the PR. Web build clean.

## 10. Definition of Done

- [ ] `ArudamReason` / `ArudamFactor` / `FactorStrength` + `reasons` field added; engine
      behavior-preserving; factor→CONF mapping documented in the engine.
- [ ] `_WhySection` renders collapsed-by-default; expands to doctrinal prose + CONF
      citations; Moment/You grouping; floor-lock single-reason path.
- [ ] All new strings bilingual (EN + pure-Tamil ARB), zero hardcoded `Text()`.
- [ ] Engine tests extended (reasons per case); card tests extended (collapse/expand +
      provenance + floor-lock + misaligned); existing tests unchanged & green.
- [ ] `flutter analyze` clean; `flutter test` green (except 4 CloudKit); web build clean.
- [ ] Implementation + test summaries filled; PR opened for Kiro Web review.

**Provenance:** North Star verdict-transparency + "Agency, not Fate" (`product-scope.md`) ·
CONF-014 (two clocks) · CONF-015 (contextual harmony) · CONF-016/017 (nudge, not guarantee) ·
CONF-018 (inauspicious windows) · CONF-026 (Sushumna neutral) · CONF-PP-001/002/004
(bird-state / tarabala) · existing `IntegratedArudamEngine`, `ArudamNowCard`.
