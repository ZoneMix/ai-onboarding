---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% await tp.system.prompt("One sentence: what is this technology?") %>
type: technology
domain: <% await tp.system.suggester(["redteam", "blueteam", "career", "personal", "other"], ["redteam", "blueteam", "career", "personal", "other"], false, "Domain") %>
reference: "[[Cybersecurity]]"
---
# <% tp.file.title %>

## Overview

<% tp.file.cursor() %>

## How it works

## Attack surface

## See Also
