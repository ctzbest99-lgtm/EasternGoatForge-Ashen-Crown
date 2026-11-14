import math, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from pix import *

PALHEX = dict(o='#1A1A1A', D='#3B2A1F', R='#6B442E', Q='#8F6B4D', t='#C9A27A', s='#F2C9A7',
    H='#4A3A2D', h='#7A5A43', j='#A6815E', C='#1F2A44', c='#3B4F7A', d='#6F8CC4',
    K='#142036', k='#2B4A7A', l='#5E7FB8', M='#2A2A2A', m='#555555', n='#A0A0A0',
    L='#3A2A1F', z='#6E5036', y='#A0785A', B='#D0B58A')
P = {k: hx(v) for k, v in PALHEX.items()}
P['e'] = P['o']
OL = P['o']

HEAD = """
....h..hhhh.h.....
...hhhhjjjjhhh.h..
..hhjjjhhhhjjjhh..
.hhjhhhhhhhhhjjhh.
hhhhhhhhhhhhhhhjhh
hhHhhhhhhhhhhhhhhh
.HHhhhhhhhhhhhhhhh
..HhhhhhhHhhhhhhhh
.HHhhhhhHHhhhHhhhH
HHHhhhhHsHhhHsHhHs
HHHHhhHssshhssshss
.HHHhtssssssssssss
..HHttssssssssess.
.HHHtsstsssssses..
HHHHHtsssssssssss.
.HHHHHtsssssstts..
..HHHHttsssssss...
....HHHtttttt.....
"""
# eye cells (row, col) in HEAD for overrides
EYE = [(12, 14), (13, 14)]

TORSO = """
..CcccccccC..
.CzzzzzzzzyC.
.Lzzzzzzzyzy.
.Lzzzzzzzzzy.
.LLzzzzzzzyy.
.LLzzzzzzzyy.
.LLLzzzzzzzy.
.DDDDDDDBBDD.
.DRRRRRRBBRD.
.LLzzzzzzzyL.
.LzLzzzyzzyL.
LLzLzzLzyzzy.
LzLLzLLzLzzyL
"""

COLLAR = """
.kkk.....
kkllkkk..
Kkkkllkkk
KKkkkkkkl
"""

PAULDRON = """
.mnnn.
mnnnnn
mmnnnm
.Mmmm.
"""

BOOT = """
yzz..
zzzzy
LLLLL
"""
BOOT_FAR = """
zLL..
LLLLz
MMMMM
"""

def ik(ax, ay, bx, by, l1, l2, bend):
    """joint between a and b; bend=+1 pushes joint to +x (knee forward), -1 backward."""
    dx, dy = bx - ax, by - ay
    d = math.hypot(dx, dy)
    if d >= l1 + l2 - 0.01 or d == 0:
        return (ax + dx * l1 / (l1 + l2), ay + dy * l1 / (l1 + l2))
    a = (l1 * l1 - l2 * l2 + d * d) / (2 * d)
    hgt = math.sqrt(max(l1 * l1 - a * a, 0))
    mx, my = ax + dx * a / d, ay + dy * a / d
    # perpendicular (rotate dir by 90)
    px, py = -dy / d, dx / d
    if px * bend < 0: px, py = -px, -py
    return (mx + px * hgt, my + py * hgt)

def draw_leg(hip, foot, far):
    L_ = Layer()
    ax, ay = hip; fx, fy = foot
    ankle = (fx, fy - 2)
    knee = ik(ax, ay, ankle[0], ankle[1], 6.5, 6.5, +1)
    cols = [P['D'], P['D'], P['R']] if far else [P['D'], P['R'], P['Q']]
    L_.limb(ax, ay, round(knee[0]), round(knee[1]), cols)
    L_.limb(round(knee[0]), round(knee[1]), ankle[0], ankle[1], cols)
    L_.map(BOOT_FAR if far else BOOT, fx - 1, fy - 2, P)
    return L_.outlined(OL)

def draw_arm(sh, hand, far, bend=-1):
    L_ = Layer()
    el = ik(sh[0], sh[1], hand[0], hand[1], 4.5, 4.5, bend)
    cols = [P['C'], P['C'], P['c']] if far else [P['C'], P['c'], P['d']]
    el = (round(el[0]), round(el[1]))
    L_.limb(sh[0], sh[1], el[0], el[1], cols)
    L_.limb(el[0], el[1], hand[0], hand[1], cols[:2])
    sk = P['t'] if far else P['s']
    L_.rect(hand[0], hand[1], hand[0] + 1, hand[1] + 1, sk)
    return L_

def draw_sword(hand, ang, length=11):
    L_ = Layer()
    a = math.radians(ang)
    ux, uy = math.cos(a), math.sin(a)
    hx_, hy_ = hand[0] + 0.5, hand[1] + 0.5
    # grip behind hand
    for t in range(-3, 0):
        L_.put(round(hx_ + ux * t), round(hy_ + uy * t), P['z'])
    L_.put(round(hx_ - ux * 3.5), round(hy_ - uy * 3.5), P['B'])  # pommel
    # guard perpendicular
    gx, gy = hx_ + ux * 1.5, hy_ + uy * 1.5
    for t in (-2, -1, 0, 1, 2):
        L_.put(round(gx - uy * t), round(gy + ux * t), P['B'])
    # blade (2px: light core + mid edge)
    for t in range(2, length + 1):
        bx_, by_ = hx_ + ux * t, hy_ + uy * t
        L_.put(round(bx_), round(by_), P['n'])
        if t < length:
            L_.put(round(bx_ + uy * 0.9), round(by_ - ux * 0.9), P['m'])
    return L_.outlined(OL)

def draw_cloak(top, sway, length=20, flare=0):
    """Back drape hanging from the shoulders to the knees, flaring behind the body."""
    L_ = Layer()
    x0, y0 = top
    for r in range(length):
        f = r / max(length - 1, 1)
        sh = round(sway * f * f)
        left = x0 - round(f * (4 + flare)) + sh
        right = x0 + 9 - round(f * 3) + round(sh * 0.5)
        for x in range(left, right + 1):
            u = (x - left) / max(right - left, 1)
            if r < 2: c = P['k'] if u < 0.85 else P['l']
            elif u < 0.12: c = P['K']
            elif u < 0.3: c = P['k']
            elif u < 0.42: c = P['l']
            elif u < 0.55: c = P['k']
            elif u < 0.68: c = P['K']
            else: c = P['k']
            L_.put(x, y0 + r, c)
    hem_y = y0 + length - 1
    for (x, y), c in list(L_.px.items()):
        if y == hem_y and (x % 3 == 1): L_.erase(x, y)
        if y == hem_y - 1 and (x % 6 == 4): L_.erase(x, y)
    return L_.outlined(OL)

def head_layer(pos, eye='open'):
    L_ = Layer()
    L_.map(HEAD, pos[0], pos[1], P)
    ex, ey = pos[0], pos[1]
    if eye == 'shut':
        for (r, c) in EYE: L_.put(ex + c, ey + r, P['s'])
        L_.put(ex + 13, ey + 13, P['e']); L_.put(ex + 14, ey + 13, P['e'])
    elif eye == 'hurt':
        for (r, c) in EYE: L_.put(ex + c, ey + r, P['s'])
        L_.put(ex + 13, ey + 12, P['e']); L_.put(ex + 14, ey + 13, P['e']); L_.put(ex + 13, ey + 14, P['e'])
    elif eye == 'dead':
        for (r, c) in EYE: L_.put(ex + c, ey + r, P['s'])
        L_.put(ex + 13, ey + 13, P['e']); L_.put(ex + 14, ey + 13, P['e']); L_.put(ex + 15, ey + 13, P['e'])
    # mouth
    if eye in ('hurt', 'dead'):
        L_.put(ex + 15, ey + 15, P['D'])
    return L_.outlined(OL)

def frame(p):
    """Build a hero frame from pose dict."""
    bx, by = p.get('bx', 0), p.get('by', 0)
    hdx, hdy = p.get('hdx', 0), p.get('hdy', 0)
    F = Layer()
    torso_x, torso_y = 9 + bx, 20 + by
    hipy = 32 + by
    # cloak (behind all)
    if p.get('cloak', True):
        F.over(draw_cloak((torso_x, torso_y - 1), p.get('sway', 0), p.get('clen', 21), p.get('flare', 0)))
    # far arm
    sh_far = (torso_x + 4, torso_y + 3)
    F.over(draw_arm(sh_far, p.get('fhand', (torso_x + 3, torso_y + 10)), True, p.get('fbend', -1)).outlined(OL))
    # legs
    legs = p.get('legs', [(0, 0), (0, 0)])
    hf = (torso_x + 5, hipy); hn = (torso_x + 7, hipy)
    if p.get('show_legs', True):
        ff = p.get('ffoot', (hf[0] + legs[0][0], 46 - legs[0][1]))
        nf = p.get('nfoot', (hn[0] + legs[1][0], 46 - legs[1][1]))
        F.over(draw_leg(hf, ff, True))
        F.over(draw_leg(hn, nf, False))
    sword_back = p.get('sword') is not None and p.get('sword_behind')
    if sword_back:
        F.over(draw_sword(p['hand'], p['sword'], p.get('slen', 11)))
    # torso
    T = Layer(); T.map(TORSO, torso_x, torso_y, P)
    F.over(T.outlined(OL))
    # head
    F.over(head_layer((7 + bx + hdx, 3 + by + hdy), p.get('eye', 'open')))
    # collar (in front of chin)
    Cl = Layer(); Cl.map(COLLAR, torso_x + 1, torso_y - 2, P)
    F.over(Cl.outlined(OL))
    # near arm + sword
    if p.get('pre_arm'):
        F.over(p['pre_arm'](torso_x, torso_y))
    sh = (torso_x + 8, torso_y + 3)
    hand = p.get('hand', (torso_x + 10, torso_y + 10))
    arm = draw_arm(sh, hand, False, p.get('nbend', -1))
    sword = draw_sword(hand, p['sword'], p.get('slen', 11)) if p.get('sword') is not None else None
    F.over(arm.outlined(OL))
    Pd = Layer(); Pd.map(PAULDRON, sh[0] - 3, sh[1] - 3, P)
    F.over(Pd.outlined(OL))
    if sword and not p.get('sword_behind'):
        F.over(sword)
        # re-draw hand on top of grip
        hl = Layer(); hl.rect(hand[0], hand[1], hand[0] + 1, hand[1] + 1, P['s']); F.over(hl)
    if p.get('fx'):
        F.over(p['fx'])
    return F

# ---------------- animations ----------------
def idle():
    out = []
    for i in range(4):
        b = [0, 0, 1, 1][i]
        out.append(frame(dict(by=b, hdy=0, sword=62 + [0, 0, 2, 2][i], sway=[0, -1, -1, 0][i],
                              hand=(19, 30 + b), fhand=(12, 30 + b), legs=[(-1, 0), (1, 0)],
                              ffoot=(13, 46), nfoot=(17, 46))))
    return out

def walk():
    out = []
    for i in range(8):
        ph = 2 * math.pi * i / 8
        c, s = math.cos(ph), math.sin(ph)
        nd = round(4 * c); fd = -nd
        nl = round(max(0, s) * 2.4); fl = round(max(0, -s) * 2.4)
        bob = 0 if abs(c) > 0.8 else -1
        bob = 1 if abs(c) > 0.99 else (0 if abs(c) > 0.5 else -1)
        bob = [1, 0, -1, 0, 1, 0, -1, 0][i]
        sw = round(-2.5 * c)  # near arm swings opposite near leg
        out.append(frame(dict(by=bob, sword=55 - sw * 4, sway=-1 - (1 if abs(s) > 0.5 else 0),
                              legs=[(fd, fl), (nd, nl)],
                              hand=(19 + sw, 29 + bob), fhand=(12 - sw, 29 + bob))))
    return out

def swoosh(points, col):
    L_ = Layer()
    for (x, y) in points: L_.put(x, y, col)
    return L_

def attack():
    st = dict(legs=[(-3, 0), (3, 0)], ffoot=(11, 46), nfoot=(19, 46))
    f = []
    # 0 anticipation: sword raised up behind head
    f.append(frame(dict(st, bx=-1, by=1, hand=(13, 26), sword=190, fhand=(10, 28), nbend=1, sway=1)))
    # 1 wind-up: sword cocked back over the shoulder
    f.append(frame(dict(st, bx=-2, by=1, hand=(11, 24), sword=208, fhand=(9, 27), nbend=1, sway=2)))
    # 2 swing: arm forward-up, blade diagonal forward-up, smear arc
    sw = swoosh([(4, 13), (5, 11), (7, 9), (9, 7), (11, 5), (13, 3), (15, 2), (17, 1), (19, 1), (21, 2), (23, 3), (25, 5), (26, 7)], P['l'])
    f.append(frame(dict(st, bx=1, by=0, hand=(21, 19), sword=-50, fhand=(13, 27), sway=-2, fx=sw)))
    # 3 strike: full extension forward
    sw2 = swoosh([(28, 11), (29, 13), (30, 15), (30, 17), (30, 19), (30, 21), (29, 23), (29, 25), (28, 27)], P['d'])
    f.append(frame(dict(st, bx=2, by=1, hand=(21, 24), sword=12, slen=9, fhand=(13, 28), sway=-3, fx=sw2)))
    # 4 follow through: sword down-forward
    f.append(frame(dict(st, bx=2, by=2, hand=(21, 28), sword=62, fhand=(13, 29), sway=-2)))
    # 5 recover
    f.append(frame(dict(st, bx=1, by=1, hand=(20, 29), sword=62, fhand=(12, 30), sway=-1)))
    return f

def hurt():
    base = dict(legs=[(-1, 0), (1, 0)], ffoot=(13, 46), nfoot=(17, 46))
    return [
        frame(dict(base, bx=-2, by=1, hdx=-1, eye='hurt', hand=(16, 30), sword=75, fhand=(9, 28), sway=2)),
        frame(dict(base, bx=-3, by=2, hdx=-1, hdy=0, eye='hurt', hand=(15, 31), sword=85, fhand=(8, 29), sway=3)),
        frame(dict(base, bx=-1, by=1, eye='open', hand=(18, 30), sword=68, fhand=(11, 30), sway=1)),
    ]

DW = 48  # death frames are 48 wide (body stays at x=16 so origin (16,47) is unchanged)

def widen(L_):
    return resized(L_, DW, 48)

def death():
    base = dict(legs=[(-1, 0), (1, 0)], ffoot=(13, 46), nfoot=(17, 46))
    f = []
    f.append(frame(dict(base, bx=-2, by=1, hdx=-1, eye='hurt', hand=(16, 30), sword=80, fhand=(9, 28), sway=2)))
    f.append(frame(dict(by=4, bx=-1, eye='hurt', hand=(18, 34), sword=88, fhand=(10, 33), sway=1,
                        ffoot=(11, 46), nfoot=(19, 46), clen=18)))
    kneel = frame(dict(by=8, bx=0, hdx=1, hdy=1, eye='shut', hand=(19, 38), sword=None, fhand=(12, 37), sway=0,
                       ffoot=(10, 46), nfoot=(20, 46), clen=15, flare=1))
    f.append(kneel)
    # tipping forward around the knees
    k = widen(kneel)
    tip = rotsprite(k, 40, 18, 46)
    x0, y0, x1, y1 = tip.bbox(); tip = tip.shifted(0, 47 - y1)
    f.append(tip)
    # face down on the ground (full body rotated 90 CW), then settle
    full = frame(dict(legs=[(-1, 0), (1, 0)], ffoot=(14, 46), nfoot=(16, 46), hand=(19, 31), sword=None,
                      fhand=(13, 31), eye='dead', sway=-2, clen=20))
    R = full.rot90cw()   # 48x32
    x0, y0, x1, y1 = R.bbox()
    down = Layer(DW, 48); down.over(R, 0 - x0 + 1, 47 - y1 - 1)
    f.append(down)
    settle = Layer(DW, 48); settle.over(R, 0 - x0 + 1, 47 - y1)
    # dropped sword lying on the ground in front
    f.append(settle)
    return [widen(x) if x.w == 32 else x for x in f]

if __name__ == '__main__':
    od = '/workspace/sprites/hero'; os.makedirs(od, exist_ok=True)
    anims = [('idle', idle()), ('walk', walk()), ('attack', attack()), ('hurt', hurt()), ('death', death())]
    rows = []
    for name, fr in anims:
        im = strip(fr)
        fn = f'{od}/spr_hero_{name}_strip{len(fr)}.png'
        im.save(fn)
        bad = check_palette(im, PALHEX.values())
        if bad: print('PALETTE VIOLATION', name, list(bad)[:5])
        fw = fr[0].w
        rows.append((f'spr_hero_{name}_strip{len(fr)}  ({len(fr)}f, {fw}x48)', im, fw))
        if name == 'walk': gif(im, 32, f'{od}/hero_walk_preview.gif', 6, 100)
    preview(rows, f'{od}/hero_preview.png', 'HERO  -  32x48 frames, origin (16,47)')
    print('ok')
