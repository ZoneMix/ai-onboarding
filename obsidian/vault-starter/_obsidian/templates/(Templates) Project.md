---
title: <% tp.file.title %>
date_created: <% tp.date.now("YYYY-MM-DD") %>
description: <% await tp.system.prompt("One sentence: what is this project?") %>
type: project
domain: <% await tp.system.suggester(["projects", "home", "study", "personal", "operations"], ["projects", "home", "study", "personal", "operations"], false, "Domain") %>
status: active
---
# <% tp.file.title %>

## Overview

<% tp.file.cursor() %>

## Goals

## Next steps

## Notes

Agent research, logs and build files for this project go in `_agents/projects/`, not here.
