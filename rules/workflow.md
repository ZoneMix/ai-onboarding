# How a coding task runs

The loop for any change, from a one-line fix to a multi-day feature.

## 1. Understand

- Read the repo's `AGENTS.md` (or `CLAUDE.md`) first, then only the files the task touches.
- Find the existing pattern before inventing one: how errors, config, tests and logging are
  already done here.
- For anything bigger than a small fix, write a short plan: what changes, in which files, how
  you'll know it works. Agree it with the person when the goal itself is unclear; otherwise
  start.

## 2. Isolate

- **One branch per task,** named for the change (`fix/login-redirect`, `feat/export-csv`).
  Never commit straight to the default branch.
- **One worktree per parallel task.** When several tasks or agents run at once, give each its
  own `git worktree` folder (`<repo>-<task>` next to the main checkout) so nobody's
  uncommitted work collides.
- Keep the default branch's checkout clean; it is what you branch from and merge into.

## 3. Build

- Small, coherent commits, each one passing the checks. A reviewer should be able to read the
  history as a story.
- Write the test with the change, not after. A bug fix starts with a failing regression test.
- Update the docs and instruction files the change makes wrong, in the same commit.

## 4. Verify

- Run the project's full checks (format, lint, types, tests, build) before calling it done.
  Fix what your change broke; rerun.
- See it work for real: run the app, hit the endpoint, open the page in a browser at phone and
  desktop widths. Tests passing is necessary, not sufficient.
- Review your own diff (`git diff main...HEAD`) as if someone else wrote it. See `review.md`.

## 5. Hand off

- Open a pull request (see `github.md`) or report the branch, with what changed, why, and how
  you verified it.
- Name follow-ups once, plainly. Don't leave "TODO" in code without an owner.
- After merge, delete the branch and the worktree.
