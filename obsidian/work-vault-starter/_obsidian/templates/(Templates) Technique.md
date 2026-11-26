---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% tp.system.prompt("One sentence: what does this technique do?") %>
type: technique
domain: <% tp.system.suggester(["redteam", "blueteam", "career", "personal", "other"], ["redteam", "blueteam", "career", "personal", "other"], false, "Domain") %>
mitre_id: <% tp.system.prompt("MITRE ATT&CK id (T1558.003), blank if none", "") %>
mitre_tactic: <% tp.file.folder(false) %>
reference: "[[Cybersecurity]]"
---
# <% tp.file.title %>

## Description

<% tp.file.cursor() %>

## Prerequisites

## Procedure

## Detection

## See Also
