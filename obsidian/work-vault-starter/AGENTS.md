---
title: AGENTS
description: Instructions for any AI agent working in this security knowledge vault.
type: reference
domain: other
---
# AGENTS

A security knowledge vault: pentesting, red teaming, certifications, tools, techniques and engagement notes. Personal notes live in a separate life vault with its own `AGENTS.md`. A folder's own `AGENTS.md` wins over this file. `CLAUDE.md` imports this one.

## Layout

Notes are filed by what the knowledge is, not by the project that produced it (a type-based taxonomy, after Graham Helton's vault):

| Folder | Holds |
| --- | --- |
| `1_TECHNOLOGY/` | Platforms, protocols and products studied as subjects (Kerberos, Kubernetes) |
| `2_TECHNIQUE/<MITRE tactic>/` | Attacker or defender methods (Kerberoasting under Credential Access) |
| `3_RESEARCH/` | Open research topics, training labs, cheatsheets |
| `4_TOOL/` | One note per tool |
| `5_CONCEPT/` | Cross-cutting ideas and the maps of content; `Cybersecurity.md` is the main map |
| `6_PROMPTS/` | Prompt library |
| `7_PROJECTS/` | Project containers: cert study, engagements, code, lab builds |
| `9_OPERATIONS/` | Context files and operational notes |
| `99_OTHER/` | Anything else |
| `_obsidian/` | `templates/` and `attachments/` |

`Home.md` is the homepage. Atomic notes graduate out of project folders into the type folders as they mature. Working files for a project (raw module dumps, research logs, `working/` folders) stay inside that project's folder, or in a nested repo.

## Note conventions

- Frontmatter on every note: `title`, `date_created`, `description`, `type`, `domain`, `reference`. Techniques add `mitre_id` and `mitre_tactic`; tools add `category`; project notes add `status` (active, paused, complete). Domains: redteam, blueteam, career, personal, other.
- Templates: `_obsidian/templates/(Templates) <Type>.md`. Before writing a note, read one or two existing notes in the destination folder and match their real shape. Tool notes open with `## Cheatsheet` and end with `## See Also`.
- Links: Obsidian `[[wikilinks]]` for anything in the vault, never markdown links or relative paths. No `#` or `:` in filenames.
- Stubs: an unresolved `[[wikilink]]` marks a knowledge gap on purpose. Do not delete them, and do not create a stub note until three or more notes point at it.
- One concept per note. A new tool or technology note is also added under the right heading of `5_CONCEPT/Cybersecurity.md`.
- Code fences are language-tagged and closed. Wrap text containing `$` in backticks, or Obsidian renders it as math.
- Syntax reference: the official [obsidian-skills](https://github.com/obsidianmd/obsidian-skills) (`obsidian-markdown`, `obsidian-cli`).

## Writing rules

- No em dashes or middle dots in new text.
- Synthesize in your own words; never copy licensed course text. Commands, flags and payload strings are fine.
- Every command, flag, version or CVE id stated as fact traces to a source you checked. Mark the rest "(unverified)".
- Safe proof of concept only: `id` for RCE, a benign `SELECT` for SQLi, `alert(1)` for XSS.
- Additions to an existing note are additive: keep what is there, append a dated block with its source.

## Git: commit often, push every day

- The vault root is a git repo. The Obsidian Git plugin commits on a timer, but only while the app is open; commit your own edits path-limited straight away so they land under a meaningful message.
- Commit after each logical edit and push after each commit (`git pull --rebase --autostash origin main && git push origin main`). Never end a session with your own changes uncommitted. A daily backstop (`vault-daily-push`) pushes committed work that was missed; it never commits for you.
- The tracked hook `.githooks/pre-commit` (`git config core.hooksPath .githooks`) runs gitleaks on every commit and blocks files over 10 MB. Never bypass it.
- Project folders under `7_PROJECTS/` may be nested repos ignored by the root. Check with `git -C <folder> rev-parse --show-toplevel` and commit in the repo that owns the file.
- Commit format `<type>: <description>`. Never `git add -A`, never amend or force-push, never push course material or client data to a public remote.
- Never read out or commit secrets: cookies, tokens, keys, `.env` files.
