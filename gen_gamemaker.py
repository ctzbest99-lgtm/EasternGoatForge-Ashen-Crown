#!/usr/bin/env python3
"""Generate the complete GameMaker project for ASHEN CROWN.

Run from the repo root:  python3 gen_gamemaker.py
Rebuilds gamemaker/ (AshenCrown.yyp + all resources) from game/.
Edits made in the GameMaker IDE are overwritten - keep game/ as the source of truth.

Data-driven: reads the repo's own import tables (game/sprites/IMPORT.md,
game/rooms/ROOM_SETUP.md facts baked in) and game/ source tree.
Format: GameMaker 2024.x project format.
"""
import json, os, re, shutil, uuid, random, sys
from PIL import Image

ROOT = os.path.abspath(os.path.dirname(__file__))   # repo root
SRC = os.path.join(ROOT, 'game')                    # game/ (scripts/, objects/, ...)
OUT = os.path.join(ROOT, 'gamemaker')
REF = None  # options are restored from the existing gamemaker/ tree

# ---------------------------------------------------------------- helpers
def gm(obj, ind=0):
    if obj is None: return "null"
    if obj is True: return "true"
    if obj is False: return "false"
    if isinstance(obj, str): return json.dumps(obj)
    if isinstance(obj, int): return str(obj)
    if isinstance(obj, float):
        return str(obj) if obj != int(obj) else str(int(obj)) + ".0"
    pad = "  " * ind
    if isinstance(obj, list):
        if not obj: return "[]"
        return "[\n" + ",\n".join(pad + "  " + gm(i, ind + 1) for i in obj) + ",\n" + pad + "]"
    if isinstance(obj, dict):
        if not obj: return "{}"
        return "{\n" + ",\n".join(pad + "  " + json.dumps(k) + ":" + gm(v, ind + 1)
                                   for k, v in obj.items()) + ",\n" + pad + "}"
    raise TypeError(obj)

def write_json(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', newline='\n') as f:
        f.write(gm(obj) + "\n")

def rid(): return str(uuid.uuid4())
def inst_name():
    return "inst_" + ''.join(random.choice("0123456789ABCDEF") for _ in range(8))

FOLDERS = ["objects", "rooms", "scripts", "sprites", "tilesets"]
RESOURCES = []

def parent_ref(folder):
    return {"name": folder, "path": f"folders/{folder}.yy"}

# back up committed extras (options tree, README) so the generator is self-contained
_options_backup = {}
if os.path.exists(os.path.join(OUT, 'options')):
    for root, dirs, files in os.walk(os.path.join(OUT, 'options')):
        for fn in files:
            p = os.path.join(root, fn)
            _options_backup[os.path.relpath(p, os.path.join(OUT, 'options'))] = open(p, 'rb').read()
_docs_backup = {}
if os.path.exists(OUT):
    for fn in os.listdir(OUT):
        if fn.endswith('.md'):
            _docs_backup[fn] = open(os.path.join(OUT, fn), 'rb').read()
if os.path.exists(OUT):
    shutil.rmtree(OUT)
os.makedirs(OUT)
for fn, data in _docs_backup.items():
    open(os.path.join(OUT, fn), 'wb').write(data)

# ---------------------------------------------------------------- scripts
for fn in sorted(os.listdir(os.path.join(SRC, 'scripts'))):
    base = fn[:-4]
    d = os.path.join(OUT, 'scripts', base)
    os.makedirs(d, exist_ok=True)
    shutil.copy(os.path.join(SRC, 'scripts', fn), os.path.join(d, base + '.gml'))
    write_json(os.path.join(d, base + '.yy'), {
        "$GMScript": "v1", "%Name": base, "isCompatibility": False,
        "isDnD": False, "name": base, "parent": parent_ref("scripts"),
        "resourceType": "GMScript", "resourceVersion": "2.0",
    })
    RESOURCES.append({"id": {"name": base, "path": f"scripts/{base}/{base}.yy"}})

# ---------------------------------------------------------------- objects
EVENT_MAP = {
    'Create_0':  (0, 0,  'Create.gml'),
    'Step_0':    (3, 0,  'Step.gml'),
    'Step_1':    (3, 1,  'Begin_Step.gml'),
    'Step_2':    (3, 2,  'End_Step.gml'),
    'Other_2':   (7, 2,  'Room_Start.gml'),
    'Draw_64':   (8, 64, 'Draw_GUI.gml'),
    'CleanUp_0': (12, 0, 'Clean_Up.gml'),
}
FILE_TO_EVENT = {v[2]: k for k, v in EVENT_MAP.items()}

OBJ_META = {
    'obj_player':             ('spr_kael_ow16_idle_down', None, False, True),
    'obj_solid':              ('spr_solid_placeholder', None, False, True),
    'obj_interactable':       ('spr_interactable_placeholder', 'obj_solid', False, True),
    'obj_encounter_trigger':  ('spr_encounter_trigger_placeholder', None, False, True),
    'obj_encounter_zone':     ('spr_encounter_zone_placeholder', None, False, True),
    'obj_story_encounter':    ('spr_story_encounter_placeholder', None, False, True),
    'obj_story_npc':          ('spr_story_npc_placeholder', None, False, True),
    'obj_story_trigger':      ('spr_story_trigger_placeholder', None, False, True),
    'obj_trap_plate':         ('spr_trap_plate_placeholder', None, False, True),
    'obj_zone_entrance':      ('spr_encounter_trigger_placeholder', None, False, True),
    'obj_save_point':         ('spr_save_point_idle_strip8', 'obj_interactable', False, True),
    'obj_respawn_point':      ('spr_respawn_point_placeholder', None, False, True),
    'obj_game_controller':    (None, None, True, False),
    'obj_title':              (None, None, False, True),
    'obj_battle_controller':  (None, None, False, True),
    'obj_dialogue_box':       (None, None, False, True),
    'obj_inventory_menu':     (None, None, False, True),
    'obj_shop_menu':          (None, None, False, True),
    'obj_save_menu':          (None, None, False, True),
    'obj_save_toast':         (None, None, False, True),
    # Chapter 3: heist-night lighting (drawn in the GUI layer, no sprite)
    'obj_night_overlay':      (None, None, False, True),
}

obj_names = []
for name in sorted(os.listdir(os.path.join(SRC, 'objects'))):
    d = os.path.join(SRC, 'objects', name)
    if not os.path.isdir(d): continue
    obj_names.append(name)
    out_d = os.path.join(OUT, 'objects', name)
    os.makedirs(out_d, exist_ok=True)
    gmls = sorted(f for f in os.listdir(d) if f.endswith('.gml'))
    event_list = []
    for g in gmls:
        ev = FILE_TO_EVENT[g]
        etype, num, _ = EVENT_MAP[ev]
        event_list.append({"$GMEvent": "v1", "%Name": "", "collisionObjectId": None,
                          "eventNum": num, "eventType": etype, "isDnD": False,
                          "name": "", "resourceType": "GMEvent",
                          "resourceVersion": "2.0"})
        shutil.copy(os.path.join(d, g), os.path.join(out_d, ev + '.gml'))
    sprite, parent_obj, persistent, visible = OBJ_META[name]
    write_json(os.path.join(out_d, name + '.yy'), {
        "$GMObject": "", "%Name": name, "eventList": event_list,
        "managed": True, "name": name, "overriddenProperties": [],
        "parent": parent_ref("objects"),
        "parentObjectId": ({"name": parent_obj, "path": f"objects/{parent_obj}/{parent_obj}.yy"}
                            if parent_obj else None),
        "persistent": persistent,
        "physicsAngularDamping": 0.1, "physicsDensity": 0.5,
        "physicsFriction": 0.2, "physicsGroup": 1, "physicsKinematic": False,
        "physicsLinearDamping": 0.1, "physicsObject": False,
        "physicsRestitution": 0.1, "physicsSensor": False,
        "physicsShape": 1, "physicsShapePoints": [], "physicsStartAwake": True,
        "properties": [], "resourceType": "GMObject", "resourceVersion": "2.0",
        "solid": False,
        "spriteId": ({"name": sprite, "path": f"sprites/{sprite}/{sprite}.yy"}
                      if sprite else None),
        "spriteMaskId": None, "visible": visible,
    })
    RESOURCES.append({"id": {"name": name, "path": f"objects/{name}/{name}.yy"}})

# ---------------------------------------------------------------- sprites
SPR = os.path.join(SRC, 'sprites')

def parse_origin(s, fw, fh):
    s = s.strip()
    m = re.search(r'\((\d+)\s*,\s*(\d+)\)', s)
    if m:
        x, y = int(m.group(1)), int(m.group(2))
        if x == 0 and y == 0: return 0, 0, 0
        if x == fw // 2 and y == fh - 1: return 7, x, y
        if x == fw // 2 and y == fh // 2: return 4, x, y
        return 9, x, y
    return 0, 0, 0   # "Top Left" etc.

def parse_mask(s, fw, fh):
    s = s.strip().lower()
    if 'full' in s or s == '':
        return 1, (0, 0, fw - 1, fh - 1)
    nums = [int(x) for x in re.findall(r'-?\d+', s)]
    if len(nums) >= 4:
        l, t, r, b = nums[:4]
        l, t = max(0, l), max(0, t)
        r, b = min(fw - 1, r), min(fh - 1, b)
        return 2, (l, t, r, b)
    return 1, (0, 0, fw - 1, fh - 1)

def parse_size(s):
    m = re.search(r'(\d+)\s*[x×]\s*(\d+)', s)
    return (int(m.group(1)), int(m.group(2))) if m else None

def parse_fps(s):
    m = re.match(r'\s*([0-9.]+)', s)
    return float(m.group(1)) if m else 0.0

specs = {}       # name -> dict
conflicts = 0
md = open(os.path.join(SPR, 'IMPORT.md')).read()
for m in re.finditer(r'^\| `([^`]+)` \| `([^`]+)` \| (\d+) \| ([0-9x×]+) \| (.*?) \| (.*?) \|', md, re.M):
    name, file, n, size, origin, mask = m.groups()
    n = int(n)
    fs = parse_size(size)
    if fs is None:  # "(see image)" etc.
        p = os.path.join(SPR, file)
        if os.path.exists(p):
            w, h = Image.open(p).size
            fs = (w, h)
            n = 1 if '_strip' not in name else n
        else:
            continue
    fw, fh = fs
    oenum, ox, oy = parse_origin(origin, fw, fh)
    menum, bbox = parse_mask(mask, fw, fh)
    fps = parse_fps(mask)  # fps column may be merged in mask col in some tables
    sp = dict(name=name, src=os.path.join(SPR, file), fw=fw, fh=fh, n=n,
              oenum=oenum, xo=ox, yo=oy, menum=menum, bbox=bbox, fps=fps,
              texture=None, nineslice=None)
    if name in specs:
        # keep the row with concrete mask coords over "full image" duplicates
        old = specs[name]
        if old['menum'] == 1 and menum == 2:
            specs[name] = sp
        elif old['menum'] == menum:
            pass
        conflicts += 1
    else:
        specs[name] = sp

# FPS lives in the 7th column when present; re-parse rows with 7 columns
for m in re.finditer(r'^\| `([^`]+)` \| `([^`]+)` \| (\d+) \| ([0-9x×]+) \| (.*?) \| (.*?) \| ([0-9.;a-z ]*?) \|', md, re.M):
    name, file, n, size, origin, mask, fps = m.groups()
    if name in specs:
        specs[name]['fps'] = parse_fps(fps)

# disabled item icons
dis_dir = os.path.join(SPR, 'ui/menus/items_disabled')
for fn in sorted(os.listdir(dis_dir)):
    if not fn.endswith('.png'): continue
    name = fn[:-4]
    specs[name] = dict(name=name, src=os.path.join(dis_dir, fn), fw=16, fh=16, n=1,
                       oenum=9, xo=8, yo=8, menum=1, bbox=(0, 0, 15, 15),
                       fps=0.0, texture=None, nineslice=None)

# placeholders (flat colour, generated)
PLACEHOLDERS = {
    'spr_player_placeholder':        (16, 24, 9, 8, 23, 2, (0, 8, 15, 23), (70, 70, 80, 255)),
    'spr_solid_placeholder':         (16, 16, 0, 0, 0, 1, None, (48, 48, 54, 255)),
    'spr_interactable_placeholder': (16, 16, 0, 0, 0, 1, None, (124, 82, 44, 255)),
    'spr_encounter_trigger_placeholder': (16, 16, 0, 0, 0, 1, None, (205, 45, 45, 110)),
    'spr_encounter_zone_placeholder': (16, 16, 0, 0, 0, 1, None, (222, 192, 44, 90)),
    'spr_respawn_point_placeholder': (16, 16, 0, 0, 0, 1, None, (44, 165, 165, 190)),
    'spr_story_encounter_placeholder': (16, 16, 0, 0, 0, 1, None, (152, 62, 192, 110)),
    'spr_story_npc_placeholder':     (16, 16, 0, 0, 0, 1, None, (62, 152, 120, 110)),
    'spr_story_trigger_placeholder': (16, 16, 0, 0, 0, 1, None, (200, 120, 40, 110)),
    'spr_trap_plate_placeholder':    (16, 16, 0, 0, 0, 1, None, (90, 90, 160, 110)),
}
for name, (w, h, oenum, xo, yo, bmode, bbox, rgba) in PLACEHOLDERS.items():
    specs[name] = dict(name=name, src=None, fw=w, fh=h, n=1, oenum=oenum, xo=xo, yo=yo,
                       menum=bmode, bbox=bbox, fps=0.0, texture=None,
                       nineslice=None, gen_rgba=rgba)

# tileset source sprite
specs['spr_ts_zone1'] = dict(name='spr_ts_zone1',
                            src=os.path.join(SRC, 'tilesets', 'ts_zone1.png'),
                            fw=256, fh=800, n=1, oenum=0, xo=0, yo=0, menum=1,
                            bbox=(0, 0, 255, 799), fps=0.0, texture=None, nineslice=None)

# wrenfield tileset source sprite (Chapter 2/3 rooms; rows 0-49 == ts_zone1)
specs['spr_ts_wrenfield'] = dict(name='spr_ts_wrenfield',
                            src=os.path.join(SRC, 'tilesets', 'ts_wrenfield.png'),
                            fw=256, fh=1040, n=1, oenum=0, xo=0, yo=0, menum=1,
                            bbox=(0, 0, 255, 1039), fps=0.0, texture=None, nineslice=None)

# 640 title set gets its own texture group (tex_title_640) per IMPORT.md
for name, sp in specs.items():
    if sp['src'] and ('title/640' + os.sep in sp['src'] or '/title/640/' in sp['src'].replace(os.sep, '/')):
        sp['texture'] = 'tex_title_640'

# nine-slice (from IMPORT.md "Nine-slice" tables and notes)
NINESLICE = {
    'spr_ui_window': (8, 8, 8, 8), 'spr_ui_window_dim': (8, 8, 8, 8),
    'spr_ui_window_gold': (8, 8, 8, 8),
    'spr_ui_select_bar': (3, 3, 3, 3), 'spr_ui_slider_track': (2, 2, 2, 2),
    'spr_ui_row_select': (4, 4, 4, 4), 'spr_ui_row_select_disabled': (4, 4, 4, 4),
    'spr_ui_tab_blank_strip2': (4, 4, 4, 3),
    'spr_ui_portrait_frame': (3, 3, 3, 3), 'spr_ui_leader_frame': (3, 3, 3, 3),
    'spr_ui_qty_field': (3, 3, 3, 3),
}

def emit_sprite(sp):
    name = sp['name']
    d = os.path.join(OUT, 'sprites', name)
    os.makedirs(d, exist_ok=True)
    layer_uuid = rid()
    frames, keyframes = [], []
    for i in range(sp['n']):
        fuuid = rid()
        if sp['src']:
            strip = Image.open(sp['src']).convert('RGBA')
            assert strip.width == sp['fw'] * sp['n'], \
                f"{name}: strip width {strip.width} != {sp['fw']}*{sp['n']}"
            assert strip.height == sp['fh'], f"{name}: strip height {strip.height} != {sp['fh']}"
            img = strip.crop((i * sp['fw'], 0, (i + 1) * sp['fw'], sp['fh']))
        else:
            img = Image.new('RGBA', (sp['fw'], sp['fh']), sp.get('gen_rgba', (255, 0, 255, 255)))
        img.save(os.path.join(d, fuuid + '.png'))
        ldir = os.path.join(d, 'layers', fuuid)
        os.makedirs(ldir, exist_ok=True)
        img.save(os.path.join(ldir, layer_uuid + '.png'))
        frames.append({"$GMSpriteFrame": "", "%Name": fuuid, "name": fuuid,
                       "resourceType": "GMSpriteFrame", "resourceVersion": "2.0"})
        keyframes.append({
            "$Keyframe<SpriteFrameKeyframe>": "",
            "Channels": {"0": {"$SpriteFrameKeyframe": "",
                               "Id": {"name": fuuid, "path": f"sprites/{name}/{name}.yy"},
                               "resourceType": "SpriteFrameKeyframe",
                               "resourceVersion": "2.0"}},
            "Disabled": False, "id": rid(), "IsCreationKey": False,
            "Key": float(i), "Length": 1.0,
            "resourceType": "Keyframe<SpriteFrameKeyframe>",
            "resourceVersion": "2.0", "Stretch": False,
        })
    if sp['bbox']:
        bl, bt, br, bb = sp['bbox']
    else:
        bl, bt, br, bb = 0, 0, sp['fw'] - 1, sp['fh'] - 1
    ns = None
    if name in NINESLICE:
        l, t, r, b = NINESLICE[name]
        ns = {"$GMNineSliceData": "", "bottom": b, "enabled": True,
              "guideColour": [4294902015, 4294902015, 4294902015, 4294902015],
              "highlightColour": 1728023040, "highlightStyle": 0, "left": l,
              "resourceType": "GMNineSliceData", "resourceVersion": "2.0",
              "right": r, "tileMode": [0, 0, 0, 0, 0], "top": t}
    write_json(os.path.join(d, name + '.yy'), {
        "$GMSprite": "", "%Name": name, "bboxMode": sp['menum'],
        "bbox_bottom": bb, "bbox_left": bl, "bbox_right": br, "bbox_top": bt,
        "collisionKind": 1, "collisionTolerance": 0, "DynamicTexturePage": False,
        "edgeFiltering": False, "For3D": False, "frames": frames,
        "gridX": 0, "gridY": 0, "height": sp['fh'], "HTile": False,
        "layers": [{"$GMImageLayer": "", "%Name": layer_uuid, "blendMode": 0,
                    "displayName": "default", "isLocked": False, "name": layer_uuid,
                    "opacity": 100.0, "resourceType": "GMImageLayer",
                    "resourceVersion": "2.0", "visible": True}],
        "name": name, "nineSlice": ns, "origin": sp['oenum'],
        "parent": parent_ref("sprites"), "preMultiplyAlpha": False,
        "resourceType": "GMSprite", "resourceVersion": "2.0",
        "sequence": {
            "$GMSequence": "", "%Name": name, "autoRecord": True,
            "backdropHeight": 1080, "backdropImageOpacity": 0.5,
            "backdropImagePath": "", "backdropWidth": 1920,
            "backdropXOffset": 0.0, "backdropYOffset": 0.0,
            "eventStubScript": None, "eventToFunction": {},
            "events": {"$KeyframeStore<MessageEventKeyframe>": "", "Keyframes": [],
                       "resourceType": "KeyframeStore<MessageEventKeyframe>",
                       "resourceVersion": "2.0"},
            "length": float(sp['n']), "lockOrigin": False,
            "moments": {"$KeyframeStore<MomentsEventKeyframe>": "", "Keyframes": [],
                        "resourceType": "KeyframeStore<MomentsEventKeyframe>",
                        "resourceVersion": "2.0"},
            "name": name, "playback": 1, "playbackSpeed": sp['fps'],
            "playbackSpeedType": 0, "resourceType": "GMSequence",
            "resourceVersion": "2.0", "showBackdrop": True,
            "showBackdropImage": False, "timeUnits": 1, "visibleRange": None,
            "volume": 1.0, "xorigin": sp['xo'], "yorigin": sp['yo'],
            "tracks": [{
                "$GMSpriteFramesTrack": "", "builtinName": 0, "events": [],
                "inheritsTrackColour": True, "interpolation": 1,
                "isCreationTrack": False,
                "keyframes": {"$KeyframeStore<SpriteFrameKeyframe>": "",
                              "Keyframes": keyframes,
                              "resourceType": "KeyframeStore<SpriteFrameKeyframe>",
                              "resourceVersion": "2.0"},
                "modifiers": [], "name": "frames",
                "resourceType": "GMSpriteFramesTrack", "resourceVersion": "2.0",
                "spriteId": None, "trackColour": 0, "tracks": [], "traits": 0,
            }],
        },
        "swatchColours": None, "swfPrecision": 2.525,
        "textureGroupId": {"name": sp['texture'] or "Default",
                           "path": f"texturegroups/{sp['texture'] or 'Default'}"},
        "type": 0, "VTile": False, "width": sp['fw'],
    })
    RESOURCES.append({"id": {"name": name, "path": f"sprites/{name}/{name}.yy"}})

for sp in sorted(specs.values(), key=lambda s: s['name']):
    emit_sprite(sp)

# ---------------------------------------------------------------- tileset
ts_dir = os.path.join(OUT, 'tilesets', 'ts_zone1')
os.makedirs(ts_dir, exist_ok=True)
write_json(os.path.join(ts_dir, 'ts_zone1.yy'), {
    "$GMTileSet": "v1", "%Name": "ts_zone1", "autoTileSets": [],
    "macroPageTiles": {"SerialiseHeight": 0, "SerialiseWidth": 0,
                       "TileSerialiseData": []},
    "name": "ts_zone1", "out_columns": 16, "out_tilehborder": 2,
    "out_tilevborder": 2, "parent": parent_ref("tilesets"),
    "resourceType": "GMTileSet", "resourceVersion": "2.0",
    "spriteId": {"name": "spr_ts_zone1", "path": "sprites/spr_ts_zone1/spr_ts_zone1.yy"},
    "spriteNoExport": True,
    "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
    "tileAnimationFrames": [], "tileAnimationSpeed": 15.0,
    "tileHeight": 16, "tilehsep": 0, "tilevsep": 0, "tileWidth": 16,
    "tilexoff": 0, "tileyoff": 0, "tile_count": 800,
})
RESOURCES.append({"id": {"name": "ts_zone1", "path": "tilesets/ts_zone1/ts_zone1.yy"}})

# ---------------------------------------------------------------- wrenfield tileset
# ts_wrenfield: rows 0-49 are ts_zone1 unchanged; the new rows are the Chapter 2/3
# exterior and interior tiles (16x16, no offset/spacing). 256x1040 = 1040 tiles.
ts_dir = os.path.join(OUT, 'tilesets', 'ts_wrenfield')
os.makedirs(ts_dir, exist_ok=True)
write_json(os.path.join(ts_dir, 'ts_wrenfield.yy'), {
    "$GMTileSet": "v1", "%Name": "ts_wrenfield", "autoTileSets": [],
    "macroPageTiles": {"SerialiseHeight": 0, "SerialiseWidth": 0,
                       "TileSerialiseData": []},
    "name": "ts_wrenfield", "out_columns": 16, "out_tilehborder": 2,
    "out_tilevborder": 2, "parent": parent_ref("tilesets"),
    "resourceType": "GMTileSet", "resourceVersion": "2.0",
    "spriteId": {"name": "spr_ts_wrenfield", "path": "sprites/spr_ts_wrenfield/spr_ts_wrenfield.yy"},
    "spriteNoExport": True,
    "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
    "tileAnimationFrames": [], "tileAnimationSpeed": 15.0,
    "tileHeight": 16, "tilehsep": 0, "tilevsep": 0, "tileWidth": 16,
    "tilexoff": 0, "tileyoff": 0, "tile_count": 1040,
})
RESOURCES.append({"id": {"name": "ts_wrenfield", "path": "tilesets/ts_wrenfield/ts_wrenfield.yy"}})

# ---------------------------------------------------------------- rooms
# layer definitions used by scr_map_layer_defs(): name, depth, visible
TILE_LAYERS = [("Ground", 400, True), ("Decoration", 300, True),
               ("Overhead", -10000, True), ("Collision", 500, False),
               ("Markers", 600, False)]

def gmr_tile_layer(name, depth, visible, tileset="ts_zone1"):
    return {
        "$GMRTileLayer": "", "%Name": name, "depth": depth,
        "gridX": 16, "gridY": 16, "hierarchyFrozen": False,
        "inheritLayerDepth": False, "inheritLayerSettings": False,
        "inheritSubLayers": True, "inheritVisibility": True,
        "layers": [], "name": name,
        "properties": [], "resourceType": "GMRTileLayer", "resourceVersion": "2.0",
        "spriteId": None, "tilesetId":
            {"name": tileset, "path": f"tilesets/{tileset}/{tileset}.yy"},
        "userdefinedDepth": False, "visible": visible, "x": 0, "y": 0,
        "tiles": {"SerialiseHeight": 0, "SerialiseWidth": 0, "TileSerialiseData": []},
    }

def gmr_instance_layer(instances):
    entries = []
    order = []
    for obj, x, y in instances:
        iname = inst_name()
        entries.append({
            "$GMRInstance": "v4", "%Name": iname, "colour": 4294967295,
            "frozen": False, "hasCreationCode": False, "ignore": False,
            "imageIndex": 0, "imageSpeed": 1.0, "inheritCode": False,
            "inheritedItemId": None, "inheritItemSettings": False,
            "isDnd": False, "name": iname,
            "objectId": {"name": obj, "path": f"objects/{obj}/{obj}.yy"},
            "properties": [], "resourceType": "GMRInstance",
            "resourceVersion": "2.0", "rotation": 0.0, "scaleX": 1.0,
            "scaleY": 1.0, "x": float(x), "y": float(y),
        })
        order.append({"name": iname, "path": "PLACEHOLDER"})
    return {
        "$GMRInstanceLayer": "", "%Name": "Instances", "depth": 0,
        "effectEnabled": True, "effectType": None, "gridX": 16, "gridY": 16,
        "hierarchyFrozen": False, "inheritLayerDepth": False,
        "inheritLayerSettings": False, "inheritSubLayers": True,
        "inheritVisibility": True, "instances": entries, "layers": [],
        "name": "Instances", "properties": [],
        "resourceType": "GMRInstanceLayer", "resourceVersion": "2.0",
        "userdefinedDepth": False, "visible": True,
    }, order

def view(wview, hview, wport, hport, visible):
    return {"hborder": 32, "hport": hport, "hspeed": -1, "hview": hview,
            "inherit": False, "objectId": None, "vborder": 32, "visible": visible,
            "vspeed": -1, "wport": wport, "wview": wview, "xport": 0,
            "xview": 0, "yport": 0, "yview": 0}

ROOMS = [
    # name, w, h, instances [(obj,x,y)], creation code, view0
    ('rm_title', 320, 180, [('obj_game_controller', 16, 16), ('obj_title', 160, 90)],
     None, (320, 180, 640, 360)),
    ('rm_overworld', 6400, 4800,
     [('obj_game_controller', 32, 32), ('obj_player', 3192, 2992)],
     'scr_build_overworld();', (320, 180, 640, 360)),
    ('rm_old_watchtower', 960, 720, [('obj_player', 472, 688)],
     'scr_build_old_watchtower();', (320, 180, 640, 360)),
    ('rm_watchtower_basement', 704, 512, [('obj_player', 120, 80)],
     'scr_build_watchtower_basement();', (320, 180, 640, 360)),
    ('rm_greyhaven_varyn_house', 320, 240, [('obj_player', 152, 176)],
     'scr_build_greyhaven_varyn_house();', (320, 180, 640, 360)),
    ('rm_greyhaven_tavern', 384, 256, [('obj_player', 184, 208)],
     'scr_build_greyhaven_tavern();', (320, 180, 640, 360)),
    ('rm_greyhaven_chapel', 320, 288, [('obj_player', 152, 256)],
     'scr_build_greyhaven_chapel();', (320, 180, 640, 360)),
    ('rm_greyhaven_blacksmith', 320, 240, [('obj_player', 152, 176)],
     'scr_build_greyhaven_blacksmith();', (320, 180, 640, 360)),
    ('rm_greyhaven_general_store', 320, 240, [('obj_player', 152, 176)],
     'scr_build_greyhaven_general_store();', (320, 180, 640, 360)),
    ('rm_battle_test', 640, 360, [('obj_battle_controller', 32, 32)],
     None, (640, 360, 640, 360)),
    # ---- Chapter 2 (feature/chapter2): Millhaven Road, Wrenfield and its interiors ----
    ('rm_millhaven_road', 512, 960, [('obj_player', 264, 32)],
     'scr_build_millhaven_road();', (320, 180, 640, 360)),
    ('rm_wrenfield', 896, 704, [('obj_player', 200, 32)],
     'scr_build_wrenfield();', (320, 180, 640, 360)),
    ('rm_wrenfield_bent_post', 384, 256, [('obj_player', 184, 208)],
     'scr_build_wrenfield_bent_post();', (320, 180, 640, 360)),
    ('rm_wrenfield_store', 320, 224, [('obj_player', 152, 160)],
     'scr_build_wrenfield_store();', (320, 180, 640, 360)),
    # ---- Chapter 3 (feature/chapter3): Valemere Road, Valemere, Salt Lamp, warehouse ----
    ('rm_valemere_road', 384, 704, [('obj_player', 352, 592)],
     'scr_build_valemere_road();', (320, 180, 640, 360)),
    ('rm_valemere', 640, 480, [('obj_player', 40, 240)],
     'scr_build_valemere();', (320, 180, 640, 360)),
    ('rm_salt_lamp', 320, 224, [('obj_player', 152, 208)],
     'scr_build_salt_lamp();', (320, 180, 640, 360)),
    ('rm_warehouse', 416, 288, [('obj_player', 200, 224)],
     'scr_build_warehouse();', (320, 180, 640, 360)),
]

room_order = []
for name, w, h, instances, creation_code, view0 in ROOMS:
    d = os.path.join(OUT, 'rooms', name)
    os.makedirs(d, exist_ok=True)
    inst_layer, order = gmr_instance_layer(instances)
    # player instance must be created before game controller reads it? Keep editor
    # order as given (controller first is fine; code uses Room Start / Begin Step).
    views = [view(*view0, True)] + [view(640, 360, 640, 360, False) for _ in range(7)]
    if creation_code:
        with open(os.path.join(d, 'RoomCreationCode.gml'), 'w', newline='\n') as f:
            f.write(creation_code + "\n")
        ccf = f"${{project_dir}}/rooms/{name}/RoomCreationCode.gml"
    else:
        ccf = ""
    layers = [inst_layer]
    layers += [gmr_tile_layer(nm, dep, vis) for nm, dep, vis in TILE_LAYERS]
    layers.append({"$GMRBackgroundLayer": "", "%Name": "Background",
                   "animationFPS": 15.0, "animationSpeedType": 0,
                   "colour": 4278190080, "depth": 100, "effectEnabled": True,
                   "effectType": None, "gridX": 16, "gridY": 16,
                   "hierarchyFrozen": False, "hspeed": 0.0, "htiled": False,
                   "inheritLayerDepth": False, "inheritLayerSettings": False,
                   "inheritSubLayers": True, "inheritVisibility": True,
                   "layers": [], "name": "Background", "properties": [],
                   "resourceType": "GMRBackgroundLayer", "resourceVersion": "2.0",
                   "spriteId": None, "stretch": False, "userdefinedAnimFPS": False,
                   "userdefinedDepth": False, "visible": True, "vspeed": 0.0,
                   "vtiled": False, "x": 0, "y": 0})
    write_json(os.path.join(d, name + '.yy'), {
        "$GMRoom": "v1", "%Name": name, "creationCodeFile": ccf,
        "inheritCode": False, "inheritCreationOrder": False,
        "inheritLayers": False, "instanceCreationOrder": order, "isDnd": False,
        "layers": layers,
        "name": name, "parent": parent_ref("rooms"), "parentRoom": None,
        "physicsSettings": {"inheritPhysicsSettings": False,
                            "PhysicsWorld": False, "PhysicsWorldGravityX": 0.0,
                            "PhysicsWorldGravityY": 10.0,
                            "PhysicsWorldPixToMetres": 0.1},
        "resourceType": "GMRoom", "resourceVersion": "2.0",
        "roomSettings": {"Height": h, "inheritRoomSettings": False,
                         "persistent": False, "Width": w},
        "sequenceId": None, "views": views,
        "viewSettings": {"clearDisplayBuffer": True, "clearViewBackground": False,
                         "enableViews": True, "inheritViewSettings": False},
        "volume": 1.0,
    })
    RESOURCES.append({"id": {"name": name, "path": f"rooms/{name}/{name}.yy"}})
    room_order.append({"roomId": {"name": name, "path": f"rooms/{name}/{name}.yy"}})

# fix instanceCreationOrder paths
for name, *_ in ROOMS:
    p = os.path.join(OUT, 'rooms', name, name + '.yy')
    s = open(p).read()
    s = s.replace('"path": "PLACEHOLDER"', f'"path": "rooms/{name}/{name}.yy"')
    open(p, 'w').write(s)

# ---------------------------------------------------------------- options
if REF and os.path.exists(os.path.join(REF, 'options')):
    shutil.copytree(os.path.join(REF, 'options'), os.path.join(OUT, 'options'))
elif _options_backup:
    for rel, data in _options_backup.items():
        p = os.path.join(OUT, 'options', rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'wb').write(data)
else:
    raise SystemExit("no options source: set REF or run once with the template")
# uncheck "Interpolate colours between pixels" on every platform + main
for root, dirs, files in os.walk(os.path.join(OUT, 'options')):
    for fn in files:
        if not fn.endswith('.yy'): continue
        p = os.path.join(root, fn)
        s = open(p).read()
        s2 = re.sub(r'"([a-z]+_interpolate_pixels|nwindows_interpolate_pixels)":\s*true',
                    r'"\1":false', s)
        s2 = s2.replace('"nwindows_display_name":"yyp-template"',
                        '"nwindows_display_name":"Ashen Crown"')
        s2 = s2.replace('"nwindows_product_info":"yyp-template"',
                        '"nwindows_product_info":"Ashen Crown"')
        s2 = s2.replace('"nwindows_company_info":"DecadeDecaf"',
                        '"nwindows_company_info":"Eastern Goat Forge"')
        if s2 != s: open(p, 'w').write(s2)

# ---------------------------------------------------------------- datafiles
included = []
src_df = os.path.join(SRC, 'datafiles')
for root, dirs, files in os.walk(src_df):
    for fn in sorted(files):
        src = os.path.join(root, fn)
        rel = os.path.relpath(src, src_df).replace(os.sep, '/')
        dst = os.path.join(OUT, 'datafiles', rel)
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy(src, dst)
        included.append({
            "$GMIncludedFile": "", "%Name": rel, "CopyToMask": -1,
            "filePath": "datafiles", "name": rel,
            "resourceType": "GMIncludedFile", "resourceVersion": "2.0",
        })

# ---------------------------------------------------------------- .yyp
write_json(os.path.join(OUT, 'AshenCrown.yyp'), {
    "$GMProject": "", "%Name": "AshenCrown",
    "AudioGroups": [{"$GMAudioGroup": "v1", "%Name": "audiogroup_default",
                     "exportDir": "", "name": "audiogroup_default",
                     "resourceType": "GMAudioGroup", "resourceVersion": "2.0",
                     "targets": -1}],
    "configs": {"children": [], "name": "Default"},
    "defaultScriptType": 1,
    "Folders": [{"$GMFolder": "", "%Name": f, "folderPath": f"folders/{f}.yy",
                 "name": f, "resourceType": "GMFolder",
                 "resourceVersion": "2.0"} for f in FOLDERS],
    "ForcedPrefabProjectReferences": [],
    "IncludedFiles": included,
    "isEcma": False, "LibraryEmitters": [],
    "MetaData": {"IDEVersion": "2024.14.4.222"},
    "name": "AshenCrown", "resources": RESOURCES,
    "resourceType": "GMProject", "resourceVersion": "2.0",
    "RoomOrderNodes": room_order, "templateType": "game",
    "TextureGroups": [{"$GMTextureGroup": "", "%Name": "tex_title_640",
                        "autocrop": True, "border": 2, "compressFormat": "bz2",
                        "customOptions": "", "directory": "", "groupParent": None,
                        "isScaled": True, "loadType": "default",
                        "mipsToGenerate": 0, "name": "tex_title_640",
                        "resourceType": "GMTextureGroup", "resourceVersion": "2.0",
                        "targets": -1},
                       {"$GMTextureGroup": "", "%Name": "Default",
                       "autocrop": True, "border": 2, "compressFormat": "bz2",
                       "customOptions": "", "directory": "", "groupParent": None,
                       "isScaled": True, "loadType": "default",
                       "mipsToGenerate": 0, "name": "Default",
                       "resourceType": "GMTextureGroup", "resourceVersion": "2.0",
                       "targets": -1}],
})

order = {
    "FolderOrderSettings": [{"name": f, "order": i, "path": f"folders/{f}.yy"}
                            for i, f in enumerate(FOLDERS)],
    "ResourceOrderSettings": [{"name": r["id"]["name"], "order": i,
                              "path": r["id"]["path"]}
                             for i, r in enumerate(RESOURCES)],
}
write_json(os.path.join(OUT, 'AshenCrown.resource_order'), order)

print(f"Generated {OUT}")
print(f"  scripts: {len(os.listdir(os.path.join(SRC,'scripts')))}  objects: {len(obj_names)}  "
      f"sprites: {len(specs)}  rooms: {len(ROOMS)}")
print(f"  table conflicts resolved: {conflicts}")
print(f"  640 title sprites in tex_title_640: "
      f"{sum(1 for sp in specs.values() if sp['texture'] == 'tex_title_640')}")
print(f"  included files: {len(included)}")
