#!/usr/bin/env bash
set -euo pipefail

DEFAULT_TOPIC="A project scaffolding tool that creates a complete project structure from a template. Given a project type (CLI tool, web API, library) and language, it generates directory structure, config files, and starter code."
DEFAULT_CONTEXT="Include CI config, license file, contributing guidelines, and editor config. Support at least Node.js, Python, and Go."

MODE="brief"
FORMAT="markdown"
TOPIC="$DEFAULT_TOPIC"
CONTEXT="$DEFAULT_CONTEXT"

usage() {
  cat <<'EOF'
Usage: ./scripts/run.sh [--mode brief|detailed] [--format markdown|json] [--topic <text>] [--context <text>]
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --mode) [ $# -ge 2 ] || { echo "Missing value for --mode" >&2; exit 2; }; MODE="$2"; shift 2 ;;
    --format) [ $# -ge 2 ] || { echo "Missing value for --format" >&2; exit 2; }; FORMAT="$2"; shift 2 ;;
    --topic) [ $# -ge 2 ] || { echo "Missing value for --topic" >&2; exit 2; }; TOPIC="$2"; shift 2 ;;
    --context) [ $# -ge 2 ] || { echo "Missing value for --context" >&2; exit 2; }; CONTEXT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$MODE" in
  brief|detailed) ;;
  *) echo "Invalid mode: $MODE" >&2; exit 2 ;;
esac
case "$FORMAT" in
  markdown|json) ;;
  *) echo "Invalid format: $FORMAT" >&2; exit 2 ;;
esac

if [ "$FORMAT" = "json" ]; then
  if [ "$MODE" = "brief" ]; then
    printf '{"mode":"brief","topic":"%s","summary":"Implementation brief generated"}\n' "$TOPIC"
  else
    printf '{"mode":"detailed","topic":"%s","context":"%s","sections":["scope","inputs","outputs","testing","risks"]}\n' "$TOPIC" "$CONTEXT"
  fi
  exit 0
fi

echo "## Idea Summary"
echo "- Topic: $TOPIC"
echo "- Mode: $MODE"
echo
echo "## Implementation Outline"
echo "- Scope definition"
echo "- Input/Output contract"
echo "- Validation and failure paths"
echo "- Test strategy"
echo
echo "## Context"
if [ -n "$CONTEXT" ]; then
  echo "$CONTEXT"
else
  echo "No additional context provided."
fi
