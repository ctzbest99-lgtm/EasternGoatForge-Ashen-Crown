"""Tiny pixel-art toolkit: palette maps, thick-limb lines, per-part outlines, strips, previews."""
from PIL import Image, ImageDraw, ImageFont
import math

def hx(c):
    c = c.lstrip('#'); return (int(c[0:2],16), int(c[2:4],16), int(c[4:6],16), 255)

class Layer:
    def __init__(s, w=32, h=48):
        s.w, s.h = w, h
        s.px = {}
    def put(s, x, y, c):
        if c is None: return
        x, y = int(x), int(y)
        if 0 <= x < s.w and 0 <= y < s.h:
            s.px[(x, y)] = c
    def get(s, x, y): return s.px.get((x, y))
    def erase(s, x, y): s.px.pop((int(x), int(y)), None)
    def map(s, grid, x0, y0, pal, flip=False):
        rows = [r for r in grid.strip('\n').split('\n')]
        for j, row in enumerate(rows):
            row = row.strip()
            w = len(row)
            for i, ch in enumerate(row):
                if ch in '. ': continue
                xi = (w - 1 - i) if flip else i
                s.put(x0 + xi, y0 + j, pal[ch])
    def rect(s, x0, y0, x1, y1, c):
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1): s.put(x, y, c)
    def limb(s, x0, y0, x1, y1, cols):
        """Thick line; cols = list of colors across the limb (left->right for vertical-ish, top->bottom for horizontal-ish)."""
        dx, dy = x1 - x0, y1 - y0
        n = max(abs(dx), abs(dy), 1)
        vertical = abs(dy) >= abs(dx)
        k = len(cols)
        for t in range(n + 1):
            x = x0 + dx * t / n; y = y0 + dy * t / n
            x, y = int(round(x)), int(round(y))
            for i, c in enumerate(cols):
                o = i - (k - 1) // 2
                if vertical: s.put(x + o, y, c)
                else: s.put(x, y + o, c)
    def line(s, x0, y0, x1, y1, c):
        s.limb(x0, y0, x1, y1, [c])
    def outlined(s, oc, diag=False):
        out = Layer(s.w, s.h); out.px = dict(s.px)
        nb = [(1,0),(-1,0),(0,1),(0,-1)] + ([(1,1),(1,-1),(-1,1),(-1,-1)] if diag else [])
        for (x, y) in list(s.px):
            for ddx, ddy in nb:
                p = (x+ddx, y+ddy)
                if p not in s.px and 0 <= p[0] < s.w and 0 <= p[1] < s.h:
                    out.px[p] = oc
        return out
    def over(s, other, dx=0, dy=0):
        for (x, y), c in other.px.items(): s.put(x+dx, y+dy, c)
        return s
    def shifted(s, dx, dy):
        o = Layer(s.w, s.h)
        for (x, y), c in s.px.items(): o.put(x+dx, y+dy, c)
        return o
    def rot90ccw(s):
        """Rotate content CCW about canvas; returns layer of size (h, w)."""
        o = Layer(s.h, s.w)
        for (x, y), c in s.px.items(): o.put(y, s.w - 1 - x, c)
        return o
    def rot90cw(s):
        o = Layer(s.h, s.w)
        for (x, y), c in s.px.items(): o.put(s.h - 1 - y, x, c)
        return o
    def bbox(s):
        xs = [p[0] for p in s.px]; ys = [p[1] for p in s.px]
        return min(xs), min(ys), max(xs), max(ys)
    def image(s):
        im = Image.new('RGBA', (s.w, s.h), (0, 0, 0, 0))
        for (x, y), c in s.px.items(): im.putpixel((x, y), c)
        return im

def strip(frames):
    w, h = frames[0].w, frames[0].h
    im = Image.new('RGBA', (w * len(frames), h), (0, 0, 0, 0))
    for i, f in enumerate(frames): im.paste(f.image(), (i * w, 0))
    return im

BG = (34, 34, 44, 255)
BG2 = (44, 44, 56, 255)

def font(sz):
    try: return ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', sz)
    except Exception: return ImageFont.load_default(size=sz)

def on_bg(im, scale, checker=True):
    w, h = im.size
    bg = Image.new('RGBA', (w, h), BG)
    if checker:
        d = ImageDraw.Draw(bg)
        # frame-cell tint is drawn by caller; here a subtle baseline guide is not added
    bg.alpha_composite(im)
    return bg.resize((w * scale, h * scale), Image.NEAREST)

def preview(strips, path, title, scale=6, fw=32):
    """strips: list of (label, PIL strip image, frame_w)."""
    pad = 16; lab = 26
    W = max(s.size[0] for _, s, _ in strips) * scale + pad * 2
    H = sum(s.size[1] * scale + lab + pad for _, s, _ in strips) + 50
    sheet = Image.new('RGBA', (W, H), (22, 22, 28, 255))
    d = ImageDraw.Draw(sheet)
    d.text((pad, 12), title, fill=(230, 230, 230, 255), font=font(22))
    y = 50
    for label, s, w in strips:
        d.text((pad, y), label, fill=(200, 200, 210, 255), font=font(16))
        y += lab
        n = s.size[0] // w
        for i in range(n):
            cell = Image.new('RGBA', (w, s.size[1]), BG if i % 2 == 0 else BG2)
            cell.alpha_composite(s.crop((i * w, 0, (i + 1) * w, s.size[1])))
            sheet.paste(cell.resize((w * scale, s.size[1] * scale), Image.NEAREST), (pad + i * w * scale, y))
        y += s.size[1] * scale + pad
    sheet.convert('RGB').save(path)

def gif(strip_im, fw, path, scale=6, ms=100):
    n = strip_im.size[0] // fw
    frames = []
    for i in range(n):
        f = Image.new('RGBA', (fw, strip_im.size[1]), BG)
        f.alpha_composite(strip_im.crop((i * fw, 0, (i + 1) * fw, strip_im.size[1])))
        frames.append(f.convert('RGB').resize((fw * scale, strip_im.size[1] * scale), Image.NEAREST))
    frames[0].save(path, save_all=True, append_images=frames[1:], duration=ms, loop=0, disposal=2)

def check_palette(im, pal_hex):
    allowed = {hx(c)[:3] for c in pal_hex}
    bad = set()
    for p in im.getdata():
        if p[3] == 0: continue
        if p[3] != 255 or p[:3] not in allowed: bad.add(p)
    return bad

def _scale2x(px, w, h):
    """EPX/Scale2x on dict-of-pixels. returns (dict, 2w, 2h)."""
    g = lambda x, y: px.get((x, y))
    out = {}
    for y in range(h):
        for x in range(w):
            P_ = g(x, y); A = g(x, y-1); B = g(x+1, y); C = g(x-1, y); D = g(x, y+1)
            e0 = e1 = e2 = e3 = P_
            if A != D and C != B:
                if C == A: e0 = A
                if A == B: e1 = B
                if C == D: e2 = C
                if D == B: e3 = D
            for (dx, dy, e) in ((0,0,e0),(1,0,e1),(0,1,e2),(1,1,e3)):
                if e is not None: out[(2*x+dx, 2*y+dy)] = e
    return out, 2*w, 2*h

def rotsprite(layer, deg, cx, cy):
    """Rotate layer content by deg (clockwise positive in screen space) about (cx,cy) using 8x scale2x + nearest."""
    px, w, h = layer.px, layer.w, layer.h
    for _ in range(3): px, w, h = _scale2x(px, w, h)
    a = math.radians(deg); ca, sa = math.cos(a), math.sin(a)
    out = Layer(layer.w, layer.h)
    for y in range(layer.h):
        for x in range(layer.w):
            # inverse rotate destination pixel centre into source
            dx, dy = x + 0.5 - cx, y + 0.5 - cy
            sx = ca * dx + sa * dy + cx; sy = -sa * dx + ca * dy + cy
            c = px.get((int(math.floor(sx * 8)), int(math.floor(sy * 8))))
            if c is not None: out.put(x, y, c)
    return out

def resized(layer, w, h, dx=0, dy=0):
    o = Layer(w, h)
    for (x, y), c in layer.px.items(): o.put(x + dx, y + dy, c)
    return o
