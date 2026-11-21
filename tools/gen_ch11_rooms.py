#!/usr/bin/env python3
"""Generate Chapter 11's rooms: rm_barrow_halls (30x20) and rm_barrow_deep (26x20).

Emits, into game/scripts/ (and the gamemaker mirrors):
  scr_build_barrow_halls.gml, scr_build_barrow_deep.gml, scr_ch11_markers_data.gml
and, into gamemaker/rooms/:
  rm_barrow_halls/, rm_barrow_deep/

Functional blockouts on the Wrenfield tileset: there is no tomb tileset yet.
docs/story/CHAPTER11_SCRIPT.md is the source. Room helpers come from tools/gen_act3_rooms.py's
helper section so the generators cannot drift. Run from the repo root:
    python3 tools/gen_ch11_rooms.py
"""
import json, os, random

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
SCR = os.path.join(ROOT, 'game', 'scripts')
GM = os.path.join(ROOT, 'gamemaker')
RM = os.path.join(GM, 'rooms')

_src = open(os.path.join(ROOT, 'tools', 'gen_act3_rooms.py'), encoding='utf-8').read()
_helpers = _src[:_src.index('# ================================================================ rm_blackwood_shrine')]
_ns = {'__file__': os.path.join(ROOT, 'tools', 'gen_act3_rooms.py'), '__name__': 'gen_act3_helpers'}
exec(compile(_helpers, 'gen_act3_rooms.py', 'exec'), _ns)
T = _ns['T']; Grid = _ns['Grid']; emit_room = _ns['emit_room']
emit_markers = _ns['emit_markers']; marker_room_yy = _ns['marker_room_yy']
# ts_barrow material band (ids 800-895): cold flagstone floors, rubble, wall courses
# and a carved pillar. Same room shapes as the Wrenfield blockout.
ROAD = [820, 821, 822, 823]
PILLAR = 880
STONE = [816, 817, 818, 819, 820, 821]
WALLTOP = [848, 849]
WALLFACE = [864, 865, 866, 867]

random.seed(20261126)


def stone_room(w, h):
    g, d, o, c = Grid(w, h), Grid(w, h), Grid(w, h), Grid(w, h)
    for y in range(h):
        for x in range(w):
            g.set(x, y, random.choice(STONE))
    return g, d, o, c


def shell(w, h, d, c):
    """Cut-stone walls all round, with the processional centre left open."""
    for x in range(w):
        for y in range(h):
            if x in (0, 1, w - 2, w - 1) or y in (0, 1, h - 2, h - 1):
                if y <= 1:
                    d.set(x, y, random.choice(WALLTOP))
                else:
                    d.set(x, y, random.choice(WALLFACE))
                c.set(x, y, 1)


# ================================================================ rm_barrow_halls (30x20)
W, H = 30, 20
g, d, o, c = stone_room(W, H)
shell(W, H, d, c)
# The processional way, and the steps up to the deep chamber.
for y in range(2, H - 2):
    for x in (13, 14):
        g.set(x, y, random.choice(ROAD))
for y in (2, 3):
    for x in (13, 14):
        d.set(x, y, random.choice(STONE[1:]))
# Pillar rows: a hall built for crowds, not for one party.
for x in (6, 10, 18, 22):
    for y in (6, 10, 14):
        d.set(x, y, PILLAR)
        c.set(x, y, 1)
# Niches for the struck names, on both side walls.
for (x, y) in ((2, 8), (2, 12), (W - 3, 8), (W - 3, 12)):
    d.set(x, y, STONE[5])

halls_markers = [
    {'type': 'player_spawn', 'name': 'from_gate', 'tile_x': 14, 'tile_y': 17,
     'x': T(14, 17)[0], 'y': T(14, 17)[1], 'facing': 'up',
     'note': 'Arrive down the steps from the gatehouse.'},
    {'type': 'player_spawn', 'name': 'from_deep', 'tile_x': 14, 'tile_y': 4,
     'x': T(14, 4)[0], 'y': T(14, 4)[1], 'facing': 'down',
     'note': 'Arrive back up from the last chamber.'},
    {'type': 'zone_exit', 'name': 'to_gate', 'tile_x': 14, 'tile_y': 18,
     'x': T(14, 18)[0], 'y': T(14, 18)[1], 'target_room': 'rm_barrow_gate',
     'target_spawn': 'from_halls', 'w': 2, 'h': 1,
     'note': 'Back up the steps to the gatehouse.'},
    {'type': 'zone_exit', 'name': 'to_deep', 'tile_x': 13, 'tile_y': 1,
     'x': T(13, 1)[0], 'y': T(13, 1)[1], 'target_room': 'rm_barrow_deep',
     'target_spawn': 'from_halls', 'w': 2, 'h': 1,
     'note': 'The last chamber. No gate: the hall is the warning.'},
    {'type': 'lore', 'name': 'struck_names', 'tile_x': 2, 'tile_y': 8,
     'x': T(2, 8)[0], 'y': T(2, 8)[1], 'script_id': 'BH_NAMES',
     'lines': ['A name cut into the niche, struck through with a chisel. The title above it was left.'],
     'note': 'BH_NAMES: the erasure. Optional, sets ch11_names_seen.'},
    {'type': 'lore', 'name': 'grave_goods', 'tile_x': W - 3, 'tile_y': 8,
     'x': T(W - 3, 8)[0], 'y': T(W - 3, 8)[1], 'script_id': 'BH_NICHE',
     'lines': ['A cup, a knife, and a shoe sized for a child. The offerings were never taken.'],
     'note': 'BH_NICHE: the offerings. Optional, sets ch11_niche_seen.'},
    {'type': 'encounter_zone', 'name': 'barrow_halls', 'tile_x': 4, 'tile_y': 5,
     'x': T(4, 5)[0], 'y': T(4, 5)[1], 'table_id': 'crown_barrow',
     'fallback_table_id': 'crown_barrow', 'levels': '21-23',
     'rect_px': [3 * 16, 4 * 16, 27 * 16, 18 * 16],
     'enemy_table': [
         {'group': ['barrow_husk', 'barrow_husk', 'oath_iron'], 'weight': 3},
         {'group': ['oath_iron', 'grave_moth'], 'weight': 2},
         {'group': ['barrow_husk', 'grave_moth', 'grave_moth'], 'weight': 2}
     ],
     'enemies': 'Barrow Husks, Oath Iron, Grave Moths',
     'note': 'The halls only. The deep chamber has no random encounters.'},
]

# ================================================================ rm_barrow_deep (26x20)
W2, H2 = 26, 20
g2, d2, o2, c2 = stone_room(W2, H2)
shell(W2, H2, d2, c2)
# The chamber: one dais, one lectern, one stand.
for (x, y) in ((12, 5), (13, 5), (14, 5), (12, 4), (13, 4), (14, 4)):
    g2.set(x, y, random.choice(STONE[1:]))
for x in (12, 13, 14):
    d2.set(x, 3, STONE[3])
    c2.set(x, 3, 1)
# The processional way in from the halls.
for y in range(8, H2 - 2):
    for x in (12, 13):
        g2.set(x, y, random.choice(ROAD))
d2.set(10, 7, STONE[5])   # the lectern, drawn, walkable so its inspectable can be touched
d2.set(16, 7, STONE[5])   # the stand for the seal
for x in (5, 8, 17, 20):
    d2.set(x, 12, PILLAR)
    c2.set(x, 12, 1)

deep_markers = [
    {'type': 'player_spawn', 'name': 'from_halls', 'tile_x': 13, 'tile_y': 17,
     'x': T(13, 17)[0], 'y': T(13, 17)[1], 'facing': 'up',
     'note': 'Arrive from the halls.'},
    {'type': 'zone_exit', 'name': 'to_halls', 'tile_x': 13, 'tile_y': 18,
     'x': T(13, 18)[0], 'y': T(13, 18)[1], 'target_room': 'rm_barrow_halls',
     'target_spawn': 'from_deep', 'w': 2, 'h': 1,
     'note': 'Back to the halls. The act card plays at the seal, not here.'},
    {'type': 'lore', 'name': 'the_charter', 'tile_x': 10, 'tile_y': 7,
     'x': T(10, 7)[0], 'y': T(10, 7)[1], 'script_id': 'BK_CHARTER',
     'lines': ['One page under a sheet clearer than glass. The Crown\'s oldest hand, and a seal that is not the Crown\'s.'],
     'note': 'BK_CHARTER: required. Reading the name wakes the King.'},
    {'type': 'lore', 'name': 'the_seal', 'tile_x': 16, 'tile_y': 7,
     'x': T(16, 7)[0], 'y': T(16, 7)[1],
     'lines': ['A seal on a stand: a crown ringing a black sun, small enough for a hand.',
               'Nobody has touched it in a hundred years.'],
     'note': 'Look text only. The seal itself is the §6 choice, after the fight.'},
    {'type': 'extra', 'name': 'kept_king', 'tile_x': 13, 'tile_y': 4,
     'sprite': 'spr_story_npc_placeholder', 'x': T(13, 4)[0], 'y': T(13, 4)[1],
     'note': 'The Forgotten King on the dais. Placeholder sprite until his strips exist.'},
]

files = {
    'scr_build_barrow_halls.gml': emit_room('scr_build_barrow_halls', W, H, g, d, o, c,
        'The barrow halls: pillars, niches, the struck names and the way down. Chapter 11.',
        barrow=True),
    'scr_build_barrow_deep.gml': emit_room('scr_build_barrow_deep', W2, H2, g2, d2, o2, c2,
        'The last chamber: dais, lectern, seal stand and the Forgotten King. Chapter 11.',
        barrow=True),
    'scr_ch11_markers_data.gml': (
        emit_markers('scr_barrow_halls_markers', W, H, halls_markers, 'Barrow halls markers (Chapter 11).')
        + '\n' + emit_markers('scr_barrow_deep_markers', W2, H2, deep_markers, 'Last chamber markers (Chapter 11).')),
}

write_list = []
for fn, body_text in files.items():
    text = '/// Generated by tools/gen_ch11_rooms.py — do not hand-edit.\n\n' + body_text
    with open(os.path.join(SCR, fn), 'w', encoding='utf-8', newline='\n') as f:
        f.write(text)
    write_list.append(fn)
    print('wrote', fn)

rooms = [
    ('rm_barrow_halls', W, H, 14, 17, 'The barrow halls (Chapter 11)'),
    ('rm_barrow_deep', W2, H2, 13, 17, 'The last chamber (Chapter 11)'),
]
for name, w, h, sx, sy, note in rooms:
    folder = os.path.join(RM, name)
    os.makedirs(folder, exist_ok=True)
    with open(os.path.join(folder, name + '.yy'), 'w', encoding='utf-8', newline='\n') as f:
        json.dump(marker_room_yy(name, w, h, sx, sy), f, indent=2)
        f.write('\n')
    with open(os.path.join(folder, 'RoomCreationCode.gml'), 'w', encoding='utf-8', newline='\n') as f:
        f.write('scr_build_' + name.replace('rm_', '') + '();\n')
    print('wrote', name)


def mirror_script(fn):
    gdir = os.path.join(GM, 'scripts', fn[:-4])
    os.makedirs(gdir, exist_ok=True)
    with open(os.path.join(gdir, fn), 'w', encoding='utf-8', newline='\n') as f:
        f.write(open(os.path.join(SCR, fn), encoding='utf-8').read())
    with open(os.path.join(gdir, fn[:-4] + '.yy'), 'w', encoding='utf-8', newline='\n') as f:
        json.dump({
            "$GMScript": "v1", "%Name": fn[:-4], "isCompatibility": False, "isDnD": False,
            "name": fn[:-4], "parent": {"name": "scripts", "path": "folders/scripts.yy"},
            "resourceType": "GMScript", "resourceVersion": "2.0",
        }, f, indent=2)
        f.write('\n')


for fn in write_list:
    mirror_script(fn)

yyp_path = os.path.join(GM, 'AshenCrown.yyp')
yyp = open(yyp_path, encoding='utf-8').read()
anchor = ('    {\n      "id":{\n        "name":"rm_hollow_approach",\n'
          '        "path":"rooms/rm_hollow_approach/rm_hollow_approach.yy",\n      },\n    },\n')
room_anchor = ('    {\n      "id":{\n        "name":"rm_hollow_sanctuary",\n'
               '        "path":"rooms/rm_hollow_sanctuary/rm_hollow_sanctuary.yy",\n      },\n    },\n')
added = []
for fn in write_list:
    name = fn[:-4]
    if '"name":"%s"' % name in yyp:
        continue
    block = ('    {\n      "id":{\n        "name":"%s",\n        "path":"scripts/%s/%s.yy",\n      },\n    },\n'
             % (name, name, name))
    yyp = yyp.replace(anchor, block + anchor, 1)
    added.append(name)
for name, w, h, sx, sy, note in rooms:
    if '"name":"%s"' % name in yyp:
        continue
    block = ('    {\n      "id":{\n        "name":"%s",\n        "path":"rooms/%s/%s.yy",\n      },\n    },\n'
             % (name, name, name))
    yyp = yyp.replace(room_anchor, room_anchor + block, 1)
    added.append(name)
    start = yyp.index('"RoomOrderNodes":[')
    end = yyp.index('\n  ],', start)
    node = ('    {\n      "roomId":{\n        "name":"%s",\n        "path":"rooms/%s/%s.yy",\n      },\n    },\n'
            % (name, name, name))
    yyp = yyp[:end] + '\n' + node.rstrip('\n') + yyp[end:]
if added:
    with open(yyp_path, 'w', encoding='utf-8', newline='\n') as f:
        f.write(yyp)
print('registered in yyp:', added if added else 'nothing new')
print('done')
