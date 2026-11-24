#!/usr/bin/env python3
"""Post-process a combined study guide for PDF export.

Fixes three issues that break PDF rendering:
1. Inconsistent section headers (normalize to "# X.X: Name")
2. Missing page breaks between major sections
3. Markdown headers inside slide blockquotes (convert to bold)

Usage:
    python3 postprocess.py <path-to-study-guide.md>
"""

import re
import sys
from pathlib import Path


SECTION_PATTERN = re.compile(
    r'^# (?:Section\s*\d*:\s*|Study\s+Guide\s+Part\s*\d+\s*[:\-]?\s*)?'
    r'(\d+\.\d+[a-z]?)\s*[-–—]+\s*(.+)$'
)
SECTION_COLON_PATTERN = re.compile(
    r'^# Section:\s*(\d+\.\d+[a-z]?)\s*[-–—]+\s*(.+)$'
)
EXISTING_SECTION_PATTERN = re.compile(r'^# (\d+\.\d+[a-z]?)\s*[-–—]+')
STUDY_GUIDE_PART_PATTERN = re.compile(r'^# Study Guide Part \d+')
PAGEBREAK_DIV = '<div style="page-break-before: always;"></div>'


def fix_section_headers_and_breaks(content: str) -> str:
    """Normalize section headers and insert page breaks before each."""
    lines = content.split('\n')
    output = []
    prev_was_pagebreak = False

    i = 0
    while i < len(lines):
        line = lines[i]

        # Drop "Study Guide Part N" headers and trailing blank/separator lines
        if STUDY_GUIDE_PART_PATTERN.match(line):
            i += 1
            while i < len(lines) and (lines[i].strip() == '' or lines[i].strip() == '---'):
                i += 1
            continue

        # Normalize "# Section N: X.Y - Name" → "# X.Y: Name" with page break
        m = SECTION_PATTERN.match(line) or SECTION_COLON_PATTERN.match(line)
        if m:
            sec_num, sec_name = m.group(1), m.group(2).strip()
            if not prev_was_pagebreak:
                output.extend(['', PAGEBREAK_DIV, ''])
            output.append(f'# {sec_num}: {sec_name}')
            prev_was_pagebreak = False
            i += 1
            continue

        # Existing properly-formatted section header: add page break, normalize dashes
        m = EXISTING_SECTION_PATTERN.match(line)
        if m:
            sec_num = m.group(1)
            if not prev_was_pagebreak:
                output.extend(['', PAGEBREAK_DIV, ''])
            normalized = re.sub(r'\s*[-–]+\s*', ': ', line, count=1)
            output.append(normalized)
            prev_was_pagebreak = False
            i += 1
            continue

        prev_was_pagebreak = 'page-break' in line
        output.append(line)
        i += 1

    result = '\n'.join(output)
    result = re.sub(r'\n{4,}', '\n\n\n', result)
    result = re.sub(r'\n---\n+(<div style="page-break)', r'\n\n\1', result)
    return result


def fix_blockquote_headers(content: str) -> str:
    """Convert `> # Title` and `> ## Title` inside slide blocks to `> **Title**`.

    Inside markdown blockquotes, `#` and `##` render as actual H1/H2 headers in PDF
    exporters. Slide content uses these as section labels for command groups
    (e.g., "## List all VMs"), so the result is a broken document outline.
    Converting to bold preserves the visual structure without polluting the TOC.
    """
    lines = content.split('\n')
    output = []
    in_slide = False

    for line in lines:
        stripped = line.rstrip('\n')

        if '**[Slide' in stripped:
            in_slide = True
        elif not stripped.startswith('>') and stripped.strip() != '':
            in_slide = False

        if in_slide and stripped.startswith('>'):
            # > ## Text → > **Text**
            m = re.match(r'^(>\s*)##\s+(.+)$', stripped)
            if m:
                output.append(f'{m.group(1)}**{m.group(2)}**')
                continue
            # > # Text → > **Text** (only for descriptive headers, not code comments)
            m = re.match(r'^(>\s*)#\s+(.+)$', stripped)
            if m:
                text = m.group(2)
                # Skip lines that look like actual shell/code comments
                if not any(c in text for c in ['=', '$', '{', '}', '|', '\\']):
                    output.append(f'{m.group(1)}**{text}**')
                    continue

        output.append(line)

    return '\n'.join(output)


def main():
    if len(sys.argv) != 2:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

    path = Path(sys.argv[1])
    if not path.exists():
        print(f'File not found: {path}', file=sys.stderr)
        sys.exit(1)

    content = path.read_text()
    original_lines = content.count('\n')

    content = fix_section_headers_and_breaks(content)
    content = fix_blockquote_headers(content)

    path.write_text(content)
    new_lines = content.count('\n')

    page_breaks = content.count('page-break-before')
    slide_blocks = content.count('[Slide')
    image_refs = len(re.findall(r'!\[\]\(|!\[\[', content))

    print(f'Processed: {path}')
    print(f'  Lines: {original_lines} → {new_lines}')
    print(f'  Page breaks: {page_breaks}')
    print(f'  Slide blocks: {slide_blocks}')
    print(f'  Remaining image refs: {image_refs}')


if __name__ == '__main__':
    main()
