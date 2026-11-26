---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% tp.system.prompt("One sentence: what is this note?") %>
type: <% tp.system.suggester(["note", "study", "research", "reference", "project", "journal", "moc"], ["note", "study", "research", "reference", "project", "journal", "moc"], false, "Type") %>
domain: <% tp.system.suggester(["study", "reading", "home", "projects", "personal", "operations"], ["study", "reading", "home", "projects", "personal", "operations"], false, "Domain") %>
---
# <% tp.file.title %>

<% tp.file.cursor() %>

## Related

- Add this note to its folder's MOC.
