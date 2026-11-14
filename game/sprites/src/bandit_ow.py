"""Bandit top-down overworld sprites: 4 directions, 1 idle + 4 walk frames, 32x48 and 16x24."""
import math, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from ow_common import *
import bandit as B
P, OL = B.P, B.OL

HEAD_FRONT = mirror_half("""
.....RRRR
...RRtttR
..RttRRRR
.RtRRRRRR
.RRRRRRRR
RRRRRRRRR
RRRRDDDDD
RRRDttttt
RRDssssss
RRDssosss
RRDssosss
RRDxxxxxx
RRxXXXXXX
DRxXXXXXX
DDRxXXXXX
.DDRxXXXX
..DDRxxxx
....DDDDD
""")
HEAD_FRONT = poke(HEAD_FRONT, [(1, 12, 'R'), (1, 13, 'R'), (2, 14, 'R'), (2, 13, 'R'), (3, 15, 'R'), (3, 16, 'R')])
HEAD_BACK = mirror_half("""
.....RRRR
...RRtttR
..RttRRRR
.RtRRRRRR
.RRRRRRRR
RRRRRRRRR
RRRRRRRRR
DRRRRRRRR
DRRRRRRRR
DDRRRRRRR
DDRRRRRRR
DDRRRRRRR
DDDRRRRRR
.DDRRRRRR
.DDDRRRRR
..DDDRRRR
...DDDDRR
.....DDDD
""")
HEAD_BACK = poke(HEAD_BACK, [(1, 12, 'R'), (1, 13, 'R'), (2, 14, 'R'), (2, 13, 'R'), (3, 15, 'R'), (3, 16, 'R')])

TORSO_FRONT = mirror_half("""
.RRRRR
RRtRRR
DRRRRR
.CCccc
.CCccc
.CCccc
.CCccc
.CCccc
.LLLLm
.CCcCc
.CcCCc
C.CcCc
""")
TORSO_BACK = mirror_half("""
.RRRRR
RRtRRR
DRRRRR
.CCccc
.CCccc
.CCccc
.CCCcc
.CCccc
.LLLLL
.CCcCc
.CcCCc
C.CcCc
""")
BOOT = """
LLL
LLL
ggg
"""

def leg_v(x, top, bottom):
    L_ = Layer()
    for y in range(top, bottom - 2):
        L_.put(x, y, P['D']); L_.put(x + 1, y, P['R']); L_.put(x + 2, y, P['R'])
    L_.map(BOOT, x, bottom - 2, P)
    return L_.outlined(OL)

def arm_v(x, top, hand_y, knife=False):
    L_ = Layer()
    for y in range(top, hand_y):
        L_.put(x, y, P['C']); L_.put(x + 1, y, P['c'])
    L_.rect(x, hand_y, x + 1, hand_y + 1, P['s'])
    if knife:
        L_.put(x, hand_y - 1, P['L'])
        for k in range(2, 7):
            L_.put(x, hand_y + k, P['b']); 
            if k < 5: L_.put(x + 1, hand_y + k, P['m'])
        L_.put(x - 1, hand_y + 2, P['G']); L_.put(x + 2, hand_y + 2, P['G'])
    return L_.outlined(OL)

def tails_back(x, y, ph):
    """Bandana knot at the back of the hood with two short tails swaying."""
    L_ = Layer()
    L_.rect(x, y, x + 2, y + 1, P['X']); L_.put(x + 1, y + 1, P['x'])
    for k, (tx, n) in enumerate(((x, 5), (x + 2, 4))):
        for i in range(1, n):
            wob = round(math.sin(ph + k * 2 + i * 0.7) * 0.6) if i > 1 else 0
            L_.put(tx + wob, y + 1 + i, P['X'] if i < n - 1 else P['x'])
    return L_.outlined(OL)

WALK = [(2, 0, 0, 1, -1), (0, 0, -1, 0, 0), (0, 2, 0, -1, 1), (0, 0, -1, 0, 0)]

def front(i=None):
    ll, rl, b, lh, rh = WALK[i] if i is not None else (0, 0, 0, 0, 0)
    F = Layer()
    F.over(leg_v(12, 32 + b, 47 - ll - 1)); F.over(leg_v(17, 32 + b, 47 - rl - 1))
    T = Layer(); T.map(TORSO_FRONT, 10, 20 + b, P); F.over(T.outlined(OL))
    F.over(arm_v(8, 23 + b, 29 + b + lh, knife=True))
    F.over(arm_v(22, 23 + b, 29 + b + rh))
    Hd = Layer(); Hd.map(HEAD_FRONT, 7, 4 + b, P); F.over(Hd.outlined(OL))
    return F

def back(i=None):
    ll, rl, b, lh, rh = WALK[i] if i is not None else (0, 0, 0, 0, 0)
    F = Layer()
    F.over(leg_v(12, 32 + b, 47 - ll - 1)); F.over(leg_v(17, 32 + b, 47 - rl - 1))
    T = Layer(); T.map(TORSO_BACK, 10, 20 + b, P); F.over(T.outlined(OL))
    F.over(arm_v(8, 23 + b, 29 + b + lh))
    F.over(arm_v(22, 23 + b, 29 + b + rh, knife=True))
    Hd = Layer(); Hd.map(HEAD_BACK, 7, 4 + b, P); F.over(Hd.outlined(OL))
    F.over(tails_back(15, 16 + b, (i or 0) * 1.6))
    return F

def side(i=None):
    if i is None:
        return B.frame(dict(ffoot=(14, 46), nfoot=(18, 46), hand=(19, 30), knife=75, fhand=(14, 29), ph=0))
    ph = 2 * math.pi * i / 4
    c, s = math.cos(ph), math.sin(ph)
    nd = round(4 * c); nl = round(max(0, s) * 3); fl = round(max(0, -s) * 3)
    bob = [1, 0, 1, 0][i]; sw = round(2 * c)
    return B.frame(dict(by=bob, ffoot=(15 - nd, 46 - fl), nfoot=(17 + nd, 46 - nl), hand=(19 - sw, 30 + bob),
                        knife=70, fhand=(14 + sw, 29 + bob), ph=i * 1.6 + 1, lift=1))

# ---------- 16x24 ----------
S_FRONT = mirror_half("""
........
.....RRR
....RttR
...RtRRR
...RRRRR
..RRRDDD
..RRDttt
..RDsoss
..RDXXXX
..RxXXXX
...DRxxx
....RRRt
...RRCcc
..cCCccc
..cCCccc
..ssLLLm
..bCCcCc
..bCcCCc
....RR..
....RR..
....RR..
...LLL..
...ggg..
........
""")
S_FRONT = poke(S_FRONT, [(2, 10, 'R'), (3, 11, 'R'), (16, 13, '.'), (17, 13, '.'), (16, 2, 'b'), (17, 2, 'm')])
S_FRONT = poke(S_FRONT, [(16, 13, 'c'), (17, 13, 'c')])
S_BACK = mirror_half("""
........
.....RRR
....RttR
...RtRRR
...RRRRR
..RRRRRR
..RRRRRR
..DRRRRR
..DDRRxX
..DDRRRx
...DDRRR
....RRRt
...RRCcc
..cCCccc
..cCCccc
..ssLLLL
..cCCcCc
..cCcCCc
....RR..
....RR..
....RR..
...LLL..
...ggg..
........
""")
S_BACK = poke(S_BACK, [(2, 10, 'R'), (3, 11, 'R'), (10, 7, 'X'), (11, 7, 'x'), (11, 9, 'X'), (12, 9, 'x'),
                       (16, 13, 'b'), (17, 13, 'b'), (16, 2, 'c'), (17, 2, 'c')])
S_SIDE = """
................
.......RRRR.....
.....RRttRRR....
....RRtRRRRRR...
....RRRRRRDDDD..
...XRRRRRDtttt..
..XxRRRRRDssos..
..x.RRRRRxxXXX..
....DRRRRxXXXX..
.....DDRRRxXX...
......RRRRt.....
.....RRtRRR.....
.....CCccsb.....
.....CCccc.b....
.....CCcccc.....
.....LLLLmL.....
.....CcCCc......
.....CC.Cc......
"""

def small(grid, legs=None, bob=0, hands=None):
    rows = grid_rows(grid)
    L_ = Layer(16, 24)
    for y, r in enumerate(rows):
        for x, ch in enumerate(r):
            if ch == '.': continue
            yy = y + bob if y < 18 else y
            if legs and y >= 18: yy = y - (legs[0] if x < 8 else legs[1])
            if hands and y >= 15 and y < 18 and ch in 'sb':
                yy += hands[0] if x < 8 else hands[1]
            L_.put(x, yy, P[ch])
    return L_.outlined(OL)

def small_side(i=None):
    rows = grid_rows(S_SIDE)
    upper = Layer(16, 24)
    for y, r in enumerate(rows):
        for x, ch in enumerate(r):
            if ch != '.': upper.put(x, y, P[ch])
    bob = 0 if i is None else [0, -1, 0, -1][i]
    F = Layer(16, 24)
    poses = {None: (6, 8, 0, 0), 0: (4, 10, 0, 0), 1: (6, 8, 1, 0), 2: (10, 4, 0, 0), 3: (8, 6, 0, 1)}
    bx_, fx_, bl, fl = poses[i]
    for lx, lift, cols in ((bx_, bl, ['D', 'D']), (fx_, fl, ['D', 'R'])):
        Lg = Layer(16, 24)
        Lg.limb(7, 18 + bob, lx, 21 - lift, [P[cols[0]], P[cols[1]]])
        Lg.rect(lx - 1, 21 - lift, lx + 1, 21 - lift, P['L']); Lg.rect(lx - 1, 22 - lift, lx + 2, 22 - lift, P['g'])
        F.over(Lg.outlined(OL))
    F.over(upper.shifted(0, bob).outlined(OL))
    return F

SMALL_WALK = [((2, 0), 0, (1, -1)), ((0, 0), -1, (0, 0)), ((0, 2), 0, (-1, 1)), ((0, 0), -1, (0, 0))]

def build():
    od = '/workspace/sprites/bandit/overworld'
    big, walks = [], {}
    for d in ('down', 'up', 'right', 'left'):
        if d == 'down': idle, wk = front(), [front(i) for i in range(4)]
        elif d == 'up': idle, wk = back(), [back(i) for i in range(4)]
        elif d == 'right': idle, wk = side(), [side(i) for i in range(4)]
        else: idle, wk = mirror_layer(side()), [mirror_layer(side(i)) for i in range(4)]
        big.append((d, idle, wk)); walks[d] = wk
    rows = save_set(od, 'spr_bandit_ow', big, 32, B.PALHEX.values(), '')
    gif_4dir([walks[d] for d in ('down', 'left', 'right', 'up')], 32, 48, f'{od}/bandit_ow_walk_preview.gif')
    sm, sw = [], {}
    for d in ('down', 'up', 'right', 'left'):
        if d in ('down', 'up'):
            g = S_FRONT if d == 'down' else S_BACK
            idle = small(g); wk = [small(g, legs=l, bob=b, hands=h) for (l, b, h) in SMALL_WALK]
        elif d == 'right': idle, wk = small_side(), [small_side(i) for i in range(4)]
        else: idle, wk = mirror_layer(small_side()), [mirror_layer(small_side(i)) for i in range(4)]
        sm.append((d, idle, wk)); sw[d] = wk
    rows_s = save_set(od + '/16x24', 'spr_bandit_ow16', sm, 16, B.PALHEX.values(), '')
    gif_4dir([sw[d] for d in ('down', 'left', 'right', 'up')], 16, 24, f'{od}/16x24/bandit_ow16_walk_preview.gif', scale=8)
    preview(rows, f'{od}/bandit_ow_preview.png', 'BANDIT overworld 32x48 (idle | walk x4), origin (16,47)')
    preview(rows_s, f'{od}/16x24/bandit_ow16_preview.png', 'BANDIT overworld 16x24 (idle | walk x4), origin (8,23)', scale=8, fw=16)
    print('ok')

if __name__ == '__main__':
    build()
