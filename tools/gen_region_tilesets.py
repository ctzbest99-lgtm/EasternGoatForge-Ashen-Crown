#!/usr/bin/env python3
"""Build the town/keep atlases that replace the Chapter 3, 5 and 9 blockouts.

The chapter builders address tiles by fixed ids, so each atlas keeps the Wrenfield
id contract and repaints the ids those builders actually use. That means a room
only changes its prepare function; layouts, markers and collision stay put.

    ts_valemere   rm_valemere_road, rm_valemere, rm_salt_lamp, rm_warehouse
    ts_coleford   rm_town
    ts_garrison   rm_garrison_keep

Painted ids (same in every region, different material):
    2-6 turf        26/28/29/31/80/13 roads      53/58/63/87 stone or dirt
    79 tree         107 lamp                     527 pillar / well / banner
    608/609/611/623 interior floors              640-643 wall face
    659/665/666 caps   661 wall side   670 wall top
    704-707 counter     809-811 facades         1024 crate   1034-1035 barrel

    python3 tools/gen_region_tilesets.py
"""
import json
import os
import random
import re
import uuid

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'game', 'tilesets')
GM = os.path.join(ROOT, 'gamemaker')
COLS, TILE, ROWS = 16, 16, 65
WIDTH, HEIGHT = COLS * TILE, ROWS * TILE

TURF = [2, 3, 4, 5, 6]
ROAD = [26, 28, 29, 31, 80, 13]
STONE = [53, 58, 63, 87]
FLOORS = [608, 609, 611, 623]
WALLS = [640, 641, 642, 643]
CAPS = [659, 665, 666]
BAR = [704, 705, 706, 707]
FACADE = [809, 810, 811]
TOUCHED = TURF + ROAD + STONE + [79, 107, 527] + FLOORS + WALLS + [661] + CAPS + [670] + BAR + FACADE + [1024, 1034, 1035]

REGIONS = {
    'valemere': {
        'turf': (76, 98, 62), 'turf_dry': (108, 112, 74),
        'road': (100, 104, 108), 'mortar': (60, 64, 70), 'pattern': 'cobble',
        'stone': (112, 116, 120), 'stone_dark': (74, 78, 84),
        'plaster': (214, 206, 186), 'timber': (76, 54, 38),
        'roof': (56, 70, 88), 'roof_light': (78, 94, 114),
        'floor': (132, 98, 62), 'floor_dark': (104, 76, 48),
        'counter': (120, 84, 52), 'metal': (176, 142, 84),
        'accent': (64, 104, 138), 'leaf': (58, 88, 52), 'leaf_light': (92, 126, 70),
    },
    'coleford': {
        'turf': (92, 106, 60), 'turf_dry': (126, 118, 66),
        'road': (108, 92, 66), 'mortar': (78, 64, 48), 'pattern': 'mud',
        'stone': (124, 118, 104), 'stone_dark': (88, 84, 74),
        'plaster': (208, 196, 168), 'timber': (86, 62, 42),
        'roof': (150, 124, 76), 'roof_light': (176, 150, 96),
        'floor': (124, 94, 60), 'floor_dark': (96, 70, 44),
        'counter': (112, 80, 48), 'metal': (150, 138, 112),
        'accent': (140, 96, 56), 'leaf': (66, 92, 48), 'leaf_light': (104, 128, 64),
    },
    'garrison': {
        'turf': (82, 94, 64), 'turf_dry': (104, 104, 70),
        'road': (94, 96, 100), 'mortar': (62, 64, 68), 'pattern': 'paving',
        'stone': (92, 94, 98), 'stone_dark': (64, 66, 70),
        'plaster': (104, 104, 108), 'timber': (60, 50, 40),
        'roof': (58, 60, 66), 'roof_light': (76, 78, 84),
        'floor': (106, 90, 68), 'floor_dark': (82, 68, 50),
        'counter': (96, 78, 54), 'metal': (140, 142, 146),
        'accent': (128, 54, 46), 'leaf': (60, 76, 52), 'leaf_light': (84, 100, 66),
    },
}


def box(index):
    return (index % COLS) * TILE, (index // COLS) * TILE


def grain(draw, index, base, rng, amount=6, speckle=0.16):
    ox, oy = box(index)
    draw.rectangle([ox, oy, ox + 15, oy + 15], fill=base + (255,))
    for y in range(16):
        for x in range(16):
            if rng.random() < speckle:
                j = rng.randint(-amount, amount)
                draw.point((ox + x, oy + y), fill=tuple(max(0, min(255, c + j)) for c in base) + (255,))


def turf(draw, index, col, pal):
    rng = random.Random(1200 + index)
    base = tuple(pal['turf'][i] + (col % 3) for i in range(3))
    grain(draw, index, base, rng, speckle=0.22)
    ox, oy = box(index)
    for _ in range(5):  # clumps give the field some body at 16px
        x, y = rng.randrange(0, 14), rng.randrange(0, 14)
        draw.rectangle([ox + x, oy + y, ox + x + rng.randint(1, 3), oy + y + 1], fill=pal['leaf'] + (255,))
    for _ in range(8):
        x, y = rng.randrange(1, 15), rng.randrange(3, 16)
        c = pal['turf_dry'] if rng.random() < 0.4 else pal['leaf_light']
        draw.line([ox + x, oy + y, ox + x + rng.randint(-1, 1), oy + y - rng.randint(1, 3)], fill=c + (255,))
    if col == 5:
        draw.point((ox + rng.randrange(2, 14), oy + rng.randrange(2, 14)), fill=(240, 226, 170, 255))


def road(draw, index, col, pal):
    rng = random.Random(1400 + index)
    ox, oy = box(index)
    if pal['pattern'] == 'mud':
        grain(draw, index, pal['road'], rng, amount=10, speckle=0.30)
        for k in range(2):  # wheel rut
            y = 4 + k * 7 + rng.randint(-1, 1)
            draw.line([ox, oy + y, ox + 15, oy + y + rng.randint(-1, 1)], fill=(pal['road'][0] - 22, pal['road'][1] - 18, pal['road'][2] - 12, 255))
        return
    if pal['pattern'] == 'paving':
        grain(draw, index, pal['road'], rng, amount=5, speckle=0.10)
        draw.line([ox, oy + 5, ox + 15, oy + 5], fill=pal['mortar'] + (255,))
        draw.line([ox, oy + 11, ox + 15, oy + 11], fill=pal['mortar'] + (255,))
        x = 4 if col % 2 else 11
        draw.line([ox + x, oy, ox + x, oy + 5], fill=pal['mortar'] + (255,))
        draw.line([ox + (15 - x), oy + 5, ox + (15 - x), oy + 11], fill=pal['mortar'] + (255,))
        return
    # cobbles: offset arcs of rounded stones
    draw.rectangle([ox, oy, ox + 15, oy + 15], fill=pal['mortar'] + (255,))
    for row in range(4):
        y = row * 4
        shift = 0 if row % 2 == 0 else 4
        for cx in range(-1, 5):
            x = cx * 8 + shift
            c = tuple(pal['road'][i] + rng.randint(-10, 8) for i in range(3)) + (255,)
            draw.ellipse([ox + x + 1, oy + y + 1, ox + x + 7, oy + y + 3], fill=c)


def stonework(draw, index, col, pal):
    rng = random.Random(1600 + index)
    base = tuple(pal['stone'][i] + (col % 3) for i in range(3))
    grain(draw, index, base, rng, amount=7, speckle=0.18)
    ox, oy = box(index)
    draw.line([ox, oy + 7, ox + 15, oy + 7], fill=pal['stone_dark'] + (255,))
    joint = 5 if col % 2 else 10
    draw.line([ox + joint, oy, ox + joint, oy + 7], fill=pal['stone_dark'] + (255,))
    draw.line([ox + (15 - joint), oy + 8, ox + (15 - joint), oy + 15], fill=pal['stone_dark'] + (255,))


def tree(draw, index, pal):
    ox, oy = box(index)
    draw.rectangle([ox + 7, oy + 9, ox + 8, oy + 15], fill=(pal['timber'][0], pal['timber'][1], pal['timber'][2], 255))
    rng = random.Random(1800 + index)
    for dy, r in ((4, 6), (7, 7), (10, 5)):
        draw.ellipse([ox + 8 - r, oy + dy - r // 2, ox + 8 + r, oy + dy + r // 2], fill=pal['leaf'] + (255,))
    for _ in range(9):
        x, y = rng.randrange(1, 15), rng.randrange(1, 12)
        draw.point((ox + x, oy + y), fill=pal['leaf_light'] + (255,))


def lamp(draw, index, pal):
    ox, oy = box(index)
    draw.rectangle([ox + 7, oy + 6, ox + 8, oy + 15], fill=(pal['timber'][0], pal['timber'][1], pal['timber'][2], 255))
    draw.rectangle([ox + 5, oy + 2, ox + 10, oy + 7], fill=pal['metal'] + (255,))
    draw.rectangle([ox + 6, oy + 3, ox + 9, oy + 6], fill=(250, 216, 132, 255))
    draw.point((ox + 7, oy + 4), fill=(255, 246, 200, 255))


def pillar(draw, index, pal):
    ox, oy = box(index)
    draw.rectangle([ox + 3, oy + 6, ox + 12, oy + 15], fill=pal['stone'] + (255,))
    draw.ellipse([ox + 3, oy + 4, ox + 12, oy + 8], fill=pal['stone_dark'] + (255,))
    draw.ellipse([ox + 5, oy + 5, ox + 10, oy + 7], fill=pal['metal'] + (255,))


def crate(draw, index, pal):
    ox, oy = box(index)
    draw.rectangle([ox + 2, oy + 4, ox + 13, oy + 15], fill=pal['counter'] + (255,))
    draw.rectangle([ox + 2, oy + 4, ox + 13, oy + 5], fill=pal['timber'] + (255,))
    draw.line([ox + 2, oy + 4, ox + 13, oy + 15], fill=pal['timber'] + (255,))
    draw.line([ox + 13, oy + 4, ox + 2, oy + 15], fill=pal['timber'] + (255,))


def barrel(draw, index, pal):
    ox, oy = box(index)
    draw.ellipse([ox + 2, oy + 3, ox + 13, oy + 15], fill=pal['counter'] + (255,))
    draw.rectangle([ox + 2, oy + 4, ox + 13, oy + 14], fill=pal['counter'] + (255,))
    draw.ellipse([ox + 2, oy + 2, ox + 13, oy + 6], fill=pal['timber'] + (255,))
    draw.line([ox + 2, oy + 8, ox + 13, oy + 8], fill=pal['metal'] + (255,))
    draw.line([ox + 2, oy + 12, ox + 13, oy + 12], fill=pal['metal'] + (255,))


def boards(draw, index, col, pal):
    rng = random.Random(2000 + index)
    base = tuple(pal['floor'][i] + (col % 4) for i in range(3))
    grain(draw, index, base, rng, amount=5, speckle=0.10)
    ox, oy = box(index)
    for y in (4, 9, 14):
        draw.line([ox, oy + y, ox + 15, oy + y], fill=pal['floor_dark'] + (255,))
    draw.line([ox + (col * 3) % 14 + 1, oy, ox + (col * 3) % 14 + 1, oy + 4], fill=pal['floor_dark'] + (255,))


def plaster_wall(draw, index, col, pal):
    rng = random.Random(2200 + index)
    grain(draw, index, pal['plaster'], rng, amount=4, speckle=0.08)
    ox, oy = box(index)
    # half-timber studs at the tile edges, braces on one variant
    draw.rectangle([ox, oy, ox + 2, oy + 15], fill=pal['timber'] + (255,))
    draw.rectangle([ox + 13, oy, ox + 15, oy + 15], fill=pal['timber'] + (255,))
    draw.rectangle([ox, oy, ox + 15, oy + 1], fill=pal['timber'] + (255,))
    if col % 2:
        draw.line([ox + 3, oy + 2, ox + 12, oy + 13], fill=pal['timber'] + (255,))
    else:
        draw.line([ox + 12, oy + 2, ox + 3, oy + 13], fill=pal['timber'] + (255,))


def stone_wall(draw, index, col, pal):
    rng = random.Random(2400 + index)
    grain(draw, index, pal['stone'], rng, amount=6, speckle=0.14)
    ox, oy = box(index)
    for y in (5, 10, 15):
        draw.line([ox, oy + y, ox + 15, oy + y], fill=pal['stone_dark'] + (255,))
    for row, y in enumerate((0, 6, 11)):
        x = (3 + row * 5 + col) % 12 + 1
        draw.line([ox + x, oy + y, ox + x, oy + y + 4], fill=pal['stone_dark'] + (255,))


def cap(draw, index, col, pal, light=False):
    rng = random.Random(2600 + index)
    base = pal['roof_light'] if light else pal['roof']
    grain(draw, index, base, rng, amount=6, speckle=0.12)
    ox, oy = box(index)
    for y in range(0, 16, 4):
        draw.line([ox, oy + y, ox + 15, oy + y], fill=pal['timber'] + (255,))
        for x in range((col % 2) * 4, 16, 8):
            draw.arc([ox + x, oy + y + 1, ox + x + 7, oy + y + 4], 180, 360, fill=pal['roof'] + (255,))
    draw.line([ox, oy, ox + 15, oy], fill=tuple(min(255, c + 26) for c in base) + (255,))


def counter(draw, index, col, pal):
    rng = random.Random(2800 + index)
    grain(draw, index, pal['counter'], rng, amount=4, speckle=0.08)
    ox, oy = box(index)
    draw.rectangle([ox, oy, ox + 15, oy + 2], fill=pal['metal'] + (255,))
    if col == 3:  # a tankard left on the counter
        draw.rectangle([ox + 5, oy + 5, ox + 8, oy + 9], fill=pal['metal'] + (255,))
        draw.arc([ox + 8, oy + 5, ox + 10, oy + 8], 270, 90, fill=pal['metal'] + (255,))
        draw.line([ox + 5, oy + 5, ox + 8, oy + 5], fill=(244, 240, 222, 255))


def facade(draw, index, col, pal):
    rng = random.Random(3000 + index)
    grain(draw, index, pal['plaster'], rng, amount=4, speckle=0.06)
    ox, oy = box(index)
    draw.rectangle([ox, oy + 12, ox + 15, oy + 15], fill=pal['stone'] + (255,))
    draw.rectangle([ox, oy, ox + 2, oy + 12], fill=pal['timber'] + (255,))
    draw.rectangle([ox + 13, oy, ox + 15, oy + 12], fill=pal['timber'] + (255,))
    if col == 1:  # lit window
        draw.rectangle([ox + 4, oy + 3, ox + 11, oy + 9], fill=pal['timber'] + (255,))
        draw.rectangle([ox + 5, oy + 4, ox + 10, oy + 8], fill=(246, 214, 142, 255))
        draw.line([ox + 8, oy + 4, ox + 8, oy + 8], fill=pal['timber'] + (255,))


def paint(atlas, pal):
    draw = ImageDraw.Draw(atlas)
    for prop in (79, 107, 527, 1024, 1034, 1035):
        ox, oy = box(prop)
        draw.rectangle([ox, oy, ox + 15, oy + 15], fill=(0, 0, 0, 0))
    for i, index in enumerate(TURF):
        turf(draw, index, i, pal)
    for i, index in enumerate(ROAD):
        road(draw, index, i, pal)
    for i, index in enumerate(STONE):
        stonework(draw, index, i, pal)
    tree(draw, 79, pal)
    lamp(draw, 107, pal)
    pillar(draw, 527, pal)
    crate(draw, 1024, pal)
    barrel(draw, 1034, pal)
    barrel(draw, 1035, pal)
    for i, index in enumerate(FLOORS):
        boards(draw, index, i, pal)
    wall = stone_wall if pal['pattern'] == 'paving' else plaster_wall
    for i, index in enumerate(WALLS):
        wall(draw, index, i, pal)
    ox, oy = box(661)                      # wall side / corner post
    draw.rectangle([ox, oy, ox + 15, oy + 15], fill=pal['timber'] + (255,))
    draw.rectangle([ox + 3, oy, ox + 4, oy + 15], fill=tuple(min(255, c + 24) for c in pal['timber']) + (255,))
    for i, index in enumerate(CAPS):
        cap(draw, index, i, pal, light=(i == 1))
    cap(draw, 670, 3, pal, light=True)     # ridge
    for i, index in enumerate(BAR):
        counter(draw, index, i, pal)
    for i, index in enumerate(FACADE):
        facade(draw, index, i, pal)
    return atlas


def build(region):
    pal = REGIONS[region]
    base = Image.open(os.path.join(SRC, 'ts_wrenfield.png')).convert('RGBA')
    atlas = paint(base.copy(), pal)
    path = os.path.join(SRC, f'ts_{region}.png')
    atlas.save(path)
    return atlas, path


def preview(atlas, region):
    cols, scale, cell = 6, 4, 64
    rows = (len(TOUCHED) + cols - 1) // cols
    label_h = 14
    img = Image.new('RGBA', (cols * cell, rows * (cell + label_h)), (14, 14, 16, 255))
    draw = ImageDraw.Draw(img)
    for i, index in enumerate(TOUCHED):
        col, row = i % cols, i // cols
        ox, oy = box(index)
        src = atlas.crop((ox, oy, ox + TILE, oy + TILE)).resize((cell, cell), Image.NEAREST)
        x, y = col * cell, row * (cell + label_h)
        for cy in range(0, cell, 8):
            for cx in range(0, cell, 8):
                if (cx // 8 + cy // 8) % 2 == 0:
                    draw.rectangle([x + cx, y + cy, x + cx + 7, y + cy + 7], fill=(26, 26, 30, 255))
        img.alpha_composite(src, (x, y))
        draw.text((x + 2, y + cell + 1), str(index), fill=(210, 210, 200, 255))
    path = os.path.join(SRC, f'ts_{region}_preview_4x.png')
    img.save(path)
    return path


def uid(*parts):
    return str(uuid.uuid5(uuid.NAMESPACE_URL, 'ashen-crown/' + '/'.join(parts)))


def write_json(path, obj):
    with open(path, 'w', newline='\n') as f:
        json.dump(obj, f, indent=2)
        f.write('\n')


def emit_resources(region, atlas):
    spr = f'spr_ts_{region}'
    ts = f'ts_{region}'
    frame = uid(spr, 'frame')
    layer = uid(spr, 'layer')
    keyframe = uid(spr, 'keyframe')
    spr_dir = os.path.join(GM, 'sprites', spr)
    os.makedirs(os.path.join(spr_dir, 'layers', frame), exist_ok=True)
    atlas.save(os.path.join(spr_dir, frame + '.png'))
    atlas.save(os.path.join(spr_dir, 'layers', frame, layer + '.png'))
    write_json(os.path.join(spr_dir, spr + '.yy'), {
        "$GMSprite": "", "%Name": spr,
        "bboxMode": 1, "bbox_bottom": HEIGHT - 1, "bbox_left": 0,
        "bbox_right": WIDTH - 1, "bbox_top": 0,
        "collisionKind": 1, "collisionTolerance": 0,
        "DynamicTexturePage": False, "edgeFiltering": False, "For3D": False,
        "frames": [{"$GMSpriteFrame": "", "%Name": frame, "name": frame,
                    "resourceType": "GMSpriteFrame", "resourceVersion": "2.0"}],
        "gridX": 0, "gridY": 0, "height": HEIGHT, "HTile": False,
        "layers": [{"$GMImageLayer": "", "%Name": layer, "blendMode": 0,
                    "displayName": "default", "isLocked": False, "name": layer,
                    "opacity": 100.0, "resourceType": "GMImageLayer",
                    "resourceVersion": "2.0", "visible": True}],
        "name": spr, "nineSlice": None, "origin": 0,
        "parent": {"name": "sprites", "path": "folders/sprites.yy"},
        "preMultiplyAlpha": False, "resourceType": "GMSprite", "resourceVersion": "2.0",
        "sequence": {
            "$GMSequence": "", "%Name": spr, "autoRecord": True,
            "backdropHeight": 1080, "backdropImageOpacity": 0.5, "backdropImagePath": "",
            "backdropWidth": 1920, "backdropXOffset": 0.0, "backdropYOffset": 0.0,
            "eventStubScript": None, "eventToFunction": {},
            "events": {"$KeyframeStore<MessageEventKeyframe>": "", "Keyframes": [],
                       "resourceType": "KeyframeStore<MessageEventKeyframe>",
                       "resourceVersion": "2.0"},
            "length": 1.0, "lockOrigin": False,
            "moments": {"$KeyframeStore<MomentsEventKeyframe>": "", "Keyframes": [],
                        "resourceType": "KeyframeStore<MomentsEventKeyframe>",
                        "resourceVersion": "2.0"},
            "name": spr, "playback": 1, "playbackSpeed": 0.0,
            "playbackSpeedType": 0, "resourceType": "GMSequence", "resourceVersion": "2.0",
            "showBackdrop": True, "showBackdropImage": False, "timeUnits": 1,
            "visibleRange": None, "volume": 1.0, "xorigin": 0, "yorigin": 0,
            "tracks": [{
                "$GMSpriteFramesTrack": "", "builtinName": 0, "events": [],
                "inheritsTrackColour": True, "interpolation": 1, "isCreationTrack": False,
                "keyframes": {
                    "$KeyframeStore<SpriteFrameKeyframe>": "",
                    "Keyframes": [{
                        "$Keyframe<SpriteFrameKeyframe>": "",
                        "Channels": {"0": {"$SpriteFrameKeyframe": "",
                                           "Id": {"name": frame, "path": f"sprites/{spr}/{spr}.yy"},
                                           "resourceType": "SpriteFrameKeyframe",
                                           "resourceVersion": "2.0"}},
                        "Disabled": False, "id": keyframe, "IsCreationKey": False,
                        "Key": 0.0, "Length": 1.0,
                        "resourceType": "Keyframe<SpriteFrameKeyframe>",
                        "resourceVersion": "2.0", "Stretch": False}],
                    "resourceType": "KeyframeStore<SpriteFrameKeyframe>",
                    "resourceVersion": "2.0"},
                "modifiers": [], "name": "frames",
                "resourceType": "GMSpriteFramesTrack", "resourceVersion": "2.0",
                "spriteId": None, "trackColour": 0, "tracks": [], "traits": 0}],
        },
        "swatchColours": None, "swfPrecision": 2.525,
        "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
        "type": 0, "VTile": False, "width": WIDTH,
    })

    ts_dir = os.path.join(GM, 'tilesets', ts)
    os.makedirs(ts_dir, exist_ok=True)
    write_json(os.path.join(ts_dir, ts + '.yy'), {
        "$GMTileSet": "v1", "%Name": ts, "autoTileSets": [],
        "macroPageTiles": {"SerialiseHeight": 0, "SerialiseWidth": 0, "TileSerialiseData": []},
        "name": ts, "out_columns": COLS, "out_tilehborder": 2, "out_tilevborder": 2,
        "parent": {"name": "tilesets", "path": "folders/tilesets.yy"},
        "resourceType": "GMTileSet", "resourceVersion": "2.0",
        "spriteId": {"name": spr, "path": f"sprites/{spr}/{spr}.yy"},
        "spriteNoExport": True,
        "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
        "tileAnimationFrames": [], "tileAnimationSpeed": 15.0,
        "tileHeight": 16, "tilehsep": 0, "tilevsep": 0, "tileWidth": 16,
        "tilexoff": 0, "tileyoff": 0, "tile_count": COLS * ROWS,
    })

    yyp_path = os.path.join(GM, 'AshenCrown.yyp')
    yyp = open(yyp_path, encoding='utf-8').read()
    if f'"name":"{spr}"' not in yyp:
        anchor_name = 'spr_ts_barrow' if '"name":"spr_ts_barrow"' in yyp else 'spr_ts_wrenfield'
        anchor = ('    {\n      "id":{\n        "name":"%s",\n'
                  '        "path":"sprites/%s/%s.yy",\n      },\n    },\n' % (anchor_name, anchor_name, anchor_name))
        block = ('    {\n      "id":{\n        "name":"%s",\n'
                 '        "path":"sprites/%s/%s.yy",\n      },\n    },\n' % (spr, spr, spr))
        assert anchor in yyp, f'{anchor_name} resource block not found in the yyp'
        yyp = yyp.replace(anchor, anchor + block, 1)
    if f'"name":"{ts}"' not in yyp:
        anchor_name = 'ts_barrow' if '"name":"ts_barrow"' in yyp else 'ts_wrenfield'
        anchor = ('    {\n      "id":{\n        "name":"%s",\n'
                  '        "path":"tilesets/%s/%s.yy",\n      },\n    },\n' % (anchor_name, anchor_name, anchor_name))
        block = ('    {\n      "id":{\n        "name":"%s",\n'
                 '        "path":"tilesets/%s/%s.yy",\n      },\n    },\n' % (ts, ts, ts))
        assert anchor in yyp, f'{anchor_name} resource block not found in the yyp'
        yyp = yyp.replace(anchor, anchor + block, 1)
    open(yyp_path, 'w', encoding='utf-8', newline='\n').write(yyp)

    order_path = os.path.join(GM, 'AshenCrown.resource_order')
    order = open(order_path, encoding='utf-8').read()
    existing = set(re.findall(r'"name":"(spr_ts_\w+|ts_\w+)"', order))
    entries = [(spr, f'sprites/{spr}/{spr}.yy'), (ts, f'tilesets/{ts}/{ts}.yy')]
    last_order = max(int(m) for m in re.findall(r'"order":(\d+)', order))
    for name, path in entries:
        if name in existing:
            continue
        last_order += 1
        block = ('    {\n      "name":"%s",\n      "order":%d,\n      "path":"%s",\n    },\n'
                 % (name, last_order, path))
        marker = '\n],\n}'
        assert marker in order
        order = order.replace(marker, '\n' + block.rstrip('\n') + marker, 1)
    open(order_path, 'w', encoding='utf-8', newline='\n').write(order)
    print(f'registered {spr} and {ts}')


def main():
    for region in REGIONS:
        atlas, path = build(region)
        print('wrote', os.path.relpath(path, ROOT), atlas.size)
        print('wrote', os.path.relpath(preview(atlas, region), ROOT))
        emit_resources(region, atlas)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
