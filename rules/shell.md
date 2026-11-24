# Shell

- **No heredocs or here-strings** (two less-than signs in a row) in commands, commit messages
  included. They end up in shell history. Write files with the editor tool; feed input with a
  single `< FILE` redirect. Script files are exempt. Enforced by
  `claude/hooks/no-heredoc.py`.
- **`jq` for JSON.** Never `python -m json.tool` or ad hoc parsing.
- **`curl -I` for headers**, not `-o /dev/null -D -`.
- **Prefer dedicated tools** (read, search, edit) over shell equivalents when the agent has
  them.
- **Absolute paths** over `cd` chains.
- **Long-running commands** (dev servers, builds over two minutes) run in the background.
- **Scripts:** `#!/usr/bin/env bash` with `set -euo pipefail` for entry points; keep them
  portable across bash versions. On macOS, `/usr/bin/grep` has no `-P`: use Python or
  `grep -E` for anything a hook depends on.
