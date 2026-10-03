<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/_template/requirements.md
  Saranidhi Kiro Spec — REQUIREMENTS template (EARS acceptance criteria = Definition of Done).
  Copy this folder to .kiro/specs/<spec-id>/ and fill it. Authored by the Operator,
  merged to main via /plan-done (merge-first) BEFORE the Executor (Antigravity) runs /spec-run.
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# <Feature Title> — Requirements

| Property | Value |
| :--- | :--- |
| **Spec ID** | `<spec-id>` (kebab-case; = `.kiro/specs/<spec-id>/` dir name) |
| **Feature** | <one-line description of the capability> |
| **Backlog** | `<TSK-xxx>` / `<BK-xxx>` (SPRINT-NN) |
| **Status** | 🟡 Proposed (authored on Kiro Web / Operator; executed by Antigravity / Executor) |
| **CONF** | `<CONF-nn>` / `<CONF-PP-nn>` resolved, or `n/a` for non-doctrinal work |
| **Enables** | <downstream specs/features this unblocks> |
| **Executor** | Antigravity (`/spec-run <spec-id>`) |

---

## 1. Introduction
<What this delivers and why, in 2–4 sentences. Link the corpus practice + resolved CONF
when the change touches doctrine (birth-bird, swara/nostril clock, Oracle/Aruḍam scoring,
Hora/Tattva, DB migrations). The owner's CONF-tracker lineage decision IS source truth
when sources conflict.>

## 0. Preconditions (preflight — verify BEFORE any change; enforced by tasks.md T0)
- **P1 — Surface:** Executor (Antigravity on the owner's Mac); local Flutter toolchain able to run `just validate-local`.
- **P2 — Toolchain:** `flutter 3.47.5` (Homebrew cask), Dart SDK, Chrome (web build). `just env-doctor` green.
- **P3 — Branch:** `sprint/<spec-id>` (or `fix/*`) off up-to-date `main`; clean tree; not `main`/`prod`.
- **P4 — Merge-first:** this Spec merged to `main` before `/spec-run` (satisfied by `/plan-done`).
- **P5 — Baseline green:** `just validate-local` — analyze `--fatal-infos` + test + build web GREEN
  (the "green except the 4 known CloudKit macOS failures" baseline).

## 2. Current-state facts (of record — verified)
- <Pin what exists today that this change builds on / must not break. Cite files + line anchors.>

## 3. Requirements (EARS acceptance criteria = Definition of Done)

### R1 — <Primary behavior>
- **R1.1** The system SHALL <testable behavior>.
- **R1.2** WHEN <trigger>, the system SHALL <response>.

### R2 — <Secondary behavior / edge cases>
- **R2.1** IF <precondition>, THEN the system SHALL <response>.

<!-- ───────────── STANDING CRITERIA — EVERY saranidhi Spec carries these ───────────── -->

### RT — Tamil bilingual gate (STANDING — non-negotiable; collaboration-guardrails §4)
- **RT.1** Every new/changed user-facing string SHALL be bilingual: English + **pure Tamil
  script** (தமிழ்), via the `l10n` ARB flow — never transliteration, never a hardcoded English literal.
- **RT.2** The feature SHALL be eyeballed in Tamil mode before the PR; partially-localized
  widgets (the recurring v1.8.1 miss) SHALL be explicitly checked.
- **RT.3** Trilingual nakshatra selection SHALL use `NakshatraL10n.trilingualDisplay()`
  ("English / தமிழ்") wherever a nakshatra is chosen.

### RC — CONF provenance (STANDING for doctrinal work; collaboration-guardrails §4)
- **RC.1** Any doctrinal rule/calculation changed here SHALL cite its corpus practice +
  the resolved `CONF-nn` (Sara Kalai) / `CONF-PP-nn` (Panja Pakshi) in §1 and in the PR body.
- **RC.2** Where sources conflict, the owner's CONF-tracker lineage decision SHALL be
  treated as source truth and referenced by id.

### RQ — Quality gates / no regression (STANDING)
- **RQ.1** `just validate-local` SHALL pass: `flutter analyze --fatal-infos` (zero issues),
  `flutter test` (green except the 4 known CloudKit macOS failures), `flutter build web`.
- **RQ.2** Tier-2 coverage SHALL remain **≥ 19%** (`THRESHOLD=19`); the web integration
  gate (`flutter drive`) SHALL stay green (blocking as of Sprint 36).
- **RQ.3** Behavior explicitly listed as "must stay UNCHANGED" in §2 SHALL be pinned by a test.

## 4. Out of scope (scope honesty)
- <What this Spec deliberately does NOT do, and which future spec owns it.>

## 4b. Human Verification Plan (emitted by /spec-run; recorded by /verification-done)
Run on the deployed PR preview (Vercel) and/or local web build:
- **V1 — <happy path>:** <exact steps a human clicks + expected result>.
- **VT — Tamil mode:** switch to Tamil; the new UI renders in pure Tamil script, no English leak (RT).
- **VQ — gates:** `just validate-local` green; coverage ≥ 19%; integration gate green (RQ).
