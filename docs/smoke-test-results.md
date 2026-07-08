[← Back to Root](../README.md)

# Saranidhi — Smoke Test History

Each production release has a single smoke test file containing both the plan (scenarios + expected outcomes) and the execution results.

## Release History

| Version | Date | Tester | Scenarios | Verdict | File |
|---------|------|--------|-----------|---------|------|
| v1.0.0-web | 2026-07-02 | Eialarasu | 42 | ✅ PASS | [v1.0.0](smoke-test-v1.0.0.md) |
| v1.2.0-web | Pending | Eialarasu | 62 | ⬜ Pending | [v1.2.0](smoke-test-v1.2.0.md) |

## Process

1. Sprint merged → staging auto-deploys
2. Open `docs/smoke-test-v{X.Y.Z}.md` — scenarios + results in one file
3. Execute on staging, fill in Pass?/Notes columns
4. ALL sections pass → tag release → production
5. Any failures → hotfix → re-test failed scenarios

---

[← Back to Root](../README.md)
