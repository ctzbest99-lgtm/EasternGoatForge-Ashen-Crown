"""Render the Adventure menu's Bestiary screen without GameMaker.

    python3 tools/render_bestiary_mock.py [out.png]

The layout numbers are copied from obj_adventure_menu/Draw_GUI.gml and scr_menu_layout.gml
(320x180 GUI, detail pane at x=154, monster plate at x=248..308, y=112..176). Text is drawn
with the real bitmap font (spr_font_main_strip95) and the monster with the real first idle
frame, so this is a faithful check for overlap and clipping. It is a mock, not a screenshot:
it does not run GML, and nine-slice window art is approximated with a plain frame.
"""
import os
import sys

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FONT = os.path.join(ROOT, 'game', 'sprites', 'ui', 'spr_font_main_strip95.png')
FONT_MAP = (' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`'
            'abcdefghijklmnopqrstuvwxyz{|}~')

W, H = 320, 180
COL_W = (240, 235, 223)
COL_Y = (217, 184, 96)
COL_G = (154, 146, 132)
COL_A = (125, 117, 112)
COL_DESC = (216, 208, 192)
ROW_BG = (34, 38, 58)

FULL_X, FULL_Y, FULL_W, FULL_H = 4, 4, 312, 172
LIST_W = 142
ROWS = 8
ROW_H = 15
DX = LIST_W + 12          # 154
IX, IY, IW, IH = FULL_X + FULL_W - 60, 112, 60, 64


class Canvas:
    def __init__(self):
        self.img = Image.new('RGBA', (W, H), (12, 13, 20, 255))
        self.font = Image.open(FONT).convert('RGBA')
        self.gw = self.font.width // len(FONT_MAP)

    def glyph(self, ch):
        i = FONT_MAP.find(ch)
        if i < 0:
            i = FONT_MAP.find('?')
        return self.font.crop((i * self.gw, 0, (i + 1) * self.gw, self.font.height))

    def text(self, x, y, s, col, right=False):
        if right:
            x -= len(s) * self.gw
        for k, ch in enumerate(s):
            g = self.glyph(ch)
            alpha = g.split()[3].point(lambda a: a * col[3] // 255) if len(col) > 3 else g.split()[3]
            solid = Image.new('RGBA', g.size, col[:3] + (255,))
            solid.putalpha(alpha)
            self.img.alpha_composite(solid, (int(x + k * self.gw), int(y)))

    def wrap(self, x, y, s, width, sep=11):
        max_chars = max(1, int(width // self.gw))
        lines, cur = [], ''
        for word in s.split(' '):
            cand = (cur + ' ' + word).strip()
            if len(cand) <= max_chars:
                cur = cand
            else:
                if cur:
                    lines.append(cur)
                cur = word
        if cur:
            lines.append(cur)
        for i, line in enumerate(lines):
            self.text(x, y + i * sep, line, COL_DESC)
        return y + len(lines) * sep

    def rect(self, x, y, w, h, fill=None, outline=None):
        d = ImageDraw.Draw(self.img)
        if fill:
            d.rectangle([x, y, x + w - 1, y + h - 1], fill=fill)
        if outline:
            d.rectangle([x, y, x + w - 1, y + h - 1], outline=outline)

    def sprite(self, path, box, scale_cap=1.0, silhouette=False):
        spr = Image.open(path).convert('RGBA')
        n = 1
        base = os.path.basename(path)
        if 'strip' in base:
            n = int(base.rsplit('strip', 1)[1].split('.')[0])
        fw = spr.width // n
        frame = spr.crop((0, 0, fw, spr.height))
        bw, bh = box[2], box[3]
        s = min(bw / fw, bh / spr.height, scale_cap)
        frame = frame.resize((max(1, int(fw * s)), max(1, int(spr.height * s))), Image.NEAREST)
        if silhouette:
            solid = Image.new('RGBA', frame.size, (0, 0, 0, 255))
            frame = Image.composite(solid, Image.new('RGBA', frame.size, (0, 0, 0, 0)), frame.split()[3])
        px = box[0] + (bw - frame.width) // 2
        py = box[1] + (bh - frame.height) // 2
        self.img.alpha_composite(frame, (int(px), int(py)))


def entry(c, e, idx, scroll, *, seen=True):
    c.rect(FULL_X, FULL_Y, FULL_W, FULL_H, fill=(16, 20, 40), outline=COL_Y)
    c.text(FULL_X + 8, 10, 'BESTIARY', COL_Y)
    c.text(FULL_X + FULL_W - 8, 10, f'{e["seen_total"]} / 33 seen', COL_G, right=True)

    for i in range(ROWS):
        row = i + scroll
        if row >= len(e['list']):
            break
        by = 30 + i * ROW_H
        name = e['list'][row]
        sel = row == idx
        if sel:
            c.rect(8, by, LIST_W - 4, 13, fill=ROW_BG, outline=COL_Y)
            c.text(9, by + 4, '>', COL_Y)
        c.text(20, by + 2, name if seen else '???', COL_Y if sel else (COL_W if seen else COL_A))
    c.text(LIST_W - 6, 18, '^', COL_G)
    c.text(LIST_W - 6, 158, 'v', COL_G)

    if not seen:
        c.text(DX, 26, 'No record yet.', COL_A)
        c.wrap(DX, 42, 'Meet this enemy in battle and its entry fills in.', 84)
        plate(c, e['sprite'], silhouette=True)
        return

    c.text(DX, 26, e['name'], COL_Y)
    c.text(DX, 40, f'Lv {e["level"]}   {e["role"]}', COL_G)
    d = e['desc']
    if len(d) > 66:
        cut = d.rfind(' ', 0, 67) or 66
        d = d[:cut] + '...'
    c.wrap(DX, 52, d, 148)
    c.text(DX, 88, 'Weak', COL_G)
    c.text(IX - 4, 88, e['weak'], COL_W, right=True)
    c.text(DX, 100, 'Found', COL_G)
    c.text(IX - 4, 110, e['area'], COL_W, right=True)
    rows = [('HP', e['hp'], 'MDF', e['mdf']), ('ATK', e['atk'], 'SPD', e['spd']),
            ('DEF', e['dfn'], 'Gold', e['gold'])]
    for r, (l1, v1, l2, v2) in enumerate(rows):
        y = 124 + 16 * r
        c.text(DX, y, l1, COL_G)
        c.text(DX + 38, y, str(v1), COL_W, right=True)
        c.text(DX + 46, y, l2, COL_G)
        c.text(IX - 4, y, str(v2), COL_W, right=True)
    plate(c, e['sprite'], silhouette=False)


def plate(c, sprite, silhouette):
    c.rect(IX, IY, IW, IH, fill=(10, 12, 18) if silhouette else (26, 30, 40), outline=COL_A)
    c.sprite(sprite, (IX, IY, IW, IH), silhouette=silhouette)


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else 'artifacts_bestiary.png'
    c = Canvas()
    entries = [
        dict(name='Blackwood Matriarch', list=['Blackwood Matriarch'] * 8, seen_total=12, level=14,
             role='Greater beast', desc='The eldest thing in the Blackwood. It remembers the road '
             'before the ash and does not forgive the crossing.',
             weak='Fire', area='Greyhaven / ashfall', hp=1450, atk=88, dfn=54, mdf=41, spd=22, gold=260,
             sprite=os.path.join(ROOT, 'game/sprites/enemies/blackwood_matriarch/'
                                 'spr_blackwood_matriarch_idle_strip8.png')),
        dict(name='Bandit', list=['Bandit'] * 8, seen_total=12, level=2, role='Road thief',
             desc='A desperate man with a cheap blade. Works the roads outside Greyhaven.',
             weak='Cold', area='Old Watchtower', hp=34, atk=11, dfn=6, mdf=4, spd=8, gold=9,
             sprite=os.path.join(ROOT, 'game/sprites/bandit/spr_bandit_idle_strip4.png')),
        dict(name='Ash Wolf', list=['Ash Wolf'] * 8, seen_total=12, level=3, role='Pack hunter',
             desc='A lean wolf greyed by ash. Hunts in packs along the ash fields.',
             weak='Fire', area='Blackwood', hp=52, atk=14, dfn=7, mdf=5, spd=13, gold=12,
             sprite=os.path.join(ROOT, 'game/sprites/enemies/ash_wolf/spr_ash_wolf_idle_strip4.png')),
    ]
    panels = []
    for i, e in enumerate(entries):
        c = Canvas()
        entry(c, e, 0, 0, seen=(i != 2))
        panels.append(c.img)
    sheet = Image.new('RGBA', (W * 3 + 16, H), (8, 8, 12, 255))
    for i, p in enumerate(panels):
        sheet.alpha_composite(p, (i * (W + 8), 0))
    sheet = sheet.resize((sheet.width * 2, sheet.height * 2), Image.NEAREST)
    sheet.convert('RGB').save(out)
    print('wrote', out, sheet.size)


if __name__ == '__main__':
    main()
