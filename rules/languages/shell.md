---
paths: ["**/*.sh", "**/*.bash", "**/*.zsh", "**/.githooks/*"]
---
# Shell scripts

- **`#!/usr/bin/env bash`** and `set -euo pipefail` in entry points. Scripts that are sourced
  inherit the caller's options and set none of their own.
- **`shellcheck` clean.** A disabled check carries a comment saying why.
- **Portable to bash 3.2,** the version macOS ships: no associative arrays, no `mapfile`, no
  `${var,,}`. Read lines with `while IFS= read -r`.
- **Quote every expansion** unless word splitting is the point, and say so when it is.
- **No heredocs or here-strings** in commands an agent runs (see `../shell.md`); inside
  script files they're fine.
- **`grep -E` or Python** for anything a hook or script depends on; macOS `/usr/bin/grep`
  has no `-P`.
- **Explicit failure:** check the result of every step that can fail, and print a reason
  before exiting non-zero. `|| true` only with a comment saying why the failure is expected.
- **Destructive steps** (`rm -rf`, `mv` over files) work on paths built from known variables,
  never from unvalidated input, and back up before replacing.
