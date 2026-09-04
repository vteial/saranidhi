# Smoke Test — v1.5.0-web

**Release:** v1.5.0-web (**bundled**: Sprint 34 — Migration + Onboarding UX Polish, and Sprint 35 — Somatic Intervention Engine)
**Date:** 2026-09-05 (release-start)
**Tester:** Eialarasu + Kiro
**Device/Browser:** Desktop browser + mobile
**URL:** https://saranidhi-staging.vercel.app (staging) — verify version reads **1.5.0** on the release branch build

> **Focus:** This release bundles two sprints. Sprint 34 (UX/migration polish) and
> Sprint 35 (Somatic Intervention Engine). The **CRITICAL** validation is the
> **schema v4→v5 migration** (Section H) — test BOTH a fresh install and an
> upgrade from an existing (v4) profile. Also verify the full intervention loop
> and re-run the Sprint 34 items deferred in v1.4.2 (auto-recalc bird).
>
> **Legend:** ✅ Pass · ⚠️ Accepted (known/deferred) · ⏸️ Deferred (not yet tested) · ❌ Fail

---

## H. Schema Migration v4 → v5 — CRITICAL (4 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| H1 | Upgrade from existing profile | Open staging with a DB created on v4 (existing profile + journal + oracle history) | App loads; no crash/white screen; all existing data intact; `somatic_intervention_logs` table created | ⏸️ |
| H2 | Fresh install | Clear all site data → open app | Onboarding runs; DB created fresh at v5; no migration errors | ⏸️ |
| H3 | Somatic log persists | Complete one intervention (Section J) → reopen app | Logged session survives reload (table writable) | ⏸️ |
| H4 | Existing features unaffected post-migration | After H1, use journal/oracle/streak | All read/write normally | ⏸️ |

> **Gate:** H1 + H2 MUST pass before `/release-start`. Migration is historically
> the highest-risk area (see v1.2.1 hotfix lessons).

---

## Sprint 34 carried-forward scenarios

### A. Auto-Recalculate Birth Bird on Load (Task 34.1) — (5 scenarios, deferred in v1.4.2)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| A1 | Corrects an old-logic profile | Open app with existing DOB profile whose bird was Bright-Half-only | Bird silently corrected via dual-table; dashboard refreshes | ⏸️ |
| A2 | One-time notice shown | Same as A1 | SnackBar: "Your bird has been updated to {Bird}…" | ⏸️ |
| A3 | No-DOB profile untouched | Open app with a manual "I know my star" profile (no DOB) | Bird unchanged; no notice | ⏸️ |
| A4 | Idempotent | Reopen app after correction | No repeat notice | ⏸️ |
| A5 | Notice localized | A1/A2 in Tamil | Notice text in Tamil | ⏸️ |

### B. Onboarding — 3 Tabs + IST localization (Task 34.2) — (3 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| B1 | Three equal tabs + all paths derive bird | Onboarding → star / DOB / name | Each path yields a bird | ✅ (v1.4.2 preview) |
| B2 | DOB IST note localized | DOB tab in Tamil | IST note in Tamil | ✅ (v1.4.2 preview) |
| B3 | Re-verify after migration | Fresh onboarding on v1.5.0 build | Works as in v1.4.2 | ⏸️ |

### C. Onboarding — Summary + Validation (Task 34.3) — (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| C1 | Complete Setup gated | Reach Summary with missing bird/location | Button disabled + warning banner names what's missing | ✅ (v1.4.2 preview) |
| C2 | Edit + complete happy path | Fill all → Complete Setup | Onboarding done → dashboard | ✅ (v1.4.2 preview) |

### D. GuidedNostrilTest reset/reorder (Task 34.4) — (1 scenario)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| D1 | Order + Start over | Journal → guided nostril test | Lunar/Sushumna/Solar order; Start over resets | ✅ (v1.4.2 preview) |

### E. Oracle History desktop delete (Task 34.5) — (1 scenario)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| E1 | Hover delete + swipe delete | Oracle history | Trash on hover (desktop) + swipe (touch), shared confirm | ✅ (v1.4.2 preview) |

### F. Web Geolocation on startup (Task 34.6) — (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| F1 | Permission prompt + graceful denial | Open app (web) | Prompt appears; denial uses stored location, no error | ⚠️ Partially tested |
| F2 | Moved >5 km silent update | Override coords → reload | Location updates + one-time notice; bird unchanged | ⏸️ |

---

## Sprint 35 scenarios — Somatic Intervention Engine

### J. Intervention End-to-End Flow — CRITICAL (6 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| J1 | Clear Breath Channel action appears | Journal → log an **unaligned** breath (flow ≠ expected, not Sushumna) | Alignment card shows a **Clear Breath Channel** button | ⏸️ |
| J2 | Not shown when aligned / Sushumna | Log an aligned entry, and a Sushumna entry | No Clear Breath Channel button | ⏸️ |
| J3 | Selector offers two protocols | Tap Clear Breath Channel | Bottom sheet: Posture Shift (3 min) + Axillary Pressure (5 min) | ⏸️ |
| J4 | Timer room — posture | Select Posture Shift | Full-screen room; correct **contralateral** instruction (target left → lie on right side, etc.); pacer animates; 3:00 countdown | ⏸️ |
| J5 | Timer room — axillary | Select Axillary Pressure | 5:00 countdown; instruction "opposite armpit" | ⏸️ |
| J6 | Validation + log on completion | Let timer finish → nostril test → log result | Auto nostril test launches; success/retry SnackBar; session written to DB (see H3) | ⏸️ |

### K. Sama Vritti Pacer (Task 35.4) — (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| K1 | 4:4:4:4 rhythm | Observe pacer in timer room | Circle grows (inhale) → holds → shrinks (exhale) → holds; ~4s each; phase label + second count | ⏸️ |
| K2 | Phase labels localized | Tamil mode | Inhale/Hold/Exhale labels in Tamil | ⏸️ |

### L. Cross-Lateral Correctness (Task 35.5) — (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| L1 | Target Lunar (left) | Trigger intervention where expected = Lunar | Instruction: act on **right** side (contralateral) | ⏸️ |
| L2 | Target Solar (right) | Trigger intervention where expected = Solar | Instruction: act on **left** side | ⏸️ |

### M. Somatic Tamil + Cancel (Task 35.8) — (2 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| M1 | All somatic UI localized | Tamil mode through the whole flow | Selector, instruction, room title/hint, success/retry all Tamil | ⏸️ |
| M2 | Cancel mid-timer | Open room → tap close | Returns without logging a success | ⏸️ |

---

## N. Regression — Critical Path (5 scenarios)

| # | Scenario | Steps | Expected | Result |
|---|----------|-------|----------|--------|
| N1 | App loads without errors | Open app | Dashboard loads; startup widgets stack cleanly | ⏸️ |
| N2 | Journal log works | Journal → select nostril → log | Entry saved with alignment | ⏸️ |
| N3 | Full Day Schedule | Today tab → schedule | 5 yamas with bird states | ⏸️ |
| N4 | Tamil mode | Switch to Tamil | All labels render | ⏸️ |
| N5 | About shows v1.5.0 | Settings → About card | Version = 1.5.0 | ⏸️ |

---

## Summary

| Section | Scenarios | Pass | Accepted | Deferred | Fail |
|---------|-----------|------|----------|----------|------|
| H. Migration (CRITICAL) | 4 | 0 | 0 | 4 | 0 |
| A. Auto-Recalc Bird | 5 | 0 | 0 | 5 | 0 |
| B. Onboarding 3 tabs | 3 | 2 | 0 | 1 | 0 |
| C. Summary + Validation | 2 | 2 | 0 | 0 | 0 |
| D. Nostril test | 1 | 1 | 0 | 0 | 0 |
| E. Oracle delete | 1 | 1 | 0 | 0 | 0 |
| F. Geolocation | 2 | 0 | 1 | 1 | 0 |
| J. Intervention flow (CRITICAL) | 6 | 0 | 0 | 6 | 0 |
| K. Sama Vritti pacer | 2 | 0 | 0 | 2 | 0 |
| L. Cross-lateral | 2 | 0 | 0 | 2 | 0 |
| M. Somatic Tamil + cancel | 2 | 0 | 0 | 2 | 0 |
| N. Regression | 5 | 0 | 0 | 5 | 0 |
| **Total** | **35** | **9** | **1** | **25** | **0** |

> Pre-filled from v1.4.2 preview testing (Sprint 34 happy-path). Remaining
> ⏸️ rows to be executed on staging after PR #131 + #132 are both merged.

---

**CRITICAL gates before `/release-start`:**
- [ ] H1 (upgrade migration) + H2 (fresh install) pass
- [ ] J1–J6 (intervention end-to-end) pass
- [ ] N5 shows version 1.5.0

**Release decision:**
- [ ] All critical + core pass → proceed to `/release-start`
- [ ] Failures found → hotfix first, re-test
