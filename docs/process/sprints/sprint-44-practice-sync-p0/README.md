[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 44 — ★ Practice Sync Phase 0: owner-stamped safe merge-import (v1.12.0)

> **Dossier index.** Spec, what was built, the local test gate, and the resulting PR/release.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Goal

Phase 0 of the **[Practice Sync](../../sprint-backlog.md#-practice-sync--cross-device-aggregate)**
epic — the near-term, **zero-backend** win pulled ahead of the Now Surface because it affects the
owner's daily practice (data split across 4 devices, no aggregate view).

Make the existing manual export/import **safe**:
- **Owner identity** — a locally-generated `ownerId` (guarded schema **v6→v7** migration; shown in
  Settings as "Practice ID"). No login.
- **MERGE import** replacing the current **destructive** import — union all event tables (journal,
  breath-sessions, prasanam, somatic logs) **by UUID**; never delete. Idempotent.
- **Owner-identity guard** — merge only when the file's `ownerId` matches (or the local device is
  fresh + adopts it); **mismatch REFUSES** → structurally prevents mixing another person's data.
- Keep the old destructive path as an explicit **"Restore (overwrite)"**.

> **Key correctness note:** the hold-time aggregate + personal-best are **journal-sourced**
> (`analytics_calculator` reads `sara_kalai_journal.holdDurationMs`), not `breath_sessions` — so
> the merge must cover the **journal** (and sessions, and the other event tables). Verified in code.

## Process

Correctness-critical (migration + data-merge + identity guard) → **spec → Antigravity (local
green) → Kiro Web review**. Also fixes two latent bugs (stale `AppConstants.schemaVersion`;
`validateExportData` schema ceiling). **User Guide is refreshed (NOT n/a)** — real multi-device
capability. Owner is sole merge authority.

## Status

🔄 **In progress** — spec authored; awaiting Antigravity implementation.

- **PR:** _pending_
- **Shipped:** _pending — targets v1.12.0-web_
