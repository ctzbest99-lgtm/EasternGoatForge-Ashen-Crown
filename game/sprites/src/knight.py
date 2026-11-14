import math, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from pix import *
from hero import ik

PALHEX = dict(o='#000000', g='#2A2A2A', G='#5A5A5A', a='#8A8A8A', D='#3B2A1F', R='#6B4A2E', t='#C9A27A',
              x='#5A1F1F', X='#A33B3B', C='#2E3A44', c='#5A6B8A', l='#8FA3C4', M='#4A4A4A', n='#C0C0C0',
              r='#FF3B3B', W='#FFFFFF')
P = {k: hx(v) for k, v in PALHEX.items()}
OL = P['o']
W_, OX = 64, 16   # build canvas: 64 wide, body centred at x=32

def L(): return Layer(W_, 48)

HELM = """
....gMMMMMg....
..gMGaaaaGMg...
.gMGannaaaGMg..
.gMGaaaGGGGGMg.
gMGGaGGGGGGGGMg
gMGGGGGGGGGGGMg
gMGGGGGGgooooog
gMGGGGGGgooooog
gMGGGGGGGgggggg
gMMGGGGGGGaGaMg
gMMGGGGGGGGGGMg
.gMMGGGGGGaGaMg
..gMMGGGGGGGMg.
...gMMMMMMMMg..
"""
# eye slit cells (row, col)
EYES = [(6, 11), (6, 12), (7, 12)]

TORSO = """
..xXXXXXXXXXXx..
.xXXxXXXXXxXXXx.
.gxxMMMGaGxxxxg.
gMMMMGannaGRMMg.
gMMMMGannaRDMMMg
gMgMMGaaaRDGMMMg
gMgMMMGaRDGMMMMg
.gMgMMMRDGMMMMg.
.gMMgMRDGMMMMMg.
.DRRRRRRtRRRRRD.
.DDRRRRRtRRRRDD.
.gCcccMgMccccCg.
.gCcclMgMcclcCg.
.gCccc.gMcccCg..
..gcc..gMccCg...
"""

PAUL = """
..gaaaa.
.GannnaG
GGaaaaaG
MGGGGGGM
gMMMMMMg
.gg..gg.
"""

SAB = """
.MGGa..
MGGGGa.
gggggga
"""
SAB_FAR = """
.gMMG..
gMMMMG.
gggggg.
"""

def draw_leg(hip, foot, far):
    l_ = L()
    ax, ay = hip; fx, fy = foot
    ankle = (fx, fy - 2)
    knee = ik(ax, ay, ankle[0], ankle[1], 7, 6.5, +1)
    knee = (round(knee[0]), round(knee[1]))
    cols = [P['g'], P['g'], P['M'], P['G']] if far else [P['g'], P['M'], P['G'], P['a']]
    l_.limb(ax, ay, knee[0], knee[1], cols)
    l_.limb(knee[0], knee[1], ankle[0], ankle[1], cols)
    # knee cop
    kc = P['G'] if far else P['a']
    l_.put(knee[0], knee[1], kc); l_.put(knee[0] + 1, knee[1], P['n'] if not far else P['a'])
    l_.map(SAB_FAR if far else SAB, fx - 2, fy - 2, P)
    return l_.outlined(OL)

def draw_arm(sh, hand, far, bend=-1):
    l_ = L()
    el = ik(sh[0], sh[1], hand[0], hand[1], 5, 5, bend)
    el = (round(el[0]), round(el[1]))
    cols = [P['g'], P['g'], P['M']] if far else [P['g'], P['G'], P['a']]
    l_.limb(sh[0], sh[1], el[0], el[1], cols)
    l_.limb(el[0], el[1], hand[0], hand[1], cols)
    l_.rect(hand[0] - 1, hand[1] - 1, hand[0] + 1, hand[1] + 1, P['M'] if far else P['G'])
    l_.put(hand[0] + 1, hand[1] - 1, P['G'] if far else P['a'])
    return l_.outlined(OL)

def draw_sword(hand, ang, length=16):
    l_ = L()
    a = math.radians(ang); ux, uy = math.cos(a), math.sin(a)
    px_, py_ = -uy, ux   # perpendicular
    hx_, hy_ = hand[0] + 0.5, hand[1] + 0.5
    put = lambda t, o, c: l_.put(math.floor(hx_ + ux * t + px_ * o), math.floor(hy_ + uy * t + py_ * o), c)
    for t in [i * 0.5 for i in range(-9, 2)]:
        put(t, 0, P['R'] if int(t * 2) % 3 else P['D'])
    put(-5, 0, P['a']); put(-5.5, 0, P['a'])
    for o in [i * 0.5 for i in range(-7, 8)]:
        put(2, o, P['G']); put(2.5, o, P['a'] if abs(o) < 3 else P['G'])
    t = 3.0
    while t <= length:
        taper = t > length - 2
        put(t, 0, P['n'])
        if not taper:
            put(t, -1, P['a']); put(t, 1, P['M'])
        t += 0.5
    return l_.outlined(OL)

def draw_cloak(top, sway, length=27, flare=0, t=0.0):
    """Tattered dark-red cloak hanging behind."""
    l_ = L()
    x0, y0 = top
    rag = [0, 3, 1, 4, 0, 2, 5, 1, 3, 0, 4, 2, 1, 3, 0]
    for r in range(length + 6):
        f = min(r / max(length - 1, 1), 1.3)
        sh = round(sway * f * f + math.sin(t + r * 0.3) * 0.6 * f)
        left = x0 - round(min(f, 1.0) * (5 + flare)) + sh
        right = x0 + 11 - round(f * 2) + round(sh * 0.5)
        for x in range(left, right + 1):
            col = x - left
            lim = length - rag[col % len(rag)] * 1 + (2 if col % 4 == 1 else 0)
            if r > lim: continue
            u = col / max(right - left, 1)
            if u < 0.15: c = P['x']
            elif u < 0.35: c = P['X']
            elif u < 0.48: c = P['x']
            elif u < 0.7: c = P['X']
            else: c = P['x']
            if (col * 7 + r * 3) % 23 == 0 and r > 8: continue   # moth holes
            l_.put(x, y0 + r, c)
    return l_.outlined(OL)

def draw_scarf_tail(knot, t, length=7):
    l_ = L()
    kx, ky = knot
    for i in range(length):
        wob = round(math.sin(t + i * 0.8) * 1.0)
        y = ky + round(i * 0.45) + wob
        l_.put(kx - i, y, P['X']); l_.put(kx - i, y + 1, P['x'] if i % 3 else P['X'])
        if i > length - 3 and i % 2: l_.erase(kx - i, y + 1)
    return l_.outlined(OL)

def head_layer(pos, glow=2):
    l_ = L(); l_.map(HELM, pos[0], pos[1], P)
    ex, ey = pos
    cols = {3: (P['r'], P['W']), 2: (P['r'], P['r']), 1: (P['X'], P['r']), 0: (P['x'], P['x']), -1: (P['o'], P['o'])}[glow]
    l_.put(ex + 11, ey + 6, cols[0]); l_.put(ex + 12, ey + 6, cols[1]); l_.put(ex + 13, ey + 6, cols[0] if glow >= 2 else P['o'])
    l_.put(ex + 12, ey + 7, cols[0] if glow >= 1 else P['o'])
    return l_.outlined(OL)

def frame(p, crop=32):
    bx, by = p.get('bx', 0) + OX, p.get('by', 0)
    hdx, hdy = p.get('hdx', 0), p.get('hdy', 0)
    F = L()
    tx, ty = 8 + bx, 16 + by
    hipy = 31 + by
    tt = p.get('t', 0)
    F.over(draw_cloak((tx + 1, ty - 1), p.get('sway', 0), p.get('clen', 27), p.get('flare', 0), tt))
    F.over(draw_scarf_tail((tx + 3, ty + 1), tt, p.get('stail', 7)))
    sw = p.get('sword')
    hand = (p['hand'][0] + OX, p['hand'][1])
    fhand = (p['fhand'][0] + OX, p['fhand'][1])
    if sw is not None and p.get('sword_back'):
        F.over(draw_sword(hand, sw, p.get('slen', 16)))
    F.over(draw_arm((tx + 5, ty + 4), fhand, True, p.get('fbend', -1)))
    if p.get('show_legs', True):
        ff = (p['ffoot'][0] + OX, p['ffoot'][1]); nf = (p['nfoot'][0] + OX, p['nfoot'][1])
        F.over(draw_leg((tx + 5, hipy), ff, True))
        F.over(draw_leg((tx + 9, hipy), nf, False))
    T = L(); T.map(TORSO, tx, ty, P); F.over(T.outlined(OL))
    F.over(head_layer((tx + 1 + hdx - 1, 3 + by + hdy), p.get('glow', 2)))
    # collar scarf front wrap drawn over helmet chin
    S = L(); S.map("""
.xXXXXXXXXx.
xXXxXXXXXXXx
""", tx + 2, ty - 1, P); F.over(S.outlined(OL))
    if sw is not None and not p.get('sword_back'):
        F.over(draw_sword(hand, sw, p.get('slen', 16)))
    F.over(draw_arm((tx + 11, ty + 4), hand, False, p.get('nbend', -1)))
    Pd = L(); Pd.map(PAUL, tx + 8, ty + 1, P); F.over(Pd.outlined(OL))
    if p.get('fx'): F.over(p['fx'].shifted(OX, 0))
    if p.get('fx64'): F.over(p['fx64'])
    if crop == 64: return F
    o = Layer(crop, 48); o.over(F, -OX, 0); return o

# ---------------- animations ----------------
STAND = dict(ffoot=(12, 46), nfoot=(20, 46))

def tip_angle(hand, L_=16, ground=45):
    dy = ground - hand[1]
    dx = math.sqrt(max(L_ * L_ - dy * dy, 0))
    return math.degrees(math.atan2(dy, dx))

def idle():
    out = []
    for i in range(8):
        b = [0, 0, 1, 1, 1, 1, 0, 0][i]
        g = [3, 2, 2, 1, 1, 2, 2, 3][i]
        hand = (21, 31 + b)
        out.append(frame(dict(STAND, by=b, hand=hand, fhand=(14, 31 + b), sword=tip_angle(hand), glow=g,
                              t=i * math.pi / 4, sway=[0, -1, -1, -1, 0, 0, 0, 0][i])))
    return out

def walk():
    out = []
    for i in range(8):
        ph = 2 * math.pi * i / 8
        c, s = math.cos(ph), math.sin(ph)
        nd = round(3.5 * c)
        nl = round(max(0, s) * 2.2); fl = round(max(0, -s) * 2.2)
        bob = [1, 0, 0, 0, 1, 0, 0, 0][i]   # heavy stomp on contact
        hand = (20 + round(c * 0.6), 31 + bob)
        out.append(frame(dict(by=bob, ffoot=(14 - nd, 46 - fl), nfoot=(18 + nd, 46 - nl), hand=hand,
                              fhand=(14 - round(c * 1.5), 31 + bob), sword=tip_angle(hand), glow=2, t=i * math.pi / 4,
                              sway=-1 - (1 if abs(s) > 0.5 else 0))))
    return out

def arc(cx, cy, r, a0, a1, col, step=8):
    l_ = Layer(64, 48)
    a = a0
    while (a <= a1) if a1 > a0 else (a >= a1):
        x = cx + r * math.cos(math.radians(a)); y = cy + r * math.sin(math.radians(a))
        l_.put(round(x), round(y), col)
        a += step if a1 > a0 else -step
    return l_

def smear(cx, cy, a0, a1, r0, r1):
    l_ = Layer(64, 48)
    cx += OX
    for r in range(r0, r1 + 1):
        col = P['l'] if r >= r1 - 1 else P['c']
        n = int(abs(a1 - a0) * r / 40) + 2
        for k in range(n + 1):
            a = math.radians(a0 + (a1 - a0) * k / n)
            l_.put(round(cx + r * math.cos(a)), round(cy + r * math.sin(a)), col)
    return l_

def attack():
    f = []
    st = dict(ffoot=(10, 46), nfoot=(21, 46))
    f.append(frame(dict(st, bx=-1, by=2, hand=(13, 29), fhand=(11, 30), sword=165, glow=2, sway=1, t=0), 64))
    f.append(frame(dict(st, bx=-2, by=1, hand=(11, 22), fhand=(10, 28), sword=212, glow=3, sway=2, t=0.7,
                        nbend=1), 64))
    f.append(frame(dict(st, bx=0, by=0, hand=(22, 16), fhand=(12, 27), sword=-62, slen=17, glow=3, sway=0, t=1.4,
                        fx64=smear(16, 24, -205, -80, 21, 23)), 64))
    dust = Layer(64, 48)
    for (x, y, c) in [(38, 45, 't'), (40, 44, 'R'), (43, 45, 't'), (45, 43, 'R'), (36, 43, 'R'), (47, 45, 't'), (34, 45, 'D')]:
        dust.put(x + OX, y, P[c])
    f.append(frame(dict(ffoot=(9, 46), nfoot=(23, 46), bx=2, by=3, hand=(26, 30), fhand=(14, 31), sword=38, slen=19,
                        glow=3, sway=-3, t=2.1, fx64=smear(20, 25, -75, 42, 23, 25).over(dust)), 64))
    dust2 = Layer(64, 48)
    for (x, y, c) in [(37, 42, 't'), (40, 40, 'R'), (44, 41, 't'), (47, 42, 'D'), (34, 43, 'R'), (47, 46, 't'), (42, 44, 't')]:
        dust2.put(x + OX, y, P[c])
    f.append(frame(dict(ffoot=(9, 46), nfoot=(23, 46), bx=2, by=3, hand=(26, 31), fhand=(14, 32), sword=40, slen=19,
                        glow=2, sway=-2, t=2.8, fx64=dust2), 64))
    hand = (22, 31)
    f.append(frame(dict(st, bx=1, by=1, hand=hand, fhand=(14, 31), sword=tip_angle(hand), glow=2, sway=-1, t=3.5), 64))
    return f

def hurt():
    out = []
    seq = [(-2, 1, -1, 3), (-3, 2, -1, 3), (-3, 2, -1, 1), (-2, 1, 0, 2), (-1, 1, 0, 2), (0, 0, 0, 2)]
    for i, (bx, by, hdx, g) in enumerate(seq):
        hand = (21 + bx, 31 + by)
        out.append(frame(dict(STAND, bx=bx, by=by, hdx=hdx, hand=hand, fhand=(13 + bx, 30 + by),
                              sword=tip_angle(hand), glow=g, sway=max(0, -bx) + 1, t=i)))
    return out

DW = 48
def death():
    out = []
    # 0-1 stagger
    for i, (bx, by) in enumerate([(-2, 1), (-3, 3)]):
        hand = (20 + bx, 32 + by)
        out.append(frame(dict(ffoot=(12, 46), nfoot=(20 + i, 46), bx=bx, by=by, hdx=-1, hand=hand, fhand=(12 + bx, 30 + by),
                              sword=tip_angle(hand), glow=3, sway=1, t=i), DW))
    # 2 drop to one knee, sword planted
    kn = dict(ffoot=(8, 46), nfoot=(21, 46), by=8, hand=(23, 30), fhand=(14, 36), sword=90, slen=16, sway=0, clen=22)
    out.append(frame(dict(kn, glow=2, t=2), DW))
    # 3 kneeling, glow fading
    out.append(frame(dict(kn, by=9, hdx=1, hdy=1, glow=1, t=2.5), DW))
    # 4 head bowed, eyes out
    out.append(frame(dict(kn, by=10, hdx=1, hdy=2, glow=0, t=3), DW))
    # 5 tipping forward (sword left planted)
    body = frame(dict(kn, by=10, hdx=1, hdy=2, glow=-1, t=3, sword=None, hand=(22, 38), fhand=(15, 38)), DW)
    tip = rotsprite(body, 35, 16, 46); x0, y0, x1, y1 = tip.bbox(); tip = tip.shifted(0, 47 - y1)
    sword = Layer(DW, 48); sword.over(draw_sword((23 + OX, 30), 90, 16), -OX, 0)
    out.append(Layer(DW, 48).over(tip).over(sword))
    # 6-7 face down, cloak settling, planted sword remains
    full = frame(dict(STAND, hand=(21, 32), fhand=(14, 32), sword=None, glow=-1, sway=-3, clen=26, t=4))
    R = full.rot90cw(); x0, y0, x1, y1 = R.bbox()
    for dy in (-1, 0):
        lay = Layer(DW, 48)
        lay.over(R, 1 - x0, 47 - y1 + dy)
        lay.over(sword)
        out.append(lay)
    return out

if __name__ == '__main__':
    od = '/workspace/sprites/fallen_knight'; os.makedirs(od, exist_ok=True)
    anims = [('idle', idle()), ('walk', walk()), ('attack', attack()), ('hurt', hurt()), ('death', death())]
    rows = []
    for name, fr in anims:
        im = strip(fr); fw = fr[0].w
        im.save(f'{od}/spr_fallen_knight_{name}_strip{len(fr)}.png')
        bad = check_palette(im, PALHEX.values())
        if bad: print('PALETTE VIOLATION', name, list(bad)[:5])
        org = '(32,47)' if fw == 64 else '(16,47)'
        rows.append((f'spr_fallen_knight_{name}_strip{len(fr)}  ({len(fr)}f, {fw}x48, origin {org})', im, fw))
        if name == 'walk': gif(im, 32, f'{od}/fallen_knight_walk_preview.gif', 6, 120)
    preview(rows, f'{od}/fallen_knight_preview.png', 'FALLEN KNIGHT (boss)')
    print('ok')
