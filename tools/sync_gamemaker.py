#!/usr/bin/env python3
"""Safely regenerate gamemaker/ from game/ using the repository generator."""
from __future__ import annotations
import argparse, filecmp, os, shutil, subprocess, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IGNORED = shutil.ignore_patterns(".git", ".venv", "venv", "__pycache__", ".pytest_cache", ".mypy_cache", ".ruff_cache", ".DS_Store")

def inventory(root):
    return {p.relative_to(root).as_posix(): p for p in root.rglob("*") if p.is_file()} if root.is_dir() else {}

def compare(current, built):
    old, new = inventory(current), inventory(built)
    added, removed = sorted(new.keys() - old.keys()), sorted(old.keys() - new.keys())
    changed = sorted(name for name in old.keys() & new.keys() if not filecmp.cmp(old[name], new[name], shallow=False))
    return added, removed, changed

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true", help="fail if committed generated output is stale")
    mode.add_argument("--apply", action="store_true", help="replace gamemaker/ after successful build and validation")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()
    if not (ROOT / "gen_gamemaker.py").is_file() or not (ROOT / "game").is_dir():
        print("ERROR: incomplete repository checkout", file=sys.stderr); return 2
    live = ROOT / "gamemaker"
    if not live.is_dir():
        print("ERROR: gamemaker/ missing; refusing implicit creation", file=sys.stderr); return 2

    with tempfile.TemporaryDirectory(prefix="ashen-crown-sync-") as temp:
        work = Path(temp) / "work"
        shutil.copytree(ROOT, work, ignore=IGNORED)
        build = subprocess.run([sys.executable, "gen_gamemaker.py"], cwd=work, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if build.returncode:
            print("ERROR: generator failed; live project untouched.\n" + build.stdout); return build.returncode
        check = subprocess.run([sys.executable, "validate_gamemaker.py"], cwd=work, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if check.returncode:
            print("ERROR: generated output failed validation; live project untouched.\n" + check.stdout); return check.returncode
        built = work / "gamemaker"
        added, removed, changed = compare(live, built)
        total = len(added) + len(removed) + len(changed)
        if not args.quiet:
            print(f"Validated generated project. Proposed changes: {total}")
            for label, names in (("ADD", added), ("REMOVE", removed), ("UPDATE", changed)):
                for name in names: print(f" {label:6} gamemaker/{name}")
        if total == 0:
            print("SYNC OK: generated project is current."); return 0
        if args.check:
            print("SYNC REQUIRED: run python tools/sync_gamemaker.py --apply"); return 1
        if not args.apply:
            print("DRY RUN: no files changed. Review the list, then use --apply."); return 0

        stage = Path(tempfile.mkdtemp(prefix=".gamemaker-stage-", dir=ROOT))
        shutil.rmtree(stage)
        backup = ROOT / ".gamemaker-sync-backup"
        try:
            shutil.copytree(built, stage)
            if backup.exists():
                print(f"ERROR: backup path already exists: {backup}", file=sys.stderr); return 2
            os.replace(live, backup)
            try: os.replace(stage, live)
            except Exception:
                os.replace(backup, live); raise
            shutil.rmtree(backup)
        except Exception:
            if backup.exists() and not live.exists(): os.replace(backup, live)
            if stage.exists(): shutil.rmtree(stage, ignore_errors=True)
            raise
        print(f"SYNC APPLIED: replaced gamemaker/ ({total} changed files).")
        return 0

if __name__ == "__main__":
    raise SystemExit(main())
