# /graduate

Extracts ideas buried in daily notes and promotes them into standalone permanent notes.

## Usage

```
/graduate
```

## Process

### Step 1: Scan Daily Notes

Read 14 days of daily notes. Look for both explicit and implicit graduation signals.

```bash
obsidian daily:read
obsidian search:context query="#idea"
obsidian search:context query="#expand"
obsidian search:context query="should write about"
obsidian search:context query="worth investigating"
```

**Explicit signals**: #idea tags, #expand tags, "should write about", "worth investigating", named concepts, unresolved [[links]].

**Implicit signals**: high-energy paragraphs, original claims, themes recurring 3+ times, repeated unanswered questions.

**Exclude**: tasks, logistics, complaints without insight.

### Step 2: Cross-Reference with Vault

For each candidate, check vault status:

```bash
obsidian search query="<candidate concept>"
obsidian backlinks file="<related note>"
```

- **New concept**: not in vault yet -- prioritize
- **Underdeveloped**: exists but thin -- enrich
- **Already covered**: exists with depth -- skip unless daily note adds unique angle
- **Recurring unresolved**: keeps appearing without resolution -- high priority

### Step 3: Present Candidates

| Idea | Source | Days Mentioned | Status | Recommendation |
|------|--------|---------------|--------|----------------|
| <idea-1> | daily <date> | 3 | New | Graduate |
| <idea-2> | daily <date> | 1 | Underdeveloped | Enrich |
| <idea-3> | daily <date> | 5 | Recurring | High Priority |

### Step 4: Graduate

For each approved idea, create a mini-essay:

- **Core claim**: the central idea in one sentence
- **Context**: where this thinking emerged from
- **[[Backlinks]]**: connections to existing vault notes
- **Open questions**: what remains unresolved

Write in first-person voice matching the energy of the daily note. Add bidirectional backlinks to source daily notes and related permanent notes. Target 3-8 paragraphs per graduated note.

### Step 5: Summary

```
Graduated Today: <count>
Still in Queue: <count> (with brief descriptions)
Vault Health: <orphan count>, <unresolved link count>
```

## Guidelines

- Preserve the vault owner's voice; do not sanitize the energy out of raw ideas.
- Present borderline cases for the vault owner to decide rather than auto-graduating.
- Target 5-10 minutes per run to keep the habit sustainable.
- 3-8 paragraphs per graduated note; long enough to be useful, short enough to finish.
