[← Back to Root](../README.md)

> **Reviewed:** v1.13.0-web

# Saranidhi — Documentation Index

All project documentation, grouped by context. The AI team operating model lives in
[`dev-workflow.md`](process/dev-workflow.md) + [`collaboration-guardrails.md`](../.kiro/steering/collaboration-guardrails.md)
(saranidhi-only doctrine in [`doctrine-flows.md`](process/doctrine-flows.md)).

> **Live vs. historical — read the tree this way:** everything in `process/` · `product/` ·
> `reference/` · `testing/` · `deployment/` · `research/` and the root ledgers
> (`SPRINT_TRACKER.md` · `BACKLOG.md` · `CHANGELOG.md` · `STATUS.md`) is **LIVE** — kept current.
> `process/sprints/**` (completed sprint dossiers) and `testing/releases/**` (shipped release
> artifacts) are **frozen historical records** — audit integrity, do not edit; the live
> inventory of what shipped is in `SPRINT_TRACKER.md` + `CHANGELOG.md`.

---

## 🛠️ process/ — how we build & ship
| Doc | Purpose |
|-----|---------|
| [dev-workflow.md](process/dev-workflow.md) | Sprint/release protocols (`/plan-start` · `/plan-done` · `/sprint-*` · `/spec-run` · `/release-*`), branching, CI gates, lessons/gotchas |
| [doctrine-flows.md](process/doctrine-flows.md) | Saranidhi-only Knowledge Capture + CONF Resolution flows |
| [dev-setup.md](process/dev-setup.md) | Local development environment setup |
| [SPRINT_TRACKER.md](../SPRINT_TRACKER.md) | Completed + in-progress sprints, overview table, Definition of Done |
| [BACKLOG.md](../BACKLOG.md) | Candidate/future work, epics, open decisions, ideas |
| [project-valuation-report.md](process/project-valuation-report.md) | Time investment, sprint delivery, hours |
| [project-evaluation.md](process/project-evaluation.md) | Feature scorecard, quality metrics, defect log |

## 📦 product/ — what we're building
| Doc | Purpose |
|-----|---------|
| [product-scope.md](product/product-scope.md) | Functional product scope — features, principles, vision |
| [user-guide.md](product/user-guide.md) | In-app guide: what Saranidhi is, aim, features |

## 🧪 testing/ — test strategy & release verification
| Doc | Purpose |
|-----|---------|
| [testing-plan.md](testing/testing-plan.md) | Master test strategy, scenario backlog, test-count progression |
| [smoke-test-results.md](testing/smoke-test-results.md) | Release smoke-test index (links every version) |
| [releases/](testing/releases/) | Per-release dossiers — rich releases in `vX.Y.Z/` folders (smoke-test, release-notes, docs-audit); legacy v1.0.0–v1.6.0 as flat `smoke-test-v*.md` |

## 🚀 deployment/ — ops & release enablement
| Doc | Purpose |
|-----|---------|
| [deployment.md](deployment/deployment.md) | Prod/Staging/Preview architecture, rollback, monitoring |
| [mobile-release-guide.md](deployment/mobile-release-guide.md) | iOS/Android build & submission steps |
| [store-listing.md](deployment/store-listing.md) | App Store & Play Store listing text |
| [icloud-sync-testing.md](deployment/icloud-sync-testing.md) | Multi-device CloudKit sync verification |
| [offline-verification.md](deployment/offline-verification.md) | Offline capability matrix |
| [pocketbase-hosting.md](deployment/pocketbase-hosting.md) | PocketBase hosting runbook — host-agnostic (Fly.io / Railway), Practice Sync Phase 1 backend |

## 📚 reference/ — standing reference
| Doc | Purpose |
|-----|---------|
| [architecture.md](reference/architecture.md) | Technical architecture — engine algorithms, schema, platform, patterns |
| [security-review.md](reference/security-review.md) | Architecture security assessment, data protection |
| [third-party-comparison.md](reference/third-party-comparison.md) | Bird-state mapping vs Align27 / Tamil texts |
| [implementation-roadmap.md](reference/implementation-roadmap.md) | Forward-looking design roadmap — Chronobiology / Somatic / Oracle / numerology sequencing |

## 🔬 research/ — domain research & engine specs
Vedic/Sara Kalai methodology, engine specs, and terminology. See
[research/](research/) — calculation methodology, action windows, Prasanam
oracle, numerology, advanced somatic mastery, holistic living, and EN/TA
terminology. *(The forward-looking implementation roadmap moved to
[reference/implementation-roadmap.md](reference/implementation-roadmap.md).)*

---

[← Back to Root](../README.md)
