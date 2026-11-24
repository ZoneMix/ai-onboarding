#!/usr/bin/env python3
"""no-heredoc: Claude Code PreToolUse hook (matcher Bash) for the no-heredoc rule.

Reads the hook JSON on stdin and takes tool_input.command. If it contains two less-than signs
in a row anywhere (heredoc, here-string, even inside a comment or a quoted pattern), it exits 2
with the reason on stderr, which makes Claude Code block the call and show the reason.
Exit 0 otherwise. Unparseable input exits 2 (fail closed).

Why: heredoc bodies land in shell history, and a strict textual rule is simpler to trust than
a shell parser. Script files are exempt because they never pass through this hook.
"""
import json
import sys

LT2 = "<" * 2
MSG = ("BLOCKED by no-heredoc (rule: no heredocs). The Bash command contains two less-than signs"
       " in a row (heredoc or here-string). Rewrite it without them: write files with the editor"
       " tool, or feed input with a single < FILE redirect.\n")


def main():
    try:
        data = json.load(sys.stdin)
    except ValueError:
        sys.stderr.write("no-heredoc: cannot parse hook input, refusing (fail closed).\n")
        return 2
    ti = data.get("tool_input") if isinstance(data, dict) else None
    cmd = ti.get("command") if isinstance(ti, dict) else None
    if isinstance(cmd, str) and LT2 in cmd:
        sys.stderr.write(MSG)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
