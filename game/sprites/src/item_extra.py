"""Missing 16x16 item icons (Ether, Chain Mail) in the Chapter 1 icon style.

Run from game/sprites/:
    python3 src/item_extra.py

Writes spr_item_ether.png, spr_item_chain_mail.png and their _disabled variants into
game/sprites/items/. The disabled copies are desaturated and dimmed the way the existing
disabled item icons read in the bag.
"""
import os

from PIL import Image

HERE = os.path.dirname(__file__)
OUT = os.path.abspath(os.path.join(HERE, '..', 'items'))


def hx(value):
    value = value.lstrip('#')
    return tuple(int(value[i:i + 2], 16) for i in (0, 2, 4))


PALETTE = {
    '.': None,
    'o': hx('#1A1A1A'),
    # Ether: cork, blue glass, liquid, label
    'c': hx('#6B442E'), 'C': hx('#A6815E'),
    'g': hx('#2B4A7A'), 'G': hx('#3B6FA8'), 'l': hx('#7FB6D9'), 'w': hx('#D8F2FF'),
    'p': hx('#D0B58A'), 'P': hx('#8F6B4D'),
    # Chain Mail: three steel tones
    'M': hx('#505864'), 'm': hx('#78828F'), 'n': hx('#A8B2BF'), 'd': hx('#3A4048'),
}

ETHER = [
    "................",
    "......ooo.......",
    ".....ocCco......",
    ".....ocCco......",
    "......ogo.......",
    ".....ogGgo......",
    "....ogGGGgo.....",
    "...ogGlllGgo....",
    "..ogGllwllGgo...",
    "..ogGlppplGgo...",
    "..ogGlpPplGgo...",
    "..ogGGlllGGgo...",
    "..ogGGGGGGGgo...",
    "..oggGGGGGggo...",
    "...ogggggggo....",
    "....ooooooo.....",
    "................",
]

CHAIN = [
    "................",
    ".....oooooo.....",
    "....oMmmmmMo....",
    "...oMmo..oMMo...",
    "...oMmo..oMMo...",
    "..oMmmo..oMMMo..",
    ".oMmmno..onMMMo.",
    ".oMmmmmmmmmmmMo.",
    ".oMmmmmmmmmmmMo.",
    ".oMmdmmddmmdmmo.",
    "..oMmdmmdmmdmo..",
    "..oMmmdmmdmmmo..",
    "...oMmmdmdmmo...",
    "....oMmmmmmo....",
    ".....oooooo.....",
    "................",
]


def draw(grid, path):
    im = Image.new('RGBA', (16, 16), (0, 0, 0, 0))
    for y, row in enumerate(grid):
        if len(row) != 16:
            raise SystemExit(f'{path}: row {y} is {len(row)} cells, expected 16')
        for x, ch in enumerate(row):
            col = PALETTE.get(ch)
            if col is not None:
                im.putpixel((x, y), col + (255,))
    im.save(path)
    return im


def disabled(im):
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = im.getpixel((x, y))
            if a == 0:
                continue
            grey = int(0.30 * r + 0.59 * g + 0.11 * b)
            grey = max(0, min(255, int(grey * 0.78)))
            out.putpixel((x, y), (grey, grey, grey, a))
    return out


def main():
    os.makedirs(OUT, exist_ok=True)
    for name, grid in (('spr_item_ether', ETHER), ('spr_item_chain_mail', CHAIN)):
        im = draw(grid, os.path.join(OUT, name + '.png'))
        disabled(im).save(os.path.join(OUT, name + '_disabled.png'))
        print(f'wrote {name}.png and {name}_disabled.png')


if __name__ == '__main__':
    main()
