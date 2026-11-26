# Obsidian

My Obsidian setup: two git-backed vaults, one that doubles as shared memory for AI agents and one for deep work knowledge, the app settings I use, and the skills agents use to work in them. The rules agents follow are in `rules/obsidian.md`.

## How my two vaults work

I keep two vaults because they answer different questions. The life vault holds everything I study, read and plan, my daily notes, and the memory every agent loads before it touches anything. It is organized by area of life, with numbered top folders and a map of content for each. The work vault holds security knowledge, and there the question is always what a thing is: a technology, a technique under its MITRE tactic, a tool, a concept. Notes start inside the project that produced them and graduate into those type folders once they stand on their own. Mixing the two would bury a reading note under Kerberos write-ups, and the work vault has rules of its own about course material and client data.

Agents work in both, and the main lesson of running a dozen of them against one vault is that their output has to live apart from mine. Each vault has a root `AGENTS.md` that every agent reads first. The life vault has an `_agents/` folder that is theirs: run reports, audits, queues, learning logs, raw research, transcripts, build scripts and the generated daily brief all go there, and Obsidian hides it from search and the graph. What I read stays in the numbered folders as short, linted notes with the same five frontmatter fields, so the vault still reads like something I wrote. When an agent finds something worth my time, it writes a short note in the right place and links into `_agents/` for the detail.

Git holds it all together. Every agent commits its own files the moment it finishes an edit, takes a lock folder so two writers never collide, and pushes right away. A pre-commit hook scans every commit for secrets and oversized files, and a small evening job pushes anything that was committed but missed, and tells me when something is stuck. If an agent ever wrecks a note, the history is one revert away.

## What's here

| Path | What it is |
|---|---|
| `vault-starter/` | The life vault: `AGENTS.md`, `0_MEMORY/` memory files, the `_agents/` workspace, numbered folders, templates, the pre-commit hook and lint config. |
| `work-vault-starter/` | The work vault: type folders (technology, technique by MITRE tactic, research, tool, concept, prompts, projects), its `AGENTS.md`, templates, hook and lint config. |
| `scripts/` | `vault-daily-push`, the evening push backstop, with launchd and systemd schedules. |
| `config/.obsidian/` | App settings: appearance, core plugins, hotkeys, daily notes, templates, CSS snippets, and the list of community plugins. |
| `../skills/obsidian-*`, `../skills/build-study-guide` | Agent skills for working in a vault. |

`./setup.sh --only obsidian --vault <folder>` installs the skills, creates the life vault (or adds the missing pieces to an existing one, never overwriting a note) and copies the settings. Add `--work-vault <folder>` for the work vault. In a vault that is already a git repo it offers to turn on the pre-commit hook.

## Community plugins

The settings list these plugins in `community-plugins.json`; Obsidian offers to install them
from its community browser the first time you open the vault. Plugin code isn't bundled here,
so you always get the current release from its author.

| Plugin | What I use it for |
|---|---|
| Obsidian Git | Commits and syncs the vault on a timer; agents commit their own edits. |
| Templater | The templates in `_obsidian/templates`. |
| Calendar | Jump to daily notes. |
| Homepage | Opens `Home.md` on launch. |
| Linter | Keeps frontmatter and formatting consistent on save. |
| Tag Wrangler | Rename and merge tags. |
| Spaced Repetition | Flashcards for study notes. |
| Reminder | Due dates on tasks. |
| Table Editor, Text Format, Smart Typography, URL into selection | Editing comfort. |
| Recent Files, Settings Search | Navigation. |
| Pandoc, Print | Export to PDF and Word. |
| Bible Reference | Scripture lookups in study notes. Drop it if you don't need it. |

Install the official [obsidian-skills](https://github.com/obsidianmd/obsidian-skills) for agents (Obsidian markdown, Bases, JSON Canvas, the CLI, Defuddle). They are not bundled here, so you get the current release:

```bash
claude plugin marketplace add obsidianmd/obsidian-skills
claude plugin install obsidian@obsidian-skills
```

Other agents: `npx skills add https://github.com/obsidianmd/obsidian-skills`, or copy `plugins/obsidian/skills/*` into that agent's skills folder.

Settings worth changing in the app: Files and links, Use [[Wikilinks]] on and Excluded files `_agents/`; Core plugins, Properties on; Linter, lint on save.

## Fonts

`snippets/helton-fonts.css` loads Atkinson Hyperlegible Next from Google Fonts and expects
JetBrainsMono Nerd Font installed locally for code.

Some snippets are adapted from other authors (named in each file's header comment) and stay under their original licenses.
