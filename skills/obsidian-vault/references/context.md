# /context: Build Full Picture of Who You Are

Reads across the vault to build a comprehensive picture of who you are, what you're working on, and what you care about right now. Run this before any other vault-intelligence command to establish baseline context.

## Usage

```
/context
```

## Process

### Step 1: Read Core Context Files

Load the foundational files that define priorities, projects, and identity:

```bash
obsidian read file="<Context-File-A>"
obsidian read file="<Context-File-B>"
obsidian read file="<Context-File-C>"
```

Read any README or index files that serve as vault entry points.

### Step 2: Explore Directory Structure

Map the vault's organizational structure:

```bash
obsidian folders
obsidian files folder="<Key-Folder-A>"
obsidian files folder="<Key-Folder-B>"
```

### Step 3: Follow Backlinks

Discover connected documents from context files:

```bash
obsidian backlinks file="<Context-File-A>"
obsidian backlinks file="<Context-File-B>"
obsidian links file="<Context-File-A>"
```

### Step 4: Review Recent Daily Notes

Read the last 5-7 daily notes to understand current state:

```bash
obsidian daily:read
obsidian read path="8_DAILY/YYYY-MM-DD.md"
```

Look for:
- Current focus areas and active projects
- Recurring themes and questions
- Energy levels and blockers
- Confidence markers: `[solid]`, `[evolving]`, `[hypothesis]`, `[questioning]`

### Step 5: Analyze Vault Structure

Get a structural overview:

```bash
obsidian tags counts sort=count
obsidian orphans
obsidian unresolved
obsidian deadends
```

Look for:
- Tag distribution revealing where thinking concentrates
- Orphaned notes that may contain forgotten value
- Unresolved links representing ideas never developed

### Step 6: Synthesize

Build understanding around these dimensions:
- **Priorities**: What actually matters right now (not what should matter)
- **Active projects**: What's in motion, what's stalled
- **Open questions**: What you're wrestling with
- **Shifts**: What's changing in your thinking
- **Connections**: Surprising patterns across domains

## Output

Present a synthesis organized by:
1. **Identity snapshot**: Role, responsibilities, core domains
2. **Current priorities**: Ranked by vault evidence, not stated importance
3. **Active threads**: Projects, questions, and evolving ideas
4. **Vault health**: Structural observations (orphans, gaps, clusters)
5. **Confidence map**: Which areas are solid vs. evolving vs. questioning

## Guidelines

- Weight recent daily notes heavily, they reflect current state
- Note discrepancies between stated priorities and actual note density
- Flag confidence markers and track where thinking is actively shifting
- Build understanding before beginning any work
