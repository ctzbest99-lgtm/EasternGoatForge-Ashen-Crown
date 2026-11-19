"""Alden Marr, Nim and Derry: the three named speakers the art pass left as stand-ins.

Canon gives their roles, not their faces. These designs are therefore new art direction,
not story canon: they follow only what the scripts already establish.

  Alden  the rebellion's organiser, warm and precise: town coat, brass trim, satchel of
         papers, no weapon (he says he fights badly and is never in a battle slot).
  Nim    a Lower City fence: flat cap, patched brown coat, dull red scarf, no picks or
         blades ("I don't do locks anymore").
  Derry  a Broken Yoke road contact: weathered travelling cloak with the hood up, grey
         beard, muted ochre scarf, no weapon ("I was never here").

Overworld: 16x24, four directions, idle + 4 walk frames -> game/sprites/npcs/<stem>/
Portraits: 48x48, three expressions                      -> game/sprites/portraits/<stem>/

Run from game/sprites/:  python3 src/story_npcs.py
"""
import os
import sys

from PIL import Image

HERE = os.path.dirname(__file__)
sys.path.insert(0, HERE)
from party_kit import save_overworld, save_portraits
from pix import preview, BG

SPR = os.path.abspath(os.path.join(HERE, '..'))

ALDEN = dict(
    skin=(226, 178, 138), skin2=(192, 134, 98),
    hair=(88, 50, 34), hair2=(62, 34, 24),
    coat=(46, 70, 92), coat2=(34, 52, 70),
    trim=(178, 144, 82),
    pants=(62, 58, 54), boot=(38, 34, 30),
    metal=(190, 194, 200), metal2=(226, 230, 234),
    wood=(104, 78, 50), leather=(104, 78, 50),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(22, 22, 28),
    satchel=True, part=True,
)

NIM = dict(
    skin=(156, 106, 78), skin2=(118, 72, 52),
    hair=(58, 54, 52), hair2=(38, 36, 34),
    coat=(92, 76, 56), coat2=(68, 56, 42),
    trim=(136, 104, 48),
    pants=(56, 50, 44), boot=(34, 30, 26),
    metal=(176, 168, 144), metal2=(210, 202, 178),
    wood=(110, 84, 54), leather=(86, 64, 42),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(20, 18, 18),
    cap=(54, 50, 46), scarf=(116, 52, 44),
    stubble=True, earring=True,
)

DERRY = dict(
    skin=(206, 158, 116), skin2=(170, 120, 84),
    hair=(104, 92, 74), hair2=(78, 68, 54),
    coat=(58, 74, 56), coat2=(44, 58, 42),
    trim=(140, 120, 72),
    pants=(64, 56, 46), boot=(38, 32, 26),
    metal=(150, 150, 140), metal2=(190, 190, 178),
    wood=(112, 86, 54), leather=(88, 66, 44),
    crystal=(190, 210, 190), crystal2=(226, 240, 226),
    out=(20, 22, 18),
    hood=True, hood_color=(44, 58, 42),
    cloak=True, scarf=(150, 126, 76), beard=True,
)


def make_ow_preview(stem):
    od = os.path.join(SPR, 'npcs', stem)
    rows = []
    walks = []
    for d in ('down', 'up', 'right', 'left'):
        idle = Image.open(f'{od}/spr_{stem}_ow16_idle_{d}.png').convert('RGBA')
        walk = Image.open(f'{od}/spr_{stem}_ow16_walk_{d}_strip4.png').convert('RGBA')
        walks.append(walk)
        row = Image.new('RGBA', (idle.width + 16 + walk.width, 24), (0, 0, 0, 0))
        row.paste(idle, (0, 0))
        row.paste(walk, (idle.width + 16, 0))
        rows.append((f'spr_{stem}_ow16_idle_{d}.png  +  spr_{stem}_ow16_walk_{d}_strip4.png',
                     row, 16))
    preview(rows, f'{od}/spr_{stem}_ow16_preview.png',
            f'{stem.upper()} overworld 16x24 (idle | walk x4), origin (8,23)',
            scale=8, fw=16)
    make_walk_gif(walks, 16, 24, f'{od}/spr_{stem}_ow16_walk_preview.gif', scale=8)


def make_walk_gif(walks, fw, fh, path, scale=8):
    """Four walk strips side by side, animating together (preview only)."""
    frames = []
    n = max(w.width // fw for w in walks)
    for i in range(n):
        sheet = Image.new('RGBA', (fw * 4 + 3 * 4, fh), BG)
        for k, walk in enumerate(walks):
            cell = walk.crop(((i % (walk.width // fw)) * fw, 0,
                              (i % (walk.width // fw)) * fw + fw, fh))
            sheet.alpha_composite(cell, (k * (fw + 4), 0))
        frames.append(sheet.convert('RGB').resize((sheet.width * scale, fh * scale),
                                                  Image.NEAREST))
    frames[0].save(path, save_all=True, append_images=frames[1:], duration=150, loop=0,
                   disposal=2)


def make_portrait_preview(stem, expressions):
    od = os.path.join(SPR, 'portraits', stem)
    strip = Image.new('RGBA', (48 * len(expressions), 48), (0, 0, 0, 0))
    for i, expr in enumerate(expressions):
        im = Image.open(f'{od}/spr_portrait_{stem}_{expr}.png').convert('RGBA')
        strip.paste(im, (i * 48, 0))
    preview([(' | '.join(expressions), strip, 48)],
            f'{od}/spr_portrait_{stem}_portraits_preview.png',
            f'{stem.upper()} portraits 48x48, origin (0,0)', scale=3, fw=48)


def build(stem, P, expressions):
    print(f'{stem} overworld ->', save_overworld(P, stem, weapon='none'))
    print(f'{stem} portraits ->', save_portraits(P, stem, expressions))
    make_ow_preview(stem)
    make_portrait_preview(stem, expressions)


if __name__ == '__main__':
    build('alden', ALDEN, ('neutral', 'warm', 'resolved'))
    build('nim', NIM, ('neutral', 'wry', 'wary'))
    build('derry', DERRY, ('neutral', 'wary', 'grim'))
