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

echo "=== Building Flutter Web ==="
flutter build web --release

echo "=== Build Complete ==="
