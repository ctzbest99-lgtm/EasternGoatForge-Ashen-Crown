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
             'rm_greyhaven_tavern','rm_greyhaven_chapel','rm_greyhaven_blacksmith','rm_greyhaven_general_store'):
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
refs = set()
for root, dirs, files in os.walk(OUT):
    for fn in files:
        if fn.endswith('.gml'):
            refs |= set(re.findall(r'\b((?:spr|obj|ts|rm)_\w+)\b', open(os.path.join(root,fn)).read()))
missing = refs - sprites - objects - scripts - set(rooms) - {'ts_zone1'}
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

print("ERRORS:" if errors else "ALL CHECKS PASSED")
for e in errors: print(" -", e)
sys.exit(1 if errors else 0)
