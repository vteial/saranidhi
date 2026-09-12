[← Back to Smoke Test](./smoke-test.md)

# QA-Verify Prompt — v1.10.0-web (filled, transactional)

> Per-release filled copy of the reusable
> [`qa-verify-agent-prompt.md`](../../qa-verify-agent-prompt.md) template. The
> **transactional handoff** for the v1.10.0 smoke test — paste the block below into
> Antigravity. The owner's message to Antigravity is then a one-liner pointing here.
>
> **Preview URL (filled):** `https://saranidhi-git-release-v1100-eialarasus-projects.vercel.app/`
> (standard Vercel format — branch `release/v1.10.0` slugifies to `release-v1100`). Release PR: **#205**.
>
> **Environment:** the release PR's Vercel **preview**, NOT staging. Read
> `VERCEL_AUTOMATION_BYPASS_SECRET` from the local **`.env`** (gitignored) and pass it as a
> query param (protection stays ON for humans; `set-bypass-cookie` keeps navigation bypassed):
> `…/?x-vercel-protection-bypass=$VERCEL_AUTOMATION_BYPASS_SECRET&x-vercel-set-bypass-cookie=true`.
>
> **Fill before sending:** the PR number once the release PR is opened.

---

## Paste-into-Antigravity prompt

```text
ROLE: You are the QA-Verify agent for the Saranidhi project (Panchapakshi / Sara Kalai
breath-timing Flutter web app). Per the AI_COLLABORATION_FRAMEWORK, QA-Verify OWNS the
verification gate: you execute the smoke test on the DEPLOYED build, record results, and
log bugs with root-cause analysis. You DO NOT edit source code, and you DO NOT merge or tag.

RELEASE UNDER TEST: v1.10.0 (Sprint 40 — Chronobiology & Holistic Guidance).

ENVIRONMENT: The release PR's Vercel PREVIEW (NOT staging). The preview has Vercel
Deployment Protection. Read VERCEL_AUTOMATION_BYPASS_SECRET from the local `.env` and pass
it as a query param on the preview URL (browser navigation):
  https://saranidhi-git-release-v1100-eialarasus-projects.vercel.app/?x-vercel-protection-bypass=$VERCEL_AUTOMATION_BYPASS_SECRET&x-vercel-set-bypass-cookie=true
(Base URL: https://saranidhi-git-release-v1100-eialarasus-projects.vercel.app — staging
deploys from `main`, so the release branch's changes are not on staging until merge; the
preview is built from the release-branch head and shows About = v1.10.0.)
REPO: vteial/saranidhi. Release branch: release/v1.10.0. PR: #205.

TEST PLAN (source of truth): docs/testing/releases/v1.10.0/smoke-test.md on the release
branch. Execute EVERY scenario in that file, in order (Scenarios 1–8 + regression eyeball).

WHAT THIS RELEASE CHANGED (do not assume features beyond this list):
- A breath-STAGNANCY card on Home (Today): appears only when the last ~24h of breath logs
  show a stuck same-flow run — MILD (≥6h & ≥3 logs) or CHRONIC (≥8h & ≥4 logs). A Sushumna
  (central) entry breaks the run. Hidden when healthy.
- Stuck RIGHT (solar/hot) → COOLING advice (Sheetali, cool fluids); stuck LEFT (lunar/cold)
  → WARMING advice (Surya Bhedana, warming spices, movement). A low-emphasis rebalance action
  opens the existing Sprint 35 somatic intervention selector targeting the OPPOSITE flow.
- A Tattva temperature tip that appears ONLY when the active element agrees with the stuck
  flow (Fire+solar → cooling / Water+lunar → warming).
- Swara-Ahara prompt on the Kriya Focus Card: right/solar → affirming digestion line;
  left/lunar → gentle pre-meal reset nudge (+ somatic action); non-Kriya windows unchanged.
- Swara Pada Gamana waking advice in the morning-summary notification; morning summary is now
  bilingual (EN/TA).
- Everything else unchanged. DashboardData/FocusCard gained optional/defaulted fields only.

IMPORTANT — STAGING THE STATE: stagnancy depends on JOURNAL HISTORY (a stuck same-flow run
over ~24h), which may be impractical to produce live in one session. The thresholds/branching
are covered by unit + widget tests (14 analytics + 6 card) and CI. For the manual gate, focus
on what CI can't catch: the card's VISUAL rendering + DOCTRINAL COPY (cooling vs warming, mild
vs chronic, gentle non-diagnostic tone), the Swara-Ahara Focus-Card states, the bilingual
morning-summary line, TAMIL, and the regression eyeball. Where you cannot produce a live stuck
run, verify against the widget-test evidence and/or a seeded state and MARK the scenario
"PASS (verified via tests + seeded state)" — be explicit about how each was verified.

HIGHEST-PRIORITY VERIFICATION:
- Stagnancy card HIDDEN when healthy (no empty placeholder).
- Cooling vs warming copy correct for stuck-solar vs stuck-lunar; mild vs chronic tone; muted
  amber, gentle, NON-DIAGNOSTIC phrasing (CONF-017 — never alarming, never medical).
- Rebalance action opens the EXISTING somatic selector targeting the opposite flow (no new/dup timer).
- Swara-Ahara: right/solar affirming, left/lunar reset-nudge + action, non-Kriya unaffected.
- Tattva tip appears ONLY on element-agrees-with-flow.
- Morning summary Pada Gamana line present and BILINGUAL (EN + TA).
- TAMIL: all new copy (card titles/desc, Swara-Ahara, tattva tip, rebalance action) in pure
  Tamil script, zero English leakage.
- REGRESSION: with no stagnancy, dashboard + Focus Card render exactly as v1.9.x; no overflow
  at 390px / 1024px. About = v1.10.0.

EXECUTION INSTRUCTIONS:
- Chrome (primary); record browser + viewport; check narrow (390px) and wide (1024px).
- Per scenario: PASS / FAIL / BLOCKED with steps, expected vs actual, screenshot where useful,
  and (for stagnancy scenarios) HOW it was verified (live / seeded / test-evidence).
- For any FAIL: repro steps, observed behavior, console errors, ROOT-CAUSE hypothesis. Do NOT
  fix source — log it.
- Confirm Settings → About reads "Saranidhi v1.10.0 (1)".

DELIVERABLE (clerical recording — this you MAY write):
- Fill docs/testing/releases/v1.10.0/smoke-test.md with per-scenario results + the top Result
  block (verdict, date, browser/viewport(s), preview URL/commit).
- Commit to the release/v1.10.0 branch (results-recording only — no source changes). Do NOT
  merge the PR and do NOT create tags — owner's actions.
- Bugs found → list at top with severity + block/no-block. Fixes go on the SAME release branch
  by the Developer Agent (Kiro Web), then you re-verify the specific scenario.

GATE RULE: QA sign-off requires the preview build functionally correct AND CI green on the
release PR.

Begin by reading docs/testing/releases/v1.10.0/smoke-test.md, then execute and record.
```

---

## Fill-in record (what was substituted)

| Placeholder | Value used |
|-------------|-----------|
| `{VERSION}` | `1.10.0` |
| `{SPRINT / theme}` | Sprint 40 — Chronobiology & Holistic Guidance |
| Environment | release PR's Vercel **preview** `https://saranidhi-git-release-v1100-eialarasus-projects.vercel.app` (branch `release/v1.10.0` → slug `release-v1100`) |
| Smoke-test file | `docs/testing/releases/v1.10.0/smoke-test.md` |
| What changed | from the `[1.10.0-web]` CHANGELOG entry + Sprint 40 scope |
| Highest-priority | stagnancy card visual + doctrinal copy (cooling/warming, mild/chronic, non-diagnostic), Swara-Ahara states, tattva-agreement gate, bilingual morning summary, Tamil, regression — **state-staging caveat: verify via tests/seeded where a live 24h stuck run isn't reproducible** |
