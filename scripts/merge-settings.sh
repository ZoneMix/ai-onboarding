#!/usr/bin/env bash
# merge-settings.sh: merge claude/settings.example.json into ~/.claude/settings.json.
# Writes the result to settings.json.merged next to the original and prints the diff.
# It never replaces the live file; move it into place yourself after reading the diff:
#   mv ~/.claude/settings.json.merged ~/.claude/settings.json
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIVE="${CLAUDE_SETTINGS:-$HOME/.claude/settings.json}"
OUT="${MERGE_OUT:-$LIVE.merged}"
EMPTY="$(mktemp)"
trap 'rm -f "$EMPTY"' EXIT
printf '{}\n' > "$EMPTY"

command -v jq >/dev/null || { echo "missing required tool: jq" >&2; exit 1; }
mkdir -p "$(dirname "$LIVE")"
current="$LIVE"
[ -f "$LIVE" ] || current="$EMPTY"

jq -s -f "$REPO/scripts/merge-settings.jq" "$current" "$REPO/claude/settings.example.json" > "$OUT"
chmod 600 "$OUT"

echo "Merged settings written to $OUT. Diff against the live file:"
diff -u "$current" "$OUT" || true  # diff exits 1 when the files differ; that is expected here
