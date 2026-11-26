---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% tp.system.prompt("One sentence: what is this idea?") %>
type: concept
domain: <% tp.system.suggester(["redteam", "blueteam", "career", "personal", "other"], ["redteam", "blueteam", "career", "personal", "other"], false, "Domain") %>
reference: "[[Cybersecurity]]"
---
# <% tp.file.title %>

## Definition

<% tp.file.cursor() %>

## Key principles

## See Also
