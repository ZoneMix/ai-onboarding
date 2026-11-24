# Several agents at once

For running more than one agent on the same machine or checkout.

- **One writer per file.** The hand-off names who owns each shared file. Others don't touch
  it; they send findings to the owner.
- **The owner commits.** Don't commit shared changes while other writers are active.
- **Lock shared targets.** A job that changes a host or a working directory takes a lock
  first, and a second job against the same target waits or refuses.
- **Stop jobs through their tool,** with a reason, never with `kill` on a hand-picked pid.
- **Only message an idle agent.** A prompt sent while a human is typing merges with their
  text. If an agent is waiting on a human approval, tell the human; never answer it for them.
- **Don't rearrange someone else's workspace.** No focusing, closing, restarting or changing
  the model of another agent's session.
- **Don't spawn background agents casually.** Each one can carry its own tool servers and
  outlive the agent that started it. Ask before a large fan-out, and make sure every agent
  you start has exited (and its child processes with it) before you finish.
- **Delegate bounded work** (a parser, a test file, one script) to a smaller model; keep design
  decisions with the orchestrating agent.
- **Long reports go to a file** the other agent can read; keep prompts short.
