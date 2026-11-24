# Obsidian

My Obsidian setup: a vault that doubles as shared memory for AI agents, the app settings I
use, and the skills agents use to work in it. The why is in `rules/obsidian.md`.

## What's here

| Path | What it is |
|---|---|
| `vault-starter/` | An empty vault: `AGENTS.md`, `0_MEMORY/` memory files, numbered folders, templates. |
| `config/.obsidian/` | App settings: appearance, core plugins, hotkeys, daily notes, templates, CSS snippets, and the list of community plugins. |
| `../skills/obsidian-*`, `../skills/build-study-guide` | Agent skills for working in a vault. |

`./setup.sh --only obsidian --vault <folder>` installs the skills, creates the vault (or adds
the missing pieces to an existing one, never overwriting a note) and copies the settings.

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

Also worth installing for agents: the official
[obsidian-skills](https://github.com/kepano/obsidian-skills) marketplace for Claude Code
(`/plugin marketplace add kepano/obsidian-skills`).

## Fonts

`snippets/helton-fonts.css` loads Atkinson Hyperlegible Next from Google Fonts and expects
JetBrainsMono Nerd Font installed locally for code.

Some snippets are adapted from other authors (named in each file's header comment) and stay under their original licenses.
