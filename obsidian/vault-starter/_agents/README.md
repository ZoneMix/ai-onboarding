---
title: Agents workspace
description: Where agents keep their own tracking, run logs, reports, feeds and working research. Not meant for reading.
type: reference
domain: operations
---
# Agents workspace

This folder belongs to the agents. It holds what they keep for their own sake: run reports, audits, queues, learning logs, raw research, transcripts, build trees and generated feeds. A person never needs to open it. Exclude it from Obsidian's search and graph (Settings, Files and links, Excluded files); links into it still open.

Everything a person reads lives in the numbered folders, written as clean notes. When an agent's work produces something worth reading, it writes a short note in the right human folder and links back here for the detail.

## Folders

| Folder | What it holds |
| --- | --- |
| `feeds/` | Generated daily material: briefs, news digests, anything a bot writes every day |
| `reports/<kind>/` | Run reports, audits, lint results and review drafts, one dated file per run |
| `queues/` | Work queues and hand-offs between bots |
| `learning-logs/` | Spaced-review or progress logs, one per subject |
| `projects/<project>/` | Build trees, research batches, transcripts, scripts and STATUS files for big projects |
| `reference/` | Machine snapshots and paste-in prompt packs |
| `archive/` | Agent files that are finished or dead |

## Rules

- Put new agent output here, never in a human folder. If unsure where, use `reports/` or the project folder.
- One file per run or per subject, dated in the name (`YYYY-MM-DD`). Keep the path stable so the writer can find it again.
- Frontmatter is optional here. Plain markdown, JSON, CSV, code and transcripts are all fine.
- No secrets, ever. The vault pre-commit hook scans every commit.
- List any folder here that only one automation writes in `0_MEMORY/Agents.md`.
