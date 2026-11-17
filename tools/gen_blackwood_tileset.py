#!/usr/bin/env python3
"""Build the placeholder Blackwood tileset and its GameMaker resources.

The Blackwood had no tileset of its own: the Chapter 6 rooms were blockouts on
`ts_wrenfield`, so the cursed wood read as a Wrenfield street. This generator makes
`ts_blackwood` a real placeholder atlas:

  game/tilesets/ts_blackwood.png             256 x 1040, 16 columns x 65 rows
  game/tilesets/ts_blackwood_preview_4x.png  labelled 4x preview (not imported)

Rows 0-49 are copied verbatim from `ts_zone1.png`, so every existing Zone 1 / Wrenfield
tile id (0-799) means the same tile in all three atlases and nothing has to be remapped.
Rows 50-64 (ids 800-1039) are the Blackwood's own dark placeholder material:

  800-815   bwmoss_*       understory floor, eight usable shades
  816-831   bwearth_*      packed black road
  832-847   bwchar_*       charcoal / burn-line ground
  848-863   bwbog_*        standing bog water
  864-879   bwthorn_*      thorn wall (blocking)
  880-895   bwtop_*        dead canopy tops, transparent (Overhead layer)
  896-911   props          bramble, bones, ash, embers, spores, web, kiln, vine,
                           thorn post, brazier, fallen stone, carved stone, rune, pool
  912-927   props 2        roots, standing stone, stump, charred beam, skull, moths,
                           thorn snag, smoking kiln, rack, rest, stone, log, fungus
  928-943   bwtrunk_*      dead trunk columns (Decor layer)
  944-959   bwbranch_*     trunk tops and branches, transparent (Overhead layer)
  960-975   bwhut_*        charred hut planks
  976-991   bwcrown_cap_*  dark stone wall caps
  992-1007  bwcrown_face_* dark stone wall faces (one carries the black-sun crown)
  1008-1023 bwroot_arch_*  root arches and hanging thorns
  1024-1039 bwmist_* / spare

It also writes the GameMaker side, idempotently: sprite `spr_ts_blackwood` (one image,
256x1040), tileset `ts_blackwood` (16x16, no offset or spacing, 1040 tiles), and both
registered in `AshenCrown.yyp` and `AshenCrown.resource_order`. Resource GUIDs are
derived from the resource name (uuid5), so re-running never churns the project.

    python3 tools/gen_blackwood_tileset.py
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
ATLAS = os.path.join(SRC, 'ts_blackwood.png')
PREVIEW = os.path.join(SRC, 'ts_blackwood_preview_4x.png')

COLS, TILE, ROWS = 16, 16, 65
WIDTH, HEIGHT = COLS * TILE, ROWS * TILE

MOSS = [800 + i for i in range(16)]
EARTH = [816 + i for i in range(16)]
CHAR = [832 + i for i in range(16)]
BOG = [848 + i for i in range(16)]
THORN = [864 + i for i in range(16)]
TOP = [880 + i for i in range(16)]

PROPS_A = ['bwbramble_0', 'bwbramble_1', 'bwbramble_2', 'bwbones', 'bwash_pile',
           'bwember_glow', 'bwspores', 'bwweb', 'bwkiln', 'bwvine', 'bwthorn_post',
           'bwbrazier', 'bwfallen_stone', 'bwcarved_stone', 'bwrune_stone', 'bwpool']
PROPS_B = ['bwroot_0', 'bwstanding_stone', 'bwstump', 'bwchar_beam', 'bwskull',
           'bwmoths', 'bwthorn_snag', 'bwkiln_smoke', 'bwrack', 'bwrest', 'bwstone',
           'bwlog', 'bwfungus', 'bwweb_low', 'bwhut_wall', 'bwhut_corner']


def names_for(index):
    """Name for tile id `index` (used by the preview and the printed table)."""
    if index < 800:
        return ''
    row, col = index // 16, index % 16
    if row == 50:
        return f'bwmoss_{col}'
    if row == 51:
        return f'bwearth_{col}'
    if row == 52:
        return f'bwchar_{col}'
    if row == 53:
        return f'bwbog_{col}'
    if row == 54:
        return f'bwthorn_{col}'
    if row == 55:
        return f'bwtop_{col}'
    if row == 56:
        return PROPS_A[col]
    if row == 57:
        return PROPS_B[col]
    if row == 58:
        return f'bwtrunk_{col}'
    if row == 59:
        return f'bwbranch_{col}'
    if row == 60:
        return f'bwhut_{col}'
    if row == 61:
        return f'bwcrown_cap_{col}'
    if row == 62:
        return f'bwcrown_face_{col}'
    if row == 63:
        return f'bwroot_arch_{col}'
    return f'bwspare_{col}'


# --------------------------------------------------------------------------- drawing
def box(index):
    return ((index % COLS) * TILE, (index // COLS) * TILE)


def origin(index):
    return box(index)


def shade(rgb, rng, amount=8, alpha=255):
    return (max(0, min(255, rgb[0] + rng.randint(-amount, amount))),
            max(0, min(255, rgb[1] + rng.randint(-amount, amount))),
            max(0, min(255, rgb[2] + rng.randint(-amount, amount))), alpha)


def fill_tile(draw, index, rgb, rng, speckle=0.10, speck_rgb=None, speck_amount=12):
    """Solid base with per-pixel grain, so flat colours still read as ground."""
    ox, oy = origin(index)
    base = rgb
    draw.rectangle([ox, oy, ox + TILE - 1, oy + TILE - 1], fill=base + (255,))
    for y in range(TILE):
        for x in range(TILE):
            if rng.random() < speckle:
                c = speck_rgb or (base[0], base[1], base[2])
                draw.point((ox + x, oy + y), fill=shade(c, rng, speck_amount))


def draw_moss(draw, index, col):
    rng = random.Random(5000 + index)
    base = (17 + (col % 4) * 2, 25 + (col % 5), 18 + (col % 3) * 2)
    fill_tile(draw, index, base, rng, speckle=0.16, speck_rgb=(28, 40, 26), speck_amount=10)
    ox, oy = origin(index)
    for _ in range(5):  # fallen twigs / leaves
        x, y = rng.randrange(1, 14), rng.randrange(1, 14)
        if rng.random() < 0.5:
            draw.line([ox + x, oy + y, ox + x + rng.randint(2, 5), oy + y + rng.randint(-1, 1)],
                      fill=(38, 30, 22, 255))
        else:
            draw.point((ox + x, oy + y), fill=(52, 34, 26, 255))
    if col % 4 == 0:
        draw.line([ox + 2, oy + 12, ox + 6, oy + 10, ox + 9, oy + 12], fill=(38, 52, 36, 255))


def draw_earth(draw, index, col):
    rng = random.Random(5200 + index)
    base = (37 + (col % 4) * 2, 30 + (col % 3), 23 + (col % 2))
    fill_tile(draw, index, base, rng, speckle=0.12, speck_rgb=(52, 43, 33), speck_amount=9)
    ox, oy = origin(index)
    for _ in range(3):  # pebbles and root cracks
        x, y = rng.randrange(1, 14), rng.randrange(1, 14)
        draw.rectangle([ox + x, oy + y, ox + x + 1, oy + y + 1], fill=(24, 20, 16, 255))
    if col % 5 == 0:
        draw.line([ox + 1, oy + 11, ox + 6, oy + 9, ox + 11, oy + 12, ox + 15, oy + 10],
                  fill=(23, 19, 15, 255))


def draw_char(draw, index, col):
    rng = random.Random(5400 + index)
    base = (21 + (col % 3), 20 + (col % 2), 19 + (col % 2))
    fill_tile(draw, index, base, rng, speckle=0.14, speck_rgb=(40, 39, 37), speck_amount=14)
    ox, oy = origin(index)
    if col % 4 == 1:  # a live ember or two
        for _ in range(2):
            x, y = rng.randrange(2, 14), rng.randrange(2, 14)
            draw.point((ox + x, oy + y), fill=(150, 62, 26, 255))
            draw.point((ox + x + 1, oy + y), fill=(96, 40, 20, 255))
    if col % 4 == 2:  # ash drift
        draw.ellipse([ox + 3, oy + 6, ox + 12, oy + 11], fill=(46, 45, 43, 255))


def draw_bog(draw, index, col):
    rng = random.Random(5600 + index)
    base = (16 + (col % 3), 28 + (col % 4), 27 + (col % 3))
    fill_tile(draw, index, base, rng, speckle=0.08, speck_rgb=(24, 38, 37), speck_amount=8)
    ox, oy = origin(index)
    for k in range(2 + col % 3):  # ripple lines
        y = 4 + k * 4 + rng.randint(0, 1)
        draw.line([ox + 2, oy + y, ox + 8, oy + y, ox + 13, oy + y - 1], fill=(30, 46, 44, 255))
    if col % 5 == 0:  # reeds
        for x in (4, 7, 10):
            draw.line([ox + x, oy + 14, ox + x + 1, oy + 6], fill=(34, 42, 30, 255))


def draw_thorn(draw, index, col):
    rng = random.Random(5800 + index)
    base = (11 + (col % 3), 16 + (col % 3), 13 + (col % 2))
    fill_tile(draw, index, base, rng, speckle=0.2, speck_rgb=(18, 24, 18), speck_amount=6)
    ox, oy = origin(index)
    for _ in range(6 + col % 4):  # pale needles
        x, y = rng.randrange(0, 15), rng.randrange(0, 15)
        dx, dy = rng.choice([(2, 1), (2, -1), (1, 2), (1, -2)])
        draw.line([ox + x, oy + y, ox + x + dx, oy + y + dy], fill=(96, 104, 82, 255))
    draw.line([ox + 1, oy + 14, ox + 14, oy + 2], fill=(20, 28, 20, 255))


def draw_top(draw, index, col):
    """Transparent dead canopy: a dense leaf mass with holes, so the player shows through."""
    rng = random.Random(6000 + index)
    ox, oy = origin(index)
    for gy in range(-1, 15, 3):
        for gx in range(-1, 15, 3):
            if rng.random() < 0.24:  # gaps between the leaves
                continue
            x = gx + rng.randint(-1, 1)
            y = gy + rng.randint(-1, 1)
            w, h = rng.randint(4, 7), rng.randint(4, 6)
            draw.ellipse([ox + x, oy + y, ox + x + w, oy + y + h], fill=shade((15, 23, 16), rng, 9))
    for _ in range(2):  # hanging dead twigs
        x = rng.randrange(2, 14)
        draw.line([ox + x, oy + 11, ox + x + rng.randint(-1, 1), oy + 15], fill=(28, 24, 18, 255))


def draw_bramble(draw, index, variant):
    ox, oy = origin(index)
    rng = random.Random(7000 + index)
    for _ in range(5 + variant):
        x0, y0 = rng.randrange(2, 14), 14
        x1, y1 = rng.randrange(1, 15), rng.randrange(3, 10)
        draw.line([ox + x0, oy + y0, ox + x1, oy + y1], fill=(22, 30, 22, 255))
        draw.point((ox + x1, oy + y1), fill=(84, 92, 70, 255))
    for _ in range(3):
        x, y = rng.randrange(2, 14), rng.randrange(4, 13)
        draw.point((ox + x, oy + y), fill=(70, 78, 58, 255))


def draw_bones(draw, index):
    ox, oy = origin(index)
    draw.line([ox + 3, oy + 11, ox + 9, oy + 8], fill=(182, 176, 152, 255), width=2)
    draw.line([ox + 9, oy + 8, ox + 13, oy + 11], fill=(182, 176, 152, 255), width=2)
    draw.ellipse([ox + 2, oy + 3, ox + 6, oy + 6], fill=(196, 190, 168, 255))
    draw.point((ox + 3, oy + 4), fill=(30, 26, 22, 255))


def draw_ash(draw, index, smoking=False):
    ox, oy = origin(index)
    draw.ellipse([ox + 2, oy + 8, ox + 13, oy + 13], fill=(92, 88, 82, 255))
    draw.ellipse([ox + 4, oy + 9, ox + 11, oy + 12], fill=(64, 62, 58, 255))
    if smoking:
        for y in (6, 4, 2):
            draw.line([ox + 8, oy + y, ox + 9, oy + y - 1], fill=(48, 48, 46, 255))


def draw_embers(draw, index):
    ox, oy = origin(index)
    for (x, y) in ((5, 10), (9, 8), (7, 12), (11, 11)):
        draw.point((ox + x, oy + y), fill=(210, 104, 42, 255))
        draw.point((ox + x + 1, oy + y), fill=(126, 52, 22, 255))
    draw.ellipse([ox + 4, oy + 8, ox + 12, oy + 13], fill=(38, 26, 20, 255))


def draw_spores(draw, index):
    ox, oy = origin(index)
    rng = random.Random(7300 + index)
    for _ in range(9):
        x, y = rng.randrange(2, 14), rng.randrange(2, 14)
        draw.point((ox + x, oy + y), fill=(120, 132, 96, 255))


def draw_web(draw, index):
    ox, oy = origin(index)
    for k in range(4):
        draw.line([ox + 2, oy + 2 + k * 4, ox + 13, oy + 2 + k * 4], fill=(150, 152, 142, 255))
    draw.line([ox + 2, oy + 2, ox + 14, oy + 13], fill=(150, 152, 142, 255))
    draw.line([ox + 14, oy + 2, ox + 2, oy + 13], fill=(150, 152, 142, 255))


def draw_kiln(draw, index, smoking=False):
    ox, oy = origin(index)
    draw.ellipse([ox + 2, oy + 5, ox + 13, oy + 14], fill=(54, 44, 34, 255))
    draw.ellipse([ox + 4, oy + 7, ox + 11, oy + 12], fill=(34, 26, 20, 255))
    draw.point((ox + 7, oy + 10), fill=(198, 92, 38, 255))
    draw.point((ox + 9, oy + 9), fill=(152, 66, 28, 255))
    if smoking:
        for y in (4, 2):
            draw.line([ox + 8, oy + y, ox + 9, oy + y - 1], fill=(44, 44, 42, 255))


def draw_vine(draw, index):
    ox, oy = origin(index)
    rng = random.Random(7500 + index)
    x = 8
    for y in range(0, 16, 2):
        draw.line([ox + x, oy + y, ox + x + rng.randint(-2, 2), oy + y + 1], fill=(30, 38, 26, 255))
        x += rng.randint(-1, 1)


def draw_post(draw, index):
    ox, oy = origin(index)
    draw.rectangle([ox + 7, oy + 4, ox + 9, oy + 14], fill=(32, 26, 20, 255))
    for y in (5, 9, 12):
        draw.line([ox + 3, oy + y, ox + 6, oy + y - 1], fill=(84, 92, 70, 255))
        draw.line([ox + 10, oy + y, ox + 13, oy + y - 1], fill=(84, 92, 70, 255))


def draw_brazier(draw, index):
    ox, oy = origin(index)
    draw.rectangle([ox + 5, oy + 9, ox + 10, oy + 14], fill=(46, 44, 40, 255))
    draw.ellipse([ox + 3, oy + 5, ox + 12, oy + 10], fill=(38, 36, 32, 255))
    draw.ellipse([ox + 5, oy + 3, ox + 10, oy + 8], fill=(176, 76, 32, 255))
    draw.ellipse([ox + 6, oy + 4, ox + 9, oy + 7], fill=(224, 148, 62, 255))


def draw_stone(draw, index, carved=False, rune=False):
    ox, oy = origin(index)
    draw.polygon([(ox + 3, oy + 14), (ox + 4, oy + 5), (ox + 8, oy + 2),
                  (ox + 13, oy + 5), (ox + 13, oy + 14)], fill=(56, 58, 54, 255))
    draw.polygon([(ox + 5, oy + 13), (ox + 6, oy + 6), (ox + 8, oy + 4), (ox + 11, oy + 6)],
                 fill=(44, 46, 42, 255))
    if carved:  # the black sun under a shallow crown
        draw.arc([ox + 5, oy + 6, ox + 11, oy + 12], 0, 360, fill=(28, 28, 26, 255))
        draw.ellipse([ox + 6, oy + 7, ox + 10, oy + 11], fill=(20, 20, 18, 255))
        for x in (5, 8, 11):
            draw.point((ox + x, oy + 5), fill=(28, 28, 26, 255))
    if rune:
        draw.line([ox + 6, oy + 6, ox + 10, oy + 10], fill=(120, 132, 96, 255))
        draw.line([ox + 10, oy + 6, ox + 6, oy + 10], fill=(120, 132, 96, 255))


def draw_pool(draw, index):
    ox, oy = origin(index)
    draw.ellipse([ox + 2, oy + 7, ox + 13, oy + 13], fill=(12, 20, 22, 255))
    draw.arc([ox + 3, oy + 8, ox + 12, oy + 12], 0, 180, fill=(24, 40, 42, 255))


def draw_skull(draw, index):
    ox, oy = origin(index)
    draw.ellipse([ox + 4, oy + 5, ox + 11, oy + 12], fill=(190, 186, 166, 255))
    draw.rectangle([ox + 5, oy + 11, ox + 10, oy + 13], fill=(176, 172, 152, 255))
    draw.point((ox + 6, oy + 8), fill=(28, 24, 20, 255))
    draw.point((ox + 9, oy + 8), fill=(28, 24, 20, 255))


def draw_moths(draw, index):
    ox, oy = origin(index)
    rng = random.Random(7900 + index)
    for _ in range(7):
        x, y = rng.randrange(2, 13), rng.randrange(2, 13)
        draw.point((ox + x, oy + y), fill=(150, 138, 108, 255))
        draw.point((ox + x + 1, oy + y), fill=(110, 100, 78, 255))


def draw_trunk(draw, index, col):
    rng = random.Random(8000 + index)
    ox, oy = origin(index)
    width = 5 + col % 3
    x0 = 8 - width // 2
    draw.rectangle([ox + x0, oy, ox + x0 + width, oy + 15], fill=(38, 32, 27, 255))
    for y in range(0, 16, 2):
        draw.line([ox + x0 + rng.randint(0, width - 1), oy + y,
                   ox + x0 + rng.randint(0, width - 1), oy + y + 1], fill=(26, 22, 18, 255))
    if col % 4 == 0:  # broken branch stub
        draw.line([ox + x0 + width, oy + 5, ox + 15, oy + 3], fill=(32, 27, 22, 255))


def draw_branch(draw, index, col):
    rng = random.Random(8200 + index)
    ox, oy = origin(index)
    draw.rectangle([ox + 6, oy + 8, ox + 10, oy + 15], fill=(38, 32, 27, 255))
    for _ in range(3):
        x1 = rng.choice([1, 3, 12, 14])
        y1 = rng.randrange(1, 8)
        draw.line([ox + 8, oy + 9, ox + x1, oy + y1], fill=(34, 29, 24, 255))
    for _ in range(6):
        x, y = rng.randrange(1, 15), rng.randrange(0, 9)
        draw.ellipse([ox + x, oy + y, ox + x + 2, oy + y + 2], fill=shade((16, 24, 17), rng, 8))


def draw_hut(draw, index, col):
    ox, oy = origin(index)
    plank = (34, 29, 24, 255) if col % 2 else (28, 24, 20, 255)
    draw.rectangle([ox, oy, ox + 15, oy + 15], fill=plank)
    for y in range(1, 16, 3):
        draw.line([ox, oy + y, ox + 15, oy + y], fill=(20, 17, 14, 255))
    if col % 4 == 3:  # charred through
        draw.polygon([(ox + 4, oy + 4), (ox + 11, oy + 3), (ox + 12, oy + 10), (ox + 5, oy + 11)],
                     fill=(14, 13, 12, 255))


def draw_cap(draw, index, col):
    ox, oy = origin(index)
    base = (30, 32, 29, 255) if col % 2 else (38, 40, 36, 255)
    draw.rectangle([ox, oy + 3, ox + 15, oy + 15], fill=base)
    draw.line([ox, oy + 3, ox + 15, oy + 3], fill=(52, 54, 50, 255))
    rng = random.Random(8500 + index)
    for _ in range(6):
        x, y = rng.randrange(0, 15), rng.randrange(4, 15)
        draw.point((ox + x, oy + y), fill=(22, 24, 21, 255))


def draw_face(draw, index, col):
    ox, oy = origin(index)
    draw.rectangle([ox, oy, ox + 15, oy + 15], fill=(34, 36, 32, 255))
    for y in range(0, 16, 5):
        draw.line([ox, oy + y, ox + 15, oy + y], fill=(25, 27, 24, 255))
    draw.line([ox + 3, oy, ox + 3, oy + 15], fill=(25, 27, 24, 255))
    if col % 8 == 0:  # the black-sun crown, cut once and worn
        draw.ellipse([ox + 5, oy + 5, ox + 11, oy + 11], fill=(18, 18, 16, 255))
        for x in (5, 8, 11):
            draw.line([ox + x, oy + 4, ox + x, oy + 2], fill=(18, 18, 16, 255))


def draw_arch(draw, index, col):
    ox, oy = origin(index)
    rng = random.Random(8700 + index)
    draw.arc([ox - 4, oy + 2, ox + 19, oy + 22], 200, 340, fill=(34, 37, 28, 255), width=2)
    for _ in range(5):
        x = rng.randrange(0, 15)
        draw.line([ox + x, oy + 4, ox + x + rng.randint(-3, 3), oy + 15],
                  fill=(28, 32, 24, 255))
    for _ in range(4):
        x, y = rng.randrange(0, 15), rng.randrange(4, 14)
        draw.point((ox + x, oy + y), fill=(84, 92, 70, 255))


def draw_mist(draw, index, col):
    ox, oy = origin(index)
    rng = random.Random(8900 + index)
    for _ in range(3):
        y = rng.randrange(4, 13)
        draw.line([ox + 1, oy + y, ox + 14, oy + y], fill=(46, 52, 50, 96))


def build_atlas():
    atlas = Image.new('RGBA', (WIDTH, HEIGHT), (0, 0, 0, 0))
    zone1 = Image.open(os.path.join(SRC, 'ts_zone1.png')).convert('RGBA')
    assert zone1.size == (WIDTH, 800), f'ts_zone1.png is {zone1.size}, expected {(WIDTH, 800)}'
    atlas.paste(zone1, (0, 0))

    draw = ImageDraw.Draw(atlas)
    for i, index in enumerate(MOSS):
        draw_moss(draw, index, i)
    for i, index in enumerate(EARTH):
        draw_earth(draw, index, i)
    for i, index in enumerate(CHAR):
        draw_char(draw, index, i)
    for i, index in enumerate(BOG):
        draw_bog(draw, index, i)
    for i, index in enumerate(THORN):
        draw_thorn(draw, index, i)
    for i, index in enumerate(TOP):
        draw_top(draw, index, i)

    # props A (896-911)
    for variant in range(3):
        draw_bramble(draw, 896 + variant, variant)
    draw_bones(draw, 899)
    draw_ash(draw, 900)
    draw_embers(draw, 901)
    draw_spores(draw, 902)
    draw_web(draw, 903)
    draw_kiln(draw, 904)
    draw_vine(draw, 905)
    draw_post(draw, 906)
    draw_brazier(draw, 907)
    draw_stone(draw, 908)
    draw_stone(draw, 909, carved=True)
    draw_stone(draw, 910, rune=True)
    draw_pool(draw, 911)

    # props B (912-927)
    draw_bramble(draw, 912, 4)
    draw_stone(draw, 913)
    draw_trunk(draw, 914, 3)   # cut stump
    draw_hut(draw, 915, 3)     # charred beam
    draw_skull(draw, 916)
    draw_moths(draw, 917)
    draw_post(draw, 918)
    draw_kiln(draw, 919, smoking=True)
    draw_hut(draw, 920, 1)     # rack / lean-to plank
    draw_ash(draw, 921, smoking=True)
    draw_stone(draw, 922, rune=True)
    draw_trunk(draw, 923, 5)   # fallen log
    draw_spores(draw, 924)
    draw_web(draw, 925)
    draw_hut(draw, 926, 2)
    draw_hut(draw, 927, 3)

    for i, index in enumerate(range(928, 944)):
        draw_trunk(draw, index, i)
    for i, index in enumerate(range(944, 960)):
        draw_branch(draw, index, i)
    for i, index in enumerate(range(960, 976)):
        draw_hut(draw, index, i)
    for i, index in enumerate(range(976, 992)):
        draw_cap(draw, index, i)
    for i, index in enumerate(range(992, 1008)):
        draw_face(draw, index, i)
    for i, index in enumerate(range(1008, 1024)):
        draw_arch(draw, index, i)
    for i, index in enumerate(range(1024, 1040)):
        if i < 8:
            draw_mist(draw, index, i)

    atlas.save(ATLAS)
    return atlas


def build_preview(atlas, scale=4):
    rows = range(50, ROWS)
    label_h = 14 * scale
    cell = TILE * scale
    preview = Image.new('RGBA', (COLS * cell, len(rows) * (cell + label_h)), (14, 14, 16, 255))
    draw = ImageDraw.Draw(preview)
    for r_i, row in enumerate(rows):
        for col in range(COLS):
            index = row * COLS + col
            src = atlas.crop((col * TILE, row * TILE, col * TILE + TILE, row * TILE + TILE))
            big = src.resize((cell, cell), Image.NEAREST)
            x, y = col * cell, r_i * (cell + label_h)
            # checkerboard behind transparent tiles, so holes read as holes
            for cy in range(0, cell, 8):
                for cx in range(0, cell, 8):
                    if (cx // 8 + cy // 8) % 2 == 0:
                        draw.rectangle([x + cx, y + cy, x + cx + 7, y + cy + 7], fill=(26, 26, 30, 255))
            preview.alpha_composite(big, (x, y))
            draw.text((x + 2, y + cell + 1), f'{index} {names_for(index)}',
                      fill=(210, 210, 200, 255))
    preview.save(PREVIEW)
    return PREVIEW


# --------------------------------------------------------------------------- GameMaker
def uid(*parts):
    return str(uuid.uuid5(uuid.NAMESPACE_URL, 'ashen-crown/' + '/'.join(parts)))


def write_json(path, obj):
    with open(path, 'w', newline='\n') as f:
        json.dump(obj, f, indent=2)
        f.write('\n')


def emit_resources(atlas):
    frame = uid('spr_ts_blackwood', 'frame')
    layer = uid('spr_ts_blackwood', 'layer')
    keyframe = uid('spr_ts_blackwood', 'keyframe')

    spr_dir = os.path.join(GM, 'sprites', 'spr_ts_blackwood')
    os.makedirs(os.path.join(spr_dir, 'layers', frame), exist_ok=True)
    atlas.save(os.path.join(spr_dir, frame + '.png'))
    atlas.save(os.path.join(spr_dir, 'layers', frame, layer + '.png'))

    write_json(os.path.join(spr_dir, 'spr_ts_blackwood.yy'), {
        "$GMSprite": "", "%Name": "spr_ts_blackwood",
        "bboxMode": 1, "bbox_bottom": HEIGHT - 1, "bbox_left": 0,
        "bbox_right": WIDTH - 1, "bbox_top": 0,
        "collisionKind": 1, "collisionTolerance": 0,
        "DynamicTexturePage": False, "edgeFiltering": False, "For3D": False,
        "frames": [{
            "$GMSpriteFrame": "", "%Name": frame, "name": frame,
            "resourceType": "GMSpriteFrame", "resourceVersion": "2.0",
        }],
        "gridX": 0, "gridY": 0, "height": HEIGHT, "HTile": False,
        "layers": [{
            "$GMImageLayer": "", "%Name": layer, "blendMode": 0,
            "displayName": "default", "isLocked": False, "name": layer,
            "opacity": 100.0, "resourceType": "GMImageLayer",
            "resourceVersion": "2.0", "visible": True,
        }],
        "name": "spr_ts_blackwood", "nineSlice": None, "origin": 0,
        "parent": {"name": "sprites", "path": "folders/sprites.yy"},
        "preMultiplyAlpha": False, "resourceType": "GMSprite",
        "resourceVersion": "2.0",
        "sequence": {
            "$GMSequence": "", "%Name": "spr_ts_blackwood",
            "autoRecord": True, "backdropHeight": 1080, "backdropImageOpacity": 0.5,
            "backdropImagePath": "", "backdropWidth": 1920,
            "backdropXOffset": 0.0, "backdropYOffset": 0.0,
            "eventStubScript": None, "eventToFunction": {},
            "events": {"$KeyframeStore<MessageEventKeyframe>": "", "Keyframes": [],
                       "resourceType": "KeyframeStore<MessageEventKeyframe>",
                       "resourceVersion": "2.0"},
            "length": 1.0, "lockOrigin": False,
            "moments": {"$KeyframeStore<MomentsEventKeyframe>": "", "Keyframes": [],
                        "resourceType": "KeyframeStore<MomentsEventKeyframe>",
                        "resourceVersion": "2.0"},
            "name": "spr_ts_blackwood", "playback": 1, "playbackSpeed": 0.0,
            "playbackSpeedType": 0, "resourceType": "GMSequence",
            "resourceVersion": "2.0", "showBackdrop": True,
            "showBackdropImage": False, "timeUnits": 1, "visibleRange": None,
            "volume": 1.0, "xorigin": 0, "yorigin": 0,
            "tracks": [{
                "$GMSpriteFramesTrack": "", "builtinName": 0, "events": [],
                "inheritsTrackColour": True, "interpolation": 1,
                "isCreationTrack": False,
                "keyframes": {
                    "$KeyframeStore<SpriteFrameKeyframe>": "",
                    "Keyframes": [{
                        "$Keyframe<SpriteFrameKeyframe>": "",
                        "Channels": {"0": {
                            "$SpriteFrameKeyframe": "",
                            "Id": {"name": frame,
                                   "path": "sprites/spr_ts_blackwood/spr_ts_blackwood.yy"},
                            "resourceType": "SpriteFrameKeyframe",
                            "resourceVersion": "2.0",
                        }},
                        "Disabled": False, "id": keyframe, "IsCreationKey": False,
                        "Key": 0.0, "Length": 1.0,
                        "resourceType": "Keyframe<SpriteFrameKeyframe>",
                        "resourceVersion": "2.0", "Stretch": False,
                    }],
                    "resourceType": "KeyframeStore<SpriteFrameKeyframe>",
                    "resourceVersion": "2.0",
                },
                "modifiers": [], "name": "frames",
                "resourceType": "GMSpriteFramesTrack", "resourceVersion": "2.0",
                "spriteId": None, "trackColour": 0, "tracks": [], "traits": 0,
            }],
        },
        "swatchColours": None, "swfPrecision": 2.525,
        "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
        "type": 0, "VTile": False, "width": WIDTH,
    })
    print('wrote', os.path.relpath(os.path.join(spr_dir, 'spr_ts_blackwood.yy'), ROOT))

    ts_dir = os.path.join(GM, 'tilesets', 'ts_blackwood')
    os.makedirs(ts_dir, exist_ok=True)
    write_json(os.path.join(ts_dir, 'ts_blackwood.yy'), {
        "$GMTileSet": "v1", "%Name": "ts_blackwood", "autoTileSets": [],
        "macroPageTiles": {"SerialiseHeight": 0, "SerialiseWidth": 0, "TileSerialiseData": []},
        "name": "ts_blackwood", "out_columns": COLS, "out_tilehborder": 2,
        "out_tilevborder": 2,
        "parent": {"name": "tilesets", "path": "folders/tilesets.yy"},
        "resourceType": "GMTileSet", "resourceVersion": "2.0",
        "spriteId": {"name": "spr_ts_blackwood",
                     "path": "sprites/spr_ts_blackwood/spr_ts_blackwood.yy"},
        "spriteNoExport": True,
        "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
        "tileAnimationFrames": [], "tileAnimationSpeed": 15.0,
        "tileHeight": 16, "tilehsep": 0, "tilevsep": 0, "tileWidth": 16,
        "tilexoff": 0, "tileyoff": 0, "tile_count": COLS * ROWS,
    })
    print('wrote', os.path.relpath(os.path.join(ts_dir, 'ts_blackwood.yy'), ROOT))

    # Register in the project (idempotent, text insertion keeps the existing formatting).
    yyp_path = os.path.join(GM, 'AshenCrown.yyp')
    yyp = open(yyp_path, encoding='utf-8').read()
    spr_anchor = ('    {\n      "id":{\n        "name":"spr_ts_wrenfield",\n'
                  '        "path":"sprites/spr_ts_wrenfield/spr_ts_wrenfield.yy",\n      },\n    },\n')
    ts_anchor = ('    {\n      "id":{\n        "name":"ts_wrenfield",\n'
                 '        "path":"tilesets/ts_wrenfield/ts_wrenfield.yy",\n      },\n    },\n')
    if '"name":"spr_ts_blackwood"' not in yyp:
        block = ('    {\n      "id":{\n        "name":"spr_ts_blackwood",\n'
                 '        "path":"sprites/spr_ts_blackwood/spr_ts_blackwood.yy",\n      },\n    },\n')
        assert spr_anchor in yyp, 'spr_ts_wrenfield resource block not found in the yyp'
        yyp = yyp.replace(spr_anchor, spr_anchor + block, 1)
    if '"name":"ts_blackwood"' not in yyp:
        block = ('    {\n      "id":{\n        "name":"ts_blackwood",\n'
                 '        "path":"tilesets/ts_blackwood/ts_blackwood.yy",\n      },\n    },\n')
        assert ts_anchor in yyp, 'ts_wrenfield resource block not found in the yyp'
        yyp = yyp.replace(ts_anchor, ts_anchor + block, 1)
    open(yyp_path, 'w', encoding='utf-8', newline='\n').write(yyp)

    order_path = os.path.join(GM, 'AshenCrown.resource_order')
    order = open(order_path, encoding='utf-8').read()
    existing = set(re.findall(r'"name":"(spr_ts_blackwood|ts_blackwood)"', order))
    entries = [('spr_ts_blackwood', 'sprites/spr_ts_blackwood/spr_ts_blackwood.yy'),
               ('ts_blackwood', 'tilesets/ts_blackwood/ts_blackwood.yy')]
    last_order = max(int(m) for m in (o for o in re.findall(r'"order":(\d+)', order)))
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
    print('registered spr_ts_blackwood and ts_blackwood in the yyp and resource_order')


def main():
    atlas = build_atlas()
    print('wrote', os.path.relpath(ATLAS, ROOT), atlas.size)
    print('wrote', os.path.relpath(build_preview(atlas), ROOT))
    emit_resources(atlas)
    print('ts_blackwood tile ids:')
    for index in (800, 816, 832, 848, 864, 880, 896, 904, 907, 909, 913, 928, 929, 944):
        print(f'  {index:4d}  {names_for(index)}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
