"""Cinderhollow's burners and the Lost Ones: dedicated 16x24 overworld sets.

The scripts give these people roles, not faces, so this is art direction only. Nothing here
adds lore or resolves what the Lost Ones are.

  burner        soot-dark adult in a patched brown coat and a charcoal cap, no weapon
  burner_wood   younger adult with a strapped bundle of wet wood; no cap, red kerchief
  burner_child  small patched figure with a mop of dark hair, scaled from the same template
  lost_one      gaunt, barefoot figure in leaf-stained clothes, facing the shrine
  lost_one_boots the same, wearing the patrol's boots

Overworld: 16x24, four directions, idle + 4 walk frames. No battle strips or portraits.

Run from the repo root:  python3 game/sprites/src/blackwood_folk.py
"""

import os
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from party_kit import ow_figure, px, strip, canvas, _shade
from pix import preview, BG

SPR = os.path.abspath(os.path.join(HERE, '..'))
OUT = {
    'burner': os.path.join(SPR, 'npcs', 'burner'),
    'burner_wood': os.path.join(SPR, 'npcs', 'burner_wood'),
    'burner_child': os.path.join(SPR, 'npcs', 'burner_child'),
    'lost_one': os.path.join(SPR, 'enemies', 'lost_one', 'overworld'),
    'lost_one_boots': os.path.join(SPR, 'enemies', 'lost_one', 'overworld'),
}

BURNER = dict(
    skin=(152, 110, 82), skin2=(118, 80, 58),
    hair=(42, 36, 30), hair2=(28, 24, 20),
    coat=(78, 60, 43), coat2=(54, 42, 32),
    trim=(122, 86, 52),
    pants=(56, 48, 40), boot=(36, 30, 24),
    metal=(132, 126, 114), metal2=(170, 164, 150),
    wood=(88, 62, 40), leather=(100, 72, 46),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(18, 16, 14),
    cap=(60, 50, 38), beard=True,
)

BURNER_WOOD = dict(
    skin=(166, 120, 88), skin2=(132, 90, 64),
    hair=(50, 42, 34), hair2=(34, 28, 22),
    coat=(68, 55, 42), coat2=(48, 38, 30),
    trim=(112, 78, 46),
    pants=(54, 46, 38), boot=(38, 30, 24),
    metal=(132, 126, 114), metal2=(170, 164, 150),
    wood=(92, 66, 42), leather=(106, 76, 48),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(18, 16, 14),
    scarf=(122, 62, 42),
)

BURNER_CHILD = dict(
    skin=(172, 128, 94), skin2=(138, 96, 68),
    hair=(44, 37, 30), hair2=(30, 25, 20),
    coat=(84, 68, 50), coat2=(60, 48, 36),
    trim=(126, 90, 54),
    pants=(56, 48, 40), boot=(38, 30, 24),
    metal=(132, 126, 114), metal2=(170, 164, 150),
    wood=(88, 62, 40), leather=(100, 72, 46),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(18, 16, 14),
    scarf=(148, 116, 64),
)

LOST = dict(
    skin=(176, 182, 170), skin2=(140, 146, 134),
    hair=(56, 60, 54), hair2=(38, 42, 38),
    coat=(74, 80, 66), coat2=(54, 60, 48),
    trim=(98, 106, 84),
    pants=(52, 56, 48), boot=(140, 146, 134),  # barefoot: the boot shape is skin-toned
    metal=(140, 146, 134), metal2=(176, 182, 170),
    wood=(92, 70, 46), leather=(86, 68, 48),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(20, 24, 20),
    long_hair=True, cloak=True,
)

LOST_BOOTS = dict(LOST)
LOST_BOOTS['boot'] = (82, 64, 44)  # the patrol boots from PT_CAMP_02
LOST_BOOTS['leather'] = (82, 64, 44)


def carry_bundle(im, dirn, phase):
    """Three wet sticks over the shoulder, bound with a leather strap."""
    if dirn == 'right':
        sticks = ((4, 5), (2, 4), (1, 6))
    elif dirn == 'up':
        sticks = ((10, 5), (12, 4), (13, 6))
    else:
        sticks = ((11, 4), (13, 5), (14, 6))
    for i, (x, top) in enumerate(sticks):
        for y in range(top, 12):
            px(im, x, y, _shade(BURNER_WOOD['wood'], 0.82 + i * 0.08 + (y - top) * 0.01))
        px(im, x, top, _shade(BURNER_WOOD['wood'], 0.55))
    # the strap crosses the near shoulder; the hand closes on the lowest stick
    for x, y in ((8, 12), (9, 11), (10, 10), (11, 9)):
        if dirn == 'right':
            x = 15 - x
        px(im, x, y, BURNER_WOOD['leather'])
    hand_x = 11 if dirn not in ('right', 'up') else 12
    px(im, hand_x, 12, BURNER_WOOD['skin2'])
    return im


def leaf_litter(im, dirn, phase):
    """A few leaves at the feet: they are standing in the shrine's leaf litter."""
    for x, y, c in ((1, 23, (84, 92, 58)), (14, 22, (96, 74, 42)),
                    (0, 21, (68, 78, 48)), (15, 23, (78, 66, 40))):
        if im.getpixel((x, y))[3] == 0:
            px(im, x, y, c)
    return im


def soot(im, dirn, phase):
    """Two soot flecks; the palette already carries most of the grime."""
    if dirn != 'up':
        px(im, 5, 8, (34, 28, 22))
        px(im, 9, 12, (34, 28, 22))
    return im


def child_frame(P, dirn, phase):
    """The same figure at 12x18, feet on the bottom row: a child, not a shrunken adult."""
    adult = ow_figure(P, dirn, phase, 'none')
    small = adult.resize((12, 18), Image.NEAREST)
    im = canvas(16, 24)
    im.alpha_composite(small, (2, 6))
    # The 12x18 downscale swallows the template's 1px eyes; put them back so the child reads.
    if dirn == 'down':
        px(im, 6, 12, (46, 33, 25))
        px(im, 9, 12, (46, 33, 25))
    elif dirn == 'left':
        px(im, 5, 12, (46, 33, 25))
    elif dirn == 'right':
        px(im, 10, 12, (46, 33, 25))
    return im


def save_set(stem, P, post=None, child=False, folder=None):
    od = folder or OUT[stem]
    os.makedirs(od, exist_ok=True)
    for dirn in ('down', 'up', 'left', 'right'):
        if child:
            idle = child_frame(P, dirn, 0)
        else:
            idle = ow_figure(P, dirn, 0, 'none')
        if post:
            idle = post(idle, dirn, 0)
        idle.save(f'{od}/spr_{stem}_ow16_idle_{dirn}.png')
        frames = []
        for phase in (1, 2, 3, 2):
            if child:
                im = child_frame(P, dirn, phase)
            else:
                im = ow_figure(P, dirn, phase, 'none')
            if post:
                im = post(im, dirn, phase)
            frames.append(im)
        strip(frames).save(f'{od}/spr_{stem}_ow16_walk_{dirn}_strip4.png')
    print(f'{stem} overworld -> {od}')


def make_preview(stem, label, folder=None):
    d = folder or OUT[stem]
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
    for stem, label in (('burner', 'burner'), ('burner_wood', 'burner (wood)'),
                        ('burner_child', 'burner child'), ('lost_one', 'lost one'),
                        ('lost_one_boots', 'lost one (boots)')):
        d = OUT[stem]
        for dirn in ('down', 'up', 'right', 'left'):
            idle = Image.open(f'{d}/spr_{stem}_ow16_idle_{dirn}.png').convert('RGBA')
            walk = Image.open(f'{d}/spr_{stem}_ow16_walk_{dirn}_strip4.png').convert('RGBA')
            cells.append((label, dirn, idle, walk))
    scale = 6
    cw, ch = 16 * scale, 24 * scale
    pad = 12
    label_h = 16
    width = pad + 2 * (cw * 5 + pad) + pad
    height = pad + 10 * (ch + label_h + pad)
    sheet = Image.new('RGBA', (width, height), BG)
    from PIL import ImageDraw
    draw = ImageDraw.Draw(sheet)
    for i, (label, dirn, idle, walk) in enumerate(cells):
        gx, gy = i % 2, i // 2
        x0 = pad + gx * (cw * 5 + pad)
        y0 = pad + gy * (ch + label_h + pad)
        draw.text((x0, y0), f'{label}  {dirn}', fill=(220, 214, 196))
        frame = Image.new('RGBA', (16 * 5, 24), (0, 0, 0, 0))
        frame.alpha_composite(idle, (0, 0))
        for k in range(4):
            frame.alpha_composite(walk.crop((k * 16, 0, k * 16 + 16, 24)), (16 + k * 16, 0))
        sheet.alpha_composite(frame.resize((frame.width * scale, frame.height * scale),
                                           Image.NEAREST), (x0, y0 + label_h))
    out = os.path.join(SPR, '..', '..', 'artifacts', 'blackwood_folk.png')
    sheet.convert('RGB').save(os.path.abspath(out))
    print('contact sheet ->', os.path.abspath(out))


if __name__ == '__main__':
    save_set('burner', BURNER, post=soot)
    save_set('burner_wood', BURNER_WOOD, post=carry_bundle)
    save_set('burner_child', BURNER_CHILD, child=True)
    save_set('lost_one', LOST, post=leaf_litter)
    save_set('lost_one_boots', LOST_BOOTS, post=leaf_litter)
    make_preview('burner', 'BURNER')
    make_preview('burner_wood', 'BURNER (WOOD)')
    make_preview('burner_child', 'BURNER CHILD')
    make_preview('lost_one', 'LOST ONE')
    make_preview('lost_one_boots', 'LOST ONE (BOOTS)')
    contact_sheet()
