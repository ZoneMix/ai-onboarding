"""Surgically fix dollar-sign usage in Obsidian markdown files.

Obsidian renders `$x$` as inline math (MathJax). Vaults that ingest content
from technical course material commonly have bare `$` in prose:
  - Windows account names (`LAB-DC$`, `WS01$`, `apache-dev$`)
  - Shell variables (`$true`, `$_`, `$args`)
  - Dollar amounts (`$200`, `$1,000`)
  - Password literals containing `$` (`Eva$i0n!`)
  - Special-char lists (`!@#$%^&*`)

All of these mis-render as math in Obsidian preview. This script wraps each
in backticks (so it's treated as inline code, math-inert) or escapes with
`\\$` for prose-flow cases.

Usage:
  python3 fix_dollars.py [--dir <markdown-dir>]
  # default --dir is current working directory's `content/`

Idempotent: running twice is a no-op. Skips fenced code blocks and existing
inline backtick spans (those don't need fixing: math doesn't render inside
either).
"""

from __future__ import annotations

import argparse
import re
import sys
import pathlib

# Account names ending in `$` (Windows machine/service accounts).
ACCOUNT_NAME_RE = re.compile(r'(?<![`\w\\])([A-Za-z][\w-]*\$)(?!\w)')

# Shell variables / built-ins: $true, $false, $_, $args, $variable
SHELL_VAR_RE = re.compile(r'(?<![`\w\\])(\$[A-Za-z_][\w]*)\b')

# Dollar amounts: $200, $1,000.00: escape as `\$200` (preserves prose flow).
DOLLAR_AMOUNT_RE = re.compile(r'(?<![`\w\\])\$(\d[\d,.]*)\b')

# Mid-token `$` in identifier-like strings (e.g., Eva$i0n!): wrap in backticks.
MID_TOKEN_DOLLAR_RE = re.compile(r'(?<![`\w\\])([A-Za-z]\w*\$\w[\w!@#\-]*)(?!\w)')

# `!@#$%^&*` style special-char lists: escape the bare `$`.
SPECIAL_CHARS_RE = re.compile(r'(!@#)\$(%)')


def split_into_segments(line: str) -> list[tuple[str, str]]:
    """Split a line into (kind, text) segments where kind is 'code' (inline backticks)
    or 'text'. Backtick-delimited content is kept as-is; only 'text' segments get fixed.
    """
    out = []
    i = 0
    while i < len(line):
        if line[i] == '`':
            j = line.find('`', i + 1)
            if j == -1:
                out.append(('text', line[i:]))
                break
            out.append(('code', line[i:j + 1]))
            i = j + 1
        else:
            j = line.find('`', i)
            if j == -1:
                out.append(('text', line[i:]))
                break
            out.append(('text', line[i:j]))
            i = j
    return out


def fix_text_segment(s: str) -> str:
    """Apply $-fix rules to a non-code text segment."""
    # Mid-token first (so Eva$i0n! gets wrapped before $i0n is matched alone)
    s = MID_TOKEN_DOLLAR_RE.sub(r'`\1`', s)
    s = ACCOUNT_NAME_RE.sub(r'`\1`', s)
    s = SPECIAL_CHARS_RE.sub(r'\1\\$\2', s)
    s = DOLLAR_AMOUNT_RE.sub(r'\\$\1', s)
    s = SHELL_VAR_RE.sub(r'`\1`', s)
    return s


def fix_line(line: str) -> str:
    segments = split_into_segments(line)
    out = []
    for kind, txt in segments:
        if kind == 'text':
            out.append(fix_text_segment(txt))
        else:
            out.append(txt)
    return ''.join(out)


def fix_file(path: pathlib.Path) -> tuple[int, list[tuple[int, str, str]]]:
    """Fix one file in place. Returns (lines_changed, samples) where samples
    is up to 3 (line_no, before, after) tuples for diff display."""
    text = path.read_text()
    lines = text.split('\n')
    in_fence = False
    changes = 0
    samples: list[tuple[int, str, str]] = []
    for i, line in enumerate(lines):
        if line.strip().startswith('```'):
            in_fence = not in_fence
            continue
        if in_fence or '$' not in line:
            continue
        text_only = ''.join(seg[1] for seg in split_into_segments(line) if seg[0] == 'text')
        if '$' not in text_only:
            continue
        new_line = fix_line(line)
        if new_line != line:
            changes += 1
            if len(samples) < 3:
                samples.append((i + 1, line, new_line))
            lines[i] = new_line
    if changes:
        path.write_text('\n'.join(lines))
    return changes, samples


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--dir',
        default='content',
        help='Directory of .md files to fix (default: content/). '
             'Use "." to fix everything in the current directory.',
    )
    parser.add_argument(
        '--quiet',
        action='store_true',
        help='Only print the summary line, no per-file diffs.',
    )
    args = parser.parse_args()

    target = pathlib.Path(args.dir)
    if not target.is_dir():
        print(f'error: {target} is not a directory', file=sys.stderr)
        return 1

    md_files = sorted(target.rglob('*.md'))
    if not md_files:
        print(f'No .md files found under {target}', file=sys.stderr)
        return 1

    total_changes = 0
    files_changed = 0
    for md in md_files:
        n_changes, samples = fix_file(md)
        if n_changes:
            files_changed += 1
            total_changes += n_changes
            if not args.quiet:
                print(f'\n{md}: {n_changes} line(s) fixed')
                for line_no, before, after in samples:
                    bdisp = before if len(before) < 140 else before[:137] + '...'
                    adisp = after if len(after) < 140 else after[:137] + '...'
                    print(f'  L{line_no} BEFORE: {bdisp}')
                    print(f'         AFTER:  {adisp}')

    print(f'\nSummary: {files_changed} file(s) changed, {total_changes} line(s) fixed.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
