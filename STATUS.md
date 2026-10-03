# Project Status & Executive Summary

| Property | Value |
| :--- | :--- |
| **Project ID** | PRJ-001 |
| **Project Name** | Saranidhi — The Treasure House of Breath |
| **Current Health** | 🟢 On Track |
| **Dev Environment** | 💻 Local |
| **Owner / Lead** | Eialarasu |
| **Last Updated** | 2026-10-03 |

---

### 1. Elevator Pitch (Business Purpose)
A local-first, zero-backend Flutter app for daily spiritual guidance — Sara Kalai / Siva Swarodaya breath-swara tracking, Panja Pakshi bird-state timing, and Vedic Hora/Tattva — with all user data on-device or in the user's own cloud. Bilingual (English + pure Tamil); privacy by architecture.

### 2. Latest Deliveries & Business Wins
- **v1.13.0-web shipped** — Practice Sync Phase 1: opt-in (default OFF), on-demand cross-device sync via a swappable `SyncTransport` → self-hosted PocketBase. Owner-scoped, append-only/idempotent, offline-first preserved — the first release to cross the network boundary (security re-review passed).
- **Process converged to the cetana-labs family (PRJ-001)**: Operator/Executor/Human roles, merge-first Kiro Specs, `just` DX surface, cetana-style `.kiro/skills/`, Decision Journal, and this STATUS.md as the portfolio-dashboard contract.
- **Golden-Fixture Correctness Gate shipped (`TSK-golden-01`, PR #280)** — the first sprint fully on the new rails: a frozen 37-case fixture CI reconciles fail-closed over the astro engines (Moon longitude, nakshatra/bird, swara, Hora, Tattva, Oracle), converting the prose DoD into an executable, path-independent correctness check.
- **~47 sprints · ~273 PRs · ~157.5 engineering hours.**

### 3. Current Focus & Next Milestone
- **v1.13.1** — graceful sync error messages (no raw `ClientException` in UI) + first-class in-app account sign-up.
- Next quality-gate candidates: AST/architecture-boundary fitness tests; `verify-bundle` deploy check. Fly.io PocketBase deploy (owner-deferred) and the 7-day Accuracy Calibration behind it.

### 4. Blockers & Risks
- **Blockers**: None.
- **Key Risks**: Calc-correctness has no golden-fixture gate yet (coverage % only) — the top adoption target. Fly.io PocketBase deploy deferred (greened against local Docker Compose).

### 5. Verified Quality Metrics
- 2-tier CI: `flutter analyze --fatal-infos` (zero issues) + `flutter test` (green except the 4 known CloudKit macOS failures) + `flutter build web`; coverage **≥ 19%**; web integration gate (`flutter drive`) blocking.
- Every merge human-gated (`/review-pr`); Operator (Kiro) never merges/tags; prod + staging in sync on v1.13.0-web.

<!-- Canonical path: ~/dev-home/personal/saranidhi/STATUS.md · cetana 35-line schema · consumed by the personal cetana-labs portfolio dashboard (PRJ-001 row) · updated at /sprint-update + /release-update · Last verified: 2026-10-03 (v1.13.0-web) -->
