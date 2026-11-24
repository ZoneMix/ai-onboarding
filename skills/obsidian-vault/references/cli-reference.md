# Obsidian CLI: Full Command Reference

Complete reference for the Obsidian command-line interface. Requires Obsidian 1.12+ with CLI enabled.

## Core Concepts

### Parameters vs Flags

- **Parameters** take values: `parameter=value` or `parameter="value with spaces"`
- **Flags** are boolean switches: `open`, `overwrite`
- **Multiline content**: use `\n` for newlines, `\t` for tabs

### File Targeting

- `file=<name>`: resolves by filename (wikilink-style, no extension needed)
- `path=<path>`: exact path from vault root (e.g., `path="8_DAILY/2026-03-17.md"`)
- `vault=<name>` or `vault=<id>`: target a specific vault

### Output

- `--copy` flag copies output to clipboard
- Most read commands output to stdout for piping

---

## General

| Command | Description |
|---------|-------------|
| `help` | Show help |
| `version` | Show Obsidian version |
| `reload` | Reload the vault |
| `restart` | Restart Obsidian |

## File Operations

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `file` | Show file info | `file=<name>` or `path=<path>` |
| `files` | List files | `folder=<name>`, `sort=<field>` |
| `folder` | Show folder info | `folder=<name>` |
| `folders` | List folders | |
| `open` | Open a note in Obsidian | `file=<name>` or `path=<path>` |
| `create` | Create a new note | `name=<name>`, `content=<text>`, `template=<name>`, `folder=<name>` |
| `read` | Read note content to stdout | `file=<name>` or `path=<path>` |
| `append` | Append content to a note | `file=<name>`, `content=<text>` |
| `prepend` | Prepend content to a note | `file=<name>`, `content=<text>` |
| `move` | Move a note to a folder | `file=<name>`, `folder=<name>` |
| `rename` | Rename a note | `file=<name>`, `name=<new-name>` |
| `delete` | Delete a note | `file=<name>` or `path=<path>` |

## Daily Notes

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `daily` | Open today's daily note | |
| `daily:path` | Show path to today's daily note | |
| `daily:read` | Read today's daily note to stdout | |
| `daily:append` | Append to today's daily note | `content=<text>` |
| `daily:prepend` | Prepend to today's daily note | `content=<text>` |

## Random & Unique Notes

| Command | Description |
|---------|-------------|
| `random` | Open a random note |
| `random:read` | Read a random note to stdout |
| `unique` | Create a unique (Zettelkasten-style) note |

## Search & Links

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `search` | Search the vault | `query=<text>`, `path=<folder>` |
| `search:context` | Search with surrounding context | `query=<text>`, `path=<folder>` |
| `search:open` | Search and open result | `query=<text>` |
| `backlinks` | Notes linking TO a note | `file=<name>` |
| `links` | Notes a note links TO | `file=<name>` |
| `unresolved` | Referenced but uncreated `[[links]]` | |
| `orphans` | Notes with no incoming links | |
| `deadends` | Notes with no outgoing links | |

## Organization

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `outline` | Show note heading structure | `file=<name>` |
| `tags` | List all tags in vault | `counts`, `sort=count` |
| `tag` | List notes with a specific tag | `tag=<name>` |
| `aliases` | List aliases | `file=<name>` |
| `properties` | Show note properties | `file=<name>` |
| `property:set` | Set a property value | `file=<name>`, `property=<key>`, `value=<val>` |
| `property:remove` | Remove a property | `file=<name>`, `property=<key>` |
| `property:read` | Read a property value | `file=<name>`, `property=<key>` |

## Task Management

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `tasks` | List tasks | `file=<name>`, `daily`, `total` |
| `task` | Manage a task | `toggle`, `done`, `todo`, `status=<text>`, `line=<n>`, `file=<name>` |

## Sync

| Command | Description |
|---------|-------------|
| `sync` | Trigger sync |
| `sync:status` | Show sync status |
| `sync:history` | Show sync history |
| `sync:read` | Read a synced version |
| `sync:restore` | Restore a synced version |
| `sync:open` | Open sync history |
| `sync:deleted` | List deleted synced files |

## File History

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `diff` | Show diff between versions | `file=<name>` |
| `history` | Show file history | `file=<name>` |
| `history:list` | List history entries | `file=<name>` |
| `history:read` | Read a historical version | `file=<name>` |
| `history:restore` | Restore a historical version | `file=<name>` |
| `history:open` | Open history view | `file=<name>` |

## Bases

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `bases` | List bases | |
| `base:views` | List views in a base | `base=<name>` |
| `base:create` | Create a base | `name=<name>` |
| `base:query` | Query a base | `base=<name>`, `query=<text>` |

## Bookmarks

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `bookmarks` | List bookmarks | |
| `bookmark` | Manage bookmarks | `file=<name>` |

## Publish

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `publish:site` | Show publish site info | |
| `publish:list` | List published notes | |
| `publish:status` | Show publish status | `file=<name>` |
| `publish:add` | Publish a note | `file=<name>` |
| `publish:remove` | Unpublish a note | `file=<name>` |
| `publish:open` | Open published note | `file=<name>` |

## Plugins & Themes

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `plugins` | List all plugins | |
| `plugins:enabled` | List enabled plugins | |
| `plugins:restrict` | Toggle restricted mode | |
| `plugin` | Show plugin info | `plugin=<id>` |
| `plugin:enable` | Enable a plugin | `plugin=<id>` |
| `plugin:disable` | Disable a plugin | `plugin=<id>` |
| `plugin:install` | Install a plugin | `plugin=<id>` |
| `plugin:uninstall` | Uninstall a plugin | `plugin=<id>` |
| `plugin:reload` | Reload a plugin | `plugin=<id>` |
| `themes` | List themes | |
| `theme` | Show current theme | |
| `theme:set` | Set theme | `theme=<name>` |
| `theme:install` | Install a theme | `theme=<name>` |
| `theme:uninstall` | Uninstall a theme | `theme=<name>` |
| `snippets` | List CSS snippets | |
| `snippets:enabled` | List enabled snippets | |
| `snippet:enable` | Enable a snippet | `snippet=<name>` |
| `snippet:disable` | Disable a snippet | `snippet=<name>` |

## Interface

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `workspace` | Show current workspace | |
| `workspaces` | List workspaces | |
| `workspace:save` | Save workspace | `name=<name>` |
| `workspace:load` | Load workspace | `name=<name>` |
| `workspace:delete` | Delete workspace | `name=<name>` |
| `tabs` | List open tabs | |
| `tab:open` | Open a tab | `file=<name>` |
| `recents` | List recently opened files | |
| `command` | Run a command by ID | `command=<id>` |
| `commands` | List all commands | |
| `hotkey` | Show hotkey for a command | `command=<id>` |
| `hotkeys` | List all hotkeys | |

## Developer Tools

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `devtools` | Open developer tools | |
| `dev:debug` | Toggle debug mode | |
| `dev:cdp` | Chrome DevTools Protocol | |
| `dev:errors` | Show error log | |
| `dev:screenshot` | Take a screenshot | |
| `dev:console` | Run console command | |
| `dev:css` | Inspect CSS | |
| `dev:dom` | Inspect DOM | |
| `dev:mobile` | Toggle mobile emulation | |
| `eval` | Execute JavaScript in Obsidian | `code=<js>` |

## Utilities

| Command | Description | Key Parameters |
|---------|-------------|----------------|
| `web` | Open a URL | `url=<url>` |
| `wordcount` | Word count for a note | `file=<name>` |
| `templates` | List templates | |
| `template:read` | Read a template | `template=<name>` |
| `template:insert` | Insert a template into a note | `template=<name>`, `file=<name>` |

---

## TUI Keyboard Shortcuts

When using the interactive TUI mode:

| Category | Action | Key |
|----------|--------|-----|
| Navigation | Move cursor | `Left`/`Right` |
| Navigation | Start/end of line | `Ctrl+A` / `Ctrl+E` |
| Navigation | Word backward/forward | `Alt+B` / `Alt+F` |
| Editing | Delete to start of line | `Ctrl+U` |
| Editing | Delete to end of line | `Ctrl+K` |
| Editing | Delete word backward | `Ctrl+W` or `Alt+Backspace` |
| Autocomplete | Accept suggestion | `Tab` or `Right` |
| Autocomplete | Previous suggestion | `Shift+Tab` |
| Autocomplete | Next suggestion | `Down` |
| History | Previous command | `Up` or `Ctrl+P` |
| History | Next command | `Down` or `Ctrl+N` |
| History | Reverse search | `Ctrl+R` |
| Other | Execute | `Enter` |
| Other | Undo | `Escape` |
| Other | Clear screen | `Ctrl+L` |
| Other | Exit | `Ctrl+C` or `Ctrl+D` |

## Platform Notes

- **macOS**: CLI registration adds to `~/.zprofile`
- **Linux**: Registration creates symlinks
- **Windows**: Uses a terminal redirector
- Obsidian app must be running (auto-launches if not)
- For headless sync without desktop app, use Obsidian Headless
