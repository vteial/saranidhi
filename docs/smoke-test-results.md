[← Back to Root](../README.md)

# Saranidhi — Smoke Test History

Each production release has a single smoke test file containing both the plan (scenarios + expected outcomes) and the execution results.

## Release History

| Version | Date | Tester | Scenarios | Verdict | File |
|---------|------|--------|-----------|---------|------|
| v1.0.0-web | 2026-07-02 | Eialarasu | 42 | ✅ PASS | [v1.0.0](smoke-test-v1.0.0.md) |
| v1.2.0-web | 2026-07-08 | Eialarasu | 62 | ✅ PASS | [v1.2.0](smoke-test-v1.2.0.md) |
| v1.2.1-web | 2026-07-10 | Eialarasu | 30 | ✅ PASS (1 accepted) | [v1.2.1](smoke-test-v1.2.1.md) |
| v1.2.2-web | 2026-07-11 | Eialarasu | 23 | ✅ PASS | [v1.2.2](smoke-test-v1.2.2.md) |
| v1.3.0-web | 2026-07-12 | Eialarasu + Kiro | 25 | ✅ PASS (1 accepted) | [v1.3.0](smoke-test-v1.3.0.md) |
| v1.4.0-web | 2026-07-16 | Eialarasu + Kiro | 41 | ✅ PASS (3 accepted) | [v1.4.0](smoke-test-v1.4.0.md) |
| v1.4.1-web | 2026-08-27 | Eialarasu + Kiro | 21 | ✅ PASS | [v1.4.1](smoke-test-v1.4.1.md) |

## Process

1. Sprint merged → staging auto-deploys
2. Open `docs/smoke-test-v{X.Y.Z}.md` — scenarios + results in one file
3. Execute on staging, fill in Pass?/Notes columns
4. ALL sections pass → tag release → production
5. Any failures → hotfix → re-test failed scenarios

---

[← Back to Root](../README.md)
