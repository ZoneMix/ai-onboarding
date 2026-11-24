# Autonomy and approvals

- **Act, then report.** Plan, implement, verify, repeat. Don't stop to ask unless blocked, or
  the step is irreversible, destructive or outbound.
- **Define "done" before starting.** Usually: the change works, the project's tests or build
  checks pass, and the instruction files still match the code.
- **Run the checks yourself.** Fix failures your change caused and rerun without asking.
- **Keep going through a plan.** Once a plan is agreed, build slice after slice and report;
  don't stop to ask whether to start the next one.
- **Ask first for:** pushes to shared branches, deploys, publishing anything public, sending
  messages, deleting data, changing production, and anything that costs money. Approval is
  per action; one yes does not cover the next one. The exception is a standing approval
  written in the project's own instructions (for example "commit, push and deploy without
  asking"); follow it there and nowhere else.
- **"Keep X" means keep X.** When told to stick with an existing design, file or approach, open
  it and make only the changes named. Don't reinterpret, restyle or "elevate" it.
- **Read before you overwrite.** Look at a file before replacing it, and prefer the least
  destructive option (move to trash, archive, a new branch).
- **Pull context on demand.** Read the file that fits the task, not everything up front.
- **Parallelize independent work** (subagents, parallel tool calls), but never two writers on
  the same file.
- **Clean up what you start.** Long autonomous sessions can exhaust a machine's memory. Run one
  dev server at a time and stop the old one before starting another; close headless browsers
  after each check; don't leave `nohup` or background processes behind. Prefer a container
  with a memory limit over an unbounded dev server on the host.
