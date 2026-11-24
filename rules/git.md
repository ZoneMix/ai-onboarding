# Git

- **Commit format:** `<type>: <description>`, where type is one of `feat`, `fix`,
  `refactor`, `docs`, `test`, `chore`, `perf`, `ci`. Lowercase, imperative, no trailing
  period.
- **Stage specific files.** Never `git add -A`, `git add --all` or `git add .`. Prefer a
  path-limited commit: `git commit -m "<type>: <description>" -- <files>`.
- **Never amend** unless asked. **Never force-push.** **Never `git reset --hard`.**
- **Never skip hooks** (`--no-verify`, `-n`).
- **Branch before committing** when on the default branch. Commit freely on your own branch;
  push it and open a PR when the task calls for one; ask before pushing to a shared branch.
- **Merge locally with `--no-ff`** when you merge yourself, so the branch stays visible in
  history, then push to a branch that already exists.
- **Multi-line messages** use repeated `-m` flags, not a heredoc (see `shell.md`).
- **One owner per change.** When several agents share a checkout, the owner of a file commits
  it; others hand findings over instead of committing.
