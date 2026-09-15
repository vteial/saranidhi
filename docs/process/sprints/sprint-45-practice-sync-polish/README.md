[← Back to Sprint Tracker](../../sprint-tracker.md)

# Sprint 45 — v1.12.1 fast-follow: Practice-Sync polish (v1.12.1)

> **Dossier index.** Spec, what was built, the local test gate, and the resulting PR/release.

| Artifact | Doc |
|----------|-----|
| **Spec** (Kiro Web) | [`spec.md`](./spec.md) |
| **Implementation summary** (Antigravity) | [`implementation-summary.md`](./implementation-summary.md) |
| **Local test summary** (Antigravity) | [`test-summary.md`](./test-summary.md) |

## Goal

The three **Practice-Sync polish** items deferred from Sprint 44 and logged in the backlog during
the v1.12.0 owner cross-device smoke (PR #240). Ships together as the patch release **v1.12.1-web**.
No schema change (stays schema **v7**, export **v2**).

- **45.1 (🔴 structural)** — an **onboarding "Import from another device" entry point.** A genuinely
  new device shows onboarding first, but Merge/Restore live in Settings (only reachable *after*
  onboarding) — so the intended "import-before-onboarding to adopt the existing Practice ID" flow is
  **not directly reachable** in v1.12.0. Add a **subtle link on the intro screen** (owner-chosen
  option (a)) that opens the file picker and merges *before* onboarding completes.
- **45.2 (🟢)** — **BUG-v1.12.0-01: Practice ID not refreshed after Restore/Merge.** The Settings
  profile card shows the *old* Practice ID until a manual page reload.
- **45.3 (🟢)** — **Practice ID prefix in the export filename** so files are identifiable across
  devices.

> **Key grounding note (verified in code this session):** `DatabaseExporter.mergeFromBytes`
> **already** handles the empty-local case — it inserts the file's profile (adopting the file's
> `ownerId`) and imports preferences (including `onboarding_complete`). And
> `_invalidateAllDataProviders()` already invalidates `onboardingCompleteProvider`. So **45.1 is
> almost entirely a UI entry-point task** — the domain layer already supports import-before-onboarding.

## Process

45.1 touches onboarding navigation → **spec → Antigravity (local green) → Kiro Web review**. No
schema/migration change. **User Guide** gets a short "set up a new device by importing" note (real
capability → NOT `n/a`). Owner is sole merge authority.

## Status

📬 **PR Submitted** — Implementation complete; local suite green; PR opened for Kiro Web / owner review.

- **PR:** [#244](https://github.com/vteial/saranidhi/pull/244)
- **Shipped:** _pending — targets v1.12.1-web (`/release-start v1.12.1`)_
