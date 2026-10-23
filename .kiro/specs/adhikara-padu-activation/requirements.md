# Adhikara / Padu-Pakshi Activation — Requirements

> **Class:** sprint deliverable, **correctness-critical** (changes the live Oracle/Aruḍam composite
> score users see on the Prasanam and Home surfaces).
> **Provenance:** the Adhikara (ruling-power) and Padu-Pakshi (downtime) day tables are grounded in
> the primary Tamil source *"பஞ்ச பட்சி ஆருடம்"* (Kottumozhi Sathya, pp. 14/17/18/22) under
> **CONF-PP-007**. These day-block tables are **corpus-confirmed and independent** of the unresolved
> per-yama *sequence* layer — so activating them does not depend on, and must not touch, that layer.
> **Builds on:** PR #304 (`pakshi-scoring-corpus-alignment`) which shipped `PakshiAdhikara`
> (`lib/features/astro_engine/domain/pakshi_adhikara.dart`) and wired an **optional, currently-dormant**
> `bird` parameter into `OracleCompositeEngine.evaluate`. This Spec **activates** that dormant path.

## Problem

PR #304 built and unit-tested the `PakshiAdhikara` helper and the `adhikaraMultiplier` plumbing, but left
it **inert**: no live caller passes `bird:`, so `adhikaraMultiplier` is always `1.0` on every user path.
The corpus-confirmed Adhikara boost (×1.15) and Padu-Pakshi downtime penalty (×0.5) therefore never
reach the score a user sees.

Two user-facing surfaces consume the composite, and they take **different paths**:

| Surface | Current evaluate call | Has `adhikaraMultiplier` plumbing? |
|---|---|---|
| **Prasanam** (`prasanam_screen.dart`) | `OracleCompositeEngine.evaluate(...)` | ✅ dormant `bird` param ready |
| **Home "now" card** (`arudam_now_card.dart`) | `IntegratedArudamEngine.evaluate(...)` **directly** (bypasses the composite) | ❌ no plumbing on this path |

Both surfaces already resolve the subject bird species as `data.effectiveBirthBird ?? data.birthBird`
(`PakshiBird?`), so the input is in scope at each call site.

## EARS Definition of Done

**R1 — Activate the Adhikara/Padu modifier on the Prasanam path.**
R1.1 WHEN the Prasanam screen calls `OracleCompositeEngine.evaluate` THEN it SHALL pass
`bird: effectiveBirthBird ?? birthBird` so the modifier is derived from the live subject bird.
R1.2 WHEN the resolved `PakshiBird` is `null` (profile has no birth bird yet) THEN `bird:` SHALL be
omitted / passed `null` and the score SHALL be IDENTICAL to today (multiplier stays `1.0`) — no regression
for un-onboarded users.
R1.3 The modifier SHALL use the SAME paksha/isNight derivation already in `evaluate` (no new timing logic).

**R2 — Resolve the Home "now" card consistently (no silent divergence between surfaces).**
R2.1 The design SHALL decide ONE of: (a) route `arudam_now_card` through `OracleCompositeEngine.evaluate`
so it gains the same modifier, OR (b) thread an `adhikaraMultiplier` into its direct
`IntegratedArudamEngine.evaluate` call via the same `PakshiAdhikara` derivation. Whichever is chosen,
the Prasanam and Home surfaces SHALL apply the Adhikara/Padu modifier **identically** for the same
(bird, weekday, paksha, day/night) — a user SHALL NOT see two different verdicts for the same moment.
R2.2 WHEN the birth bird is `null` on the Home path THEN the card SHALL be unchanged from today.

**R3 — The inauspicious floor-lock stays absolute (R4.2 of #304 preserved).**
R3.1 WHEN a Rahu Kaal / Emakandam window is active THEN the score SHALL remain floor-locked
(`isFloorLocked: true`, `band: sunya`, score 10) REGARDLESS of an Adhikara ×1.15 boost — the boost
SHALL NOT lift a locked score. (The current ordering in `IntegratedArudamEngine.evaluate` returns the
floor BEFORE applying `adhikaraMultiplier`; this Spec SHALL keep that ordering and pin it with a test.)

**R4 — The per-yama sequence layer is untouched (CONF-PP-007 firewall).**
R4.1 `pakshi_calculator.dart` state tables (`_*Group*`) SHALL be byte-unchanged (empty diff).
R4.2 This Spec SHALL NOT assert or encode any resolution of the per-yama sequence question; it activates
ONLY the day-block Adhikara/Padu tables, which are a separate, corpus-confirmed layer.

**R5 — The score shift is characterised and intentional (not silent).**
R5.1 A golden test SHALL record the composite score for a fixed input suite spanning: an Adhikara day
(expect ×1.15), a Padu day (expect ×0.5), a normal day (expect ×1.0 — unchanged), and a floor-locked
window on an Adhikara day (expect still locked to 10). Before/after values SHALL be explicit and reviewable.
R5.2 The existing #304 golden fixtures SHALL be updated to reflect activation where a caller now passes
`bird:`, with the diff visible in the PR.

**RT — Tamil bilingual (standing).** IF the activation surfaces a new user-facing label (e.g. an
"Adhikara day — heightened" / "Padu Pakshi — rest day" badge or guidance line) THEN it SHALL be EN +
pure Tamil script. IF no new string is surfaced (modifier only shifts the existing numeric band) THEN
RT is N/A and the REPORT SHALL say so explicitly.

**RC — CONF provenance (standing).** The activation SHALL cite CONF-PP-007 and the Kottumozhi pages
(14/17/18/22) for the Adhikara/Padu tables. The owner's CONF-PP-007 decision is source-truth.

**RQ — Regression gate (standing).** State explicitly what stays UNCHANGED: un-onboarded users (null
bird), floor-locked windows, and all normal (non-Adhikara, non-Padu) days SHALL produce byte-identical
verdicts to today. Only Adhikara and Padu days shift, and only by the documented ×1.15 / ×0.5.

## Known doctrinal caveat (carried into the REPORT, not a blocker)

The app renders the **effective birth bird** (Owl-basis / CONF-PP-001/002 canonical), which has **no
external ground truth** in the Accuracy matrix (that matrix validated the *Cock* column). The Adhikara/Padu
**day tables** are corpus-confirmed independently of that matrix, so activation is defensible — but this
Spec SHALL NOT claim the resulting verdict is externally validated against Align27/Drik. It claims only
fidelity to the Kottumozhi day-block tables.

## Out of scope (flag, don't fold)
- The per-yama **sequence** rewrite (CONF-PP-007 unresolved — awaiting a full primary-source grid or the
  Align27/Drik canonical ruling).
- Any new Owl-basis ground-truth collection (separate data task).
- Changing the ×1.15 / ×0.5 magnitudes themselves (they are #304's corpus-cited constants; this Spec
  only *activates* them).
