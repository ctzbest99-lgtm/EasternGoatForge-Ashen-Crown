"""Kael (hero) top-down overworld sprites: 4 directions, 1 idle + 4 walk frames, 32x48 and 16x24."""
import math, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from ow_common import *
import hero as H
P, OL = H.P, H.OL

# ---------- 32x48 ----------
HEAD_FRONT = mirror_half("""
.....hhhh
...hhjjjj
..hjjhhhh
.hjhhhhhh
.hhhhhhhh
hHhhhhhhh
HHhhhhhhh
HHhhhHhhh
HHhhHshhH
HHhHsssHs
HHHtsssss
HHtsssess
HHtsssess
.Htssssss
.HHtsssss
..HHtssss
...HHttss
.....tttt
""")
# messy asymmetric bangs + mouth
HEAD_FRONT = poke(HEAD_FRONT, [(7, 12, 'H'), (8, 11, 's'), (9, 13, 'h'), (6, 5, 'j'), (14, 9, 't'), (14, 8, 't'), (0, 4, '.'), (0, 13, '.'), (0, 3, '.')])
HEAD_FRONT = poke(HEAD_FRONT, [(14, 8, 's'), (14, 9, 's'), (15, 8, 't'), (15, 9, 't')])

HEAD_BACK = mirror_half("""
.....hhhh
...hhjjjj
..hjjjhhh
.hjjhhhhh
.hhhhhhhh
hHhhhhhhh
HHhhhhhhh
HHhhhhhhh
HHHhhhhhh
HHHhhhhhh
HHHHhhhhh
HHHHhhhhh
HHHHHhhhh
.HHHHhhhh
.HHHHHhhh
..HHHHHhH
...HHHHHH
.....HHHH
""")
HEAD_BACK = poke(HEAD_BACK, [(5, 11, 'j'), (8, 6, 'H'), (9, 6, 'H'), (10, 7, 'H'), (9, 12, 'H'), (10, 12, 'H'), (11, 13, 'H'),
                             (12, 9, 'H'), (13, 9, 'H'), (16, 12, '.'), (17, 4, '.'), (17, 10, '.')])

TORSO_FRONT = mirror_half("""
..kkkk
.kklll
nnmkCc
nmmLzz
mmMLzz
.MLzzy
.LLzzy
.LLzzz
.DDDDB
.LzzzR
.LzLzz
.LLzLz
.L.zL.
""")
TORSO_FRONT = poke(TORSO_FRONT, [(1, 5, 'K'), (1, 6, 'K'), (2, 5, 'c'), (2, 6, 'c')])

TORSO_BACK = mirror_half("""
..kkkk
.kkkkk
nnmkkk
nmmkkk
mmMkkk
.Kkklk
.Kkklk
.KkkkK
.KkklK
.KkkkK
""")

BOOT_FRONT = """
zzz
zzz
LLL
"""
BOOT_BACK = """
LLL
zzz
LLL
"""

def cloak_front(x0, y0, sway=0, length=20):
    L_ = Layer()
    for r in range(length):
        f = r / (length - 1)
        left = x0 - round(f * 3); right = x0 + 15 + round(f * 3)
        for x in range(left, right + 1):
            u = (x - left) / (right - left)
            c = P['K'] if (u < 0.12 or u > 0.88) else P['k']
            if 0.18 < u < 0.26 or 0.74 < u < 0.82: c = P['l'] if r > 2 else P['k']
            L_.put(x + (round(sway * f) if r > length // 2 else 0), y0 + r, c)
    for (x, y), c in list(L_.px.items()):
        if y == y0 + length - 1 and x % 3 == 1: L_.erase(x, y)
    return L_.outlined(OL)

def cloak_back(x0, y0, sway=0, length=20):
    """Full back drape covering the body."""
    L_ = Layer()
    for r in range(length):
        f = r / (length - 1)
        left = x0 - round(f * 3); right = x0 + 15 + round(f * 3)
        for x in range(left, right + 1):
            u = (x - left) / (right - left)
            if u < 0.1 or u > 0.9: c = P['K']
            elif 0.28 < u < 0.36 or 0.62 < u < 0.7: c = P['K'] if r > 3 else P['k']
            elif 0.44 < u < 0.52 and r > 3: c = P['l']
            else: c = P['k']
            if r < 2: c = P['k'] if 0.1 < u < 0.9 else P['K']
            L_.put(x, y0 + r, c)
    for (x, y), c in list(L_.px.items()):
        if y == y0 + length - 1 and x % 3 == 1: L_.erase(x, y)
    return L_.outlined(OL)

def leg_v(x, top, bottom, boot, far=False):
    L_ = Layer()
    cols = [P['D'], P['R'], P['Q']] if not far else [P['D'], P['R'], P['R']]
    for y in range(top, bottom - 2):
        for i, c in enumerate(cols): L_.put(x + i, y, c)
    L_.map(boot, x, bottom - 2, P)
    return L_.outlined(OL)

def arm_v(x, top, hand_y, skin=True):
    L_ = Layer()
    for y in range(top, hand_y):
        L_.put(x, y, P['C']); L_.put(x + 1, y, P['c'])
    if skin: L_.rect(x, hand_y, x + 1, hand_y + 1, P['s'])
    return L_.outlined(OL)

# leg lift / arm swing per walk frame: (left foot lift, right foot lift, bob, left hand dy, right hand dy)
WALK = [(2, 0, 0, 1, -1), (0, 0, -1, 0, 0), (0, 2, 0, -1, 1), (0, 0, -1, 0, 0)]

def front(i=None):
    ll, rl, bob, lh, rh = WALK[i] if i is not None else (0, 0, 0, 0, 0)
    F = Layer(); b = bob
    F.over(cloak_front(8, 21 + b, 0, 19))
    F.over(leg_v(12, 33 + b, 47 - ll - 1 + (0 if ll else 0), BOOT_FRONT))
    F.over(leg_v(17, 33 + b, 47 - rl - 1, BOOT_FRONT))
    T = Layer(); T.map(TORSO_FRONT, 10, 20 + b, P); F.over(T.outlined(OL))
    # scabbard hilt at his left hip (image right)
    S = Layer(); S.put(22, 31 + b, P['B']); S.put(23, 31 + b, P['B']); S.put(22, 30 + b, P['z']); S.put(22, 29 + b, P['z'])
    S.rect(21, 32 + b, 22, 37 + b, P['L']); S.put(21, 32 + b, P['z'])
    F.over(S.outlined(OL))
    F.over(arm_v(8, 23 + b, 30 + b + lh))
    F.over(arm_v(22, 23 + b, 30 + b + rh))
    Hd = Layer(); Hd.map(HEAD_FRONT, 7, 3 + b, P); F.over(Hd.outlined(OL))
    C = Layer(); C.map(mirror_half("""
..kkk
.kkll
"""), 11, 19 + b, P); F.over(C.outlined(OL))
    return F

def back(i=None):
    ll, rl, bob, lh, rh = WALK[i] if i is not None else (0, 0, 0, 0, 0)
    F = Layer(); b = bob
    F.over(leg_v(12, 33 + b, 47 - ll - 1, BOOT_BACK))
    F.over(leg_v(17, 33 + b, 47 - rl - 1, BOOT_BACK))
    # scabbard tip below cloak on his left (image left)
    S = Layer(); S.rect(8, 36 + b, 9, 41 + b, P['L']); S.put(8, 41 + b, P['B']); F.over(S.outlined(OL))
    F.over(arm_v(8, 23 + b, 30 + b + lh))
    F.over(arm_v(22, 23 + b, 30 + b + rh))
    F.over(cloak_back(8, 20 + b, 0, 20))
    T = Layer(); T.map(TORSO_BACK, 10, 20 + b, P)
    # pauldrons only (the rest of TORSO_BACK sits under the cloak)
    Pd = Layer()
    for (x, y), c in T.px.items():
        if c in (P['n'], P['m'], P['M']): Pd.put(x, y, c)
    F.over(Pd.outlined(OL))
    Hd = Layer(); Hd.map(HEAD_BACK, 7, 3 + b, P); F.over(Hd.outlined(OL))
    return F

def scabbard_side(tx, ty):
    L_ = Layer()
    L_.limb(tx + 5, ty + 12, tx - 3, ty + 15, [P['L'], P['z']])
    L_.put(tx + 6, ty + 11, P['B']); L_.put(tx + 7, ty + 10, P['z']); L_.put(tx + 6, ty + 12, P['B'])
    L_.put(tx - 3, ty + 15, P['B'])
    return L_.outlined(OL)

def side(i=None):
    if i is None:
        return H.frame(dict(sword=None, hand=(19, 30), fhand=(12, 30), ffoot=(14, 46), nfoot=(17, 46), pre_arm=scabbard_side))
    ph = 2 * math.pi * i / 4
    c, s = math.cos(ph), math.sin(ph)
    nd = round(4 * c); nl = round(max(0, s) * 2.5); fl = round(max(0, -s) * 2.5)
    bob = [0, -1, 0, -1][i]
    sw = round(-2 * c)
    return H.frame(dict(by=bob, sword=None, legs=[(-nd, fl), (nd, nl)], sway=-1 - abs(round(s)),
                        hand=(19 + sw, 29 + bob), fhand=(12 - sw, 29 + bob), pre_arm=scabbard_side))

# ---------- 16x24 (FF1 scale, hand-authored, not downscaled) ----------
S_FRONT = mirror_half("""
........
.....hhh
....hjjj
...hjhhh
...hhhhh
..HhhhHh
..HhHsHs
..Htsess
..Htssss
...Htsss
....kkll
...nmkzz
..cmmLzz
..cdLLzz
..cdLzzy
..ssDDDB
...LLzzz
...LzLzz
....RQ..
....RQ..
....RQ..
...zzz..
...LLL..
........
""")
S_FRONT = poke(S_FRONT, [(5, 10, 'h'), (6, 9, 's'), (5, 5, 'j'), (8, 7, 't'), (8, 8, 't')])
S_BACK = mirror_half("""
........
.....hhh
....hjjj
...hjhhh
...hhhhh
..Hhhhhh
..HHhhhh
..HHhhhh
..HHHhhh
...HHHHh
....kkkk
...nmkkk
..cmmkkk
..cKkkkl
..cKkkkk
..ssKkkk
...Kkkkk
...KkKkk
....RQ..
....RQ..
....RQ..
...LLL..
...LLL..
........
""")
S_BACK = poke(S_BACK, [(5, 10, 'j'), (3, 6, 'j')])
S_SIDE = """
................
.......hhhh.....
.....hhjjjjh....
....hjjhhhhjh...
....hhhhhhhhhh..
...HHhhhhhHhhh..
...HHhhhHhssHs..
...HHHhtsssses..
...HHHtssssss...
....HHHtttss....
.....Kkklkk.....
....Kkkzzznn....
....KkLzzmmn....
....KkLzzcd.....
...KkkLzzcd.....
...KkkDDDss.....
...KkkLzzz......
..KkkkLzLz......
......RRQ.......
......RRQ.......
......RRQ.......
......zzzz......
......LLLLL.....
................
"""

def small(grid, legs=None, bob=0, hands=None):
    """Render a 16x24 grid; legs=(left_lift, right_lift) raises leg pixel columns."""
    rows = grid_rows(grid)
    L_ = Layer(16, 24)
    for y, r in enumerate(rows):
        for x, ch in enumerate(r):
            if ch == '.': continue
            yy = y + bob if y < 18 else y
            if legs and y >= 18:
                lift = legs[0] if x < 8 else legs[1]
                yy = y - lift
                if lift and y == 20:  # keep leg continuous when lifted
                    pass
            if hands and y in (15,) and ch == 's':
                yy += hands[0] if x < 8 else hands[1]
            L_.put(x, yy, P[ch])
    return L_.outlined(OL)

def small_side(i=None):
    rows = grid_rows(S_SIDE)
    upper = Layer(16, 24)
    for y, r in enumerate(rows[:18]):
        for x, ch in enumerate(r):
            if ch != '.': upper.put(x, y, P[ch])
    bob = 0 if i is None else [0, -1, 0, -1][i]
    F = Layer(16, 24)
    # legs: (back foot x, front foot x, back lift, front lift)
    poses = {None: (6, 8, 0, 0), 0: (4, 10, 0, 0), 1: (6, 8, 1, 0), 2: (10, 4, 0, 0), 3: (8, 6, 0, 1)}
    bx_, fx_, bl, fl = poses[i]
    for lx, lift, cols in ((bx_, bl, ['D', 'R']), (fx_, fl, ['R', 'Q'])):
        Lg = Layer(16, 24)
        hip = 7
        Lg.limb(hip, 18 + bob, lx, 21 - lift, [P[cols[0]], P[cols[1]]])
        Lg.rect(lx - 1, 21 - lift, lx + 1, 21 - lift, P['z']); Lg.rect(lx - 1, 22 - lift, lx + 2, 22 - lift, P['L'])
        F.over(Lg.outlined(OL))
    F.over(upper.shifted(0, bob).outlined(OL))
    return F

SMALL_WALK = [((2, 0), 0, (1, -1)), ((0, 0), -1, (0, 0)), ((0, 2), 0, (-1, 1)), ((0, 0), -1, (0, 0))]

def build():
    od = '/workspace/sprites/hero/overworld'
    big = []
    walks = {}
    for d in ('down', 'up', 'right', 'left'):
        if d == 'down': idle, wk = front(), [front(i) for i in range(4)]
        elif d == 'up': idle, wk = back(), [back(i) for i in range(4)]
        elif d == 'right': idle, wk = side(), [side(i) for i in range(4)]
        else: idle, wk = mirror_layer(side()), [mirror_layer(side(i)) for i in range(4)]
        big.append((d, idle, wk)); walks[d] = wk
    rows = save_set(od, 'spr_kael_ow', big, 32, H.PALHEX.values(), '')
    gif_4dir([walks[d] for d in ('down', 'left', 'right', 'up')], 32, 48, f'{od}/kael_ow_walk_preview.gif')
    sm = []; swalks = {}
    for d in ('down', 'up', 'right', 'left'):
        if d in ('down', 'up'):
            g = S_FRONT if d == 'down' else S_BACK
            idle = small(g); wk = [small(g, legs=l, bob=b, hands=h) for (l, b, h) in SMALL_WALK]
        elif d == 'right':
            idle = small_side(); wk = [small_side(i) for i in range(4)]
        else:
            idle = mirror_layer(small_side()); wk = [mirror_layer(small_side(i)) for i in range(4)]
        sm.append((d, idle, wk)); swalks[d] = wk
    rows_s = save_set(od + '/16x24', 'spr_kael_ow16', sm, 16, H.PALHEX.values(), '')
    gif_4dir([swalks[d] for d in ('down', 'left', 'right', 'up')], 16, 24, f'{od}/16x24/kael_ow16_walk_preview.gif', scale=8)
    preview(rows, f'{od}/kael_ow_preview.png', 'KAEL overworld 32x48 (idle | walk x4), origin (16,47)')
    preview(rows_s, f'{od}/16x24/kael_ow16_preview.png', 'KAEL overworld 16x24 (idle | walk x4), origin (8,23)', scale=8, fw=16)
    print('ok')

if __name__ == '__main__':
    build()
