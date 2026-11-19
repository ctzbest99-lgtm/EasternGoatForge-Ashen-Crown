"""Missing 10x10 status icons: Blind (frame 0) and Sleep (frame 1).

Run from game/sprites/:
    python3 src/status_extra.py

Writes ui/spr_ui_status_extra_strip2.png. The existing 12-frame status strip keeps its
frame indices untouched; the battle HUD draws these two from the extra strip.
"""
import os

from PIL import Image

HERE = os.path.dirname(__file__)
OUT = os.path.abspath(os.path.join(HERE, '..', 'ui'))

PALETTE = {
    '.': None,
    'o': (26, 26, 26),
    'w': (232, 236, 248),
    'b': (176, 138, 208),
    'r': (192, 80, 80),
    's': (159, 184, 232),
    'S': (216, 232, 255),
}

BLIND = [
    "..........",
    "...oooo...",
    "..o....o..",
    ".o.wwww.o.",
    "o.wwwwww.o",
    ".o.wwww.o.",
    "..o....o..",
    "...oooo...",
    "..........",
    "..........",
]

SLEEP = [
    "..........",
    "..oooooo..",
    ".....o....",
    "....o.....",
    "...o......",
    "..oooooo..",
    "...ssss...",
    ".....s....",
    "....s.....",
    "...ssss...",
]

# Red diagonal across the eye, drawn after the white so it reads as a blindfold/slash.
SLASH = [(2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7)]


def draw(grid, slash=False):
    im = Image.new('RGBA', (10, 10), (0, 0, 0, 0))
    for y, row in enumerate(grid):
        if len(row) != 10:
            raise SystemExit(f'row {y} is {len(row)} cells, expected 10')
        for x, ch in enumerate(row):
            col = PALETTE.get(ch)
            if col is not None:
                im.putpixel((x, y), col + (255,))
    if slash:
        for x, y in SLASH:
            im.putpixel((x, y), PALETTE['r'] + (255,))
    return im


def main():
    os.makedirs(OUT, exist_ok=True)
    blind = draw(BLIND, slash=True)
    sleep = draw(SLEEP)
    out = Image.new('RGBA', (20, 10), (0, 0, 0, 0))
    out.paste(blind, (0, 0))
    out.paste(sleep, (10, 0))
    out.save(os.path.join(OUT, 'spr_ui_status_extra_strip2.png'))
    print('wrote ui/spr_ui_status_extra_strip2.png')


if __name__ == '__main__':
    main()
