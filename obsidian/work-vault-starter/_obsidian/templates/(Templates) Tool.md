---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% tp.system.prompt("One sentence: what is this tool for?") %>
type: tool
domain: <% tp.system.suggester(["redteam", "blueteam", "career", "personal", "other"], ["redteam", "blueteam", "career", "personal", "other"], false, "Domain") %>
category: <% tp.system.prompt("Category (enumeration, exploitation, post-exploitation, ...)", "") %>
reference: "[[Cybersecurity]]"
---
# <% tp.file.title %>

## Cheatsheet

```bash
<% tp.file.cursor() %>
```

## Installation

## Usage

## See Also
