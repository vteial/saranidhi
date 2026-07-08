# Contributing to Saranidhi

Thank you for your interest in contributing to Saranidhi!

---

## Development Setup

See [docs/dev-setup.md](docs/dev-setup.md) for full environment setup instructions (macOS).

**Quick start:**
```bash
git clone https://github.com/vteial/saranidhi.git
cd saranidhi
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Branch Strategy

| Type | Pattern | Example |
|------|---------|---------|
| Sprint feature | `feature/sprintX-topic` | `feature/sprint20-ui-polish` |
| Bug fix | `fix/sprintX-topic` | `fix/sprint14-overflow` |
| Documentation | `docs/topic` | `docs/sprint19-update` |
| Test coverage | `test/topic` | `test/widget-coverage` |

**Rules:**
- Always branch from `main`
- Never push directly to `main` or `prod`
- One PR per sprint (or logical unit of work)

---

## Code Standards

- **Linting:** `very_good_analysis` — zero issues on `flutter analyze --fatal-infos`
- **Formatting:** `dart format .` (enforced by lefthook pre-commit)
- **Imports:** dart → third-party → blank line → own-package (`package:saranidhi/`)
- **No `dynamic`** except where framework-mandated
- **Feature structure:** `lib/features/<name>/domain/`, `data/`, `presentation/`, `providers/`

---

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(scope): <short description>
```

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Maintenance, config |
| `refactor` | Code restructuring |
| `test` | Adding/updating tests |
| `docs` | Documentation only |
| `ci` | CI/CD changes |

---

## Pull Request Process

1. Ensure `flutter analyze --fatal-infos` passes (zero issues)
2. Ensure `flutter test` passes (all green)
3. Ensure `flutter build web` compiles
4. Update `docs/sprint-tracker.md` if completing a sprint task
5. PR description should include: what changed, how to verify, any blockers
6. Wait for CI to pass + Vercel preview to deploy
7. Verify visually on Vercel preview URL before requesting merge

---

## Testing

- **Domain logic:** Unit tests required for all calculators and pure functions
- **Widget tests:** Encouraged for new presentation widgets
- **Integration tests:** For critical user flows (onboarding, breath entry)
- **Coverage threshold:** ≥ 20% (enforced by CI)

Run tests:
```bash
flutter test                          # All tests
flutter test test/features/astro_engine/  # Specific directory
flutter test --coverage               # With coverage report
```

---

## Architecture

See [`.kiro/design.md`](.kiro/design.md) for full architecture documentation.

Key principles:
- **Local-first, zero-backend** — no user data on developer servers
- **Pure Dart domain layer** — all Vedic calculations offline, testable
- **Feature-first structure** — each feature is self-contained
- **Responsive** — two-column ≥600px, single-column on mobile

---

## Kiro AI Integration

This project uses [Kiro](https://kiro.dev) for AI-assisted development:

- **`.kiro/steering/saranidhi-spec.md`** — Auto-loaded rules for every session
- **`.kiro/product.md`** — Product requirements
- **`.kiro/design.md`** — Technical design
- **`.kiro/structure.md`** — File structure map

---

## Questions?

Open an issue or reach out to the maintainer (@vteial).
