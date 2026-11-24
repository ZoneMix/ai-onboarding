# ai-onboarding

My AI coding setup, packaged so you can take all of it or just the parts you like: the
working rules I give coding agents, hooks that stop the mistakes they make most, a couple of
skills, and a simple way to set up instruction files in each project.

## Quick start

```bash
git clone https://github.com/ZoneMix/ai-onboarding.git
```

```bash
cd ai-onboarding && ./setup.sh
```

The menu lets you import everything, pick and choose, or read through what's here first.
Nothing is replaced without a backup, and an existing `CLAUDE.md` is never overwritten unless
you say so.

Prefer to let an agent do it? Open Claude Code (or another coding agent) in the cloned folder
and say:

> Read AGENTS.md and set up my machine from it.

It will show you the options, preview the changes and install what you choose.

## What's inside

- **Rules** (`rules/`): how a coding task runs from plan to pull request, how to review code,
  how to work with GitHub and CI, plus communication, git, shell, secrets, deploys, writing,
  design and accessibility.
- **Guard hooks** (`claude/hooks/`): block heredocs, force-pushes, `git add -A`, skipped git
  hooks, risky `rm -rf`, reading private SSH keys, and secrets in edits or commits.
- **Settings** (`claude/settings.example.json`): matching deny rules, merged into yours.
- **Skills** (`skills/`): `pr-review` reviews a PR or branch with severity and
  `file:line`; `lean-audit` keeps out dead code and junk tests; `instruction-audit` checks
  that `AGENTS.md` still matches the code.
- **Obsidian** (`obsidian/`, `rules/obsidian.md`): how I use a git-backed vault as memory
  shared by every agent, a vault starter with that memory layout and a safe multi-agent git
  protocol, my app settings and CSS snippets, and skills for working in a vault.
- **Project starter** (`templates/`): `AGENTS.md` as the single source of truth, a one-line
  `CLAUDE.md` that imports it, and a GitHub kit: PR template, Dependabot, a CI workflow with
  pinned actions, and a pre-push hook.

## Useful flags

```bash
./setup.sh --help
```

```bash
./setup.sh --all --dry-run
```

```bash
./setup.sh --only rules,hooks,settings
```

```bash
./setup.sh --project ~/code/my-app
```

```bash
./setup.sh --only obsidian --vault ~/Documents/Vault
```

## Requirements

macOS or Linux, bash, Python 3.9+, `jq` and `git`. Claude Code for the hooks, settings and
skills; the rules work with any agent that reads `AGENTS.md`. Optional: `gitleaks` for secret
scans.

## License

MIT. See `LICENSE`.
