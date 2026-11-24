# shellcheck shell=bash
# components.sh: what setup.sh can import, and how. Sourced, not run. Bash 3.2 compatible.
# Globals read: REPO, CLAUDE_DIR, HOOK_DEST, PROJECT_DIR, DRY_RUN, ASSUME_YES.

# shellcheck disable=SC2034  # read by setup.sh, which sources this file
COMPONENT_IDS="rules instructions hooks settings skills project"
# shellcheck disable=SC2034
EVERYTHING_IDS="rules hooks settings skills"  # "instructions" is the one-file alternative to "rules"

component_title() {
  case "$1" in
    rules) echo "Rules (full)" ;;
    instructions) echo "Instructions (one file)" ;;
    hooks) echo "Guard hooks" ;;
    settings) echo "Claude Code settings" ;;
    skills) echo "Skills" ;;
    project) echo "Project starter" ;;
  esac
}

component_desc() {
  case "$1" in
    rules) echo "Topic rule files in ~/.claude/rules/ai-onboarding/, loaded in every project." ;;
    instructions) echo "A condensed ~/.claude/CLAUDE.md instead of the full rules. Pick this or Rules." ;;
    hooks) echo "Block heredocs, force-push, git add -A, risky rm -rf and secrets in edits." ;;
    settings) echo "Deny rules plus hook wiring, merged into your settings.json. Needs the hooks." ;;
    skills) echo "pr-review, lean-audit (no dead code or junk tests), instruction-audit (docs stay true)." ;;
    project) echo "AGENTS.md, CLAUDE.md shim, and a GitHub kit: PR template, Dependabot, CI, pre-push." ;;
  esac
}

component_files() {
  case "$1" in
    rules) ls "$REPO"/rules/*.md ;;
    instructions) echo "$REPO/templates/global-CLAUDE.md" ;;
    hooks) ls "$REPO"/claude/hooks/*.py ;;
    settings) echo "$REPO/claude/settings.example.json" ;;
    skills) ls "$REPO"/skills/*/SKILL.md ;;
    project) echo "$REPO/templates/project-AGENTS.md"; echo "$REPO/templates/project-CLAUDE.md"
             find "$REPO/templates/github" -type f | sort ;;
  esac
}

install_rules() {
  local f
  for f in "$REPO"/rules/*.md; do
    place_file "$f" "$CLAUDE_DIR/rules/ai-onboarding/$(basename "$f")" || return 1
  done
}

install_instructions() {
  local src="$REPO/templates/global-CLAUDE.md" dest="$CLAUDE_DIR/CLAUDE.md" side choice
  side="$CLAUDE_DIR/CLAUDE.ai-onboarding.md"
  if [ ! -f "$dest" ] || cmp -s "$src" "$dest"; then
    place_file "$src" "$dest"
    return 0
  fi
  say "  You already have $dest. Differences (yours, then ours):"
  show_diff "$dest" "$src"
  choice="$(ask_choice "  What should happen to your CLAUDE.md?" s \
    "s=keep yours, save ours next to it to merge by hand" \
    "r=replace yours (a backup is kept)" \
    "k=keep yours, skip this")"
  case "$choice" in
    r) place_file "$src" "$dest" ;;
    k) say "  skipped    $dest" ;;
    *) place_file "$src" "$side"; say "  Merge the lines you want from $side into $dest." ;;
  esac
}

install_hooks() {
  if [ "$DRY_RUN" = 1 ]; then
    if ! HOOK_DEST="$HOOK_DEST" bash "$REPO/scripts/install-hooks.sh" --test-only >/dev/null 2>&1; then
      warn "hook tests failed; run claude/hooks/test-hooks.sh to see which."
      return 1
    fi
    say "  hook tests passed"
    say "  would install no-heredoc, guard-bash, guard-secrets to $HOOK_DEST"
    return 0
  fi
  local out
  if ! out="$(HOOK_DEST="$HOOK_DEST" bash "$REPO/scripts/install-hooks.sh" 2>&1)"; then
    printf '%s\n' "$out" | grep -vE '^PASS ' >&2
    warn "hook tests failed, so nothing was installed."
    return 1
  fi
  say "  hook tests passed"
  printf '%s\n' "$out" | grep -E '^(installed|backed up) ' | sed 's/^/  /'
}

install_settings() {
  local live="$CLAUDE_DIR/settings.json" merged
  merged="$(mktemp)"
  if [ ! -x "$HOOK_DEST/claude-no-heredoc" ] && ! is_selected hooks; then
    warn "the settings point at hooks in $HOOK_DEST that are not installed; select Guard hooks too."
  fi
  CLAUDE_SETTINGS="$live" MERGE_OUT="$merged" bash "$REPO/scripts/merge-settings.sh" >/dev/null
  if [ -f "$live" ] && cmp -s "$live" "$merged"; then
    rm -f "$merged"
    say "  unchanged  $live"
    return 0
  fi
  [ -f "$live" ] && show_diff "$live" "$merged"
  if [ "$DRY_RUN" = 1 ]; then
    rm -f "$merged"
    if [ -f "$live" ]; then say "  would update $live (backup kept)"; else say "  would create $live"; fi
    return 0
  fi
  if ask_yn "  Apply these settings changes?" y; then
    if [ -f "$live" ]; then
      cp -p "$live" "$(backup_path "$live")" || { warn "cannot back up $live"; return 1; }
    fi
    mv "$merged" "$live" || { warn "cannot write $live"; return 1; }
    chmod 600 "$live"
    say "  updated    $live"
  else
    rm -f "$merged"
    say "  skipped    $live"
  fi
}

install_skills() {
  local dir name f
  for dir in "$REPO"/skills/*/; do
    name="$(basename "$dir")"
    ask_yn "  Install skill '$name'?" y || { say "  skipped    $name"; continue; }
    for f in "$dir"*; do
      place_file "$f" "$CLAUDE_DIR/skills/$name/$(basename "$f")" || return 1
    done
  done
}

install_project() {
  local dir="$PROJECT_DIR"
  if [ -z "$dir" ] && [ "$ASSUME_YES" = 0 ]; then
    printf '  Project folder to set up (blank to skip): '
    read -r dir || dir=""
  fi
  dir="${dir/#\~/$HOME}"
  if [ -z "$dir" ]; then say "  skipped    no project folder given"; return 0; fi
  if [ ! -d "$dir" ]; then warn "$dir is not a folder; skipped."; return 0; fi
  if [ -f "$dir/AGENTS.md" ]; then
    say "  kept       $dir/AGENTS.md (already there)"
  else
    place_file "$REPO/templates/project-AGENTS.md" "$dir/AGENTS.md"
    [ "$DRY_RUN" = 1 ] || say "  Fill in the placeholders, or ask your agent to fill them in from the code."
  fi
  if [ ! -f "$dir/CLAUDE.md" ]; then
    place_file "$REPO/templates/project-CLAUDE.md" "$dir/CLAUDE.md"
  elif ! grep -q '@AGENTS.md' "$dir/CLAUDE.md"; then
    say "  kept       $dir/CLAUDE.md; add a line '@AGENTS.md' to it so Claude reads AGENTS.md."
  else
    say "  unchanged  $dir/CLAUDE.md"
  fi
  if ask_yn "  Add the GitHub kit (PR template, Dependabot, CI workflow, pre-push hook)?" y; then
    install_github_kit "$dir" || return 1
  fi
}

# place_new SRC DEST: copy only when DEST is missing; a project's own files are never replaced.
place_new() {
  if [ -e "$2" ]; then say "  kept       $2 (already there)"; return 0; fi
  place_file "$1" "$2"
}

install_github_kit() {
  local dir="$1" kit="$REPO/templates/github"
  place_new "$kit/pull_request_template.md" "$dir/.github/pull_request_template.md" || return 1
  place_new "$kit/dependabot.yml" "$dir/.github/dependabot.yml" || return 1
  place_new "$kit/workflows/ci.yml" "$dir/.github/workflows/ci.yml" || return 1
  place_new "$kit/githooks/pre-push" "$dir/.githooks/pre-push" || return 1
  [ "$DRY_RUN" = 1 ] && return 0
  chmod +x "$dir/.githooks/pre-push"
  say "  Edit the commands in .github/workflows/ci.yml and .githooks/pre-push to match AGENTS.md."
  if [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; then
    if ask_yn "  Turn on the pre-push hook for this clone now?" n; then
      git -C "$dir" config core.hooksPath .githooks
      say "  set        core.hooksPath=.githooks in $dir"
    else
      say "  To turn it on later: git -C $dir config core.hooksPath .githooks"
    fi
  fi
}
