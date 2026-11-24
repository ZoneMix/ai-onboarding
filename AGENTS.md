# AI onboarding

You are a coding agent. Someone pointed you at this repo so you can set up their machine and
projects the way this setup works: the same working rules, guard hooks, skills and
instruction-file layout. This file is your entry point. Read it top to bottom, then follow
"Setup". Everything here is plain text and small scripts; nothing phones home.

## What this repo holds

| Path | What it is |
|---|---|
| `setup.sh` | The installer. A menu for people; flags for agents (`./setup.sh --help`). |
| `rules/` | The working rules, one short file per topic. The source of truth for behavior. |
| `templates/global-CLAUDE.md` | The same rules condensed into one user-level `CLAUDE.md`. |
| `templates/project-AGENTS.md` | Starting point for a project's `AGENTS.md`. |
| `templates/project-CLAUDE.md` | The one-line shim that makes Claude Code read `AGENTS.md`. |
| `templates/github/` | PR template, Dependabot config, pinned CI workflow and a pre-push hook. |
| `claude/hooks/` | Claude Code PreToolUse hooks that enforce what prose cannot, with tests. |
| `claude/settings.example.json` | Deny rules and hook wiring, merged into `settings.json`. |
| `skills/` | Reusable skills (`SKILL.md` folders): coding and Obsidian. |
| `obsidian/` | A vault starter for agent memory and my Obsidian app settings. |
| `scripts/` | Helpers `setup.sh` uses: hook install, settings merge, menu code. |

## The items

`./setup.sh --list` prints them. Each can be installed on its own:

- **rules**: copies `rules/*.md` to `~/.claude/rules/ai-onboarding/`. Claude Code loads
  `~/.claude/rules/` in every project.
- **instructions**: the one-file alternative to rules, installed as `~/.claude/CLAUDE.md`. An
  existing file is kept and ours is saved next to it as `CLAUDE.ai-onboarding.md`.
- **hooks**: runs the hook tests, then installs the hooks to `~/.local/bin/claude-*`.
- **settings**: merges deny rules and hook wiring into `~/.claude/settings.json`. Existing
  keys are kept; deny rules and hooks are unioned. Needs the hooks.
- **skills**: copies the coding skills to `~/.claude/skills/`: `pr-review`, `lean-audit`
  and `instruction-audit`.
- **obsidian**: copies the vault skills (`obsidian-vault`, `obsidian-vault-restructure`,
  `obsidian-markdown-lint`, `build-study-guide`). With `--vault <dir>` it also creates the
  vault, or adds only the missing files to an existing one, and copies the app settings
  without replacing any of theirs.
- **project**: adds `AGENTS.md`, a `CLAUDE.md` shim and, if wanted, the GitHub kit to one
  project folder. It never replaces a file the project already has.

Every replaced file gets a timestamped `.bak-YYYYMMDD-HHMMSS` copy next to it.

## Setup

1. **Read the rules** in `rules/` and apply them for the rest of the session, including while
   you do the setup.
2. **Ask what they want.** Show the person the list above and ask whether they want
   everything (`--all` is rules, hooks, settings, skills and Obsidian) or only some items.
   Ask whether they use Obsidian and where their vault is (`--vault`). If they'd
   rather drive it themselves, tell them to run `./setup.sh` in a terminal for the menu, and
   stop here.
3. **Preview.** Run `./setup.sh --all --dry-run` (or `--only <items> --dry-run`) and show the
   person what would change.
4. **Install.** Run the same command without `--dry-run`. Without a terminal, every question
   takes its safe default: keep their `CLAUDE.md`, apply the merged settings with a backup,
   install every selected skill.
5. **Merge by hand where asked.** If `~/.claude/CLAUDE.ai-onboarding.md` was created, propose a
   merge into their `CLAUDE.md`: keep their lines, add what's missing, and resolve conflicts in
   favor of their file.
6. **Per project.** For each repo they name, run `./setup.sh --only project --project <dir>`,
   then fill in `AGENTS.md` from what the code shows and leave the rest as questions.
7. **Verify.** In a new session, confirm a heredoc is blocked and `git add -A` is refused.
   Report what was installed, where, and anything skipped.

## How the work flows

The rules cover the whole loop, and are worth reading in this order:

1. `workflow.md`: understand, isolate (branch and worktree per task), build, verify, hand off.
2. `review.md`: what to look for, how to write and verify findings, untrusted diffs.
3. `github.md`: pull requests, CI hardening, dependency updates, releases, going public.
4. `scheduled-agents.md`: headless review and triage jobs that run on a timer.
5. `obsidian.md`: an Obsidian vault as long-term memory shared by every agent.

The rest (`communication`, `autonomy`, `code`, `git`, `shell`, `security`, `deploy`,
`accessibility`, `writing-and-design`, `instruction-files`, `multi-agent`) apply throughout.

## Other agents

`AGENTS.md` is the shared format: Codex, Cursor and others read it directly. For an agent that
reads its own file instead (for example `GEMINI.md`), make that file a pointer to `AGENTS.md`
rather than a copy. The hooks and settings are Claude Code specific; for other agents, the
rules in `rules/` still apply as prose.

## Changing this repo

- Keep it generic: no secrets, hostnames, IP addresses, internal domains, personal names or
  account details. Use placeholders like `<repo>` or `$HOME`.
- `rules/` is canonical; `templates/global-CLAUDE.md` condenses it, so change both together.
- Hooks fail closed on input they cannot parse, and every hook change gets a case in
  `claude/hooks/test-hooks.sh`.
- Scripts stay compatible with macOS's bash 3.2 and pass `shellcheck -x`.
- Before every commit: `./scripts/install-hooks.sh --test-only`, `shellcheck -x setup.sh
  scripts/*.sh scripts/lib/*.sh`, and `gitleaks dir .`.
