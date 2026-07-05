---
inclusion: auto
---

# Saranidhi — Steering Rules & Guardrails

> This file auto-loads into every Kiro session. It contains ONLY rules,
> constraints, and conventions that must be followed at all times.
> For architecture details, see `.kiro/design.md`.
> For product requirements, see `.kiro/product.md`.
> For file structure, see `.kiro/structure.md`.

---

## 1. Strict Exclusions (NEVER do these)

- No server-side database (no Supabase, no Firebase Firestore, no custom backend)
- No third-party analytics that leak user data
- No social features or user-to-user interaction
- No developer-owned cloud storage of user data
- No usage of `dynamic` type except where framework-mandated
- No `IntrinsicHeight` widget (causes layout issues)
- No `git push --force` to main/prod branches
- No modifications to files outside assigned scope (e.g., Jules only touches `test/`)

## 2. Architecture Constraints

- **Local-first, zero-backend** — all data on-device or user's own cloud
- **Privacy guarantee** — user data never touches developer infrastructure
- **Offline-capable** — all Vedic calculations are pure Dart, zero network dependency
- **Cloud backup** — ONLY to user's OWN iCloud/Google Drive account

## 3. Code Conventions

- **Linting:** `very_good_analysis` — zero issues on `flutter analyze --fatal-infos`
- **Import ordering:** dart → third-party packages → blank line → own-package (`package:saranidhi/`)
- **State management:** Riverpod 3 (`NotifierProvider`, `FutureProvider`) — no `StateProvider` (deprecated)
- **Models:** Freezed + json_serializable for entities
- **Local variables:** Use `var` (not `final`) only when value changes; prefer `final`
- **Responsive layout:** Two-column on medium+ devices (>=600px), single-column on narrow
- **Feature structure:** `lib/features/<name>/domain/`, `data/`, `presentation/`, `providers/`
- **Generated files:** `*.g.dart`, `*.freezed.dart` excluded from git (CI runs `build_runner`)
- **Localization:** `lib/l10n/generated/` committed; `flutter: generate: true` in pubspec

## 4. CI Quality Gates

- `flutter analyze --fatal-infos` — zero issues (errors, warnings, AND infos)
- **Tier 1 (PRs):** `flutter test test/features/{domain dirs}` — domain + provider tests pass
- **Tier 2 (merge):** `flutter test --coverage` — ALL tests pass + ≥ 20% coverage
- `flutter build web` — must compile
- Integration tests via headless Chrome

## 5. Sprint Protocols

- `/start-sprint` — branch from main, update tracker to "Current Sprint"
- `/finish-sprint` — push, create PR, update tracker to "Complete (PR #N)", verify CI, merge
- `/project-update` — runs AFTER merge on separate `docs/` branch (valuation, evaluation, plan, testing-plan)
- Valuation hours: AI-estimated time + 20% buffer

## 6. Deployment

| Environment | Branch | URL |
|-------------|--------|-----|
| Production | `prod` | saranidhi.vercel.app |
| Staging | `main` | saranidhi-staging.vercel.app |
| Preview | PR branches | Auto-generated Vercel URL |

## 7. Platform Notes

- **iOS/macOS:** CloudKit sync via MethodChannel (native Swift plugins)
- **Web:** Drift uses WebAssembly SQLite (`sqlite3.wasm` + `drift_worker.js`)
- **Notifications:** `flutter_local_notifications` — iOS/macOS/Android only, web is no-op
- **File sharing:** `share_plus` — cross-platform share sheet for data export
- **File picking:** `file_picker` — JSON file selection for data import
- **iCloud entitlements:** Already committed; requires Apple Developer account to activate
- **Nakshatra calculation:** Pure Dart Jean Meeus ELP 2000/82 (Moon longitude) + Lahiri Ayanamsa — zero network dependency
- **OnboardingGuard:** Wraps OnboardingScreen in `Navigator` widget for web picker dialog support (MaterialApp.builder renders above GoRouter)
- **Onboarding flow:** 4 steps — Welcome → Find Your Bird (dual-path: know nakshatra / calculate from DOB) → Your Location → Data Storage
- **Preset cities:** Indian only (Chennai, Mumbai, Delhi, Bangalore, Hyderabad, Kolkata)
- **Pre-onboarding intro:** IntroScreen shown via OnboardingGuard before 4-step onboarding. Uses `introSeenProvider` (NotifierProvider) + Navigator ValueKeys for proper widget replacement.
- **About/User Guide:** About card uses `package_info_plus` for version, `url_launcher` for email/website/privacy links. Privacy Policy served as locale-aware static HTML (`privacy-en.html` / `privacy-ta.html`) via `Uri.base.origin`.

---
