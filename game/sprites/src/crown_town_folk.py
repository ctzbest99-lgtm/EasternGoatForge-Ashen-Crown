"""Coleford's magistrate and his clerk: dedicated 16x24 overworld sets.

The Chapter 9 script gives them roles, not faces, so this is art direction only. Nothing
here adds lore or settles anything the script leaves open:

  vell   Magistrate Vell: mid-forties, ink on his cuffs, a Crown indigo coat, a brass
         seal on a short chain, and the heavy ledger he carries instead of a weapon
         (VG_FIGHT calls his kit a clerk's: a heavy ledger and a guard stance).
  nessa  Vell's clerk, Perrin's cousin from Cinderhollow: hair tied back, a pale linen
         apron over a dark working dress, ink-stained fingers, and the folded page she
         wants an hour with tucked at her waist.

Overworld: 16x24, four directions, idle + 4 walk frames -> game/sprites/npcs/<stem>/
No battle strips and no portraits: Vell yields in one scripted boss fight and neither
has a portrait slot. Their appearance is art direction, not story canon.

Run from the repo root:  python3 game/sprites/src/crown_town_folk.py
"""

import os
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from party_kit import ow_figure, px, strip
from pix import preview, BG

SPR = os.path.abspath(os.path.join(HERE, '..'))
OUT = {
    'vell': os.path.join(SPR, 'npcs', 'vell'),
    'nessa': os.path.join(SPR, 'npcs', 'nessa'),
}

VELL = dict(
    skin=(214, 170, 132), skin2=(180, 136, 102),
    hair=(78, 68, 60), hair2=(52, 46, 40),
    coat=(48, 56, 80), coat2=(34, 40, 60),      # Crown indigo, the administration's coat
    trim=(172, 140, 80),                        # brass: seal, chain, buttons
    pants=(58, 56, 56), boot=(36, 32, 30),
    metal=(186, 190, 196), metal2=(222, 226, 230),
    wood=(112, 84, 54), leather=(96, 70, 46),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(22, 22, 28),
)

NESSA = dict(
    skin=(222, 180, 146), skin2=(188, 144, 112),
    hair=(112, 74, 46), hair2=(82, 52, 34),
    coat=(66, 74, 68), coat2=(48, 54, 50),      # dark working dress
    trim=(148, 132, 96),
    pants=(64, 62, 58), boot=(40, 36, 32),      # the skirt reads as the lower half
    metal=(176, 178, 172), metal2=(212, 214, 206),
    wood=(116, 88, 58), leather=(104, 78, 52),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(22, 22, 24),
)

GREY = (146, 140, 132)          # Vell's temples
PAGE = (214, 208, 188)          # ledger and copy paper
PAGE2 = (184, 178, 158)
BOOK = (92, 66, 42)             # the ledger's leather cover
BOOK2 = (66, 46, 28)
BRASS = (198, 164, 94)
BRASS2 = (150, 118, 62)
INK = (34, 38, 58)              # ink on the cuffs and fingers
LINEN = (200, 196, 184)         # Nessa's apron
LINEN2 = (168, 164, 150)


def stamp(im, pts, dirn):
    """Plot (x, y, colour) points, mirrored for the right-facing frame."""
    for x, y, c in pts:
        if dirn == 'right':
            x = 15 - x
        px(im, x, y, c)
    return im


# ---------------------------------------------------------------- Vell
def vell_marks(im, dirn):
    """Grey temples, a brass seal on a short chain, and ink at the cuffs."""
    if dirn == 'down':
        stamp(im, [(3, 5, GREY), (12, 5, GREY),                    # temples
                   (5, 11, BRASS), (8, 11, BRASS),                 # chain
                   (6, 13, BRASS), (7, 13, BRASS),                 # seal
                   (6, 14, BRASS2), (7, 14, BRASS2),
                   (2, 15, INK), (13, 15, INK)], dirn)             # inked cuffs
    elif dirn == 'up':
        stamp(im, [(4, 6, GREY), (11, 6, GREY),                    # temples, from behind
                   (5, 10, BRASS), (10, 10, BRASS),                # chain across the shoulders
                   (2, 15, INK), (13, 15, INK)], dirn)
    else:  # left; right is mirrored by stamp()
        stamp(im, [(3, 5, GREY),                                   # temple at the brow
                   (9, 11, BRASS), (8, 12, BRASS), (8, 13, BRASS2),
                   (4, 15, INK)], dirn)
    return im


def vell_ledger(im, dirn):
    """The heavy ledger, carried edge-on under the near arm: leather spine, pale fore-edge."""
    if dirn == 'down':
        stamp(im, [(10, 12, BOOK), (11, 12, PAGE), (12, 12, PAGE2),
                   (10, 13, BOOK), (11, 13, PAGE), (12, 13, PAGE2),
                   (10, 14, BOOK), (11, 14, PAGE), (12, 14, PAGE2),
                   (10, 15, BOOK), (11, 15, PAGE), (12, 15, PAGE2),
                   (10, 16, BOOK2), (11, 16, PAGE2), (12, 16, BOOK2),
                   (11, 12, BRASS2)], dirn)
    elif dirn == 'up':
        # held in front: below the arm only the spine and the page edge show
        stamp(im, [(11, 12, BOOK), (12, 12, PAGE2),
                   (11, 13, BOOK), (12, 13, PAGE),
                   (11, 14, BOOK), (12, 14, PAGE2),
                   (11, 15, BOOK2), (12, 15, BOOK2)], dirn)
    else:  # left, and mirrored for right
        stamp(im, [(2, 12, BOOK), (3, 12, PAGE),
                   (2, 13, BOOK), (3, 13, PAGE),
                   (2, 14, BOOK), (3, 14, PAGE2),
                   (2, 15, BOOK), (3, 15, PAGE2),
                   (2, 16, BOOK2), (3, 16, BOOK2),
                   (3, 12, BRASS2)], dirn)
    return im


def vell(im, dirn, phase):
    return vell_ledger(vell_marks(im, dirn), dirn)


# ---------------------------------------------------------------- Nessa
def nessa_marks(im, dirn, phase):
    """Hair tied back, a linen apron, ink-stained fingers, a folded page at her waist."""
    if dirn == 'down':
        stamp(im, [(8, 2, NESSA['hair2']), (8, 3, NESSA['hair2']),   # centre parting
                   (9, 3, BRASS2),                                    # pin
                   (6, 11, LINEN), (9, 11, LINEN),                    # apron straps
                   (13, 15, INK)], dirn)                              # ink on the fingers
        # a narrow apron panel, so the dress still shows either side of it
        for y in range(12, 18):
            for x in range(6, 10):
                px(im, x, y, LINEN if y < 17 else LINEN2)
        # the waist tie, and the folded page tucked under it
        stamp(im, [(5, 14, LINEN2), (10, 14, LINEN2),
                   (5, 15, PAGE), (5, 16, PAGE2), (6, 16, PAGE2)], dirn)
    elif dirn == 'up':
        stamp(im, [(6, 9, LINEN), (7, 9, LINEN2), (8, 9, LINEN),     # the tie at her nape
                   (7, 14, LINEN), (8, 14, LINEN2),                  # apron bow
                   (7, 15, LINEN2), (8, 15, LINEN2)], dirn)
    else:  # left, mirrored for right
        # the apron reads as its front edge, not as a slab across the body
        stamp(im, [(5, 13, LINEN), (5, 14, LINEN2),
                   (5, 16, LINEN), (5, 17, LINEN2),
                   (4, 14, LINEN2),                                  # waist tie
                   (11, 4, NESSA['hair2']), (12, 4, NESSA['hair2']),  # the tied knot of hair
                   (12, 5, NESSA['hair2']), (11, 5, NESSA['hair2']),
                   (12, 6, NESSA['hair']),
                   (4, 15, INK)], dirn)                              # ink on the fingers
    return im


# ---------------------------------------------------------------- build
def save_set(stem, P, post):
    od = OUT[stem]
    os.makedirs(od, exist_ok=True)
    for dirn in ('down', 'up', 'left', 'right'):
        idle = post(ow_figure(P, dirn, 0, 'none'), dirn, 0)
        idle.save(f'{od}/spr_{stem}_ow16_idle_{dirn}.png')
        frames = [post(ow_figure(P, dirn, phase, 'none'), dirn, phase)
                  for phase in (1, 2, 3, 2)]
        strip(frames).save(f'{od}/spr_{stem}_ow16_walk_{dirn}_strip4.png')
    print(f'{stem} overworld -> {od}')


def make_preview(stem, label):
    d = OUT[stem]
    rows = []
    for dirn in ('down', 'up', 'right', 'left'):
        idle = Image.open(f'{d}/spr_{stem}_ow16_idle_{dirn}.png').convert('RGBA')
        walk = Image.open(f'{d}/spr_{stem}_ow16_walk_{dirn}_strip4.png').convert('RGBA')
        row = Image.new('RGBA', (idle.width + 16 + walk.width, 24), (0, 0, 0, 0))
        row.paste(idle, (0, 0))
        row.paste(walk, (idle.width + 16, 0))
        rows.append((f'spr_{stem}_ow16_idle_{dirn}.png  +  spr_{stem}_ow16_walk_{dirn}_strip4.png',
                     row, 16))
    preview(rows, f'{d}/spr_{stem}_ow16_preview.png',
            f'{label} overworld 16x24 (idle | walk x4), origin (8,23)', scale=8, fw=16)


def contact_sheet():
    cells = []
    for stem in ('vell', 'nessa'):
        d = OUT[stem]
        for dirn in ('down', 'up', 'right', 'left'):
            idle = Image.open(f'{d}/spr_{stem}_ow16_idle_{dirn}.png').convert('RGBA')
            walk = Image.open(f'{d}/spr_{stem}_ow16_walk_{dirn}_strip4.png').convert('RGBA')
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
    out = os.path.join(SPR, '..', '..', 'artifacts', 'crown_town_folk.png')
    sheet.convert('RGB').save(os.path.abspath(out))
    print('contact sheet ->', os.path.abspath(out))


if __name__ == '__main__':
    save_set('vell', VELL, vell)
    save_set('nessa', NESSA, nessa_marks)
    make_preview('vell', 'VELL')
    make_preview('nessa', 'NESSA')
    contact_sheet()
