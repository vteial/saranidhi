#!/usr/bin/env bash
#
# env-doctor — audit the LOCAL MACHINE for Saranidhi (PRJ-001) readiness.
#
# Answers "is my machine set up right?" BEFORE anything runs: Flutter toolchain
# present + healthy, pnpm/node (for the saranidhi-e2e sibling), dev-server port
# free. REPORTS and suggests fixes — it does not install anything.
#
# Exit: 0 if no ❌ failures, 1 otherwise (⚠️ warnings do not fail).
#
# Reusable: values are passed in by the justfile (WEB_PORT, PNPM_VERSION,
# NODE_MIN, FLUTTER). Sensible defaults if run directly.
set -uo pipefail

WEB_PORT="${WEB_PORT:-8787}"
PNPM_VERSION="${PNPM_VERSION:-10.27.0}"
NODE_MIN="${NODE_MIN:-22}"
FLUTTER="${FLUTTER:-flutter}"

pass=0; warn=0; fail=0
ok()  { echo "  ✅ $1"; pass=$((pass+1)); }
wrn() { echo "  ⚠️  $1"; warn=$((warn+1)); }
err() { echo "  ❌ $1"; fail=$((fail+1)); }

echo "env-doctor — auditing local environment (Saranidhi)"
echo

echo "Flutter toolchain:"
if command -v "$FLUTTER" >/dev/null 2>&1; then
  fv="$("$FLUTTER" --version 2>/dev/null | head -1 | awk '{print $2}')"
  ok "flutter ${fv:-present}"
  # flutter doctor: surface the top-level verdict without the full wall of text.
  if "$FLUTTER" doctor 2>/dev/null | grep -q "No issues found"; then
    ok "flutter doctor → No issues found"
  else
    wrn "flutter doctor reports issues — run 'flutter doctor' for detail (Chrome needed for web)"
  fi
else
  err "flutter not found — install the Flutter SDK (Homebrew cask on this machine)"
fi
command -v "${DART:-dart}" >/dev/null 2>&1 && ok "dart $(${DART:-dart} --version 2>&1 | awk '{print $4}')" || wrn "dart not on PATH (usually bundled with flutter)"

echo
echo "Web build prerequisites:"
if command -v google-chrome >/dev/null 2>&1 || command -v chromium >/dev/null 2>&1 || [ -d "/Applications/Google Chrome.app" ]; then
  ok "Chrome present (flutter -d chrome / integration tests)"
else
  wrn "Chrome not detected — 'flutter run -d chrome' and integration tests need it"
fi

echo
echo "Node / pnpm (for the saranidhi-e2e sibling repo):"
if command -v node >/dev/null 2>&1; then
  node_major="$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)"
  if [ "${node_major:-0}" -ge "$NODE_MIN" ]; then ok "node $(node -v) (>= $NODE_MIN)"; else wrn "node $(node -v) < $NODE_MIN"; fi
else
  wrn "node not found — only needed for the saranidhi-e2e Playwright repo"
fi
if command -v pnpm >/dev/null 2>&1; then
  pv="$(pnpm --version 2>/dev/null)"
  [ "$pv" = "$PNPM_VERSION" ] && ok "pnpm $pv (pinned)" || wrn "pnpm ${pv:-blank} (family pins $PNPM_VERSION)"
else
  wrn "pnpm not found — only needed for saranidhi-e2e"
fi
command -v just >/dev/null 2>&1 && ok "just $(just --version | awk '{print $2}')" || wrn "just not found — 'brew install just'"

echo
echo "Dev-server port:"
if lsof -iTCP:"$WEB_PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  wrn "port $WEB_PORT in use — 'just stop-local' or it'll clash with start-local"
else
  ok "port $WEB_PORT free"
fi

echo
echo "Summary: ${pass} ok · ${warn} warning(s) · ${fail} failure(s)"
[ "$fail" -eq 0 ] && { echo "✔ environment looks ready"; exit 0; } || { echo "✖ fix the ❌ items above"; exit 1; }
