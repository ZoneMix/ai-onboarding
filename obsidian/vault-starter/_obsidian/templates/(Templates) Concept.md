---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% tp.system.prompt("One sentence: what is this idea?") %>
type: note
domain: <% tp.system.suggester(["study", "reading", "home", "projects", "personal", "operations"], ["study", "reading", "home", "projects", "personal", "operations"], false, "Domain") %>
---
# <% tp.file.title %>

## Definition

<% tp.file.cursor() %>

## Key principles

## Related
