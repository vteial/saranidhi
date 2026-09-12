[← Back to Smoke Test](./smoke-test-v1.8.0.md)

# Release Notes — v1.8.0-web

> Permanent record of the GitHub Release. The owner creates the tag/release from the
> GitHub UI; this file is the source text so the release stays auditable/reproducible.
> Drafted at `/release-start`, finalized at `/release-update`.

## Tag details (copy into the GitHub Release UI)

| Field | Value |
|-------|-------|
| **Tag** | `v1.8.0-web` |
| **Target** | `prod` branch |
| **Title** | `v1.8.0-web — Integrated Aruḍam (Aruḍam Now)` |

## Release notes (body)

The first slice of the flagship **Integrated Aruḍam** — a single, always-on verdict that fuses your cosmic timing and your breath into one answer: *"is now a good moment, and what should I do?"*

### 🦅 What's New
- **"Aruḍam Now" verdict card on Home** — an ambient, glanceable card at the top of the Today view that combines your Panja Pakshi bird-state, the planetary hour (Hora), your birth-star strength (Tarabala), and the auspiciousness of the moment into a single score and band.
- **Two-clock breakdown, in plain language** — the card always shows both clocks separately: **Moment** (the cosmic timing — your bird state + hora, the *ceiling* of how good now is) and **You** (whether your breath is *naturally aligned* with it). No jargon, no raw numbers.
- **Moment × Readiness** — when your breath is naturally aligned you claim the full strength of the moment; when it isn't, the verdict softens (never blocks) and gently guides you toward patience.

### 🌿 The philosophy (Agency, not Fate)
- **Natural alignment is the goal, not a shortcut.** When your breath doesn't match the moment, Saranidhi's guidance is to **wait, accept, or note** — cultivating alignment as a lifelong practice.
- **Forced breath-shifting is treated as an exception, not a habit.** It's tucked behind a low-key "Urgent?" option with an honest warning that it's an emergency measure that taxes your reserves and never guarantees success — and sessions where you forced a shift are recorded separately, so the app only ever celebrates *natural* alignment.

### Fixed
- **Inauspicious windows now gate correctly at night too.** Rahu Kaal / Emakandam previously only "locked" the verdict during daytime; the Aruḍam Now verdict is now correct around the clock.

### Notes
- The Prasanam Oracle is unchanged in how you use it; under the hood it now shares the same verdict engine.
- Honest when it can't see your breath: if your last reading is more than ~30 minutes old, the card shows the cosmic timing and simply invites you to check your breath — it never fabricates an alignment.
- Fully bilingual (English + தமிழ்).

### Sprint(s)
- Sprint 38 — Integrated Aruḍam, Slice 1

---

- **Spec + dossier:** [`sprints/sprint-38-integrated-arudam/`](../../process/sprints/sprint-38-integrated-arudam/README.md)
- **Smoke test:** [`smoke-test-v1.8.0.md`](./smoke-test-v1.8.0.md) — ⬜ PENDING (owner runs on staging)
- **Docs audit:** [`docs-audit-v1.8.0.md`](./docs-audit-v1.8.0.md) — ⬜ PENDING
- **PR:** [#181](https://github.com/vteial/saranidhi/pull/181) · **Prod:** [saranidhi.vercel.app](https://saranidhi.vercel.app)
- **Full changelog:** [`CHANGELOG.md`](../../../CHANGELOG.md)
