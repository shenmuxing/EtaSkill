#!/usr/bin/env python3
"""Lightweight public-readiness checks for a MetaSkill skill directory."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


TEXT_SUFFIXES = {
    ".md",
    ".txt",
    ".yaml",
    ".yml",
    ".json",
    ".py",
    ".ps1",
    ".sh",
    ".toml",
}

PRIVATE_PATTERNS = [
    ("windows_absolute_path", re.compile(r"(?:[A-Za-z]:\\|\\\\\?\\[A-Za-z]:\\)")),
    (
        "unix_home_path",
        re.compile(
            r"(?:"
            + "|".join(re.escape(segment) for segment in ("/" + "Users/", "/" + "home/"))
            + r")[^\s)`'\"]+"
        ),
    ),
    ("email_address", re.compile(r"\b[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}\b")),
    (
        "secret_assignment",
        re.compile(r"\b(?:api[_-]?key|token|secret|password)\b\s*[:=]", re.IGNORECASE),
    ),
]


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_frontmatter(skill_md: Path) -> tuple[list[str], dict[str, str], str | None]:
    text = read_text(skill_md)
    match = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not match:
        return [], {}, "SKILL.md must start with YAML frontmatter delimited by ---"

    keys: list[str] = []
    values: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if not line.strip() or line.startswith(" "):
            continue
        key_match = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if key_match:
            key, value = key_match.groups()
            keys.append(key)
            values[key] = value.strip().strip("\"'")
    return keys, values, None


def iter_text_files(root: Path):
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if any(part in {".git", "__pycache__"} for part in path.parts):
            continue
        if path.suffix.lower() in TEXT_SUFFIXES:
            yield path


def review_skill(root: Path) -> tuple[list[str], list[str]]:
    blockers: list[str] = []
    warnings: list[str] = []

    skill_md = root / "SKILL.md"
    if not skill_md.exists():
        blockers.append("SKILL.md is missing.")
        return blockers, warnings

    keys, values, error = parse_frontmatter(skill_md)
    if error:
        blockers.append(error)
    else:
        allowed = {"name", "description"}
        unexpected = [key for key in keys if key not in allowed]
        missing = [key for key in ("name", "description") if key not in values]
        if unexpected:
            blockers.append(
                "SKILL.md frontmatter has unsupported key(s): " + ", ".join(unexpected)
            )
        if missing:
            blockers.append("SKILL.md frontmatter is missing: " + ", ".join(missing))

        name = values.get("name", "")
        if name:
            if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
                blockers.append(f"Skill name is not lowercase hyphen-case: {name}")
            if root.name != name:
                blockers.append(f"Folder name '{root.name}' does not match skill name '{name}'.")
        description = values.get("description", "")
        if not description or "TODO" in description:
            blockers.append("Frontmatter description is empty or still contains TODO text.")

    for file_path in iter_text_files(root):
        try:
            text = read_text(file_path)
        except UnicodeDecodeError:
            warnings.append(f"{file_path}: not UTF-8; skipped text scan.")
            continue
        rel = file_path.relative_to(root)
        for label, pattern in PRIVATE_PATTERNS:
            for match in pattern.finditer(text):
                line_no = text.count("\n", 0, match.start()) + 1
                blockers.append(f"{rel}:{line_no}: possible private data ({label}).")

    for optional in ("references", "scripts", "assets"):
        directory = root / optional
        if directory.exists() and not any(directory.iterdir()):
            warnings.append(f"{optional}/ exists but is empty.")

    return blockers, warnings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("skill_dir", type=Path)
    args = parser.parse_args()

    root = args.skill_dir.resolve()
    blockers, warnings = review_skill(root)

    print(f"Reviewed: {root}")
    if blockers:
        print("\nBlockers:")
        for item in blockers:
            print(f"- {item}")
    else:
        print("\nBlockers: none")

    if warnings:
        print("\nWarnings:")
        for item in warnings:
            print(f"- {item}")
    else:
        print("\nWarnings: none")

    return 1 if blockers else 0


if __name__ == "__main__":
    sys.exit(main())
