[← Back to Smoke Test Index](../../smoke-test-results.md) · [Sprint 44 dossier](../../../process/sprints/sprint-44-practice-sync-p0/README.md)

# Smoke Test — v1.12.0-web (Sprint 44, Practice Sync Phase 0)

**Release:** v1.12.0-web (Sprint 44 — ★ Practice Sync Phase 0: owner-stamped safe merge-import)
**Date:** _pending_
**Tester:** Owner (real cross-device) + Antigravity (QA-Verify Agent)
**Shipping Commit:** _pending_ on `release/v1.12.0` (PR #_pending_)
**Device/Browser:** Chrome — Desktop + Mobile (390×844); **plus real devices** for the cross-device flow (iPad Mini + iPhone SE)
**Environment:** PR Vercel **preview** — `https://saranidhi-git-release-v1120-eialarasus-projects.vercel.app` (via `VERCEL_AUTOMATION_BYPASS_SECRET`) — **NOT** staging

## Result

- **Pre-flight readiness gate (Step 0):** ⏳ _pending_ — record `PRE-FLIGHT: READY (About=v1.12.0, preview OK, CI green)` before scenarios, or a `BLOCKED` reason (never fall back — see the QA-Verify prompt's ABORT PROTOCOL).
- **Status:** ⏳ _pending_
- **Build / Version Confirmed:** Settings → About should read **`Saranidhi v1.12.0 (1)`** _(confirm)_
- **CI Gate:** _(confirm green on the release PR — Analyze/Fast+Build, Full Suite+Coverage)_
- **Bugs / Regressions:** _pending_

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
| 1 | **Migration on existing prod profile (upgrade path)** | ⏳ | Open v1.12.0 on a device that already had v1.11.x data. App loads with **no data loss**; a **Practice ID** now appears in Settings; existing streak/history intact. (The v6→v7 migration ran + backfilled `ownerId`.) |
| 2 | **Practice ID visible + copyable** | ⏳ | Settings → profile shows **Practice ID** (short, read-only, copy button → toast). Same device keeps the same ID across reopens. |
| 3 | **Export (with Practice ID)** | ⏳ | Settings → Export produces a JSON file (share/download). It carries the device's Practice ID + version (v1.12.0 / schema 7 / exportVersion 2). |
| 4 | **★ Cross-device MERGE (the headline)** | ⏳ | On **Device B** (e.g. iPhone SE) export; on **Device A** (iPad Mini, same Practice ID) **Merge from file** → Device A gains B's sessions/journal it didn't have; **no local data deleted**; toast reports N merged. Re-merging the same file = **0 new** (idempotent). |
| 5 | **Aggregate view spans both devices** | ⏳ | After the merge, Analytics/Home: **streak, 7/30-day trend, hold-time average, personal-best** reflect the **combined** session set (e.g. a hold-time PB from Device B now shows on Device A). |
| 6 | **Owner-guard REFUSES a foreign file** | ⏳ | Attempt to **Merge** a file with a **different Practice ID** → refused with a clear dialog ("belongs to a different Practice ID… Cancel / Restore-overwrite"). **No data merged/changed.** (Simulate with a second Practice ID / a hand-edited file.) |
| 7 | **Legacy file (no Practice ID)** | ⏳ | Merging an older export lacking a Practice ID → **warn + require explicit confirm** before proceeding. |
| 8 | **Restore (overwrite) still works + is distinct** | ⏳ | The old destructive path is a **separate, clearly-labeled "Restore (overwrite everything)"** with a confirm; it fully replaces local data as before (unchanged behavior). Not confusable with Merge. |
| 9 | **New-device identity propagation** | ⏳ | On a fresh/unonboarded device, **Merge/import an export → the device adopts that Practice ID** (subsequent exports match). *(Doc tip: import before onboarding.)* |
| 10 | **Tamil localization** | ⏳ | In தமிழ்: Practice ID label + copy toast, Merge vs Restore buttons, the mismatch-refusal dialog, legacy-warn — all pure Tamil script, zero English leakage. |
| — | **Regression glance** | ⏳ | Single-device normal use unchanged; onboarding, dashboard, journal, Aruḍam, analytics render as v1.11.x. No overflow at 390px. |
| — | **Version confirm** | ⏳ | Settings → About = `Saranidhi v1.12.0 (1)`. |

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
