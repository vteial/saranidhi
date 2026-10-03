# Local developer-experience commands for Saranidhi (PRJ-001).
#
#   just              # list all commands
#   just setup-local  # FIRST RUN: pub get + codegen, guide the toolchain
#   just env-doctor   # audit the machine (flutter doctor + toolchain + ports)
#   just validate-local  # the quality gates: analyze + test + build web
#   just start-local  # flutter run -d chrome
#   just stop-local   # free the dev-server port
#   just status-local # is the dev server up?
#   just status-staging  # probe the staging + prod Vercel URLs
#   just validate-docs   # docs freshness / link audit
#
# Family vocabulary shared across the owner's repos (cetana-labs). Same verbs
# everywhere; bodies are stack-specific. Saranidhi is LOCAL-FIRST — no backing
# services, so start-local just runs the Flutter web dev server.
# See docs/process/PROCESS_MIGRATION.md §5. REUSABLE: edit the variable block,
# copy this file + scripts/{setup-local,env-doctor,validate-local}.sh.

# Load .env so recipes see its values; don't fail if absent.
set dotenv-load := true
set dotenv-required := false

# ── repo-specific config (edit these per project) ────────────────────────────
flutter        := "flutter"
dart           := "dart"
web_port       := "8787"                       # local flutter-web dev-server port
pnpm_version   := "10.27.0"
node_min       := "22"
coverage_min   := "19"                          # ci-full.yml threshold (THRESHOLD=19)
staging_url    := "https://saranidhi-staging.vercel.app"
prod_url       := "https://saranidhi.vercel.app"
# ─────────────────────────────────────────────────────────────────────────────

# List all commands (default).
default:
    @just --list

# First-run onboarding: pub get + build_runner codegen, guide the toolchain, then env-doctor.
setup-local:
    @PNPM_VERSION="{{pnpm_version}}" NODE_MIN="{{node_min}}" FLUTTER="{{flutter}}" \
        bash scripts/setup-local.sh

# Audit the local machine: flutter doctor, toolchain, dev-server port free.
env-doctor:
    @WEB_PORT="{{web_port}}" PNPM_VERSION="{{pnpm_version}}" NODE_MIN="{{node_min}}" \
        FLUTTER="{{flutter}}" bash scripts/env-doctor.sh

# The quality gates (mirrors CI): analyze --fatal-infos + flutter test + build web.
# Local baseline = GREEN except the 4 known CloudKit macOS failures.
validate-local:
    @COVERAGE_MIN="{{coverage_min}}" FLUTTER="{{flutter}}" DART="{{dart}}" \
        bash scripts/validate-local.sh

# Run the Flutter web dev server (local-first; no backing services to start).
start-local:
    {{flutter}} run -d chrome --web-port {{web_port}}

# Stop the dev server: free the web port.
stop-local:
    @pid="$(lsof -tiTCP:{{web_port}} -sTCP:LISTEN 2>/dev/null || true)"; \
        if [ -n "$pid" ]; then kill "$pid" && echo "· stopped dev server on :{{web_port}} (pid $pid)"; \
        else echo "· nothing listening on :{{web_port}}"; fi

# Is the local dev server up?
status-local:
    @if lsof -iTCP:{{web_port}} -sTCP:LISTEN >/dev/null 2>&1; then \
        echo "● ONLINE  — flutter web dev server on http://localhost:{{web_port}}"; \
        else echo "○ OFFLINE — run: just start-local"; fi

# Probe the live Vercel staging + production edges (HTTP code + latency).
status-staging:
    @for u in "{{staging_url}}" "{{prod_url}}"; do \
        code="$(curl -s -o /dev/null -w '%{http_code}' -m 10 "$u" || echo 000)"; \
        t="$(curl -s -o /dev/null -w '%{time_total}s' -m 10 "$u" || echo -)"; \
        if [ "$code" = "200" ]; then echo "  ✅ $u → $code ($t)"; else echo "  ❌ $u → $code"; fi; \
        done

# Docs freshness / link audit (the docs-audit gate — placeholder until scripted).
validate-docs:
    @echo "docs audit: check every durable doc's '> Reviewed:' stamp vs current prod,"
    @echo "and that internal links resolve. (Scripted gate is a follow-up — tracked in BACKLOG.)"
    @grep -rL "> \*\*Reviewed:\*\*" docs --include="*.md" 2>/dev/null | sed 's/^/  · no Reviewed stamp: /' || true
