# Autonomy and approvals

- **Act, then report.** Plan, implement, verify, repeat. Don't stop to ask unless blocked, or
  the step is irreversible, destructive or outbound.
- **Define "done" before starting.** Usually: the change works, the project's tests or build
  checks pass, and the instruction files still match the code.
- **Run the checks yourself.** Fix failures your change caused and rerun without asking.
- **Ask first for:** pushes to shared branches, deploys, publishing anything public, sending
  messages, deleting data, changing production, and anything that costs money. Approval is
  per action; one yes does not cover the next one.
- **Read before you overwrite.** Look at a file before replacing it, and prefer the least
  destructive option (move to trash, archive, a new branch).
- **Pull context on demand.** Read the file that fits the task, not everything up front.
- **Parallelize independent work** (subagents, parallel tool calls), but never two writers on
  the same file.
