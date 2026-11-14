import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from pix import *

def mirror_half(half, mid_extra=''):
    """half: rows of left half; returns full symmetric grid string."""
    rows = [r.strip() for r in half.strip('\n').split('\n')]
    return '\n'.join(r + r[::-1] for r in rows)

def grid_rows(g):
    return [list(r.strip()) for r in g.strip('\n').split('\n')]

def rows_to_grid(rows):
    return '\n'.join(''.join(r) for r in rows)

def poke(g, edits):
    """edits: list of (row, col, ch)."""
    rows = grid_rows(g)
    for r, c, ch in edits:
        rows[r][c] = ch
    return rows_to_grid(rows)

def mirror_layer(L_):
    o = Layer(L_.w, L_.h)
    for (x, y), c in L_.px.items(): o.put(L_.w - 1 - x, y, c)
    return o

def save_set(od, prefix, sets, fw, pal_hex, title, gif_scale=6):
    """sets: list of (dir, idle_layer, [walk layers]). Writes strips; returns preview rows."""
    os.makedirs(od, exist_ok=True)
    rows = []
    for d, idle, walk in sets:
        im_i = strip([idle]); im_w = strip(walk)
        fi = f'{od}/{prefix}_idle_{d}.png'; fwk = f'{od}/{prefix}_walk_{d}_strip{len(walk)}.png'
        im_i.save(fi); im_w.save(fwk)
        for im, n in ((im_i, fi), (im_w, fwk)):
            bad = check_palette(im, pal_hex)
            if bad: print('PALETTE VIOLATION', n, list(bad)[:4])
        rows.append((f'{os.path.basename(fi)}  +  {os.path.basename(fwk)}', 
                     _join(im_i, im_w, fw), fw))
    return rows

def _join(a, b, fw):
    # idle frame, one blank gap frame, then walk strip (preview only)
    im = Image.new('RGBA', (a.size[0] + fw + b.size[0], a.size[1]), (0, 0, 0, 0))
    im.paste(a, (0, 0)); im.paste(b, (a.size[0] + fw, 0))
    return im

def gif_4dir(walks, fw, fh, path, scale=6, ms=150):
    """walks: list of 4 walk strips (down, left, right, up); shows all 4 side by side animating."""
    n = max(len(w) for w in walks)
    frames = []
    for i in range(n):
        f = Image.new('RGBA', (fw * 4 + 3 * 4, fh), BG)
        for k, w in enumerate(walks):
            fr = w[i % len(w)].image()
            f.alpha_composite(fr, (k * (fw + 4), 0))
        frames.append(f.convert('RGB').resize((f.size[0] * scale, fh * scale), Image.NEAREST))
    frames[0].save(path, save_all=True, append_images=frames[1:], duration=ms, loop=0, disposal=2)
