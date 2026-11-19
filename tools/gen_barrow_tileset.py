#!/usr/bin/env python3
"""Build `ts_barrow`, the crypt atlas for the Chapters 10-11 barrow rooms.

Those three rooms were Wrenfield blockouts: grass, road and street stone under a
barrow. This atlas keeps the tile-id contract the room builders rely on (65 rows,
16x16 tiles) and adds the crypt's own material in rows 50-55 (ids 800-895), the
same pattern `ts_blackwood` uses. Rows 0-49 are copied from `ts_zone1`, so every
old id still means what it meant.

  800-815  brgrass_*    dead turf over the field (the gate's approach)
  816-831  brfloor_*    cold flagstone (halls and deep)
  832-847  brubble_*    gravel, chippings, bone dust
  848-863  brwalltop_*  wall caps and lintels
  864-879  brwallface_* block courses and mortar
  880-895  props         pillar, broken pillar, sconce, brazier, sarcophagus,
                        urn, bones, skull, cobweb, root, rune slab, stair,
                        rubble pile, candles, chain, floor crack

Writes the atlas, a labelled 4x preview of rows 50-55, and the GameMaker side
(sprite `spr_ts_barrow`, tileset `ts_barrow`, both registered idempotently):

    python3 tools/gen_barrow_tileset.py
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
ATLAS = os.path.join(SRC, 'ts_barrow.png')
PREVIEW = os.path.join(SRC, 'ts_barrow_preview_4x.png')
COLS, TILE, ROWS = 16, 16, 65
WIDTH, HEIGHT = COLS * TILE, ROWS * TILE

BANDS = {
    'brgrass': 800, 'brfloor': 816, 'brubble': 832,
    'brwalltop': 848, 'brwallface': 864,
}
PROPS = ['brpillar', 'brpillar_broken', 'brsconce', 'brbrazier', 'brsarcophagus',
         'brurn', 'brbones', 'brskull', 'brweb', 'brroot', 'brrune', 'brstair',
         'brrubble_pile', 'brcandles', 'brchain', 'brcrack']


def names_for(index):
    if index < 800:
        return ''
    row, col = index // 16, index % 16
    if row == 50:
        return f'brgrass_{col}'
    if row == 51:
        return f'brfloor_{col}'
    if row == 52:
        return f'brubble_{col}'
    if row == 53:
        return f'brwalltop_{col}'
    if row == 54:
        return f'brwallface_{col}'
    if row == 55:
        return PROPS[col]
    return ''


def box(index):
    return (index % COLS) * TILE, (index // COLS) * TILE


def shade(rgb, rng, amount=7):
    return (max(0, min(255, rgb[0] + rng.randint(-amount, amount))),
            max(0, min(255, rgb[1] + rng.randint(-amount, amount))),
            max(0, min(255, rgb[2] + rng.randint(-amount, amount))), 255)


def grain(draw, index, base, rng, amount=7, speckle=0.18):
    ox, oy = box(index)
    draw.rectangle([ox, oy, ox + 15, oy + 15], fill=base + (255,))
    for y in range(16):
        for x in range(16):
            if rng.random() < speckle:
                draw.point((ox + x, oy + y), fill=shade(base, rng, amount))


def dead_grass(draw, index, col):
    rng = random.Random(9100 + index)
    base = (58 + col % 3, 54 + col % 2, 40 + col % 3)
    grain(draw, index, base, rng)
    ox, oy = box(index)
    for _ in range(7):  # dry blades
        x, y = rng.randrange(1, 14), rng.randrange(4, 15)
        draw.line([ox + x, oy + y, ox + x + rng.randint(-1, 1), oy + y - rng.randint(1, 3)],
                  fill=shade((96, 88, 62), rng, 8))
    for _ in range(2):
        x, y = rng.randrange(2, 13), rng.randrange(3, 13)
        draw.point((ox + x, oy + y), fill=(118, 110, 82, 255))


def floor(draw, index, col):
    rng = random.Random(9300 + index)
    base = (58 + col % 3, 60 + col % 3, 66 + col % 2)
    grain(draw, index, base, rng, amount=6, speckle=0.14)
    ox, oy = box(index)
    # slab seams: two courses with a staggered join, so a field of tiles reads as paving
    draw.line([ox, oy + 5, ox + 15, oy + 5], fill=(38, 40, 46, 255))
    draw.line([ox, oy + 10, ox + 15, oy + 10], fill=(38, 40, 46, 255))
    x = 4 if col % 2 == 0 else 11
    draw.line([ox + x, oy, ox + x, oy + 5], fill=(40, 42, 48, 255))
    draw.line([ox + (15 - x), oy + 5, ox + (15 - x), oy + 10], fill=(40, 42, 48, 255))
    draw.line([ox + x, oy + 10, ox + x, oy + 15], fill=(40, 42, 48, 255))
    if col % 4 == 0:  # a hairline crack
        draw.line([ox + 6, oy + 11, ox + 9, oy + 13, ox + 8, oy + 15], fill=(34, 36, 41, 255))
    if col % 5 == 1:  # dust drift
        draw.ellipse([ox + 2, oy + 2, ox + 8, oy + 4], fill=(70, 72, 78, 255))


def rubble(draw, index, col):
    rng = random.Random(9500 + index)
    base = (46 + col % 3, 44 + col % 2, 42 + col % 2)
    grain(draw, index, base, rng, amount=9, speckle=0.22)
    ox, oy = box(index)
    for _ in range(5):
        x, y = rng.randrange(1, 13), rng.randrange(1, 13)
        w = rng.randint(1, 3)
        draw.rectangle([ox + x, oy + y, ox + x + w, oy + y + rng.randint(1, 2)],
                       fill=shade((66, 64, 62), rng, 10))
    if col % 4 == 2:  # bone dust
        for _ in range(3):
            x, y = rng.randrange(2, 14), rng.randrange(2, 14)
            draw.point((ox + x, oy + y), fill=(148, 142, 122, 255))


def wall_top(draw, index, col):
    rng = random.Random(9700 + index)
    base = (72 + col % 3, 74 + col % 2, 80 + col % 2)
    grain(draw, index, base, rng, amount=5, speckle=0.10)
    ox, oy = box(index)
    draw.line([ox, oy + 1, ox + 15, oy + 1], fill=(96, 98, 104, 255))
    draw.line([ox, oy + 14, ox + 15, oy + 14], fill=(44, 46, 52, 255))
    draw.line([ox + (7 if col % 2 else 8), oy + 2, ox + (7 if col % 2 else 8), oy + 13],
              fill=(50, 52, 58, 255))


def wall_face(draw, index, col):
    rng = random.Random(9900 + index)
    base = (44 + col % 3, 44 + col % 2, 48 + col % 2)
    grain(draw, index, base, rng, amount=6, speckle=0.12)
    ox, oy = box(index)
    for y in (5, 10, 15):  # mortar courses
        draw.line([ox, oy + y, ox + 15, oy + y], fill=(34, 36, 42, 255))
    for row, y in enumerate((0, 6, 11)):
        x = (3 + row * 5 + col) % 12 + 1
        draw.line([ox + x, oy + y, ox + x, oy + y + 4], fill=(36, 38, 44, 255))
    if col % 3 == 0:  # a chipped block
        draw.rectangle([ox + 4, oy + 7, ox + 7, oy + 9], fill=(46, 48, 54, 255))
    if col % 4 == 3:  # seep stain
        draw.line([ox + 11, oy + 1, ox + 11, oy + 4], fill=(40, 46, 48, 255))


def pillar(draw, index, broken=False):
    ox, oy = box(index)
    top = 2 if broken else 0
    draw.rectangle([ox + 4, oy + top, ox + 11, oy + 15], fill=(66, 68, 74, 255))
    draw.rectangle([ox + 3, oy + top, ox + 12, oy + top + 2], fill=(82, 84, 90, 255))
    draw.rectangle([ox + 5, oy + top + 3, ox + 6, oy + 15], fill=(54, 56, 62, 255))
    draw.rectangle([ox + 9, oy + top + 3, ox + 10, oy + 15], fill=(46, 48, 54, 255))
    if not broken:
        draw.rectangle([ox + 3, oy + 14, ox + 12, oy + 15], fill=(78, 80, 86, 255))
    else:  # chipped crown
        for x, y in ((4, top), (5, top + 1), (10, top), (11, top + 1)):
            draw.point((ox + x, oy + y), fill=(0, 0, 0, 0))


def sconce(draw, index):
    ox, oy = box(index)
    draw.rectangle([ox + 7, oy + 8, ox + 8, oy + 13], fill=(58, 52, 44, 255))
    draw.rectangle([ox + 5, oy + 7, ox + 10, oy + 8], fill=(74, 66, 54, 255))
    draw.ellipse([ox + 6, oy + 2, ox + 9, oy + 7], fill=(228, 168, 78, 255))
    draw.point((ox + 7, oy + 3), fill=(255, 226, 150, 255))
    draw.point((ox + 8, oy + 5), fill=(196, 112, 44, 255))


def brazier(draw, index):
    ox, oy = box(index)
    draw.ellipse([ox + 3, oy + 8, ox + 12, oy + 14], fill=(62, 58, 52, 255))
    draw.ellipse([ox + 4, oy + 9, ox + 11, oy + 12], fill=(40, 30, 24, 255))
    draw.ellipse([ox + 6, oy + 6, ox + 9, oy + 10], fill=(214, 128, 52, 255))
    draw.point((ox + 7, oy + 6), fill=(250, 210, 132, 255))
    draw.rectangle([ox + 7, oy + 14, ox + 8, oy + 15], fill=(48, 44, 40, 255))


def sarcophagus(draw, index):
    ox, oy = box(index)
    draw.rectangle([ox + 1, oy + 4, ox + 14, oy + 14], fill=(74, 76, 82, 255))
    draw.rectangle([ox + 2, oy + 5, ox + 13, oy + 13], fill=(62, 64, 70, 255))
    draw.line([ox + 8, oy + 5, ox + 8, oy + 13], fill=(48, 50, 56, 255))
    draw.rectangle([ox + 4, oy + 6, ox + 7, oy + 7], fill=(84, 86, 92, 255))   # effigy head
    draw.line([ox + 4, oy + 9, ox + 7, oy + 9], fill=(84, 86, 92, 255))
    draw.point((ox + 11, oy + 12), fill=(190, 184, 164, 255))


def urn(draw, index):
    ox, oy = box(index)
    draw.ellipse([ox + 4, oy + 7, ox + 11, oy + 14], fill=(80, 74, 66, 255))
    draw.rectangle([ox + 6, oy + 4, ox + 9, oy + 7], fill=(92, 86, 76, 255))
    draw.ellipse([ox + 5, oy + 8, ox + 7, oy + 11], fill=(66, 60, 54, 255))
    draw.point((ox + 9, oy + 9), fill=(116, 108, 94, 255))


def bones(draw, index):
    ox, oy = box(index)
    draw.line([ox + 2, oy + 12, ox + 8, oy + 9], fill=(198, 192, 172, 255), width=2)
    draw.line([ox + 8, oy + 9, ox + 13, oy + 12], fill=(198, 192, 172, 255), width=2)
    draw.ellipse([ox + 2, oy + 4, ox + 7, oy + 8], fill=(208, 202, 182, 255))
    draw.point((ox + 4, oy + 6), fill=(30, 28, 24, 255))
    draw.point((ox + 5, oy + 6), fill=(30, 28, 24, 255))
    draw.line([ox + 10, oy + 4, ox + 13, oy + 8], fill=(184, 178, 158, 255))


def skull(draw, index):
    ox, oy = box(index)
    draw.ellipse([ox + 4, oy + 5, ox + 11, oy + 12], fill=(210, 204, 184, 255))
    draw.rectangle([ox + 6, oy + 11, ox + 9, oy + 13], fill=(200, 194, 174, 255))
    draw.point((ox + 6, oy + 8), fill=(28, 26, 22, 255))
    draw.point((ox + 9, oy + 8), fill=(28, 26, 22, 255))
    draw.point((ox + 7, oy + 10), fill=(40, 36, 30, 255))


def web(draw, index):
    ox, oy = box(index)
    for k in range(4):
        draw.line([ox + 1, oy + 1 + k * 4, ox + 14, oy + 1 + k * 4], fill=(160, 158, 150, 120))
    draw.line([ox + 1, oy + 1, ox + 14, oy + 14], fill=(160, 158, 150, 120))
    draw.line([ox + 14, oy + 1, ox + 1, oy + 14], fill=(160, 158, 150, 120))


def root(draw, index):
    ox, oy = box(index)
    rng = random.Random(10300 + index)
    for _ in range(5):
        x0, y0 = rng.randrange(2, 14), 0
        x1, y1 = rng.randrange(1, 15), rng.randrange(8, 16)
        draw.line([ox + x0, oy + y0, ox + x1, oy + y1], fill=(74, 58, 44, 255), width=2)
    for _ in range(3):
        draw.point((ox + rng.randrange(2, 14), oy + rng.randrange(6, 15)), fill=(96, 78, 58, 255))


def rune(draw, index):
    ox, oy = box(index)
    draw.rectangle([ox + 2, oy + 2, ox + 13, oy + 14], fill=(62, 64, 70, 255))
    draw.rectangle([ox + 3, oy + 3, ox + 12, oy + 13], fill=(50, 52, 58, 255))
    for x, y in ((6, 5), (9, 5), (7, 7), (8, 7), (8, 9), (7, 11), (9, 11)):
        draw.point((ox + x, oy + y), fill=(116, 196, 160, 255))
    draw.point((ox + 8, oy + 6), fill=(168, 236, 196, 255))


def stair(draw, index):
    ox, oy = box(index)
    for k in range(4):
        y = k * 4
        draw.rectangle([ox, oy + y, ox + 15, oy + y + 3], fill=(64 + k * 4, 66 + k * 4, 72 + k * 4, 255))
        draw.line([ox, oy + y, ox + 15, oy + y], fill=(84, 86, 92, 255))
        draw.line([ox, oy + y + 3, ox + 15, oy + y + 3], fill=(42, 44, 50, 255))


def rubble_pile(draw, index):
    ox, oy = box(index)
    rng = random.Random(10500 + index)
    draw.ellipse([ox + 1, oy + 7, ox + 14, oy + 15], fill=(44, 42, 40, 255))
    for _ in range(9):
        x, y = rng.randrange(2, 14), rng.randrange(7, 15)
        draw.rectangle([ox + x, oy + y, ox + x + rng.randint(1, 3), oy + y + rng.randint(1, 2)],
                       fill=shade((68, 66, 62), rng, 12))
    draw.point((ox + 5, oy + 8), fill=(152, 146, 126, 255))


def candles(draw, index):
    ox, oy = box(index)
    for x, h in ((4, 7), (7, 10), (10, 6)):
        draw.rectangle([ox + x, oy + 15 - h, ox + x + 1, oy + 14], fill=(206, 198, 176, 255))
        draw.point((ox + x, oy + 14 - h), fill=(250, 206, 124, 255))
    draw.ellipse([ox + 3, oy + 12, ox + 11, oy + 15], fill=(78, 70, 58, 255))


def chain(draw, index):
    ox, oy = box(index)
    for k in range(4):
        y = k * 4 + 1
        draw.ellipse([ox + 6, oy + y, ox + 9, oy + y + 3], outline=(120, 118, 112, 255))
    draw.point((ox + 7, oy + 15), fill=(90, 88, 84, 255))


def crack(draw, index):
    ox, oy = box(index)
    draw.line([ox + 2, oy + 3, ox + 6, oy + 7, ox + 5, oy + 11, ox + 9, oy + 15],
              fill=(34, 36, 41, 255), width=1)
    draw.line([ox + 9, oy + 15, ox + 13, oy + 12], fill=(36, 38, 43, 255))


def dead_tree(draw, index):
    ox, oy = box(index)
    draw.rectangle([ox + 7, oy + 5, ox + 9, oy + 15], fill=(58, 48, 38, 255))
    draw.line([ox + 8, oy + 8, ox + 3, oy + 3], fill=(58, 48, 38, 255), width=2)
    draw.line([ox + 8, oy + 7, ox + 13, oy + 2], fill=(58, 48, 38, 255), width=2)
    draw.line([ox + 3, oy + 3, ox + 2, oy + 1], fill=(72, 60, 46, 255))
    draw.line([ox + 13, oy + 2, ox + 14, oy + 0], fill=(72, 60, 46, 255))
    draw.line([ox + 8, oy + 11, ox + 4, oy + 8], fill=(66, 54, 42, 255))


def standing_stone(draw, index):
    ox, oy = box(index)
    draw.rectangle([ox + 5, oy + 3, ox + 10, oy + 15], fill=(72, 74, 80, 255))
    draw.rectangle([ox + 6, oy + 4, ox + 9, oy + 14], fill=(62, 64, 70, 255))
    draw.rectangle([ox + 4, oy + 13, ox + 11, oy + 15], fill=(54, 56, 62, 255))
    draw.line([ox + 7, oy + 7, ox + 8, oy + 10], fill=(114, 196, 160, 255))


def build_atlas():
    base = Image.open(os.path.join(SRC, 'ts_wrenfield.png')).convert('RGBA')
    assert base.size == (WIDTH, HEIGHT), f'ts_wrenfield.png is {base.size}, expected {(WIDTH, HEIGHT)}'
    atlas = base.copy()
    draw = ImageDraw.Draw(atlas)

    for i in range(16):
        dead_grass(draw, 800 + i, i)
        floor(draw, 816 + i, i)
        rubble(draw, 832 + i, i)
        wall_top(draw, 848 + i, i)
        wall_face(draw, 864 + i, i)

    for i in range(16):  # props sit on the room's own floor, not on a Wrenfield tile
        ox, oy = box(880 + i)
        draw.rectangle([ox, oy, ox + 15, oy + 15], fill=(0, 0, 0, 0))

    pillar(draw, 880)
    pillar(draw, 881, broken=True)
    sconce(draw, 882)
    brazier(draw, 883)
    sarcophagus(draw, 884)
    urn(draw, 885)
    bones(draw, 886)
    skull(draw, 887)
    web(draw, 888)
    root(draw, 889)
    rune(draw, 890)
    stair(draw, 891)
    rubble_pile(draw, 892)
    candles(draw, 893)
    chain(draw, 894)
    crack(draw, 895)

    # Wrenfield ids the barrow gate still uses: same meaning, crypt dressing.
    for i in range(16):
        ox, oy = box(79)
        draw.rectangle([ox, oy, ox + 15, oy + 15], fill=(0, 0, 0, 0))
    dead_tree(draw, 79)
    standing_stone(draw, 527)
    for i in range(16):
        ox, oy = box(107)
        draw.rectangle([ox, oy, ox + 15, oy + 15], fill=(0, 0, 0, 0))
    sconce(draw, 107)
    for i in range(16):
        ox, oy = box(1024)
        draw.rectangle([ox, oy, ox + 15, oy + 15], fill=(0, 0, 0, 0))
    urn(draw, 1024)

    atlas.save(ATLAS)
    return atlas


def build_preview(atlas, scale=4):
    rows = range(50, 56)
    label_h = 14 * scale
    cell = TILE * scale
    img = Image.new('RGBA', (COLS * cell, len(rows) * (cell + label_h)), (14, 14, 16, 255))
    draw = ImageDraw.Draw(img)
    for r_i, row in enumerate(rows):
        for col in range(COLS):
            index = row * COLS + col
            src = atlas.crop((col * TILE, row * TILE, col * TILE + TILE, row * TILE + TILE))
            big = src.resize((cell, cell), Image.NEAREST)
            x, y = col * cell, r_i * (cell + label_h)
            for cy in range(0, cell, 8):
                for cx in range(0, cell, 8):
                    if (cx // 8 + cy // 8) % 2 == 0:
                        draw.rectangle([x + cx, y + cy, x + cx + 7, y + cy + 7], fill=(26, 26, 30, 255))
            img.alpha_composite(big, (x, y))
            draw.text((x + 2, y + cell + 1), f'{index}', fill=(210, 210, 200, 255))
    img.save(PREVIEW)
    return PREVIEW


def uid(*parts):
    return str(uuid.uuid5(uuid.NAMESPACE_URL, 'ashen-crown/' + '/'.join(parts)))


def write_json(path, obj):
    with open(path, 'w', newline='\n') as f:
        json.dump(obj, f, indent=2)
        f.write('\n')


def emit_resources(atlas):
    frame = uid('spr_ts_barrow', 'frame')
    layer = uid('spr_ts_barrow', 'layer')
    keyframe = uid('spr_ts_barrow', 'keyframe')
    spr_dir = os.path.join(GM, 'sprites', 'spr_ts_barrow')
    os.makedirs(os.path.join(spr_dir, 'layers', frame), exist_ok=True)
    atlas.save(os.path.join(spr_dir, frame + '.png'))
    atlas.save(os.path.join(spr_dir, 'layers', frame, layer + '.png'))
    write_json(os.path.join(spr_dir, 'spr_ts_barrow.yy'), {
        "$GMSprite": "", "%Name": "spr_ts_barrow",
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
        "name": "spr_ts_barrow", "nineSlice": None, "origin": 0,
        "parent": {"name": "sprites", "path": "folders/sprites.yy"},
        "preMultiplyAlpha": False, "resourceType": "GMSprite", "resourceVersion": "2.0",
        "sequence": {
            "$GMSequence": "", "%Name": "spr_ts_barrow", "autoRecord": True,
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
            "name": "spr_ts_barrow", "playback": 1, "playbackSpeed": 0.0,
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
                                           "Id": {"name": frame,
                                                  "path": "sprites/spr_ts_barrow/spr_ts_barrow.yy"},
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

    ts_dir = os.path.join(GM, 'tilesets', 'ts_barrow')
    os.makedirs(ts_dir, exist_ok=True)
    write_json(os.path.join(ts_dir, 'ts_barrow.yy'), {
        "$GMTileSet": "v1", "%Name": "ts_barrow", "autoTileSets": [],
        "macroPageTiles": {"SerialiseHeight": 0, "SerialiseWidth": 0, "TileSerialiseData": []},
        "name": "ts_barrow", "out_columns": COLS, "out_tilehborder": 2, "out_tilevborder": 2,
        "parent": {"name": "tilesets", "path": "folders/tilesets.yy"},
        "resourceType": "GMTileSet", "resourceVersion": "2.0",
        "spriteId": {"name": "spr_ts_barrow",
                     "path": "sprites/spr_ts_barrow/spr_ts_barrow.yy"},
        "spriteNoExport": True,
        "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
        "tileAnimationFrames": [], "tileAnimationSpeed": 15.0,
        "tileHeight": 16, "tilehsep": 0, "tilevsep": 0, "tileWidth": 16,
        "tilexoff": 0, "tileyoff": 0, "tile_count": COLS * ROWS,
    })
    print('wrote', os.path.relpath(os.path.join(spr_dir, 'spr_ts_barrow.yy'), ROOT))
    print('wrote', os.path.relpath(os.path.join(ts_dir, 'ts_barrow.yy'), ROOT))

    yyp_path = os.path.join(GM, 'AshenCrown.yyp')
    yyp = open(yyp_path, encoding='utf-8').read()
    spr_anchor = ('    {\n      "id":{\n        "name":"spr_ts_wrenfield",\n'
                  '        "path":"sprites/spr_ts_wrenfield/spr_ts_wrenfield.yy",\n      },\n    },\n')
    ts_anchor = ('    {\n      "id":{\n        "name":"ts_wrenfield",\n'
                 '        "path":"tilesets/ts_wrenfield/ts_wrenfield.yy",\n      },\n    },\n')
    if '"name":"spr_ts_barrow"' not in yyp:
        block = ('    {\n      "id":{\n        "name":"spr_ts_barrow",\n'
                 '        "path":"sprites/spr_ts_barrow/spr_ts_barrow.yy",\n      },\n    },\n')
        assert spr_anchor in yyp, 'spr_ts_wrenfield resource block not found in the yyp'
        yyp = yyp.replace(spr_anchor, spr_anchor + block, 1)
    if '"name":"ts_barrow"' not in yyp:
        block = ('    {\n      "id":{\n        "name":"ts_barrow",\n'
                 '        "path":"tilesets/ts_barrow/ts_barrow.yy",\n      },\n    },\n')
        assert ts_anchor in yyp, 'ts_wrenfield resource block not found in the yyp'
        yyp = yyp.replace(ts_anchor, ts_anchor + block, 1)
    open(yyp_path, 'w', encoding='utf-8', newline='\n').write(yyp)

    order_path = os.path.join(GM, 'AshenCrown.resource_order')
    order = open(order_path, encoding='utf-8').read()
    existing = set(re.findall(r'"name":"(spr_ts_barrow|ts_barrow)"', order))
    entries = [('spr_ts_barrow', 'sprites/spr_ts_barrow/spr_ts_barrow.yy'),
               ('ts_barrow', 'tilesets/ts_barrow/ts_barrow.yy')]
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
    print('registered spr_ts_barrow and ts_barrow in the yyp and resource_order')


def main():
    atlas = build_atlas()
    print('wrote', os.path.relpath(ATLAS, ROOT), atlas.size)
    print('wrote', os.path.relpath(build_preview(atlas), ROOT))
    emit_resources(atlas)
    for index in (800, 816, 832, 848, 864, 880, 884, 891):
        print(f'  {index:4d}  {names_for(index)}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
