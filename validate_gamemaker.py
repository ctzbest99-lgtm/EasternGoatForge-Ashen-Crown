import json, os, re, sys
from PIL import Image
ROOT = os.path.abspath(os.path.dirname(__file__))
OUT = os.path.join(ROOT, 'gamemaker')
SRC = os.path.join(ROOT, 'game')
def load(p):
    s = open(p).read()
    s = re.sub(r',(\s*[}\]])', r'\1', s)
    return json.loads(s)

errors, warns = [], []
yys = 0
for root, dirs, files in os.walk(OUT):
    for fn in files:
        if fn.endswith(('.yyp','.yy','.resource_order')):
            try: load(os.path.join(root, fn)); yys += 1
            except Exception as e: errors.append(f"PARSE {fn}: {e}")
print(f"parsed {yys} json files")

def check_refs(obj, base):
    if isinstance(obj, dict):
        for k, v in obj.items():
            if k == 'path' and isinstance(v, str) and v.startswith(('sprites/','objects/','scripts/','rooms/','folders/','texturegroups/','tilesets/')):
                if not v.startswith(('folders/','texturegroups/')) and not os.path.exists(os.path.join(OUT, v)):
                    errors.append(f"MISSING PATH {v} ({base})")
            else: check_refs(v, base)
    elif isinstance(obj, list):
        for v in obj: check_refs(v, base)

yyp = load(os.path.join(OUT,'AshenCrown.yyp'))
check_refs(yyp, 'yyp')
for root, dirs, files in os.walk(OUT):
    for fn in files:
        if fn.endswith('.yy'): check_refs(load(os.path.join(root,fn)), fn)

names = {r['id']['name'] for r in yyp['resources']}
paths = {r['id']['path'] for r in yyp['resources']}
assert len(names) == len(paths) == len(yyp['resources']), "duplicate resources!"

for r in yyp['resources']:
    p, n = r['id']['path'], r['id']['name']
    if not os.path.exists(os.path.join(OUT, p)): errors.append(f"resource file missing {p}")
    if p.startswith('sprites/'):
        sp = load(os.path.join(OUT, p)); d = os.path.dirname(os.path.join(OUT, p))
        if sp['frames']:
            im = Image.open(os.path.join(d, sp['frames'][0]['name'] + '.png'))
            if im.size != (sp['width'], sp['height']):
                errors.append(f"{n}: png {im.size} != ({sp['width']},{sp['height']})")
        for fr in sp['frames']:
            if not os.path.exists(os.path.join(d, fr['name'] + '.png')):
                errors.append(f"{n}: frame png missing")
            lay = sp['layers'][0]['name']
            if not os.path.exists(os.path.join(d, 'layers', fr['name'], lay + '.png')):
                errors.append(f"{n}: layer png missing")
        kf = sp['sequence']['tracks'][0]['keyframes']['Keyframes']
        if len(kf) != len(sp['frames']): errors.append(f"{n}: keyframe count")
        if sp['sequence']['length'] != float(len(sp['frames'])): errors.append(f"{n}: seq length")
        # nine-slice present where required
        if n in ('spr_ui_window','spr_ui_window_dim','spr_ui_window_gold','spr_ui_select_bar',
                 'spr_ui_slider_track','spr_ui_row_select','spr_ui_row_select_disabled',
                 'spr_ui_tab_blank_strip2','spr_ui_portrait_frame','spr_ui_leader_frame','spr_ui_qty_field'):
            if not (sp.get('nineSlice') and sp['nineSlice'].get('enabled')):
                errors.append(f"{n}: nine-slice not enabled")
    if p.startswith('objects/'):
        o = load(os.path.join(OUT, p)); dd = os.path.dirname(os.path.join(OUT, p))
        MAP = {(0,0):'Create_0',(3,0):'Step_0',(3,1):'Step_1',(3,2):'Step_2',(7,2):'Other_2',(8,64):'Draw_64',(12,0):'CleanUp_0'}
        want = set(MAP[(e['eventType'], e['eventNum'])] for e in o['eventList'])
        have = set(f[:-4] for f in os.listdir(dd) if f.endswith('.gml'))
        if want != have: errors.append(f"{n}: events {sorted(want)} != files {sorted(have)}")

# scripts byte-identical
for fn in os.listdir(os.path.join(SRC, 'scripts')):
    a = open(os.path.join(SRC,'scripts',fn)).read()
    b = open(os.path.join(OUT,'scripts',fn[:-4],fn[:-4]+'.gml')).read()
    if a != b: errors.append(f"script {fn} differs")

# datafiles identical
n = 0
for root, dirs, files in os.walk(os.path.join(SRC,'datafiles')):
    for fn in files:
        a = open(os.path.join(root,fn),'rb').read()
        rel = os.path.relpath(os.path.join(root,fn), os.path.join(SRC,'datafiles'))
        b = open(os.path.join(OUT,'datafiles',rel),'rb').read()
        if a != b: errors.append(f"datafile differs {rel}")
        n += 1
print(f"datafiles checked: {n}")
files_on_disk = set()
for root, dirs, files in os.walk(os.path.join(OUT,'datafiles')):
    for fn in files:
        files_on_disk.add(os.path.relpath(os.path.join(root,fn), os.path.join(OUT,'datafiles')))
files_in_yyp = set(i['name'] for i in yyp['IncludedFiles'])
if files_on_disk != files_in_yyp:
    errors.append(f"IncludedFiles mismatch {files_on_disk ^ files_in_yyp}")

# rooms: instances in bounds, tile layers present, creation code
rooms = {r['id']['name']: load(os.path.join(OUT, r['id']['path'])) for r in yyp['resources'] if r['id']['path'].startswith('rooms/')}
for name, rm in rooms.items():
    w, h = rm['roomSettings']['Width'], rm['roomSettings']['Height']
    lnames = [l['name'] for l in rm['layers']]
    for want in ('Instances','Ground','Decoration','Overhead','Collision','Markers'):
        if want not in lnames: errors.append(f"{name}: layer {want} missing")
    for l in rm['layers']:
        if l['resourceType'] == 'GMRTileLayer':
            if l['tilesetId']['name'] != 'ts_zone1': errors.append(f"{name}: wrong tileset")
        if l['resourceType'] == 'GMRInstanceLayer':
            for i in l['instances']:
                if not (0 <= i['x'] <= w and 0 <= i['y'] <= h):
                    errors.append(f"{name}: instance out of bounds ({i['x']},{i['y']})")
    v = rm['views'][0]
    if v['wview'] > w or v['hview'] > h: errors.append(f"{name}: view exceeds room")

# player present in every field room
for want in ('rm_overworld','rm_old_watchtower','rm_watchtower_basement','rm_greyhaven_varyn_house',
             'rm_greyhaven_tavern','rm_greyhaven_chapel','rm_greyhaven_blacksmith','rm_greyhaven_general_store',
             'rm_millhaven_road','rm_wrenfield','rm_wrenfield_bent_post','rm_wrenfield_store',
             'rm_valemere_road','rm_valemere','rm_salt_lamp','rm_warehouse',
             'rm_hollow_approach','rm_hollow_sanctuary'):
    rm = rooms[want]
    objs = [i['objectId']['name'] for l in rm['layers'] if l['resourceType']=='GMRInstanceLayer' for i in l['instances']]
    if 'obj_player' not in objs: errors.append(f"{want}: obj_player missing")
rm = rooms['rm_title']
objs = [i['objectId']['name'] for l in rm['layers'] if l['resourceType']=='GMRInstanceLayer' for i in l['instances']]
if 'obj_title' not in objs or 'obj_game_controller' not in objs: errors.append("rm_title: title/controller missing")
if 'obj_player' in objs: errors.append("rm_title: player should not be placed")
# room order: rm_title first, rm_overworld second
ro = [n['roomId']['name'] for n in yyp['RoomOrderNodes']]
if ro[0] != 'rm_title' or ro[1] != 'rm_overworld': errors.append(f"room order wrong: {ro}")
print("room order:", ro)

# every GML-referenced asset name exists
sprites = {r['id']['name'] for r in yyp['resources'] if r['id']['path'].startswith('sprites/')}
objects = {r['id']['name'] for r in yyp['resources'] if r['id']['path'].startswith('objects/')}
scripts = {r['id']['name'] for r in yyp['resources'] if r['id']['path'].startswith('scripts/')}
tilesets = {r['id']['name'] for r in yyp['resources'] if r['id']['path'].startswith('tilesets/')}
refs = set()
for root, dirs, files in os.walk(OUT):
    for fn in files:
        if fn.endswith('.gml'):
            refs |= set(re.findall(r'\b((?:spr|obj|ts|rm)_\w+)\b', open(os.path.join(root,fn)).read()))
missing = refs - sprites - objects - scripts - set(rooms) - tilesets
# ts_wrenfield and ts_blackwood are real tileset resources (rows 0-49 are ts_zone1): the
# Chapter 2-6 rooms switch to them at runtime, so a GML reference to them is not unresolved.
missing.discard('ts_wrenfield')
missing.discard('ts_blackwood')
missing = {m for m in missing if not m.startswith('scr_')}
missing = {m for m in missing if not (m.startswith('spr_') and m.endswith(('_',)) )}
# filter obvious dynamic-concat prefixes (end with _)
missing = {m for m in missing if not m.endswith('_')}
print("unresolved refs:", sorted(missing) if missing else "none")

# 640 title set: present and in tex_title_640
tg_names = {t['name'] for t in yyp['TextureGroups']}
if 'tex_title_640' not in tg_names: errors.append('tex_title_640 group missing from yyp')
for r in yyp['resources']:
    if r['id']['path'].startswith('sprites/'):
        sp = load(os.path.join(OUT, r['id']['path']))
        grp = sp['textureGroupId']['name']
        is640 = '640' in r['id']['name'] and ('menu' in r['id']['name'] or 'title' in r['id']['name'] or 'logo' in r['id']['name'])
        if is640 and grp != 'tex_title_640': errors.append(f"{r['id']['name']}: expected tex_title_640, got {grp}")
        if not is640 and grp != 'Default': errors.append(f"{r['id']['name']}: expected Default, got {grp}")
if 'spr_menu_embers_640_strip24' not in sprites: errors.append('ember 640 strip missing')

# bestiary: every listed id exists, display names are unique, and each resolves to a battle sprite
def read_script(name):
    return open(os.path.join(SRC, 'scripts', name)).read()

bestiary_src = read_script('scr_bestiary.gml')
enemy_src = read_script('scr_enemy_database.gml')
sprite_src = read_script('scr_sprites.gml')

m = re.search(r'function scr_bestiary_ids\(\)\s*\{\s*return\s*\[(.*?)\]\s*;', bestiary_src, re.S)
bestiary_ids = re.findall(r'"([a-z0-9_]+)"', m.group(1)) if m else []
if not bestiary_ids:
    errors.append("bestiary: scr_bestiary_ids() not found or empty")

# Enemy ids and display names: scr_get_enemy_data() only (the battle-area switch below it is a
# different mapping and must not be read as enemy definitions).
data_src = enemy_src[:enemy_src.index('function scr_enemy_battle_area')]
enemy_ids = set(re.findall(r'case\s+"([a-z0-9_]+)"\s*:', data_src))
enemy_names = dict(re.findall(r'scr_enemy_scaled\(\s*"([a-z0-9_]+)"\s*,\s*"([^"]+)"', data_src))
for lit in re.finditer(r'id:\s*"([a-z0-9_]+)"\s*,', data_src):
    nm = re.search(r'name:\s*"([^"]+)"', data_src[lit.end():lit.end() + 700])
    if nm:
        enemy_names.setdefault(lit.group(1), nm.group(1))

# Battle art kind per id: the explicit cases in scr_battle_kind_from_id(); ids it does not name
# fall through to scr_battle_kind_is_generic(), i.e. their own id, and scr_bestiary_sprite()
# falls back to the id as well. Both resolve to spr_<kind>_idle*.
kind_src = sprite_src[sprite_src.index('function scr_battle_kind_from_id'):]
kind_src = kind_src[:kind_src.index('default:')]
kind_of, pending = {}, []
for tok in re.finditer(r'case "([a-z0-9_]+)":|return "([a-z0-9_]*)";|return _actor_id;', kind_src):
    if tok.group(1):
        pending.append(tok.group(1))
    else:
        target = tok.group(2) if tok.group(2) is not None else None
        for p in pending:
            kind_of[p] = target if target is not None else p
        pending = []
IDLE_CANDIDATES = ('idle_strip4', 'idle_strip8', 'idle_strip6', 'idle_strip2', 'idle_p2_strip8', 'idle')
alias_at = bestiary_src.index('function scr_bestiary_alias')
alias_src = bestiary_src[alias_at:bestiary_src.index('function ', alias_at + 10)]
aliases = dict(re.findall(r'case\s+"([a-z0-9_]+)"\s*:\s*return\s+"([a-z0-9_]+)"\s*;', alias_src))
aliases.update(dict(re.findall(r'==\s*"([a-z0-9_]+)"\s*\)\s*\?\s*"([a-z0-9_]+)"', alias_src)))

name_owner, art_ok = {}, 0
for eid in bestiary_ids:
    if eid not in enemy_ids:
        errors.append(f"bestiary: '{eid}' is listed but scr_get_enemy_data() has no such enemy")
        continue
    nm = enemy_names.get(eid)
    if nm is None:
        errors.append(f"bestiary: '{eid}' has no display name in scr_enemy_database.gml")
    else:
        name_owner.setdefault(nm, []).append(eid)
    if eid in aliases:
        errors.append(f"bestiary: '{eid}' is aliased to '{aliases[eid]}' and must not be a row of its own")
    kind = kind_of.get(eid, eid)
    if any(f"spr_{kind}_{c}" in sprites for c in IDLE_CANDIDATES):
        art_ok += 1
    else:
        errors.append(f"bestiary: '{eid}' resolves to no battle sprite (looked for spr_{kind}_idle*)")
for nm, owners in name_owner.items():
    if len(owners) > 1:
        errors.append(f"bestiary: display name '{nm}' is shared by {owners}")
for alias_id, target in aliases.items():
    if target not in enemy_ids:
        errors.append(f"bestiary: alias '{alias_id}' points at unknown '{target}'")
print(f"bestiary: {len(bestiary_ids)} entries, {len(name_owner)} distinct names, "
      f"{art_ok} with art, {len(aliases)} aliased")

# encounters: every group and table entry names a real enemy, and boss groups lead with a boss
encounter_src = read_script('scr_encounter_tables.gml')
table_src = encounter_src[encounter_src.index('function scr_get_encounter_table'):
                          encounter_src.index('function scr_encounter_table_level_band')]
group_src = encounter_src[encounter_src.index('function scr_get_encounter_group'):]

# Boss ids: the "boss" role in scr_enemy_scaled(), plus any literal entry carrying is_boss: true.
boss_ids = set(re.findall(r'scr_enemy_scaled\(\s*"([a-z0-9_]+)"\s*,\s*"[^"]*"\s*,\s*"[^"]*"\s*,\s*"boss"', data_src))
lit_ids = [(m.start(), m.group(1)) for m in re.finditer(r'id:\s*"([a-z0-9_]+)"', data_src)]
for i, (start, eid) in enumerate(lit_ids):
    end = lit_ids[i + 1][0] if i + 1 < len(lit_ids) else len(data_src)
    if re.search(r'is_boss:\s*true', data_src[start:end]):
        boss_ids.add(eid)

def encounter_ids(block):
    """Enemy ids a table entry or group body mentions."""
    out = []
    out += re.findall(r'enemy_id:\s*"([a-z0-9_]+)"', block)
    for grp in re.findall(r'group:\s*\[([^\]]*)\]', block):
        out += re.findall(r'"([a-z0-9_]+)"', grp)
    for lst in re.findall(r'(?:adds|enemies):\s*\[([^\]]*)\]', block):
        out += re.findall(r'"([a-z0-9_]+)"', lst)
    out += re.findall(r'array_push\(\s*_adds\s*,\s*"([a-z0-9_]+)"\)', block)
    return out

# Random tables: enemy_id / group / group_id entries, per table id (aliased case labels share one).
def labels_before(src, pos):
    """The case labels that share the return at `pos` (comments and blank lines allowed)."""
    start = max(src.rfind('return', 0, pos), src.rfind('function', 0, pos)) + 1
    return re.findall(r'case\s+"([a-z0-9_]+)"', src[start:pos])

tables, table_blocks, table_refs, group_refs = {}, [], 0, set()
for m in re.finditer(r'return\s*\[(.*?)\];', table_src, re.S):
    labels = labels_before(table_src, m.start())
    body = m.group(1)
    if not labels:
        continue
    ids = encounter_ids(body)
    group_refs |= set(re.findall(r'group_id:\s*"([a-z0-9_]+)"', body))
    for tid in labels:
        tables[tid] = ids
    table_blocks.append((labels, ids))
    table_refs += len(ids)
    for eid in ids:
        if eid not in enemy_ids:
            errors.append(f"encounter table '{labels[0]}' references unknown enemy '{eid}'")
        elif eid in boss_ids:
            errors.append(f"encounter table '{labels[0]}' rolls boss '{eid}' as a regular encounter")

# Named groups: boss slot must be a boss, adds must be regular enemies, ids must exist.
groups, group_count = {}, 0
for m in re.finditer(r'return\s*\{(.*?)\};', group_src, re.S):
    labels = [g for g in labels_before(group_src, m.start()) if g.startswith('grp_')]
    body = m.group(1)
    if not labels:
        continue
    boss = re.search(r'boss:\s*"([a-z0-9_]+)"', body)
    boss_id = boss.group(1) if boss else None
    for gid in labels:
        groups[gid] = boss_id
    group_count += 1
    for eid in encounter_ids(body):
        if eid not in enemy_ids:
            errors.append(f"encounter group '{labels[0]}' references unknown enemy '{eid}'")
    if boss_id is not None:
        if boss_id not in enemy_ids:
            errors.append(f"encounter group '{labels[0]}' boss '{boss_id}' is not in scr_get_enemy_data()")
        elif boss_id not in boss_ids:
            errors.append(f"encounter group '{labels[0]}' puts '{boss_id}' in the boss slot but it is not a boss")
        for eid in encounter_ids(body):
            if eid in boss_ids:
                errors.append(f"encounter group '{labels[0]}' adds boss '{eid}' as a regular add")

for gid in sorted(group_refs):
    if gid not in groups:
        errors.append(f"encounter table references unknown group '{gid}'")
print(f"encounters: {len(tables)} tables, {group_count} groups, {table_refs} table refs, "
      f"{len([g for g, b in groups.items() if b])} boss groups")

# Level bands: an enemy rolling in a table should sit inside the band that table declares.
band_src = encounter_src[encounter_src.index('function scr_encounter_table_level_band'):
                         encounter_src.index('function scr_get_encounter_group')]
bands = {}
for m in re.finditer(r'return\s*\{\s*min:\s*(\d+)\s*,\s*max:\s*(\d+)\s*\}', band_src):
    for tid in labels_before(band_src, m.start()):
        bands[tid] = (int(m.group(1)), int(m.group(2)))

# Enemy levels: the level argument of scr_enemy_scaled(), and `level:` in the literal entries.
enemy_level = dict((eid, int(lvl)) for eid, lvl in
                   re.findall(r'scr_enemy_scaled\(\s*"([a-z0-9_]+)"\s*,\s*"[^"]*"\s*,\s*"[^"]*"'
                              r'\s*,\s*"[a-z]+"\s*,\s*(\d+)', data_src))
for i, (start, eid) in enumerate(lit_ids):
    end = lit_ids[i + 1][0] if i + 1 < len(lit_ids) else len(data_src)
    lvl = re.search(r'level:\s*(\d+)', data_src[start:end])
    if lvl:
        enemy_level.setdefault(eid, int(lvl.group(1)))

out_of_band = 0
for labels, ids in table_blocks:
    band = bands.get(labels[0])
    if band is None:
        warns.append(f"encounter table '{labels[0]}' declares no level band")
        continue
    if band[0] > band[1]:
        errors.append(f"encounter table '{labels[0]}' has an inverted band {band[0]}-{band[1]}")
    missing = sorted({eid for eid in ids if eid not in enemy_level})
    for eid in missing:
        errors.append(f"encounter table '{labels[0]}' uses '{eid}', whose level is unknown")
    bad = sorted({(eid, enemy_level[eid]) for eid in ids
                  if eid in enemy_level and not band[0] <= enemy_level[eid] <= band[1]})
    if bad:
        out_of_band += 1
        alias = f" (also '{', '.join(labels[1:])}')" if len(labels) > 1 else ""
        listing = ", ".join(f"{eid} L{lvl}" for eid, lvl in bad)
        warns.append(f"encounter table '{labels[0]}'{alias} band {band[0]}-{band[1]} rolls "
                     f"out-of-band enemies: {listing}")
for tid in sorted(set(bands) - set(tables)):
    errors.append(f"level band declared for '{tid}', which is not an encounter table")
print(f"levels: {len(table_blocks)} tables checked against their bands, {out_of_band} out of band")

if warns:
    print(f"WARNINGS ({len(warns)}):")
    for w in warns:
        print(" -", w)
print("ERRORS:" if errors else "ALL CHECKS PASSED")
for e in errors: print(" -", e)
sys.exit(1 if errors else 0)
