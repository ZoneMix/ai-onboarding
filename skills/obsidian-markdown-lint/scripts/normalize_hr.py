"""Normalize horizontal-rule lines to a consistent style.

Imported course content uses `----`, `--------`, etc. as
section dividers. markdownlint's MD035 rule wants a single canonical style.
This script rewrites any line that's *just* dashes (4 or more) to `---`.

Usage:
  python3 normalize_hr.py [--dir <markdown-dir>] [--style <hr-string>]

Idempotent: running twice is a no-op.
"""

from __future__ import annotations

import argparse
import re
import sys
import pathlib


def normalize_file(path: pathlib.Path, style: str) -> int:
    """Rewrite N-dash HR lines to the canonical style. Returns changes.

    Catches:
      - `----` and longer (4+ dashes)
      - `---  ` and similar (3 dashes followed by trailing whitespace:
        markdownlint MD035 treats these as a different "style" than `---`).
    """
    text = path.read_text()
    # Match any line that's only dashes (3+) optionally followed by whitespace.
    new = re.sub(r'^[-]{3,}[ \t]*$', style, text, flags=re.MULTILINE)
    if new != text:
        path.write_text(new)
        return 1
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dir', default='content', help='Directory to scan (default: content/)')
    parser.add_argument('--style', default='---', help='Canonical HR string (default: ---)')
    args = parser.parse_args()

    target = pathlib.Path(args.dir)
    if not target.is_dir():
        print(f'error: {target} is not a directory', file=sys.stderr)
        return 1

    files_changed = 0
    for md in sorted(target.rglob('*.md')):
        n = normalize_file(md, args.style)
        if n:
            files_changed += 1
            print(f'{md}: normalized to "{args.style}"')

    print(f'\nNormalized HR in {files_changed} file(s).')
    return 0


if __name__ == '__main__':
    sys.exit(main())
