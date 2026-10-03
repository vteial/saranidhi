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
# The 4 known CloudKit macOS failures are the ACCEPTED baseline (ICloudBackupRepository +
# CloudKitSyncService can't authenticate off an Apple platform). The gate must tell "4 known"
# apart from "4 known + a real regression": we assert the failing-test NAME SET is EXACTLY these.
KNOWN_CLOUDKIT_FAILURES='ICloudBackupRepository signIn returns false on non-Apple platform
ICloudBackupRepository isAuthenticated returns false on non-Apple platform
ICloudBackupRepository deleteBackup fails on non-Apple platform
ICloudBackupRepository isSupported is false on test platform'

# --machine emits one JSON object per line; collect the names of tests that errored/failed.
"$FLUTTER" test --coverage --machine >/tmp/sarani_test.json 2>/tmp/sarani_test.err
# testID→name from testStart events; failing testIDs from testDone events with result != success.
actual_failures="$(
  awk '
    /"type":"testStart"/ {
      id=""; name="";
      if (match($0, /"id":[0-9]+/))        { id=substr($0,RSTART+5,RLENGTH-5) }
      if (match($0, /"name":"[^"]*"/))     { name=substr($0,RSTART+8,RLENGTH-9) }
      if (id!="") names[id]=name
    }
    /"type":"testDone"/ {
      id=""; res="";
      if (match($0, /"testID":[0-9]+/))        { id=substr($0,RSTART+9,RLENGTH-9) }
      if (match($0, /"result":"[^"]*"/))       { res=substr($0,RSTART+10,RLENGTH-11) }
      if (id!="" && res!="success" && res!="") print names[id]
    }
  ' /tmp/sarani_test.json | sort -u
)"
known_sorted="$(printf '%s\n' "$KNOWN_CLOUDKIT_FAILURES" | sort -u)"

if [ -z "$actual_failures" ]; then
  ok "tests green (0 failures)"
elif [ "$actual_failures" = "$known_sorted" ]; then
  ok "tests green except the 4 known CloudKit macOS failures (exact baseline — accepted)"
else
  bad "test failures differ from the accepted 4-CloudKit baseline — REGRESSION:"
  # Show what's unexpected (present in actual, not in known) and any missing-known drift.
  comm -23 <(printf '%s\n' "$actual_failures") <(printf '%s\n' "$known_sorted") \
    | sed 's/^/      + unexpected failure: /'
  comm -13 <(printf '%s\n' "$actual_failures") <(printf '%s\n' "$known_sorted") \
    | sed 's/^/      - known-baseline test no longer failing (update the list?): /'
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
