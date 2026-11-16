"""Shared pixel-art kit for the two party members who had no art (Sera, Caelan).

Style follows the existing flat-colour placeholder sets in this repo (see lyra.py):
hard pixels, one dark outline colour, three to five shades per material, no anti-aliasing.
Silhouettes are deliberately different per character so they read apart at 16x24:

  Sera    silver guard coat, bright pauldrons, long holy sword, pale hair
  Caelan  long dark-blue robe, staff with a lit crystal, short dark hair

Overworld: 16x24, four directions, idle + 4 walk frames.
Battle:    32x48 idle/walk/hurt/defend, 48x48 attack/death (party faces right).
Portraits: 48x48 bust, three expressions.

Run the per-character scripts (sera.py, caelan.py, portraits.py), not this file.
"""
from PIL import Image
import os

HERE = os.path.dirname(__file__)
SPR = os.path.abspath(os.path.join(HERE, '..'))


def canvas(w, h):
    return Image.new('RGBA', (w, h), (0, 0, 0, 0))


def px(im, x, y, c):
    if 0 <= x < im.width and 0 <= y < im.height:
        im.putpixel((int(x), int(y)), tuple(c) + (255,) if len(c) == 3 else c)


def rect(im, x0, y0, x1, y1, c):
    for y in range(int(y0), int(y1) + 1):
        for x in range(int(x0), int(x1) + 1):
            px(im, x, y, c)


def strip(frames):
    w, h = frames[0].size
    im = Image.new('RGBA', (w * len(frames), h), (0, 0, 0, 0))
    for i, f in enumerate(frames):
        im.paste(f, (i * w, 0))
    return im


# ================================================================ overworld 16x24
# ---------------------------------------------------------------- 16x24 templates
# Proportions and construction are transcribed from the hand-drawn Taren set
# (npcs/taren/spr_taren_ow16_idle_*): a 6px hair cap, 4px eyes-and-face band, collar
# row, two arm columns outside a 10px torso, belt row, two legs with a gap, boots on
# the ground line. Letters are meaningful, not Taren's colours.
OW_DOWN = """
................
.....OOOOOO.....
....OHHHHHHO....
...OHIIIIIIHO...
..OHIHHHHHHIHO..
..OHHHHHHHHHHO..
..OHSSSSSSSSHO..
..OHSSOSSOSSHsO.
..OtSSSSSSSStJO.
...OtSSSSSStOJO.
..OmMmmmmmmMsssO
.OAABCCCCCCBAAO.
.OBBCCKCCKCCBBO.
.OBNCCCCCCCCNBO.
.OBNkLLLLLLkNBO.
.OSSPpPppPpPSSO.
..OPpPpPPpPpPO..
..OQqQqqqqQqQO..
...OQqOOOOqQO...
...OQqO..OqQO...
...OQqO..OqQO...
..OUUJO..OJUUO..
..OUUUO..OUUUO..
...OOO....OOO...
"""
OW_LEFT = """
................
......OOOO......
.....OHHHHO.....
....OHIIIIHO....
...OHIHHHIIHO...
..OHHHHHHHHHO...
..OHSHHHHHHHO...
.OSSOSStHHHsO...
.OSSSSStHHJJO...
..OSSSttHJOJO...
...OOOmmMmsssO..
....OBKCCApOO...
....OBACCCpO....
....ONACKCpO....
....ONALLLpO....
....OSApPpPO....
.....OpPpppO....
.....OqqqQQO....
......OOOOO.....
.....OqQOQO.....
.....OqQOQO.....
.....OJJJOJO....
....OUUUUOUO....
.....OOOOOO.....
"""
OW_UP = """
................
.....OOOOOO.....
....OHHHHHHO....
...OHHHHHHHHO...
..OHHHHHHHHHHO..
..OHHHHHHHHHHO..
.OsHHHHHHHHHHO..
.OJHHHHHHHHHHO..
OOJJHHHHHHHHJO..
JJJJJHHHHHHJO...
OOOmpmmmmmmMmO..
.OAABpCCCCCBAAO.
.OBBCCpCCKCCBBO.
.OBBCCCpCCCCBBO.
.OBBkLLpLLLkBBO.
.OSSPpPppPpPSSO.
..OPpPpPPpPpPO..
..OQqQqqqqpqQO..
...OQqOOOOqpO...
...OQqO..OqQpO..
...OQqO..OqQO...
..OUUJO..OJUUO..
..OUUUO..OUUUO..
...OOO....OOO...
"""
OW_TEMPLATE = {'down': OW_DOWN, 'left': OW_LEFT, 'up': OW_UP}


def _shade(c, f):
    return tuple(max(0, min(255, int(v * f))) for v in c[:3])


def _lift(c, f):
    return tuple(min(255, int(v + (255 - v) * f)) for v in c[:3])


def ow_palette(P):
    """Map the template letters onto a character's palette."""
    return {
        'O': P['out'],
        'H': P['hair'], 'I': _lift(P['hair'], 0.22), 'J': P.get('hair2', _shade(P['hair'], 0.7)),
        'S': P['skin'], 's': P['skin2'], 't': _shade(P['skin2'], 0.85),
        'M': P['trim'], 'm': _shade(P['trim'], 0.78),
        'A': _shade(P['coat'], 0.88), 'B': _shade(P['coat'], 0.68), 'C': P['coat'],
        'K': P['trim'], 'N': P['metal'],
        'L': P['wood'], 'k': _shade(P['wood'], 0.7),
        'P': P['pants'], 'p': _lift(P['pants'], 0.18),
        'Q': _shade(P['pants'], 0.82), 'q': _shade(P['pants'], 0.66),
        'U': P['boot'],
    }


def _ow_rows(P, dirn, phase):
    rows = [list(r) for r in OW_TEMPLATE[dirn].strip('\n').split('\n')]
    w = 16

    # per-character silhouette changes, applied before the walk offsets
    if P.get('long_hair'):
        for y in range(10, 14):
            for x in (2, 3, 12, 13):
                if 0 <= y < 24 and rows[y][x] not in ' .':
                    rows[y][x] = 'J' if x in (2, 13) else 'H'
            if dirn == 'left':
                for x in (10, 11):
                    rows[y][x] = 'J'
    if P.get('robe'):
        for y in (17, 18):
            for x in range(2, 14):
                rows[y][x] = 'C'
        for x in range(2, 14):
            rows[19][x] = 'O' if x in (2, 13) else 'B'
    if P.get('pauldron'):
        for x in (2, 3, 12, 13):
            rows[10][x] = 'N'
            rows[11][x] = 'N' if x in (3, 12) else rows[11][x]

    # walk: swing the two leg groups in opposite directions, feet only
    dx = (0, 1, 0, -1)[phase % 4]
    if dx:
        for y in range(19, 24):
            left = [rows[y][x] for x in range(0, 8)]
            right = [rows[y][x] for x in range(8, 16)]
            rows[y] = (['.'] + left[:-1] if dx > 0 else left[1:] + ['.']) + \
                      (right[1:] + ['.'] if dx > 0 else ['.'] + right[:-1])
    return rows


def ow_figure(P, dirn, phase=0, weapon='sword'):
    """16x24 overworld frame; phase 0..3, 0 is the idle stance."""
    if dirn == 'right':                      # the left art mirrors cleanly
        return ow_figure(P, 'left', phase, weapon).transpose(Image.FLIP_LEFT_RIGHT)
    rows = _ow_rows(P, dirn, phase)
    pal = ow_palette(P)
    im = canvas(16, 24)
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch not in ' .':
                px(im, x, y, pal[ch])

    # weapons sit on top of the body the way Taren's hilt does, so silhouettes stay
    # distinguishable without breaking the 16px cell
    if weapon == 'staff':
        sx = 14 if dirn != 'left' else 1
        rect(im, sx, 1, sx, 20, P['wood'])
        rect(im, sx - 1, 0, sx + 1, 1, P['crystal'])
        px(im, sx, 0, P['crystal2'])
        px(im, sx if dirn != 'left' else 1, 15, P['skin'])
    elif weapon == 'sword':
        bx = 13 if dirn != 'left' else 2
        rect(im, bx, 4, bx, 9, P['metal'])
        px(im, bx, 3, P['metal2'])
        rect(im, bx - 1, 10, bx + 1, 10, P.get('trim', P['metal']))
        rect(im, bx, 11, bx, 13, P['wood'])
    elif weapon == 'daggers':
        for hx, hy in ((3, 16), (12, 16)):
            px(im, hx, hy, P['metal'])
            px(im, hx, hy + 1, P['metal2'])
            px(im, hx, hy - 1, P['trim'])
        if dirn == 'up':
            px(im, 4, 14, P['metal']); px(im, 11, 14, P['metal'])
        if dirn == 'left':
            px(im, 10, 15, P['metal'])
    return im


# ================================================================ battle 32x48
def _outline(im, col):
    out = im.copy()
    filled = [(x, y) for y in range(im.height) for x in range(im.width) if im.getpixel((x, y))[3]]
    for (x, y) in filled:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < im.width and 0 <= ny < im.height and not out.getpixel((nx, ny))[3]:
                out.putpixel((nx, ny), tuple(col[:3]) + (255,))
    return out


def bt_figure(P, w, h, weapon='sword', crouch=0, lean=0, arm_ext=0, fallen=0.0, stride=0):
    """Battle frame on a w x h cell, party facing right.

    Construction: 9px head on 14px shoulders, 12px torso, 3px limbs, boots on the ground
    line. crouch 0..3 sinks the body and bends the knees, lean shifts the upper body,
    arm_ext pushes the weapon forward, fallen 0..1 tips the figure onto the floor.
    """
    im = canvas(w, h)
    base_x = 6 if w <= 32 else 12          # wider cells give the attack swing room
    ground = h - 1
    crouch = max(0, min(3, int(crouch)))

    hx = base_x + lean + 3                 # head left edge
    hy = 4 + crouch                        # head top
    ty0 = hy + 15                           # shoulders
    ty1 = hy + 28                           # belt
    ux = base_x + lean

    # ---- legs (bent by crouch, boots on the ground line)
    leg_top = ty1 + 1
    knee = (leg_top + ground) // 2
    stride = max(-3, min(3, int(stride)))
    back_x, front_x = ux + 3, ux + 8 + stride
    back_lift = 1 if stride < 0 else 0
    front_lift = 1 if stride > 0 else 0
    if fallen < 0.5:
        rect(im, back_x, leg_top, back_x + 2, ground - 2 - back_lift, P['pants'])
        rect(im, front_x, leg_top, front_x + 2, ground - 2 - front_lift, P['pants'])
        rect(im, back_x, knee - 1, front_x + 2, knee, P['pants'])       # knee/thigh mass
        rect(im, back_x - 1, ground - 1 - back_lift, back_x + 3, ground - back_lift, P['boot'])
        rect(im, front_x, ground - 1 - front_lift, front_x + 4, ground - front_lift, P['boot'])
        rect(im, back_x, leg_top, back_x + 2, leg_top + 2, P['coat2'])  # coat tails
        rect(im, front_x, leg_top, front_x + 2, leg_top + 2, P['coat2'])
        if crouch:
            rect(im, back_x - 1, knee, back_x - 1, knee + 1 + crouch, P['pants'])
            rect(im, front_x + 3, knee, front_x + 3, knee + 1 + crouch, P['pants'])

    # ---- torso
    rect(im, ux + 1, ty0, ux + 14, ty0 + 2, P['coat'])                 # shoulders
    rect(im, ux + 2, ty0 + 2, ux + 13, ty1, P['coat'])                 # chest
    rect(im, ux + 2, ty1 - 2, ux + 13, ty1, P['coat2'])                # hem
    rect(im, ux + 3, ty0 + 1, ux + 12, ty0 + 1, P['coat2'])            # collar
    if P.get('robe'):
        rect(im, ux + 1, ty0, ux + 14, ty1 + 2, P['coat'])
        rect(im, ux, ty1 + 1, ux + 15, ty1 + 3, P['coat2'])
        rect(im, ux, ty1 + 3, ux + 15, ty1 + 3, P['trim'])
    else:
        rect(im, ux + 2, ty1 - 4, ux + 13, ty1 - 3, P['trim'])         # belt
        px(im, ux + 7, ty1 - 4, P['metal'])
    if P.get('pauldron'):
        rect(im, ux + 1, ty0, ux + 4, ty0 + 2, P['metal'])
        rect(im, ux + 11, ty0, ux + 14, ty0 + 2, P['metal'])

    # ---- back arm, then the sword arm reaching forward
    rect(im, ux, ty0 + 3, ux + 1, ty1 - 3, P['coat2'])
    rect(im, ux, ty1 - 2, ux + 1, ty1 - 1, P['skin'])
    fx = ux + 14 + arm_ext
    rect(im, ux + 13, ty0 + 3, fx, ty0 + 4, P['coat2'])                # upper arm
    rect(im, fx - 1, ty0 + 4, fx, ty0 + 6, P['coat2'])                 # forearm
    rect(im, fx, ty0 + 7, fx + 1, ty0 + 8, P['skin'])                  # fist

    # ---- head: hair cap over a short face band, so it does not read as a block
    rect(im, hx - 1, hy, hx + 9, hy + 5, P['hair'])
    rect(im, hx, hy + 5, hx + 8, hy + 12, P['skin'])
    rect(im, hx + 1, hy + 12, hx + 7, hy + 12, P['skin2'])
    px(im, hx + 3, hy + 8, P['out'])                                   # eyes
    px(im, hx + 6, hy + 8, P['out'])
    px(im, hx + 5, hy + 10, P['skin2'])                                # nose
    px(im, hx + 4, hy + 11, P['skin2'])                                # mouth
    rect(im, hx, hy + 5, hx, hy + 9, P['hair2'])                       # nape
    if P.get('long_hair') or P.get('ponytail'):
        rect(im, hx - 2, hy + 4, hx - 1, hy + 16, P['hair2'])
        rect(im, hx + 9, hy + 4, hx + 10, hy + 16, P['hair'])
    rect(im, hx + 3, hy + 13, hx + 5, hy + 14, P['skin2'])             # neck

    # ---- weapon in the sword hand
    if weapon == 'sword':
        rect(im, fx + 2, hy - 2, fx + 2, ty0 + 5, P['metal'])
        px(im, fx + 2, hy - 3, P['metal2'])
        rect(im, fx + 1, ty0 + 5, fx + 3, ty0 + 5, P['trim'])          # guard
        rect(im, fx + 2, ty0 + 6, fx + 2, ty0 + 8, P['wood'])
    elif weapon == 'staff':
        rect(im, fx + 2, hy - 6, fx + 2, ty1 + 2, P['wood'])
        rect(im, fx + 1, hy - 9, fx + 3, hy - 7, P['crystal'])
        px(im, fx + 2, hy - 10, P['crystal2'])
    elif weapon == 'daggers':
        rect(im, fx + 2, ty0 + 2, fx + 5, ty0 + 3, P['metal'])         # forward blade
        px(im, fx + 6, ty0 + 2, P['metal2'])
        rect(im, fx + 2, ty0 + 4, fx + 3, ty0 + 4, P['trim'])
        rect(im, ux, ty0 + 5, ux, ty0 + 7, P['metal'])                 # off-hand blade
        px(im, ux, ty0 + 4, P['metal2'])

    out = _outline(im, P['out'])
    if fallen:
        out = out.rotate(-90 * fallen, resample=Image.NEAREST, center=(w // 2, h - 16))
    return out


# ================================================================ portraits 48x48
EXPRESSIONS = ('neutral', 'determined', 'pained')


def portrait(P, expr='neutral'):
    """48x48 bust: head, hair (short / long / tied), three expressions."""
    im = canvas(48, 48)
    hair, hair2, skin, skin2 = P['hair'], P.get('hair2', P['hair']), P['skin'], P['skin2']

    # shoulders and collar
    rect(im, 6, 39, 41, 47, P['coat'])
    rect(im, 8, 39, 39, 40, P['coat2'])
    rect(im, 14, 37, 33, 40, P['trim'])
    rect(im, 21, 33, 26, 38, skin2)                      # neck
    rect(im, 20, 36, 27, 37, skin2)

    # face
    rect(im, 13, 11, 34, 34, skin)
    rect(im, 13, 11, 34, 13, _shade(skin, 0.92))
    rect(im, 12, 29, 14, 33, skin2)                      # cheek shadows
    rect(im, 33, 29, 35, 33, skin2)
    rect(im, 15, 33, 32, 34, skin2)                      # jaw
    rect(im, 17, 35, 30, 36, skin2)

    # brows and eyes, per expression
    for ex, ey in ((18, 21), (28, 21)):
        if expr == 'neutral':
            rect(im, ex, 18, ex + 3, 18, hair2)
            rect(im, ex, ey + 1, ex + 3, ey + 2, P['out'])
        elif expr == 'determined':
            rect(im, ex, 18, ex + 3, 18, hair2)
            px(im, ex + (3 if ex < 24 else 0), 17, hair2)
            rect(im, ex, ey + 1, ex + 3, ey + 2, P['out'])
            px(im, ex + 1, ey, skin2)
        else:
            rect(im, ex, 17, ex + 3, 17, hair2)
            px(im, ex + (3 if ex < 24 else 0), 18, hair2)
            rect(im, ex, ey + 2, ex + 3, ey + 2, P['out'])
            px(im, ex + 2, ey + 1, P['out'])
    # nose
    rect(im, 23, 24, 23, 27, skin2)
    px(im, 24, 27, skin2)
    # mouth
    if expr == 'neutral':
        rect(im, 21, 30, 26, 30, hair2)
    elif expr == 'determined':
        rect(im, 21, 30, 26, 30, hair2)
        px(im, 21, 31, hair2); px(im, 26, 31, hair2)
    else:
        rect(im, 21, 29, 26, 32, _shade(P['out'], 1.0))
        rect(im, 22, 31, 25, 31, _lift(P['out'], 0.25))

    # hair: cap plus a style, drawn over the face edges
    rect(im, 11, 6, 36, 14, hair)
    rect(im, 12, 5, 35, 7, hair)
    rect(im, 13, 4, 34, 5, _lift(hair, 0.18))
    rect(im, 10, 12, 12, 26, hair)                     # temple locks
    rect(im, 35, 12, 37, 26, hair)
    if P.get('long_hair'):
        rect(im, 8, 20, 12, 40, hair2)
        rect(im, 35, 20, 39, 40, hair2)
        rect(im, 9, 22, 11, 38, hair)
        rect(im, 36, 22, 38, 38, hair)
    if P.get('ponytail'):
        rect(im, 36, 10, 39, 30, hair2)
        rect(im, 38, 14, 41, 28, hair)
        px(im, 37, 10, P['trim']); px(im, 37, 11, P['trim'])
    if not P.get('long_hair') and not P.get('ponytail'):
        rect(im, 10, 12, 13, 21, hair)                 # short sides
        rect(im, 34, 12, 37, 21, hair)

    return _outline(im, P['out'])


def save_overworld(P, stem, weapon='sword', folder='npcs'):
    od = os.path.join(SPR, folder, stem)
    os.makedirs(od, exist_ok=True)
    for dirn in ('down', 'up', 'left', 'right'):
        ow_figure(P, dirn, 0, weapon).save(f'{od}/spr_{stem}_ow16_idle_{dirn}.png')
        frames = [ow_figure(P, dirn, ph, weapon) for ph in (1, 2, 3, 2)]
        strip(frames).save(f'{od}/spr_{stem}_ow16_walk_{dirn}_strip4.png')
    return od


def save_battle(P, stem, weapon='sword', folder='party'):
    pd = os.path.join(SPR, folder, stem)
    os.makedirs(pd, exist_ok=True)
    idle = [dict(), dict(crouch=1), dict(), dict(crouch=1)]
    strip([bt_figure(P, 32, 48, weapon=weapon, **k) for k in idle]).save(f'{pd}/spr_{stem}_idle_strip4.png')

    walk = []
    for i, st in enumerate((0, 1, 2, 1, 0, -1, -2, -1)):
        walk.append(dict(crouch=1 if st in (1, -1) else 0, lean=1 if st > 0 else 0, stride=st))
    strip([bt_figure(P, 32, 48, weapon=weapon, **k) for k in walk]).save(f'{pd}/spr_{stem}_walk_strip8.png')

    attack = [dict(lean=-4, arm_ext=-2), dict(lean=3, arm_ext=6), dict(lean=5, arm_ext=10),
              dict(lean=4, arm_ext=8), dict(lean=1, arm_ext=2), dict()]
    strip([bt_figure(P, 48, 48, weapon=weapon, **k) for k in attack]).save(f'{pd}/spr_{stem}_attack_strip6.png')

    hurt = [dict(lean=-6, crouch=1), dict(lean=-8, crouch=2), dict(lean=-5, crouch=1)]
    strip([bt_figure(P, 32, 48, weapon=weapon, **k) for k in hurt]).save(f'{pd}/spr_{stem}_hurt_strip3.png')

    defend = [dict(crouch=2, arm_ext=-1), dict(crouch=3, arm_ext=0), dict(crouch=2, arm_ext=-1)]
    strip([bt_figure(P, 32, 48, weapon=weapon, **k) for k in defend]).save(f'{pd}/spr_{stem}_defend_strip3.png')

    death = [dict(lean=-4, crouch=1), dict(lean=-7, crouch=3), dict(lean=-6, fallen=0.3),
             dict(fallen=0.55), dict(fallen=0.8), dict(fallen=1.0)]
    strip([bt_figure(P, 48, 48, weapon=weapon, **k) for k in death]).save(f'{pd}/spr_{stem}_death_strip6.png')
    return pd


def save_portraits(P, stem):
    od = os.path.join(SPR, 'portraits', stem)
    os.makedirs(od, exist_ok=True)
    for expr in EXPRESSIONS:
        portrait(P, expr).save(f'{od}/spr_portrait_{stem}_{expr}.png')
    return od
