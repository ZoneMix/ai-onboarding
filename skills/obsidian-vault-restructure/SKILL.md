---
name: obsidian-vault-restructure
description: "Audit, clean, and restructure an Obsidian vault into a type-based taxonomy with consistent frontmatter, atomic notes, and AI-ready structure. Use when a vault is messy, uses outdated PARA layout, has high orphan rates, inconsistent metadata, or needs migration to the Helton V2 organization model."
---

# Obsidian Vault Restructure

Systematically audit and restructure an Obsidian vault into a type-based taxonomy inspired by Graham Helton's V2 approach, organizing by what knowledge IS, not what you're doing with it.

## When to Use

- Vault uses outdated PARA structure and needs migration to type-based taxonomy
- High orphan rate (>50%) or deadend rate (>80%)
- Inconsistent or missing frontmatter across notes
- Files scattered across root or in inconsistent folder structures
- Assets spread across multiple folders
- No structured note creation workflow exists
- User says the vault is "messy", "unorganized", or "needs cleanup"

## When NOT to Use

- Vault is already using type-based taxonomy with consistent frontmatter
- User just wants to read/search/analyze vault content (use `obsidian-vault` skill)
- User wants to create a new vault from scratch (just set up the folder structure)

---

## Target Structure

```
_obsidian/              <- Vault metadata
  attachments/          <- ALL media consolidated here
  templates/            <- Note templates (Templater-driven)
1_TECHNOLOGY/           <- Specific technologies (e.g., Kubernetes, Active Directory)
2_TECHNIQUE/            <- Executable techniques (e.g., Spaced Repetition, Code Review)
3_RESEARCH/             <- Exploration topics, breadcrumbs, rabbit holes
4_TOOL/                 <- Tool descriptions and usage guides (e.g., nmap, Burp Suite)
5_CONCEPT/              <- Concepts, largest directory (e.g., Cryptography, Philosophy, Economics)
6_PROMPTS/              <- AI prompt library
7_PROJECTS/             <- Active project containers (certifications, client work, courses)
8_DAILY/                <- Daily notes
9_OPERATIONS/           <- Meta-operational (Tasks, Calendar, Inbox, Standup)
99_OTHER/               <- Miscellaneous items not fitting elsewhere
```

Key principles:
- **Organize by note TYPE, not actionability**: a note about a sourdough starter is a TECHNIQUE regardless of which cookbook you learned it from
- **One attachment folder**: all images, audio, PDFs in `_obsidian/attachments/`
- **One template folder**: all templates in `_obsidian/templates/`
- **No files in vault root**: everything in a typed folder
- **Projects are containers, not permanent homes**: atomic notes graduate out into type folders; project folders hold course structure and study logs
- **Frontmatter on every note**: consistent schema enables Obsidian Bases and automation

## Frontmatter Schema

Every note MUST have this frontmatter:

```yaml
---
title: Note Title
date_created: YYYY-MM-DD
description: One-line summary of the note
type: technology|technique|research|tool|concept|prompt|project|other
domain: work|study|career|personal|other
reference: "[[Related Note]]"
---
```

Technique notes can add domain-specific fields, for example:
```yaml
framework_id: <id>
framework_category: <category>
```

Project notes add status:
```yaml
status: active|paused|complete
```

---

## Quick Start

1. Run the **Audit** phase to assess vault health
2. Present findings and get user confirmation
3. Execute phases in order
4. Run `/vault-map` to verify results

---

## Phase 1: Audit

Assess current vault health before touching anything.

```bash
obsidian tags counts sort=count vault="$VAULT"
obsidian orphans vault="$VAULT" | wc -l
obsidian deadends vault="$VAULT" | wc -l
obsidian unresolved vault="$VAULT" | wc -l
obsidian files vault="$VAULT" | wc -l
obsidian folders vault="$VAULT"
obsidian files vault="$VAULT" | grep -v "/"   # root files
```

Also check via filesystem:
```bash
find "$VAULT_PATH" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.pdf" -o -iname "*.m4a" -o -iname "*.mp4" \) | wc -l
find "$VAULT_PATH" -type d -name "assets" -o -name "attachments" -o -name "imgs" -o -name "images"
```

Present a health report:
- Total files, media files, markdown files
- Orphan count and percentage
- Deadend count and percentage
- Unresolved link count (these are knowledge gap indicators, preserve intentional stubs)
- Root file count (should be 0)
- Scattered asset folder count
- Frontmatter completeness (how many notes have type/domain/description)

## Phase 2: Create Directory Structure

Create the target structure if it doesn't exist:

```bash
mkdir -p "$VAULT_PATH/_obsidian/attachments"
mkdir -p "$VAULT_PATH/_obsidian/templates"
mkdir -p "$VAULT_PATH/1_TECHNOLOGY"
mkdir -p "$VAULT_PATH/2_TECHNIQUE"
mkdir -p "$VAULT_PATH/3_RESEARCH"
mkdir -p "$VAULT_PATH/4_TOOL"
mkdir -p "$VAULT_PATH/5_CONCEPT"
mkdir -p "$VAULT_PATH/6_PROMPTS"
mkdir -p "$VAULT_PATH/7_PROJECTS"
mkdir -p "$VAULT_PATH/8_DAILY"
mkdir -p "$VAULT_PATH/9_OPERATIONS"
mkdir -p "$VAULT_PATH/99_OTHER"
```

## Phase 3: Update Obsidian Config

Update `.obsidian/app.json`:
- `attachmentFolderPath` -> `_obsidian/attachments`
- Add `_obsidian/` to `userIgnoreFilters`

Update `.obsidian/templates.json`:
- `folder` -> `_obsidian/templates`

Update `.obsidian/daily-notes.json`:
- `template` -> `_obsidian/templates/(Templates) Daily`
- `folder` -> `8_DAILY`

Configure Linter to ignore `_obsidian/templates/` to preserve Templater syntax.

## Phase 4: Classify and Move Notes

Map existing notes to type-based folders. Classification guide:

| Old Location | Note Content | New Location |
|---|---|---|
| `01 - Projects/Course/` | Course structure, study logs | `7_PROJECTS/Course/` |
| `01 - Projects/Course/` | Individual technique notes | Graduate to `2_TECHNIQUE/` |
| `01 - Projects/Course/` | Tool usage notes | Graduate to `4_TOOL/` |
| `02 - Areas/Philosophy/` | Philosophy concepts | `5_CONCEPT/` |
| `02 - Areas/Personal-Context` | Context file | `9_OPERATIONS/` |
| `02 - Areas/Work-Context` | Context file | `9_OPERATIONS/` |
| `03 - Resources/TTPs/` | Techniques | `2_TECHNIQUE/` |
| `03 - Resources/Books/` | Book notes | `3_RESEARCH/` |
| `03 - Resources/Articles/` | Article notes | `3_RESEARCH/` |
| `00 - Maps of Content/` | MOC hub notes | `5_CONCEPT/` (MOCs become concept index notes) |
| `06 - Daily/` | Daily notes | `8_DAILY/` |
| `07 - Archives/` | Completed projects | `7_PROJECTS/` (mark status: complete) |
| `08 - Operations/` | Operational notes | `9_OPERATIONS/` |
| `99 - Meta/assets/` | Media files | `_obsidian/attachments/` |
| `99 - Meta/00 - Templates/` | Templates | `_obsidian/templates/` |

For project folders (certs, courses): keep the folder structure intact in `7_PROJECTS/` but extract atomic notes into type folders. The project folder retains:
- README/index with course structure
- Study logs and progress tracking
- Links to graduated atomic notes

## Phase 5: Mass Frontmatter Update

Use AI to add missing frontmatter to existing notes:

1. Scan all notes missing required fields (title, date_created, description, type, domain)
2. For each note, infer:
   - `type` from folder location and content
   - `domain` from content keywords and existing tags
   - `description` from first paragraph or H1
   - `date_created` from file creation date or existing `date`/`created` fields
3. Apply updates in batches, preserving existing frontmatter fields
4. Do NOT auto-generate note content, only metadata

## Phase 6: Consolidate Assets

1. Find all scattered asset/attachment/images/imgs folders
2. Check for duplicates between scattered folders and `_obsidian/attachments/`
3. `cmp -s` before deleting, don't trust filename matching alone
4. Move unique files to `_obsidian/attachments/`
5. Delete empty source folders

## Phase 7: Fix Broken Links

Common path patterns to fix after migration:

| Pattern | Fix |
|---|---|
| `99 - Meta/assets/` | -> `_obsidian/attachments/` |
| `99 - Meta/00 - Templates/` | -> `_obsidian/templates/` |
| `01 - Projects/X/` | -> `7_PROJECTS/X/` |
| `02 - Areas/` | -> `5_CONCEPT/` or `9_OPERATIONS/` |
| `03 - Resources/` | -> `3_RESEARCH/` or appropriate type folder |
| `06 - Daily/` | -> `8_DAILY/` |
| `07 - Archives/` | -> `7_PROJECTS/` |
| `08 - Operations/` | -> `9_OPERATIONS/` |
| `00 - Maps of Content/` | -> `5_CONCEPT/` |

Use `sed -i` for bulk path replacement:
```bash
find "$VAULT_PATH" -name "*.md" -exec sed -i '' 's|OLD_PATH/|NEW_PATH/|g' {} \;
```

## Phase 8: Wire Backlinks

Priority order:
1. **Concept index notes -> typed notes** (replace MOC function)
2. **Project indexes -> graduated atomic notes** (maintain project context)
3. **Cross-type links** (technique -> tool, concept -> technique, etc.)
4. **Context files <-> concept notes** (bidirectional)

## Phase 9: Knowledge Gap Analysis

After restructure, identify knowledge gaps using two methods:

**Stub Notes Method**: Run `obsidian unresolved` to find `[[wikilinks]]` without files. These grey nodes in graph view indicate areas needing development. Preserve intentional stubs, they're feature, not bugs.

**Incoming Link Density**: Notes with many incoming links from diverse sources are foundational concepts. If they're thin, they need deepening:
```bash
obsidian backlinks file="Note" vault="$VAULT" | wc -l
```

## Phase 10: Verify

Run `/vault-map` and compare before/after metrics:
- Orphan rate should drop significantly
- Root files should be 0
- No broken link patterns remaining
- Frontmatter completeness should be >90%
- Every note has type and domain fields

---

## PARA Migration Mapping

For vaults migrating from PARA structure:

| PARA Folder | Disposition |
|---|---|
| `00 - Maps of Content/` | Dissolve, MOCs become concept index notes in `5_CONCEPT/` |
| `01 - Projects/` | Move to `7_PROJECTS/`, graduate atomic notes out |
| `02 - Areas/` | Content goes to `5_CONCEPT/`, context files to `9_OPERATIONS/` |
| `03 - Resources/` | Classify into `1_TECHNOLOGY/`, `4_TOOL/`, `3_RESEARCH/` by content |
| `05 - Fleeting/` | Triage into type folders or delete |
| `06 - Daily/` | Move to `8_DAILY/` |
| `07 - Archives/` | Move to `7_PROJECTS/` with `status: complete` |
| `08 - Operations/` | Move to `9_OPERATIONS/` |
| `99 - Meta/` | Assets to `_obsidian/attachments/`, templates to `_obsidian/templates/` |

## Gotchas

- **CLI `folder=` on `create` fails silently**: always `mkdir -p` the folder first
- **Linter will destroy Templater syntax**: add `_obsidian/templates/` to linter ignored folders
- **Moving images breaks embeds**: always do a broken link sweep after moving assets
- **Obsidian treats `[[Course]]` and `[[7_PROJECTS/Course]]` as different links**: prefer simple `[[wikilinks]]`
- **Don't merge duplicate files without reading both**: brief versions often have unique reference links
- **Stub notes are intentional knowledge gaps**: don't delete unresolved wikilinks unless truly erroneous
- **AI for metadata, not content**: mass-update frontmatter with AI, but don't auto-generate note bodies
- **Project folders are temporary containers**: as you learn, extract atomic notes into type folders

## Estimated Impact

A typical vault migration (1000+ files):
- Orphan rate drops 30-50% (type-based linking replaces MOCs)
- Frontmatter completeness: 0% -> 90%+
- Root files -> 0
- Broken links -> 0
- Time: 2-4 hours with Claude Code automation
