[← Back to Root](../../README.md)

# Saranidhi — Smoke Test History

Each production release has a single smoke test file containing both the plan (scenarios + expected outcomes) and the execution results.

## Release History

| Version | Date | Tester | Scenarios | Verdict | File |
|---------|------|--------|-----------|---------|------|
| v1.0.0-web | 2026-07-02 | Eialarasu | 42 | ✅ PASS | [v1.0.0](releases/smoke-test-v1.0.0.md) |
| v1.2.0-web | 2026-07-08 | Eialarasu | 62 | ✅ PASS | [v1.2.0](releases/smoke-test-v1.2.0.md) |
| v1.2.1-web | 2026-07-10 | Eialarasu | 30 | ✅ PASS (1 accepted) | [v1.2.1](releases/smoke-test-v1.2.1.md) |
| v1.2.2-web | 2026-07-11 | Eialarasu | 23 | ✅ PASS | [v1.2.2](releases/smoke-test-v1.2.2.md) |
| v1.3.0-web | 2026-07-12 | Eialarasu + Kiro | 25 | ✅ PASS (1 accepted) | [v1.3.0](releases/smoke-test-v1.3.0.md) |
| v1.4.0-web | 2026-07-16 | Eialarasu + Kiro | 41 | ✅ PASS (3 accepted) | [v1.4.0](releases/smoke-test-v1.4.0.md) |
| v1.4.1-web | 2026-08-27 | Eialarasu + Kiro | 21 | ✅ PASS | [v1.4.1](releases/smoke-test-v1.4.1.md) |
| v1.4.2-web | 2026-07-14 | Eialarasu + Kiro | 33 | ✅ PASS (2 accepted, 7 deferred) | [v1.4.2](releases/smoke-test-v1.4.2.md) |
| v1.5.0-web | 2026-09-04 | Eialarasu + Kiro (Antigravity QA) | 35 | ✅ PASS (1 accepted, 6 deferred) | [v1.5.0](releases/smoke-test-v1.5.0.md) |
| v1.6.0-web | 2026-09-07 | Eialarasu + Kiro (Antigravity QA) | 13 | ✅ PASS (1 accepted) | [v1.6.0](releases/smoke-test-v1.6.0.md) |
| v1.7.0-web | 2026-09-11 | Eialarasu (iPad, live) + Antigravity QA | 12 | ✅ PASS | [v1.7.0](releases/v1.7.0/smoke-test.md) |
| v1.8.0-web | 2026-09-12 | Antigravity QA (headed, PR preview) | 6 + visual + doctrinal | ✅ PASS | [v1.8.0](releases/v1.8.0/smoke-test.md) |
| v1.8.1-web | 2026-09-12 | — (cosmetic l10n hotfix) | CI + Tamil-mode eyeball | ✅ PASS (no full matrix — hotfix) | — |
| v1.9.0-web | 2026-09-12 | Antigravity QA (headed, PR preview) | 6 + regression eyeball | ✅ PASS | [v1.9.0](releases/v1.9.0/smoke-test.md) |
| v1.10.0-web | 2026-09-13 | Antigravity QA (PR preview) | 8 + regression eyeball | ✅ PASS | [v1.10.0](releases/v1.10.0/smoke-test.md) |
| v1.10.1-web | _pending_ | Antigravity QA (PR preview) | 3 (slim — light patch) | ⏳ pending | [v1.10.1](releases/v1.10.1/smoke-test.md) |
| v1.11.0-web | 2026-09-14 | Antigravity QA (PR preview) | 7 + regression eyeball | ✅ PASS | [v1.11.0](releases/v1.11.0/smoke-test.md) |
| v1.11.1-web | 2026-09-14 | Owner + Antigravity QA (PR preview) | 4 (slim — cosmetic l10n + width fit) + regression | ✅ PASS | [v1.11.1](releases/v1.11.1/smoke-test.md) |
| v1.12.0-web | 2026-09-15 | Owner (real cross-device: iMac + iPad Mini) | 10 (full — migration + cross-device merge + owner guard + aggregate) + regression | ✅ PASS (with notes → v1.12.1) | [v1.12.0](releases/v1.12.0/smoke-test.md) |
| v1.12.1-web | 2026-09-15 | Owner (PR #246 preview) | 6 (targeted patch — import-before-onboarding, in-place refresh, filename prefix) + regression + EN/TA | ✅ PASS | [v1.12.1](releases/v1.12.1/smoke-test.md) |
| v1.13.0-web | 2026-09-16 | Owner (PR #265 preview, real cross-device: 3 physical devices) | 8 (★ Practice Sync Phase 1 — opt-in gate, sign-in, cross-device round-trip, scopes, owner-guard, offline-first, EN/TA, regression) | ✅ PASS (4 fixes during smoke; error-UX + sign-up → v1.13.1) | [v1.13.0](releases/v1.13.0/smoke-test.md) |

## Process

1. Sprint merged → staging auto-deploys
2. Open `docs/smoke-test-v{X.Y.Z}.md` — scenarios + results in one file
3. Execute on staging, fill in Pass?/Notes columns
4. ALL sections pass → tag release → production
5. Any failures → hotfix → re-test failed scenarios

---

## Release Effort Reference — the smoke gate is mostly *fixed cost per release*

> **Why this matters for planning.** The manual smoke test is a human gate. Measured on the
> v1.12.1-web run, it is **~2 hours per release regardless of how little changed** — because the
> two biggest chunks are *fixed overhead* that every release pays, not per-scenario work. This is
> the single most useful input to the **"ship now vs. batch"** decision at `/plan` and
> `/release-start`.

### Measured baseline — v1.12.1-web (targeted patch smoke, 6 scenarios)

| Phase | Duration | Fixed or variable? |
|-------|:--------:|--------------------|
| Step 0 — pre-flight readiness gate (reach preview, verify About version, CI green) | **~33 min** | **Fixed** — paid every release |
| S4 — onboarding happy-path regression (full wizard walkthrough) | **~28 min** | **Fixed-ish** — core-flow regression re-run most releases |
| The actual *changed-behavior* scenarios (S1 import, S2 refresh, S3 filename) | **~31 min** | **Variable** — scales with what changed |
| S5 owner-guard + S6 bilingual regression | **~28 min** | **Fixed-ish** — safety + l10n re-check |
| Documentation & git finalization (fill smoke-test.md, commit, push) | **~11 min** | **Fixed** |
| **Active smoke** | **~1h 48m** | |
| **Total session (incl. docs + push)** | **~2h 00m** | |

> **Read:** of a ~2h patch-release smoke, only **~30 min** was spent verifying *what actually
> changed*. The other **~90 min** (pre-flight + onboarding + owner-guard/bilingual regression +
> finalization) is overhead that a full-feature release pays too. CI, by contrast, is cheap and
> fast — Analyze/Fast ~3 min, Full Suite + Coverage (661 tests) ~5 min — so **CI is never the
> bottleneck; the human smoke gate is.**

### Decision rule this implies (use at `/plan` + `/release-start`)

1. **Batch small polish/cosmetic items.** Because ~90 min of the smoke is per-*release* not
   per-*scenario*, N small fixes shipped as one release cost ~2h of smoke total; shipped as N
   separate patches they cost ~N×2h. Prefer batching unless an item is urgent or risky.
2. **A "light patch" is still a ~2h release, not a free one.** When scoping a fast-follow, price in
   the smoke gate — a one-line fix does **not** mean a one-line release.
3. **Reserve the fastest path (fold-into-PR hotfix, CI-only + eyeball — e.g. v1.8.1 / v1.11.1) for
   genuinely trivial, low-risk changes** (pure l10n/string, no logic/schema) where the full S1–S6
   walkthrough adds little confidence over CI + a targeted eyeball.
4. **The pre-flight gate (~33 min) is non-negotiable overhead** — it exists to prevent testing the
   wrong build (the v1.11.0 wrong-environment incident). Do not try to shave it; plan around it.

> **Maintenance:** update the measured baseline only when a *materially different* run gives better
> data (e.g. a full-matrix feature release, or once web E2E automation lands and shifts the gate
> cost). This is a planning heuristic, not a per-release log.

---

[← Back to Root](../../README.md)
