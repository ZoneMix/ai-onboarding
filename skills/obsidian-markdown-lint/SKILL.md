---
name: obsidian-markdown-lint
description: Use when setting up markdown linting in an Obsidian vault, especially prose-heavy study vaults (course and certification note collections), knowledge bases imported from online courses and training material, or any markdown-only repo where you want consistent formatting without the noise of strict line-length and inline-HTML rules. Triggers on "lint markdown", "fix markdown formatting", "set up markdownlint in this vault", "fix the dollar signs rendering as math in Obsidian", "normalize HR/horizontal rules", "clean up the formatting", or any request to apply markdownlint-cli2 to an Obsidian-style vault. Make sure to use this whenever the user wants markdown cleanup in a notes vault, even if they don't name `markdownlint-cli2` explicitly, the alternative is hand-editing hundreds of files, which is slow and inconsistent.
---

# Obsidian Markdown Lint Setup

Set up `markdownlint-cli2` in an Obsidian vault with a configuration tuned for prose, plus two repair scripts (`fix_dollars.py`, `normalize_hr.py`) that handle Obsidian-specific issues markdownlint won't catch.

## When to Use

- The user wants to lint or auto-format markdown across an Obsidian vault.
- The vault contains imported training material (online course exports, course PDFs, lab walkthroughs) where formatting is inconsistent across files.
- The user reports that `$` characters render as math/MathJax in Obsidian preview (the most common issue: account names like `LAB-DC$`, shell variables like `$true`, dollar amounts like `$200`).
- The user wants horizontal rules standardized (imported course content often uses `----`, `--------`, etc.).
- Setting up a brand-new vault where you want lint to enforce sensible defaults from day one.

## When NOT to Use

- A non-Obsidian markdown project (README/docs in a code repo): those usually want stricter rules; use markdownlint-cli2 default config or the project's existing `.markdownlint.json`.
- The vault is already linted and the user wants to ADD a specific rule, just edit `.markdownlint-cli2.jsonc` directly, no skill needed.
- The user wants to convert markdown to HTML/PDF, wrong tool, look at pandoc or remark.

## Approach

The skill bundles three pieces that work together:

| File | Purpose |
|---|---|
| `assets/markdownlint-cli2.jsonc` | Config template tuned for prose vaults, disables MD013 (line length), MD033 (inline HTML), MD041 (first-line H1), MD025 (single H1, since merge files commonly have two), MD024 (duplicate headings, since course content repeats subsection names), MD056 (table column count, false-positives on URL-heavy tables), MD001 (heading increment, converted content skips H3→H4 sometimes). Configures MD035 to canonicalize HRs at `---`. |
| `scripts/fix_dollars.py` | Surgical fixer for Obsidian's MathJax `$` interpretation. Wraps account names / shell vars / dollar amounts in backticks (or escapes with `\$` for prose-flow cases), only touching prose text, leaves fenced code blocks and existing inline backticks untouched. Idempotent. |
| `scripts/normalize_hr.py` | Normalizes 4+-dash horizontal rules to `---` so MD035 stops flagging them. Idempotent. |
| `scripts/setup.sh` | Detects/installs markdownlint-cli2, locates the actual binary path (works around npm not symlinking to Homebrew's `bin/`), drops in the config, optionally runs `--fix`. |

## Steps

1. **Confirm the user's vault layout.** Most Obsidian vaults this skill targets have one of these shapes:
   - Flat `content/N.N - Name.md` (a restructured course vault)
   - Folder-per-topic with `<Topic>/<Section>.md` files
   - Free-form vault root with arbitrary `.md` files
   The default `globs` in the config template (`content/**/*.md`, `*.md`) covers the first and third. If the user has a deeply-nested structure, edit `globs` after copying the template.

2. **Run the setup helper from the vault root:**

   ```bash
   bash ~/.claude/skills/obsidian-markdown-lint/scripts/setup.sh --fix
   ```

   With `--fix` it auto-cleans on first run; without `--fix` it just installs and configures, letting the user inspect before any rewrite. Either way it leaves `.markdownlint-cli2.jsonc` at the vault root and prints the binary path the user can re-invoke.

3. **Apply the dollar-sign fixer if the vault has shell/Windows content:**

   ```bash
   python3 ~/.claude/skills/obsidian-markdown-lint/scripts/fix_dollars.py --dir content
   ```

   The fixer is idempotent and safe to re-run. It only touches `$` in prose, never inside fenced code blocks. For vaults that don't have shell content (no `$true` or `LAB-DC$` anywhere), this is a no-op.

4. **Apply the HR normalizer if the source content uses long dash rules:**

   ```bash
   python3 ~/.claude/skills/obsidian-markdown-lint/scripts/normalize_hr.py --dir content
   ```

   Imported course content commonly uses `----` (4 dashes) or longer as section dividers. This normalizes them to `---` so MD035 with `style: "---"` stops flagging.

5. **Re-run the linter:**

   ```bash
   $(npm root -g)/markdownlint-cli2/markdownlint-cli2-bin.mjs --fix   # if PATH symlink missing
   markdownlint-cli2 --fix                                            # if PATH symlink works
   ```

   At this point the lint should be clean, or near-clean with only structural issues that need human judgment (e.g., empty links pointing to TBD sections, deliberate duplicate H4 names that the user wants to keep).

6. **For ongoing enforcement, add a hook or pre-commit step.** A simple `PostToolUse` hook on `Write|Edit` that runs the fixer scripts plus markdownlint-cli2 keeps the vault clean as the user adds more notes. The skill doesn't install this, it's a per-user preference.

## The Dollar Problem (why it matters)

Obsidian's preview parses `$x$` as inline math (MathJax) and `$$...$$` as block math. When technical content contains:

- `LAB-DC$` (Windows machine account)
- `$true` (PowerShell built-in)
- `$200` (cost mentioned in cloud-platform lab content)
- `Eva$i0n!` (sample password literal)

…Obsidian renders these as broken/italicized math, often making the surrounding paragraph unreadable in preview. The `fix_dollars.py` script wraps these in backticks (which are math-inert) so they render as code. Backticks inside inline-code spans don't nest weirdly because the script only edits non-code text segments.

## Configuration Decisions and Why

The config template's disabled rules are deliberate, each is a place where strict markdownlint defaults conflict with how prose-heavy vaults are written:

- **MD013 line-length: off.** Long sentences are how prose works. Hard-wrapping at 80 chars makes editing painful and Obsidian renders fine without it.
- **MD033 inline HTML: off.** Imported course callout boxes use `<p class="mb-0">`, `<i class="mdi mdi-info">`, etc. These render as info/warning boxes in Obsidian. Stripping them loses semantic information.
- **MD024 duplicate headings: off.** Course content commonly has repeated subsection names like `Validating the Credentials` once per enumeration tool. The repetition is intentional, flagging it is noise.
- **MD025 single H1: off.** Merge files (where the splitter combines pre-existing user notes with raw imported content) intentionally have two H1s separated by a `## Source: X (raw)` divider.
- **MD056 table column count: off.** URL-heavy tables (BloodHound edges, AD attack matrices) confuse the cell-count parser when URLs contain characters that look like cell separators.
- **MD001 heading increment: off.** Converted content sometimes jumps H3→H5 because the original course had an H4 in a callout that got stripped during conversion. Restructuring the heading levels would damage the source content fidelity; better to accept the skip.

## Gotchas

- **The npm-global symlink to Homebrew's `/opt/homebrew/bin/` sometimes doesn't get created** when `markdownlint-cli2` installs. The setup script handles this by falling back to invoking the binary via direct node module path: `node $(npm root -g)/markdownlint-cli2/markdownlint-cli2-bin.mjs`. If you're typing commands by hand and `markdownlint-cli2` isn't on PATH, use the same fallback or `alias markdownlint-cli2='node $(npm root -g)/markdownlint-cli2/markdownlint-cli2-bin.mjs'` in your shell rc.
- **macOS Bash 3.2 doesn't have associative arrays.** The setup script uses plain arrays / string membership; don't rewrite it to use `declare -A` if you're patching it.
- **Filenames containing `\` (backslash)** trip several Unix tools (markdownlint glob included). If a vault has `NT AUTHORITY\SYSTEM` style names, rename them to use `-` instead and preserve the original convention in the H1 heading inside the file. This is a per-vault decision, not something the skill auto-fixes.
- **Don't touch `.markdownlint.json`**: some users have a config-protection hook on that exact filename. Use `.markdownlint-cli2.jsonc` (the config the cli2 variant prefers anyway). The template uses this name.
- **Configuration files at vault root may interact with `.obsidian/` plugins.** A few Obsidian plugins (Linter, Various Markdown, etc.) try to format on save and can fight markdownlint's choices. If both are running, configure them to leave `$`-related transforms alone or disable one.
- **The fixer's regex can't reach into HTML attribute values.** Lines with `<p>...$value...</p>` won't be auto-fixed. These are rare but check after running if Obsidian still shows math rendering somewhere.
- **`--fix` can break a deliberate empty link** (`[text]()`). The auto-fix won't try to invent a URL but it will sometimes leave the link in a state that needs manual restore. If you have placeholder links pointing at TBD sections, fix them up before linting or accept that markdownlint will keep flagging them as MD042.
- **Screenshot-heavy vaults will hit MD045 hard.** Lab-note vaults often have hundreds of portal screenshots without alt text. The rule is genuinely useful for accessibility, so it stays enabled by default, but if the user is unwilling to write alt text retrospectively, disable MD045 in the per-vault config and revisit when adding new images.
- **Embedded git repos under `working/` produce warnings.** Some vaults have nested git checkouts (e.g., `working/AzureAppsSweep`, lab tooling repos) that warn during `git add`. These don't break anything, but the user may want to either gitignore those subdirs or convert them to submodules. The lint skill itself doesn't touch them.
- **Vaults with 0 commits need a baseline first.** Running the skill on a fresh `git init` directory with no commits means there's no rollback target, make an initial `chore: pre-lint baseline` commit before applying the auto-fix pass so the diff is reviewable and revertible.
- **Session files from course downloaders.** Some download tools leave a session cookie file in the working directory. Make sure it is gitignored before the first commit.

## What "Done" Looks Like

After running the skill end-to-end, the user should have:

- A `.markdownlint-cli2.jsonc` at vault root with prose-tuned defaults.
- Zero (or near-zero) lint errors when running `markdownlint-cli2`.
- `$`-bearing prose that previously mis-rendered as math now wrapped in backticks or escaped, verifiable by opening one of the affected files in Obsidian preview.
- Horizontal rules standardized to `---`.
- The skill's three scripts available for re-runs whenever new content is added.

## Related


## Pilot Results (2026-04-28)

Skill exercised on 4 sibling Obsidian vaults to validate portability. Each vault's `--fix` reduction:

| Vault | Before | After | Notes |
|---|---:|---:|---|
| Course A | 1,419 | 1   | Clean; 1 = real missing alt text |
| Course B | 1,638 | 1   | Clean; 7 HR + 6 dollar fixes; caught a session file not gitignored |
| Course C |   790 | 27  | Mostly clean; 39 dollar fixes; residual MD029 (ol-prefix) edge cases |
| Lab notes |   560 | 432 | 416 MD045 + 260 MD028 are real content gaps (screenshot-heavy) |

The skill is robust for prose-heavy vaults with text content. For vaults dominated by un-alt-texted screenshots (lab notes), the user should either commit to writing alt text or disable MD045 per-vault.
