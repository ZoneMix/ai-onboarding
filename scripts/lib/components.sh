# shellcheck shell=bash
# components.sh: what setup.sh can import, and how. Sourced, not run. Bash 3.2 compatible.
# Globals read: REPO, CLAUDE_DIR, HOOK_DEST, PROJECT_DIR, VAULT_DIR, WORK_VAULT_DIR, DRY_RUN, ASSUME_YES.

# shellcheck disable=SC2034  # read by setup.sh, which sources this file
COMPONENT_IDS="rules instructions hooks settings skills obsidian project"
CODING_SKILLS="pr-review lean-audit instruction-audit"
OBSIDIAN_SKILLS="obsidian-vault obsidian-vault-restructure obsidian-markdown-lint build-study-guide"
# shellcheck disable=SC2034
EVERYTHING_IDS="rules hooks settings skills obsidian"  # "instructions" is the one-file alternative to "rules"

component_title() {
  case "$1" in
    rules) echo "Rules (full)" ;;
    instructions) echo "Instructions (one file)" ;;
    hooks) echo "Guard hooks" ;;
    settings) echo "Claude Code settings" ;;
    skills) echo "Coding skills" ;;
    obsidian) echo "Obsidian" ;;
    project) echo "Project starter" ;;
  esac
}

component_desc() {
  case "$1" in
    rules) echo "Topic and per-language rules in ~/.claude/rules/ai-onboarding/, loaded everywhere." ;;
    instructions) echo "A condensed ~/.claude/CLAUDE.md instead of the full rules. Pick this or Rules." ;;
    hooks) echo "Block heredocs, force-push, git add -A, risky rm -rf and secrets in edits." ;;
    settings) echo "Deny rules plus hook wiring, merged into your settings.json. Needs the hooks." ;;
    skills) echo "pr-review, lean-audit (no dead code or junk tests), instruction-audit (docs stay true)." ;;
    obsidian) echo "Vault skills, /vault-map, /backlinks and the push backstop; life and work vault starters with --vault and --work-vault." ;;
    project) echo "AGENTS.md, CLAUDE.md shim, and a GitHub kit: PR template, Dependabot, CI, pre-push." ;;
  esac
}

component_files() {
  case "$1" in
    rules) ls "$REPO"/rules/*.md "$REPO"/rules/languages/*.md ;;
    instructions) echo "$REPO/templates/global-CLAUDE.md" ;;
    hooks) ls "$REPO"/claude/hooks/*.py ;;
    settings) echo "$REPO/claude/settings.example.json" ;;
    skills) for n in $CODING_SKILLS; do echo "$REPO/skills/$n/SKILL.md"; done ;;
    obsidian) echo "$REPO/rules/obsidian.md"; echo "$REPO/obsidian/README.md"
              for n in $OBSIDIAN_SKILLS; do echo "$REPO/skills/$n/SKILL.md"; done
              ls "$REPO"/commands/*.md ;;
    project) echo "$REPO/templates/project-AGENTS.md"; echo "$REPO/templates/project-CLAUDE.md"
             find "$REPO/templates/github" -type f | sort ;;
  esac
}

install_rules() {
  place_tree "$REPO/rules" "$CLAUDE_DIR/rules/ai-onboarding"
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

# place_tree SRC_DIR DEST_DIR: place_file for every file under SRC_DIR, keeping the layout,
# then one summary line instead of a line per file.
place_tree() {
  local f out="" line created=0 updated=0 same=0
  while IFS= read -r f; do
    line="$(place_file "$1/$f" "$2/$f")" || return 1
    case "$line" in
      *created*|*"would create"*) created=$((created + 1)) ;;
      *updated*|*"would update"*) updated=$((updated + 1)); out="$out$line
" ;;
      *) same=$((same + 1)) ;;
    esac
  done < <(cd "$1" && find . -type f ! -name .DS_Store ! -name '*.pyc' ! -path '*/__pycache__/*' | sed 's|^\./||' | sort)
  printf '%s' "$out"
  say "  $2: $created new, $updated updated, $same unchanged"
}

install_skill_set() {  # install_skill_set "names": ask per skill, then copy it whole
  local name
  for name in $1; do
    ask_yn "  Install skill '$name'?" y || { say "  skipped    $name"; continue; }
    place_tree "$REPO/skills/$name" "$CLAUDE_DIR/skills/$name" || return 1
  done
}

install_skills() {
  install_skill_set "$CODING_SKILLS"
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

fill_vault() {  # fill_vault <starter dir> <vault dir> <label>: add the starter's missing files, never replace a note
  local starter="$1" dir="$2" label="$3" f
  if [ -e "$dir" ] && [ ! -d "$dir" ]; then warn "$dir is not a folder; skipped."; return 0; fi
  say "  $label in $dir (existing notes are never replaced):"
  while IFS= read -r f; do
    place_new "$starter/$f" "$dir/$f" || return 1
  done < <(cd "$starter" && find . -type f ! -name .DS_Store | sed 's|^\./||' | sort)
  [ "$DRY_RUN" = 1 ] && return 0
  [ -f "$dir/.githooks/pre-commit" ] && chmod +x "$dir/.githooks/pre-commit"
  if [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; then
    local current
    current="$(git -C "$dir" config --get core.hooksPath || true)"
    if [ -n "$current" ] && [ "$current" != ".githooks" ]; then
      say "  kept       core.hooksPath=$current in $dir (set it to .githooks yourself to use the vault hook)"
    elif ! command -v gitleaks >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/gitleaks ] && [ ! -x /usr/local/bin/gitleaks ]; then
      say "  skipped    the vault hook: it needs gitleaks, which is not installed (it would block every commit)."
      say "  Install gitleaks, then: git -C \"$dir\" config core.hooksPath .githooks"
    elif ask_yn "  Turn on the vault pre-commit hook (gitleaks, size cap) for $dir now?" y; then
      git -C "$dir" config core.hooksPath .githooks
      say "  set        core.hooksPath=.githooks in $dir"
    fi
  else
    say "  To share the vault with agents safely, make it a git repo: git -C \"$dir\" init"
    say "  then turn on its hook: git -C \"$dir\" config core.hooksPath .githooks"
  fi
}

install_obsidian() {
  local dir="$VAULT_DIR" work="$WORK_VAULT_DIR" f
  install_skill_set "$OBSIDIAN_SKILLS" || return 1
  place_tree "$REPO/commands" "$CLAUDE_DIR/commands" || return 1
  place_new "$REPO/obsidian/scripts/vault-daily-push" "$HOOK_DEST/vault-daily-push" || return 1
  [ "$DRY_RUN" = 1 ] || chmod +x "$HOOK_DEST/vault-daily-push"
  say "  Schedule the push backstop with obsidian/scripts/launchd or systemd (see obsidian/scripts/README.md)."
  say "  Agents also want the official skills: claude plugin marketplace add obsidianmd/obsidian-skills"
  say "  then: claude plugin install obsidian@obsidian-skills"
  if [ -z "$dir" ] && [ -z "$work" ] && [ "$ASSUME_YES" = 0 ]; then
    printf '  Life vault folder to create or fill in (blank to skip): '
    read -r dir || dir=""
    printf '  Work vault folder to create or fill in (blank to skip): '
    read -r work || work=""
  fi
  dir="${dir/#\~/$HOME}"
  work="${work/#\~/$HOME}"
  if [ -z "$dir" ] && [ -z "$work" ]; then say "  skipped    vault starters (no vault folder given)"; return 0; fi
  if [ -n "$dir" ]; then fill_vault "$REPO/obsidian/vault-starter" "$dir" "Life vault starter" || return 1; fi
  if [ -n "$work" ]; then fill_vault "$REPO/obsidian/work-vault-starter" "$work" "Work vault starter" || return 1; fi
  local target targets=()
  [ -n "$dir" ] && targets+=("$dir")
  [ -n "$work" ] && targets+=("$work")
  for target in "${targets[@]}"; do
    if ask_yn "  Copy my Obsidian settings and CSS snippets into $target/.obsidian (yours are kept)?" y; then
      while IFS= read -r f; do
        place_new "$REPO/obsidian/config/.obsidian/$f" "$target/.obsidian/$f" || return 1
      done < <(cd "$REPO/obsidian/config/.obsidian" && find . -type f ! -name .DS_Store | sed 's|^\./||' | sort)
      say "  Open the vault in Obsidian and allow community plugins to install the listed ones."
    fi
  done
}
