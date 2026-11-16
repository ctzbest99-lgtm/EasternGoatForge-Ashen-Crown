#!/usr/bin/env python3
"""Safely regenerate gamemaker/ from game/ using the repository generator."""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IGNORED = shutil.ignore_patterns(
    ".git", ".venv", "venv", "__pycache__", ".pytest_cache",
    ".mypy_cache", ".ruff_cache", ".DS_Store",
)
UUID_RE = re.compile(r"\\b[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\\b", re.I)
INSTANCE_RE = re.compile(r"\\binst_[0-9A-F]{8}\\b")


def normalize_json(data: bytes) -> bytes:
    text = data.decode("utf-8")
    value = json.loads(re.sub(r",(\\s*[}\\]])", r"\\1", text))

    def visit(item):
        if isinstance(item, str):
            item = UUID_RE.sub("<generated-uuid>", item)
            return INSTANCE_RE.sub("<generated-instance>", item)
        if isinstance(item, list):
            return [visit(child) for child in item]
        if isinstance(item, dict):
            return {key: visit(child) for key, child in item.items()}
        return item

    return json.dumps(visit(value), sort_keys=True, separators=(",", ":")).encode("utf-8")


def inventory(root: Path) -> dict[str, tuple[Path, bytes]]:
    """Build a stable inventory that ignores generator-only random identifiers."""
    result: dict[str, tuple[Path, bytes]] = {}
    sprite_root = root / "sprites"
    sprite_metadata = {}
    if sprite_root.is_dir():
        for meta in sprite_root.glob("*/**/*.yy"):
            if meta.parent.parent != sprite_root:
                continue
            try:
                raw = re.sub(r",(\\s*[}\\]])", r"\\1", meta.read_text(encoding="utf-8"))
                obj = json.loads(raw)
                frames = [frame.get("name") for frame in obj.get("frames", [])]
                layers = [layer.get("name") for layer in obj.get("layers", [])]
                sprite_metadata[meta.parent] = (
                    {name: index for index, name in enumerate(frames)},
                    {name: index for index, name in enumerate(layers)},
                )
            except (OSError, UnicodeError, json.JSONDecodeError, AttributeError):
                continue

    for path in root.rglob("*"):
        if not path.is_file():
            continue
        relative = path.relative_to(root)
        key = relative.as_posix()
        data = path.read_bytes()
        if path.suffix.lower() == ".png" and relative.parts and relative.parts[0] == "sprites":
            sprite_dir = root / "sprites" / relative.parts[1]
            maps = sprite_metadata.get(sprite_dir)
            if maps:
                frame_map, layer_map = maps
                parts = relative.parts[2:]
                if len(parts) == 3:
                    frame = frame_map.get(path.stem)
                    if frame is not None:
                        key = f"sprites/{sprite_dir.name}/@frame/{frame:05d}.png"
                elif len(parts) == 4 and parts[0] == "layers":
                    frame = frame_map.get(parts[1])
                    layer = layer_map.get(path.stem)
                    if frame is not None and layer is not None:
                        key = f"sprites/{sprite_dir.name}/@layer/{frame:05d}/{layer:03d}.png"
        if path.suffix.lower() in {".yy", ".yyp", ".resource_order"}:
            try:
                data = normalize_json(data)
            except (UnicodeError, json.JSONDecodeError):
                pass
        if key in result:
            raise RuntimeError(f"normalized output collision: {key}")
        result[key] = (path, data)
    return result


def compare(current: Path, built: Path):
    old, new = inventory(current), inventory(built)
    added = sorted(new.keys() - old.keys())
    removed = sorted(old.keys() - new.keys())
    changed = sorted(
        name for name in old.keys() & new.keys()
        if old[name][1] != new[name][1]
    )
    return added, removed, changed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true", help="fail if generated output is stale")
    mode.add_argument("--apply", action="store_true", help="replace gamemaker/ after successful build and validation")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    if not (ROOT / "gen_gamemaker.py").is_file() or not (ROOT / "game").is_dir():
        print("ERROR: incomplete repository checkout", file=sys.stderr)
        return 2
    live = ROOT / "gamemaker"
    if not live.is_dir():
        print("ERROR: gamemaker/ missing; refusing implicit creation", file=sys.stderr)
        return 2

    with tempfile.TemporaryDirectory(prefix="ashen-crown-sync-") as temp:
        work = Path(temp) / "work"
        shutil.copytree(ROOT, work, ignore=IGNORED)
        build = subprocess.run(
            [sys.executable, "gen_gamemaker.py"], cwd=work, text=True,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        )
        if build.returncode:
            print("ERROR: generator failed; live project untouched.\\n" + build.stdout)
            return build.returncode
        validation = subprocess.run(
            [sys.executable, "validate_gamemaker.py"], cwd=work, text=True,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        )
        if validation.returncode:
            print("ERROR: generated output failed validation; live project untouched.\\n" + validation.stdout)
            return validation.returncode

        generated = work / "gamemaker"
        added, removed, changed = compare(live, generated)
        total = len(added) + len(removed) + len(changed)
        if not args.quiet:
            print(f"Generated project validated. Semantic file changes: {total}")
            for label, names in (("ADD", added), ("REMOVE", removed), ("UPDATE", changed)):
                for name in names:
                    print(f" {label:6} gamemaker/{name}")
        if total == 0:
            print("SYNC OK: generated project matches source inputs.")
            return 0
        if args.check:
            print("SYNC REQUIRED: run python tools/sync_gamemaker.py --apply")
            return 1
        if not args.apply:
            print("DRY RUN ONLY: no files changed. Review the list, then use --apply.")
            return 0

        stage = Path(tempfile.mkdtemp(prefix=".gamemaker-stage-", dir=ROOT))
        shutil.rmtree(stage)
        backup = ROOT / ".gamemaker-sync-backup"
        try:
            shutil.copytree(generated, stage)
            if backup.exists():
                print(f"ERROR: backup path already exists: {backup}", file=sys.stderr)
                return 2
            os.replace(live, backup)
            try:
                os.replace(stage, live)
            except Exception:
                os.replace(backup, live)
                raise
            shutil.rmtree(backup)
        except Exception:
            if backup.exists() and not live.exists():
                os.replace(backup, live)
            if stage.exists():
                shutil.rmtree(stage, ignore_errors=True)
            raise
        print(f"SYNC APPLIED: replaced gamemaker/ ({total} semantic file changes).")
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
