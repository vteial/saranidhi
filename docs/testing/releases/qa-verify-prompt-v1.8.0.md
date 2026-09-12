[← Back to Smoke Test](./smoke-test-v1.8.0.md)

# QA-Verify Prompt — v1.8.0-web (filled, transactional)

> Per-release filled copy of the reusable
> [`qa-verify-agent-prompt.md`](../qa-verify-agent-prompt.md) template. This is the
> **transactional handoff** for the v1.8.0 smoke test — paste the block below into
> Antigravity. The owner's message to Antigravity is then a one-liner pointing here.
>
> **Environment note (v1.8.0):** the smoke test runs on the **PR #184 Vercel _preview_**,
> NOT staging — staging deploys from `main`, so the release branch's changes aren't there
> until merge (see `dev-workflow.md` `/release-start`, corrected in PR #186). The preview
> is built from the release-branch head and correctly shows **About = v1.8.0** (owner
> already confirmed).

---

## Paste-into-Antigravity prompt

```text
ROLE: You are the QA-Verify agent for the Saranidhi project (Panchapakshi / Sara Kalai
breath-timing Flutter web app). Per the AI_COLLABORATION_FRAMEWORK, QA-Verify OWNS the
verification gate: you execute the smoke test on the DEPLOYED build, record results, and
log bugs with root-cause analysis. You DO NOT edit source code, and you DO NOT merge or tag.

RELEASE UNDER TEST: v1.8.0 (Sprint 38 — Integrated Aruḍam, Slice 1: the ambient "Aruḍam Now"
verdict card on Home).

ENVIRONMENT: The release PR's Vercel PREVIEW (NOT staging):
  https://saranidhi-git-release-v180-eialarasus-projects.vercel.app
(Staging deploys from `main`, so the release branch's changes are not on staging until the
PR is merged; the preview is built from the release-branch head and shows About = v1.8.0.)
REPO: vteial/saranidhi. Release branch: release/v1.8.0. PR: #184.

TEST PLAN (source of truth): docs/testing/releases/smoke-test-v1.8.0.md on the release
branch. Execute EVERY scenario in that file, in order (Scenarios 1–6).

WHAT THIS RELEASE CHANGED (do not assume features beyond this list):
- New "Aruḍam Now" verdict card at the TOP of the Home (Today) view — fuses bird-state,
  Hora, Tarabala, and auspiciousness into one score + band, with a two-clock breakdown
  (Moment = cosmic ceiling · You = breath readiness).
- Moment × Readiness scoring: naturally-aligned breath = full strength; misaligned = softer
  verdict (never blocked).
- Natural-vs-forced framing: misaligned guidance is "wait / accept / note"; a low-emphasis
  "Urgent?" affordance opens a WARNING-toned contralateral-shift sheet that never promises
  success; a "Re-check Breath" loop records the session as a forced shift.
- Inauspicious floor-lock now works at night too (Rahu Kaal / Emakandam), not only daytime.
- Fully bilingual (English + Tamil).

HIGHEST-PRIORITY VERIFICATION (this release's core risk areas — test explicitly):
- VISUAL RENDERING of the verdict card on BOTH a NARROW (mobile) viewport AND a WIDE
  (tablet/iPad) viewport — this is the #1 risk (a new hero card; CI can't catch layout).
  Confirm the two-clock breakdown, band color/score, and any "Urgent?"/"Check your breath"
  links render cleanly, no overflow, no clipping, in both widths.
- DOCTRINAL COPY (the North Star): confirm the misaligned guidance leads with patience
  ("wait / accept / note"), the "Urgent?" affordance is low-emphasis + warning-toned, and
  NOWHERE does the app present forced shifting as a guaranteed fix / success path.
- STALE-SWARA degrade: with no breath entry in the last ~30 min (or fresh), the "You" clock
  must show "breath observation needed" + "Check your breath →" — it must NOT fabricate an
  aligned/misaligned state.
- TAMIL: switch to தமிழ் and confirm the card title, both clock labels, the alignment
  statuses, and the urgent-sheet copy all render in correct Tamil (no English leakage,
  no mixed script).

EXECUTION INSTRUCTIONS:
- Test on Chrome (primary). Record browser + viewport for each run; test the card at both
  a narrow and a wide viewport.
- For each scenario: record PASS / FAIL / BLOCKED with exact steps, expected vs actual, and
  a screenshot where useful.
- For any FAIL: capture reproduction steps, observed behavior, console errors if any, and
  your ROOT-CAUSE hypothesis (which screen/widget/flow). Do NOT fix source — log it.
- Spot-check the core happy path (onboarding → dashboard → a breath journal entry →
  alignment result) to confirm the release didn't regress core behavior.
- NOTE: no data migration is user-visible this release (a wasForcedShift column was added,
  guarded); there is no birth-bird recalculation to re-verify. Focus on the card + framing.

DELIVERABLE (clerical recording — this you MAY write):
- Fill in docs/testing/releases/smoke-test-v1.8.0.md with results for every scenario
  (status, notes, evidence), plus the top "Result" block: verdict PASS / PASS-WITH-NOTES /
  FAIL, the date, browser/viewport(s), and the preview URL/commit tested.
- Commit the results to the release/v1.8.0 branch (results-recording commit only — no
  source changes). Do NOT merge the release PR and do NOT create tags — those are the
  owner's actions.
- If bugs are found: list them at top with severity and whether they block the release.
  Bugs get fixed on the SAME release branch by the Developer Agent (Kiro Web), then you
  re-verify the specific failed scenario.

GATE RULE: QA sign-off requires the preview build functionally correct AND CI green on
PR #184 (not just a passing Vercel preview render). Your job is the deployed-build
verification gate.

Begin by reading docs/testing/releases/smoke-test-v1.8.0.md, then execute and record.
```

---

## Fill-in record (what was substituted)

| Placeholder | Value used |
|-------------|-----------|
| `{VERSION}` | `1.8.0` |
| `{SPRINT / theme}` | Sprint 38 — Integrated Aruḍam, Slice 1 |
| Environment | **PR #184 preview** `https://saranidhi-git-release-v180-eialarasus-projects.vercel.app` (not staging — v1.8.0 preview, About card confirmed) |
| Smoke-test file | `docs/testing/releases/smoke-test-v1.8.0.md` |
| What changed | from the `[1.8.0-web]` CHANGELOG entry + Sprint 38 scope |
| Highest-priority | verdict-card visual (narrow+wide), doctrinal copy, stale-swara degrade, Tamil — **no migration path this release** |
