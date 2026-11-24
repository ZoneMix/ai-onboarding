# Merge claude/settings.example.json (input 1) into the current settings (input 0).
# Keeps every existing key. Unions deny rules; appends hook groups that are not already present.
.[0] as $cur
| .[1] as $add
| $cur
| .permissions.deny = ((($cur.permissions.deny // []) + ($add.permissions.deny // [])) | unique)
| reduce ($add.hooks // {} | keys[]) as $event (.;
    .hooks[$event] = (($cur.hooks[$event] // []) as $have
      | $have + [($add.hooks[$event][] | select(. as $g | $have | index([$g]) | not))]))
