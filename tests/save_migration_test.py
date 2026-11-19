#!/usr/bin/env python3
"""Fixture and wiring contract for the v1-v4 save migration and Chapter 1 quest.

This is the CI-safe half of the check. The executable half is
scr_save_migration_test() in game/scripts/scr_save.gml, which calls the real
scr_save_migrate() and scr_save_apply_member() against these same fixtures.
That GML test needs a GameMaker runtime, so CI cannot run it.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIXTURE_DIR = ROOT / "game" / "datafiles" / "tests" / "saves"


def fail(message: str) -> None:
    raise AssertionError(message)


def load_fixture(name: str) -> dict:
    path = FIXTURE_DIR / name
    if not path.is_file():
        fail(f"missing fixture: {path}")
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"{name} is not valid JSON: {exc}")
    if not isinstance(data, dict):
        fail(f"{name} must contain a JSON object")
    return data


def check_fixtures() -> None:
    cases = [
        ("v1_kael.json", 1, "kael"),
        ("v2_kael.json", 2, "kael"),
        ("v3_kael.json", 3, "kael"),
        ("v4_caelan.json", 4, "caelan"),
    ]
    for name, version, actor_id in cases:
        data = load_fixture(name)
        if data.get("save_schema_version") != version:
            fail(f"{name}: save_schema_version must be {version}")
        roster = data.get("roster")
        if not isinstance(roster, list) or not roster:
            fail(f"{name}: roster must be a non-empty array")
        snap = roster[0]
        if snap.get("actor_id") != actor_id:
            fail(f"{name}: expected actor {actor_id!r}")
        for key in ("max_hp", "attack", "base_attack", "level"):
            if key not in snap:
                fail(f"{name}: missing {key}")
        if version < 4:
            # These are exactly the fields the old-save repair must synthesize.
            for key in ("base_max_hp", "base_max_mp", "base_magic"):
                if key in snap:
                    fail(f"{name}: pre-v4 fixture must not contain {key}")
            if snap["attack"] <= 0:
                fail(f"{name}: attack must be positive for the MAG fallback")
        else:
            for key in ("base_max_hp", "base_max_mp", "base_magic"):
                if key not in snap:
                    fail(f"{name}: v4 fixture must contain {key}")
            if snap["base_max_hp"] != snap["max_hp"]:
                fail(f"{name}: v4 base_max_hp should match max_hp")
            if snap["base_max_mp"] != snap["max_mp"]:
                fail(f"{name}: v4 base_max_mp should match max_mp")
        if version >= 2 and "max_mp" not in snap:
            fail(f"{name}: v2+ fixture must contain max_mp")
        if version == 1 and "max_mp" in snap:
            fail(f"{name}: v1 fixture must exercise the synthesized max_mp path")
        # Sanitized: no player names, e-mail addresses, or absolute paths.
        text = (FIXTURE_DIR / name).read_text(encoding="utf-8")
        for marker in ("@", "/home/", "C:\\", "steamuser"):
            if marker in text:
                fail(f"{name}: fixture is not sanitized ({marker!r})")


def check_gml_wiring() -> None:
    save = (ROOT / "game" / "scripts" / "scr_save.gml").read_text(encoding="utf-8")
    quest = (ROOT / "game" / "scripts" / "scr_quest_data.gml").read_text(encoding="utf-8")
    story = (ROOT / "game" / "scripts" / "scr_story.gml").read_text(encoding="utf-8")
    dialogue = (ROOT / "game" / "scripts" / "scr_dialogue_data.gml").read_text(encoding="utf-8")
    begin = (ROOT / "game" / "objects" / "obj_game_controller" / "Begin_Step.gml").read_text(
        encoding="utf-8"
    )
    yyp = (ROOT / "gamemaker" / "AshenCrown.yyp").read_text(encoding="utf-8")

    if "function scr_save_migration_test" not in save:
        fail("scr_save.gml is missing scr_save_migration_test")
    if 'if (variable_struct_exists(_snap, "base_magic"))' not in save:
        fail("scr_save_apply_member must honor an explicit base_magic")
    if '_actor.base_magic = _snap.attack' not in save:
        fail("scr_save_apply_member must fall back to saved attack for pre-v4 MAG")
    for name, _, _ in [
        ("v1_kael.json", 1, "kael"),
        ("v2_kael.json", 2, "kael"),
        ("v3_kael.json", 3, "kael"),
        ("v4_caelan.json", 4, "caelan"),
    ]:
        if f"tests/saves/{name}" not in save:
            fail(f"scr_save_migration_test does not reference {name}")
        if f"tests/saves/{name}" not in yyp:
            fail(f"AshenCrown.yyp does not include tests/saves/{name}")

    if 'id: "Q_MAIN_FIND_MIRA"' not in quest:
        fail("scr_quest_data.gml is missing Q_MAIN_FIND_MIRA")
    for index in range(1, 10):
        if f'"Q_FM_S{index}"' not in quest:
            fail(f"Q_MAIN_FIND_MIRA is missing stage Q_FM_S{index}")
    if "function scr_quest_advance" not in quest:
        fail("scr_quest_data.gml is missing the ordered quest helper")
    if "function scr_ch1_quest_tick" not in story:
        fail("scr_story.gml is missing scr_ch1_quest_tick")
    for stage in ("Q_FM_S1", "Q_FM_S2", "Q_FM_S3", "Q_FM_S9"):
        if stage not in dialogue:
            fail(f"dialogue callbacks do not advance {stage}")
    if "scr_ch1_quest_tick();" not in begin:
        fail("Begin_Step.gml does not call scr_ch1_quest_tick")
    if 'scr_quest_set("Q_MAIN_FIND_MIRA", "complete")' not in story:
        fail("Blackguard victory does not complete Q_MAIN_FIND_MIRA")
    if 'scr_quest_advance("Q_MAIN_BEYOND_VEIL", "Q_BV_S1")' not in dialogue:
        fail("CV_END does not start Q_MAIN_BEYOND_VEIL")


def main() -> int:
    try:
        check_fixtures()
        check_gml_wiring()
    except AssertionError as exc:
        print(f"FAIL: {exc}")
        return 1
    print("save migration fixtures and Chapter 1 quest wiring: OK")
    print("runtime GML self-test: NOT RUN (requires GameMaker)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
