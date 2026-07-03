[← Back to Root](../README.md)

# Saranidhi — Local Development Environment Setup (macOS)

---

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| macOS | 13+ (Ventura or later) | Host OS |
| Xcode | 15+ | iOS + macOS builds, CloudKit entitlements |
| Flutter SDK | Stable channel (≥3.44) | Framework |
| Dart SDK | ≥3.12.1 | Language (bundled with Flutter) |
| Git | 2.x | Version control |
| Homebrew | Latest | Package manager |
| Chrome | Latest | Web testing + DevTools |

---

## Step-by-Step Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Flutter SDK

```bash
brew install --cask flutter
```

Or download from [flutter.dev/get-started/install/macos](https://docs.flutter.dev/get-started/install/macos/desktop).

### 3. Verify Flutter Installation

```bash
flutter doctor -v
```

Expected output should show:
- Flutter channel: stable
- Dart SDK: ≥3.12.1
- Xcode: installed and configured
- Chrome: installed (for web builds)

Fix any issues `flutter doctor` reports before proceeding.

### 4. Install Xcode (from App Store)

```bash
# Accept license
sudo xcodebuild -license accept

# Install command-line tools
xcode-select --install
```

### 5. Clone the Repository

```bash
git clone https://github.com/vteial/saranidhi.git
cd saranidhi
```

### 6. Install Dependencies + Code Generation

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `*.g.dart` (Riverpod providers, Drift database)
- `*.freezed.dart` (immutable models)
- Drift query classes

### 7. Generate macOS Xcode Project (Sprint 16+)

```bash
flutter create --platforms=macos .
```

This creates `macos/Runner.xcodeproj/project.pbxproj` which is required for macOS builds but not committed to git (generated per-machine).

### 8. Configure CloudKit in Xcode (for iCloud Sync)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target → **Signing & Capabilities**
3. Set your **Team** (Apple Developer account)
4. Add **iCloud** capability (if not already present)
5. Check **CloudKit**
6. Select container: `iCloud.com.vteial.saranidhi`

Repeat for `macos/Runner.xcworkspace`:
1. Open in Xcode
2. Same steps: Team → iCloud → CloudKit → container

### 9. Install Lefthook (Pre-commit Hooks)

```bash
brew install lefthook
lefthook install
```

This enforces `dart format` + `dart analyze` before every commit.

### 10. Verify Everything Builds

```bash
# Code analysis (must pass with zero issues)
flutter analyze --fatal-infos

# Run all tests
flutter test

# Build web
flutter build web

# Build macOS app
flutter build macos

# Run on macOS (live)
flutter run -d macos
```

---

## Daily Development Commands

| Task | Command |
|------|---------|
| Run on web (Chrome) | `flutter run -d chrome` |
| Run on macOS | `flutter run -d macos` |
| Run on iOS Simulator | `flutter run -d iPhone` |
| Run on connected iPhone | `flutter run -d <device-id>` |
| List available devices | `flutter devices` |
| Regenerate code | `dart run build_runner build --delete-conflicting-outputs` |
| Watch mode (codegen) | `dart run build_runner watch --delete-conflicting-outputs` |
| Run specific test file | `flutter test test/features/astro_engine/pakshi_calculator_test.dart` |
| Run tests with coverage | `flutter test --coverage` |
| View coverage report | `genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html` |

---

## Project Structure

```
saranidhi/
├── lib/
│   ├── core/           # Shared utilities, theme, router, l10n
│   ├── database/       # Drift schema, providers
│   ├── features/       # Feature modules (astro_engine, breath_journal, etc.)
│   └── l10n/           # Generated localization files
├── test/               # Unit + widget tests
├── integration_test/   # E2E integration tests
├── ios/                # iOS platform (Runner, entitlements)
├── macos/              # macOS platform (Runner, CloudKit plugin)
├── android/            # Android platform
├── web/                # Web assets (wasm, workers)
├── docs/               # Project documentation
└── .kiro/              # Kiro steering files
```

---

## Branching & Workflow

| Action | Command |
|--------|---------|
| Start sprint work | `git checkout main && git pull && git checkout -b feature/sprint16-topic` |
| Daily sync from main | `git fetch origin main && git rebase origin/main` |
| Push branch | `git push origin feature/sprint16-topic` |
| Before PR | `flutter analyze && flutter test && flutter build web` |

See [docs/dev-workflow.md](dev-workflow.md) for full sprint protocols.

---

## CloudKit Testing (Sprint 16+)

After Xcode CloudKit setup:

1. Run app on macOS: `flutter run -d macos`
2. Go to Settings → Storage → select "iCloud"
3. Toggle "Primary device" ON
4. Tap "Sync Now"
5. Check [CloudKit Dashboard](https://icloud.developer.apple.com/) → Private DB

See [docs/icloud-sync-testing.md](icloud-sync-testing.md) for full multi-device testing scenarios.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `flutter doctor` shows Xcode issues | Run `sudo xcodebuild -license accept` and `xcode-select --install` |
| CocoaPods not found | `brew install cocoapods` then `cd ios && pod install` |
| Drift codegen fails | `dart run build_runner clean` then rebuild |
| macOS build fails "no project" | Run `flutter create --platforms=macos .` to generate pbxproj |
| CloudKit "not authenticated" | Ensure iCloud is signed in (System Settings → Apple ID → iCloud) |
| Tests fail with "Platform not supported" | CloudKit tests gracefully skip on non-Apple; run on macOS for full coverage |
| `flutter pub get` fails | Check `pubspec.yaml` SDK constraint matches your Flutter version |

---

## Apple Developer Account Requirements

For CloudKit sync (Sprint 16) and App Store submission (Sprint X):

| Item | Cost | Where |
|------|------|-------|
| Apple Developer Program | $99/year | [developer.apple.com](https://developer.apple.com) |
| CloudKit container | Free (included) | Created via Xcode capabilities |
| App Store distribution | Included in $99 | App Store Connect |

---

[← Back to Root](../README.md)
