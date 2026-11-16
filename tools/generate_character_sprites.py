#!/usr/bin/env python3
"""Placeholder 32x48 character sheets for ASHEN CROWN: walk, attack, hurt.

Implements docs/CHARACTER_MODELS.md: 32x48 frames, four directions x four walk
frames, row order down/left/right/up, origin (16,46), 12x6 foot mask at
x 10..21 / y 40..46. Output is placeholder art for movement and collision
testing, not final art.

Geometry rule: left-facing frames are mirrored across the 32px canvas to make
the right-facing row, so every pixel must sit symmetrically about x 15.5. That
is why the leading foot lifts instead of stepping forward, and why the boots are
17..20 rather than 18..21.

Stdlib only (no PIL): PNG is encoded by hand with zlib.

Usage:
  python3 tools/generate_character_sprites.py            # write sheets
  python3 tools/generate_character_sprites.py --preview out.png
"""

import os
import struct
import sys
import zlib

W, H = 32, 48
DIRS = ("down", "left", "right", "up")
TRANSPARENT = (0, 0, 0, 0)
OUT_DIR = os.path.join("assets", "characters")


# ---------------------------------------------------------------- colour utils
def rgba(hexstr):
    h = hexstr.lstrip("#")
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), 255)


def ramp(dark, base, light):
    """Material ramp as (base, dark, light)."""
    return (rgba(base), rgba(dark), rgba(light))


class Canvas:
    def __init__(self, w=W, h=H):
        self.w, self.h = w, h
        self.data = [[TRANSPARENT] * w for _ in range(h)]

    def px(self, x, y, col):
        if 0 <= x < self.w and 0 <= y < self.h:
            self.data[y][x] = col

    def rect(self, x0, y0, x1, y1, col):
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                self.px(x, y, col)

    def bevel(self, x0, y0, x1, y1, pal):
        """Filled block with light top/left edge and dark bottom/right edge."""
        base, dark, light = pal
        self.rect(x0, y0, x1, y1, base)
        for y in range(y0, y1 + 1):
            self.px(x0, y, light)
            self.px(x1, y, dark)
        for x in range(x0, x1 + 1):
            self.px(x, y0, light)
            self.px(x, y1, dark)

    def mirror(self):
        self.data = [row[::-1] for row in self.data]
        return self

    def outline(self, col):
        """1px outline around the whole silhouette (never pure black)."""
        src = [row[:] for row in self.data]
        for y in range(self.h):
            for x in range(self.w):
                if src[y][x][3] != 0:
                    continue
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < self.w and 0 <= ny < self.h and src[ny][nx][3] != 0:
                        self.data[y][x] = col
                        break
        return self

    def clear(self, x0, y0, x1, y1):
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                self.px(x, y, TRANSPARENT)

    def blit(self, other, ox, oy):
        for y in range(other.h):
            for x in range(other.w):
                col = other.data[y][x]
                if col[3] != 0:
                    self.px(ox + x, oy + y, col)


def pal(style, key):
    value = style[key]
    return value if isinstance(value, tuple) else style[value]


# ------------------------------------------------------------------ characters
KAEL = dict(
    outline=rgba("#100E0E"),
    skin=ramp("#9C7350", "#C79A72", "#E3BC94"),
    hair=ramp("#5F523D", "#8A7A5C", "#B7A87F"),
    cloak=ramp("#1E272C", "#2E3B42", "#465961"),
    leather=ramp("#482C1D", "#6B4630", "#8C603F"),
    steel=ramp("#545A62", "#8C9096", "#C3C8CE"),
    accent=ramp("#5E1C1C", "#8E2F2F", "#B14A44"),
    torso="cloak", legs="cloak", boots="leather",
    head="hair", cape=True, pauldron=True, item="sword", shoulder=6,
)

BANDIT = dict(
    outline=rgba("#100E0E"),
    skin=ramp("#8E6446", "#B98862", "#D6A97F"),
    hood=ramp("#3B3529", "#5A5140", "#7A7159"),
    tunic=ramp("#3A4229", "#55603C", "#74805A"),
    leather=ramp("#2F2418", "#4C3A2A", "#6B5138"),
    steel=ramp("#5E6469", "#9AA0A6", "#C6CBD0"),
    accent=ramp("#511A1A", "#7E2A2A", "#A33B34"),
    torso="tunic", legs="tunic", boots="leather",
    head="hood", cape=False, pauldron=False, item="dagger", shoulder=5,
)

FALLEN = dict(
    outline=rgba("#0C0D10"),
    plate=ramp("#343A44", "#5C636E", "#9AA3AF"),
    rust=ramp("#52301B", "#7A4A2C", "#9E6A42"),
    tabard=ramp("#48201F", "#6E2A2E", "#8C3A38"),
    glow=rgba("#A8C8C0"),
    void=rgba("#141A1A"),
    trim=ramp("#6B5220", "#9C7A3A", "#C4A05C"),
    skin=ramp("#2B3038", "#454C56", "#6E7681"),   # gauntlet interior
    leather=ramp("#3A2A20", "#5A4230", "#7A5A42"),
    accent="tabard", steel="plate",
    torso="plate", legs="plate", boots="plate",
    head="helm", cape=True, pauldron=True, item="sword", shoulder=8,
)


# ----------------------------------------------------------------- draw pieces
def legs_front(c, s, lift_l, lift_r):
    """Front/back view: one foot lifts per contact frame.

    Feet never slide sideways here: this is a top-down front view, and the 12x6
    foot mask (x 10..22) has to contain the boots plus their outline.
    """
    lp, bp = pal(s, "legs"), pal(s, "boots")
    c.rect(11, 34, 14, 42 - lift_l, lp[1])
    c.rect(17, 34, 20, 42 - lift_r, lp[1])
    c.bevel(11, 43 - lift_l, 14, 45 - lift_l, bp)
    c.bevel(17, 43 - lift_r, 20, 45 - lift_r, bp)


def legs_side(c, s, front_lift, back_off):
    """Side view: trailing leg swings back, leading foot lifts.

    The leading boot cannot step forward: its outline would leave the 12x6 mask
    (x 10..22), so the stride is carried by the back leg instead.
    """
    lp, bp = pal(s, "legs"), pal(s, "boots")
    c.rect(14 + back_off, 34, 17 + back_off, 42, lp[1])
    c.bevel(13 + back_off, 43, 18 + back_off, 45, bp[0:1] + (bp[1], bp[0]))
    c.rect(12, 34, 15, 42 - front_lift, lp[0])
    c.bevel(11, 43 - front_lift, 16, 45 - front_lift, bp)


def body_front(c, s):
    tp, lr, ac, st = pal(s, "torso"), pal(s, "leather"), pal(s, "accent"), pal(s, "steel")
    half = s["shoulder"]
    c.bevel(16 - half, 17, 16 + half, 30, tp)
    c.bevel(16 - half, 31, 16 + half, 32, lr)          # belt
    c.px(16, 31, st[2])                                # buckle
    c.rect(16 - half + 1, 15, 16 + half - 1, 16, ac[0])  # scarf / gorget
    c.rect(7, 18, 9, 29, tp[1])                        # arms
    c.rect(23, 18, 25, 29, tp[0])
    c.rect(7, 30, 9, 31, pal(s, "skin")[0])            # hands
    c.rect(23, 30, 25, 31, pal(s, "skin")[0])
    if s["pauldron"]:
        c.bevel(22, 16, 26, 20, st)


def body_back(c, s):
    tp, lr = pal(s, "torso"), pal(s, "leather")
    half = s["shoulder"]
    if s["cape"]:
        c.rect(16 - half - 1, 16, 16 + half + 1, 33, tp[1])
        c.rect(16 - half - 1, 16, 16 - half - 1, 33, tp[0])
        for x in range(16 - half - 1, 16 + half + 2):  # ragged hem
            if x % 3 == 0:
                c.px(x, 34, tp[1])
    else:
        c.bevel(16 - half, 17, 16 + half, 30, tp)
    c.bevel(16 - half, 31, 16 + half, 32, lr)
    c.rect(7, 18, 9, 29, tp[1])
    c.rect(23, 18, 25, 29, tp[1])
    if s["pauldron"]:
        c.bevel(22, 16, 26, 20, pal(s, "steel"))


def body_side(c, s):
    tp, lr, st = pal(s, "torso"), pal(s, "leather"), pal(s, "steel")
    c.bevel(11, 17, 20, 30, tp)
    c.bevel(11, 31, 20, 32, lr)
    c.px(12, 31, st[2])
    if s["cape"]:
        c.rect(19, 17, 21, 32, tp[1])
    c.rect(12, 18, 14, 29, tp[0])                      # visible arm
    c.rect(12, 30, 14, 31, pal(s, "skin")[0])


# ----------------------------------------------------------------------- heads
def head_front(c, s):
    sk = pal(s, "skin")
    if s["head"] == "hair":
        hp = s["hair"]
        c.rect(11, 3, 21, 8, hp[0])
        c.rect(11, 3, 21, 4, hp[2])
        c.rect(11, 7, 21, 8, hp[1])
        c.rect(11, 5, 11, 12, hp[1])
        c.rect(21, 5, 21, 12, hp[1])
        c.rect(12, 9, 20, 14, sk[0])
        for x in range(12, 21):
            c.px(x, 14, sk[1])
        c.px(14, 11, s["outline"])
        c.px(18, 11, s["outline"])
        c.rect(15, 13, 17, 13, sk[1])
    elif s["head"] == "hood":
        hp, ak = s["hood"], pal(s, "accent")
        c.rect(11, 2, 21, 12, hp[0])
        c.rect(11, 2, 12, 12, hp[2])
        c.rect(13, 8, 19, 13, sk[0])
        c.rect(12, 12, 20, 13, ak[0])                  # mask / bandana
        c.px(15, 10, s["outline"])
        c.px(18, 10, s["outline"])
    else:  # helm
        pl, ru = s["plate"], s["rust"]
        c.rect(10, 2, 22, 13, pl[0])
        c.rect(10, 2, 11, 13, pl[2])
        c.rect(12, 8, 20, 9, s["void"])                # visor slit
        c.px(14, 8, s["glow"])
        c.px(18, 8, s["glow"])
        c.rect(10, 12, 22, 13, ru[1])                  # rusted jaw
        c.rect(15, 1, 17, 2, ru[2])                    # crest stub


def head_back(c, s):
    if s["head"] == "hair":
        hp = s["hair"]
        c.rect(11, 3, 21, 14, hp[0])
        c.rect(11, 3, 21, 4, hp[2])
        c.rect(11, 12, 21, 14, hp[1])
    elif s["head"] == "hood":
        hp = s["hood"]
        c.rect(11, 2, 21, 13, hp[0])
        c.rect(11, 2, 12, 13, hp[2])
        c.rect(13, 11, 19, 13, hp[1])
    else:
        pl, ru = s["plate"], s["rust"]
        c.rect(10, 2, 22, 13, pl[0])
        c.rect(10, 2, 11, 13, pl[2])
        c.rect(10, 12, 22, 13, ru[1])
        c.rect(15, 1, 17, 2, ru[2])


def head_side(c, s):
    sk = pal(s, "skin")
    if s["head"] == "hair":
        hp = s["hair"]
        c.rect(12, 3, 20, 14, sk[0])
        c.rect(12, 3, 20, 5, hp[0])                    # fringe
        c.rect(16, 4, 20, 13, hp[1])                   # back of head
        c.px(13, 11, s["outline"])
    elif s["head"] == "hood":
        hp = s["hood"]
        c.rect(12, 2, 20, 13, hp[0])
        c.rect(18, 3, 20, 13, hp[1])
        c.rect(12, 8, 16, 12, sk[0])
        c.rect(12, 11, 17, 12, pal(s, "accent")[0])
        c.px(14, 9, s["outline"])
    else:
        pl, ru = s["plate"], s["rust"]
        c.rect(11, 2, 21, 13, pl[0])
        c.rect(11, 8, 13, 9, s["void"])
        c.px(12, 8, s["glow"])
        c.rect(11, 12, 21, 13, ru[1])
        c.rect(15, 1, 17, 2, ru[2])


# ----------------------------------------------------------------------- items
def draw_item(c, s, dirn):
    if s["item"] == "none":
        return
    st = pal(s, "steel")
    lr = pal(s, "leather")
    if dirn == "down":
        c.rect(26, 20, 27, 33, st[0])                  # blade
        for y in range(20, 34):
            c.px(26, y, st[2])
        c.rect(25, 34, 28, 35, lr[1])                  # grip
    elif dirn == "left":
        c.rect(5, 22, 6, 33, st[0])
        for y in range(22, 34):
            c.px(6, y, st[2])
        c.rect(4, 34, 7, 35, lr[1])


# ------------------------------------------------------------------- assembly
BLADE_LEN = {"sword": 18, "dagger": 9}


def draw_arm(c, s, x0, x1, y0, y1):
    """Arm from a shoulder at y0 down to a skin hand at y1."""
    tp, sk = pal(s, "torso"), pal(s, "skin")
    c.rect(x0, y0, x1, y1 - 2, tp[0])
    c.rect(x0, y1 - 1, x1, y1, sk[0])


def draw_blade(c, s, x0, y0, x1, y1, along_x):
    """Blade with a lit edge and a leather grip just past its base."""
    st, lr = pal(s, "steel"), pal(s, "leather")
    c.rect(x0, y0, x1, y1, st[0])
    if along_x:
        for x in range(x0, x1 + 1):
            c.px(x, y0, st[2])
        c.rect(x1 + 1, y0 - 1, x1 + 3, y1 + 1, lr[1])
    else:
        for y in range(y0, y1 + 1):
            c.px(x0, y, st[2])
        c.rect(x0 - 1, y1 + 1, x1 + 1, y1 + 2, lr[1])


def base_pose(c, s, dirn, legs_args):
    """Legs, torso and head for a non-walking pose."""
    if dirn == "up":
        legs_front(c, s, *legs_args[0])
        body_back(c, s)
        head_back(c, s)
    elif dirn == "down":
        legs_front(c, s, *legs_args[0])
        body_front(c, s)
        head_front(c, s)
    else:
        legs_side(c, s, *legs_args[1])
        body_side(c, s)
        head_side(c, s)


def build_walk_frame(s, dirn, frame):
    if dirn == "right":
        return build_walk_frame(s, "left", frame).mirror()
    c = Canvas()
    if dirn == "up":
        legs_front(c, s, *[(0, 1), (0, 0), (1, 0), (0, 0)][frame])
        body_back(c, s)
        head_back(c, s)
    elif dirn == "down":
        legs_front(c, s, *[(1, 0), (0, 0), (0, 1), (0, 0)][frame])
        body_front(c, s)
        head_front(c, s)
    else:
        legs_side(c, s, *[(0, 2), (0, 0), (1, 1), (0, 1)][frame])
        body_side(c, s)
        head_side(c, s)
    draw_item(c, s, dirn)
    c.outline(s["outline"])
    return c


def build_attack_frame(s, dirn, frame):
    """Three frames: windup (blade raised), strike (swept across), recover (blade low)."""
    if dirn == "right":
        return build_attack_frame(s, "left", frame).mirror()
    c = Canvas()
    base_pose(c, s, dirn, ((0, 0), (0, 1)))
    blade = BLADE_LEN.get(s["item"], 10)
    sk = pal(s, "skin")

    if dirn in ("down", "up"):
        c.clear(7, 18, 9, 32)          # clear the resting arms, then redraw in action
        c.clear(23, 18, 25, 32)
        draw_arm(c, s, 7, 9, 18, 30)
        if frame == 0:
            draw_arm(c, s, 23, 25, 16, 24)
            draw_blade(c, s, 25, 3, 26, 15, False)
        elif frame == 1:
            draw_arm(c, s, 20, 26, 21, 23)
            draw_blade(c, s, max(2, 24 - blade), 21, 24, 22, True)
            c.px(24, 23, sk[0])
        else:                                   # recover: blade held low, still attached to the hand
            draw_arm(c, s, 23, 25, 24, 29)
            c.rect(25, 29, 27, 30, pal(s, "leather")[1])
            c.rect(26, 31, 27, 38, pal(s, "steel")[0])
            for y in range(31, 39):
                c.px(26, y, pal(s, "steel")[2])
    else:
        c.clear(12, 18, 16, 32)
        if frame == 0:
            draw_arm(c, s, 12, 14, 16, 24)
            draw_blade(c, s, 11, 4, 12, 15, False)
        elif frame == 1:
            draw_arm(c, s, 12, 15, 21, 23)
            draw_blade(c, s, max(1, 12 - blade), 21, 12, 22, True)
        else:                                   # recover: blade held low, still attached to the hand
            draw_arm(c, s, 12, 14, 24, 29)
            c.rect(10, 29, 12, 30, pal(s, "leather")[1])
            c.rect(9, 31, 10, 38, pal(s, "steel")[0])
            for y in range(31, 39):
                c.px(9, y, pal(s, "steel")[2])
    return c.outline(s["outline"])


def build_hurt_frame(s, dirn, frame=0):
    """Single flinch pose per direction: arms flung up, weapon dropped."""
    if dirn == "right":
        return build_hurt_frame(s, "left", 0).mirror()
    c = Canvas()
    base_pose(c, s, dirn, ((0, 0), (0, 1)))
    if dirn in ("down", "up"):
        c.clear(7, 18, 9, 32)
        c.clear(23, 18, 25, 32)
        draw_arm(c, s, 7, 9, 16, 19)
        draw_arm(c, s, 23, 25, 16, 19)
    else:
        c.clear(12, 18, 16, 32)
        draw_arm(c, s, 12, 14, 16, 19)
    return c.outline(s["outline"])


def build_grid(s, cols, builder):
    """Sheet with one row per direction (down, left, right, up) and `cols` frames."""
    sheet = Canvas(W * cols, H * 4)
    for row, dirn in enumerate(DIRS):
        for frame in range(cols):
            sheet.blit(builder(s, dirn, frame), frame * W, row * H)
    return sheet


def build_shadow():
    c = Canvas(16, 4)
    shades = [(0, 0, 0, 70), (0, 0, 0, 110), (0, 0, 0, 110), (0, 0, 0, 70)]
    spans = [(5, 10), (1, 14), (1, 14), (5, 10)]
    for y, ((x0, x1), col) in enumerate(zip(spans, shades)):
        c.rect(x0, y, x1, y, col)
    return c


# ------------------------------------------------------------------------- png
def write_png(path, canvas, scale=1, bg=None):
    width, height = canvas.w, canvas.h
    rows = []
    for y in range(height):
        row = bytearray()
        for x in range(width):
            px = canvas.data[y][x]
            if px[3] == 0 and bg is not None:
                px = bg
            row += bytes(px) * scale
        for _ in range(scale):
            rows.append(bytes(row))
    raw = b"".join(b"\x00" + r for r in rows)

    def chunk(tag, data):
        return (struct.pack(">I", len(data)) + tag + data
                + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF))

    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(b"IHDR", struct.pack(">IIBBBBB", width * scale, height * scale,
                                      8, 6, 0, 0, 0))
    png += chunk(b"IDAT", zlib.compress(raw, 9))
    png += chunk(b"IEND", b"")
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "wb") as fh:
        fh.write(png)


def write_preview(path, sheets, scale=5):
    gap = 2
    total_w = sum(s.w for s in sheets) + gap * (len(sheets) - 1)
    total_h = max(s.h for s in sheets)
    canvas = Canvas(total_w, total_h)
    x = 0
    for s in sheets:
        canvas.blit(s, x, 0)
        x += s.w + gap
    write_png(path, canvas, scale=scale, bg=(26, 26, 30, 255))


def check_sheet(name, sheet, outline, cols):
    """Verify one sheet against the model sheet rules. Returns a list of problems."""
    problems = []
    poses = {}
    for row in range(4):
        for f in range(cols):
            ox, oy = f * W, row * H
            op = [(x - ox, y - oy) for y in range(oy, oy + H)
                  for x in range(ox, ox + W) if sheet.data[y][x][3]]
            poses[(row, f)] = frozenset(op)
            if not op:
                problems.append("%s: frame row %d col %d is empty" % (name, row, f))
                continue
            ys = [y for _, y in op]
            if max(ys) != 46:
                problems.append("%s: row %d col %d bottom %d (want 46)"
                                % (name, row, f, max(ys)))
            if min(ys) == 0 and any(sheet.data[oy][ox + x] != outline for x, y in op if y == 0):
                problems.append("%s: row %d col %d clipped at the top row" % (name, row, f))
            for y in range(40, 47):
                for x in range(W):
                    if sheet.data[oy + y][ox + x][3] and not (10 <= x <= 21):
                        problems.append("%s: row %d col %d foot outside mask x=%d y=%d"
                                        % (name, row, f, x, y))
    for row in range(4):
        if cols > 1 and len({poses.get((row, f), frozenset()) for f in range(cols)}) < 2:
            problems.append("%s: direction row %d has no pose variation" % (name, row))
    for f in range(cols):
        mirrored = frozenset((W - 1 - x, y) for x, y in poses.get((1, f), ()))
        if mirrored != poses.get((2, f)):
            problems.append("%s: left/right col %d are not exact mirrors" % (name, f))
    return problems


def main(argv):
    sheets = [
        ("spr_kael_walk.png", build_grid(KAEL, 4, build_walk_frame), KAEL["outline"], 4),
        ("spr_kael_attack.png", build_grid(KAEL, 3, build_attack_frame), KAEL["outline"], 3),
        ("spr_kael_hurt.png", build_grid(KAEL, 1, build_hurt_frame), KAEL["outline"], 1),
        ("spr_bandit_walk.png", build_grid(BANDIT, 4, build_walk_frame), BANDIT["outline"], 4),
        ("spr_fallen_knight_walk.png", build_grid(FALLEN, 4, build_walk_frame),
         FALLEN["outline"], 4),
        ("spr_shadow.png", build_shadow(), None, 1),
    ]
    problems = []
    frames = 0
    for name, sheet, outline, cols in sheets:
        out = os.path.join(OUT_DIR, name)
        write_png(out, sheet)
        print("wrote %s (%dx%d)" % (out, sheet.w, sheet.h))
        if outline is not None:
            frames += cols * 4
            problems += check_sheet(name.replace(".png", ""), sheet, outline, cols)
    if "--preview" in argv:
        target = argv[argv.index("--preview") + 1]
        walk = ("spr_kael_walk.png", "spr_bandit_walk.png", "spr_fallen_knight_walk.png")
        write_preview(target, [sheet for name, sheet, _, _ in sheets if name in walk])
        print("wrote preview %s" % target)
    if problems:
        print("FAILED %d check(s):" % len(problems))
        for p in problems[:20]:
            print("  " + p)
        return 1
    print("checked %d frames: bounds, foot mask, mirrored left/right, pose variation OK" % frames)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
