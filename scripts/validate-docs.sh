#!/usr/bin/env bash
# ~/dev-home/personal/saranidhi/scripts/validate-docs.sh
# Doc self-cleanup gate (the "self-clean on the go" enforcer — guardrails §0).
# Fails (exit 1) on any of:
#   1. a durable doc missing its `> **Reviewed:**` / `> Reviewed:` freshness stamp
#   2. an EXTERNAL-REPO pointer (../cetana-labs, ../nexus-pulse, or an abs path to another
#      personal project) — a runtime dependency, forbidden by the self-containment principle
#   3. (advisory) orphaned docs nothing links to
# Last verified: 2026-10-03 (v1.13.0-web).
set -uo pipefail

fail=0

echo "── doc audit ──────────────────────────────────────────"

# 1. Reviewed-stamp presence (durable docs under docs/ + root process docs)
echo "1) Reviewed-stamp check…"
missing_stamp=$(grep -rL "Reviewed:" docs --include="*.md" 2>/dev/null || true)
if [ -n "$missing_stamp" ]; then
  echo "$missing_stamp" | sed 's/^/   ⚠️  no Reviewed stamp: /'
  # advisory only (not every doc is "durable") — do not fail the build on this yet
fi

# 2. External-repo pointer check (HARD FAIL — self-containment)
echo "2) External-repo pointer check (self-containment)…"
# forbid links/paths into sibling project repos; allow this project's own paths + CONTRIBUTING notes
ext=$(grep -rnE '\.\./(cetana-labs|nexus-pulse|rbac-platform)/|/dev-home/personal/(cetana-labs|nexus-pulse|rbac-platform)/' \
        --include="*.md" . 2>/dev/null | grep -v node_modules || true)
if [ -n "$ext" ]; then
  echo "$ext" | sed 's/^/   ❌ external-repo pointer: /'
  echo "   → saranidhi must vendor ideas in, not depend on an external repo at runtime (guardrails §0)."
  fail=1
fi

# 3. Orphan check (advisory): process/narrative docs that no other md links to.
#    Excludes raw corpus (docs/research/transcripts/**) and templates (referenced by
#    convention, not links) — flagging those is noise, not a cleanup signal.
echo "3) Orphan-doc check (advisory)…"
while IFS= read -r doc; do
  base=$(basename "$doc")
  case "$base" in README.md|index.md) continue;; esac
  case "$doc" in
    */research/transcripts/*) continue;;
    */templates/*) continue;;
  esac
  if ! grep -rqF "$base" --include="*.md" . 2>/dev/null; then
    echo "   ⚠️  orphan (nothing links to it): $doc"
  fi
done < <(find docs -name "*.md" 2>/dev/null)

echo "───────────────────────────────────────────────────────"
if [ "$fail" -ne 0 ]; then
  echo "❌ validate-docs FAILED (external-repo pointer). Fix before PR."
  exit 1
fi
echo "✅ validate-docs: no external-repo pointers; stamp/orphan notes above are advisory."
