# Code

- **Immutable data across function boundaries.** Return new objects; local accumulators are
  fine.
- **Small units.** Files around 200 to 400 lines; functions under 50.
- **Explicit errors.** Handle errors at every level. Never swallow one silently; a deliberate
  ignore carries a comment that says why. A linter rule (for example ruff `S110`) keeps this
  honest.
- **No hardcoded values.** Constants or config, never magic numbers or inline hosts.
- **Validate at system boundaries:** user input, files, the network, other processes.
- **Lean by default.** Only write code a current caller or user-visible behavior needs. Reuse
  the existing helper before writing a new one. No speculative options, single-implementation
  interfaces, or test-only seams. See `skills/lean-audit/`.
- **Tests protect contracts.** Each test names the behavior it guards and fails on a credible
  regression. A bug fix gets one regression test that fails before the fix.
- **Comments explain why, never what.** No history in code, no banners, no restated
  signatures. Docs never hard-code counts that rot.
