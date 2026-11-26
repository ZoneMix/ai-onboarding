---
title: AGENTS
description: Instructions for any AI agent working in this vault. Load 0_MEMORY first, keep agent output in _agents/.
type: reference
domain: operations
---
# AGENTS

This vault is my personal notes and the shared, platform-neutral memory for every AI agent I use. It is plain markdown in a git repo, so any agent (Claude Code, Codex, a chat assistant, a scheduled bot) can read and write it. Read this file first and follow it exactly. `CLAUDE.md` imports it.

## Load, in this order

1. `0_MEMORY/README.md`: the format and the rules.
2. `0_MEMORY/Standing Rules.md`: hard rules; they override convenience.
3. `0_MEMORY/Preferences.md`: how I want you to talk and work.
4. `0_MEMORY/Profile.md`: who I am, as much as an agent needs.
5. `0_MEMORY/Agents.md`: who else works for me and what each one owns.
6. `0_MEMORY/rules.md`: the correction log. Reread it before every task.
7. Then as the task needs: `decisions.md` (my past answers; check it before asking me), the other topic files, and the newest file in `0_MEMORY/Log/`.

After loading, tell me in three lines or fewer what you loaded and anything that looks stale.

## How to behave

- Concise, bottom line first. No em dashes or middots. Never convey state by color alone.
- Act, then report. Get my explicit yes first for sending messages as me, posting, moving money, deleting data and making anything public.
- When I correct you, find the root cause and add one line to `0_MEMORY/rules.md`: `- Rule. [YYYY-MM-DD, AgentName]`. Show me the line.

## The vault has two sides

The numbered folders are for me. `_agents/` is for agents. Keep them apart.

| Side | Folders | Who reads it | What goes there |
| --- | --- | --- | --- |
| Human | the numbered folders, `People`, `Home.md` | me | Finished, readable notes |
| Memory | `0_MEMORY/` | every agent | Durable facts, one per line |
| Agents | `_agents/` | agents only | Your own tracking: run reports, audits, queues, learning logs, feeds, raw research, transcripts, build trees, working state |

Where your output goes:

| You are writing | Put it in |
| --- | --- |
| A durable fact, rule, decision or correction | the right `0_MEMORY/` file |
| A run report, audit, lint result or review draft | `_agents/reports/<kind>/YYYY-MM-DD.md` |
| A queue or hand-off between bots | `_agents/queues/` |
| Spaced-review or progress logs | `_agents/learning-logs/` |
| Research batches, sources, transcripts, scripts, build output, STATUS files for a project | `_agents/projects/<project>/` |
| A daily brief, news or other generated feed | `_agents/feeds/` |
| Something I should read | a short, clean note in the right human folder, linking to `_agents/` for detail |

Hide `_agents/` from Obsidian's search and graph with Settings, Files and links, Excluded files (`_agents/`). Links into it still open.

## Writing for people

A human note must read like something I wrote for myself: short, plain and linted. If it only makes sense to another agent, it belongs in `_agents/`.

- Obsidian-flavored markdown. The official `obsidian-markdown` skill ([obsidianmd/obsidian-skills](https://github.com/obsidianmd/obsidian-skills)) is the syntax reference.
- Frontmatter on every note, with these five fields: `title`, `date_created` (YYYY-MM-DD), `description` (one sentence), `type`, `domain`.
  - `type` is one of: moc, note, study, research, reference, project, journal, daily, person, book.
  - `domain` is one of the areas you keep (for example: study, reading, home, projects, personal, operations). Keep the list short and fixed.
- Link notes with `[[wikilinks]]`, never markdown links to local files. Use a path when a basename is ambiguous.
- One `# ` heading per note, then `## ` sections with plain names. Prose over walls of bold-label bullets.
- Add each new note to its folder's map of content (`MOC - <Area>.md`). Use the templates in `_obsidian/templates/`.
- Never paste raw transcripts, logs, JSON, code or working notes into a human folder.
- Lint a human note before you commit it: `npx markdownlint-cli2 "<file>"` (the config skips `_agents/`).

## Write protocol

- Save a durable fact (preference, rule, correction, decision, new person, new system) the same turn you learn it, as one line in the topic file it belongs to: `- Fact in plain words. [YYYY-MM-DD, AgentName]`
- Correct, don't duplicate: edit the existing line with the new date and source. Newest dated fact wins; if unsure, keep both, mark `(confirm)` and ask me.
- Significant events go as one dated line at the bottom of `0_MEMORY/Log/YYYY-MM.md`.
- Never store secret values. Naming where a secret lives (a keychain item name) is fine.
- No routine run noise ("checked, nothing new") in memory; run results go in `_agents/reports/`.
- Folders an automation owns (daily notes a bot writes, for example) are written only through that automation. List them in `0_MEMORY/Agents.md`.

## Git: commit often, push every day

The working tree is shared by every agent and the Obsidian Git plugin, which only runs while the app is open. Never count on it for your files.

- Commit after each logical edit, from the vault root. Never end a session with your own changes uncommitted.
- Push after every commit. A daily backstop (`vault-daily-push`, see the repo's `obsidian/scripts/`) pushes committed work that was missed; it never commits for you.
- The tracked hook `.githooks/pre-commit` runs on every commit once you set `git config core.hooksPath .githooks`. It blocks secrets (gitleaks), files over 10 MB, and scratch or `working/` files outside `_agents/`. Never bypass it with `--no-verify`.
- Commit messages: `<type>: <description>` (feat, fix, refactor, docs, test, chore); memory edits use `docs: memory <what>`.

When several agents share the vault:

0. **Lock:** `mkdir .git/memory.lock` (atomic). If it fails, wait 30 seconds and retry. A lock older than 10 minutes is stale: check with `find .git/memory.lock -maxdepth 0 -mmin +10`, then `rmdir` it. Hold the lock through edit, commit, pull and push.
1. **Check:** `git status --porcelain <file>` for each file you will touch. If one has uncommitted changes you didn't make, release the lock, wait a minute, retry.
2. **Commit only your files, by path:** `git commit -m "docs: memory <what>" -- <your files>` (for a move, list the old and new paths).
3. **Sync:** `git pull --rebase --autostash origin main && git push origin main`
4. **Release:** `rmdir .git/memory.lock`, even if a step failed.
5. **Never** stash, reset, force-push, `git add -A` or `git commit -a`. On a rebase conflict, `git rebase --abort`, release the lock and ask me.

If you cannot reach the vault, say so and ask how to get access. Do not invent memory.
