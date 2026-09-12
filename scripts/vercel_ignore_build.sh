#!/usr/bin/env bash
#
# Vercel "Ignored Build Step" for Saranidhi.
#   exit 0  -> SKIP the build (no deploy, no build minutes)
#   exit 1  -> PROCEED with the build
#
# Rule: only build when the commit changed something that can affect the built
# web bundle. Docs-only / process / .kiro / config-meta changes are skipped.
#
# Fail-safe by design: this is an ALLOWLIST of app-affecting paths (build if any
# changed). Anything unknown/unanticipated falls through to BUILD (a wasted build
# at worst) — never to a silent SKIP of a real change (which would ship stale).
#
# Wired via vercel.json "ignoreCommand". Vercel runs this from the repo root with
# HEAD = the commit being considered for deploy.

set -euo pipefail

# Paths whose changes DO affect the built Flutter web app.
APP_PATHS=(
  lib/            # Dart source
  web/            # web entry, index.html, flutter_bootstrap, drift_worker.dart
  public/         # static assets bundled via pubspec (e.g. public/logo.svg)
  pubspec.yaml    # deps + asset declarations + version
  pubspec.lock    # resolved deps
  l10n.yaml       # localization codegen config
  build.yaml      # build_runner / codegen config
  analysis_options.yaml  # analyzer (can fail the build)
  vercel.json           # build/deploy config itself
  scripts/vercel_build.sh # the build script itself
)

# Compare the deploy commit against its parent. If any app path changed -> build.
if git diff --quiet "HEAD^" "HEAD" -- "${APP_PATHS[@]}" 2>/dev/null; then
  echo "🟡 Vercel: no app-affecting changes in this commit — SKIPPING build."
  exit 0
else
  echo "🟢 Vercel: app-affecting changes detected — proceeding with build."
  exit 1
fi
