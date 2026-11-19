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
UUID_RE = re.compile(r"\b[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\b", re.I)
INSTANCE_RE = re.compile(r"\binst_[0-9A-F]{8}\b")


def normalize_json(data: bytes) -> bytes:
    text = data.decode("utf-8")
    value = json.loads(re.sub(r",(\s*[}\]])", r"\1", text))

    def visit(item):
        if isinstance(item, str):
            item = UUID_RE.sub("<generated-uuid>", item)
            if re.fullmatch(r"inst_[A-Za-z0-9_]+", item):
                return "<generated-instance>"
            return INSTANCE_RE.sub("<generated-instance>", item)
        if isinstance(item, list):
            return [visit(child) for child in item]
        if isinstance(item, dict):
            normalized = {}
            for key, child in item.items():
                # GameMaker has emitted both spellings for the same DnD flag.
                canonical_key = "isDnD" if key in {"isDnD", "isDnd"} else key
                normalized[canonical_key] = visit(child)
            # These arrays are IDE resource listings, not runtime room order.
            if isinstance(normalized.get("resources"), list):
                normalized["resources"].sort(key=lambda entry: entry.get("id", {}).get("name", ""))
            if isinstance(normalized.get("ResourceOrderSettings"), list):
                # IDE display order is user preference, not generated game content.
                for entry in normalized["ResourceOrderSettings"]:
                    if isinstance(entry, dict):
                        entry.pop("order", None)
                normalized["ResourceOrderSettings"].sort(key=lambda entry: entry.get("name", ""))
            return normalized
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
                raw = re.sub(r",(\s*[}\]])", r"\1", meta.read_text(encoding="utf-8"))
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
        # Rooms and sounds contain IDE-authored content and binary assets that the
        # source generator does not own. Preserve them; do not compare or replace them.
        if relative.parts and relative.parts[0] in {"rooms", "sounds"}:
            continue
        key = relative.as_posix()
        data = path.read_bytes()
        if path.suffix.lower() == ".png" and relative.parts and relative.parts[0] == "sprites":
            sprite_dir = root / "sprites" / relative.parts[1]
            maps = sprite_metadata.get(sprite_dir)
            if maps:
                frame_map, layer_map = maps
                parts = relative.parts[2:]
                if len(parts) == 1:
                    frame = frame_map.get(path.stem)
                    if frame is not None:
                        key = f"sprites/{sprite_dir.name}/@frame/{frame:05d}.png"
                elif len(parts) == 3 and parts[0] == "layers":
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


def compare(current: Path, built: Path, *, code_only: bool = False):
    old, new = inventory(current), inventory(built)
    added = sorted(new.keys() - old.keys())
    # Generator output is additive/update-only. Live-only files are preserved because
    # they may be authored in the IDE or supplied by an asset pipeline.
    removed: list[str] = []
    changed = sorted(
        name for name in old.keys() & new.keys()
        if old[name][1] != new[name][1]
    )
    if code_only:
        # CI gates source/generated GML parity. Resource metadata and imported binary
        # assets are reviewed through the full dry-run and project validator instead.
        added = [name for name in added if name.endswith(".gml")]
        changed = [name for name in changed if name.endswith(".gml")]
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
        # Run the additional source-driven asset importers after the base generator.
        for command in (
            [sys.executable, "tools/gen_blackwood_tileset.py"],
            [sys.executable, "tools/import_sprites.py"],
        ):
            step = subprocess.run(
                command, cwd=work, text=True,
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            )
            if step.returncode:
                print("ERROR: asset generation failed; live project untouched.\\n" + step.stdout)
                return step.returncode

        validation = subprocess.run(
            [sys.executable, "validate_gamemaker.py"], cwd=work, text=True,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        )
        if validation.returncode:
            print("ERROR: generated output failed validation; live project untouched.\\n" + validation.stdout)
            return validation.returncode

        generated = work / "gamemaker"
        added, removed, changed = compare(live, generated, code_only=args.check)
        total = len(added) + len(removed) + len(changed)
        if not args.quiet:
            print(f"Generated project validated. Managed file changes: {total}")
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

        # Apply only generated additions and updates. Never replace the whole project
        # tree and never delete live-only resources: IDE-authored rooms, sounds, and
        # other assets may not have a source-side representation yet.
        for name in added + changed:
            source = generated / name
            destination = live / name
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, destination)
        print(f"SYNC APPLIED: added/updated {total} generated files; preserved all live-only resources.")
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
