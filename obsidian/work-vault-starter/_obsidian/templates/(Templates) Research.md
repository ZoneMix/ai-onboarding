---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% await tp.system.prompt("One sentence: what question does this answer?") %>
type: research
domain: <% await tp.system.suggester(["redteam", "blueteam", "career", "personal", "other"], ["redteam", "blueteam", "career", "personal", "other"], false, "Domain") %>
reference: "[[Cybersecurity]]"
---
# <% tp.file.title %>

## Question

<% tp.file.cursor() %>

## Findings

## Sources

Each source with author, title, date and link, and what it shows. Mark anything not checked "(unverified)".
