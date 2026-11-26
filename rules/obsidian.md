# Obsidian as shared agent memory

How I use Obsidian vaults as the long-term memory for every agent, not just as notes.

## The idea

- **Memory lives in plain markdown, not in an agent platform.** A git-backed vault holds what my agents know about me, my rules and my projects. Any agent can read it, so switching tools loses nothing.
- **`0_MEMORY/` is loaded first.** A root `AGENTS.md` tells every agent what to read, in what order, and how to write back. `CLAUDE.md` imports it.
- **One fact per line, dated and signed:** `- Fact. [YYYY-MM-DD, AgentName]`. Newest wins; `(confirm)` marks a guess. Corrections go in `rules.md`, which every agent rereads before each task. Answers I've already given go in `decisions.md`, so I'm not asked twice.

## Two vaults, two shapes

- **A life vault** (study, reading, home, projects, daily notes, the agent memory) is organized by area: numbered top folders, a map of content per area, PARA and Zettelkasten habits blended (inspired by CyanVoxel's vault).
- **A work vault** (security knowledge) is organized by type: technology, technique by MITRE tactic, research, tool, concept, prompts, projects (Graham Helton's model). A note says what the knowledge is, not which project produced it.
- They stay separate because the work notes go deep and the rules differ (course material, client data). They cross-link with `obsidian://` links. Each has its own `AGENTS.md`.

## Agents get their own side of the vault

- **Human folders are for reading.** Every note there is short, linted Obsidian markdown with five frontmatter fields (`title`, `date_created`, `description`, `type`, `domain`), wikilinks and one H1.
- **`_agents/` is the agents' workspace:** run reports, audits, queues, learning logs, generated feeds (the daily brief, news), raw research, transcripts and project build trees. Obsidian hides it from search and the graph; links into it still open. An agent's own tracking never lands in a human folder; when its work produces something worth reading, it writes a short note there and links into `_agents/` for the detail.
- **Bot sections stay out of daily notes.** A bot that writes a daily brief writes it to `_agents/feeds/daily/<day>.md`; the daily note holds my own sections and one link.

## Many writers, one vault

- **Git is the sync.** Commit after every logical edit, push after every commit. The Obsidian Git plugin commits on a timer but only while the app is open, so agents never rely on it.
- **A daily backstop** (`obsidian/scripts/vault-daily-push`) pushes committed work that was missed and reports anything stuck. It never commits for anyone.
- **A tracked pre-commit hook** (`.githooks/pre-commit`) runs on every commit, from any agent or the plugin: gitleaks, a 10 MB cap, and no scratch files outside `_agents/`.
- **A lock folder serializes agents:** `mkdir .git/memory.lock` before editing, path-limited commit, pull with rebase, push, `rmdir` the lock. Never stash, reset or commit another writer's changes. The full steps are in each starter's `AGENTS.md`.
- **Folders owned by an automation** (daily notes a bot writes, for example) are written only through that automation.

## Agents and the app

- Use the official [obsidian-skills](https://github.com/obsidianmd/obsidian-skills) as the syntax reference: `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `obsidian-cli`, `defuddle`. In Claude Code: `claude plugin marketplace add obsidianmd/obsidian-skills`, then `claude plugin install obsidian@obsidian-skills` (user scope). Update with `claude plugin update obsidian@obsidian-skills`.
- The `obsidian` CLI (Obsidian 1.12+, Settings, General) lets agents search and read while the app runs. Put `vault=` first, write long or backslash-heavy content to the file directly, and read the output: the CLI exits 0 even on failure.
- Lint human notes with `markdownlint-cli2` (config at the vault root, skipping `_agents/`) and turn on the Linter plugin's lint on save, so `$` signs don't render as math and formatting stays consistent.
- Set Obsidian to wikilinks (Files and links, Use [[Wikilinks]]) and turn on the Properties core plugin.
- Keep the vault out of reach of anything that doesn't need it, and never put a secret in a note.
