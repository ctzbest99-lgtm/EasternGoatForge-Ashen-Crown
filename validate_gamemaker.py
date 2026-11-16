#!/usr/bin/env python3
"""Validate the generated ASHEN CROWN GameMaker project against its sources."""
from __future__ import annotations
import json, re, sys
from pathlib import Path
try:
    from PIL import Image
except ImportError:
    print("ERROR: Pillow is required: python -m pip install Pillow", file=sys.stderr)
    raise SystemExit(2)

ROOT = Path(__file__).resolve().parent
SRC, OUT = ROOT / "game", ROOT / "gamemaker"
errors = []
counts = {"json": 0, "resources": 0, "scripts": 0, "datafiles": 0, "rooms": 0}

def fail(message): errors.append(message)
def rel(path):
    try: return path.relative_to(ROOT).as_posix()
    except ValueError: return str(path)
def load_json(path):
    try:
        raw = path.read_text(encoding="utf-8")
        value = json.loads(re.sub(r",(\s*[}\]])", r"\1", raw))
        counts["json"] += 1
        return value
    except FileNotFoundError:
        fail(f"MISSING FILE: {rel(path)}")
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        fail(f"INVALID JSON: {rel(path)}: {exc}")
    return None
def safe_load(path, context):
    value = load_json(path)
    if value is None: fail(f"UNREADABLE RESOURCE: {context}")
    return value
def report():
    if errors:
        print(f"VALIDATION FAILED ({len(errors)} issue(s))")
        for error in errors: print(f" - {error}")
        return 1
    print("ALL CHECKS PASSED")
    return 0
def check_paths(value, source):
    if isinstance(value, dict):
        for key, child in value.items():
            if key == "path" and isinstance(child, str) and child.startswith(
                ("sprites/", "objects/", "scripts/", "rooms/", "folders/", "texturegroups/", "tilesets/")
            ):
                if not child.startswith(("folders/", "texturegroups/")) and not (OUT / child).exists():
                    fail(f"MISSING PATH: {child} (referenced by {rel(source)})")
            else: check_paths(child, source)
    elif isinstance(value, list):
        for child in value: check_paths(child, source)

EVENT_NAMES = {
    (0, 0): "Create_0", (3, 0): "Step_0", (3, 1): "Step_1",
    (3, 2): "Step_2", (7, 2): "Other_2", (8, 64): "Draw_64",
    (12, 0): "CleanUp_0",
}
def check_object(name, path):
    obj = safe_load(path, name)
    if not isinstance(obj, dict): return
    expected = set()
    for event in obj.get("eventList", []):
        if not isinstance(event, dict):
            fail(f"{name}: malformed event entry"); continue
        key = (event.get("eventType"), event.get("eventNum"))
        if key not in EVENT_NAMES: fail(f"{name}: unsupported event {key}")
        else: expected.add(EVENT_NAMES[key])
    actual = {p.stem for p in path.parent.glob("*.gml")}
    if expected != actual:
        fail(f"{name}: event files differ; expected {sorted(expected)}, found {sorted(actual)}")

def check_sprite(name, path):
    sp = safe_load(path, name)
    if not isinstance(sp, dict): return
    frames, layers = sp.get("frames"), sp.get("layers")
    if not isinstance(frames, list) or not isinstance(layers, list):
        fail(f"{name}: frames/layers must be arrays"); return
    width, height = sp.get("width"), sp.get("height")
    if not isinstance(width, int) or not isinstance(height, int) or width <= 0 or height <= 0:
        fail(f"{name}: invalid dimensions")
    layer_names = [layer.get("name") for layer in layers if isinstance(layer, dict)]
    if not layer_names or len(layer_names) != len(layers): fail(f"{name}: malformed or missing layers")
    for frame in frames:
        if not isinstance(frame, dict) or not isinstance(frame.get("name"), str):
            fail(f"{name}: malformed frame"); continue
        frame_name = frame["name"]
        png = path.parent / f"{frame_name}.png"
        if not png.is_file(): fail(f"{name}: frame PNG missing: {rel(png)}")
        else:
            try:
                with Image.open(png) as im:
                    if isinstance(width, int) and isinstance(height, int) and im.size != (width, height):
                        fail(f"{name}: {png.name} size {im.size}, expected {(width, height)}")
                    im.verify()
            except Exception as exc: fail(f"{name}: invalid image {png.name}: {exc}")
        for layer_name in layer_names:
            layer_png = path.parent / "layers" / frame_name / f"{layer_name}.png"
            if not layer_png.is_file(): fail(f"{name}: layer PNG missing: {rel(layer_png)}")
    sequence = sp.get("sequence")
    if not isinstance(sequence, dict): fail(f"{name}: sequence missing"); return
    try:
        keyframes = sequence["tracks"][0]["keyframes"]["Keyframes"]
        if len(keyframes) != len(frames): fail(f"{name}: keyframe count differs from frame count")
    except (KeyError, IndexError, TypeError): fail(f"{name}: malformed sequence keyframes")
    try:
        if float(sequence.get("length")) != float(len(frames)): fail(f"{name}: sequence length differs from frame count")
    except (TypeError, ValueError): fail(f"{name}: invalid sequence length")
    required = {
        "spr_ui_window", "spr_ui_window_dim", "spr_ui_window_gold", "spr_ui_select_bar",
        "spr_ui_slider_track", "spr_ui_row_select", "spr_ui_row_select_disabled",
        "spr_ui_tab_blank_strip2", "spr_ui_portrait_frame", "spr_ui_leader_frame", "spr_ui_qty_field",
    }
    if name in required and not (isinstance(sp.get("nineSlice"), dict) and sp["nineSlice"].get("enabled")):
        fail(f"{name}: nine-slice not enabled")

def main():
    if not SRC.is_dir(): fail("SOURCE DIRECTORY MISSING: game/")
    if not OUT.is_dir(): fail("GENERATED PROJECT DIRECTORY MISSING: gamemaker/")
    if errors: return report()
    project = safe_load(OUT / "AshenCrown.yyp", "AshenCrown.yyp")
    if not isinstance(project, dict): return report()

    parsed = []
    for path in OUT.rglob("*"):
        if path.is_file() and path.suffix in {".yyp", ".yy", ".resource_order"}:
            data = load_json(path)
            if isinstance(data, dict): parsed.append((path, data)); check_paths(data, path)

    resources = project.get("resources")
    if not isinstance(resources, list):
        fail("AshenCrown.yyp: resources must be an array"); resources = []
    names, paths, by_name = [], [], {}
    for entry in resources:
        try: name, resource = entry["id"]["name"], entry["id"]["path"]
        except (KeyError, TypeError): fail("AshenCrown.yyp: malformed resource entry"); continue
        if not isinstance(name, str) or not isinstance(resource, str):
            fail("AshenCrown.yyp: resource name/path must be strings"); continue
        names.append(name); paths.append(resource); by_name[name] = resource
        file = OUT / resource
        if not file.is_file(): fail(f"RESOURCE FILE MISSING: {resource}"); continue
        counts["resources"] += 1
        if resource.startswith("sprites/"): check_sprite(name, file)
        elif resource.startswith("objects/"): check_object(name, file)
    if len(names) != len(set(names)): fail("AshenCrown.yyp: duplicate resource names")
    if len(paths) != len(set(paths)): fail("AshenCrown.yyp: duplicate resource paths")

    source_scripts = SRC / "scripts"
    if source_scripts.is_dir():
        expected = {f"{p.stem}/{p.name}" for p in source_scripts.glob("*.gml")}
        actual = {p.relative_to(OUT / "scripts").as_posix() for p in (OUT / "scripts").rglob("*.gml")} if (OUT / "scripts").is_dir() else set()
        if expected != actual: fail(f"SCRIPT SET DIFFERS: {sorted(expected ^ actual)}")
        for source in sorted(source_scripts.glob("*.gml")):
            target = OUT / "scripts" / source.stem / source.name
            if not target.is_file(): fail(f"GENERATED SCRIPT MISSING: {rel(target)}")
            elif source.read_bytes() != target.read_bytes(): fail(f"SCRIPT DIFFERS: {source.name}")
            counts["scripts"] += 1

    source_data, generated_data = SRC / "datafiles", OUT / "datafiles"
    if source_data.is_dir():
        src_files = {p.relative_to(source_data).as_posix(): p for p in source_data.rglob("*") if p.is_file()}
        out_files = {p.relative_to(generated_data).as_posix(): p for p in generated_data.rglob("*") if p.is_file()} if generated_data.is_dir() else {}
        if set(src_files) != set(out_files): fail(f"DATAFILE SET DIFFERS: {sorted(set(src_files) ^ set(out_files))}")
        for name in sorted(set(src_files) & set(out_files)):
            if src_files[name].read_bytes() != out_files[name].read_bytes(): fail(f"DATAFILE DIFFERS: {name}")
            counts["datafiles"] += 1
    included = {item.get("name") for item in project.get("IncludedFiles", []) if isinstance(item, dict)}
    on_disk = {p.relative_to(generated_data).as_posix() for p in generated_data.rglob("*") if p.is_file()} if generated_data.is_dir() else set()
    if included != on_disk: fail(f"INCLUDED FILES DIFFER: {sorted(included ^ on_disk)}")

    rooms = {}
    for entry in resources:
        try: name, resource = entry["id"]["name"], entry["id"]["path"]
        except (KeyError, TypeError): continue
        if not resource.startswith("rooms/"): continue
        room = safe_load(OUT / resource, name)
        if not isinstance(room, dict): continue
        rooms[name] = room; counts["rooms"] += 1
        settings = room.get("roomSettings", {})
        width, height = settings.get("Width"), settings.get("Height")
        if not isinstance(width, int) or not isinstance(height, int):
            fail(f"{name}: invalid dimensions"); continue
        layers = room.get("layers", [])
        layer_names = {layer.get("name") for layer in layers if isinstance(layer, dict)}
        for required in ("Instances", "Ground", "Decoration", "Overhead", "Collision", "Markers"):
            if required not in layer_names: fail(f"{name}: layer {required} missing")
        for layer in layers:
            if not isinstance(layer, dict): continue
            if layer.get("resourceType") == "GMRTileLayer":
                tile = layer.get("tilesetId", {}).get("name")
                if tile not in {"ts_zone1", "ts_wrenfield"}: fail(f"{name}: unknown tileset {tile}")
            if layer.get("resourceType") == "GMRInstanceLayer":
                for inst in layer.get("instances", []):
                    x, y = inst.get("x"), inst.get("y")
                    if not isinstance(x, (int, float)) or not isinstance(y, (int, float)) or not (0 <= x <= width and 0 <= y <= height):
                        fail(f"{name}: instance out of bounds ({x}, {y})")
        views = room.get("views", [])
        if views and (views[0].get("wview", 0) > width or views[0].get("hview", 0) > height):
            fail(f"{name}: view exceeds room dimensions")

    field_rooms = (
        "rm_overworld", "rm_old_watchtower", "rm_watchtower_basement", "rm_greyhaven_varyn_house",
        "rm_greyhaven_tavern", "rm_greyhaven_chapel", "rm_greyhaven_blacksmith", "rm_greyhaven_general_store",
        "rm_millhaven_road", "rm_wrenfield", "rm_wrenfield_bent_post", "rm_wrenfield_store",
        "rm_valemere_road", "rm_valemere", "rm_salt_lamp", "rm_warehouse", "rm_hollow_approach", "rm_hollow_sanctuary",
    )
    for name in field_rooms:
        room = rooms.get(name)
        if room is None: fail(f"REQUIRED ROOM MISSING: {name}"); continue
        objs = [i.get("objectId", {}).get("name") for layer in room.get("layers", []) if layer.get("resourceType") == "GMRInstanceLayer" for i in layer.get("instances", [])]
        if "obj_player" not in objs: fail(f"{name}: obj_player missing")
    title = rooms.get("rm_title")
    if title is None: fail("REQUIRED ROOM MISSING: rm_title")
    else:
        objs = [i.get("objectId", {}).get("name") for layer in title.get("layers", []) if layer.get("resourceType") == "GMRInstanceLayer" for i in layer.get("instances", [])]
        if "obj_title" not in objs or "obj_game_controller" not in objs: fail("rm_title: title/controller missing")
        if "obj_player" in objs: fail("rm_title: player should not be placed")
    order = [node.get("roomId", {}).get("name") for node in project.get("RoomOrderNodes", [])]
    if order[:2] != ["rm_title", "rm_overworld"]: fail(f"ROOM ORDER WRONG: {order}")

    known = set(by_name) | {"ts_zone1", "ts_wrenfield"}
    refs = set()
    for file in OUT.rglob("*.gml"):
        try: refs.update(re.findall(r"\b((?:spr|obj|ts|rm)_\w+)\b", file.read_text(encoding="utf-8")))
        except (OSError, UnicodeError) as exc: fail(f"UNREADABLE GML {rel(file)}: {exc}")
    missing = {ref for ref in refs - known if not ref.endswith("_")}
    if missing: fail(f"UNRESOLVED GML REFERENCES: {sorted(missing)}")

    groups = {item.get("name") for item in project.get("TextureGroups", []) if isinstance(item, dict)}
    if "tex_title_640" not in groups: fail("tex_title_640 group missing from project")
    for entry in resources:
        try: name, resource = entry["id"]["name"], entry["id"]["path"]
        except (KeyError, TypeError): continue
        if resource.startswith("sprites/"):
            sprite = load_json(OUT / resource)
            if not isinstance(sprite, dict): continue
            group = sprite.get("textureGroupId", {}).get("name")
            is_640 = "640" in name and any(token in name for token in ("menu", "title", "logo"))
            expected = "tex_title_640" if is_640 else "Default"
            if group != expected: fail(f"{name}: expected {expected}, got {group}")
    if "spr_menu_embers_640_strip24" not in by_name: fail("640 title ember strip missing")

    print(f"Validated {counts['json']} JSON files, {counts['resources']} resources, {counts['scripts']} scripts, {counts['datafiles']} datafiles, {counts['rooms']} rooms")
    return report()

if __name__ == "__main__":
    raise SystemExit(main())
