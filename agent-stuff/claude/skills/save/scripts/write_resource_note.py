#!/usr/bin/env python3
"""Write a resource note into ~/Dropbox/memory/resources/ from JSON on stdin."""

from __future__ import annotations

import json
import os
import re
import sys
import unicodedata
from datetime import date
from pathlib import Path
from typing import Any

BUCKETS = {
    "book": "books",
    "video": "videos",
    "blogpost": "blogposts",
    "article": "articles",
    "paper": "papers",
    "podcast": "podcasts",
    "course": "courses",
    "talk": "talks",
    "link": "links",
    "other": "other",
}


def fail(message: str) -> "NoReturn":
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def slugify(value: str) -> str:
    normalized = unicodedata.normalize("NFKD", value)
    ascii_text = normalized.encode("ascii", "ignore").decode("ascii")
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", ascii_text).strip("-").lower()
    return slug or "resource"


def choose_bucket(kind: str) -> str:
    key = (kind or "other").strip().lower()
    return BUCKETS.get(key, "other")


def unique_path(directory: Path, slug: str) -> Path:
    candidate = directory / f"{slug}.md"
    if not candidate.exists():
        return candidate

    counter = 2
    while True:
        candidate = directory / f"{slug}-{counter}.md"
        if not candidate.exists():
            return candidate
        counter += 1


def listify(value: Any) -> list[str]:
    if value is None:
        return []
    if isinstance(value, list):
        return [str(item).strip() for item in value if str(item).strip()]
    text = str(value).strip()
    return [text] if text else []


def render_markdown(payload: dict[str, Any]) -> str:
    title = str(payload["title"]).strip()
    kind = str(payload.get("kind") or "other").strip().lower()
    url = str(payload.get("url") or "").strip()
    summary = str(payload.get("summary") or "").strip()
    why_saved = str(payload.get("why_saved") or "").strip()
    research_notes = listify(payload.get("research_notes"))

    if not title:
        fail("'title' is required")
    if not summary:
        fail("'summary' is required")

    lines: list[str] = [f"# {title}", "", f"- Type: {kind or 'other'}"]
    if url:
        lines.append(f"- URL: {url}")
    lines.append(f"- Saved: {date.today().isoformat()}")

    lines.extend(["", "## Summary", "", summary])

    if why_saved:
        lines.extend(["", "## Why saved", "", why_saved])

    if research_notes:
        lines.extend(["", "## Research notes", ""])
        lines.extend([f"- {note}" for note in research_notes])

    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    raw = sys.stdin.read().strip()
    if not raw:
        fail("expected a JSON payload on stdin")

    try:
        payload = json.loads(raw)
    except json.JSONDecodeError as exc:
        fail(f"invalid JSON: {exc}")

    if not isinstance(payload, dict):
        fail("top-level JSON value must be an object")

    memory_root = Path(
        os.environ.get("MEMORY_ROOT", os.path.expanduser("~/Dropbox/memory"))
    ).expanduser()
    resources_root = memory_root / "resources"
    bucket = choose_bucket(str(payload.get("kind") or "other"))
    target_dir = resources_root / bucket
    target_dir.mkdir(parents=True, exist_ok=True)

    title = str(payload.get("title") or "").strip()
    if not title:
        fail("'title' is required")

    slug = slugify(str(payload.get("slug") or title))
    output_path = unique_path(target_dir, slug)
    output_path.write_text(render_markdown(payload), encoding="utf-8")

    print(output_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
