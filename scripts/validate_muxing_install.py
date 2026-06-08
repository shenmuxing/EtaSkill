#!/usr/bin/env python3
"""Validate source and installed skill examples.

This is a post-install smoke checker for agents that install skills from this
repository. It intentionally does not install external CLIs or modify user
configuration; it reports the missing pieces the installer must resolve. The
explicit DeepSeek verification option is the exception: it calls the installed
credential helper only when requested.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable


KNOWN_SKILLS = (
    "call-gpt-pro",
    "codex-deepseek-paper-protocol",
    "deepseek-agent",
    "literature-idea-planner",
    "literature-reference-builder",
    "muxing-style-review",
    "proof-material",
    "proof-finder",
    "proof-cooker",
    "proof-usage",
    "proof-orchestrator",
    "proof-plan",
    "skill-creator",
    "skill-installer",
    "skill-tester",
    "style-review",
)

ALLOWED_FRONTMATTER_KEYS = {"name", "description", "license", "allowed-tools", "metadata"}

INSTALL_MD_HEADINGS = (
    "# Installation",
    "## Copy",
    "## Dependencies",
    "## Install Steps",
    "## Update Steps",
    "## Verification",
    "## Rollback",
    "## Notes",
)

SKILL_DEPENDENCIES = {
    "call-gpt-pro": {
        "connectors": ("chrome",),
        "command_groups": (("pwsh", "powershell"),),
        "files": (
            "scripts/manage_pro_sources.ps1",
            "scripts/invoke_openrouter_gpt_pro.ps1",
        ),
    },
    "codex-deepseek-paper-protocol": {
        "skills": ("deepseek-agent", "muxing-style-review"),
    },
    "deepseek-agent": {
        "commands": ("opencode",),
        "command_groups": (("pwsh", "powershell"),),
        "files": (
            "scripts/invoke_deepseek.ps1",
            "scripts/setup_opencode_deepseek.ps1",
            "scripts/set_deepseek_env.cmd",
        ),
    },
    "literature-idea-planner": {
        "connectors": ("chrome",),
    },
    "literature-reference-builder": {
        "connectors": ("chrome",),
    },
    "muxing-style-review": {
        "skills": ("style-review",),
        "commands": ("agent-style",),
        "files": (
            "references/RULES.md",
            "references/check-human.md",
            "references/check-compact.md",
            "references/subagent-review-prompt.md",
            "references/revision-brief-template.md",
            "references/rule-detectors.md",
        ),
    },
    "proof-material": {
        "files": (
            "references/index.md",
        ),
    },
    "proof-finder": {
        "skills": ("deepseek-agent", "proof-material"),
        "commands": ("opencode",),
        "files": ("references/deepseek-prompts.md",),
    },
    "proof-cooker": {
        "skills": ("proof-material", "proof-usage"),
        "files": (
            "references/taxonomy-template.md",
            "references/cooking-checklist.md",
        ),
    },
    "proof-usage": {
        "files": (
            "references/index.md",
            "references/source-map.md",
            "references/local-moves/concentration-and-self-normalization.md",
            "references/local-moves/convex-error-bounds.md",
            "references/local-moves/epoch-and-restart-controls.md",
            "references/strategies/auxiliary-models-and-contractions.md",
            "references/strategies/dual-learning-vs-decision-making.md",
            "references/techniques.md",
            "references/strategies.md",
        ),
    },
    "proof-orchestrator": {
        "skills": ("proof-plan", "call-gpt-pro", "deepseek-agent"),
        "files": (
            "references/dispatch-prompts.md",
        ),
    },
    "proof-plan": {},
    "style-review": {
        "commands": ("agent-style",),
        "files": (
            "references/revision-prompt.md",
            "references/rule-detectors.md",
        ),
    },
    "skill-creator": {
        "files": (
            "scripts/init_skill.py",
            "scripts/generate_openai_yaml.py",
            "scripts/quick_validate.py",
            "references/openai_yaml.md",
        ),
    },
    "skill-installer": {
        "files": (
            "install.md",
            "scripts/github_utils.py",
            "scripts/install-skill-from-github.py",
            "scripts/list-skills.py",
        ),
    },
    "skill-tester": {},
}

PRIVATE_PATTERN = re.compile(
    r"(/Users/|/home/|[A-Za-z]:\\\\|api[_-]?key|access[_-]?token|bearer\s+[A-Za-z0-9._-]+|\b(?:secret|password)\b\s*[:=])",
    re.IGNORECASE,
)


@dataclass
class CheckResult:
    status: str
    scope: str
    skill: str
    message: str


def default_skills_root() -> Path:
    codex_home = os.environ.get("CODEX_HOME")
    if codex_home:
        return Path(codex_home).expanduser() / "skills"
    return Path.home() / ".codex" / "skills"


def parse_frontmatter(skill_md: Path) -> tuple[dict[str, str], str | None]:
    text = skill_md.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        return {}, "SKILL.md does not start with YAML frontmatter"
    end = text.find("\n---", 4)
    if end == -1:
        return {}, "SKILL.md frontmatter is not closed"
    raw = text[4:end]
    data: dict[str, str] = {}
    for line in raw.splitlines():
        if not line.strip():
            continue
        if line.startswith((" ", "\t")):
            continue
        if ":" not in line:
            return {}, f"Unsupported frontmatter line: {line}"
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip().strip("'\"")
        data[key] = value
    return data, None


def iter_text_files(skill_dir: Path) -> Iterable[Path]:
    for path in skill_dir.rglob("*"):
        if path.is_dir():
            continue
        if path.suffix.lower() in {".png", ".jpg", ".jpeg", ".gif", ".ico"}:
            continue
        yield path


def check_source_skill(skill_dir: Path, expected_name: str) -> list[CheckResult]:
    results: list[CheckResult] = []
    skill = expected_name
    if not skill_dir.exists():
        return [CheckResult("fail", "source", skill, f"missing source directory: {skill_dir}")]

    skill_md = skill_dir / "SKILL.md"
    if not skill_md.exists():
        results.append(CheckResult("fail", "source", skill, "missing SKILL.md"))
        return results

    frontmatter, error = parse_frontmatter(skill_md)
    if error:
        results.append(CheckResult("fail", "source", skill, error))
    else:
        unexpected = sorted(set(frontmatter) - ALLOWED_FRONTMATTER_KEYS)
        if unexpected:
            results.append(
                CheckResult(
                    "fail",
                    "source",
                    skill,
                    f"unexpected frontmatter keys: {', '.join(unexpected)}",
                )
            )
        if frontmatter.get("name") != expected_name:
            results.append(
                CheckResult(
                    "fail",
                    "source",
                    skill,
                    f"frontmatter name is {frontmatter.get('name')!r}, expected {expected_name!r}",
                )
            )
        if not frontmatter.get("description"):
            results.append(CheckResult("fail", "source", skill, "missing description"))

    for rel in SKILL_DEPENDENCIES.get(skill, {}).get("files", ()):
        if not (skill_dir / rel).exists():
            results.append(CheckResult("fail", "source", skill, f"missing packaged file: {rel}"))

    install_md = skill_dir / "install.md"
    if install_md.exists():
        install_text = install_md.read_text(encoding="utf-8")
        missing_headings = [
            heading for heading in INSTALL_MD_HEADINGS if heading not in install_text
        ]
        if missing_headings:
            results.append(
                CheckResult(
                    "fail",
                    "source",
                    skill,
                    "install.md is missing heading(s): " + ", ".join(missing_headings),
                )
            )
    else:
        results.append(
            CheckResult(
                "warn",
                "source",
                skill,
                "missing install.md; reusable MetaSkill skills should document install, update, verification, and rollback steps",
            )
        )

    private_hits = []
    for path in iter_text_files(skill_dir):
        try:
            for index, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
                if PRIVATE_PATTERN.search(line):
                    private_hits.append(f"{path.relative_to(skill_dir)}:{index}")
                    break
        except UnicodeDecodeError:
            continue
    if private_hits:
        results.append(
            CheckResult(
                "warn",
                "source",
                skill,
                "review possible private markers: " + ", ".join(private_hits[:8]),
            )
        )

    if not results:
        results.append(CheckResult("pass", "source", skill, "source package looks valid"))
    return results


def command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def command_probe(name: str, timeout: int) -> tuple[bool, str]:
    if not command_exists(name):
        return False, "not found on PATH"
    try:
        completed = subprocess.run(
            [name, "--version"],
            check=False,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
    except Exception as exc:  # noqa: BLE001 - report diagnostics, do not hide them.
        return False, f"version probe failed: {exc}"
    output = (completed.stdout or completed.stderr).strip().splitlines()
    first_line = output[0] if output else f"exit code {completed.returncode}"
    return completed.returncode == 0, first_line


def check_installed_skill(
    skills_root: Path,
    skill: str,
    probe_commands: bool,
    probe_timeout: int,
    deepseek_verify: bool,
    deepseek_model: str,
) -> list[CheckResult]:
    results: list[CheckResult] = []
    installed = skills_root / skill
    if not installed.exists():
        return [
            CheckResult(
                "fail",
                "installed",
                skill,
                f"not installed at {installed}",
            )
        ]
    if not (installed / "SKILL.md").exists():
        results.append(CheckResult("fail", "installed", skill, "installed skill is missing SKILL.md"))
    if (installed / "install.md").exists():
        results.append(CheckResult("pass", "installed", skill, "install.md present"))
    else:
        results.append(CheckResult("warn", "installed", skill, "install.md not present"))

    for required in SKILL_DEPENDENCIES.get(skill, {}).get("skills", ()):
        if (skills_root / required / "SKILL.md").exists():
            results.append(CheckResult("pass", "installed", skill, f"companion skill installed: {required}"))
        else:
            results.append(CheckResult("fail", "installed", skill, f"missing companion skill: {required}"))

    for rel in SKILL_DEPENDENCIES.get(skill, {}).get("files", ()):
        if (installed / rel).exists():
            results.append(CheckResult("pass", "installed", skill, f"packaged file present: {rel}"))
        else:
            results.append(CheckResult("fail", "installed", skill, f"missing packaged file: {rel}"))

    for command in SKILL_DEPENDENCIES.get(skill, {}).get("commands", ()):
        if probe_commands:
            ok, message = command_probe(command, probe_timeout)
        else:
            ok, message = command_exists(command), "found on PATH" if command_exists(command) else "not found on PATH"
        results.append(CheckResult("pass" if ok else "fail", "installed", skill, f"{command}: {message}"))

    for group in SKILL_DEPENDENCIES.get(skill, {}).get("command_groups", ()):
        found = [command for command in group if command_exists(command)]
        if found:
            results.append(CheckResult("pass", "installed", skill, "one command found: " + " or ".join(group)))
        else:
            results.append(CheckResult("fail", "installed", skill, "one of these commands is required: " + " or ".join(group)))

    for connector in SKILL_DEPENDENCIES.get(skill, {}).get("connectors", ()):
        results.append(
            CheckResult(
                "warn",
                "installed",
                skill,
                f"verify connector manually in Codex app: {connector}",
            )
        )

    if skill == "deepseek-agent" and deepseek_verify:
        script = installed / "scripts" / "setup_opencode_deepseek.ps1"
        shell = shutil.which("pwsh") or shutil.which("powershell")
        if not script.exists():
            results.append(CheckResult("fail", "installed", skill, f"missing credential helper: {script}"))
        elif shell is None:
            results.append(CheckResult("fail", "installed", skill, "DeepSeek verification requires pwsh or powershell"))
        else:
            command = [
                shell,
                "-NoProfile",
                "-ExecutionPolicy",
                "Bypass",
                "-File",
                str(script),
                "-Workspace",
                ".",
                "-Model",
                deepseek_model,
                "-TimeoutSeconds",
                str(probe_timeout),
            ]
            completed = subprocess.run(
                command,
                check=False,
                capture_output=True,
                text=True,
                timeout=probe_timeout + 30,
            )
            summary = (completed.stdout or completed.stderr).strip().splitlines()
            message = summary[0] if summary else f"exit code {completed.returncode}"
            results.append(
                CheckResult(
                    "pass" if completed.returncode == 0 else "fail",
                    "installed",
                    skill,
                    f"deepseek OpenCode verification: {message}",
                )
            )

    if not results:
        results.append(CheckResult("pass", "installed", skill, "installed package looks valid"))
    return results


def print_text(results: list[CheckResult]) -> None:
    for result in results:
        print(f"[{result.status.upper()}] {result.scope}:{result.skill} - {result.message}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", default="skill-examples", help="path to the source skill-examples directory")
    parser.add_argument("--skills-root", default=str(default_skills_root()), help="installed Codex skills directory")
    parser.add_argument("--skill", action="append", choices=KNOWN_SKILLS, help="skill name to check; repeatable")
    parser.add_argument("--source-only", action="store_true", help="validate source packages only")
    parser.add_argument("--installed-only", action="store_true", help="validate installed skills only")
    parser.add_argument("--skip-command-probes", action="store_true", help="only check command presence, not --version")
    parser.add_argument("--deepseek-verify", action="store_true", help="run the installed deepseek-agent OpenCode credential helper")
    parser.add_argument("--deepseek-doctor", action="store_true", help="deprecated alias for --deepseek-verify")
    parser.add_argument("--deepseek-model", default="deepseek/deepseek-chat", help="OpenCode provider/model to use for DeepSeek verification")
    parser.add_argument("--probe-timeout", type=int, default=20, help="seconds for each command probe")
    parser.add_argument("--strict", action="store_true", help="treat warnings as failures")
    parser.add_argument("--json", action="store_true", help="emit JSON")
    args = parser.parse_args()

    if args.source_only and args.installed_only:
        parser.error("Use only one of --source-only or --installed-only.")

    source_root = Path(args.source_root)
    skills_root = Path(args.skills_root).expanduser()
    skills = tuple(args.skill or KNOWN_SKILLS)

    results: list[CheckResult] = []
    deepseek_verify = args.deepseek_verify or args.deepseek_doctor
    if args.deepseek_doctor:
        results.append(
            CheckResult(
                "warn",
                "environment",
                "deepseek-agent",
                "--deepseek-doctor is deprecated; use --deepseek-verify",
            )
        )
    if not args.source_only and "CODEX_HOME" not in os.environ:
        results.append(
            CheckResult(
                "warn",
                "environment",
                "all",
                "CODEX_HOME is unset; using ~/.codex/skills as the default installed skills root",
            )
        )

    if not args.installed_only:
        for skill in skills:
            results.extend(check_source_skill(source_root / skill, skill))

    if not args.source_only:
        for skill in skills:
            results.extend(
                check_installed_skill(
                    skills_root,
                    skill,
                    probe_commands=not args.skip_command_probes,
                    probe_timeout=args.probe_timeout,
                    deepseek_verify=deepseek_verify,
                    deepseek_model=args.deepseek_model,
                )
            )

    if args.json:
        print(json.dumps([asdict(result) for result in results], indent=2))
    else:
        print_text(results)

    has_fail = any(result.status == "fail" for result in results)
    has_warn = any(result.status == "warn" for result in results)
    return 1 if has_fail or (args.strict and has_warn) else 0


if __name__ == "__main__":
    sys.exit(main())
