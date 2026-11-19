"""Berrin and the Aethari ward sentinels: dedicated 16x24 overworld sets.

These two had been standing on other characters' art. The scripts give them roles, not
faces, so this is art direction only:

  Berrin         Cinderhollow's headman: old, deliberate, grey-bearded, in a worn green
                 coat and a dark wool cap. No weapon; he never fights.
  ward_sentinel  one of the three Aethari ward constructs at the doors. Same make as the
                 Door Warden, but a paler stone, an amber ward-light and a raised crest,
                 so the three figures read as ward posts rather than as the boss.

Overworld: 16x24, four directions, idle + 4 walk frames.
No battle strips and no portraits: neither has a battle slot or a speaking portrait.

Run from the repo root:  python3 game/sprites/src/story_extra.py
"""

import os
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from party_kit import save_overworld, px, strip
from pix import preview, BG

SPR = os.path.abspath(os.path.join(HERE, '..'))
WARD_SRC = os.path.join(SPR, 'enemies', 'door_warden', 'overworld')
SENTINEL_OUT = os.path.join(SPR, 'enemies', 'ward_sentinel', 'overworld')

# Berrin is deliberately not a recolour of Tomas: the cap changes the head silhouette,
# the beard stays, and the coat is the muted green of the hollow rather than forge brown.
BERRIN = dict(
    skin=(198, 154, 112), skin2=(164, 120, 84),
    hair=(150, 146, 140), hair2=(112, 108, 102),
    coat=(62, 72, 54), coat2=(46, 54, 40),
    trim=(126, 98, 58),
    pants=(58, 52, 44), boot=(38, 32, 26),
    metal=(144, 140, 128), metal2=(184, 180, 168),
    wood=(102, 74, 48), leather=(92, 68, 44),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(20, 20, 18),
    cap=(70, 62, 46), beard=True,
)

# The source is the Door Warden's finished map set. Recolouring alone would leave these
# three reading as the boss, so the crest and the chest ward-mark are drawn on top.
PALETTE_MAP = {
    (18, 22, 26): (12, 14, 20),      # outline
    (142, 138, 128): (154, 166, 168),  # pale limestone
    (58, 56, 52): (54, 66, 72),      # shadow
    (106, 104, 96): (98, 114, 120),  # mid stone
    (90, 86, 78): (76, 90, 96),      # dark stone
    (42, 74, 40): (32, 64, 68),      # moss -> deep teal shadow
    (62, 106, 56): (44, 86, 90),
    (62, 110, 90): (54, 106, 108),
    (42, 74, 66): (36, 68, 74),
    (138, 106, 56): (98, 90, 76),  # old brass -> cool dark metal
    (196, 164, 90): (132, 122, 100),
    (74, 138, 184): (224, 148, 58),  # eye -> ward-amber
    (106, 154, 120): (176, 204, 196),  # old green inlay -> pale mineral
}
OUTLINE = PALETTE_MAP[(18, 22, 26)]
STONE_LIGHT = PALETTE_MAP[(142, 138, 128)]
STONE_MID = PALETTE_MAP[(106, 104, 96)]
WARD = (224, 148, 58)
WARD_HI = (250, 214, 132)


def recolour(im):
    out = im.copy()
    for y in range(im.height):
        for x in range(im.width):
            p = im.getpixel((x, y))
            if p[3]:
                out.putpixel((x, y), PALETTE_MAP.get(p[:3], p[:3]) + (255,))
    return out


def body_top(im):
    """Topmost opaque row, used to keep the crest and ward-mark on a bobbing walk frame."""
    for y in range(im.height):
        if any(im.getpixel((x, y))[3] for x in range(im.width)):
            return y
    return 0


def crest(im, dirn, top):
    """A raised stone fin, so the ward posts are taller than the Door Warden."""
    if dirn == 'left':
        shape = {(8, 0), (9, 0), (7, 1), (8, 1), (9, 1), (10, 1),
                 (7, 2), (8, 2), (9, 2), (10, 2)}
    elif dirn == 'right':
        shape = {(15 - x, y) for x, y in
                 {(8, 0), (9, 0), (7, 1), (8, 1), (9, 1), (10, 1),
                  (7, 2), (8, 2), (9, 2), (10, 2)}}
    else:
        shape = {(7, 0), (8, 0), (6, 1), (7, 1), (8, 1), (9, 1),
                 (6, 2), (7, 2), (8, 2), (9, 2)}
    base = max(0, top - 3)
    for x, y in shape:
        px(im, x, base + y, STONE_MID if y == 2 else STONE_LIGHT)
    # outline the fin without touching the head beneath it
    for x, y in shape:
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            gy = base + ny
            if 0 <= nx < im.width and 0 <= gy < im.height and im.getpixel((nx, gy))[3] == 0:
                px(im, nx, gy, OUTLINE)
    return im


def ward_mark(im, dirn, top):
    """A small amber diamond on the chest (or the back, for the up-facing frame)."""
    if dirn == 'left':
        marks = [(8, 10, WARD), (7, 11, WARD_HI), (8, 11, WARD), (9, 11, WARD), (8, 12, WARD)]
    elif dirn == 'right':
        marks = [(15 - x, y, c) for x, y, c in
                 [(8, 10, WARD), (7, 11, WARD_HI), (8, 11, WARD), (9, 11, WARD), (8, 12, WARD)]]
    elif dirn == 'up':
        marks = [(8, 10, WARD), (7, 11, WARD), (8, 11, WARD_HI), (9, 11, WARD), (8, 12, WARD)]
    else:
        marks = [(8, 10, WARD), (7, 11, WARD), (8, 11, WARD_HI), (9, 11, WARD), (8, 12, WARD)]
    dy = max(0, top - 3)
    for x, y, c in marks:
        px(im, x, y + dy, c)
    return im


def make_sentinel_sprite(src, dirn):
    return make_sentinel_sprite_from_image(Image.open(src).convert('RGBA'), dirn)


def build_berrin():
    print('berrin overworld ->', save_overworld(BERRIN, 'berrin', weapon='none'))
    d = os.path.join(SPR, 'npcs', 'berrin')
    rows = []
    for dirn in ('down', 'up', 'right', 'left'):
        idle = Image.open(f'{d}/spr_berrin_ow16_idle_{dirn}.png').convert('RGBA')
        walk = Image.open(f'{d}/spr_berrin_ow16_walk_{dirn}_strip4.png').convert('RGBA')
        row = Image.new('RGBA', (idle.width + 16 + walk.width, 24), (0, 0, 0, 0))
        row.paste(idle, (0, 0))
        row.paste(walk, (idle.width + 16, 0))
        rows.append((f'spr_berrin_ow16_idle_{dirn}.png  +  spr_berrin_ow16_walk_{dirn}_strip4.png',
                     row, 16))
    preview(rows, f'{d}/spr_berrin_ow16_preview.png',
            'BERRIN overworld 16x24 (idle | walk x4), origin (8,23)', scale=8, fw=16)


def build_sentinels():
    os.makedirs(SENTINEL_OUT, exist_ok=True)
    rows = []
    for dirn in ('down', 'up', 'right', 'left'):
        idle = make_sentinel_sprite(f'{WARD_SRC}/spr_door_warden_ow16_idle_{dirn}.png', dirn)
        idle.save(f'{SENTINEL_OUT}/spr_ward_sentinel_ow16_idle_{dirn}.png')
        src = Image.open(f'{WARD_SRC}/spr_door_warden_ow16_walk_{dirn}_strip4.png').convert('RGBA')
        frames = []
        for i in range(4):
            cell = src.crop((i * 16, 0, i * 16 + 16, 24))
            frames.append(make_sentinel_sprite_from_image(cell, dirn))
        strip(frames).save(f'{SENTINEL_OUT}/spr_ward_sentinel_ow16_walk_{dirn}_strip4.png')
        walk = Image.open(f'{SENTINEL_OUT}/spr_ward_sentinel_ow16_walk_{dirn}_strip4.png').convert('RGBA')
        row = Image.new('RGBA', (idle.width + 16 + walk.width, 24), (0, 0, 0, 0))
        row.paste(idle, (0, 0))
        row.paste(walk, (idle.width + 16, 0))
        rows.append((f'spr_ward_sentinel_ow16_idle_{dirn}.png  +  ..._walk_{dirn}_strip4.png',
                     row, 16))
    preview(rows, f'{SENTINEL_OUT}/spr_ward_sentinel_ow16_preview.png',
            'WARD SENTINEL overworld 16x24 (idle | walk x4), origin (8,23)', scale=8, fw=16)
    print('ward sentinel overworld ->', SENTINEL_OUT)


def make_sentinel_sprite_from_image(im, dirn):
    im = recolour(im)
    top = body_top(im)
    im = crest(im, dirn, top)
    im = ward_mark(im, dirn, top)
    return im


def contact_sheet():
    """One sheet with the actual new sets, for review without claiming an engine render."""
    cells = []
    for stem, folder in (('berrin', os.path.join(SPR, 'npcs', 'berrin')),
                         ('ward_sentinel', SENTINEL_OUT)):
        for dirn in ('down', 'up', 'right', 'left'):
            idle = Image.open(f'{folder}/spr_{stem}_ow16_idle_{dirn}.png').convert('RGBA')
            walk = Image.open(f'{folder}/spr_{stem}_ow16_walk_{dirn}_strip4.png').convert('RGBA')
            cells.append((stem, dirn, idle, walk))

    scale = 6
    cw, ch = 16 * scale, 24 * scale
    pad = 12
    label_h = 16
    width = pad + 2 * (cw * 5 + pad) + pad
    height = pad + 4 * (ch + label_h + pad)
    sheet = Image.new('RGBA', (width, height), BG)
    from PIL import ImageDraw
    draw = ImageDraw.Draw(sheet)
    for i, (stem, dirn, idle, walk) in enumerate(cells):
        gx, gy = i % 2, i // 2
        x0 = pad + gx * (cw * 5 + pad)
        y0 = pad + gy * (ch + label_h + pad)
        draw.text((x0, y0), f'{stem}  {dirn}', fill=(220, 214, 196))
        frame = Image.new('RGBA', (16 * 5, 24), (0, 0, 0, 0))
        frame.alpha_composite(idle, (0, 0))
        for k in range(4):
            frame.alpha_composite(walk.crop((k * 16, 0, k * 16 + 16, 24)), (16 + k * 16, 0))
        sheet.alpha_composite(frame.resize((frame.width * scale, frame.height * scale),
                                           Image.NEAREST), (x0, y0 + label_h))
    out = os.path.join(SPR, '..', '..', 'artifacts', 'berrin_sentinels_dedicated.png')
    sheet.convert('RGB').save(os.path.abspath(out))
    print('contact sheet ->', os.path.abspath(out))


if __name__ == '__main__':
    build_berrin()
    build_sentinels()
    contact_sheet()
