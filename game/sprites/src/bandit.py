import math, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from pix import *
from hero import ik

PALHEX = dict(o='#000000', g='#2A2A2A', G='#5A5A5A', w='#A8A8A8', D='#3B2A1F', R='#6B4A2E', t='#C9A27A',
              s='#E0C19A', x='#5A1F1F', X='#A33B3B', C='#2E3A44', c='#5A6B8A', L='#4A3A2A', m='#B0B0B0', b='#E8E8E8')
P = {k: hx(v) for k, v in PALHEX.items()}
OL = P['o']

HEAD = """
......RRRRRR.....
....RRtttRRRR....
...RtttRRRRRRRR..
..RttRRRRRRRRRRR.
.RRtRRRRRRRRRRRRR
.RRRRRRRRRRRDDDDR
DRRRRRRRRRRDtttttR
DRRRRRRRRRDssssss
DDRRRRRRRDssssoss
DDRRRRRRRDsssooss
DDRRRRRRRDxxxxxxx
DDDRRRRRRxXXXXXXX
DDDRRRRRRxXXXXXXX
.DDDRRRRRxXXXXXXx
..DDDRRRRxxXXXXx.
...DDDRRRRxxxxx..
.....DDDDD.......
"""
EYE = [(8, 14), (9, 13), (9, 14)]

TORSO = """
.RRRtRR....
RRtRRRRRRR.
DRRRRRRRRRD
.CccccccccC
.CCccccccc.
.CCcccccccC
.CCCcccccC.
.CCCccccCC.
.LLLLLmmLL.
.CCcCcccCc.
.CCcCCccCcC
CC.CCcC.CcC
"""

BOOT = """
RLL..
LLLLR
ggggg
"""
BOOT_FAR = """
LDD..
DDDDL
ggggg
"""

def draw_leg(hip, foot, far):
    L_ = Layer()
    ax, ay = hip; fx, fy = foot
    ankle = (fx, fy - 2)
    knee = ik(ax, ay, ankle[0], ankle[1], 6.5, 6.5, +1)
    cols = [P['D'], P['D'], P['R']] if far else [P['D'], P['R'], P['R']]
    knee = (round(knee[0]), round(knee[1]))
    L_.limb(ax, ay, knee[0], knee[1], cols)
    L_.limb(knee[0], knee[1], ankle[0], ankle[1], cols)
    L_.map(BOOT_FAR if far else BOOT, fx - 1, fy - 2, P)
    return L_.outlined(OL)

def draw_arm(sh, hand, far, bend=-1):
    L_ = Layer()
    el = ik(sh[0], sh[1], hand[0], hand[1], 4.5, 4.5, bend)
    el = (round(el[0]), round(el[1]))
    cols = [P['C'], P['C'], P['c']] if far else [P['C'], P['c'], P['c']]
    L_.limb(sh[0], sh[1], el[0], el[1], cols)
    L_.limb(el[0], el[1], hand[0], hand[1], cols[:2])
    L_.rect(hand[0], hand[1], hand[0] + 1, hand[1] + 1, P['t'] if far else P['s'])
    return L_.outlined(OL)

def draw_knife(hand, ang, length=6):
    L_ = Layer()
    a = math.radians(ang); ux, uy = math.cos(a), math.sin(a)
    hx_, hy_ = hand[0] + 0.5, hand[1] + 0.5
    for t in (-2, -1):
        L_.put(round(hx_ + ux * t), round(hy_ + uy * t), P['L'])
    gx, gy = hx_ + ux * 1.4, hy_ + uy * 1.4
    for t in (-1, 0, 1):
        L_.put(round(gx - uy * t), round(gy + ux * t), P['G'])
    for t in range(2, length + 1):
        L_.put(round(hx_ + ux * t), round(hy_ + uy * t), P['b'])
        if t < length - 1:
            L_.put(round(hx_ + ux * t + uy * 0.9), round(hy_ + uy * t - ux * 0.9), P['m'])
    return L_.outlined(OL)

def draw_tails(knot, sway, lift=0):
    """Bandana knot tails fluttering behind the head."""
    L_ = Layer()
    kx, ky = knot
    L_.rect(kx, ky, kx + 1, ky + 1, P['X'])
    for i in range(1, 6):
        wob = round(math.sin(sway + i * 0.9) * 0.8)
        dy = round(i * (0.5 - lift * 0.15))
        L_.put(kx - i, ky + dy + wob, P['X'] if i < 4 else P['x'])
        if i < 4:
            L_.put(kx - i, ky + 2 + dy + round(math.sin(sway + 1.5 + i) * 0.8), P['x'])
    return L_.outlined(OL)

def head_layer(pos, eye='open'):
    L_ = Layer(); L_.map(HEAD, pos[0], pos[1], P)
    ex, ey = pos
    if eye != 'open':
        for (r, c) in EYE: L_.put(ex + c, ey + r, P['s'])
        if eye == 'hurt':
            L_.put(ex + 13, ey + 8, P['o']); L_.put(ex + 14, ey + 9, P['o']); L_.put(ex + 13, ey + 9, P['s'])
        else:  # shut / dead
            L_.put(ex + 13, ey + 9, P['o']); L_.put(ex + 14, ey + 9, P['o'])
    return L_.outlined(OL)

def frame(p):
    bx, by = p.get('bx', 0), p.get('by', 0)
    hdx, hdy = p.get('hdx', 0), p.get('hdy', 0)
    F = Layer()
    tx, ty = 10 + bx, 20 + by
    hipy = 32 + by
    # bandana tails (behind everything)
    F.over(draw_tails((8 + bx + hdx + 1, 4 + by + hdy + 11), p.get('ph', 0), p.get('lift', 0)))
    # far arm
    F.over(draw_arm((tx + 4, ty + 3), p.get('fhand', (tx + 3, ty + 9)), True, p.get('fbend', -1)))
    if p.get('show_legs', True):
        hf = (tx + 4, hipy); hn = (tx + 6, hipy)
        F.over(draw_leg(hf, p['ffoot'], True))
        F.over(draw_leg(hn, p['nfoot'], False))
    T = Layer(); T.map(TORSO, tx, ty, P); F.over(T.outlined(OL))
    if p.get('fx_back'): F.over(p['fx_back'])
    F.over(head_layer((7 + bx + hdx, 4 + by + hdy), p.get('eye', 'open')))
    hand = p.get('hand', (tx + 10, ty + 7))
    if p.get('knife', 0) is not None:
        F.over(draw_knife(hand, p.get('knife', 0), p.get('klen', 6)))
    F.over(draw_arm((tx + 7, ty + 3), hand, False, p.get('nbend', -1)))
    if p.get('fx'): F.over(p['fx'])
    return F

def stance(spread=3, bx=0):
    return dict(ffoot=(13 + bx - spread, 46), nfoot=(17 + bx + spread, 46))

def idle():
    out = []
    for i in range(4):
        b = [0, 1, 2, 1][i]
        out.append(frame(dict(stance(3), by=b + 1, hand=(22, 27 + b), knife=-20, fhand=(19, 25 + b), fbend=-1,
                              ph=i * 1.6)))
    return out

def walk():
    out = []
    for i in range(4):
        ph = 2 * math.pi * i / 4
        c, s = math.cos(ph), math.sin(ph)
        nd = round(4 * c); nl = round(max(0, s) * 3); fl = round(max(0, -s) * 3)
        bob = [1, 0, 1, 0][i]
        sw = round(2 * c)
        out.append(frame(dict(by=bob, ffoot=(14 - nd, 46 - fl), nfoot=(16 + nd, 46 - nl),
                              hand=(21 - sw, 28 + bob), knife=-10 + sw * 8, fhand=(17 + sw, 26 + bob), ph=i * 1.6 + 1,
                              lift=1, bx=1)))
    return out

def swoosh(pts, col):
    L_ = Layer()
    for p_ in pts: L_.put(p_[0], p_[1], col)
    return L_

def attack():
    f = []
    # 0 crouch, knife drawn back to hip
    f.append(frame(dict(stance(4, -1), bx=-1, by=3, hand=(14, 29), knife=-30, fhand=(19, 26), ph=0)))
    # 1 coil further, lean back
    f.append(frame(dict(stance(4, -1), bx=-2, by=3, hdx=-1, hand=(12, 29), knife=-40, fhand=(18, 25), nbend=1, ph=0.7)))
    # 2 lunge: body forward, arm extending
    f.append(frame(dict(ffoot=(10, 46), nfoot=(22, 46), bx=2, by=2, hand=(24, 25), knife=-5, fhand=(12, 28), ph=1.6, lift=1)))
    # 3 full stab + glint smear
    sm = swoosh([(3, 23), (4, 23), (5, 23), (2, 26), (3, 26), (4, 29), (5, 29), (6, 29)], P['w'])
    f.append(frame(dict(ffoot=(9, 46), nfoot=(23, 46), bx=3, by=3, hand=(23, 25), knife=-3, klen=7, fhand=(12, 29), ph=2.4, lift=1)))
    # 4 slash follow-through downward
    sm2 = swoosh([(30, 21), (30, 23), (30, 25), (29, 27), (28, 29), (27, 31)], P['w'])
    f.append(frame(dict(ffoot=(10, 46), nfoot=(22, 46), bx=2, by=3, hand=(23, 30), knife=60, fhand=(13, 28), ph=3.1, lift=1, fx=sm2)))
    # 5 recover to guard
    f.append(frame(dict(stance(3), bx=0, by=2, hand=(22, 28), knife=-15, fhand=(19, 26), ph=3.8)))
    return f

def hurt():
    b = stance(3)
    return [
        frame(dict(b, bx=-2, by=2, hdx=-1, eye='hurt', hand=(19, 29), knife=40, fhand=(12, 25), ph=0, lift=1)),
        frame(dict(b, bx=-3, by=3, hdx=-1, hdy=1, eye='hurt', hand=(18, 30), knife=60, fhand=(10, 24), ph=1, lift=1)),
        frame(dict(b, bx=-2, by=2, eye='shut', hand=(19, 29), knife=30, fhand=(13, 27), ph=2)),
        frame(dict(b, bx=-1, by=2, hand=(21, 28), knife=-10, fhand=(17, 26), ph=3)),
    ]

DW = 48
def death():
    f = []
    f.append(frame(dict(stance(3), bx=-2, by=2, hdx=-1, eye='hurt', hand=(19, 29), knife=40, fhand=(12, 25), lift=1)))
    f.append(frame(dict(ffoot=(11, 46), nfoot=(20, 46), bx=-1, by=5, eye='hurt', hand=(19, 33), knife=45, fhand=(13, 32), ph=1)))
    kneel = frame(dict(ffoot=(10, 46), nfoot=(21, 46), bx=0, by=9, hdx=1, hdy=1, eye='shut', hand=(20, 38), knife=None, fhand=(13, 37), ph=2))
    f.append(kneel)
    k = resized(kneel, DW, 48)
    tip = rotsprite(k, 40, 18, 46); x0, y0, x1, y1 = tip.bbox(); tip = tip.shifted(0, 47 - y1)
    f.append(tip)
    full = frame(dict(ffoot=(14, 46), nfoot=(17, 46), hand=(20, 30), knife=None, fhand=(14, 30), eye='dead', ph=3))
    R = full.rot90cw(); x0, y0, x1, y1 = R.bbox()
    down = Layer(DW, 48); down.over(R, 1 - x0, 46 - y1)
    settle = Layer(DW, 48); settle.over(R, 1 - x0, 47 - y1)
    # dropped knife on the ground behind
    kn = Layer(DW, 48); kn.over(draw_knife((3, 45), 0, 6).shifted(0, 0))
    f += [down, kn.over(settle) if False else settle]
    return [resized(x, DW, 48) if x.w == 32 else x for x in f]

if __name__ == '__main__':
    od = '/workspace/sprites/bandit'; os.makedirs(od, exist_ok=True)
    anims = [('idle', idle()), ('walk', walk()), ('attack', attack()), ('hurt', hurt()), ('death', death())]
    rows = []
    for name, fr in anims:
        im = strip(fr); fw = fr[0].w
        im.save(f'{od}/spr_bandit_{name}_strip{len(fr)}.png')
        bad = check_palette(im, PALHEX.values())
        if bad: print('PALETTE VIOLATION', name, list(bad)[:5])
        rows.append((f'spr_bandit_{name}_strip{len(fr)}  ({len(fr)}f, {fw}x48)', im, fw))
        if name == 'walk': gif(im, 32, f'{od}/bandit_walk_preview.gif', 6, 110)
    preview(rows, f'{od}/bandit_preview.png', 'BANDIT  -  32x48 frames, origin (16,47)')
    print('ok')
