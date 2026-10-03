#!/usr/bin/env bash
#
# setup-local — FIRST-RUN onboarding for a fresh clone of Saranidhi.
#
# Conservative + idempotent: does the SAFE things automatically (pub get,
# build_runner codegen, .env bootstrap) and DETECTS-AND-GUIDES the heavy
# toolchain (Flutter SDK) rather than installing it. Safe to run repeatedly.
#
#   auto:  flutter pub get, build_runner codegen, bootstrap .env
#   guide: Flutter/Chrome missing → print the fix, don't run it
#   end:   hand off to env-doctor for the readiness report
#
# Reusable: values passed in by the justfile (PNPM_VERSION, NODE_MIN, FLUTTER).
set -uo pipefail

FLUTTER="${FLUTTER:-flutter}"
PNPM_VERSION="${PNPM_VERSION:-10.27.0}"
ENV_FILE="${ENV_FILE:-.env}"

step() { echo; echo "▶ $1"; }
ok()   { echo "  ✅ $1"; }
info() { echo "  ·  $1"; }
guide(){ echo "  👉 $1"; }

echo "setup-local — first-run onboarding (Saranidhi, conservative + idempotent)"

# ── .env bootstrap ───────────────────────────────────────────────────────────
step "Project env file"
if [ -f "$ENV_FILE" ]; then
  ok "$ENV_FILE already present"
elif [ -f .env.example ]; then
  cp .env.example "$ENV_FILE" && ok "created $ENV_FILE from .env.example"
else
  info "no .env.example — skipping (Saranidhi is local-first; .env holds only the Vercel bypass secret for QA-Verify)"
fi

# ── just (safe: brew formula) ────────────────────────────────────────────────
step "just (task runner)"
if command -v just >/dev/null 2>&1; then
  ok "just $(just --version | awk '{print $2}') already installed"
elif command -v brew >/dev/null 2>&1; then
  info "installing just via brew…"
  brew install just >/dev/null 2>&1 && ok "installed just" || guide "brew install just failed — https://just.systems"
else
  guide "install just: https://just.systems (or install Homebrew first)"
fi

# ── Flutter SDK: detect-and-guide (heavy — never auto-installed) ─────────────
step "Flutter SDK — detect & guide"
if command -v "$FLUTTER" >/dev/null 2>&1; then
  ok "flutter $("$FLUTTER" --version 2>/dev/null | head -1 | awk '{print $2}') installed"
else
  guide "Flutter not found. Install (this machine uses the Homebrew cask):  brew install --cask flutter"
  guide "then:  flutter doctor   (needs Chrome for web dev)"
  echo; info "cannot continue pub get / codegen without flutter — install it, then re-run."
  exit 0
fi

# ── dependencies (safe: local) ───────────────────────────────────────────────
step "Flutter dependencies (pub get)"
if "$FLUTTER" pub get >/dev/null 2>&1; then
  ok "pub get complete"
else
  guide "flutter pub get failed — run it manually to see the error"
fi

# ── generated code (freezed / json_serializable / drift / l10n) ──────────────
step "Code generation (build_runner)"
info "running build_runner (freezed, json_serializable, drift)…"
if "$FLUTTER" pub run build_runner build --delete-conflicting-outputs >/dev/null 2>&1; then
  ok "generated files built (*.g.dart / *.freezed.dart)"
else
  guide "build_runner failed — run: flutter pub run build_runner build --delete-conflicting-outputs"
fi

# ── final readiness report ───────────────────────────────────────────────────
step "Readiness check (env-doctor)"
if command -v just >/dev/null 2>&1; then
  echo; just env-doctor || true
else
  info "run 'just env-doctor' once just is on PATH"
fi

echo
echo "✔ setup-local done. Next:  just validate-local  →  just start-local"
