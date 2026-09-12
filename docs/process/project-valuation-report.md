[← Back to Root](../../README.md)

# Saranidhi — Project Valuation Report

> **Reviewed:** v1.8.1-web · **Next review:** every `/sprint-update` + `/release-update`.

> **Purpose:** one question only — *how much engineering investment went into this,
> and what is the current state?* Everything else is delegated to the system of record
> that already owns it, so this report stays small and never rots:
> - **What shipped, per feature** → [`sprint-tracker.md`](sprint-tracker.md) + [`CHANGELOG.md`](../../CHANGELOG.md)
> - **Commit history** → `git log` (the source of truth — not duplicated here)
> - **Per-sprint detail** → the sprint dossiers under [`sprints/`](sprints/)
>
> Effort is tracked **per sprint (one row) and per phase**, never per commit. Hours use
> the owner-approved **AI-estimated + 20%** convention.

---

## Executive Summary

**Project:** Saranidhi (The Treasure House of Breath)
**Scope:** Cross-platform (iOS, Android, Web) Siddha breath-timing app with a pure-Dart Vedic calculation engine (Sara Kalai + Panja Pakshi)
**Sprints Delivered:** 36 (Sprints 1–38, incl. 27.5 hotfix; several consolidated) + Sprint 0 pre-development
**Total Engineering Investment:** **~116.5 hours** (incl. ~26.5h Research & Knowledge Engineering)
**Production Web Release:** **v1.7.0-web — LIVE** at [saranidhi.vercel.app](https://saranidhi.vercel.app) (tag `v1.7.0-web`, Sprint 37) · **v1.8.0 built (Sprint 38), release pending**
**Automated Tests:** 564 (unit + widget + integration)
**Current Phase:** Phase 2b underway — flagship **Integrated Aruḍam** slice 1 (the ambient "Aruḍam Now" verdict, Moment × Readiness) built + merged (PR #181, Sprint 38); **next: `/release-start` for v1.8.0**. Both corpora fully CONF-resolved (Sara Kalai 26/26, Panja Pakshi 6/6).

---

## Time Investment Breakdown

> Derived from sprint/phase clustering, not per-commit accounting. AI-assisted
> development compresses timelines substantially vs traditional development.

### Active Coding & Debugging (AI-assisted, sprint track)

| Phase | Sprints | Hours |
|-------|---------|-------|
| Foundation & core engine | 0–11 | ~19.5 |
| Feature build-out | 12–27 | ~35.0 |
| Polish, hardening & layers | 27.5–36 | ~12.0 |
| Sprint 37 — Birth-Bird Engine Correction (v1.7.0) | 37 | ~6.0 |
| Sprint 38 — Integrated Aruḍam, Slice 1 (v1.8.0) | 38 | ~6.0 |
| **Subtotal** | | **~78.5** |

### Infrastructure, Release & Admin Ops (off-commit)

| Activity | Hours |
|----------|-------|
| Vercel hosting (staging/prod/preview), CI setup & debugging, Drift WASM config | ~3.5 |
| Flutter SDK provisioning, project planning & architecture docs | ~3.5 |
| Smoke-test execution & release operations (all releases) | ~4.0 |
| **Subtotal** | **~11.0** |

### Research & Knowledge Engineering (Phase 2a → pre-2b, off-sprint)

> A distinct work-stream: digitizing the doctrinal source corpus, resolving cross-source
> conflicts, and capturing product strategy — the foundation for the ≥95%-fidelity vision.
> Bulk capture/transcription ran on Antigravity locally; figures below are **Kiro Web's
> share** (prompt design, per-batch verification, resolution authoring, docs, PRs).

| Activity | Hours | PRs |
|----------|-------|-----|
| Sara Kalai corpus capture (books, 2025 video, Telegram) | ~7.5 | #149, #151, #152, #154 |
| Sara Kalai CONF-resolution — **26/26** (4 Tier-1 engine blockers) | ~7.0 | #155 |
| Sara Kalai YouTube corroboration (11 videos) | ~2.5 | #156 |
| `.kiro` planning-docs audit → v1.6.0 | ~1.5 | #153 |
| Product strategy (North Star, Now Surface, Sacred Consultation) | ~3.5 | #157, #158, #159 |
| Panja Pakshi corpus capture (45 practices / 10 topics) | ~4.5 | #160 |
| **Subtotal** | **~26.5** | |

> Panja Pakshi CONF-PP resolution (6/6) and the valuation consolidation were folded
> into the sprint/admin lines above (#161–#163).

### Total

| Category | Hours |
|----------|-------|
| Active coding & debugging (sprint track) | ~78.5 |
| Infrastructure, release & admin ops | ~11.0 |
| Research & knowledge engineering | ~26.5 |
| **Total** | **~116.5** |

---

## Sprint Delivery Summary

> One row per sprint — the correct granularity for valuation. Feature-level detail
> lives in [`sprint-tracker.md`](sprint-tracker.md); per-sprint artifacts (spec /
> implementation / test summaries) live in the [`sprints/`](sprints/) dossiers.

| Sprint | Focus | PR(s) | Status |
|--------|-------|-------|--------|
| 0 | Pre-development & project initialization | — | ✅ |
| 1 | Project scaffold & core architecture | #1 | ✅ |
| 2 | Astro-Logic Engine (pure-Dart TDD) | #2 | ✅ |
| 3 | Sara Kalai Breath Journal UI + logic | #3, #4 | ✅ |
| 4 | Streak & Consistency Engine + UI polish | #5–#9 | ✅ |
| 5 | Cloud Backup Integration | #10 | ✅ |
| 6 | Notifications + Onboarding | #11 | ✅ |
| 7 | AI Wisdom Engine | #12 | ✅ |
| 8 | Theming, Profile & Core UX | #13 | ✅ |
| 9 | i18n, Animations & Polish | #14 | ✅ |
| 10 | Testing & Hardening | #16 | ✅ |
| 11 | Smoke Test Plan & CI Polish | #18 | ✅ |
| 12 | Pakshi algorithm fix + Tamil translations | #21, #22, #23 | ✅ |
| 13 | Web Production Deployment | #25, #26 | ✅ |
| 14 | Birth Bird Dashboard + Rahu Kaal + Nostril Chart | #29 | ✅ |
| 15 | Night Yamas + Full 24h View | #33, #34 | ✅ |
| 16 | iCloud Sync + macOS Target | #39 | ✅ |
| 17 | Notifications + Daily Engagement | #41 | ✅ |
| 18 | Historical View + Planning | #44 | ✅ |
| 19 | Analytics + Export | #46 | ✅ |
| 20 | UI Polish + Home Layout Redesign | #51 | ✅ |
| 21 | Pakshi Accuracy (DOB-based calculation) | #54 | ✅ |
| 22 | Widget Test Coverage + Web Polish | #56 | ✅ |
| 23 | Product Polish — About, User Guide, Onboarding Intro | #59 | ✅ |
| 24 | UX Polish — Empty States, Loading & Error Handling | #61 | ✅ |
| 25 | Performance, Accessibility & Smoke-Test Refresh | #63 | ✅ |
| 26 | Daily Engagement & Delight | #65 | ✅ |
| 27 | Layer 1 Gap Fixes — Diagnostic Foundation | #68 | ✅ |
| 27.5 | Bugfix + UX Polish (production testing fixes) | #78 | ✅ |
| 28 | UI Polish + UX Consistency | #95 | ✅ |
| 29 | Foundation — Terminology, PWA, Tech Debt | #102 | ✅ |
| 30 | Action Windows Engine + UI | #104 | ✅ |
| 31 | Numerology + Oracle Engine + GPS | #115 | ✅ |
| 32 | Prasanam Oracle UI | #118 | ✅ |
| 36 | Stability & Test Hardening (v1.6.0) | #141 | ✅ 🚀 |
| 37 | Birth-Bird Engine Correction (v1.7.0) | #167 | ✅ 🚀 |
| 38 | ★ Integrated Aruḍam — Slice 1 (v1.8.0) | #181 | ✅ (release pending) |

> 🚀 = shipped a production release. Sprint 37 was the first sprint under the
> **spec → coding-setup → review** model (Kiro Web spec + review; Antigravity implement
> + local test) — see the [Sprint 37 dossier](sprints/sprint-37-birth-bird/README.md).

---

## Post-v1.6.0 — Research & Knowledge-Engineering Phase (off-sprint)

After v1.6.0 the project entered a knowledge-engineering phase (Phase 2a → pre-2b):
building the doctrinal corpus from which the forward backlog is derived. Docs-only work
(no app code / release), tracked as a work-stream rather than numbered sprints.

| Work | PRs | Status |
|------|-----|--------|
| Sara Kalai corpus — books + 2025 video + Telegram | #149, #151, #152, #154 | ✅ Merged |
| Sara Kalai CONF tracker — **26/26 resolved** (4 Tier-1 engine blockers) | #155 | ✅ Merged |
| Sara Kalai YouTube corroboration (11 videos) | #156 | ✅ Merged |
| `.kiro` planning-docs audit → v1.6.0 | #153 | ✅ Merged |
| Product strategy: North Star, The Now Surface, Sacred Consultation | #157, #158, #159 | ✅ Merged |
| Panja Pakshi corpus — 45 practices / 10 topics | #160 | ✅ Merged |
| Valuation consolidation | #161 | ✅ Merged |
| Panja Pakshi CONF-PP resolution — **6/6 resolved** (2 Tier-1 engine conflicts) | #162, #163 | ✅ Merged |

> **Corpus status:** Sara Kalai = 87 practices / 14 topics / **26 CONFs resolved**;
> Panja Pakshi = 45 practices / 10 topics / **6 CONF-PP resolved**. Both corpora are
> fully CONF-resolved. The Panja Pakshi Tier-1 conflicts (partition 5-5-5-5-7 → 5-6-5-5-6,
> permanent bird vs Krishna swap) were adjudicated and **shipped in Sprint 37 / v1.7.0**.
> **Next:** `/plan` Phase 2b backlog derivation ("Integrated Aruḍam" epic).

---

## How this report is maintained

Updated at `/sprint-update` and `/release-update`:

- **Add one row** to *Sprint Delivery Summary* per sprint (focus + PR + status).
- **Bump the phase hours** in *Time Investment Breakdown* (AI-estimated **+20%**).
- **Refresh the *Executive Summary*** (prod version, current phase).

Explicitly **NOT** maintained here (delegated, to keep this report from rotting):

- ❌ A per-commit timeline → use `git log`.
- ❌ A per-feature deliverables list → use [`sprint-tracker.md`](sprint-tracker.md) + [`CHANGELOG.md`](../../CHANGELOG.md).

---

[← Back to Root](../../README.md)
