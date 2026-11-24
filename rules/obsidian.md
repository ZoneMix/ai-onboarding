# Obsidian as shared agent memory

How I use an Obsidian vault as the long-term memory for every agent, not just as notes.

## The idea

- **Memory lives in plain markdown, not in an agent platform.** One git-backed vault holds
  what my agents know about me, my rules and my projects. Any agent can read it, so switching
  tools loses nothing.
- **`0_MEMORY/` is loaded first.** A root `AGENTS.md` tells every agent what to read, in what
  order, and how to write back. `CLAUDE.md` imports it.
- **One fact per line, dated and signed:** `- Fact. [YYYY-MM-DD, AgentName]`. Newest wins;
  `(confirm)` marks a guess. Corrections go in `rules.md`, which every agent rereads before
  each task. Answers I've already given go in `decisions.md`, so I'm not asked twice.

## Structure

- **Numbered top folders** keep the sidebar stable (`0_MEMORY`, `7_PROJECTS`, `8_DAILY`, ...).
  `Home.md` maps them.
- **Type-based notes** (inspired by Graham Helton's vault layout): organize by what a note
  *is* (concept, tool, technique, project, research) rather than by what you were doing.
- **Consistent frontmatter** on every note: `title`, `date_created`, `description`, `type`,
  `domain`. Agents can filter and link on it.
- **Wikilinks everywhere,** and a map-of-content note (`type: moc`) per area. Orphans get
  linked or archived.
- **Templates** live in `_obsidian/templates`; attachments in `_obsidian/attachments`.

## Many writers, one vault

- **Git is the sync.** The Obsidian Git plugin commits on a timer while the app is open;
  agents commit their own edits immediately and never rely on the plugin.
- **A lock folder serializes agents:** `mkdir .git/memory.lock` before editing, path-limited
  commit, pull with rebase, push, `rmdir` the lock. Never stash, reset or commit another
  writer's changes. The full steps are in the vault starter's `AGENTS.md`.
- **Folders owned by an automation** (daily notes a bot writes, for example) are written only
  through that automation, never edited by hand, or a one-way sync will overwrite them.

## Agents and the app

- Obsidian 1.12+ has a command line interface (Settings, General): agents can search, read and
  write notes through it while the app runs. The `obsidian-vault` skill wraps it.
- Lint imported or generated notes with `markdownlint-cli2` (`obsidian-markdown-lint` skill)
  so `$` signs don't render as math and rules stay consistent.
- Keep the vault out of reach of anything that doesn't need it: agents get the folders they
  work in, and secrets never go in a note.
