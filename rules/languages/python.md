---
paths: ["**/*.py", "**/pyproject.toml", "**/ruff.toml"]
---
# Python

- **Lint with ruff** in CI and before commit. Pin the rule set with an explicit `select` so a
  ruff upgrade doesn't silently widen it, and add `S110` (bare `except: pass`) so swallowed
  errors get flagged. Use the formatter only if the repo already does; never mass-reformat.
- **Set `target-version`** to the oldest Python the code really runs on, and say why in a
  comment.
- **Money and quantities use `decimal.Decimal`,** never `float`. Parse from strings, not
  floats, and round once at the end with an explicit rounding mode.
- **Stdlib first.** Reach for a dependency only when the stdlib version would be clearly
  worse. Pin what you add.
- **Exceptions:** catch the narrowest type you expect. A deliberate ignore carries a comment
  saying why (`# noqa: S110  best-effort cleanup`).
- **Tests with pytest,** one `tests/` folder per component. Tests that build temp repos or
  files use `tmp_path` and never touch the real working tree.
- **Scripts:** `#!/usr/bin/env python3`, a `main()` that returns an exit code, and
  `sys.exit(main())`. Run anything that reads downloaded or untrusted files with `python3 -I`.
- **Environments:** one virtualenv per project (`uv` or `pyenv`), never the system Python.
