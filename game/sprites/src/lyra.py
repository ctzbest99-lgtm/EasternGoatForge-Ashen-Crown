"""Lyra Veyne placeholder sprites (flat colour, per repo placeholder conventions).

Overworld: 16x24, 4 directions, 1 idle + 4 walk frames  -> game/sprites/npcs/lyra/
Battle:    32x48 idle/walk/hurt/defend, 48x48 attack/death -> game/sprites/party/lyra/

Design's Lyra art has not landed; this flat-colour set exists so Lyra can walk
Valemere and fight the Debtman. Replace wholesale when Design's set arrives.
Run from game/sprites/:  python3 src/lyra.py
"""
from PIL import Image
import os, sys

HERE = os.path.dirname(__file__)
SPR = os.path.abspath(os.path.join(HERE, '..'))

# palette
HAIR = (74, 38, 28)
HAIR2 = (94, 50, 36)
SKIN = (232, 180, 140)
TUNIC = (47, 74, 60)
TUNIC2 = (38, 60, 49)
BELT = (85, 67, 42)
PANTS = (58, 54, 48)
BOOT = (36, 31, 26)
BLADE = (200, 204, 208)
HILT = (107, 82, 50)
OUT = (24, 20, 18)

def canvas(w, h):
    return Image.new('RGBA', (w, h), (0, 0, 0, 0))

def px(im, x, y, c):
    if 0 <= x < im.width and 0 <= y < im.height:
        im.putpixel((int(x), int(y)), c + (255,))

def rect(im, x0, y0, x1, y1, c):
    for y in range(int(y0), int(y1) + 1):
        for x in range(int(x0), int(x1) + 1):
            px(im, x, y, c)

# ---------------------------------------------------------------- overworld 16x24
def ow_body(im, dirn, leg_phase=0, arm_phase=0):
    """dirn: down/up/left/right. leg_phase 0..3 (walk), arm swing follows."""
    cx = 8
    # legs (rows 17-22)
    lo, ro = 0, 0
    if leg_phase == 1: lo, ro = 1, -1
    if leg_phase == 3: lo, ro = -1, 1
    rect(im, cx-2, 17, cx-1 + lo, 22, PANTS)
    rect(im, cx, 17, cx+1 + ro, 22, PANTS)
    rect(im, cx-2, 22, cx-1 + lo, 23, BOOT)
    rect(im, cx, 22, cx+1 + ro, 23, BOOT)
    # torso (rows 10-16): tunic with belt
    rect(im, cx-3, 10, cx+2, 15, TUNIC)
    rect(im, cx-3, 14, cx+2, 14, BELT)
    rect(im, cx-1, 11, cx, 13, TUNIC2)
    # arms (rows 11-15)
    aswing = arm_phase
    rect(im, cx-4, 11+aswing, cx-4, 15, TUNIC2)
    rect(im, cx+3, 11-aswing, cx+3, 15, TUNIC2)
    # head (rows 3-9)
    rect(im, cx-2, 4, cx+1, 8, SKIN)
    # hair: cap + sides (long-ish, tied back)
    rect(im, cx-3, 2, cx+2, 4, HAIR)
    if dirn == 'up':
        rect(im, cx-2, 4, cx+1, 8, HAIR)  # back of the head
        rect(im, cx-3, 4, cx-3, 9, HAIR2)
        rect(im, cx+2, 4, cx+2, 9, HAIR2)
    elif dirn == 'down':
        rect(im, cx-3, 4, cx-2, 7, HAIR)
        rect(im, cx+1, 4, cx+2, 7, HAIR)
        rect(im, cx-3, 2, cx-2, 9, HAIR2)  # loose strands
        px(im, cx-1, 6, OUT); px(im, cx, 6, OUT)  # eyes
        px(im, cx-1, 8, OUT)                     # mouth
    elif dirn == 'left':
        rect(im, cx-1, 4, cx+2, 7, HAIR)   # hair covers right side
        rect(im, cx+2, 4, cx+2, 10, HAIR2)  # ponytail behind
        px(im, cx-2, 6, OUT)
    else:  # right
        rect(im, cx-3, 4, cx, 7, HAIR)
        rect(im, cx-3, 4, cx-3, 10, HAIR2)
        px(im, cx+1, 6, OUT)
    # dagger at the belt (down/left/right views)
    if dirn != 'up':
        px(im, cx+2, 15, HILT)
        px(im, cx+2, 14, BLADE)

def ow_set(dirn, walk_offsets):
    idle = canvas(16, 24)
    ow_body(idle, dirn)
    frames = [idle]
    for ph in (1, 2, 3, 2):
        f = canvas(16, 24)
        ow_body(f, dirn, leg_phase=ph, arm_phase=(1 if ph in (1, 3) else 0))
        frames.append(f)
    return frames

def save_strips(frames, path, fw, fh):
    n = len(frames)
    strip = Image.new('RGBA', (fw * n, fh), (0, 0, 0, 0))
    for i, f in enumerate(frames):
        strip.paste(f, (i * fw, 0))
    strip.save(path)
    return n

# ---------------------------------------------------------------- battle 32x48 / 48x48
def bt_body(im, w, h, lean=0, crouch=0, arm_ext=0, dagger=True, fallen=0):
    """Front-facing battle figure. lean: px shift of torso/head (+ = forward/right).
    crouch: rows to drop the figure. arm_ext: dagger arm extension. fallen: 0..1 collapse."""
    cx = w // 2 + 6  # slightly right of centre (party faces right)
    base = h - 3     # ground row
    if fallen >= 0.99:
        # fully down: the final flattened heap (every death frame shows a body)
        rect(im, cx-7, base-3, cx+8, base-1, TUNIC)
        rect(im, cx-6, base-2, cx+6, base, TUNIC2)
        rect(im, cx-4, base-4, cx+1, base-2, HAIR)
        rect(im, cx+2, base-2, cx+5, base-1, BOOT)
        return
    if fallen > 0:
        # collapse: squash the figure toward the floor
        hh = int((h - 8) * (1.0 - fallen))
        if hh < 4: hh = 4
        rect(im, cx-6, base-4, cx+7, base-1, TUNIC)   # crumpled heap
        rect(im, cx-5, base-3, cx+4, base-2, TUNIC2)
        rect(im, cx-3, base-5, cx+2, base-4, HAIR)     # head resting
        return
    top = 5 + crouch
    # legs
    rect(im, cx-4, 30-crouch, cx-1, base-1, PANTS)
    rect(im, cx+1, 30-crouch, cx+4, base-1, PANTS)
    rect(im, cx-4, base-1, cx-1, base, BOOT)
    rect(im, cx+1, base-1, cx+4, base, BOOT)
    # torso (extends under the head so leaning never opens a gap)
    rect(im, cx-5+lean//2, 19-crouch+lean//2, cx+4+lean//2, 30-crouch, TUNIC)
    rect(im, cx-5, 26-crouch, cx+4, 26-crouch, BELT)
    rect(im, cx-2, 21-crouch, cx+1, 24-crouch, TUNIC2)
    # back arm (behind torso)
    rect(im, cx-7, 20-crouch, cx-4, 27-crouch, TUNIC2)  # overlaps the torso: no gap when leaning
    # head (drawn after the torso so it overlaps it, not the reverse)
    hx = cx + lean
    # neck: bridges head bottom to torso top in every pose (no gap while leaning)
    rect(im, hx-2, top+9, hx+1, 20-crouch, SKIN)
    rect(im, hx-4, top+2, hx+3, top+10, SKIN)
    rect(im, hx-5, top, hx+4, top+3, HAIR)
    rect(im, hx-5, top+3, hx-4, top+9, HAIR)
    rect(im, hx+3, top+3, hx+4, top+9, HAIR)
    rect(im, hx-5, top+9, hx-4, top+12, HAIR2)  # strands
    rect(im, hx+3, top+9, hx+4, top+12, HAIR2)
    px(im, hx-2, top+6, OUT); px(im, hx+1, top+6, OUT)
    # front arm + dagger, extended by arm_ext
    ax = cx + 5 + arm_ext
    rect(im, cx+5, 20-crouch, ax, 21-crouch, TUNIC2)
    rect(im, cx+5, 21-crouch, ax, 22-crouch, SKIN)
    if dagger:
        dx = ax + 1
        dy = 20 - crouch
        rect(im, dx, dy, dx+3, dy, BLADE)      # blade pointing right
        rect(im, dx, dy+1, dx+1, dy+1, HILT)
        rect(im, dx, dy-1, dx, dy+2, BLADE)

def bt_frames(specs, fw, fh):
    out = []
    for kwargs in specs:
        f = canvas(fw, fh)
        bt_body(f, fw, fh, **kwargs)
        out.append(f)
    return out

if __name__ == '__main__':
    random = __import__('random')
    # ---- overworld ----
    od = os.path.join(SPR, 'npcs', 'lyra')
    os.makedirs(od, exist_ok=True)
    for dirn in ('down', 'up', 'left', 'right'):
        frames = ow_set(dirn, None)
        frames[0].save(f'{od}/spr_lyra_ow16_idle_{dirn}.png')
        save_strips(frames[1:], f'{od}/spr_lyra_ow16_walk_{dirn}_strip4.png', 16, 24)
    # ---- battle ----
    pd = os.path.join(SPR, 'party', 'lyra')
    os.makedirs(pd, exist_ok=True)
    # idle 4 (breathe)
    save_strips(bt_frames([{}, {'crouch': 1}, {}, {'crouch': 1}], 32, 48), f'{pd}/spr_lyra_idle_strip4.png', 32, 48)
    # walk 8 (bob + slight lean)
    walk = []
    for i in range(8):
        ph = i % 4
        crouch = 1 if ph in (1, 3) else 0
        walk.append({'crouch': crouch, 'lean': 1 if ph == 2 else 0})
    save_strips(bt_frames(walk, 32, 48), f'{pd}/spr_lyra_walk_strip8.png', 32, 48)
    # attack 6 (48x48): windup, thrust x2, hold, recover
    save_strips(bt_frames([
        {'lean': -4, 'arm_ext': -2},
        {'lean': 3, 'arm_ext': 6},
        {'lean': 5, 'arm_ext': 10},
        {'lean': 4, 'arm_ext': 8},
        {'lean': 1, 'arm_ext': 2},
        {},
    ], 48, 48), f'{pd}/spr_lyra_attack_strip6.png', 48, 48)
    # hurt 3 (recoil left)
    save_strips(bt_frames([
        {'lean': -6, 'crouch': 1},
        {'lean': -8, 'crouch': 2},
        {'lean': -5, 'crouch': 1},
    ], 32, 48), f'{pd}/spr_lyra_hurt_strip3.png', 32, 48)
    # defend 3 (guard up, crouched)
    save_strips(bt_frames([
        {'crouch': 2, 'arm_ext': -1},
        {'crouch': 3, 'arm_ext': 0},
        {'crouch': 2, 'arm_ext': -1},
    ], 32, 48), f'{pd}/spr_lyra_defend_strip3.png', 32, 48)
    # death 6 (48x48: stagger then collapse)
    save_strips(bt_frames([
        {'lean': -4, 'crouch': 1},
        {'lean': -7, 'crouch': 3},
        {'lean': -6, 'fallen': 0.3},
        {'fallen': 0.55},
        {'fallen': 0.8},
        {'fallen': 1.0},
    ], 48, 48), f'{pd}/spr_lyra_death_strip6.png', 48, 48)
    print('Lyra sprites written to', od, 'and', pd)
