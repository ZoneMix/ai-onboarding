#!/usr/bin/env python3
"""guard-bash: Claude Code PreToolUse hook (matcher Bash) that blocks never-break actions.

It never prompts; it only blocks, with exit 2 and the reason on stderr. It is a guardrail for
common slips, not a sandbox: a determined workaround (find -delete, a script file) gets past it.
Blocks: force-push, git reset --hard, git add -A / --all / ., skipping git hooks, reading or
copying private SSH keys, and rm -rf of home, root, a repo's .git or any shallow path.
Fails closed on unparseable input. Python only: macOS /usr/bin/grep has no -P.
Extend EXTRA_DENY with (regex, reason) pairs for your own never-break commands.
"""
import json
import os
import re
import sys

HOME = os.path.expanduser("~")
MIN_SAFE_DEPTH = 4  # rm -rf allowed only on paths at least this deep, e.g. /home/me/a/b
SEG = r"[^|;&\n]*"  # stay inside one simple command
GIT = r"\bgit(\s+-C\s+(\"[^\"]*\"|'[^']*'|\S+))?\s+"  # git, optional -C <dir>

DENY = [
    (rf"{GIT}push\b{SEG}(\s--force(-with-lease)?\b|\s-f\b|\s\+\S)", "force-push is forbidden"),
    (rf"{GIT}reset\b{SEG}\s--hard\b", "git reset --hard is forbidden"),
    (rf"{GIT}add\b{SEG}\s(-A|--all|\.)(\s|$)", "stage specific files, never git add -A or ."),
    (rf"{GIT}(commit|push)\b{SEG}\s--no-verify\b", "never skip git hooks"),
    (rf"{GIT}commit\b{SEG}\s-n\b", "never skip git hooks (-n is --no-verify)"),
    (r"(~|\$HOME|/Users/[^/\s]+|/home/[^/\s]+)/\.ssh/(id_|[^\s'\"]*(\.pem|\.key|_key)\b)",
     "never read or copy private SSH keys"),
]
EXTRA_DENY = []
RM_RF = (r"\brm\s+(-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*|-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*"
         r"|-r\s+-f|-f\s+-r|--recursive\s+--force)\s+")


def block(reason):
    sys.stderr.write(f"BLOCKED by guard-bash: {reason}.\n")
    return 2


def first_match(rules, cmd):
    for pattern, reason in rules:
        if re.search(pattern, cmd):
            return reason
    return None


def dangerous_target(target, cwd):
    if target in ("", ".", "..", "*", "~", "/") or target.startswith(("$", "~/*", "/*")):
        return True
    path = os.path.normpath(os.path.join(cwd or HOME, os.path.expanduser(target)))
    if path.endswith("/.git") or path == HOME:
        return True
    return path.count("/") < MIN_SAFE_DEPTH


def rm_rf_violation(cmd, cwd):
    for m in re.finditer(rf"{RM_RF}({SEG})", cmd):
        targets = [t.strip("'\"") for t in m.group(2).split() if not t.startswith("-")]
        if not targets or any(dangerous_target(t, cwd) for t in targets):
            return True
    return False


def main():
    try:
        data = json.load(sys.stdin)
        cmd = data["tool_input"]["command"]
        cwd = data.get("cwd") or ""
    except (ValueError, KeyError, TypeError):
        return block("cannot parse hook input (fail closed)")
    if not isinstance(cmd, str):
        return block("command is not a string (fail closed)")
    reason = first_match(DENY + EXTRA_DENY, cmd)
    if not reason and rm_rf_violation(cmd, cwd):
        reason = "rm -rf of home, root, a repo's .git or a shallow path; delete something narrower"
    return block(reason) if reason else 0


if __name__ == "__main__":
    sys.exit(main())
