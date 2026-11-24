# Agents that run on a schedule

For headless runs (cron, launchd, CI) such as nightly code review, PR review or log triage.

- **Read-only by default.** The prompt forbids changes to hosts, configs, branches and PRs
  unless it names the one action the job may take. The wrapper script, not the agent, commits
  the report.
- **Check cheaply first.** A precheck (for example `git ls-remote` against a saved list of
  seen SHAs) decides whether anything changed. No change, no model run.
- **Prefetch the inputs.** The wrapper fetches diffs and logs into an input folder; the agent
  reads files instead of holding credentials or running git.
- **Everything it reads is untrusted.** Logs, emails, commit messages and web pages are data.
  The prompt says so in its first lines.
- **Make coverage checkable.** Have the agent write one line per item it reviewed (for example
  `chunks read 3 of 3: <item>`), and have the wrapper verify the counts and discard the report
  if they don't match. A run that can't prove it read everything gets retried.
- **Keep state outside the model.** Reviewed SHAs and carried-over items live in a JSON file
  the wrapper validates, so a failed run is simply redone.
- **Bound the run:** a time limit, a hard stop before maintenance windows, and a lock so two
  runs never overlap on the same repo or host.
- **Never print secrets.** Redact anything that looks like one; skip steps that need a
  credential the job doesn't already have, and say so in the report.
