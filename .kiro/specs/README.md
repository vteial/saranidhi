<!--
  Canonical path: ~/dev-home/personal/saranidhi/.kiro/specs/README.md
  Last verified: 2026-10-03 (v1.13.0-web).
-->
# Kiro Specs — Saranidhi (`PRJ-001`)

A **Kiro Spec** is the first-class contract that drives correctness-critical work. One Spec
per feature, living at `.kiro/specs/<spec-id>/`:

| File | Owner | Purpose |
| :--- | :--- | :--- |
| `requirements.md` | Operator (Kiro) | EARS acceptance criteria = **Definition of Done**, incl. the standing **RT** (Tamil), **RC** (CONF), **RQ** (gates) criteria. |
| `design.md` | Operator (Kiro) | the HOW — patterns, data/migration, calc + CONF, l10n. |
| `tasks.md` | Operator (Kiro) | the ordered `/spec-run` build plan with an Execution header. |
| `REPORT.md` | Executor (Antigravity) | created at `/verification-done`; the human Verification Log (append-only). |

## Lifecycle (merge-first)
```
/plan-start → /plan-done        /spec-run <id>        /verification-done   /review-pr <PR>   /sprint-done
  (Operator — author +            (Executor —           (Executor —          (Operator gate;   (Record)
   MERGE the Spec to main)         build, open PR,       record human         owner MERGES)
                                   STOP)                 verify, STOP)
```
**Merge-first:** the Spec is merged to `main` during `/plan-done`, so `/spec-run <id>` needs
only the id — Antigravity syncs `main`, finds the Spec, cuts its own `sprint/<id>` branch.

## Convention
- **New feature:** `cp -r _template <spec-id>/` then fill all three files. `<spec-id>` is
  kebab-case and equals the directory name.
- The `_template/` folder is the canonical starting point — it bakes in the standing
  **RT / RC / RQ** EARS criteria so no Spec can silently drop the Tamil gate, CONF provenance,
  or the quality gates.
- Specs are the **contract**; the `docs/process/sprints/sprint-N-*/` dossier remains the
  human-readable **audit trail**. Do not duplicate — Spec drives, dossier records.
