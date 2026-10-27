<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/l10n-polish-sweep/requirements.md
  Spec: l10n-polish-sweep — Requirements (EARS DoD)
  Authored: 2026-10-27 (Operator /plan-start). Class: sprint deliverable (touches live l10n + consumer code).
-->
# l10n Polish Sweep — Requirements

> **Intent (one sentence of "done").** Clear the two logged Tamil-l10n defects
> (`BUG-POLISH-01` unpin/delete collision, `BUG-v1.11.1-03` unlocalized yama
> label in the notification title) and tighten the three thin animation
> reduced-motion tests carried over from the `/review-pr 315` gate — **without
> touching the astro-engine firewall and without adding new user-facing
> strings.**

## Scope anchor
Three independent, low-risk polish items, each grounded firsthand (2026-10-27):

| Item | Real seam | Class |
| :--- | :--- | :--- |
| **BUG-POLISH-01** | `lib/l10n/app_ta.arb:408` `unpinEntry` → `நீக்கு` (collides with `delete`:165) | ARB-only |
| **BUG-v1.11.1-03** | `lib/features/notifications/domain/notification_scheduler.dart:203` `'Saranidhi — ${yama.label}'` | consumer code |
| **Test-tighten (315 carry-over)** | `test/features/performance_pass/performance_pass_invariants_test.dart` — 3 pacer tests assert only "renders + disposes" | test-only |

## Requirements (EARS)

### R1 — BUG-POLISH-01: distinct Tamil word for unpin
- **R1.1** WHEN the app renders in Tamil, THE journal entry **unpin** affordance SHALL use a Tamil word **distinct from** `delete` (`நீக்கு`). Change `app_ta.arb` `unpinEntry` from `நீக்கு` to `பின் அகற்று` ("un-pin"), keeping `delete` = `நீக்கு` unchanged.
- **R1.2** THE English `unpinEntry` value ("Unpin") SHALL remain unchanged — this is a Tamil-value fix only, **no new key**.
- **R1.3** THE fix SHALL NOT alter any other ARB entry mapping to `நீக்கு` (`delete`, `deleteEntryMessage`, `prasanamDeleteConfirm`, `clearAllDataConfirmMessage`) — those are genuinely "delete/remove" and correct.

### R2 — BUG-v1.11.1-03: localize the yama notification title
- **R2.1** WHEN a yama-transition notification fires with no bird/state context, THE title SHALL compose from the **existing** `l10n.yamaPrefix` key + the yama number, instead of the hardcoded English `yama.label` (`'Yama N'`).
- **R2.2** THE fix SHALL thread `AppLocalizations` (or a resolved prefix string) into `notification_scheduler.dart`'s title builder; **no new ARB key** is added (`yamaPrefix`/`yamaShortPrefix` already exist).
- **R2.3** THE astro-engine source SHALL remain **untouched** — `yama_calculator.dart`'s `.label` getter is NOT modified (firewall). The fix lives at the consumer only.
- **R2.4 (design decision, pinned).** THE AI-wisdom payload (`wisdom_context.dart:52` `activeYama?.label`) SHALL **remain a stable English key** — it is an LLM prompt field, not user-facing UI; a stable English token aids prompt consistency. (If the owner wants it localized, that is a separate Spec.) This decision is recorded in `design.md`.

### R3 — Test-tighten (315 carry-over)
- **R3.1** THE three reduced-motion-ON pacer tests (`ShimmerLoading`, `SamaVrittiPacer`, `QuickSyncPacer`) SHALL additionally assert the **controller state** under reduced motion (not animating / pinned to a static value), not merely "renders without throwing".
- **R3.2** THE existing reduced-motion-OFF regression assertions SHALL remain and keep passing (no loosening).

## Standing criteria
- **RT (Tamil) — n/a for new strings; value-check only.** Zero new ARB keys added across R1/R2. The ONE Tamil value changed (R1.1) SHALL be pure Tamil script (`பின் அகற்று`, no transliteration). The existing `yamaPrefix`/`yamaShortPrefix` Tamil values SHALL be eyeballed as pure Tamil.
- **RC (CONF provenance) — n/a.** No doctrinal calculation, bird/swara/oracle logic, or corpus rule is touched. State n/a explicitly in the REPORT.
- **RQ (regression-first).** Pin BEFORE changing: (a) `delete` still renders `நீக்கு` in Tamil; (b) the yama notification still fires with correct content (only the prefix source changes); (c) the AI payload `activeYama` key shape is unchanged (R2.4). No behavior drift beyond the three scoped strings/paths.

## Firewall gate (R-FW)
THE diff SHALL contain **0** files under `lib/features/astro_engine/` (and `pakshi_calculator`/`swara`/`oracle`/`arudam`/`nakshatra` paths). Verified on the real diff at `/review-pr`.

## Out of scope (binding)
- Changing `yama_calculator.dart` `.label` itself (engine firewall).
- Localizing the AI-wisdom LLM payload (R2.4 — separate Spec if wanted).
- Any new ARB key, any dashboard-UI string, any other logged bug not listed above.
- A disambiguation lint/check for future label collisions (nice-to-have; backlog, not this sprint).
