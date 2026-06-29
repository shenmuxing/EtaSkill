#!/usr/bin/env python3
"""Convert configured Markdown files to PDFs and optionally upload to Feishu Drive."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


@dataclass
class PlanItem:
    source_name: str
    category: str
    markdown_path: Path
    relative_path: Path
    pdf_path: Path
    folder_token: str = ""


def load_rules(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        rules = json.load(f)
    if rules.get("version") != 1:
        raise SystemExit("rules.json must set version to 1")
    return rules


def resolve_repo_path(repo_root: Path, value: str | None, default: str) -> Path:
    raw = value or default
    path = Path(raw)
    if not path.is_absolute():
        path = repo_root / path
    return path.resolve()


def extract_folder_token(folder_url: str) -> str:
    match = re.search(r"/drive/folder/([^/?#]+)", folder_url or "")
    return match.group(1) if match else ""


def delivery_mode(rules: dict[str, Any]) -> str:
    delivery = rules.get("delivery", {})
    return str(delivery.get("mode") or "feishu").lower()


def merged_list(source: dict[str, Any], defaults: dict[str, Any], key: str) -> list[str]:
    value = source.get(key, defaults.get(key, []))
    if value is None:
        return []
    if not isinstance(value, list):
        raise SystemExit(f"{key} must be a list")
    return [str(item) for item in value]


def matches_any(path: Path, patterns: list[str]) -> bool:
    normalized = path.as_posix()
    return any(path.match(pattern) or Path(normalized).match(pattern) for pattern in patterns)


def discover_markdown(source: dict[str, Any], defaults: dict[str, Any]) -> list[Path]:
    source_root = Path(str(source["path"])).expanduser().resolve()
    if not source_root.exists():
        print(f"WARN source does not exist: {source_root}", file=sys.stderr)
        return []
    recursive = bool(source.get("recursive", defaults.get("recursive", True)))
    include_globs = merged_list(source, defaults, "include_globs") or ["**/*.md"]
    exclude_globs = merged_list(source, defaults, "exclude_globs")

    files: set[Path] = set()
    for pattern in include_globs:
        iterator = source_root.rglob(pattern.replace("**/", "")) if recursive and not pattern.startswith("**/") else source_root.glob(pattern)
        for candidate in iterator:
            if candidate.is_file():
                rel = candidate.relative_to(source_root)
                if not matches_any(rel, exclude_globs):
                    files.add(candidate.resolve())
    return sorted(files)


def build_plan(rules: dict[str, Any], repo_root: Path) -> list[PlanItem]:
    defaults = rules.get("defaults", {})
    categories = rules.get("categories", {})
    feishu = rules.get("feishu", {})
    root_folder_token = feishu.get("folder_token") or extract_folder_token(feishu.get("folder_url", ""))
    local_only = delivery_mode(rules) == "local"
    if not local_only and not root_folder_token:
        raise SystemExit("Missing feishu.folder_token or parseable feishu.folder_url")

    output_cfg = rules.get("output", {})
    pdf_root = resolve_repo_path(repo_root, output_cfg.get("pdf_root"), "local/markdown-pdf-feishu-sync/out/pdf")
    plan: list[PlanItem] = []

    for source in rules.get("sources", []):
        if source.get("enabled", True) is False:
            continue
        if not source.get("name") or not source.get("path"):
            raise SystemExit("Each enabled source must include name and path")
        source_root = Path(str(source["path"])).expanduser().resolve()
        category = str(source.get("category") or defaults.get("category") or "uncategorized")
        category_cfg = categories.get(category, {})
        folder_token = "" if local_only else category_cfg.get("folder_token") or root_folder_token
        for md_path in discover_markdown(source, defaults):
            rel = md_path.relative_to(source_root)
            pdf_path = pdf_root / category / str(source["name"]) / rel.with_suffix(".pdf")
            plan.append(
                PlanItem(
                    source_name=str(source["name"]),
                    category=category,
                    markdown_path=md_path,
                    relative_path=rel,
                    pdf_path=pdf_path.resolve(),
                    folder_token=str(folder_token),
                )
            )
    return plan


def converter_command(template: list[Any], item: PlanItem) -> list[str]:
    values = {
        "input": str(item.markdown_path),
        "staged_input": str(item.pdf_path.with_suffix(item.markdown_path.suffix)),
        "output": str(item.pdf_path),
        "output_dir": str(item.pdf_path.parent),
        "source_dir": str(item.markdown_path.parent),
        "stem": item.markdown_path.stem,
    }
    return [str(part).format(**values) for part in template]


def run_conversion(rules: dict[str, Any], item: PlanItem) -> dict[str, Any]:
    converter = rules.get("converter", {})
    command_template = converter.get("command")
    if not isinstance(command_template, list) or not command_template:
        raise SystemExit("converter.command must be a non-empty list")
    item.pdf_path.parent.mkdir(parents=True, exist_ok=True)
    uses_staged_input = any("{staged_input}" in str(part) for part in command_template)
    staged_input = item.pdf_path.with_suffix(item.markdown_path.suffix)
    if uses_staged_input:
        shutil.copy2(item.markdown_path, staged_input)
    command = converter_command(command_template, item)
    cwd = item.pdf_path.parent if uses_staged_input else item.markdown_path.parent
    result = subprocess.run(command, cwd=str(cwd), text=True, capture_output=True)
    if uses_staged_input and staged_input.exists():
        staged_input.unlink()
    return {
        "command": command,
        "returncode": result.returncode,
        "stdout": result.stdout[-4000:],
        "stderr": result.stderr[-4000:],
        "pdf_exists": item.pdf_path.exists(),
    }


def run_upload(rules: dict[str, Any], pdf_root: Path, item: PlanItem) -> dict[str, Any]:
    if not item.pdf_path.exists():
        return {"returncode": 1, "stderr": "PDF does not exist; upload skipped"}
    if delivery_mode(rules) == "local":
        return {"returncode": 1, "stderr": "Upload disabled because delivery.mode is local"}
    if not item.folder_token:
        return {"returncode": 1, "stderr": "Missing folder token; upload skipped"}
    feishu = rules.get("feishu", {})
    identity = str(feishu.get("identity") or "bot")
    rel_pdf = item.pdf_path.relative_to(pdf_root)
    command = [
        "lark-cli",
        "drive",
        "+upload",
        "--file",
        str(rel_pdf),
        "--folder-token",
        item.folder_token,
        "--as",
        identity,
    ]
    result = subprocess.run(command, cwd=str(pdf_root), text=True, capture_output=True)
    return {
        "command": command,
        "returncode": result.returncode,
        "stdout": result.stdout[-4000:],
        "stderr": result.stderr[-4000:],
    }


def append_manifest(path: Path, record: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(record, ensure_ascii=False) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rules", required=True, help="Path to local rules.json")
    parser.add_argument("--dry-run", action="store_true", help="Print plan without converting or uploading")
    parser.add_argument("--convert", action="store_true", help="Convert Markdown files to PDFs")
    parser.add_argument("--upload", action="store_true", help="Upload generated PDFs to Feishu Drive")
    args = parser.parse_args()

    repo_root = Path.cwd().resolve()
    rules_path = Path(args.rules)
    if not rules_path.is_absolute():
        rules_path = (repo_root / rules_path).resolve()
    rules = load_rules(rules_path)
    if args.upload and delivery_mode(rules) == "local":
        raise SystemExit("Upload disabled because delivery.mode is local")
    plan = build_plan(rules, repo_root)

    output_cfg = rules.get("output", {})
    pdf_root = resolve_repo_path(repo_root, output_cfg.get("pdf_root"), "local/markdown-pdf-feishu-sync/out/pdf")
    manifest_path = resolve_repo_path(repo_root, output_cfg.get("manifest"), "local/markdown-pdf-feishu-sync/out/manifest.jsonl")
    now = datetime.now(timezone.utc).isoformat()

    summary = {
        "rules": str(rules_path),
        "pdf_root": str(pdf_root),
        "manifest": str(manifest_path),
        "items": len(plan),
        "delivery_mode": delivery_mode(rules),
        "pending_decisions": rules.get("pending_decisions", []),
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))

    failures = 0
    for item in plan:
        record: dict[str, Any] = {
            "ts": now,
            "source": item.source_name,
            "category": item.category,
            "markdown": str(item.markdown_path),
            "relative": item.relative_path.as_posix(),
            "pdf": str(item.pdf_path),
            "dry_run": bool(args.dry_run or not (args.convert or args.upload)),
        }
        if item.folder_token:
            record["folder_token"] = item.folder_token
        if args.dry_run or not (args.convert or args.upload):
            print(json.dumps(record, ensure_ascii=False))
            continue
        if args.convert:
            conversion = run_conversion(rules, item)
            record["conversion"] = conversion
            if conversion["returncode"] != 0 or not conversion["pdf_exists"]:
                failures += 1
                append_manifest(manifest_path, record)
                print(json.dumps(record, ensure_ascii=False), file=sys.stderr)
                continue
        if args.upload:
            upload = run_upload(rules, pdf_root, item)
            record["upload"] = upload
            if upload["returncode"] != 0:
                failures += 1
        append_manifest(manifest_path, record)
        print(json.dumps(record, ensure_ascii=False))

    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
