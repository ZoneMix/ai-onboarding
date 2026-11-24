---
name: instruction-audit
description: "Use when asked to audit, check or clean up a repo's agent instruction files (AGENTS.md, CLAUDE.md, rules, skills, hooks) against the actual code and settings."
---

# Instruction-file audit

Instruction files rot. This audit checks every rule against the code, read-only, and proposes
edits. Nothing is changed until the person approves.

## 1. Find the files

List every instruction source that can reach an agent in this repo, tracked or not:

- repo: `AGENTS.md`, `CLAUDE.md`, nested ones in subfolders, `.claude/settings*.json`,
  `.claude/skills/`, `.cursor/rules`, `.github/` instructions, `GEMINI.md`;
- user level: `~/.claude/CLAUDE.md`, `~/.claude/settings.json` (hooks and deny rules),
  `~/.claude/skills/`.

Note which ones import others (`@AGENTS.md`) and which exist but are ignored by git.

## 2. Check each rule

For every concrete rule or claim, open the code it describes and give it one status:

| Status | Meaning |
|---|---|
| FOLLOWED | The code does what the rule says. Cite the file and line. |
| CONTRADICTED | The code does something else. Cite where. |
| STALE | It was true once: a moved path, a renamed command, an old version or count. |
| UNVERIFIABLE | Nothing in the repo can confirm or refute it. Suggest how to make it checkable. |
| CONFLICT | Two instruction files disagree, with no precedence rule to settle it. |

Spell the status out in every row; don't rely on color or icons.

## 3. Verify the findings

Re-open every cited line before reporting (or hand the list to a fresh reviewer that sees only
the citations, not your conclusions). Fix or drop anything that doesn't hold up, and say how
many were confirmed, corrected and dropped.

## 4. Propose edits

For each finding that isn't FOLLOWED, propose the smallest edit:

- drop counts, versions and line numbers that will go stale; point at the source of truth;
- if the code is right and the rule is wrong, fix the rule; if the rule is right, say which
  code change would honor it and leave the choice to the person;
- a rule that matters and can be checked becomes a hook, a deny rule or a lint rule, with the
  prose pointing at it;
- add a precedence sentence where two files conflict.

## Report

A table of findings (rule with `file:line`, status, evidence, proposed edit), then the
proposed diffs. Applied changes: none, unless the person said to apply them.
