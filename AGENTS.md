# AI onboarding

You are a coding agent. Someone pointed you at this repo so you can set up their machine and
projects the way this setup works: the same working rules, the same guard hooks and the same
instruction-file layout. This file is your entry point. Read it top to bottom, then follow
"Setup". Everything here is plain text and small scripts; nothing phones home.

## What this repo holds

| Path | What it is |
|---|---|
| `rules/` | The working rules, one short file per topic. The source of truth for behavior. |
| `templates/global-CLAUDE.md` | User-level instructions (`~/.claude/CLAUDE.md`), condensed from `rules/`. |
| `templates/project-AGENTS.md` | Starting point for a project's `AGENTS.md`. |
| `templates/project-CLAUDE.md` | The one-line shim that makes Claude Code read `AGENTS.md`. |
| `claude/hooks/` | Claude Code PreToolUse hooks that enforce the rules prose cannot. |
| `claude/settings.example.json` | Deny rules and hook wiring to merge into `~/.claude/settings.json`. |
| `skills/` | Reusable skills (`SKILL.md` folders) for Claude Code or any agent that reads them. |
| `scripts/` | `install-hooks.sh` and `merge-settings.sh`. |

## Setup

Work through these in order. Show the person a diff before you replace any file they already
have, and never delete their existing settings or instructions.

1. **Read the rules.** Read every file in `rules/`. They are short. Apply them for the rest
   of this session, including while you do the setup.
2. **Install the hooks.** Run `scripts/install-hooks.sh`. It copies the hooks to
   `~/.local/bin` and runs their test suite. Stop and report if a test fails.
3. **Merge the settings.** Run `scripts/merge-settings.sh`. It writes a merged copy next to
   `~/.claude/settings.json` and prints the diff. Show the diff, then move the file into
   place once the person agrees. Existing keys are kept; deny rules and hooks are unioned.
4. **Install the user-level instructions.** If `~/.claude/CLAUDE.md` does not exist, copy
   `templates/global-CLAUDE.md` there. If it exists, propose a merge: keep the person's own
   lines, add the missing rules, and resolve conflicts in favor of their file.
5. **Install skills (optional).** Copy any folder in `skills/` to `~/.claude/skills/` (user
   level) or `<project>/.claude/skills/` (one project).
6. **Per project.** In each repo the person names, create `AGENTS.md` from
   `templates/project-AGENTS.md` (fill in what you can learn from the code; leave the rest as
   questions) and `CLAUDE.md` from `templates/project-CLAUDE.md`.
7. **Verify.** In a new session, confirm a heredoc is blocked
   (`echo hi` followed by a heredoc marker) and that `git add -A` is refused. Report what was
   installed, where, and anything skipped.

## Other agents

`AGENTS.md` is the shared format: Codex, Cursor and others read it directly. For an agent that
reads its own file instead (for example `GEMINI.md`), make that file a pointer to `AGENTS.md`
rather than a copy, so there is one source of truth. The hooks are Claude Code specific; for
other agents, the rules in `rules/` still apply as prose.

## Ground rules for this repo itself

- Keep it generic: no secrets, hostnames, IP addresses, internal domains, personal names or
  account details. A rule that needs a path uses a placeholder like `<repo>` or `$HOME`.
- Each fact lives in one place. `rules/` is canonical; `templates/global-CLAUDE.md` condenses
  it, so change both together.
- Hooks fail closed on input they cannot parse, and every hook change gets a test case in
  `claude/hooks/test-hooks.sh`.
- Run `scripts/install-hooks.sh --test-only` and a secret scan (`gitleaks dir .`) before every
  commit.
