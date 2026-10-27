<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/performance-pass/design.md
  Saranidhi Kiro Spec — DESIGN (the HOW; authored by the Operator).
  Last verified: 2026-10-27 (v1.13.0-web).
-->
# Performance Pass — Design

| Property | Value |
| :--- | :--- |
| **Spec ID** | `performance-pass` |
| **CONF** | `n/a` |
| **Surface** | Executor (Antigravity) — build + local verify |

---

## 1. Approach
Measurement-first, behavior-preserving. Do NOT invent a perf framework. Two independent,
low-risk workstreams, each gated on a recorded before→after number:

**(A) Startup — get work off the pre-`runApp` critical path.**
- `lib/main.dart:16-20` currently `await`s `NotificationService.instance.initialize()` before
  `runApp`. On native this runs `tz.initializeTimeZones()` + plugin init synchronously. Move it
  so the first frame is not blocked: call `runApp` first, then kick notification/timezone init
  from a post-first-frame callback (`WidgetsBinding.instance.addPostFrameCallback`) or lazily on
  first schedule. The service is idempotent (`_initialized` guard) and already a `kIsWeb` no-op,
  so this is a wiring move, not a behavior change. **Do not break the `onNotificationTap` wiring.**
- The four on-open widgets (`main.dart:44-55`) sit in `MaterialApp.router`'s `builder`, which
  reruns on route changes. Audit each for run-once semantics; any that must fire once per launch
  gets a guard (a provider flag / `ref.read` one-shot) so a route change does not re-trigger
  sync/location/migration work. Keep the widget tree shape; only add idempotency where missing.

**(B) Animations — reduced-motion aware, no visual redesign.**
- Introduce ONE small helper (e.g. `core/utils/reduced_motion.dart`): a function/extension that
  reads `MediaQuery.maybeOf(context)?.disableAnimations ?? false` and tells a widget whether to
  run its `.repeat()` loop or settle to a static end-state.
- Apply it in each of the eight F3 widgets at the point where the controller would `.repeat()`
  or `forward()`. With reduced-motion OFF the code path is byte-equivalent to today (R2.3). With
  it ON, skip the loop and show the final frame. Confirm every `AnimationController` is disposed.

## 2. Data / model
None. No Freezed entity, no Drift table, no schema bump, no migration. (If the on-open run-once
guard needs a flag, it is in-memory provider state, not persisted.)

## 3. Domain / calculation
None touched. Astro engine firewalled (R-FW) — zero files under `lib/features/astro_engine/`.

## 4. Presentation
- The reduced-motion helper lives in `core/utils/` and is imported by the eight animation widgets.
- No new visible widget, no layout change, no new string. Reuse existing patterns
  (`ShimmerLoading` already models a controller + repeat — it is one of the eight to guard).

## 5. Localization (RT)
No new ARB keys expected. If one is unavoidable, add EN + pure Tamil and regenerate
`lib/l10n/generated/`. Tamil mode eyeballed to confirm "no change" (RT.2).

## 6. Analytics reactivity
n/a — no analytics provider touched.

## 7. Open questions (resolve during build)
- **OQ-1 — Measurement method.** Pick ONE reproducible cold-start measurement (e.g. a `Stopwatch`
  from `main()` entry to first `addPostFrameCallback`, logged; or Flutter DevTools timeline) and
  use the SAME method before and after. Record which method in the REPORT. Lean: the in-code
  `Stopwatch`-to-first-frame log — cheap, reproducible, works on web and native.
- **OQ-2 — Notification init placement.** `addPostFrameCallback` vs lazy-on-first-schedule. Lean:
  `addPostFrameCallback` keeps current eager-init semantics (channel ready before any schedule)
  while unblocking the first frame — smallest behavior delta. Record the choice.
- **OQ-3 — Reduced-motion for the streak celebration.** A one-shot celebration (not a `.repeat()`
  loop) under reduced motion SHOULD still show (it is informational), but instantly / without the
  entrance animation. Confirm it does not suppress the celebration entirely (that would regress R3
  of the deferred-widgets sprint).
