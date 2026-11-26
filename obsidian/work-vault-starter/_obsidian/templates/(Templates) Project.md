---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% await tp.system.prompt("One sentence: what is this project?") %>
type: project
domain: <% await tp.system.suggester(["redteam", "blueteam", "career", "personal", "other"], ["redteam", "blueteam", "career", "personal", "other"], false, "Domain") %>
status: active
reference: "[[Cybersecurity]]"
---
# <% tp.file.title %>

## Scope

<% tp.file.cursor() %>

## Goals

## Notes

## Notes that graduated

Atomic notes that grew out of this project and moved to the type folders.
