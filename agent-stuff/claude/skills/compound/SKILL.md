---
name: compound
description: Consolidate session learnings into the project's `.notes/` directory. Use when the user says "compound", "/compound", "save session notes", "update notes from this session", "write what we learned", or otherwise asks to persist discoveries, decisions, gotchas, and TODOs from the current session into structured project notes.
---

# compound

Consolidate learnings from the current session into the project's `.notes/` directory.

## Trigger

Use when the user asks to:

- "compound" or "/compound"
- "save session notes"
- "update notes from this session"
- "write what we learned"

## Instructions

1. **Check for `.notes/` directory** in the project root. If it doesn't exist, inform the user and offer to create it using the standard structure.

2. **Review the current session** and identify:
   - **Decisions**: Architectural or design choices made (→ `decisions.md`)
   - **Gotchas**: Non-obvious behaviors, edge cases, bugs discovered (→ `gotchas.md`)
   - **TODOs**: Deferred work, future improvements identified (→ `todo.md`)
   - **Significant changes**: What was built, fixed, or configured (→ `session-log.md`)

3. **Read the existing notes files** to understand current format and avoid duplicates.

4. **Append new entries** to the appropriate files:

   For `decisions.md`:

   ```markdown
   ### [YYYY-MM-DD] Decision Title

   **Context**: Why this decision was needed
   **Decision**: What was decided
   **Rationale**: Why this approach was chosen
   ```

   For `gotchas.md`:

   ```markdown
   ### Title

   Description of the gotcha and how to handle it.
   ```

   For `todo.md`:

   ```markdown
   - [ ] Task description
   ```

   For `session-log.md`:

   ```markdown
   ## YYYY-MM-DD

   - Bullet points of what was done
   ```

5. **Summarize** what was added to the user.

## Notes

- Only add genuinely useful information, not routine operations
- Keep entries concise but complete enough to be useful later
- If a date section already exists in session-log.md, append to it rather than creating a new one
- Avoid duplicating information already in the notes
