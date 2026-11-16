#!/usr/bin/env python3
"""Generate Chapter 9's room: rm_town, its builder and its marker table.

Emits, into game/scripts/ (and the gamemaker mirrors):
  scr_build_town.gml        (the runtime tile builder)
  scr_ch9_markers_data.gml  (spawns, exits, Vell, Nessa, Alden, the levy board, encounters)
and, into gamemaker/rooms/:
  rm_town/rm_town.yy, rm_town/RoomCreationCode.gml

Layout is a functional blockout on the Wrenfield tileset: there is no Crown town tileset yet, and
docs/story/CHAPTER9_SCRIPT.md is the source. Room helpers are the ones tools/gen_act3_rooms.py
defines (Grid, emit_room, emit_markers, marker_room_yy), loaded from that file's helper section so
the two generators cannot drift. Run from the repo root:
    python3 tools/gen_ch9_rooms.py
"""
import json, os, random

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
SCR = os.path.join(ROOT, 'game', 'scripts')
GM = os.path.join(ROOT, 'gamemaker')
RM = os.path.join(GM, 'rooms')

# Load the shared room helpers without running the Act III generator's room body.
_src = open(os.path.join(ROOT, 'tools', 'gen_act3_rooms.py'), encoding='utf-8').read()
_helpers = _src[:_src.index('# ================================================================ rm_blackwood_shrine')]
_ns = {'__file__': os.path.join(ROOT, 'tools', 'gen_act3_rooms.py'), '__name__': 'gen_act3_helpers'}
exec(compile(_helpers, 'gen_act3_rooms.py', 'exec'), _ns)
T = _ns['T']; Grid = _ns['Grid']; emit_room = _ns['emit_room']
emit_markers = _ns['emit_markers']; marker_room_yy = _ns['marker_room_yy']; npc = _ns['npc']
GRASS = _ns['GRASS']; ROAD = _ns['ROAD']; DIRT = _ns['DIRT']; TREE = _ns['TREE']
CRATE = _ns['CRATE']; LAMP = _ns['LAMP']; STONE = _ns['STONE']
WALLTOP = _ns['WALLTOP']; WALLFACE = _ns['WALLFACE']

random.seed(20261121)

W, H = 34, 20
g, d, o, c = Grid(W, H), Grid(W, H), Grid(W, H), Grid(W, H)
for y in range(H):
    for x in range(W):
        g.set(x, y, random.choice(GRASS))

# The road in from the wood, and the road out to the south.
for y in range(H):
    for x in (16, 17):
        g.set(x, y, random.choice(ROAD))
# The market square's cross street.
for x in range(2, 32):
    for y in (10, 11):
        g.set(x, y, random.choice(ROAD))
# Paving around the crossing.
for x in range(13, 22):
    for y in range(8, 14):
        g.set(x, y, random.choice(STONE))


def building(x0, y0, x1, y1, door_x):
    """A Crown town facade: roof row, wall faces, one doorway left walkable."""
    for x in range(x0, x1 + 1):
        d.set(x, y0, random.choice(WALLTOP))
        c.set(x, y0, 1)
    for y in range(y0 + 1, y1 + 1):
        for x in range(x0, x1 + 1):
            if x == door_x and y == y1:
                d.set(x, y, DIRT[1])
                continue
            d.set(x, y, random.choice(WALLFACE))
            c.set(x, y, 1)


# The magistrate's house (west of the square) and the inn (east of it).
building(2, 2, 9, 6, 6)
building(23, 2, 31, 6, 27)
# The shop, on the west side, its door facing the street.
building(2, 14, 7, 18, 7)

# The levy board and the market stalls.
d.set(13, 7, 527)  # the board itself: drawn, but walkable so its inspectable can be touched
for (x, y) in [(12, 12), (22, 12)]:
    d.set(x, y, CRATE)
    c.set(x, y, 1)
# The square's well: stone, and in the way.
for (x, y) in [(16, 13), (17, 13)]:
    d.set(x, y, STONE[1])
    c.set(x, y, 1)
for (x, y) in [(15, 13), (18, 13)]:
    d.set(x, y, STONE[3])
# Lamps at the square's corners.
for (x, y) in [(13, 8), (21, 8), (13, 14), (21, 14)]:
    d.set(x, y, LAMP)

# The wood to the north, the fields to the south, and a hedge either side.
for x in range(W):
    if not (16 <= x <= 17):
        d.set(x, 0, TREE)
        c.set(x, 0, 1)
    if not (16 <= x <= 17):
        d.set(x, H - 1, TREE)
        c.set(x, H - 1, 1)
for y in range(H):
    for x in (0, W - 1):
        d.set(x, y, TREE)
        c.set(x, y, 1)

town_markers = [
    {'type': 'player_spawn', 'name': 'from_wood', 'tile_x': 16, 'tile_y': 1,
     'x': T(16, 1)[0], 'y': T(16, 1)[1], 'facing': 'down',
     'note': 'Arrive from the Blackwood doors, off the road south.'},
    {'type': 'player_spawn', 'name': 'from_barrow', 'tile_x': 16, 'tile_y': 18,
     'x': T(16, 18)[0], 'y': T(16, 18)[1], 'facing': 'up',
     'note': 'Arrive back from the barrow gate (Chapter 10).'},
    {'type': 'zone_exit', 'name': 'to_wood', 'tile_x': 16, 'tile_y': 0,
     'x': T(16, 0)[0], 'y': T(16, 0)[1], 'target_room': 'rm_blackwood_doors',
     'target_spawn': 'from_town', 'w': 2, 'h': 1,
     'note': 'Back north to the doors clearing.'},
    {'type': 'zone_exit', 'name': 'to_barrow', 'tile_x': 16, 'tile_y': 19,
     'x': T(16, 19)[0], 'y': T(16, 19)[1], 'target_room': 'rm_barrow_gate',
     'target_spawn': 'from_town', 'w': 2, 'h': 1, 'script_id': 'CH9_ROAD', 'lines':
     ['The track south is mud with a direction. The survey says keep going.'],
     'note': 'Chapter 10 is not built: scr_ch9_exit_script gates this and plays CH9_END once.'},
    {'type': 'lore', 'name': 'levy_board', 'tile_x': 13, 'tile_y': 7,
     'x': T(13, 7)[0], 'y': T(13, 7)[1], 'script_id': 'TN_BOARD',
     'lines': ['A levy board with this quarter\'s grain price on it, and a line for survey.'],
     'note': 'TN_BOARD: the survey line. Optional, sets ch9_board_read.'},
    {'type': 'lore', 'name': 'the_square', 'tile_x': 19, 'tile_y': 9,
     'x': T(19, 9)[0], 'y': T(19, 9)[1],
     'lines': ['The square is swept and the well is in the way. Two children are playing at swords.',
               'Nobody here has heard of the Blackwood, and the ones who have do not believe it.'],
     'note': 'Look text.'},
    npc('vell', 6, 7, 'vell', 'Vell', 'VG_MEET', 'spr_story_npc_placeholder', 'down',
        {'note': 'Magistrate Vell at the ledger house door: the ledger scene and the yielding boss.'}),
    npc('nessa', 8, 7, 'nessa', 'Nessa', 'CL_CHOICE', 'spr_story_npc_placeholder', 'down',
        {'note': 'Vell\'s clerk. The side quest and its one choice. Placeholder sprite.'}),
    npc('alden', 27, 7, 'alden', 'Alden', 'AL_MEET', 'spr_story_npc_placeholder', 'down',
        {'note': 'Alden Marr at the inn. No sprite exists for him; this is a placeholder.'}),
    {'type': 'encounter_zone', 'name': 'town_outskirts', 'tile_x': 10, 'tile_y': 15,
     'x': T(10, 15)[0], 'y': T(10, 15)[1], 'table_id': 'crown_barrow',
     'fallback_table_id': 'crown_barrow', 'levels': '21-23',
     'rect_px': [10 * 16, 15 * 16, 24 * 16, 19 * 16],
     'enemy_table': [
         {'group': ['crown_guard_elite', 'barrow_husk'], 'weight': 2},
         {'group': ['oath_iron', 'barrow_husk'], 'weight': 2},
         {'group': ['grave_moth', 'grave_moth', 'crown_guard_elite'], 'weight': 1}
     ],
     'enemies': 'Crown Guard Elites, Barrow Husks, Oath Iron, Grave Moths',
     'note': 'The road south of the square only. The square itself is safe.'},
]

files = {
    'scr_build_town.gml': emit_room('scr_build_town', W, H, g, d, o, c,
        'Coleford: the square, the magistrate\'s house, the inn and the road out. Chapter 9.'),
    'scr_ch9_markers_data.gml': emit_markers('scr_town_markers', W, H, town_markers,
        'Coleford markers (Chapter 9).'),
}

write_list = []
for fn, body_text in files.items():
    text = '/// Generated by tools/gen_ch9_rooms.py — do not hand-edit.\n\n' + body_text
    with open(os.path.join(SCR, fn), 'w', encoding='utf-8', newline='\n') as f:
        f.write(text)
    write_list.append(fn)
    print('wrote', fn)

rooms = [('rm_town', W, H, 16, 1, 'Coleford, a Crown market town (Chapter 9)')]
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
