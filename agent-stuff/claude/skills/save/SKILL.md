---
name: save
description: Research and save a book, video, blog post, article, paper, podcast, link, or other resource into memory. Use when the user says "/save", "save this", "remember this", "store this resource", or asks Claude to quickly research something and log it into `~/Dropbox/memory/resources/`.
---

# save

Quickly research a resource and store a durable note in memory.

## Workflow

1. Parse the user's input into a specific resource.
   - Accept a title, a URL, or both.
   - If the user gives only a vague topic instead of a specific item, ask one short clarifying question.

2. Do lightweight research.
   - If the user included a URL, fetch/read it first.
   - If the user named a book, video, blog post, article, paper, or similar item without a URL, use the best available tools to identify the canonical source and gather a quick summary.
   - Keep the research pass short. Aim for a concise, high-signal summary rather than exhaustive notes.
   - If browsing tools are unavailable, use the best available local context or model knowledge and say so briefly.

3. Normalize the note before saving.
   - Infer `type` as one of: `book`, `video`, `blogpost`, `article`, `paper`, `podcast`, `course`, `talk`, `link`, `other`.
   - Capture:
     - `title`
     - `type`
     - `source` if known (prefer the canonical URL; `url` is acceptable as a legacy alias)
     - `tags` (optional Obsidian tags as a list; omit `#` prefixes)
     - `summary` (2-6 bullets or a short paragraph)
     - `why_saved` (why this matters to the user right now)
     - `research_notes` (optional extra bullets)
     - `author` (optional note author; defaults to `Claude`)

4. Write the note using the bundled helper script `scripts/write_resource_note.py`.
   - The script writes one markdown file per resource under `~/Dropbox/memory/resources/<bucket>/`.
   - Prefer this script over hand-writing the file so filenames and sections stay consistent.

5. Refresh memory indexing.
   - If `qmd` is available, run `qmd update` after saving.

6. Report back succinctly.
   - Tell the user what you saved.
   - Include the final file path.
   - Include a one-line summary of the resource.

## Helper Script

Use `scripts/write_resource_note.py` with JSON on stdin.

Example:

```bash
python3 scripts/write_resource_note.py <<'EOF'
{
  "title": "Deep Work",
  "type": "book",
  "source": "https://example.com",
  "tags": ["books", "productivity", "focus"],
  "summary": "A book about focused, distraction-free work as a competitive advantage.",
  "why_saved": "Useful for thinking about focus and execution.",
  "research_notes": [
    "Emphasizes reducing shallow work.",
    "Frames concentration as a trainable skill."
  ]
}
EOF
```

`type` is the preferred field name. The helper still accepts `kind` as a legacy alias.

## Output Format

Save notes in this shape, with YAML frontmatter first:

```md
---
title: Deep Work
created: 2026-04-19
type: book
source: https://example.com
tags:
  - books
  - productivity
  - focus
author: Claude
---

# Deep Work

## Summary

Short summary.

## Why saved

Why it matters.

## Research notes

- Bullet
- Bullet
```

## Frontmatter Template

Use this template when saving a resource note:

```yaml
---
title: <resource title>
created: <YYYY-MM-DD>
type: <book|video|blogpost|article|paper|podcast|course|talk|link|other>
source: <canonical url or source path, if known>
tags:
  - <tag1>
  - <tag2>
author: Claude
---
```

## Rules

- Save into `~/Dropbox/memory/resources/`, not `links/`, when the resource is something the user wants to remember with a summary.
- Keep summaries crisp and durable.
- Do not invent details when the source is unclear; say what is uncertain.
- Prefer one file per resource.
- If the same resource already exists, update or append to the existing note instead of creating a duplicate.
