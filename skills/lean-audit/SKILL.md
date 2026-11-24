---
name: lean-audit
description: "Use when writing, changing, reviewing or sweeping code, tests, comments or docs, to block unneeded code and tests, or to audit one module for dead code, low-value tests and noise comments."
---

# Lean audit

One value bar for everything that lands: code, tests, comments and docs must each pay for
their maintenance cost. Optimize for confidence, not deletion count. Two modes:

- **Authoring gate:** every new or changed line.
- **Audit:** a focused sweep of one module, landed as one coherent commit. For a whole
  subsystem, inventory every file it owns first, then land a series of audit-sized commits.

## Gate: code

Before adding code, answer; a missing answer means don't write it yet:

1. Which user-visible behavior or existing caller needs it today? "Future use" and "for
   completeness" are not callers.
2. Does something already do it? Search for an existing helper first.
3. Is this the smallest change in the owning module? No speculative config, interfaces with
   one implementation, builders for three fields, or wrappers that only forward.
4. Does it need visibility or a parameter only a test needs? Then test through the real entry
   point instead.

## Gate: comments and docs

- A comment explains *why* (a quirk, a protocol constraint, an ordering requirement), never
  *what* the next line does.
- No history in code: no "fixed in v1.2", "previously", "moved from", no commented-out code.
- No banners, restated parameter lists, or doc comments that repeat the signature.
- Docs never hard-code counts that rot. One source per fact; link instead of copying.

## Gate: tests

Before adding a test, answer:

1. What behavior, invariant or contract does it protect?
2. What credible regression makes it fail?
3. Why doesn't existing coverage catch that? Each contract has one owner test at the
   strongest boundary. Prefer a new case in an existing table-driven test.
4. Does it need a production seam no production caller needs? Move it to the real boundary.

A test that breaks under behavior-preserving refactoring asserts implementation, not behavior.
A bug fix gets one regression test that fails on the pre-fix code for the intended reason.

## Junk patterns

Tests:
- assertion-free probes, or asserting only "no error" when the value is the point;
- self-comparisons, identity round-trips, asserting a constructor returns its own literal;
- copied fixtures or inventories (counts, enum lists) that change with every addition;
- greps of source text or internal formatting;
- private-helper tests duplicated by a boundary test;
- expected values computed by the function under test;
- tests that only keep a test-only export alive;
- tests that pass because of the host environment;
- names that promise more than the input exercises.

Code:
- dead code kept alive by lint suppressions or only called from tests;
- variants, fields or parameters nothing reads;
- duplicated helpers that already exist elsewhere;
- copies or recomputation in a hot path where a borrow or cache would do;
- unchecked unwraps on input from users, files, the network or the terminal.

Comments: restating the code, banners, stale counts, version history, TODOs without an owner.

## Retention bar

Keep a test that independently enforces a user-facing contract: accepted input syntax, file
and wire formats, security limits, persisted state, CLI flags, observable ordering, or a
regression with a credible failure mode. "Fast" or "static" is not a reason to delete.
A retained test that fails on the baseline may be a real bug: reproduce it and fix the owner.

## Evidence before deleting

Record for each candidate; a missing field means it isn't ready:

- name and `file:line`;
- what failure it can actually detect;
- non-test callers of the covered code;
- the stronger remaining proof, or why none is needed;
- what deletion it unlocks;
- risk and the focused command that validates the change.

## Edit shape

One coherent batch per commit. Delete obsolete test-only exports and dead paths outright; no
aliases. Prefer net-negative production lines.

## Validate and hand off

Run the focused tests, then the project's full lint, format and test commands, then
`git diff --check` and `git diff --numstat`. Report what was removed and why, what was kept
and why, the checks actually run, production versus test line counts, and named follow-ups.
