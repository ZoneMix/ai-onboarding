---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% await tp.system.prompt("One sentence: what question does this answer?") %>
type: research
domain: <% await tp.system.suggester(["study", "reading", "home", "projects", "personal", "operations"], ["study", "reading", "home", "projects", "personal", "operations"], false, "Domain") %>
---
# <% tp.file.title %>

## Question

<% tp.file.cursor() %>

## Findings

## Sources

Each source with author, title, outlet, date and link, and what it shows.
