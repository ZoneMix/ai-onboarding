# Personal coding principles

Terse, durable preferences. Prefer judgment over scaffolding: act, then report.

## Precedence
- When instructions conflict, the most specific file wins: a folder's AGENTS.md or CLAUDE.md,
  then its parents up to the repo root, then this file. What I say in the session beats all
  of them.
- Hooks and `permissions.deny` override all prose.
- In a repo with both files, AGENTS.md is canonical and CLAUDE.md starts with `@AGENTS.md`,
  adding only Claude-specific notes.

## How I work
- Autonomous: plan, implement, verify, repeat. Don't ask unless blocked or the action is
  irreversible, destructive or outbound.
- Define "done" before starting. Run the tests (or the project's build checks), fix failures
  caused by the change, and rerun without asking.
- Parallelize genuinely independent work. Pull in context conditionally.

## Communication
- Lead with the answer. Give a recommendation, not a menu.
- Short, plain sentences. Back claims with a file, command output or link.
- Commands I might run are paste-ready, one per block.
- No em dashes or middots in anything you write.

## Code style
- Immutable data across function boundaries: return new objects. Local accumulators are fine.
- Small files (200 to 400 lines), small functions (under 50 lines).
- Handle errors explicitly at every level; never swallow silently. A deliberate ignore says why.
- No hardcoded values: use constants or config. Only write code a current caller needs.

## Git
- Commit format: `<type>: <description>` (feat, fix, refactor, docs, test, chore, perf, ci).
- Never `git add -A`: stage specific files. Never amend unless asked. Never force-push.

## CLI
- `jq` for JSON. `curl -I` for headers.
- No heredocs or here-strings in Bash commands, commit messages included: they leak into shell
  history. Write files with the editor; use repeated `git commit -m`. Enforced by a hook.

## Security
- No secrets in source code or replies, ever. Refer to keychain items by name.
- Validate at system boundaries. Scan for secrets before anything goes public.

## Deploys
- Pin images by tag plus digest. Release through CI, never a local build.
- Deploy, then hash-compare the deployed files with the repo. Never overwrite a host's runtime
  state (`.env`, caches, data).

## Visual output
- Never distinguish states by color alone: add labels, shapes or patterns. Prefer blue and
  orange over red and green. Keep light and dark mode working.

## Writing skills
- SKILL.md description = a short, specific trigger ("Use when ..."), not a broad "use when
  working with X."
- SKILL.md under 150 lines; split references by topic.
