---
title: AGENTS
description: Instructions for any AI agent working in this vault. Load 0_MEMORY first.
type: reference
domain: operations
---
# AGENTS

This vault is the shared, platform-neutral memory for every AI agent I use. It is plain
markdown in a git repo, so any agent (Claude Code, Codex, a chat assistant, a scheduled bot)
can read and write it. Load it before doing anything else, and keep it current as you work.

## Load, in this order

1. `0_MEMORY/README.md`: the format and the rules.
2. `0_MEMORY/Standing Rules.md`: hard rules; they override convenience.
3. `0_MEMORY/Preferences.md`: how I want you to talk and work.
4. `0_MEMORY/Profile.md`: who I am, as much as an agent needs.
5. `0_MEMORY/Agents.md`: who else works for me and what each one owns.
6. `0_MEMORY/rules.md`: the correction log. Reread it before every task.
7. Then as the task needs: `decisions.md` (my past answers; check it before asking me), the
   other topic files, and the newest file in `0_MEMORY/Log/`.

After loading, tell me in three lines or fewer what you loaded and anything that looks stale.

## How to behave

- Concise, bottom line first. No em dashes or middots. Never convey state by color alone.
- Act, then report. Get my explicit yes first for sending messages as me, posting, moving
  money, deleting data and public deploys.
- When I correct you, find the root cause and add one line to `0_MEMORY/rules.md`:
  `- Rule. [YYYY-MM-DD, AgentName]`. Show me the line.

## Write protocol

- Save a durable fact (preference, rule, correction, decision, new person, new system) the
  same turn you learn it, as one line in the topic file it belongs to:
  `- Fact in plain words. [YYYY-MM-DD, AgentName]`
- Correct, don't duplicate: edit the existing line with the new date and source. Newest dated
  fact wins; if unsure, keep both, mark `(confirm)` and ask me.
- Significant events go as one dated line at the bottom of `0_MEMORY/Log/YYYY-MM.md`.
- Never store secret values. Naming where a secret lives (a keychain item name) is fine.
- No routine run noise ("checked, nothing new").
- Elsewhere in the vault, follow the existing frontmatter (`title`, `date_created`,
  `description`, `type`, `domain`) and link with `[[wikilinks]]`.
- Folders an automation owns are written only through that automation. List them in
  `0_MEMORY/Agents.md`.

## Git, when several agents share the vault

The working tree is shared by every agent and the Obsidian Git plugin. Keep edits small and
commit them immediately, from the vault root.

0. **Lock:** `mkdir .git/memory.lock` (atomic). If it fails, wait 30 seconds and retry. A lock
   older than 10 minutes is stale: check with `find .git/memory.lock -maxdepth 0 -mmin +10`,
   then `rmdir` it. Hold the lock through edit, commit, pull and push.
1. **Check:** `git status --porcelain <file>` for each file you will touch. If one has
   uncommitted changes you didn't make, release the lock, wait a minute, retry.
2. **Commit only your files, by path:**
   `git commit -m "docs: memory <what>" -- <your files>`
3. **Sync:** `git pull --rebase --autostash origin main && git push origin main`
4. **Release:** `rmdir .git/memory.lock`, even if a step failed.
5. **Never** stash, reset, force-push, `git add -A` or `git commit -a`. On a rebase conflict,
   `git rebase --abort`, release the lock and ask me.
