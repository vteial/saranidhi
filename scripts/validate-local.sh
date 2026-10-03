#!/usr/bin/env bash
#
# validate-local — the pre-PR QUALITY GATES for Saranidhi, mirroring CI.
#
# Answers "would this pass CI?" BEFORE opening the PR. Runs the same gates as
# ci.yml + ci-full.yml:
#   1. dart analyze --fatal-infos   (zero issues)
#   2. flutter test --coverage      (all green; local baseline = green except
#                                    the 4 known CloudKit macOS failures)
#   3. coverage >= COVERAGE_MIN     (ci-full.yml threshold)
#   4. flutter build web            (compiles)
#
# This is the Executor's gate: /spec-run runs it GREEN before the PR (v1.2.1
# lesson — CI-only is not sufficient). Exit 0 only if all gates pass.
set -uo pipefail

FLUTTER="${FLUTTER:-flutter}"
DART="${DART:-dart}"
COVERAGE_MIN="${COVERAGE_MIN:-19}"

fail=0
ok()  { echo "  ✅ $1"; }
bad() { echo "  ❌ $1"; fail=$((fail+1)); }

echo "validate-local — pre-PR quality gates (mirrors CI)"
echo

echo "Gate 1 — dart analyze --fatal-infos:"
if "$DART" analyze --fatal-infos >/tmp/sarani_analyze.log 2>&1; then
  ok "analyze clean (zero issues)"
else
  bad "analyze found issues:"; sed 's/^/      /' /tmp/sarani_analyze.log | tail -20
fi

echo
echo "Gate 2+3 — flutter test --coverage (>= ${COVERAGE_MIN}%):"
if "$FLUTTER" test --coverage >/tmp/sarani_test.log 2>&1; then
  ok "tests green"
else
  # The 4 known CloudKit macOS failures are the accepted baseline; surface the tail.
  bad "flutter test not fully green (expected baseline = green except 4 CloudKit macOS):"
  grep -E "Some tests failed|[0-9]+ (passed|failed)" /tmp/sarani_test.log | tail -5 | sed 's/^/      /'
fi
if [ -f coverage/lcov.info ]; then
  # LF = lines found, LH = lines hit; coverage = 100*LH/LF.
  cov="$(awk -F: '/^LF:/{f+=$2} /^LH:/{h+=$2} END{ if (f>0) printf "%.1f", 100*h/f; else print "0" }' coverage/lcov.info)"
  if awk "BEGIN{exit !($cov >= $COVERAGE_MIN)}"; then ok "coverage ${cov}% (>= ${COVERAGE_MIN}%)"; else bad "coverage ${cov}% < ${COVERAGE_MIN}%"; fi
else
  echo "  ·  no coverage/lcov.info (test gate may have aborted early)"
fi

echo
echo "Gate 4 — flutter build web:"
if "$FLUTTER" build web >/tmp/sarani_build.log 2>&1; then
  ok "web build compiles"
else
  bad "flutter build web failed:"; tail -15 /tmp/sarani_build.log | sed 's/^/      /'
fi

echo
[ "$fail" -eq 0 ] && { echo "✔ all gates green — safe to open the PR"; exit 0; } || { echo "✖ $fail gate(s) failed — fix before the PR (CI-only is NOT sufficient)"; exit 1; }
