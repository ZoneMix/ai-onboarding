---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% await tp.system.prompt("One sentence: what is this tool for?") %>
type: tool
domain: <% await tp.system.suggester(["redteam", "blueteam", "career", "personal", "other"], ["redteam", "blueteam", "career", "personal", "other"], false, "Domain") %>
category: <% await tp.system.prompt("Category (enumeration, exploitation, post-exploitation, ...)", "") %>
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
