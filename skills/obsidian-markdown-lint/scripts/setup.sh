#!/usr/bin/env bash
# Set up markdownlint-cli2 in an Obsidian vault.
#
# What this does:
#   1. Detects node + npm; installs markdownlint-cli2 globally if missing.
#   2. Locates the actual binary (npm sometimes doesn't symlink to PATH on
#      Homebrew installs: falls back to direct node module path).
#   3. Drops in the prose-tuned .markdownlint-cli2.jsonc config at the vault
#      root (skips if one already exists).
#   4. Optionally runs `--fix` for the first-pass auto-clean.
#
# Run from the vault root.
# Usage: bash <skill-path>/scripts/setup.sh [--fix]

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_TEMPLATE="$SKILL_DIR/assets/markdownlint-cli2.jsonc"
VAULT_ROOT="$(pwd)"
CONFIG_DEST="$VAULT_ROOT/.markdownlint-cli2.jsonc"

log() { printf '[obsidian-markdown-lint] %s\n' "$*"; }
die() { log "error: $*" >&2; exit 1; }

# 1. Toolchain check
command -v node >/dev/null 2>&1 || die "node not found: install Node.js first (e.g., \`brew install node\`)"
command -v npm >/dev/null 2>&1  || die "npm not found: should ship with node"

# 2. Locate or install markdownlint-cli2
locate_binary() {
  if command -v markdownlint-cli2 >/dev/null 2>&1; then
    command -v markdownlint-cli2; return 0
  fi
  # npm-global module path fallback (the symlink to PATH sometimes goes missing)
  local npm_root; npm_root="$(npm root -g 2>/dev/null)"
  local mod_dir="$npm_root/markdownlint-cli2"
  if [[ -d "$mod_dir" ]]; then
    local bin="$mod_dir/markdownlint-cli2-bin.mjs"
    if [[ -f "$bin" ]]; then
      printf 'node %s' "$bin"; return 0
    fi
  fi
  return 1
}

if ! BINARY="$(locate_binary)"; then
  log "markdownlint-cli2 not found: installing globally"
  npm install -g markdownlint-cli2 >/dev/null
  BINARY="$(locate_binary)" || die "install succeeded but binary still not locatable"
fi
log "using: $BINARY"

# 3. Drop in config (don't overwrite existing)
if [[ -f "$CONFIG_DEST" ]]; then
  log "$CONFIG_DEST already exists: leaving as-is"
else
  cp "$CONFIG_TEMPLATE" "$CONFIG_DEST"
  log "wrote $CONFIG_DEST (review and tune globs/ignores per vault layout)"
fi

# 4. Optional first-fix pass
if [[ "${1:-}" == "--fix" ]]; then
  log "running first-pass --fix"
  $BINARY --fix || true
  log "remaining issues:"
  $BINARY 2>&1 | grep -oE 'MD[0-9]+/[a-z-]+' | sort | uniq -c | sort -rn || true
fi

log "done"
log "to lint manually:   $BINARY"
log "to auto-fix:        $BINARY --fix"
log "to fix dollar sigils: python3 $SKILL_DIR/scripts/fix_dollars.py --dir content"
log "to normalize HRs:    python3 $SKILL_DIR/scripts/normalize_hr.py --dir content"
