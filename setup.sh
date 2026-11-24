#!/usr/bin/env bash
# setup.sh: explore ai-onboarding and import all of it, or only the parts you pick.
# Run with no arguments for the menu. Agents and scripts use the flags (see --help).
# Every change keeps a timestamped backup of the file it replaces. Bash 3.2 compatible.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
HOOK_DEST="${HOOK_DEST:-$HOME/.local/bin}"
STAMP="$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
ASSUME_YES=0
PROJECT_DIR=""
VAULT_DIR=""
SELECTED=""

# shellcheck source=scripts/lib/ui.sh
. "$REPO/scripts/lib/ui.sh"
# shellcheck source=scripts/lib/components.sh
. "$REPO/scripts/lib/components.sh"

usage() {
  cat "$REPO/scripts/lib/usage.txt"
}

is_selected() { case " $SELECTED " in *" $1 "*) return 0 ;; *) return 1 ;; esac; }
is_component() { case " $COMPONENT_IDS " in *" $1 "*) return 0 ;; *) return 1 ;; esac; }

toggle() {
  if is_selected "$1"; then
    # shellcheck disable=SC2086  # word splitting of the selection is intended
    SELECTED="$(printf '%s\n' $SELECTED | grep -vx "$1" | tr '\n' ' ' || true)"
  else
    SELECTED="$SELECTED $1"
  fi
}

is_number() { case "$1" in ''|*[!0-9]*) return 1 ;; *) return 0 ;; esac; }

id_at() {  # id_at N: the component id shown as number N in the menu
  is_number "$1" || return 1
  # shellcheck disable=SC2086  # word splitting of the id list is intended
  printf '%s\n' $COMPONENT_IDS | sed -n "${1}p"
}

list_components() {  # list_components [plain]: with "plain", no selection boxes
  local n=0 id mark=""
  for id in $COMPONENT_IDS; do
    n=$((n + 1))
    if [ "${1:-}" != plain ]; then
      mark="[ ] "
      is_selected "$id" && mark="[x] "
    fi
    printf '  %d. %s%-24s %s\n' "$n" "$mark" "$(component_title "$id")" "$(component_desc "$id")"
  done
}

explore() {  # explore ID: describe a component and offer to read its files
  local id="$1" files f n pick
  step "$(component_title "$id")"
  say "$(component_desc "$id")"
  files="$(component_files "$id")"
  n=0
  for f in $files; do n=$((n + 1)); printf '  %d. %s\n' "$n" "${f#"$REPO"/}"; done
  [ -t 0 ] || return 0
  while true; do
    printf 'Number to read a file, Enter to go back: '
    read -r pick || return 0
    [ -z "$pick" ] && return 0
    f=""
    # shellcheck disable=SC2086  # word splitting of the file list is intended
    is_number "$pick" && f="$(printf '%s\n' $files | sed -n "${pick}p")"
    if [ -n "$f" ]; then view_file "$f"; else say "No file $pick."; fi
  done
}

explore_menu() {
  local pick id
  while true; do
    step "Explore"
    list_components plain
    printf 'Number to explore, Enter to go back: '
    read -r pick || return 0
    [ -z "$pick" ] && return 0
    id="$(id_at "$pick" 2>/dev/null || true)"
    if [ -n "$id" ]; then explore "$id"; else say "No item $pick."; fi
  done
}

pick_menu() {
  local cmd id
  while true; do
    step "Pick what to import"
    list_components
    say ""
    say "Type a number to select or clear it, a = all, n = none, e N = explore N,"
    say "i = import the selected items, b = back."
    printf '> '
    read -r cmd || return 1
    case "$cmd" in
      a) SELECTED="$EVERYTHING_IDS" ;;
      n) SELECTED="" ;;
      b) return 1 ;;
      i) [ -n "${SELECTED// /}" ] && return 0; say "Nothing selected yet." ;;
      e\ *) id="$(id_at "${cmd#e }" 2>/dev/null || true)"; [ -n "$id" ] && explore "$id" ;;
      *) id="$(id_at "$cmd" 2>/dev/null || true)"
         if [ -n "$id" ]; then toggle "$id"; else say "Not an option: $cmd"; fi ;;
    esac
  done
}

main_menu() {
  local pick
  say "ai-onboarding: an AI coding setup you can take all of, or just the parts you like."
  say "Nothing changes without a backup of what it replaces."
  while true; do
    step "What would you like to do?"
    say "  1. Import everything (rules, hooks, settings, skills, Obsidian)"
    say "  2. Pick and choose"
    say "  3. Explore what's here first"
    say "  4. Set up a project folder (AGENTS.md and CLAUDE.md)"
    say "  q. Quit"
    printf '> '
    read -r pick || exit 0
    case "$pick" in
      1) SELECTED="$EVERYTHING_IDS"; return 0 ;;
      2) pick_menu && return 0 ;;
      3) explore_menu ;;
      4) SELECTED="project"; return 0 ;;
      q|Q) exit 0 ;;
      *) say "Not an option: $pick" ;;
    esac
  done
}

parse_args() {
  local id
  while [ $# -gt 0 ]; do
    case "$1" in
      --all) SELECTED="$EVERYTHING_IDS" ;;
      --only) shift; for id in $(printf '%s' "${1:-}" | tr ',' ' '); do
                is_component "$id" || { warn "unknown item: $id"; exit 2; }
                SELECTED="$SELECTED $id"; done ;;
      --vault) shift; VAULT_DIR="${1:-}"; is_selected obsidian || SELECTED="$SELECTED obsidian" ;;
      --project) shift; PROJECT_DIR="${1:-}"; is_selected project || SELECTED="$SELECTED project" ;;
      --list) list_components plain; exit 0 ;;
      --explore) shift; is_component "${1:-}" || { warn "unknown item: ${1:-}"; exit 2; }; explore "$1"; exit 0 ;;
      --dry-run) DRY_RUN=1 ;;
      --yes|-y) ASSUME_YES=1 ;;
      -h|--help) usage; exit 0 ;;
      *) warn "unknown option: $1"; usage >&2; exit 2 ;;
    esac
    shift
  done
}

run_selected() {
  local id failed=""
  if is_selected rules && is_selected instructions; then
    warn "Rules and Instructions overlap; the condensed CLAUDE.md repeats the rules. Both will be installed."
  fi
  [ "$DRY_RUN" = 1 ] && say "Dry run: showing what would change, changing nothing."
  for id in $COMPONENT_IDS; do  # fixed order: hooks are installed before settings that wire them
    is_selected "$id" || continue
    step "$(component_title "$id")"
    "install_$id" || failed="$failed $id"
  done
  step "Done"
  if [ -n "$failed" ]; then warn "these items did not finish:$failed"; return 1; fi
  if [ "$DRY_RUN" = 1 ]; then say "Nothing was changed. Run again without --dry-run to apply."; return 0; fi
  say "Start a new Claude Code session to load the changes."
}

parse_args "$@"
if [ -z "${SELECTED// /}" ]; then
  if [ -t 0 ]; then main_menu; else usage >&2; exit 2; fi
fi
if [ ! -t 0 ] && [ "$ASSUME_YES" = 0 ]; then
  ASSUME_YES=1
  say "No terminal to ask questions in, so every question takes its safe default."
fi
for tool in jq python3 git; do
  command -v "$tool" >/dev/null || { warn "missing required tool: $tool"; exit 1; }
done
run_selected
