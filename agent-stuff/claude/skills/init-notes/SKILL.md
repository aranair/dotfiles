---
name: init-notes
description: Initialize a `notes/` directory for tracking learnings, bug fixes, and architectural decisions in a project. Use when the user says "init notes", "/init-notes", "setup notes directory", "add notes tracking", or asks to set up a structured place to record project discoveries, decisions, and incident reports.
---

# init-notes

Initialize a notes directory for tracking learnings, bug fixes, and architectural decisions in a project.

## Trigger

Use when setting up a new project or when the user asks to:

- "init notes"
- "setup notes directory"
- "add notes tracking"
- "/init-notes"

## Instructions

1. Create a `notes/` directory in the project root:

   ```bash
   mkdir -p notes
   ```

2. Check if `CLAUDE.md` exists in the project root. If it does, add a reference to the notes directory near the top (after the title/description):

   ```markdown
   **See also:** `notes/` directory for learnings, bug fixes, and architectural decisions.
   ```

3. If `CLAUDE.md` doesn't exist, create it with a basic structure:

   ```markdown
   # CLAUDE.md

   Project instructions for Claude Code.

   **See also:** `notes/` directory for learnings, bug fixes, and architectural decisions.

   ## Notes

   Add significant learnings to the `notes/` directory using the format:
   `notes/YYYY-MM-DD-short-description.md`
   ```

4. Confirm to the user that notes tracking is set up and explain the naming convention:
   - Files should be named: `YYYY-MM-DD-short-description.md`
   - Include: Date, Category, Problem, Root Cause, Fix Applied, Prevention

## Note Template

When adding notes (not part of init, but for reference):

```markdown
# Title

**Date:** YYYY-MM-DD
**Category:** Database | API | Performance | Bug | Architecture

## Problem

What was observed.

## Root Cause

Why it happened.

## Fix Applied

What was done to fix it.

## Prevention

How to avoid this in the future.
```
