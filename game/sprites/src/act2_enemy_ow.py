"""Act II enemy overworld sets: crown_patrolman, crown_crossbowman,
occupation_soldier and bandit_veteran.

These four kinds had battle strips but no 16x24 map set. They are built on the
same 16x24 body template as the party kit so the proportions match the other
hand-authored overworld sets, then given distinct headgear, shields and weapons:

  crown_patrolman      kettle helm, blue tabard, spear and shield
  crown_crossbowman    soft cap, brown coat, blue sash and crossbow
  occupation_soldier   great helm, dark plate, heavy shield and halberd
  bandit_veteran       fur hood, red scarf, axe and no shield

The details are deliberately small. At 16x24 a brim, a nasal bar, a shield boss
or the line of an axe reads; a full helmet block or a long weapon rectangle does
not. Nothing here changes the battle strips or the existing map sets.

Run from the repo root:
    python3 game/sprites/src/act2_enemy_ow.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from PIL import Image, ImageDraw
from party_kit import ow_figure, px, rect, strip, _shade, _lift


HERE = os.path.dirname(os.path.abspath(__file__))
SPR = os.path.abspath(os.path.join(HERE, '..'))
OUT = os.path.join(SPR, 'enemies')


# ------------------------------------------------------------------ palettes
# Colours are sampled from the four battle strips so the map sets belong to the
# same characters. Keys used by party_kit.ow_figure are all present.
PALETTES = {
    'crown_patrolman': dict(
        out=(10, 10, 14), hair=(86, 96, 110), hair2=(58, 66, 78),
        skin=(214, 174, 132), skin2=(184, 140, 100),
        coat=(58, 88, 132), trim=(198, 160, 74), metal=(134, 146, 160),
        metal2=(176, 186, 198), wood=(88, 62, 40), pants=(42, 48, 60),
        boot=(32, 24, 18), leather=(96, 68, 44), eye=(22, 24, 30),
    ),
    'crown_crossbowman': dict(
        out=(10, 10, 14), hair=(82, 66, 50), hair2=(58, 44, 32),
        skin=(214, 174, 132), skin2=(184, 140, 100),
        coat=(104, 76, 48), trim=(54, 86, 132), metal=(136, 146, 158),
        metal2=(176, 186, 198), wood=(82, 58, 38), pants=(58, 42, 28),
        boot=(32, 24, 18), leather=(124, 90, 58), eye=(22, 24, 30),
    ),
    'occupation_soldier': dict(
        out=(8, 8, 12), hair=(64, 72, 82), hair2=(42, 48, 58),
        skin=(202, 162, 122), skin2=(170, 128, 92),
        coat=(52, 60, 72), trim=(146, 112, 48), metal=(96, 106, 118),
        metal2=(142, 152, 164), wood=(68, 48, 32), pants=(34, 38, 46),
        boot=(26, 20, 16), leather=(82, 60, 40), eye=(18, 20, 26),
    ),
    'bandit_veteran': dict(
        out=(10, 10, 14), hair=(92, 76, 56), hair2=(60, 48, 36),
        skin=(208, 168, 126), skin2=(176, 132, 94),
        coat=(86, 72, 50), trim=(150, 54, 46), metal=(132, 138, 142),
        metal2=(176, 182, 186), wood=(78, 54, 36), pants=(54, 44, 34),
        boot=(30, 24, 18), leather=(112, 80, 52), eye=(22, 24, 30),
    ),
}


# ------------------------------------------------------------------ drawing helpers
def _hand(im, x, y, P):
    px(im, x, y, P['out'])
    px(im, x, y - 1, P['skin'])
    px(im, x + 1, y, P['skin2'])


def _shield(im, P, x0, y0, w, h, field, rim, boss):
    o = P['out']
    rect(im, x0 - 1, y0 - 1, x0 + w, y0 + h, o)
    rect(im, x0, y0, x0 + w - 1, y0 + h - 1, rim)
    rect(im, x0 + 1, y0 + 1, x0 + w - 2, y0 + h - 2, field)
    px(im, x0 + w // 2, y0 + 1, boss)
    px(im, x0 + w // 2, y0 + 2, boss)
    px(im, x0 + 1, y0 + h - 2, _shade(field, 0.72))
    px(im, x0 + w - 2, y0 + h - 2, _shade(field, 0.72))


# ------------------------------------------------------------------ headgear
def patrol_helm(im, P, dirn):
    """Kettle helm: keep the face, add a one-pixel brim and a nasal bar."""
    o, m, m2 = P['out'], P['metal'], P['metal2']
    if dirn == 'up':
        rect(im, 3, 1, 12, 4, m)
        rect(im, 5, 1, 10, 1, m2)
        rect(im, 4, 5, 11, 5, m)
        rect(im, 4, 6, 11, 6, _shade(m, 0.7))
        px(im, 7, 1, m2); px(im, 8, 1, m2)
    elif dirn == 'left':
        rect(im, 5, 1, 10, 3, m)
        rect(im, 2, 4, 9, 4, m2)
        rect(im, 2, 5, 2, 6, m2)
        rect(im, 5, 5, 5, 7, m)
        px(im, 7, 1, m2); px(im, 8, 1, m2)
    else:
        rect(im, 4, 1, 11, 3, m)
        rect(im, 2, 4, 13, 4, m2)
        rect(im, 3, 5, 3, 6, m)
        rect(im, 12, 5, 12, 6, m)
        rect(im, 8, 4, 8, 6, m2)
        px(im, 7, 1, m2); px(im, 8, 1, m2)


def crossbow_cap(im, P, dirn):
    """Soft cap with a short brim and the blue company band on the brow."""
    c, c2, blue = P['hair'], P['hair2'], P['trim']
    if dirn == 'up':
        rect(im, 5, 1, 10, 1, c)
        rect(im, 4, 2, 11, 3, c)
        rect(im, 3, 4, 12, 4, c2)
        rect(im, 4, 4, 11, 4, blue)
        rect(im, 4, 5, 11, 7, _shade(c2, 0.82))
    elif dirn == 'left':
        rect(im, 5, 1, 10, 1, c)
        rect(im, 4, 2, 10, 3, c)
        rect(im, 2, 4, 10, 4, c2)
        rect(im, 5, 4, 10, 4, blue)
        rect(im, 4, 5, 5, 7, c2)
    else:
        rect(im, 5, 1, 10, 1, c)
        rect(im, 4, 2, 11, 3, c)
        rect(im, 3, 4, 12, 4, c2)
        rect(im, 4, 4, 11, 4, blue)
        rect(im, 3, 5, 4, 7, c2)
        rect(im, 11, 5, 12, 7, c2)


def great_helm(im, P, dirn):
    """Full helm: cover the face, then cut a dark eye slit and a central ridge."""
    o, m, m2 = P['out'], P['metal'], P['metal2']
    if dirn == 'up':
        rect(im, 3, 1, 12, 4, m)
        rect(im, 5, 1, 10, 2, m2)
        rect(im, 7, 1, 8, 8, m2)
        rect(im, 4, 5, 11, 8, _shade(m, 0.82))
        rect(im, 4, 8, 11, 8, _shade(m, 0.62))
    elif dirn == 'left':
        rect(im, 4, 1, 11, 4, m)
        rect(im, 5, 1, 10, 2, m2)
        rect(im, 5, 5, 10, 8, m)
        rect(im, 6, 1, 7, 8, m2)
        rect(im, 2, 6, 7, 6, o)
        rect(im, 2, 7, 4, 8, _shade(m, 0.72))
    else:
        rect(im, 3, 1, 12, 4, m)
        rect(im, 4, 1, 11, 2, m2)
        rect(im, 3, 5, 12, 8, m)
        rect(im, 7, 1, 8, 8, m2)
        rect(im, 4, 6, 11, 6, o)
        rect(im, 3, 7, 3, 8, m2)
        rect(im, 12, 7, 12, 8, m2)
        px(im, 5, 3, P['trim']); px(im, 10, 3, P['trim'])


def fur_hood(im, P, dirn):
    """Fur trim around the hair and a short mantle; the face stays visible."""
    o, f, f2, scarf = P['out'], P['hair'], P['hair2'], P['trim']
    if dirn == 'up':
        rect(im, 4, 1, 11, 1, f)
        for x, y in ((3, 2), (2, 3), (2, 4), (12, 2), (13, 3), (13, 4),
                     (3, 5), (4, 5), (11, 5), (12, 5), (4, 6), (11, 6)):
            px(im, x, y, f)
        for x, y in ((1, 10), (2, 10), (3, 10), (12, 10), (13, 10), (14, 10),
                     (1, 11), (2, 11), (13, 11), (14, 11), (2, 12), (3, 12), (12, 12), (13, 12)):
            px(im, x, y, f if (x + y) % 3 else f2)
        px(im, 12, 13, scarf); px(im, 13, 13, _shade(scarf, 0.8))
    elif dirn == 'left':
        for x, y in ((5, 1), (6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
                     (9, 2), (10, 2), (11, 2), (10, 3), (11, 3), (11, 4),
                     (11, 5), (11, 6)):
            px(im, x, y, f)
        for x, y in ((1, 10), (2, 10), (3, 10), (12, 10), (13, 10), (14, 10),
                     (1, 11), (2, 11), (13, 11), (14, 11), (2, 12), (3, 12), (12, 12), (13, 12)):
            px(im, x, y, f if (x + y) % 3 else f2)
        px(im, 1, 13, scarf); px(im, 2, 13, _shade(scarf, 0.8))
    else:
        rect(im, 4, 1, 11, 1, f)
        for x, y in ((3, 2), (2, 3), (2, 4), (12, 2), (13, 3), (13, 4),
                     (3, 5), (4, 5), (11, 5), (12, 5), (4, 6), (11, 6)):
            px(im, x, y, f)
        for x, y in ((1, 10), (2, 10), (3, 10), (12, 10), (13, 10), (14, 10),
                     (1, 11), (2, 11), (13, 11), (14, 11), (2, 12), (3, 12), (12, 12), (13, 12)):
            px(im, x, y, f if (x + y) % 3 else f2)
        px(im, 12, 12, scarf); px(im, 13, 13, scarf); px(im, 14, 13, _shade(scarf, 0.8))


# ------------------------------------------------------------------ weapons and shields
def spear(im, P, dirn):
    o, wood, m, gold = P['out'], P['wood'], P['metal2'], P['trim']
    x = 12 if dirn == 'left' else 13
    rect(im, x, 3, x, 20, wood)
    px(im, x + 1, 5, o); px(im, x + 1, 9, o); px(im, x + 1, 13, o); px(im, x + 1, 17, o)
    rect(im, x - 1, 1, x + 1, 2, o)
    rect(im, x, 1, x, 2, m)
    px(im, x, 0, m)
    rect(im, x - 2, 4, x - 1, 5, gold)
    _hand(im, x - 1, 15, P)


def patrol_shield(im, P, dirn):
    if dirn == 'left':
        x0, y0 = 1, 12
    elif dirn == 'up':
        x0, y0 = 11, 12
    else:
        x0, y0 = 1, 12
    _shield(im, P, x0, y0, 3, 5, P['coat'], P['metal'], P['trim'])


def crossbow(im, P, dirn):
    o, wood, m, m2 = P['out'], P['wood'], P['metal'], P['metal2']
    if dirn == 'up':
        # crossbow across the back: stock, bow, string and bolt tips
        rect(im, 7, 11, 13, 11, o)
        rect(im, 8, 11, 12, 11, wood)
        rect(im, 12, 8, 12, 14, m)
        px(im, 12, 7, m2); px(im, 12, 15, m2)
        rect(im, 10, 8, 10, 14, m2)
        rect(im, 9, 9, 9, 9, m2); rect(im, 9, 13, 9, 13, m2)
        px(im, 11, 12, P['trim'])
    elif dirn == 'left':
        rect(im, 1, 13, 7, 13, o)
        rect(im, 2, 13, 7, 13, wood)
        rect(im, 2, 10, 2, 16, m)
        px(im, 2, 9, m2); px(im, 2, 17, m2)
        rect(im, 4, 9, 4, 17, m2)
        rect(im, 0, 12, 1, 12, m2)
        px(im, 0, 13, m2)
        _hand(im, 6, 13, P)
    else:
        rect(im, 8, 13, 14, 13, o)
        rect(im, 9, 13, 14, 13, wood)
        rect(im, 13, 10, 13, 16, m)
        px(im, 13, 9, m2); px(im, 13, 17, m2)
        rect(im, 11, 9, 11, 17, m2)
        rect(im, 15, 12, 15, 12, m2)
        px(im, 15, 13, m2)
        _hand(im, 9, 13, P)


def heavy_shield(im, P, dirn):
    if dirn == 'up':
        x0, y0 = 10, 11
    else:
        x0, y0 = 1, 11
    _shield(im, P, x0, y0, 4, 7, P['coat'], P['metal'], P['trim'])


def halberd(im, P, dirn):
    o, wood, m, m2, gold = P['out'], P['wood'], P['metal'], P['metal2'], P['trim']
    x = 12 if dirn == 'left' else 13
    rect(im, x, 3, x, 20, wood)
    px(im, x + 1, 6, o); px(im, x + 1, 10, o); px(im, x + 1, 14, o); px(im, x + 1, 18, o)
    if dirn == 'left':
        rect(im, x - 4, 3, x - 1, 3, o)
        rect(im, x - 4, 3, x - 2, 3, m)
        rect(im, x - 5, 4, x - 4, 6, m2)
        px(im, x - 5, 3, o); px(im, x - 5, 7, o)
    else:
        rect(im, x + 1, 3, x + 4, 3, o)
        rect(im, x + 2, 3, x + 4, 3, m)
        rect(im, x + 4, 4, x + 5, 6, m2)
        px(im, x + 5, 3, o); px(im, x + 5, 7, o)
    rect(im, x, 0, x, 2, m)
    px(im, x, 0, m2)
    rect(im, x - 1, 6, x + 1, 6, gold)
    _hand(im, x - 1, 15, P)


def veteran_axe(im, P, dirn):
    o, wood, m, m2 = P['out'], P['wood'], P['metal'], P['metal2']
    x = 12 if dirn == 'left' else 13
    rect(im, x, 8, x, 20, wood)
    px(im, x + 1, 10, o); px(im, x + 1, 14, o); px(im, x + 1, 18, o)
    if dirn == 'left':
        rect(im, x - 3, 6, x, 6, o)
        rect(im, x - 3, 6, x - 1, 6, m)
        rect(im, x - 4, 7, x - 3, 8, m2)
    else:
        rect(im, x, 6, x + 3, 6, o)
        rect(im, x + 1, 6, x + 3, 6, m)
        rect(im, x + 3, 7, x + 4, 8, m2)
    _hand(im, x - 1, 15, P)


# ------------------------------------------------------------------ body details
def soldier_shoulders(im, P, dirn):
    m, m2, gold = P['metal'], P['metal2'], P['trim']
    if dirn == 'left':
        rect(im, 2, 10, 4, 11, m)
        px(im, 3, 10, m2); px(im, 2, 11, gold)
    elif dirn == 'up':
        rect(im, 2, 10, 4, 11, m)
        rect(im, 11, 10, 13, 11, m)
        px(im, 3, 10, m2); px(im, 12, 10, m2)
    else:
        rect(im, 2, 10, 4, 11, m)
        rect(im, 11, 10, 13, 11, m)
        px(im, 3, 10, m2); px(im, 12, 10, m2)
        px(im, 2, 11, gold); px(im, 13, 11, gold)


# ------------------------------------------------------------------ composite frame
def frame(P, kind, dirn, phase=0):
    if dirn == 'right':
        return frame(P, kind, 'left', phase).transpose(Image.FLIP_LEFT_RIGHT)
    im = ow_figure(P, dirn, phase, weapon=None)

    if kind == 'crown_patrolman':
        patrol_helm(im, P, dirn)
        patrol_shield(im, P, dirn)
        spear(im, P, dirn)
    elif kind == 'crown_crossbowman':
        crossbow_cap(im, P, dirn)
        crossbow(im, P, dirn)
        sash = _lift(P['trim'], 0.18)
        if dirn == 'down':
            for x, y in ((4, 10), (5, 11), (6, 12), (7, 13), (8, 14), (9, 15)):
                px(im, x, y, sash)
        elif dirn == 'left':
            for x, y in ((3, 10), (4, 11), (5, 12), (6, 13), (7, 14)):
                px(im, x, y, sash)
        else:
            for x, y in ((11, 10), (10, 11), (9, 12), (8, 13), (7, 14)):
                px(im, x, y, sash)
    elif kind == 'occupation_soldier':
        soldier_shoulders(im, P, dirn)
        great_helm(im, P, dirn)
        heavy_shield(im, P, dirn)
        halberd(im, P, dirn)
    elif kind == 'bandit_veteran':
        fur_hood(im, P, dirn)
        veteran_axe(im, P, dirn)
    return im


# ------------------------------------------------------------------ output
def walk_gif(walks, fw, fh, path, scale=8, ms=140):
    frames = []
    for i in range(4):
        f = Image.new('RGBA', (fw * 4 + 12, fh), (34, 34, 44, 255))
        for k, walk in enumerate(walks):
            f.alpha_composite(walk[i], (k * (fw + 4), 0))
        frames.append(f.convert('RGB').resize((f.width * scale, fh * scale), Image.NEAREST))
    frames[0].save(path, save_all=True, append_images=frames[1:], duration=ms, loop=0, disposal=2)


def preview(rows, path, title):
    scale, fw, fh = 8, 16, 24
    pad, lab = 12, 20
    W = (fw * 5 + pad * 2) * scale + pad
    H = len(rows) * (fh * scale + lab + pad) + 40
    sheet = Image.new('RGBA', (W, H), (22, 22, 28, 255))
    d = ImageDraw.Draw(sheet)
    d.text((pad, 10), title, fill=(230, 230, 230, 255))
    y = 34
    for label, strip_im in rows:
        d.text((pad, y), label, fill=(200, 200, 210, 255))
        y += lab
        for i in range(5):
            cell = Image.new('RGBA', (fw, fh), (34, 34, 44, 255) if i == 0 else (44, 44, 56, 255))
            cell.alpha_composite(strip_im.crop((i * fw, 0, (i + 1) * fw, fh)))
            sheet.alpha_composite(cell.resize((fw * scale, fh * scale), Image.NEAREST),
                                  (pad + i * (fw * scale + 4), y))
        y += fh * scale + pad
    sheet.convert('RGB').save(path)


def build_one(name):
    P = PALETTES[name]
    out = os.path.join(OUT, name, 'overworld')
    os.makedirs(out, exist_ok=True)
    rows = []
    walks = []
    for d in ('down', 'up', 'left', 'right'):
        idle = frame(P, name, d, 0)
        walk = [frame(P, name, d, i) for i in range(4)]
        idle.save(os.path.join(out, f'spr_{name}_ow16_idle_{d}.png'))
        strip(walk).save(os.path.join(out, f'spr_{name}_ow16_walk_{d}_strip4.png'))
        rows.append((f'{d}: idle + walk 4', strip([idle] + walk)))
        walks.append(walk)
    # source previews are reference only, like the other generated sets
    preview(rows, os.path.join(out, f'{name}_ow16_preview.png'),
            f'{name.upper()} overworld 16x24 (idle | walk x4), origin (8,23)')
    walk_gif(walks, 16, 24, os.path.join(out, f'{name}_ow16_walk_preview.gif'))
    print('wrote', name)


def build():
    for name in PALETTES:
        build_one(name)
    print('ok')


if __name__ == '__main__':
    build()
