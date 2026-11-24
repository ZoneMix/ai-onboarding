# GitHub, pull requests and CI

## Pull requests

- **Small and single-purpose.** One concern per PR; split refactors from behavior changes.
- **The body says:** what changed, why, how it was verified (commands run, what you looked at),
  and anything the reviewer should check closely. Follow the repo's PR template if it has one.
- **Draft until green.** Mark ready for review once checks pass and you've reviewed your own
  diff.
- **Use the `gh` CLI** for PRs, issues, checks and reviews (`gh pr create`, `gh pr checks`,
  `gh pr view --comments`).
- **Agents don't merge their own PRs** and don't enable auto-merge unless the person asked.
- **Address every review comment:** fix it, or reply with why not. Push fixes as new commits;
  never force-push a branch under review.

## CI

- **CI runs the same commands as local checks,** so a green laptop means a green CI. List
  them in `AGENTS.md`.
- **Pin every action to a full commit SHA** with the version in a comment:
  `uses: actions/checkout@<40-char-sha> # v4.2.2`. Tags can be moved; SHAs can't.
- **Least privilege:** set `permissions:` at the top of every workflow (`contents: read` by
  default) and widen per job only where needed.
- **Treat workflows as code that runs with your secrets.** Review workflow changes like
  security changes. A self-hosted runner executes whatever a workflow says, often with a
  Docker socket; keep it off repos that take outside contributions, or don't use one.
- **A local pre-push hook** can run the test suites a push touches (all of them for a new
  branch). Clear `GIT_DIR` and other `GIT_*` variables before running tests from a hook, or
  tests that build throwaway repos will write into the real one.

## Dependencies

- **Automate the proposals:** Dependabot or Renovate opens update PRs, grouped (minor and
  patch together, majors alone), including updates for the pinned action SHAs.
- **Wait before taking a release.** A minimum release age of a few days catches the bad
  releases that get yanked.
- **Auto-merge comes last.** Turn it on only after branch protection, required checks and a
  scan gate are in place, and only for changes the gate can prove are pin-only.

## Releases

- Tag `vX.Y.Z`, let a workflow build and publish, then pin the result by digest where it
  deploys (see `deploy.md`). Keep a `CHANGELOG.md` and call out breaking changes.

## Repos and mirrors

- **One source of truth per repo.** If a repo is mirrored elsewhere, push to the primary and
  let the mirror follow.
- **Open-sourcing a private project:** make a snapshot fork with the private parts stripped,
  run an independent sanitizer pass and a secret scan, then cherry-pick fixes between the two
  by hand. Never share code paths that could leak the private version.
- **Before anything goes public:** `gitleaks git .` over the full history, not just the
  working tree.
