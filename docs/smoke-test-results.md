[← Back to Root](../README.md)

# Saranidhi — Smoke Test Results (Release History)

## Overview

Each production release requires a passing smoke test before tagging. Results are recorded per-version for traceability and regression comparison.

---

## Release History

| Version | Date | Tester | Scenarios | Verdict | Results File |
|---------|------|--------|-----------|---------|--------------|
| v1.0.0-web | 2026-07-02 | Eialarasu | 42 (Sections A-E) | ✅ PASS | [v1.0.0](smoke-test-results-v1.0.0.md) |
| v1.2.0-web | Pending | Eialarasu | 52 (Sections A-I) | ⬜ Pending | [v1.2.0](smoke-test-results-v1.2.0.md) |

---

## Process

1. Sprint merged to `main` → staging auto-deploys
2. Tester executes smoke test on staging using `docs/manual-smoke-test.md`
3. Results recorded in `docs/smoke-test-results-v{X.Y.Z}.md`
4. ALL sections must pass → tag release version
5. Any failures → hotfix PR → re-test failed scenarios → update results

---

## Production Gate Checklist

Before tagging a release:

- [ ] All smoke test sections pass
- [ ] CI pipeline passes (analyze + test + build)
- [ ] No open critical/blocker issues
- [ ] Owner sign-off

---

[← Back to Root](../README.md)
