"""The last enemy 16x24 map sets, closing the gap recorded in STATUS.md.

Every kind here has battle art but no overworld set. The humanoids reuse the shared
16x24 body template (the same one the party and the Act II humanoids use) so their
proportions match the rest of the map cast, then get the gear their battle art shows.
The two constructs are recoloured from sets that already exist in the same "make":
the hostile Fallen Knight from the story sighting's armour, and the Sanctuary Warden
from the Door Warden's stone. The wraith and the four beasts are hand-drawn grids.

  cutpurse                 short hood, face mask, dagger; a cut purse at the belt
  dock_thug                knit cap, rolled sleeves, belaying pin
  garrison_field_surgeon   pale linen apron, tool satchel, blood at the hem
  garrison_pikeman         kettle helm, blue tabard, pike
  fallen_knight            the story knight's plate, darkened, with a drawn greatsword
  sanctuary_warden         mossy stone, a verdant ward-light, a broken crest
  shade_stalker            tall hooded wraith with no feet, ember eyes
  briar_hulk               thorn-vine brute: wide shoulders, root legs
  glyph_wisp               floating sigil and its motes
  grey_ash_wolf            low grey wolf, ember eyes
  night_moth_swarm         a loose cluster of pale moths around a dark core
  spiderling               a small spider low in the cell

Overworld: 16x24, four directions, idle + 4 walk frames. No battle strips change.

Run from the repo root:
    python3 game/sprites/src/enemy_ow_remaining.py
"""
import os
import sys

from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from party_kit import ow_figure, px, rect, strip, _shade, _lift

SPR = os.path.abspath(os.path.join(HERE, '..'))
OUT = os.path.join(SPR, 'enemies')

# ---------------------------------------------------------------- palettes
# Sampled from each kind's battle idle strip, so a map sprite and its battle art
# read as the same creature.
CUTPURSE = dict(
    out=(20, 16, 16), hair=(58, 50, 56), hair2=(42, 34, 40),
    skin=(224, 193, 154), skin2=(201, 162, 122),
    coat=(58, 50, 56), coat2=(42, 34, 40),
    trim=(110, 80, 56), pants=(42, 34, 40), boot=(28, 22, 22),
    metal=(150, 150, 158), metal2=(190, 190, 198),
    wood=(90, 66, 44), leather=(110, 80, 56),
    crystal=(190, 210, 190), crystal2=(226, 240, 226), eye=(24, 18, 20),
)

DOCK_THUG = dict(
    out=(20, 16, 16), hair=(62, 56, 52), hair2=(42, 36, 32),
    skin=(224, 193, 154), skin2=(201, 162, 122),
    coat=(106, 80, 64), coat2=(58, 42, 32),
    trim=(140, 110, 70), pants=(62, 56, 52), boot=(42, 32, 24),
    metal=(140, 140, 132), metal2=(180, 180, 170),
    wood=(110, 84, 56), leather=(86, 62, 40),
    crystal=(190, 210, 190), crystal2=(226, 240, 226), eye=(22, 16, 12),
)

SURGEON = dict(
    out=(14, 16, 20), hair=(58, 42, 32), hair2=(42, 30, 22),
    skin=(224, 193, 154), skin2=(201, 162, 122),
    coat=(180, 170, 148), coat2=(142, 134, 116),
    trim=(212, 205, 184), pants=(74, 70, 64), boot=(48, 42, 36),
    metal=(150, 154, 158), metal2=(190, 194, 198),
    wood=(110, 80, 56), leather=(86, 62, 40),
    crystal=(190, 210, 190), crystal2=(226, 240, 226), eye=(20, 18, 20),
)

PIKEMAN = dict(
    out=(14, 16, 20), hair=(74, 81, 96), hair2=(42, 46, 54),
    skin=(201, 162, 122), skin2=(170, 128, 92),
    coat=(42, 46, 54), coat2=(30, 34, 42),
    trim=(42, 74, 122), pants=(42, 46, 54), boot=(30, 26, 24),
    metal=(122, 130, 144), metal2=(170, 178, 190),
    wood=(110, 80, 56), leather=(86, 62, 40),
    crystal=(190, 210, 190), crystal2=(226, 240, 226), eye=(16, 18, 24),
)


# ---------------------------------------------------------------- humanoid gear
def hood(im, P, dirn):
    """A short hood over the hair, with the face left open."""
    h, h2 = P['hair'], P['hair2']
    if dirn == 'up':
        rect(im, 4, 0, 11, 3, h)
        rect(im, 3, 4, 12, 4, h2)
        rect(im, 6, 0, 9, 0, _lift(h, 0.12))
    elif dirn == 'left':
        rect(im, 5, 0, 10, 3, h)
        rect(im, 4, 4, 10, 4, h2)
        rect(im, 3, 5, 3, 8, h2)
    else:
        rect(im, 5, 0, 10, 3, h)
        rect(im, 3, 4, 12, 4, h2)
        rect(im, 3, 5, 3, 8, h2)
        rect(im, 12, 5, 12, 8, h2)
        px(im, 4, 4, _shade(h, 0.6)); px(im, 11, 4, _shade(h, 0.6))


def face_mask(im, P, dirn):
    """Cloth across the mouth: the lower half of the face band."""
    c = _shade(P['coat2'], 0.86)
    if dirn == 'down':
        rect(im, 5, 8, 10, 9, c)
        px(im, 5, 8, _lift(c, 0.1))
    elif dirn == 'left':
        rect(im, 4, 8, 8, 9, c)
    elif dirn == 'right':
        rect(im, 7, 8, 11, 9, c)


def belt_dagger(im, P, dirn):
    """A short blade at the belt, hilt toward the hand."""
    x = 11 if dirn != 'right' else 4
    if dirn == 'left':
        x = 10
    rect(im, x, 14, x, 16, P['metal2'])
    px(im, x, 13, P['trim'])
    px(im, x - 1, 13, P['wood'])


def cut_purse(im, P, dirn):
    x = 3 if dirn != 'right' else 11
    if dirn == 'left':
        x = 4
    rect(im, x, 15, x + 1, 16, P['leather'])
    px(im, x, 15, P['trim'])


def knit_cap(im, P, dirn):
    c, c2 = P['hair'], P['hair2']
    if dirn == 'up':
        rect(im, 4, 1, 11, 4, c)
        rect(im, 4, 4, 11, 4, c2)
        rect(im, 7, 0, 8, 0, c)
    elif dirn == 'left':
        rect(im, 5, 1, 10, 4, c)
        rect(im, 4, 4, 10, 4, c2)
        px(im, 9, 0, c); px(im, 10, 1, c)
    else:
        rect(im, 5, 1, 10, 4, c)
        rect(im, 4, 4, 11, 4, c2)
        px(im, 6, 0, c); px(im, 7, 0, c2)


def rolled_sleeves(im, P, dirn):
    """Bare forearms below the rolled cuff, so the thug reads as a dockhand."""
    if dirn == 'down':
        rect(im, 2, 15, 3, 15, P['skin'])
        rect(im, 12, 15, 13, 15, P['skin'])
        px(im, 2, 14, P['coat2']); px(im, 13, 14, P['coat2'])
    elif dirn == 'left':
        rect(im, 3, 15, 4, 15, P['skin'])
        px(im, 4, 14, P['coat2'])
    else:  # right, drawn before mirroring in frame()
        rect(im, 11, 15, 12, 15, P['skin'])
        px(im, 11, 14, P['coat2'])


def belaying_pin(im, P, dirn):
    x = 13 if dirn != 'left' else 2
    wood, hi = _lift(P['wood'], 0.14), _shade(P['wood'], 0.66)
    rect(im, x, 10, x, 18, wood)
    rect(im, x + 1, 10, x + 1, 18, hi)
    rect(im, x - 1, 9, x + 1, 10, P['leather'])   # knobbly head above the fist
    px(im, x, 16, P['skin2'])                      # the hand closes on it
    px(im, x, 17, P['skin2'])
    px(im, x, 18, P['leather'])


def surgeon_apron(im, P, dirn):
    """A pale apron panel, a tool satchel and a little blood at the hem."""
    a, a2, blood = P['trim'], P['coat2'], (138, 58, 48)
    if dirn == 'down':
        rect(im, 5, 11, 10, 17, a)
        rect(im, 5, 17, 10, 17, a2)
        px(im, 8, 15, blood); px(im, 9, 16, blood)
        rect(im, 3, 15, 4, 17, P['leather'])      # satchel
        px(im, 3, 15, P['metal'])
    elif dirn == 'left':
        rect(im, 5, 11, 8, 17, a)
        rect(im, 5, 17, 8, 17, a2)
        px(im, 6, 15, blood)
        rect(im, 9, 14, 10, 16, P['leather'])
    else:
        rect(im, 7, 11, 10, 17, a)
        rect(im, 7, 17, 10, 17, a2)
        px(im, 8, 16, blood)
        rect(im, 5, 14, 6, 16, P['leather'])


def surgeon_cap(im, P, dirn):
    c, c2 = P['coat2'], _shade(P['coat2'], 0.8)
    if dirn == 'up':
        rect(im, 5, 1, 10, 3, c)
        rect(im, 4, 4, 11, 4, c2)
    elif dirn == 'left':
        rect(im, 5, 1, 10, 3, c)
        rect(im, 4, 4, 9, 4, c2)
    else:
        rect(im, 5, 1, 10, 3, c)
        rect(im, 4, 4, 11, 4, c2)
        px(im, 8, 4, P['metal'])


def pikeman_helm(im, P, dirn):
    """Kettle helm with a short brim and a nasal bar, over the blue tabard."""
    m, m2, o = P['metal'], P['metal2'], P['out']
    if dirn == 'up':
        rect(im, 3, 1, 12, 4, m)
        rect(im, 5, 1, 10, 1, m2)
        rect(im, 4, 5, 11, 5, _shade(m, 0.7))
    elif dirn == 'left':
        rect(im, 5, 1, 10, 3, m)
        rect(im, 2, 4, 9, 4, m2)
        rect(im, 5, 5, 5, 7, m)
    else:
        rect(im, 4, 1, 11, 3, m)
        rect(im, 2, 4, 13, 4, m2)
        rect(im, 8, 4, 8, 6, m2)
        px(im, 3, 5, m); px(im, 12, 5, m)


def tabard(im, P, dirn):
    t, t2 = P['trim'], _shade(P['trim'], 0.72)
    if dirn == 'up':
        rect(im, 5, 11, 10, 14, t)
        rect(im, 5, 14, 10, 14, t2)
    elif dirn == 'left':
        rect(im, 6, 11, 8, 16, t)
        rect(im, 6, 16, 8, 16, t2)
        px(im, 7, 12, _lift(t, 0.2))
    else:
        rect(im, 7, 11, 8, 16, t)
        rect(im, 7, 16, 8, 16, t2)
        px(im, 7, 12, _lift(t, 0.2))


def pike(im, P, dirn):
    o, wood, m, m2 = P['out'], P['wood'], P['metal'], P['metal2']
    x = 13 if dirn != 'left' else 2
    rect(im, x, 1, x, 21, wood)
    px(im, x + 1, 5, o); px(im, x + 1, 10, o); px(im, x + 1, 15, o)
    rect(im, x, 0, x, 1, m)
    px(im, x, 0, m2)
    px(im, x - 1, 2, m)
    px(im, x, 21, P['leather'])


# ---------------------------------------------------------------- derived sets
def story_knight_frames():
    src = os.path.join(SPR, 'npcs', 'fallen_knight_story')
    return src


KNIGHT_MAP = {
    (0, 0, 0): (10, 10, 14),          # outline
    (90, 90, 90): (52, 56, 64),        # mid plate -> cold dark steel
    (42, 42, 42): (26, 28, 34),
    (138, 138, 138): (96, 102, 112),
    (192, 192, 192): (150, 156, 166),
    (90, 31, 31): (74, 28, 32),        # the knight's red -> deep crimson lining
    (163, 59, 59): (108, 38, 42),
    (107, 74, 46): (74, 60, 44),
    (59, 42, 31): (40, 30, 24),
    (46, 58, 68): (30, 38, 48),
}
KNIGHT_OUT = KNIGHT_MAP[(0, 0, 0)]


def recolour(im, mapping):
    out = im.copy()
    for y in range(im.height):
        for x in range(im.width):
            p = im.getpixel((x, y))
            if p[3]:
                out.putpixel((x, y), mapping.get(p[:3], p[:3]) + (255,))
    return out


def knight_sword(im, dirn):
    """A drawn greatsword: the hostile knight carries it where the story one does not."""
    m, m2 = (150, 156, 166), (96, 102, 112)
    o = KNIGHT_OUT
    if dirn == 'down':
        for y in range(4, 10):
            px(im, 13, y, m2)
            px(im, 14, y, m)
        rect(im, 12, 10, 14, 10, (140, 100, 52))   # crossguard
        px(im, 13, 11, (74, 60, 44)); px(im, 13, 12, (74, 60, 44))
        px(im, 13, 3, (206, 214, 224))              # point
        px(im, 14, 9, o)
    elif dirn == 'left':
        for y in range(3, 12):
            px(im, 1, y, m2)
            px(im, 0, y, m)
        rect(im, 0, 12, 2, 12, (140, 100, 52))
        px(im, 1, 12, (74, 60, 44))
        px(im, 1, 2, (206, 214, 224))
    else:  # up
        for y in range(4, 11):
            px(im, 2, y, m2)
            px(im, 3, y, m)
        rect(im, 1, 11, 3, 11, (140, 100, 52))
        px(im, 2, 12, (74, 60, 44))
        px(im, 3, 3, (206, 214, 224))
    return im


def make_knight():
    src = story_knight_frames()
    out = os.path.join(OUT, 'fallen_knight', 'overworld')
    os.makedirs(out, exist_ok=True)
    for dirn in ('down', 'up', 'left', 'right'):
        idle = recolour(Image.open(f'{src}/spr_fallen_knight_story_ow16_idle_{dirn}.png').convert('RGBA'), KNIGHT_MAP)
        knight_sword(idle, dirn)
        idle.save(f'{out}/spr_fallen_knight_ow16_idle_{dirn}.png')
        walk = Image.open(f'{src}/spr_fallen_knight_story_ow16_walk_{dirn}_strip4.png').convert('RGBA')
        frames = []
        for i in range(4):
            cell = recolour(walk.crop((i * 16, 0, i * 16 + 16, 24)), KNIGHT_MAP)
            frames.append(knight_sword(cell, dirn))
        strip(frames).save(f'{out}/spr_fallen_knight_ow16_walk_{dirn}_strip4.png')
    preview_from_files('fallen_knight')
    print('fallen_knight overworld ->', out)


WARDEN_MAP = {
    (18, 22, 26): (14, 18, 16),        # outline
    (142, 138, 128): (138, 148, 120),  # pale limestone -> mossy stone
    (58, 56, 52): (46, 54, 42),
    (106, 104, 96): (92, 106, 84),
    (90, 86, 78): (74, 86, 68),
    (42, 74, 40): (36, 66, 40),        # moss stays
    (62, 106, 56): (58, 98, 54),
    (62, 110, 90): (56, 104, 84),
    (42, 74, 66): (36, 66, 60),
    (138, 106, 56): (104, 92, 62),     # old brass -> weathered bronze
    (196, 164, 90): (150, 132, 88),
    (74, 138, 184): (110, 196, 126),   # eye -> verdant ward-light
    (106, 154, 120): (150, 186, 150),
}
WARDEN_OUT = WARDEN_MAP[(18, 22, 26)]
WARD = (110, 196, 126)
WARD_HI = (196, 240, 188)


def make_warden():
    src = os.path.join(OUT, 'door_warden', 'overworld')
    out = os.path.join(OUT, 'sanctuary_warden', 'overworld')
    os.makedirs(out, exist_ok=True)
    for dirn in ('down', 'up', 'left', 'right'):
        idle = recolour(Image.open(f'{src}/spr_door_warden_ow16_idle_{dirn}.png').convert('RGBA'), WARDEN_MAP)
        idle.save(f'{out}/spr_sanctuary_warden_ow16_idle_{dirn}.png')
        walk = Image.open(f'{src}/spr_door_warden_ow16_walk_{dirn}_strip4.png').convert('RGBA')
        frames = [recolour(walk.crop((i * 16, 0, i * 16 + 16, 24)), WARDEN_MAP) for i in range(4)]
        strip(frames).save(f'{out}/spr_sanctuary_warden_ow16_walk_{dirn}_strip4.png')
    preview_from_files('sanctuary_warden')
    print('sanctuary_warden overworld ->', out)


# ---------------------------------------------------------------- hand-drawn grids
def norm(rows):
    """Pad or trim every row to the 16px cell, and require 24 rows."""
    rows = [r.ljust(16, '.')[:16] for r in rows]
    if len(rows) != 24:
        raise SystemExit(f'grid has {len(rows)} rows, expected 24')
    return rows


def grid_image(rows, pal):
    im = Image.new('RGBA', (16, 24), (0, 0, 0, 0))
    for y, row in enumerate(norm(rows)):
        for x, ch in enumerate(row):
            if ch not in ' .':
                px(im, x, y, pal[ch])
    return im


def leg_swing(im, phase):
    """The same 1px lower-body swing the humanoid sets use, for anything with legs."""
    dx = (0, 1, 0, -1)[phase % 4]
    if not dx:
        return im
    out = im.copy()
    for y in range(18, 24):
        row = [im.getpixel((x, y)) for x in range(16)]
        for x in range(16):
            src = x - dx
            out.putpixel((x, y), row[src] if 0 <= src < 16 else (0, 0, 0, 0))
    return out


def bob(im, phase):
    """A 1px float for things with no feet."""
    dy = (0, -1, 0, 1)[phase % 4]
    if not dy:
        return im
    out = Image.new('RGBA', (16, 24), (0, 0, 0, 0))
    out.alpha_composite(im, (0, dy))
    return out


WOLF_PAL = {'O': (16, 18, 22), 'B': (58, 66, 76), 'D': (28, 32, 38),
            'L': (106, 116, 128), 'H': (176, 184, 192), 'E': (192, 112, 56),
            'N': (12, 14, 18)}
WOLF_DOWN = norm([
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '.....OOOO.......', '....OBLLBO......', '...OBBBBBBO.....', '...OBEBBEBO.....',
    '...OBBBBBBO.....', '....OBBBBO......', '..OBBBBBBBBO....', '.OBBBBBBBBBBO...',
    '.OBBBBBBBBBBO...', '.OBBBBBBBBBBO...', '..OBBBBBBBBO....', '..OBBO..OBBO....',
    '..OBO....OBO....', '..OBO....OBO....', '..OBO....OBO....', '..OOO....OOO....'])
WOLF_UP = norm([
    '................', '................', '................', '................',
    '................', '................', '................', '.......OO.......',
    '......OBBO......', '......OBBO......', '.....OBBBBO.....', '....OBBBBBBO....',
    '...OBBBBBBBBO...', '..OBBBBBBBBBBO..', '..OBBBBBBBBBBO..', '..OBLBBBBBLBO...',
    '..OBBBBBBBBBBO..', '..OBBBBBBBBBBO..', '..OBBBBBBBBBBO..', '..OBBO..OBBO....',
    '..OBO....OBO....', '..OBO....OBO....', '..OBO....OBO....', '..OOO....OOO....'])
WOLF_LEFT = norm([
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '..OO...OO.......', '.OBBO.OBBO......', '.OBBBBBBBBO.....', '.OBEBBBBBBBO....',
    'OOBBBBBBBBBBO...', 'OBNBBBBBBBBBBO..', '.OBBBBBBBBBBBBO.', '..OBBBBBBBBBBBO.',
    '..OBBBBBBBBBBO..', '..OBBBBBBBBBBO..', '..OBBO..OBBO....', '..OBO....OBO....',
    '..OBO....OBO....', '..OBO....OBO....', '..OBO....OBO....', '..OOO....OOO....'])

WISP_PAL = {'O': (18, 22, 26), 'B': (74, 138, 184), 'L': (142, 200, 224),
            'C': (200, 232, 248), 'W': (248, 253, 255)}
WISP_DOWN = norm([
    '................', '................', '................', '................',
    '................', '................', '.......O........', '......OBO.......',
    '.....OBLBO......', '....OBLCLBO.....', '...OBLCCC LBO...', '..OBLCCWCCLBO...',
    '...OBLCCCLBO....', '....OBLCLBO.....', '.....OBLBO......', '......OBO.......',
    '.......O........', '.....O...O......', '....O.....O.....', '................',
    '......O...O.....', '.....O.....O....', '................', '................'])
WISP_UP = norm([
    '................', '................', '................', '................',
    '................', '................', '.......O........', '......OBO.......',
    '.....OBLBO......', '....OBLCLBO.....', '...OBLC CLBO....', '..OBLC B CLBO...',
    '...OBLCCCLBO....', '....OBLCLBO.....', '.....OBLBO......', '......OBO.......',
    '.......O........', '................', '....O.....O.....', '...O.......O....',
    '................', '......O...O.....', '.......O........', '................'])
WISP_LEFT = norm([
    '................', '................', '................', '................',
    '................', '................', '......OO........', '.....OBBO.......',
    '....OBLLBO......', '....OBCCBO......', '...OBLCWCBO.....', '...OBLCWCBO.....',
    '...OBLCCLBO.....', '....OBCCBO......', '....OBLLBO......', '.....OBBO.......',
    '......OO........', '....O...O.......', '...O.....O......', '................',
    '.....O...O......', '....O.....O.....', '................', '................'])

MOTH_PAL = {'O': (14, 12, 18), 'W': (106, 90, 104), 'L': (138, 122, 136),
            'B': (58, 52, 68), 'E': (140, 46, 32)}
MOTH_DOWN = norm([
    '................', '................', '................', '................',
    '................', '....OO..........', '...OWWO..OO.....', '...OWWOOOWWO....',
    '....OO..OWWO....', '........OO......', '..OO............', '..OWWO..OO......',
    '..OWWWOOOWWO....', '...OWWO.OWWO....', '...OOO...OO.....', '.......BB.......',
    '......BBBB......', '.....BBBBBB.....', '......BBBB......', '.......BB.......',
    '..OO.......OO...', '..OWWO...OWWO...', '...OO.....OO....', '................'])
MOTH_UP = norm([
    '................', '................', '................', '................',
    '................', '................', '.....OO..OO.....', '....OWWO OWWO...',
    '....OWWO OWWO...', '.....OO...OO....', '................', '...OO....OO.....',
    '..OWWO..OWWO....', '..OWWO..OWWO....', '...OOO..OOO.....', '.....BBBBB......',
    '....BBBBBBB.....', '...BBBBBBBBB....', '....BBBBBBB.....', '.....BBBBB......',
    '..OO.......OO...', '..OWO.....OWO...', '...O.......O....', '................'])
MOTH_LEFT = norm([
    '................', '................', '................', '................',
    '................', '...OO...........', '..OWWO..OO......', '..OWWOOWWO......',
    '...OOOO WO......', '.......OWWO.....', '................', '....OO..........',
    '...OWWO..OO.....', '...OWWO OWWO....', '....OO..OWWO....', '.......BBBB.....',
    '......BBBBBB....', '.....BBBBBBBB...', '......BBBBBB....', '.......BBBB.....',
    '..OO.......OO...', '..OWO.....OWO...', '...O.......O....', '................'])

SPIDER_PAL = {'O': (14, 12, 14), 'B': (58, 50, 54), 'D': (30, 26, 28),
              'L': (207, 198, 180), 'G': (95, 168, 58), 'E': (159, 232, 112)}
SPIDER_DOWN = norm([
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '..O..O...O..O...', '..OO.OO.OO.OO...', '...OOBBBBBBOO...', '..OOBLLBBLLBOO..',
    '..OBBBBBBBBBBO..', '..OBOBBBBBBOBO..', '..O..OBBBBO..O..', '....OOBBBBOO....',
    '.....OBBBBO.....', '......OOOO......', '................', '................'])
SPIDER_UP = norm([
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '..O..O...O..O...', '..OO.OO.OO.OO...', '...OOBBBBBBOO...', '..OOBBBBBBBBOO..',
    '..OBBBBBBBBBBO..', '..OBOBBBBBBOBO..', '..O..OBBBBO..O..', '....OOBBBBOO....',
    '.....OBBBBO.....', '......OOOO......', '................', '................'])
SPIDER_LEFT = norm([
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '................', '................', '................', '................',
    '...O..O..O......', '...OO.OO.O......', '....OBBBBBO.....', '...OBBLLBBBO....',
    '..OBBBBBBBBBO...', '..OBBBBBBBBBO...', '...OBOBBBOBO....', '....OBBBBBO.....',
    '...O.OBBBO.O....', '..O...OOO...O...', '................', '................'])

HULK_PAL = {'O': (18, 20, 16), 'B': (62, 106, 56), 'D': (42, 74, 40),
            'L': (90, 138, 72), 'H': (138, 154, 112), 'W': (42, 26, 20),
            'E': (214, 122, 54), 'T': (200, 210, 160)}
HULK_DOWN = norm([
    '................', '................', '...O........O...', '..OBO......OBO..',
    '..OBBO.OO.OBBO..', '.OBBBBOBBOBBBBO.', '.OBBLBBBBBBLBBO.', '.OBBOBBBBBBOBBO.',
    '.OBO.OBBBBO.OBO.', '.OBO.OBEEBO.OBO.', '.OBBOBBBBBBOBBO.', '..OBBBBBBBBBBO..',
    '..OBLBBBBBBLBO..', '..OBBBBBBBBBBO..', '..OBBBHBBHBBBO..', '...OBBBBBBBBO...',
    '...OBBBBBBBBO...', '....OBBBBBBO....', '....OWWO WWO....', '...OWWO..OWWO...',
    '...OWO....OWO...', '...OWO....OWO...', '...OWO....OWO...', '...OOO....OOO...'])
HULK_UP = norm([
    '................', '................', '...O........O...', '..OBO......OBO..',
    '..OBBO.OO.OBBO..', '.OBBBBOBBOBBBBO.', '.OBBLBBBBBBLBBO.', '.OBBOBBBBBBOBBO.',
    '.OBBOBBBBBBOBBO.', '.OBBBBBBBBBBBBO.', '.OBBOBBBBBBOBBO.', '..OBBBBBBBBBBO..',
    '..OBLBBBBBBLBO..', '..OBBBBBBBBBBO..', '..OBBBHBBHBBBO..', '...OBBBBBBBBO...',
    '...OBBBBBBBBO...', '....OBBBBBBO....', '....OWWO WWO....', '...OWWO..OWWO...',
    '...OWO....OWO...', '...OWO....OWO...', '...OWO....OWO...', '...OOO....OOO...'])
HULK_LEFT = norm([
    '................', '................', '....O.....O.....', '...OBO...OBO....',
    '...OBBO.OBBO....', '..OBBBBOBBBBO...', '..OBBLBBBBLBBO..', '..OBBOBBBBOBBO..',
    '..OBO.OBBBO.OBO.', '..OBO.OBEBO.OBO.', '..OBBOBBBBBOBBO.', '...OBBBBBBBBBO..',
    '...OBLBBBBBBBO..', '...OBBBBBBBBBO..', '...OBBBHBBBBBO..', '....OBBBBBBBO...',
    '....OBBBBBBBO...', '.....OBBBBBO....', '.....OWWOBBO....', '....OWWO.OWO....',
    '....OWO...OWO...', '....OWO...OWO...', '....OWO...OWO...', '....OOO...OOO...'])

WRAITH_PAL = {'O': (10, 12, 16), 'H': (42, 50, 68), 'D': (28, 34, 48),
              'L': (58, 70, 92), 'S': (90, 106, 128), 'E': (196, 64, 38),
              'C': (18, 20, 26)}
WRAITH_DOWN = norm([
    '................', '......OOOO......', '.....OHHHHO.....', '....OHHLLHHO....',
    '....OHLLLLHO....', '....OHDEEDHO....', '....OHDDDDHO....', '.....OHDDHO.....',
    '...OOHHHHHHOO...', '..OHHHHHHHHHHO..', '..OHHLLHHLLHHO..', '.OHHHHHHHHHHHHO.',
    '.OHHOHHHHHHOHHO.', '.OSOOHHHHHHOOSO.', '.OSO.OHHHHO.OSO.', '.OSO.OHHHHO.OSO.',
    '..O..OHHHHO..O..', '.....OHHHHO.....', '....OHHHHHHO....', '....OHHHHHHO....',
    '...OHHHHHHHHO...', '...OHDHHHHDHO...', '..OHHOHHHHOHHO..', '..OOO.OOOO.OOO..'])
WRAITH_UP = norm([
    '................', '......OOOO......', '.....OHHHHO.....', '....OHHHHHHO....',
    '....OHLLLLHO....', '....OHLLLLHO....', '....OHHHHHHO....', '.....OHHHHO.....',
    '...OOHHHHHHOO...', '..OHHHHHHHHHHO..', '..OHHHHHHHHHHO..', '.OHHHHHHHHHHHHO.',
    '.OHHOHHHHHHOHHO.', '.OSOOHHHHHHOOSO.', '.OSO.OHHHHO.OSO.', '.OSO.OHHHHO.OSO.',
    '..O..OHHHHO..O..', '.....OHHHHO.....', '....OHHHHHHO....', '....OHHHHHHO....',
    '...OHHHHHHHHO...', '...OHHHHHHHHO...', '..OHHOHHHHOHHO..', '..OOO.OOOO.OOO..'])
WRAITH_LEFT = norm([
    '................', '.....OOOO.......', '....OHHHHO......', '...OHHLLHHO.....',
    '...OHLLLLHO.....', '...OHDEEHO......', '...OHDDDHO......', '....OHHHHO......',
    '..OOHHHHHHOO....', '.OHHHHHHHHHHO...', '.OHHLLHHHHHHO...', '.OHHHHHHHHHHHO..',
    '.OHHOHHHHHHHHO..', '.OSOOHHHHHHHO...', '.OSO.OHHHHHHO...', '.OSO.OHHHHHO....',
    '..O..OHHHHHO....', '.....OHHHHHO....', '....OHHHHHHO....', '....OHHHHHHO....',
    '...OHHHHHHHHO...', '...OHDHHHHDHO...', '..OHHOHHHHOHHO..', '..OOO.OOOO.OOO..'])

BEASTS = {
    'grey_ash_wolf': (WOLF_PAL, {'down': WOLF_DOWN, 'up': WOLF_UP, 'left': WOLF_LEFT}, 'legs'),
    'glyph_wisp': (WISP_PAL, {'down': WISP_DOWN, 'up': WISP_UP, 'left': WISP_LEFT}, 'float'),
    'night_moth_swarm': (MOTH_PAL, {'down': MOTH_DOWN, 'up': MOTH_UP, 'left': MOTH_LEFT}, 'float'),
    'spiderling': (SPIDER_PAL, {'down': SPIDER_DOWN, 'up': SPIDER_UP, 'left': SPIDER_LEFT}, 'legs'),
    'briar_hulk': (HULK_PAL, {'down': HULK_DOWN, 'up': HULK_UP, 'left': HULK_LEFT}, 'legs'),
    'shade_stalker': (WRAITH_PAL, {'down': WRAITH_DOWN, 'up': WRAITH_UP, 'left': WRAITH_LEFT}, 'float'),
}


def beast_frame(kind, dirn, phase=0):
    pal, grids, motion = BEASTS[kind]
    if dirn == 'right':
        return beast_frame(kind, 'left', phase).transpose(Image.FLIP_LEFT_RIGHT)
    im = grid_image(grids[dirn], pal)
    return leg_swing(im, phase) if motion == 'legs' else bob(im, phase)


HUMANOIDS = {
    'cutpurse': CUTPURSE,
    'dock_thug': DOCK_THUG,
    'garrison_field_surgeon': SURGEON,
    'garrison_pikeman': PIKEMAN,
}


def humanoid_frame(P, kind, dirn, phase=0):
    if dirn == 'right':
        return humanoid_frame(P, kind, 'left', phase).transpose(Image.FLIP_LEFT_RIGHT)
    im = ow_figure(P, dirn, phase, weapon=None)
    if kind == 'cutpurse':
        hood(im, P, dirn)
        face_mask(im, P, dirn)
        belt_dagger(im, P, dirn)
        cut_purse(im, P, dirn)
    elif kind == 'dock_thug':
        knit_cap(im, P, dirn)
        rolled_sleeves(im, P, dirn)
        belaying_pin(im, P, dirn)
    elif kind == 'garrison_field_surgeon':
        surgeon_cap(im, P, dirn)
        surgeon_apron(im, P, dirn)
    elif kind == 'garrison_pikeman':
        pikeman_helm(im, P, dirn)
        tabard(im, P, dirn)
        pike(im, P, dirn)
    return im


# ---------------------------------------------------------------- output
def preview_sheet(name, frames_by_dir, title):
    scale, fw, fh = 8, 16, 24
    pad, lab = 12, 20
    W = (fw * 5 + pad * 2) * scale + pad
    H = 4 * (fh * scale + lab + pad) + 40
    sheet = Image.new('RGBA', (W, H), (22, 22, 28, 255))
    d = ImageDraw.Draw(sheet)
    d.text((pad, 10), title, fill=(230, 230, 230, 255))
    y = 34
    for label, strip_im in frames_by_dir:
        d.text((pad, y), label, fill=(200, 200, 210, 255))
        y += lab
        for i in range(5):
            cell = Image.new('RGBA', (fw, fh), (34, 34, 44, 255) if i == 0 else (44, 44, 56, 255))
            cell.alpha_composite(strip_im.crop((i * fw, 0, (i + 1) * fw, fh)))
            sheet.alpha_composite(cell.resize((fw * scale, fh * scale), Image.NEAREST),
                                  (pad + i * (fw * scale + 4), y))
        y += fh * scale + pad
    sheet.convert('RGB').save(os.path.join(OUT, name, 'overworld', f'{name}_ow16_preview.png'))


def preview_from_files(name):
    d = os.path.join(OUT, name, 'overworld')
    rows = []
    for dirn in ('down', 'up', 'left', 'right'):
        idle = Image.open(f'{d}/spr_{name}_ow16_idle_{dirn}.png').convert('RGBA')
        walk = Image.open(f'{d}/spr_{name}_ow16_walk_{dirn}_strip4.png').convert('RGBA')
        rows.append((f'{dirn}: idle + walk 4', strip([idle] + [walk.crop((i * 16, 0, i * 16 + 16, 24))
                                                             for i in range(4)])))
    preview_sheet(name, rows, f'{name.upper()} overworld 16x24 (idle | walk x4), origin (8,23)')


def write_set(name, frame_fn):
    out = os.path.join(OUT, name, 'overworld')
    os.makedirs(out, exist_ok=True)
    rows = []
    for dirn in ('down', 'up', 'left', 'right'):
        idle = frame_fn(dirn, 0)
        walk = [frame_fn(dirn, i) for i in range(4)]
        idle.save(os.path.join(out, f'spr_{name}_ow16_idle_{dirn}.png'))
        strip(walk).save(os.path.join(out, f'spr_{name}_ow16_walk_{dirn}_strip4.png'))
        rows.append((f'{dirn}: idle + walk 4', strip([idle] + walk)))
    preview_sheet(name, rows, f'{name.upper()} overworld 16x24 (idle | walk x4), origin (8,23)')
    print('wrote', name)


def contact_sheet(names):
    cells = []
    for name in names:
        d = os.path.join(OUT, name, 'overworld')
        for dirn in ('down', 'up', 'right', 'left'):
            idle = Image.open(f'{d}/spr_{name}_ow16_idle_{dirn}.png').convert('RGBA')
            walk = Image.open(f'{d}/spr_{name}_ow16_walk_{dirn}_strip4.png').convert('RGBA')
            cells.append((name, dirn, idle, walk))
    scale = 4
    cw, ch = 16 * scale, 24 * scale
    pad, lab = 10, 14
    cols = 4
    rows = (len(cells) + cols - 1) // cols
    W = pad + cols * (cw * 5 + pad)
    H = pad + rows * (ch + lab + pad)
    sheet = Image.new('RGBA', (W, H), (22, 22, 28, 255))
    d = ImageDraw.Draw(sheet)
    for i, (name, dirn, idle, walk) in enumerate(cells):
        gx, gy = i % cols, i // cols
        x0 = pad + gx * (cw * 5 + pad)
        y0 = pad + gy * (ch + lab + pad)
        d.text((x0, y0), f'{name} {dirn}', fill=(220, 214, 196))
        frame = Image.new('RGBA', (16 * 5, 24), (0, 0, 0, 0))
        frame.alpha_composite(idle, (0, 0))
        for k in range(4):
            frame.alpha_composite(walk.crop((k * 16, 0, k * 16 + 16, 24)), (16 + k * 16, 0))
        sheet.alpha_composite(frame.resize((frame.width * scale, frame.height * scale),
                                           Image.NEAREST), (x0, y0 + lab))
    out = os.path.abspath(os.path.join(SPR, '..', '..', 'artifacts', 'enemy_ow_remaining.png'))
    sheet.convert('RGB').save(out)
    print('contact sheet ->', out)


if __name__ == '__main__':
    for kind, P in HUMANOIDS.items():
        write_set(kind, lambda d, ph, k=kind, p=P: humanoid_frame(p, k, d, ph))
    make_knight()
    make_warden()
    for kind in BEASTS:
        write_set(kind, lambda d, ph, k=kind: beast_frame(k, d, ph))
    contact_sheet(list(HUMANOIDS) + ['fallen_knight', 'sanctuary_warden'] + list(BEASTS))
