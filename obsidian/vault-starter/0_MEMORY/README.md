---
title: Memory
description: Platform-neutral long-term memory for every agent I use. Read this first.
type: moc
domain: operations
---
# Memory

Up: [[Home]]

This folder is the source of truth for what my agents know about me. Any agent can read and
write it; none of it lives inside a single agent platform.

## Files

- [[0_MEMORY/Standing Rules|Standing Rules]]: hard rules (sending, money, secrets, git,
  deploys).
- [[0_MEMORY/Preferences|Preferences]]: how I want agents to talk and work.
- [[0_MEMORY/Profile|Profile]]: who I am, as much as an agent needs.
- [[0_MEMORY/Agents|Agents]]: the roster of agents, each one's job and what it owns.
- [[0_MEMORY/rules|rules]]: the correction log; every agent rereads it before each task.
- [[0_MEMORY/decisions|decisions]]: my answers to past questions; check before asking me.
- `Log/YYYY-MM.md`: dated history, newest at the bottom.

Add topic files as you need them (Projects, Infrastructure, Health, People, voice for how I
write). Keep each one to one subject.

## Fact format

One fact per line: `- Fact in plain words. [YYYY-MM-DD, Source]`

- The date is when the fact was learned or last confirmed.
- The source is the agent or person who learned it.
- `(confirm)` at the end marks a guess I haven't verified.

## Rules

1. Never store secret values. Naming where a secret lives is fine.
2. Correct, don't duplicate. Edit the line; put history in `Log/` if it matters.
3. Newest dated fact wins. If you can't tell, keep both, add `(confirm)` and ask.
4. Durable facts only. Routine run results don't belong here.
5. Respect folder ownership (see [[0_MEMORY/Agents|Agents]]).
6. Git: follow the steps in the root [[AGENTS]] file.
