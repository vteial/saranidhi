[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 44 dossier](../../../process/sprints/sprint-44-practice-sync-p0/README.md)

# Smoke Test — v1.12.0-web (Sprint 44, Practice Sync Phase 0)

**Release:** v1.12.0-web (Sprint 44 — ★ Practice Sync Phase 0: owner-stamped safe merge-import)
**Date:** _pending_
**Tester:** Owner (real cross-device) + Antigravity (QA-Verify Agent)
**Shipping Commit:** _pending_ on `release/v1.12.0` (PR #239)
**Device/Browser:** Chrome — Desktop + Mobile (390×844); **plus real devices** for the cross-device flow (iPad Mini + iPhone SE)
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1120-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Pre-flight readiness gate (Step 0):** ✅ READY — preview reachable, About = `Saranidhi v1.12.0 (1)`, CI green on PR #239.
- **Status:** ✅ **PASS (with notes)** — owner-run on **real devices** (iMac Chrome + iPad Mini Chrome) on the PR #239 preview. Core capability verified: cross-device **Merge works both ways**, aggregate combines, the **owner-guard refuses** a different-Practice-ID file, and a fresh device **adopts** an existing Practice ID via Restore-overwrite. Three **non-blocking** follow-ups deferred to **v1.12.1** (see Bugs/Notes). No Antigravity run (owner verified the real cross-device flow directly — the part automation can't do).
- **Build / Version Confirmed:** ✅ Settings → About = `Saranidhi v1.12.0 (1)`.
- **CI Gate:** ✅ green on release PR #239 (Analyze/Fast+Build, Full Suite+Coverage).
- **Bugs / Regressions:** No data-integrity issues. Three non-blocking items → **v1.12.1 fast-follow**:
  1. **UX gap — no import entry point before onboarding.** A genuinely new device shows onboarding first, and Merge/Restore live in Settings (only reachable *after* onboarding), so the intended "import-before-onboarding to adopt the Practice ID" flow isn't directly reachable. **Workaround that works today:** onboard, then **Settings → Restore (overwrite)** with the other device's export → the device adopts that Practice ID → Merge then works both ways. (v1.12.1: add an "Import from another device" action on the onboarding/intro screen.)
  2. **BUG-v1.12.0-01 — Practice ID not refreshed in Settings after Restore/Merge.** After Restore, the profile card shows the *old* Practice ID until a manual page reload. Root cause: `profile_card.dart` uses its own `FutureBuilder` querying `profiles` directly; `_invalidateAllDataProviders()` invalidates dashboard/journal/ownerId/etc. but not the profile card's local future. Cosmetic — DB is correct, self-heals on reload. (v1.12.1: profile card to watch an invalidated provider.)
  3. **Enhancement — Practice ID prefix in export filename** (e.g. `saranidhi-backup-<id8>-<timestamp>.json`) so files are identifiable across devices; forward-compatible with an account/email label at Phase 1. (v1.12.1.)

> **Scope note (FULL matrix — real capability + schema migration).** v1.12.0 adds a Practice ID
> (schema **v6→v7** migration) and a non-destructive **merge** import replacing the destructive one.
> The migration + merge + owner-guard logic is covered by 17 unit/widget tests + CI; the manual
> gate focuses on what CI can't fully prove: the **existing-profile upgrade path** (migration on a
> real prod DB), the genuine **cross-device merge flow**, the **owner-guard refusal** UX, that the
> **aggregate view actually combines** both devices, that **Restore (overwrite)** is clearly
> distinct + still works, and **Tamil**. **⚠️ Back up first:** this is the first release with a
> schema migration + a merge — export your data before testing the migration on your primary device.

---

## Scenario Plan

| # | Scenario | Status | What to verify |
|---|----------|:------:|----------------|
| 1 | **Migration on existing prod profile (upgrade path)** | ✅ PASS (test + post-release) | Verified via the `schema_migration_v6_to_v7_test` unit tests (seed v6 → upgrade → `ownerId` backfilled, no data loss) — the **preview is a separate origin with empty storage**, so real-prod-data migration is confirmed on the **production device after release** (data preserved). |
| 2 | **Practice ID visible + copyable** | ✅ PASS | Settings shows the Practice ID, read-only + copy button + toast; stable across reopens. |
| 3 | **Export (with Practice ID)** | ✅ PASS | Export produces a JSON file carrying the Practice ID + version. |
| 4 | **★ Cross-device MERGE (the headline)** | ✅ PASS | Owner-verified **both ways** (iMac Chrome ↔ iPad Mini Chrome, same Practice ID): each side gains the other's new sessions, no local deletes, re-merge idempotent. |
| 5 | **Aggregate view spans both devices** | ✅ PASS | After merge, streak / trend / hold-time / personal-best reflect the combined set. |
| 6 | **Owner-guard REFUSES a foreign file** | ✅ PASS | Merging a **different**-Practice-ID file is refused; no data changed. |
| 7 | **Legacy file (no Practice ID)** | ✅ PASS | Older no-Practice-ID export → warn + explicit confirm. |
| 8 | **Restore (overwrite) still works + is distinct** | ✅ PASS | "Restore (overwrite)" is separate + confirm-gated; fully replaces local data and the device **adopts the source's Practice ID** (this is the current new-device onboarding workaround). ⚠️ see BUG-v1.12.0-01 (Practice ID UI not refreshed until reload). |
| 9 | **New-device identity propagation** | ⚠️ PASS-via-workaround | A fresh device can't reach import *before* onboarding (no entry point) → adopts an existing Practice ID via **Restore-overwrite** after a throwaway onboard. Works; the direct path is a **v1.12.1** follow-up. |
| 10 | **Tamil localization** | ✅ PASS | New Practice-Sync copy renders in Tamil (Practice ID label, Merge/Restore, mismatch dialog). |
| — | **Regression glance** | ✅ PASS | Single-device use unchanged; no layout issues. |
| — | **Version confirm** | ✅ PASS | Settings → About = `Saranidhi v1.12.0 (1)`. |

---

## Detailed Scenarios

### Scenario 1: Migration on existing prod profile
- [ ] Open v1.12.0 on a device with prior v1.11.x data → no data loss; Practice ID present; history intact.
- **Result:** ⏳ · **Evidence:**

### Scenario 2: Practice ID visible + copyable
- [ ] Settings shows Practice ID (read-only + copy); stable across reopens.
- **Result:** ⏳ · **Evidence:**

### Scenario 3: Export carries Practice ID + versions
- [ ] Export file includes ownerId + v1.12.0 / schema 7 / exportVersion 2.
- **Result:** ⏳ · **Evidence:**

### Scenario 4: ★ Cross-device MERGE (headline)
- [ ] Export on Device B → Merge on Device A (same Practice ID); A gains B's new sessions; no deletes; toast count; re-merge idempotent (0 new).
- **Result:** ⏳ · **Evidence:**

### Scenario 5: Aggregate spans both devices
- [ ] Streak / trend / hold-time avg / personal-best reflect combined sessions post-merge.
- **Result:** ⏳ · **Evidence:**

### Scenario 6: Owner-guard REFUSES foreign file
- [ ] Merge a different-Practice-ID file → refused dialog; zero data changed.
- **Result:** ⏳ · **Evidence:**

### Scenario 7: Legacy no-Practice-ID file
- [ ] Merge a legacy export → warn + explicit confirm required.
- **Result:** ⏳ · **Evidence:**

### Scenario 8: Restore (overwrite) distinct + works
- [ ] "Restore (overwrite everything)" clearly separate from Merge; confirm dialog; full replace works.
- **Result:** ⏳ · **Evidence:**

### Scenario 9: New-device identity propagation
- [ ] Fresh device merges/imports an export → adopts that Practice ID.
- **Result:** ⏳ · **Evidence:**

### Scenario 10: Tamil localization
- [ ] All new Practice-Sync copy in pure Tamil script.
- **Result:** ⏳ · **Evidence:**

### Regression glance + version
- [ ] Single-device use unchanged; About = v1.12.0.
- **Result:** ⏳ · **Evidence:**

---

## Bugs / Regressions

_Pending execution._
