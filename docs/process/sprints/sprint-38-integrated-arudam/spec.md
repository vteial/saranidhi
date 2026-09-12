[← Back to Sprint Dossier](./README.md) · [Sprint Tracker](../../sprint-tracker.md)

# Sprint 38 — Integrated Aruḍam, Slice 1 (v1.8.0) — Implementation Spec

> **Authored by Kiro Web for the Antigravity IDE coding setup** (Saranidhi local dev
> = pure Antigravity IDE on the owner's Mac). Implement with local `flutter analyze` +
> `flutter test` **GREEN before opening the PR** — Task 38.3 touches shipped calculation
> logic, so CI-only is not sufficient (v1.2.1 lesson). Kiro Web reviews the PR.
> All design decisions here are **owner-confirmed** in the Phase-2b `/plan` (PR #179)
> and the Sprint 38 `/plan` (PR #180); see the
> [flagship epic](../../sprint-backlog.md#-flagship--integrated-aruḍam).

## 0. Prerequisite — environment + known-GREEN baseline (do FIRST)

Per [`docs/process/dev-setup.md`](../../dev-setup.md). Establish the baseline before
touching Sprint 38 code (never change core logic on an already-red suite):

```bash
flutter --version      # stable ≥3.44 / Dart ≥3.12.1
flutter pub get
flutter analyze        # expect: no issues
flutter test           # baseline: green EXCEPT the 4 known CloudKit failures
```

**Known macOS baseline (NOT a regression):** `flutter test` shows **4 expected failures**,
all in `test/features/cloud_backup/backup_repository_test.dart` (CloudKit "on non-Apple
platform" cases — they fail only because `Platform.isMacOS==true` locally and PASS on CI
Ubuntu). The gate = "green **except those same 4**." If `analyze` isn't clean, or `test`
shows any failure beyond those 4, **STOP and report before starting.**

Cleanest noise-free subset for this sprint (no CloudKit):
`flutter test test/features/astro_engine/ test/features/breath_journal/ test/features/streaks/`

## 1. What this slice is

The flagship's first slice: an **always-on "Aruḍam Now" verdict card on Home** that fuses
the separate engines into ONE answer — *"is now a good moment, and what should I do?"*.

**Scoring = Moment × Readiness** (owner-confirmed):
- **Moment** = the existing composite (bird-state × Tarabala × Hora-Swara × category) — the
  *ceiling*, the inherent quality of now.
- **Readiness** = a multiplier from breath-alignment: **aligned → 1.0**, **misaligned →
  0.75** (uniform for v1), **Sushumna → the existing Yoga-context rule**. **Never a floor-lock.**
- Inauspicious windows (Rahu/Emakandam) remain the hard **floor-lock** (score → 10, band
  Sunya) — and this slice makes that floor-lock **24h-correct** (currently day-only).

**North Star (must shape all copy):** the app cultivates **natural** alignment as a lifelong
practice — it never sells shortcuts. Misalignment's default guidance is **wait / accept /
note**. Forced shifting is **urgency-only, warning-toned**, and is **never** presented as the
"fix"/success path. Streaks must eventually reward *natural* alignment (this slice adds only
the data flag — see 38.6).

## 2. Engine reality (what already exists — reuse, don't rebuild)

Confirmed by a codebase map + direct reads this session:

- **`lib/features/astro_engine/domain/oracle_engine.dart`** — `OracleCompositeEngine.evaluate({queryTime, sunrise, sunset, weekday, currentBirdState, currentWindow, tarabalaMultiplier, horaSwaraMultiplier, category, actualSwara})` → `PrasanamResult{score, band, englishGuidance, tamilGuidance, isFloorLocked}`. Already fuses everything + floor-locks + 5 bands (`OracleBand`) + bilingual guidance. **Currently the floor-lock uses `DaylightSegmentResolver`, which returns segment 0 at night → never locks after sunset (the bug 38.3 fixes).** Note: `actualSwara` currently only changes the *guidance prose* (Sushumna), never the *score* (the gap 38.2 fixes).
- **`lib/features/astro_engine/domain/daylight_segment_resolver.dart`** — `DaylightSegmentResolver.resolve(...)`; `isRahuKaal(weekday)`/`isEmakandam(weekday)` return `false` when `activeSegment == 0` (nighttime). This is *why* the floor-lock is day-only.
- **`lib/features/breath_journal/domain/alignment_checker.dart`** — `AlignmentChecker.check({actualFlow, time, latitude, longitude, utcOffset})` → `AlignmentResult{expectedFlow, isAligned, activeYama, activeBird, activeBirdState, actionWindow}`. `isAligned` already encodes the Sushumna-in-Yoga rule. **Not currently wired into the score** (38.2 wires it).
- **`lib/features/streaks/providers/streak_providers.dart`** — `DashboardData` + `dashboardDataProvider` already assemble, 24h, refreshing every 30s: `birthBirdState`, `activeActionWindow`, `activeHora`, `rahuKaal` (`RahuKaalResult{start,end}`), `emakandam` (`EmakandamResult{start,end}`), `sunrise`, `sunset`, `lunarPhase`, `isNight`. **This is the home for the verdict.**
- **`lib/features/prasanam/presentation/prasanam_screen.dart`** — `_evaluateOracle(BreathFlow swara)` is the exact reference wiring (dashboard bird state + window → Tarabala → Hora-Swara → `OracleCompositeEngine.evaluate`). The extracted engine must keep this path producing identical results.
- **`lib/features/home/presentation/today_tab.dart`** — Row 0 currently holds the Action Bar + `FocusCard` + `BirthBirdCard`. The verdict card goes at the **top of Row 0** (above the Action Bar).

## 3. Task 38.1 — Extract `IntegratedArudamEngine` (behavior-preserving)

**New file:** `lib/features/astro_engine/domain/integrated_arudam_engine.dart`.

- Move the composite fusion + bands + floor-lock + bilingual guidance out of
  `OracleCompositeEngine` into a shared `IntegratedArudamEngine` so it is callable from
  the dashboard, not only the Oracle screen. Keep `OracleBand`, `getBaseBirdScore`,
  `getCategoryHarmony` reusable (re-export or move + re-import — implementer's choice, keep clean).
- **`OracleCompositeEngine.evaluate(...)` MUST keep its current signature and return
  IDENTICAL results** — refactor it to delegate to the new engine. This is the
  behavior-preserving constraint (see the regression gate in §9).
- Design the new engine's entry so it takes **explicit inauspicious booleans**
  (`isRahuActive`, `isEmakandamActive`) rather than computing them from the day-only
  resolver — this is what lets 38.3 make it 24h-correct. Suggested shape:

  ```dart
  IntegratedArudamResult IntegratedArudamEngine.evaluate({
    required PakshiState birdState,
    required ActionWindow window,
    required QueryCategory category,      // Home ambient → derive from window (see 38.4)
    required double tarabalaMultiplier,
    required double horaSwaraMultiplier,
    required bool isAligned,              // NEW — from AlignmentChecker (38.2)
    required BreathFlow? actualSwara,     // for Sushumna prose + null-when-stale (38.4)
    required bool isRahuActive,           // NEW — caller supplies (24h-correct)
    required bool isEmakandamActive,      // NEW
  });
  ```
- `OracleCompositeEngine.evaluate` then computes `isRahuActive`/`isEmakandamActive` from
  `DaylightSegmentResolver` **exactly as today** (preserving its day-time behavior) and
  delegates — so the Oracle path is unchanged, while the dashboard path (38.3) supplies
  24h-correct booleans.

## 4. Task 38.2 — Fuse breath-alignment as the Readiness multiplier

In `IntegratedArudamEngine`:
- After computing the Moment score (`base × tarabala × horaSwara × categoryHarmony`),
  apply **Readiness**: `readiness = isAligned ? 1.0 : 0.75`. Multiply it in **before**
  `.round().clamp(0,100)`. **Never** let readiness produce a floor-lock (the only
  floor-lock remains Rahu/Emakandam).
- **Sushumna:** keep the existing rule — Sushumna counts as aligned **only** in the Yoga
  window (reuse `ActionWindow.isSushumnaAligned` / `AlignmentResult.isAligned`, which
  already encodes it). Preserve the existing Sushumna guidance-prose override.
- The Oracle path must pass `isAligned` derived the same way it derives `actualSwara`
  today, so its scores stay consistent (note: this *does* now let alignment affect the
  Oracle score too — that is intended and owner-confirmed, Q2-A. Update the Oracle
  regression baseline accordingly: the regression gate pins **floor-lock + band mapping +
  Moment math**, not a frozen number that predates alignment fusion — see §9).

## 5. Task 38.3 — 24h-correct the inauspicious floor-lock

**The fix:** compute `isRahuActive`/`isEmakandamActive` from the **actual Rahu/Emakandam
windows** (which `DashboardData` already has as `RahuKaalResult{start,end}` /
`EmakandamResult{start,end}`) via a simple time-range containment check
(`!now.isBefore(start) && now.isBefore(end)`), and pass those booleans into
`IntegratedArudamEngine.evaluate`. This works day AND night, unlike
`DaylightSegmentResolver` (which is sunrise→sunset only).

- The **dashboard/Home path** uses the window-containment booleans (24h-correct).
- The **Oracle path** keeps using `DaylightSegmentResolver` for now (unchanged behavior),
  OR is switched to the same window-containment approach **only if** the regression gate
  proves day-time parity. *Prefer leaving the Oracle path exactly as-is for this slice to
  minimize risk* — the 24h correctness is required for the ambient card, which is new.

## 6. Task 38.4 — Ambient "Aruḍam Now" verdict card on Home

**New widget:** `lib/features/home/presentation/widgets/arudam_now_card.dart`; insert at
the **top of Row 0** in `lib/features/home/presentation/today_tab.dart` (above the Action Bar).

- Reads `dashboardDataProvider`. Derives the verdict by calling `IntegratedArudamEngine`
  with the dashboard's `birthBirdState`, `activeActionWindow.window`, `activeHora`
  (→ Hora-Swara multiplier), Tarabala (reuse the Oracle screen's derivation), the
  window-containment Rahu/Emakandam booleans, and the alignment result.
- **Ambient category:** there is no user-chosen category on Home — derive `category` from
  the active window (Artha/Kriya/Yoga → same enum) so category-harmony is neutral/1.2 for
  the matching window. (Confirm the mapping reads naturally; the ambient verdict is
  "how good is now for what now is for", not "for my specific question".)
- **Card content — the two-clock breakdown, always visible, plain language:**
  ```
  🦅 ARUḌAM NOW — <Band> (<score>)
  Moment: <bird state> · <hora planet> hora   (strong/mild/weak)
  You: naturally aligned ✓   — or —   not naturally aligned ⚠
  ```
- **Swara staleness (reuse the confirmed rule):** get the latest journal entry's
  `actualFlow`; if within ~30 min use it; if stale, **degrade** — show the Moment verdict
  + "check your breath →", do **not** fabricate an aligned/misaligned state (pass
  `actualSwara: null` / treat readiness as unknown, show the Moment ceiling only). Never nag.
- **No tooltips. No raw math.** (The expandable "Why?" accordion is a named fast-follow,
  NOT this slice.)

## 7. Task 38.5 — Natural-vs-forced framing (copy + affordance)

- **Misaligned default:** the card's guidance is **wait / accept / note** — never "switch
  to fix it". Primary message frames natural alignment as the goal.
- **Forced shift = secondary, warning-toned:** a low-emphasis "Urgent?" affordance (e.g. a
  muted link, not a prominent CTA) that, when tapped, shows the contralateral shift
  guidance (CONF-002) framed as **depleting / an exception, not a habit**. Copy must
  **never promise success** — "may improve your odds / helps you align", never "guarantees"
  (CONF-016/017: a nudge, ~10–60 min, can revert). The loop ends with **"re-check"**, not "done".
- This is copy + one secondary affordance on the new card — no new engine behavior.

## 8. Task 38.6 — Reward natural alignment: FLAG ONLY (analytics rework deferred)

- Add a persisted flag distinguishing a **force-shifted** breath session from a
  **naturally-aligned** one (e.g. a `wasForcedShift`/`forcedShift` bool on the journal
  entry, schema-bump if needed — **use the tested `migration_helpers.dart` existence
  checks**, per the Sprint 36 lesson).
- **Scope = design + persist + record the flag** (set it when the user logs after using the
  forced-shift affordance). **Do NOT** rework the streak/analytics reward math this sprint
  — that's a named fast-follow. Just make the data available for it.

## 9. Task 38.7 + Tests, docs, i18n

- **Bilingual (EN/TA):** all new verdict states, the two-clock labels, and the
  natural-vs-forced copy use l10n keys (EN + TA), keeping the sacred tone. Follow the Pre-PR
  Tamil-mode checklist in `dev-workflow.md`.
- **Tests (local green before PR):**
  - `IntegratedArudamEngine` unit tests: Moment × Readiness math; misalignment 0.75; Sushumna-in-Yoga aligned/blocked; Rahu/Emakandam floor-lock day AND night; band mapping.
  - **Oracle regression tests (the gate):** `OracleCompositeEngine.evaluate` still floor-locks in the same day-time Rahu/Emakandam cases, still maps the same bands, and its Moment math is unchanged. Since alignment now legitimately feeds the score (38.2), pin the **behavior** (floor-lock conditions, band thresholds, Moment factors), not a pre-alignment frozen number — and add an explicit case showing an aligned vs misaligned score differs by the 0.75 factor.
  - **Night floor-lock test:** a post-sunset time inside a Rahu/Emakandam window → the dashboard verdict floor-locks (previously it would not).
  - Verdict-card widget test (renders band + two-clock rows; stale-swara degrade path).
- **Docs:** `docs/research/calculation-methodology.md` — add the Integrated Aruḍam verdict + Moment × Readiness + the 24h floor-lock; `docs/product/user-guide.md` — the "Aruḍam Now" card + the natural-alignment philosophy (existing users will see a new Home card).

## 10. Out of scope (named fast-follows — do NOT build here)

The **"Why?" provenance accordion**; the **native ambient surface** (widget/watch/macOS);
the **calendar-aware proactive nudge**; **tuning the 0.75 penalty** via the 7-day 3-way
comparison; the **full streak/analytics natural-alignment rework** (38.6 is flag-only).

## 11. Definition of Done

See the Sprint 38 Delivery Checklist in [`sprint-tracker.md`](../../sprint-tracker.md).
**Key gates:** local `flutter analyze` clean + full `flutter test` green before the PR
(macOS baseline = the same 4 known CloudKit failures and no others); **the regression gate
must be proven** — existing Oracle day-time behavior preserved AND night verdicts now gate
correctly; all new copy bilingual; forced-shift copy carries the warning tone and never
promises success.
