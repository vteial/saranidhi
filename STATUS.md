# Project Status & Executive Summary

| Property | Value |
| :--- | :--- |
| **Project ID** | PRJ-001 |
| **Project Name** | Saranidhi — The Treasure House of Breath |
| **Current Health** | 🟢 On Track |
| **Dev Environment** | 💻 Local |
| **Owner / Lead** | Eialarasu |
| **Last Updated** | 2026-10-25 |

---

### 1. Elevator Pitch (Business Purpose)
A local-first, zero-backend Flutter app for daily spiritual guidance — Sara Kalai / Siva Swarodaya breath-swara tracking, Panja Pakshi bird-state timing, and Vedic Hora/Tattva — with all user data on-device or in the user's own cloud. Bilingual (English + pure Tamil); privacy by architecture.

### 2. Latest Deliveries & Business Wins
- **Accuracy & Validation epic resolved (Oct 2026, PRs #296–#309)** — measured Saranidhi against three-way ground truth (Align27 ↔ Drik Panchang agree 100%; Saranidhi 24.3% cross-engine, both Cock and Owl matrices), traced the gap to a **model-layer lineage conflict** (captured honestly as **CONF-PP-007**, not patched blindly), and shipped the resolvable layer: **(a)** rescaled bird-state scoring to the primary Tamil source's failure semantics (*Kottumozhi Sathya* p.12 — Ruling 100 / Eating 80 / Walking 50 / Sleeping 20 / Dying 5) via `pakshi-scoring-corpus-alignment` (#304); **(b)** activated the **Adhikara (×1.15) / Padu (×0.5) day-block modifiers** on both Prasanam + Home surfaces via a shared pure helper, floor-lock-safe and null-bird no-op (#305 spec → #306); **(c)** validated the day-blocks at **100% primary-source agreement (14/14)** against the Owl 7-day matrix (#307 plan → #308 sheets → #309 calibration report). Per-yama sequence tables held byte-unchanged throughout (CONF-PP-007 firewall).
- **v1.13.0-web shipped** — Practice Sync Phase 1: opt-in (default OFF), on-demand cross-device sync via a swappable `SyncTransport` → self-hosted PocketBase. Owner-scoped, append-only/idempotent, offline-first preserved — the first release to cross the network boundary (security re-review passed).
- **Practice Sync auto-on-open shipped (`practice-sync-auto-on-open`, PR #294)** — the Phase-1 fast-follow: promotes the manual "Sync now" to an automatic pull-merge-push on app open + resume, strictly behind the existing opt-in + auth gate (zero traffic when OFF), debounced (per-session + 5-min resume) and silent-on-failure so offline-first startup is unchanged. Additive — engine/transport/owner-ID merge/iCloud path untouched; security re-review re-run (no auto sign-in, verified by test).
- **Golden-Fixture Correctness Gate shipped + HARDENED (`TSK-golden-01` #280, `TSK-golden-02` #290)** — a frozen 37-case fixture CI reconciling fail-closed over the astro engines, upgraded to a correctness *proof* with 7 independent ground-truth literals (Meeus Example 47.a + CONF-PP-001 star-table rows, all 5 birds) that are never engine-regenerated — a baked-in bug fails closed. Test/fixture/tooling-only; the engine passed all 7 ground-truth cases.
- **~48 sprints · 299 merged PRs · ~162 engineering hours.**

### 3. Current Focus & Next Milestone
- **v2.0.0 release readiness** — the next milestone. Five backlog items on the critical path: E2E feature-integration testing, a comprehensive v2.0 smoke-test plan, User Guide refresh, performance pass, and wiring the Sprint-26 deferred widgets. None depend on the open per-yama sequence question.
- **One open doctrinal gate (non-blocking): CONF-PP-007** — the per-yama bird-state *sequence* lineage decision. Firewalled from the shipped scoring/day-block layer; awaits a pre-Pulippani primary-source grid **or** an owner ruling to adopt Align27/Drik as canonical. Owner may research in parallel; it blocks nothing toward 2.0.
- Standing quality-gate candidates: AST/architecture-boundary fitness tests; `verify-bundle` deploy check; exhaustive 27-nakshatra / 24-hora / 5×5 bird-state coverage (deferred from `TSK-golden-02` §4).

### 4. Blockers & Risks
- **Blockers**: None. *(CONF-PP-007 per-yama sequence is an open research question, explicitly NON-blocking — firewalled from shipped behavior; blocks no 2.0 item.)*
- **Key Risks**: Fly.io PocketBase backend **live in production** (`saranidhi-pb.fly.dev`, health 200, `sessions`+`journal` provisioned, URL baked into the Vercel web build); remaining sync items are post-boundary hardening (token-rotation UX, cert pinning, at-rest encryption) logged as accepted/deferred risk in the Sprint-47 security review — none gate 2.0. Accuracy ground truth validated only for day-blocks (14/14) + Cock/Owl cross-engine baseline; per-yama sequence fidelity remains lineage-gated pending CONF-PP-007.

### 5. Verified Quality Metrics
- 2-tier CI: `flutter analyze --fatal-infos` (zero issues) + `flutter test` (green except the 4 known CloudKit macOS failures) + `flutter build web`; coverage **≥ 19%**; web integration gate (`flutter drive`) blocking.
- Every merge human-gated (`/review-pr`); Operator (Kiro) never merges/tags; prod + staging in sync on v1.13.0-web. *(This session's #296–#309 were spec/test/docs-class — no pubspec bump; next bump is the v2.0 release branch.)*

<!-- Canonical path: ~/dev-home/personal/saranidhi/STATUS.md · cetana 35-line schema · consumed by the personal cetana-labs portfolio dashboard (PRJ-001 row) · updated at /sprint-update + /release-update · Last verified: 2026-10-25 (v1.13.0-web; Accuracy & Validation epic resolved, #296–#309) -->
