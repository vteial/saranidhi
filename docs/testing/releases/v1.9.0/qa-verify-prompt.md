[← Back to Smoke Test](./smoke-test.md)

# QA-Verify Prompt — v1.9.0-web (filled, transactional)

> Per-release filled copy of the reusable
> [`qa-verify-agent-prompt.md`](../../qa-verify-agent-prompt.md) template. The
> **transactional handoff** for the v1.9.0 smoke test — paste the block below into
> Antigravity. The owner's message to Antigravity is then a one-liner pointing here.
>
> **Environment note:** the smoke test runs on the **release PR's Vercel _preview_**, NOT
> staging — staging deploys from `main`, so the release branch's changes aren't there until
> merge. The preview is built from the release-branch head and shows **About = v1.9.0**.
>
> **Preview auth:** the preview has **Vercel Deployment Protection**. Read
> `VERCEL_AUTOMATION_BYPASS_SECRET` from the local **`.env`** (gitignored, never committed)
> and pass it as a **query param** on the preview URL (protection stays ON for humans; the
> `set-bypass-cookie` param keeps in-app navigation bypassed):
> `…/?x-vercel-protection-bypass=$VERCEL_AUTOMATION_BYPASS_SECRET&x-vercel-set-bypass-cookie=true`.
>
> **Fill before sending:** replace `{PREVIEW_URL}` and the PR number once the release PR's
> `vercel[bot]` comment posts the preview (branch `release/v1.9.0`).

---

## Paste-into-Antigravity prompt

```text
ROLE: You are the QA-Verify agent for the Saranidhi project (Panchapakshi / Sara Kalai
breath-timing Flutter web app). Per the AI_COLLABORATION_FRAMEWORK, QA-Verify OWNS the
verification gate: you execute the smoke test on the DEPLOYED build, record results, and
log bugs with root-cause analysis. You DO NOT edit source code, and you DO NOT merge or tag.

RELEASE UNDER TEST: v1.9.0 (Sprint 39 — Integrated Aruḍam "Why?" provenance accordion on the
"Aruḍam Now" verdict card). This is a TRANSPARENCY-ONLY release: it does not change the
verdict score/band/floor-lock or the Prasanam Oracle — only adds an explanation surface.

ENVIRONMENT: The release PR's Vercel PREVIEW (NOT staging). The preview has Vercel
Deployment Protection. Read VERCEL_AUTOMATION_BYPASS_SECRET from the local `.env` and pass
it as a query param on the preview URL (browser navigation):
  {PREVIEW_URL}/?x-vercel-protection-bypass=$VERCEL_AUTOMATION_BYPASS_SECRET&x-vercel-set-bypass-cookie=true
(Staging deploys from `main`, so the release branch's changes are not on staging until the
PR is merged; the preview is built from the release-branch head and shows About = v1.9.0.)
REPO: vteial/saranidhi. Release branch: release/v1.9.0. PR: #___.

TEST PLAN (source of truth): docs/testing/releases/v1.9.0/smoke-test.md on the release
branch. Execute EVERY scenario in that file, in order (Scenarios 1–6 + regression eyeball).

WHAT THIS RELEASE CHANGED (do not assume features beyond this list):
- A new "Why?" accordion on the "Aruḍam Now" card — COLLAPSED BY DEFAULT; tap to expand a
  plain-language explanation of the verdict.
- Expanded, reasons are grouped under "Moment — the timing" (bird state / hora / tarabala /
  activity harmony) and "You — your readiness" (breath), OR a single "Blocked" explanation
  during an inauspicious window (Rahu Kaal / Emakandam).
- Each reason line carries a subdued source citation (e.g. "· CONF-014"). NO raw arithmetic
  is ever shown. NO tooltips.
- Fully bilingual (English + Tamil).
- Everything else (score, bands, floor-lock, two-clock breakdown, Oracle) is UNCHANGED.

HIGHEST-PRIORITY VERIFICATION (this release's core risk areas — test explicitly):
- The "Why?" section is COLLAPSED BY DEFAULT (no reason text / no "CONF-" visible until
  tapped), and expands/collapses cleanly with a ≥44×44 tap target.
- DOCTRINAL COPY (the North Star): the misaligned readiness reason must read as "dampened —
  not blocked … the higher path is to wait" — it must NEVER frame forced shifting as the
  success path. The floor-lock explanation must read as "rest / turn inward".
- GROUPING: normal verdict → "Moment — the timing" + "You — your readiness" subheads;
  floor-locked → a SINGLE "Blocked" reason (CONF-018), no Moment/You subheads; stale breath
  (>30 min / none) → Moment reasons only, NO fabricated readiness line.
- NO RAW MATH: confirm no numbers/arithmetic appear anywhere in the "Why?" body (only
  doctrine + "· CONF-…" citations).
- TAMIL: switch to தமிழ் and confirm the label (ஏன்?), the headings, and all reason prose
  render in pure Tamil script (no English leakage). Citations may remain "· CONF-…".
- REGRESSION EYEBALL: with "Why?" collapsed, the card header + two-clock breakdown +
  guidance box must render exactly as v1.8.x; no overflow at 390px or 1024px.

EXECUTION INSTRUCTIONS:
- Test on Chrome (primary). Record browser + viewport for each run; check both a narrow
  (390px) and a wide (1024px) viewport.
- For each scenario: record PASS / FAIL / BLOCKED with exact steps, expected vs actual, and
  a screenshot where useful.
- For any FAIL: capture reproduction steps, observed behavior, console errors if any, and a
  ROOT-CAUSE hypothesis (which widget/flow). Do NOT fix source — log it.
- Confirm Settings → About reads "Saranidhi v1.9.0 (1)".

DELIVERABLE (clerical recording — this you MAY write):
- Fill in docs/testing/releases/v1.9.0/smoke-test.md with results for every scenario
  (status, notes, evidence) + the top "Result" block: verdict PASS / PASS-WITH-NOTES /
  FAIL, date, browser/viewport(s), and the preview URL/commit tested.
- Commit results to the release/v1.9.0 branch (results-recording commit only — no source
  changes). Do NOT merge the release PR and do NOT create tags — those are the owner's.
- If bugs are found: list them at top with severity + whether they block the release. Bugs
  get fixed on the SAME release branch by the Developer Agent (Kiro Web), then you re-verify
  the specific failed scenario.

GATE RULE: QA sign-off requires the preview build functionally correct AND CI green on the
release PR (not just a passing Vercel preview render).

Begin by reading docs/testing/releases/v1.9.0/smoke-test.md, then execute and record.
```

---

## Fill-in record (what was substituted)

| Placeholder | Value used |
|-------------|-----------|
| `{VERSION}` | `1.9.0` |
| `{SPRINT / theme}` | Sprint 39 — Integrated Aruḍam "Why?" provenance accordion |
| Environment | release PR's Vercel **preview** (`{PREVIEW_URL}` — fill from the `vercel[bot]` comment) |
| Smoke-test file | `docs/testing/releases/v1.9.0/smoke-test.md` (new folder convention) |
| What changed | from the `[1.9.0-web]` CHANGELOG entry + Sprint 39 scope |
| Highest-priority | collapse-by-default, doctrinal copy (dampened-not-blocked / rest), grouping (Moment/You vs Blocked vs stale-omit), no raw math, Tamil, collapsed-card regression — **no migration path this release** |
