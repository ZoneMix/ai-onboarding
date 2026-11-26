---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% tp.system.prompt("One sentence: what question does this answer?") %>
type: research
domain: <% tp.system.suggester(["study", "reading", "home", "projects", "personal", "operations"], ["study", "reading", "home", "projects", "personal", "operations"], false, "Domain") %>
---
# <% tp.file.title %>

## Question

<% tp.file.cursor() %>

## Findings

## Sources

Each source with author, title, outlet, date and link, and what it shows.
