# Instruction files

- **`AGENTS.md` is canonical** in every repo, because every agent reads it. `CLAUDE.md` is a
  shim that starts with `@AGENTS.md` and adds only Claude-specific notes. Edit `AGENTS.md`,
  never a copy.
- **Precedence:** the most specific file wins. A folder's `AGENTS.md` or `CLAUDE.md`, then its
  parents up to the repo root, then the user-level `~/.claude/CLAUDE.md`. What the person says
  in the session beats all of them. Hooks and `permissions.deny` beat any prose.
- **Enforce, don't just ask.** A rule that matters and can be checked belongs in a hook or a
  deny rule, with the prose pointing at it. Prose alone drifts.
- **Keep them true.** Instruction files rot. When you change code that a file describes,
  update the file in the same change. Periodically audit them (`skills/instruction-audit/`).
- **One fact, one place.** Link to the file that owns a fact instead of copying it. No version
  numbers, counts or dates that will go stale without anyone noticing.
- **Short and specific.** Commands to build, test and lint; the module map; the project's
  non-obvious rules and gotchas. Skip generic advice the agent already follows.
- **One scaffolding folder.** Project-local agent files (skills, settings, manifests) go in
  `.claude/`. Don't create a parallel `.agents/` directory for the same thing.
- **Skills:** the `description` is a short, specific trigger ("Use when ..."). Keep `SKILL.md`
  under 150 lines and split references by topic.
