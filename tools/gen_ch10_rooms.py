#!/usr/bin/env python3
"""Generate Chapter 10's room: rm_barrow_gate, its builder and its marker table.

Emits, into game/scripts/ (and the gamemaker mirrors):
  scr_build_barrow_gate.gml, scr_ch10_markers_data.gml
and, into gamemaker/rooms/:
  rm_barrow_gate/rm_barrow_gate.yy, rm_barrow_gate/RoomCreationCode.gml

A functional blockout on the Wrenfield tileset: there is no barrow/hillside tileset yet.
docs/story/CHAPTER10_SCRIPT.md is the source. Room helpers come from tools/gen_act3_rooms.py's
helper section so the generators cannot drift. Run from the repo root:
    python3 tools/gen_ch10_rooms.py
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
GRASS = _ns['GRASS']; ROAD = _ns['ROAD']; DIRT = _ns['DIRT']; TREE = _ns['TREE']
PILLAR = _ns['PILLAR']; STONE = _ns['STONE']
WALLTOP = _ns['WALLTOP']; WALLFACE = _ns['WALLFACE']

random.seed(20261124)

W, H = 28, 20
g, d, o, c = Grid(W, H), Grid(W, H), Grid(W, H), Grid(W, H)
for y in range(H):
    for x in range(W):
        g.set(x, y, random.choice(GRASS))

# The maintained road, running south out of the gatehouse.
for y in range(4, H):
    for x in (13, 14):
        g.set(x, y, random.choice(ROAD))
# The forecourt in front of the arch.
for x in range(9, 19):
    for y in range(6, 12):
        g.set(x, y, random.choice(DIRT))

# The hillside the gatehouse is cut into.
for x in range(W):
    for y in range(0, 3):
        d.set(x, y, random.choice(STONE))
        c.set(x, y, 1)
# The arch: cut steps through the hill, and the road beyond the gate.
for y in range(0, 6):
    for x in (13, 14):
        d.set(x, y, random.choice(STONE[1:]))
# The two towers, and the lintel between them.
for (x0, x1) in ((9, 12), (15, 18)):
    for x in range(x0, x1 + 1):
        d.set(x, 3, random.choice(WALLTOP))
        c.set(x, 3, 1)
    for y in range(4, 9):
        for x in range(x0, x1 + 1):
            d.set(x, y, random.choice(WALLFACE))
            c.set(x, y, 1)
for x in range(13, 15):
    d.set(x, 3, STONE[5])
# The gate itself, and the plate above it with the crown-and-sun.
d.set(13, 5, STONE[1])
d.set(14, 5, STONE[1])
d.set(13, 4, STONE[3])
d.set(14, 4, STONE[3])
# Rubble at the roadside, and the overwritten survey post.
for (x, y) in ((7, 10), (20, 11), (8, 16), (19, 16)):
    d.set(x, y, PILLAR)
    c.set(x, y, 1)
d.set(9, 13, PILLAR)  # drawn, walkable so its inspectable can be touched

markers = [
    {'type': 'player_spawn', 'name': 'from_town', 'tile_x': 13, 'tile_y': 18,
     'x': T(13, 18)[0], 'y': T(13, 18)[1], 'facing': 'up',
     'note': 'Arrive from Coleford.'},
    {'type': 'player_spawn', 'name': 'from_halls', 'tile_x': 13, 'tile_y': 3,
     'x': T(13, 3)[0], 'y': T(13, 3)[1], 'facing': 'down',
     'note': 'Arrive back up the steps from the barrow halls (Chapter 11).'},
    {'type': 'zone_exit', 'name': 'to_town', 'tile_x': 13, 'tile_y': 19,
     'x': T(13, 19)[0], 'y': T(13, 19)[1], 'target_room': 'rm_town',
     'target_spawn': 'from_barrow', 'w': 2, 'h': 1,
     'note': 'Back north to Coleford.'},
    {'type': 'zone_exit', 'name': 'to_halls', 'tile_x': 13, 'tile_y': 2,
     'x': T(13, 2)[0], 'y': T(13, 2)[1], 'target_room': 'rm_barrow_halls',
     'target_spawn': 'from_gate', 'w': 2, 'h': 1, 'script_id': 'CH10_EXIT',
     'lines': ['The steps go down into the hill. The Warden is still between the party and them.'],
     'note': 'Chapter 11 is not built: scr_ch10_exit_script gates this and plays CH10_END once.'},
    {'type': 'npc', 'name': 'barrow_smith', 'tile_x': 17, 'tile_y': 10,
     'x': T(17, 10)[0], 'y': T(17, 10)[1], 'npc_id': 'villager', 'speaker': 'Orrin',
     'script_id': 'BG_SMITH_01', 'sprite': 'spr_traveler_ow16_idle_left', 'hostile': False,
     'facing': 'left',
     'note': 'Orrin, the Barrow Gate smith: the Act IV (story) tier merchant. Sells the late shelf; the Chapter 4 row is legacy.'},
    {'type': 'lore', 'name': 'survey_post', 'tile_x': 9, 'tile_y': 13,
     'x': T(9, 13)[0], 'y': T(9, 13)[1], 'script_id': 'SP_POST',
     'lines': ['A squat stone post, cut with the Crown\'s survey mark. The year has worn to a shape.'],
     'note': 'SP_POST: the overwritten mark. Optional, sets ch10_post_seen.'},
    {'type': 'lore', 'name': 'the_gate', 'tile_x': 13, 'tile_y': 6,
     'x': T(13, 6)[0], 'y': T(13, 6)[1],
     'lines': ['An iron gate across the road. Bolted, not locked, and the hinges are clean.',
               'Above the arch, cut shallow: a crown ringing a black sun.'],
     'note': 'Look text. The gate scene itself is scr_ch10_tick at the forecourt.'},
    {'type': 'encounter_zone', 'name': 'barrow_road', 'tile_x': 8, 'tile_y': 12,
     'x': T(8, 12)[0], 'y': T(8, 12)[1], 'table_id': 'crown_barrow',
     'fallback_table_id': 'crown_barrow', 'levels': '21-23',
     'rect_px': [8 * 16, 12 * 16, 20 * 16, 19 * 16],
     'enemy_table': [
         {'group': ['oath_iron', 'barrow_husk'], 'weight': 3},
         {'group': ['barrow_husk', 'barrow_husk', 'grave_moth'], 'weight': 2},
         {'group': ['crown_guard_elite', 'oath_iron'], 'weight': 1}
     ],
     'enemies': 'Oath Iron, Barrow Husks, Grave Moths, Crown Guard Elites',
     'note': 'The road approach only. The forecourt and the arch are safe.'},
]

files = {
    'scr_build_barrow_gate.gml': emit_room('scr_build_barrow_gate', W, H, g, d, o, c,
        'The barrow gatehouse: the maintained road, the towers, the iron gate and the hillside. Chapter 10.'),
    'scr_ch10_markers_data.gml': emit_markers('scr_barrow_gate_markers', W, H, markers,
        'Barrow gate markers (Chapter 10).'),
}

write_list = []
for fn, body_text in files.items():
    text = '/// Generated by tools/gen_ch10_rooms.py — do not hand-edit.\n\n' + body_text
    with open(os.path.join(SCR, fn), 'w', encoding='utf-8', newline='\n') as f:
        f.write(text)
    write_list.append(fn)
    print('wrote', fn)

rooms = [('rm_barrow_gate', W, H, 13, 18, 'The barrow gatehouse (Chapter 10)')]
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
            "$GMScript": "v1", "%Name": fn[:-4], "isCompatibility": False, "isDnd": False,
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
