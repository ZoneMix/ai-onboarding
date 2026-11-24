---
name: build-study-guide
description: Combine all markdown content files from a vault's content/ folder into a single printable study guide, stripping out all image references. Use whenever the user wants to print study notes, build a combined PDF-ready document, merge an Obsidian vault into one file, or prepare cert/training material for offline reading. Triggers on phrases like "print my notes", "combine all content", "make a study guide", "build a printable version".
user-invocable: true
---

# Build Study Guide

Combine all markdown files in a vault's `content/` folder into a single printable study guide. Strips all embedded image references (`![](...)`, `![alt](images/...)`, and `![[...]]`) so the result prints cleanly without dark training-slide backgrounds. Adds page breaks, normalizes headers, and handles common Obsidian-to-PDF rendering quirks.

## When to Use

- User has an Obsidian vault (study notes, training notes, course material) and wants to print it
- Output target is a single `Project-Study-Guide.md` for PDF export
- Project follows the convention `content/<section>.md` files with section numbers like `1.1`, `2.10`, `3.1a`

## When NOT to Use

- User wants to keep images visible in the PDF, just concatenate with images intact
- Target is HTML or web, use a static site generator instead

## Input

`$ARGUMENTS` is optional, the project root path. If empty, assume current working directory. The skill auto-discovers content files.

## Workflow

### Phase 1: Inventory

```bash
ls content/*.md | sort -V | head -20
total=$(ls content/*.md | wc -l)
echo "$total files"
```

### Phase 2: Build with Python (NOT agents, NOT shell loops)

**CRITICAL**: Do NOT use parallel agents or shell `for` loops for this task.
- Agents are overkill, this is pure text concatenation, not reasoning work.
- Shell `for f in $(ls ...)` breaks on filenames with spaces (most course vaults have them).

Use this single Python script instead:

```python
python3 -c "
import os, re, glob

project_root = '<PROJECT_ROOT>'
content_dir = os.path.join(project_root, 'content')
project_name = os.path.basename(project_root)

# Natural sort: '2.2' before '2.10'
files = sorted(
    glob.glob(os.path.join(content_dir, '*.md')),
    key=lambda f: [int(x) if x.isdigit() else x
                   for x in re.split(r'(\d+)', os.path.basename(f))]
)

# Image patterns to strip (covers standard markdown and Obsidian embeds)
img_re = re.compile(r'!\[.*?\]\(.*?\)|!\[\[.*?\]\]')

# Build TOC
toc_lines = ['## Table of Contents\n\n']
for f in files:
    bn = os.path.basename(f)
    sec_num = bn.split(' - ', 1)[0] if ' - ' in bn else bn.replace('.md', '')
    sec_name = bn.split(' - ', 1)[1].replace('.md', '') if ' - ' in bn else ''
    title = f'{sec_num}, {sec_name}' if sec_name else sec_num
    toc_lines.append(f'- {title}\n')

header = f'''# {project_name}, Complete Study Guide

> {len(files)} sections, generated for offline study and print.
> Images stripped for clean rendering.

'''

parts = [header, ''.join(toc_lines), '\n---\n']
for f in files:
    bn = os.path.basename(f)
    sec_num = bn.split(' - ', 1)[0] if ' - ' in bn else bn.replace('.md', '')
    sec_name = bn.split(' - ', 1)[1].replace('.md', '') if ' - ' in bn else ''
    with open(f, 'r') as fh:
        lines = fh.readlines()
    # Strip YAML frontmatter (--- ... --- block at start of file)
    content = lines
    if lines and lines[0].strip() == '---':
        end = next((i for i in range(1, len(lines)) if lines[i].strip() == '---'), 0)
        content = lines[end+1:]
    # Strip first H1 line (replaced by numbered header below)
    if content and content[0].startswith('# '):
        content = content[1:]
    # Strip images
    content_lines = [l for l in content if not img_re.search(l)]
    title = f'{sec_num}, {sec_name}' if sec_name else sec_num
    parts.append(f'\n<div style=\"page-break-before: always;\"></div>\n\n# {title}\n\n')
    parts.append(''.join(content_lines))
    parts.append('\n---\n')

output_path = os.path.join(project_root, f'{project_name}-Study-Guide.md')
with open(output_path, 'w') as out:
    out.write(''.join(parts))

text = ''.join(parts)
print(f'Output: {output_path}')
print(f'Lines: {text.count(chr(10))}')
print(f'Page breaks: {text.count(\"page-break\")}')
print(f'Image refs: {len(re.findall(r\"!\\[.*?\\]\\(.*?images/\", text))}')
print(f'Size: {len(text.encode()) / 1024 / 1024:.1f} MB')
"
```

Replace `<PROJECT_ROOT>` with the actual project path.

### Phase 3: Post-process (optional)

Run the postprocess script if the output needs additional PDF fixes:

```bash
python3 ~/.claude/skills/build-study-guide/scripts/postprocess.py <PROJECT_NAME>-Study-Guide.md
```

What it fixes:

1. **Section headers**: normalize inconsistent headers to `# X.X: Section Name`
2. **Page breaks**: insert `<div style="page-break-before: always;"></div>` before each `# X.X` header
3. **Headers inside blockquotes**: convert `> # Title` and `> ## Title` to `> **Title**` (bold) so they don't render as actual H1/H2 in PDF

Since Phase 2's Python script already handles page breaks and section numbering, the postprocess step is only needed if headers need further normalization or blockquote fixes are present.

### Phase 4: Verify

```bash
echo "Lines: $(wc -l < <PROJECT_NAME>-Study-Guide.md)"
echo "Page breaks: $(grep -c 'page-break' <PROJECT_NAME>-Study-Guide.md)"
echo "Remaining image refs: $(grep -cE '!\[.*\]\(.*images/|!\[\[.*images/' <PROJECT_NAME>-Study-Guide.md || echo 0)"
```

Image refs must be 0. Page breaks should match the number of section files.

## Output

A single file at the project root: `<ProjectName>-Study-Guide.md`. Typical scale: ~39K lines / 2.4 MB for a 228-file vault, ~13K lines for a 35-file vault.

## Gotchas

- **NEVER use shell `for f in $(ls ...)` or `for f in content/*.md`**: filenames with spaces (e.g., `1.8 - Support Vector Machines (SVMs).md`) break word splitting. Always use Python `glob.glob()` or `while IFS= read -r` with proper quoting.
- **NEVER use parallel agents for concatenation**: this is I/O work, not reasoning. A single Python script runs in <2 seconds for 228 files. Agents add minutes of overhead, risk stalling, and produce inconsistent output.
- **Section ordering**: use natural sort (`key=lambda f: [int(x) if x.isdigit() else x for x in re.split(r'(\d+)', ...)]`) to handle `2.10` vs `2.2` correctly. Shell `sort -V` works but only in GNU coreutils (macOS `sort -V` requires Homebrew coreutils).
- **Image ref patterns vary**: Course exports use `![alt](images/...)`, Obsidian vaults use `![[images/...]]`. The regex must catch both. Also catch `![](images/...)` (empty alt text).
- **YAML frontmatter stripping**: each section file may have YAML frontmatter (`--- ... ---`). The script detects and removes it so the concatenated guide doesn't have stray metadata blocks cluttering the output.
- **First H1 stripping**: each section file starts with `# Section Name` (the raw course heading). The script replaces this with a numbered `# N.N: Section Name` header. The original H1 is stripped to avoid duplicate headings.
- **Table of Contents**: the script generates a TOC from the file list before the content sections, making the guide navigable.
- **Image stripping broadened**: the regex catches ALL image embeds (`![...](...)`  and `![[...]]`), not just those in `images/` subdirectories, vault images may be in `imgs/`, `_obsidian/attachments/`, or inline URLs.
- **Colon in filenames**: sections like `CVE-2023-6909 and CVE-2024-1594 - Local File Inclusion (LFI)` have colons sanitized to ` -` during splitting. The study guide builder inherits whatever the filenames are.

## Related Skills

- `obsidian-vault`: general Obsidian vault interactions
- `obsidian-vault-restructure`: fix vault organization before building the guide
