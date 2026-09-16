[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 47 — ★ Practice Sync Phase 1: on-demand cross-device sync (PocketBase) (v1.13.0)

> **Dossier index.** Spec, what was built, the local test gate, and the resulting PR/release.
> Implementation lands in **`vteial/saranidhi`** (app code); the PocketBase **instance** is external
> (Fly.io + a local Docker Compose for dev).

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Goal

Phase 1 of the **[Practice Sync](../../sprint-backlog.md#-practice-sync--cross-device-aggregate)**
epic — the first real **cross-device sync over a network**, on the Phase-0 (v1.12.0) owner-identity
+ union-merge foundation. On demand (opt-in toggle + manual **"Sync now"**), the app does
**pull → union-merge → push** of the **breath-sessions + journal** tables to a **PocketBase**
backend, keyed by `(ownerId, id)`, reusing the Phase-0 append-only union semantics and owner-guard.

> **★ Boundary-reopening sprint.** First real network / account / off-device change since the
> deliberate local-first / zero-backend posture. Conscious + owner-confirmed: **offline-first still
> holds fully** (sync is additive), and a **security-review REDO is a hard release gate**.

## Owner-confirmed decisions (Sprint 47 `/plan`)

- **Transport = PocketBase** behind a **`SyncTransport` interface** (swappable) — a lean, reusable
  infra pattern. **Hosting = Fly.io.** REJECTED: Google Drive/GCP (OAuth + hyperscaler gravity);
  Supabase set aside (known-good, but leaner floor preferred). Long-term: minimal owned
  consent-based backend = a future adapter swap.
- **Scope = sessions + journal**; two checkboxes (both default ON; journal drives the aggregates).
- **v1.13.0 = opt-in toggle + manual "Sync now"**; auto-on-open = fast-follow (OUT).
- **Local dev = Docker Compose for PocketBase only** (`tool/dev/`); Flutter native, points via config.

## Process

Correctness + boundary-critical → **spec → Antigravity (local green against the Compose PocketBase)
→ Kiro Web review**. Reuses the Phase-0 union-merge core (must be extracted to a shared,
transport-agnostic path — see spec). **Security-review REDO** + owner-guard-preserved + offline-first
regression are DoD gates. Owner is sole merge authority.

## Status

🔨 **In Progress** — spec authored; handed to Antigravity. §0 (Fly instance) is the owner's parallel prerequisite.

- **PR:** _pending (in `vteial/saranidhi`)_
- **Shipped:** _pending — targets v1.13.0 (`/release-start v1.13.0`)_
