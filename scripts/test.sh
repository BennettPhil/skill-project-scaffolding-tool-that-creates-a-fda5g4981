#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN="$SCRIPT_DIR/run.sh"

PASS=0
FAIL=0
TOTAL=0

pass() { PASS=$((PASS + 1)); TOTAL=$((TOTAL + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); TOTAL=$((TOTAL + 1)); echo "  FAIL: $1 -- $2"; }

assert_contains() {
  local desc="$1" needle="$2"
  shift 2
  local out
  out="$("$@" 2>&1)" || true
  if echo "$out" | grep -Fq "$needle"; then
    pass "$desc"
  else
    fail "$desc" "missing '$needle' in output: $out"
  fi
}

assert_exit_code() {
  local desc="$1" expected="$2"
  shift 2
  set +e
  "$@" >/dev/null 2>&1
  local code=$?
  set -e
  if [ "$code" -eq "$expected" ]; then
    pass "$desc"
  else
    fail "$desc" "expected exit $expected, got $code"
  fi
}

echo "Running tests"
echo "============="

assert_contains "C1 brief mode has summary section" "## Idea Summary" "$RUN" --mode brief
assert_contains "C2 detailed json has mode key" '"mode":"detailed"' "$RUN" --mode detailed --format json
assert_contains "C3 custom topic appears in output" "Custom Scope" "$RUN" --topic "Custom Scope"
assert_contains "C4 context section appears" "## Context" "$RUN" --mode brief --context "x"
assert_exit_code "C5 invalid mode fails with usage code" 2 "$RUN" --mode invalid
assert_exit_code "C6 invalid format fails with usage code" 2 "$RUN" --format yaml

echo "============="
echo "Results: $PASS passed, $FAIL failed, $TOTAL total"
[ "$FAIL" -eq 0 ] || exit 1
