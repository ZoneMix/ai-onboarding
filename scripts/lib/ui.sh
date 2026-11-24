# shellcheck shell=bash
# ui.sh: prompt and file helpers for setup.sh. Sourced, not run. Bash 3.2 compatible.
# Globals read: DRY_RUN (0/1), ASSUME_YES (0/1), STAMP.

say() { printf '%s\n' "$*"; }
step() { printf '\n== %s\n' "$*"; }
warn() { printf 'note: %s\n' "$*" >&2; }

# ask_yn "question" default(y|n): returns 0 for yes. With --yes, takes the default.
ask_yn() {
  local q="$1" def="${2:-y}" ans hint="[Y/n]"
  [ "$def" = "n" ] && hint="[y/N]"
  if [ "$ASSUME_YES" = 1 ]; then [ "$def" = "y" ]; return; fi
  printf '%s %s ' "$q" "$hint"
  read -r ans || ans=""
  ans="$(printf '%s' "${ans:-$def}" | tr '[:upper:]' '[:lower:]')"
  [ "$ans" = "y" ] || [ "$ans" = "yes" ]
}

# ask_choice "question" default "k=keep yours" "r=replace" ...: echoes the chosen key.
ask_choice() {
  local q="$1" def="$2" ans opt
  shift 2
  if [ "$ASSUME_YES" = 1 ]; then printf '%s' "$def"; return; fi
  printf '%s\n' "$q" >&2
  for opt in "$@"; do printf '  %s) %s\n' "${opt%%=*}" "${opt#*=}" >&2; done
  printf 'Choice [%s]: ' "$def" >&2
  read -r ans || ans=""
  printf '%s' "${ans:-$def}"
}

backup_path() { printf '%s.bak-%s' "$1" "$STAMP"; }

# place_file SRC DEST: copy, keeping a timestamped backup when DEST exists and differs.
place_file() {
  local src="$1" dest="$2"
  if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
    say "  unchanged  $dest"
    return 0
  fi
  if [ "$DRY_RUN" = 1 ]; then
    if [ -f "$dest" ]; then say "  would update $dest (backup kept)"; else say "  would create $dest"; fi
    return 0
  fi
  mkdir -p "$(dirname "$dest")" || { warn "cannot create the folder for $dest"; return 1; }
  if [ -f "$dest" ]; then
    cp -p "$dest" "$(backup_path "$dest")" || { warn "cannot back up $dest"; return 1; }
    cp "$src" "$dest" || { warn "cannot write $dest"; return 1; }
    say "  updated    $dest (old copy: $(backup_path "$dest"))"
  else
    cp "$src" "$dest" || { warn "cannot write $dest"; return 1; }
    say "  created    $dest"
  fi
}

# show_diff OLD NEW: a short unified diff for the person to read before deciding.
show_diff() {
  diff -u "$1" "$2" | head -n 80 || true  # diff exits 1 when files differ; expected
}

# view_file PATH: page a file for reading, or print it when there is no terminal.
view_file() {
  if [ -t 1 ]; then "${PAGER:-less}" "$1"; else cat "$1"; fi
}
