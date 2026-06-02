#!/bin/bash
set -e

echo "=== Installing Flutter SDK ==="
git clone https://github.com/flutter/flutter.git --depth 1 -b stable /tmp/flutter
export PATH="/tmp/flutter/bin:$PATH"

echo "=== Flutter Version ==="
flutter --version

echo "=== Installing Dependencies ==="
flutter pub get

echo "=== Running Code Generation ==="
dart run build_runner build --delete-conflicting-outputs

echo "=== Compiling Drift Worker ==="
dart compile js -o web/drift_worker.js web/drift_worker.dart

echo "=== Copying sqlite3.wasm ==="
cp .dart_tool/hooks_runner/shared/sqlite3/build/*/out/sqlite3.wasm web/sqlite3.wasm 2>/dev/null || true

echo "=== Building Flutter Web ==="
flutter build web --release

echo "=== Build Complete ==="
