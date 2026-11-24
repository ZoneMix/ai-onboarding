# ai-onboarding

My AI coding setup, written so an agent can reproduce it. Point Claude Code (or another
coding agent) at this repo and tell it:

> Read AGENTS.md in this repo and set up my machine the same way.

It will read the rules, install the guard hooks, merge the settings and set up instruction
files, showing you each change before it replaces anything.

## What you get

- **Working rules** (`rules/`): how the agent communicates, writes code, uses git and the
  shell, handles secrets, deploys, and keeps visuals accessible.
- **Guard hooks** (`claude/hooks/`): block heredocs, force-pushes, `git add -A`, deep
  `rm -rf` mistakes, reading private SSH keys, and secrets in edits or commits.
- **Instruction-file layout** (`templates/`): `AGENTS.md` as the single source of truth per
  project, with a one-line `CLAUDE.md` that imports it.
- **Skills** (`skills/`): a lean-code gate and an instruction-file audit.

## Requirements

macOS or Linux, Python 3.9+, `jq`, `git`, and Claude Code for the hooks. Optional:
`gitleaks` for secret scans.

## License

MIT. See `LICENSE`.
