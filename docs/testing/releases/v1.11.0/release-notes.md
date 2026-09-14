[← Back to Smoke Test](./smoke-test.md) · [Releases index](../../smoke-test-results.md)

# Release Notes — v1.11.0-web

> Permanent record of the GitHub Release. The owner creates the tag/release from the
> GitHub UI; this file is the source text so the release stays auditable/reproducible.
> Drafted at `/release-start`, finalized at `/release-update`.

## Tag details (copy into the GitHub Release UI)

| Field | Value |
|-------|-------|
| **Tag** | `v1.11.0-web` |
| **Target** | `prod` branch |
| **Title** | `v1.11.0-web — Swara Clock Engine & Weekday Udhaya` |

## Release notes (body)

Saranidhi now predicts your **expected nostril** on the authentic hourly rhythm the tradition
actually teaches — a quiet but important accuracy fix at the heart of the app.

### 🌬️ What changed
- **Expected nostril flow now runs on the real 1-hour swara clock.** Previously the app inferred your expected breath channel from the 1.5-hour bird-state (Panja Pakshi) cycle. That's a *different* clock. The expected nostril now follows its own **1-hour / 24-cycle** rhythm, seeded each morning at **sunrise** by the classical **Weekday Udhaya** rule (each weekday has its own dawn nostril and a 1- or 2-hour opening window; Thursday follows the waxing/waning moon).
- **The Nostril Pattern card, refreshed.** It now shows the current expected flow, the upcoming hourly blocks, and a countdown to the **next ~1-hour switch** — and it stays live **through the night** (with a gentle inward-rest note) instead of going blank after sunset.
- **A more honest alignment & readiness reading.** Because the "readiness" half of the Aruḍam Now verdict compares your breath against this expected nostril, it's now measured against the correct rhythm.

### 🔧 Under the hood
- A latent bug that judged past journal entries against *today's* rhythm (instead of the entry's own time) is fixed.
- The bird-state / yama engine — bird schedule, Rahu Kaal, Kuligai, Emakandam, and the Aruḍam Now *Moment* score — is **unchanged** (regression-tested).

### 🌿 The spirit of it
- **Fidelity to source.** This aligns the app with the lineage teaching (CONF-013 / CONF-014 / CONF-001) so your self-observation is tested against the authentic rhythm — the foundation for the upcoming accuracy calibration.

### Notes
- No new permissions, no data migration, no schema change.

### Sprint(s)
- Sprint 42 — ★ Swara Clock Engine & Weekday Udhaya

### Smoke test
- See [`smoke-test.md`](./smoke-test.md) — status set at `/release-update`.

---

> **Shipped:** _pending_ · promotion PR _pending_ · will be live at [saranidhi.vercel.app](https://saranidhi.vercel.app).
