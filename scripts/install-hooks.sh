#!/usr/bin/env bash
# install-hooks.sh: run the hook tests, then copy the hooks to ~/.local/bin as claude-<name>.
# --test-only runs the tests and installs nothing. Existing hooks are backed up first.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO/claude/hooks"
DEST="${HOOK_DEST:-$HOME/.local/bin}"
HOOKS=(no-heredoc guard-bash guard-secrets)

for tool in python3 jq git; do
  command -v "$tool" >/dev/null || { echo "missing required tool: $tool" >&2; exit 1; }
done

echo "Running hook tests..."
bash "$SRC/test-hooks.sh"

if [ "${1:-}" = "--test-only" ]; then
  exit 0
fi

mkdir -p "$DEST"
stamp="$(date +%Y%m%d-%H%M%S)"
for name in "${HOOKS[@]}"; do
  target="$DEST/claude-$name"
  if [ -e "$target" ] && ! cmp -s "$SRC/$name.py" "$target"; then
    cp "$target" "$target.bak-$stamp"
    echo "backed up $target to $target.bak-$stamp"
  fi
  install -m 0755 "$SRC/$name.py" "$target"
  echo "installed $target"
done

echo "Hooks installed. Next: scripts/merge-settings.sh to wire them into Claude Code."
