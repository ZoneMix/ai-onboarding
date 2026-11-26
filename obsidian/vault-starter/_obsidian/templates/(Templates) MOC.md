---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% tp.system.prompt("One sentence: what area does this map cover?") %>
type: moc
domain: <% tp.system.suggester(["study", "reading", "home", "projects", "personal", "operations"], ["study", "reading", "home", "projects", "personal", "operations"], false, "Domain") %>
---
# <% tp.file.title %>

Up: [[Home]]

<% tp.file.cursor() %>

## Notes

## Related maps
