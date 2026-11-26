---
name: obsidian-vault
description: "Interact with Obsidian vaults via the CLI and vault-intelligence commands. Use when the user wants to read, write, search, analyze, or generate content from their Obsidian knowledge base. Covers CLI operations (file CRUD, search, sync, tasks, properties) and 26 vault-intelligence workflows (daily planning, idea discovery, content creation, strategic analysis)."
---

# Obsidian Vault: CLI & Vault Intelligence

Operate on Obsidian vaults from the command line and run vault-intelligence workflows that treat your knowledge base as a thinking partner.

## When to Use

- User wants to read, create, search, or modify notes in an Obsidian vault
- User asks to plan their day, close their day, or schedule from vault context
- User wants to analyze vault structure (clusters, orphans, gaps, contradictions)
- User wants to surface ideas, connections, or patterns from their notes
- User wants to generate content (essays, posts, learnings) grounded in vault data
- User wants to run strategic analysis (revenue, leverage, skill gaps) from vault evidence
- User asks about Obsidian CLI commands or syntax

## When NOT to Use

- User is working with a non-Obsidian markdown system (use standard file tools instead)
- User wants to configure Obsidian plugins or themes via the GUI
- User needs headless sync without the desktop app (use Obsidian Headless instead)
- The vault is not accessible from the current system

---

## Setup

### Prerequisites

1. Obsidian 1.12+ installed with CLI enabled (Settings > General > Command line interface)
2. CLI registered in your shell (the installer prompts for this)
3. Obsidian app must be running (CLI launches it automatically if not)

### CLI Alias

The CLI binary name varies by installation. Set an alias matching your system:

```bash
# Example: if your system installs it as obsidian.com
alias obsidian="obsidian.com"
```

All commands below use `obsidian` as the CLI name. Adjust to match your alias.

### Vault Targeting

Target a specific vault with `vault=<name>` or `vault=<id>`. It only works as the **first** parameter, right after `obsidian`; anywhere else it is ignored:

```bash
obsidian vault="My Vault" daily
obsidian vault="Work" search query="meeting"
```

If only one vault is open, the `vault=` parameter is optional.

---

## Vault Organization (Helton V2)

Notes are organized by **type** (what the knowledge IS), not by actionability (PARA). The vault uses a numbered type-based taxonomy:

| Folder | Contents | Examples |
|---|---|---|
| `_obsidian/` | Vault metadata, attachments, templates | Media files, Templater templates |
| `1_TECHNOLOGY/` | Specific technologies | Kubernetes, Active Directory, BGP |
| `2_TECHNIQUE/` | Executable techniques | Sourdough Starter, Spaced Repetition, Code Review |
| `3_RESEARCH/` | Exploration topics, breadcrumbs | Blog post notes, rabbit holes |
| `4_TOOL/` | Tool descriptions and usage | nmap, Burp Suite, tcpdump |
| `5_CONCEPT/` | Concepts (largest directory) | Cryptography, Authentication, Economics |
| `6_PROMPTS/` | AI prompt library | System prompts, analysis prompts |
| `7_PROJECTS/` | Active project containers | Courses, certifications, client work |
| `8_DAILY/` | Daily notes | 2026-04-30.md |
| `9_OPERATIONS/` | Meta-operational | Tasks, Calendar, Inbox, Context files |
| `99_OTHER/` | Miscellaneous | Items not fitting elsewhere |

## Frontmatter Schema

Every note uses a consistent YAML frontmatter schema:

```yaml
---
title: Note Title
date_created: YYYY-MM-DD
description: One-line summary
type: technology|technique|research|tool|concept|prompt|project|other
domain: work|study|career|personal|other
reference: "[[Related Note]]"
---
```

Technique notes can add domain-specific fields (for example a framework ID).
Project notes add: `status: active|paused|complete`.

This schema enables Obsidian Bases (database views), automated vault maintenance, and structured AI operations.

## Atomic Notes & Knowledge Gaps

**Atomic Notes V2**: One concept per note. Instead of "How to do prompt injection," create separate notes: `prompt injection` (technique), `indirect prompt injection` (technique), `input validation` (concept). Link them with `[[wikilinks]]`.

**Stub Notes**: Unresolved `[[wikilinks]]` (grey nodes in graph view) are intentional knowledge gap indicators. Clusters of stubs reveal areas needing study. Run `obsidian unresolved` to find them.

**Incoming Link Density**: Notes with many incoming links are foundational concepts. If they're thin, they need deepening. Run `obsidian backlinks file="Note"` to check.

**AI Usage**: Use AI for mass frontmatter updates and description generation. Do NOT use AI for bulk note generation, the value of a knowledge base comes from intentional synthesis, not token volume.

---

## CLI Quick Reference

> Full reference: [cli-reference.md](references/cli-reference.md)

### Core Syntax

```
obsidian <command> [parameters] [flags]
```

- **Parameters** take values: `file="Note Name"`, `query="search term"`
- **Flags** are boolean switches: `open`, `overwrite`
- **Multiline content**: in `content=`, `\n` becomes a newline and `\t` a tab, with no escape, so a backslash in the text (LaTeX `\theta`, a path like `C:\notes`) is corrupted. Write such content, or anything over about 4 KB, to the note file directly.
- **The CLI exits 0 even when a command fails**: read its output before reporting success.
- **Opening is opt-in**: pass `open` to open a note; there is no `silent` flag.
- **Basic syntax lives in the official `obsidian-cli` skill** (obsidianmd/obsidian-skills); this skill adds the vault workflows.
- **Targeting**: `file=<name>` (wikilink-style) or `path=<exact/path.md>` (from vault root)
- **Clipboard**: add `--copy` flag to copy output to clipboard

### Essential Commands

| Command | Example | Purpose |
|---------|---------|---------|
| `daily` | `obsidian daily` | Open today's daily note |
| `daily:read` | `obsidian daily:read` | Read today's daily note to stdout |
| `daily:append` | `obsidian daily:append content="- Task"` | Append to daily note |
| `read` | `obsidian read file="Project"` | Read a note by name |
| `create` | `obsidian create name="Note" content="..."` | Create a new note |
| `search` | `obsidian search query="keyword"` | Search the vault |
| `search:context` | `obsidian search:context query="keyword"` | Search with surrounding context |
| `backlinks` | `obsidian backlinks file="Note"` | Find notes linking to a note |
| `links` | `obsidian links file="Note"` | Find notes a note links to |
| `tags` | `obsidian tags` | List all tags |
| `tasks` | `obsidian tasks` | List all tasks |
| `orphans` | `obsidian orphans` | Notes with no incoming links |
| `deadends` | `obsidian deadends` | Notes with no outgoing links |
| `unresolved` | `obsidian unresolved` | Referenced but uncreated notes |
| `properties` | `obsidian properties file="Note"` | Read note properties |
| `eval` | `obsidian eval code="app.vault.getFiles().length"` | Run JavaScript in Obsidian |

### File Operations

```bash
obsidian create name="Note" content="Body" template="Template Name"
obsidian append file="Note" content="New content"
obsidian prepend file="Note" content="Top content"
obsidian move file="Note" to="Archive/"   # use move/rename, never mv, so links update
obsidian rename file="Old Name" name="New Name"
obsidian delete file="Note"
```

### Task Management

```bash
obsidian tasks                    # List all tasks
obsidian tasks daily              # Tasks in today's note
obsidian tasks file="Project"     # Tasks in a specific note
obsidian task toggle line=5 file="Note"  # Toggle task status
```

---

## Vault Intelligence Commands

These workflows use the CLI to perform deep analysis, planning, and content generation from your vault. Each command has a detailed reference file.

### Daily Operations

| Command | Purpose | Reference |
|---------|---------|-----------|
| `/context` | Build a full picture of who you are and what you're working on | [context.md](references/context.md) |
| `/today` | Generate a daily plan grounded in vault reality | [today.md](references/today.md) |
| `/close-day` | Review the day, capture learnings, flag unresolved items | [close-day.md](references/close-day.md) |
| `/schedule` | Schedule events using priorities and energy patterns from vault | [schedule.md](references/schedule.md) |
| `/7plan` | Reshape the next 7 days around what's most alive in your thinking | [7plan.md](references/7plan.md) |

### Vault Analysis

| Command | Purpose | Reference |
|---------|---------|-----------|
| `/map` | Topological view of vault clusters, themes, and relationships | [map.md](references/map.md) |
| `/backlinks` | Find missing links and wire new connections across the vault | [backlinks.md](references/backlinks.md) |
| `/trace` | Track how your thinking about an idea evolved over time | [trace.md](references/trace.md) |
| `/compound` | Ask the same question at different vault time periods | [compound.md](references/compound.md) |

### Idea Discovery

| Command | Purpose | Reference |
|---------|---------|-----------|
| `/emerge` | Find ideas strongly implied but never explicitly written | [emerge.md](references/emerge.md) |
| `/connect` | Surface unexpected bridges between unrelated domains | [connect.md](references/connect.md) |
| `/contradict` | Find places where you hold incompatible beliefs | [contradict.md](references/contradict.md) |
| `/drift` | Identify topics or commitments you've been quietly avoiding | [drift.md](references/drift.md) |
| `/challenge` | Argue against your current thinking using vault evidence | [challenge.md](references/challenge.md) |
| `/stranger` | Write a portrait of you as seen by someone who's never met you | [stranger.md](references/stranger.md) |

### Content Creation

| Command | Purpose | Reference |
|---------|---------|-----------|
| `/graduate` | Promote ideas buried in daily notes into standalone notes | [graduate.md](references/graduate.md) |
| `/ideas` | Generate new ideas from projects, interests, and open questions | [ideas.md](references/ideas.md) |
| `/learned` | Turn recent learnings into a polished post or essay | [learned.md](references/learned.md) |
| `/weekly-learnings` | Compile the week's insights into a writing-ready summary | [weekly-learnings.md](references/weekly-learnings.md) |
| `/xdaily` | Pull social media posts into relevant daily notes | [xdaily.md](references/xdaily.md) |
| `/xarticle` | Find writing topics by scanning for graph density and energy | [xarticle.md](references/xarticle.md) |

### Strategy

| Command | Purpose | Reference |
|---------|---------|-----------|
| `/make` | Identify ideas ready to materialize into public work | [make.md](references/make.md) |
| `/money` | Surface revenue opportunities and diagnose system issues | [money.md](references/money.md) |
| `/guests` | Derive interview subjects from active vault questions | [guests.md](references/guests.md) |
| `/leverage` | Identify high-impact skill domains for disproportionate breakthroughs | [leverage.md](references/leverage.md) |
| `/ghost` | Answer any question as the vault owner by reading their notes | [ghost.md](references/ghost.md) |

---

## Common Patterns

### Loading Context Before Any Command

Most vault-intelligence commands start by loading context. The standard pattern:

```bash
# Read core context files
obsidian read file="<Context-File-A>"
obsidian read file="<Context-File-B>"

# Read recent daily notes
obsidian daily:read
obsidian read path="8_DAILY/YYYY-MM-DD.md"

# Follow backlinks to discover connections
obsidian backlinks file="<Context-File-A>"

# Check vault structure
obsidian tags counts sort=count
obsidian orphans
obsidian deadends
obsidian unresolved
```

### Confidence Markers

Many workflows reference confidence markers in notes. The convention:

- `[solid]`: Well-established belief or fact
- `[evolving]`: Actively changing understanding
- `[hypothesis]`: Untested idea
- `[questioning]`: Actively doubting

### Writing Back to the Vault

```bash
# Append to today's daily note
obsidian daily:append content="## Analysis\n\nFindings here..."

# Create a new standalone note
obsidian create path="Essays/Graduated Idea.md" content="..."

# Update properties
obsidian property:set file="Note" property="status" value="reviewed"
```
