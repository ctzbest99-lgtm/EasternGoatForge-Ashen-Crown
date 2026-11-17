"""Render the rooms as the game builds them at runtime.

The room .yy tile layers are empty on purpose: each room's Creation Code calls
`scr_build_<room>()`, which clears the named layers and fills them from the flat
`ground` / `decor` / `overhead` arrays in `scr_<room>_data()`. Rendering the .yy layers
therefore shows nothing; this tool renders the authored arrays instead.

    python3 tools/render_built_maps.py                 # all rooms -> /tmp/map_*.png
    python3 tools/render_built_maps.py rm_greyhaven_tavern
"""
import os
import re
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS = os.path.join(ROOT, 'game', 'scripts')
# ts_wrenfield rows 0-49 are ts_zone1 unchanged, so it renders every room (and its extra rows
# matter for the Chapter 2-5 rooms, which build against ts_wrenfield).
ATLAS = os.path.join(ROOT, 'game', 'tilesets', 'ts_wrenfield.png')
# The Chapter 6 rooms build against ts_blackwood (rows 0-49 are ts_zone1, rows 50-64 are the
# Blackwood's own dark material), so they need that atlas to render correctly.
BLACKWOOD_ATLAS = os.path.join(ROOT, 'game', 'tilesets', 'ts_blackwood.png')


def parse_room(builder):
    path = os.path.join(SCRIPTS, 'scr_build_' + builder + '.gml')
    text = open(path, encoding='utf-8').read()
    m = re.search(r'scr_map_build_from_arrays\(\s*[A-Za-z_][\w]*\(?[^,]*,\s*(\d+)\s*,\s*(\d+)\s*\)', text)
    if not m:
        return None
    w, h = int(m.group(1)), int(m.group(2))
    layers = {}
    for key in ('ground', 'decor', 'overhead'):
        am = re.search(key + r':\s*\[(.*?)\]', text, re.S)
        if not am:
            return None
        vals = [int(v) for v in re.findall(r'\d+', am.group(1))]
        layers[key] = vals
    return w, h, layers


def render(name, w, h, layers, scale=1):
    atlas = Image.open(BLACKWOOD_ATLAS if name.startswith(('blackwood_', 'ashlands_')) else ATLAS).convert('RGBA')
    across = atlas.width // 16
    im = Image.new('RGBA', (w * 16, h * 16), (12, 12, 14, 255))
    for key in ('ground', 'decor', 'overhead'):
        cells = layers[key]
        for n, v in enumerate(cells):
            if not v:
                continue
            i, j = n % w, n // w
            if j >= h:
                break
            sx, sy = (v % across) * 16, (v // across) * 16
            im.alpha_composite(atlas.crop((sx, sy, sx + 16, sy + 16)), (i * 16, j * 16))
    if scale != 1:
        im = im.resize((im.width * scale, im.height * scale), Image.NEAREST)
    out = os.path.join('/tmp', f'map_{name}.png')
    im.convert('RGB').save(out)
    return out


def main(argv):
    wanted = [a for a in argv if not a.startswith('-')]
    rooms = [n[10:-4] for n in sorted(os.listdir(SCRIPTS))
             if n.startswith('scr_build_') and n.endswith('.gml')]
    for b in rooms:
        if wanted and b not in wanted and 'rm_' + b not in wanted:
            continue
        got = parse_room(b)
        if not got:
            print(f'{b}: no scr_map_build_from_arrays data (different build path)')
            continue
        w, h, layers = got
        print(f'{b:26s} {w:3d}x{h:3d}  decor={sum(1 for v in layers["decor"] if v)}'
              f'  -> {render(b, w, h, layers)}')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
