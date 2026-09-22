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

echo "=== Compiling Drift Worker for Web ==="
dart compile js -o web/drift_worker.js web/drift_worker.dart

echo "=== Building Flutter Web ==="
# Practice Sync (Sprint 47, v1.13.0+): default PocketBase backend URL baked into the build.
# Public API base (not a secret — auth is per-user email/passphrase). Users can override it in
# Settings → Sync. Prefer the Vercel env var POCKETBASE_URL if set, else the Fly default.
POCKETBASE_URL="${POCKETBASE_URL:-https://saranidhi-pb.fly.dev}"
echo "Using POCKETBASE_URL=$POCKETBASE_URL"
flutter build web --release --dart-define=POCKETBASE_URL="$POCKETBASE_URL"

echo "=== Build Complete ==="
