#!/usr/bin/env python3
"""Cross-chapter audit: find the wiring problems validate_gamemaker.py does not check.

Checks, per chapter and across the whole game:
  1. Story scripts reference dialogue ids that scr_dialogue_data*.gml does not define.
  2. Marker script_ids (npc/lore/exit hooks) are not handled by any scr_*_play_script dispatcher.
  3. zone_exit markers target a spawn name their target room's marker table does not define.
  4. scr_encounter_start groups/encounter ids are not defined, and group enemies are not in the
     enemy database.
  5. Encounter table ids used by markers do not exist.
  6. scr_*_quest_set calls name a quest or stage that scr_quest_data.gml does not define.
  7. Rooms have no ambience case in scr_audio.gml.
  8. Dialogue data nodes are defined but never referenced anywhere (dead data, informational).
  9. Every `**ID** · Speaker` line in docs/story/CHAPTER*_SCRIPT.md has a dialogue node.

Read-only. Run from the repo root:
    python3 tools/audit_chapters.py
"""
import glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCR = os.path.join(ROOT, 'game', 'scripts')
GM = os.path.join(ROOT, 'gamemaker')

problems = []
notes = []


def read(p):
    return open(p, encoding='utf-8').read()


def rel(p):
    return os.path.relpath(p, ROOT)


# ---------------------------------------------------------------- gather
story_files = sorted(glob.glob(os.path.join(SCR, 'scr_ch*_story.gml')))
dialogue_files = sorted(glob.glob(os.path.join(SCR, 'scr_dialogue_data*.gml')))
marker_files = sorted(glob.glob(os.path.join(SCR, '*markers_data*.gml'))) + \
    sorted(glob.glob(os.path.join(SCR, 'scr_map_markers_data.gml'))) + \
    sorted(glob.glob(os.path.join(SCR, '*overworld_patch*.gml')))

defined_ids = set()
node_owner = {}
for f in dialogue_files:
    for nid in re.findall(r'^\s*case "([A-Z][A-Z0-9_]+)":', read(f), re.M):
        defined_ids.add(nid)
        node_owner[nid] = os.path.basename(f)
# Chapter 1/2 nodes also live in the main dispatch switch
for nid in re.findall(r'^\s*case "([A-Z][A-Z0-9_]+)":', read(os.path.join(SCR, 'scr_dialogue_data.gml')), re.M):
    defined_ids.add(nid)

# Every scr_*_play_script dispatcher, wherever it lives: the chapter scripts hold theirs, but
# Chapter 1's and Chapter 2's sit in their scr_dialogue_data files.
dispatch = ''
for f in story_files:
    dispatch += read(f)
for f in glob.glob(os.path.join(SCR, '*.gml')):
    t = read(f)
    for m in re.finditer(r'function (scr_\w*_play_script)\(', t):
        start = m.start()
        nxt = t.find('\nfunction ', start + 10)
        dispatch += t[start:] if nxt == -1 else t[start:nxt]
dispatch_ids = set(re.findall(r'case "([A-Z0-9_]+)":', dispatch))

all_script_text = ''
for f in glob.glob(os.path.join(SCR, '*.gml')):
    all_script_text += read(f) + '\n'

# 1 --------------------------------------------------- story -> dialogue ids
# A scene hook such as "FK_03" or "HS_LORE_01" is a dispatch case, not a dialogue node, so
# ids that are switch labels in a story script are excluded.
ID_PAT = re.compile(r'"([A-Z][A-Z0-9_]+_[0-9]{2})"')
dispatch_labels = set(re.findall(r'case "([A-Z0-9_]+)":', dispatch))
for f in story_files:
    used = set(ID_PAT.findall(read(f))) - dispatch_labels
    for nid in sorted(used - defined_ids):
        problems.append(f"{rel(f)}: dialogue id {nid} is referenced but not defined")

# 2 --------------------------------------------------- marker script hooks
# zone_exit script_ids are labels for scr_*_exit_script (which keys off the marker name), not
# play-script cases, so they are excluded here.
exit_labels = set()
marker_script_ids = {}
for f in marker_files:
    t = read(f)
    for block in re.findall(r'\{[^{}]*?(?:type|"type"): "zone_exit"[^{}]*\}', t):
        exit_labels.update(re.findall(r'script_id: "([A-Z0-9_]+)"', block))
    for sid in set(re.findall(r'script_id: "([A-Z0-9_]+)"', t)):
        marker_script_ids.setdefault(sid, set()).add(rel(f))

# A non-exit hook counts as handled if the id appears in any non-marker script (dispatch case,
# comparison, table key), or if its marker carries `lines` that the dialogue fallback can show.
# Code that can handle a hook or name a node: everything except the marker tables and the
# dialogue node data itself (a node naming its own id is not a reference to it).
code_text = ''
for f in glob.glob(os.path.join(SCR, '*.gml')):
    if 'markers_data' in f or 'scr_dialogue_data' in f:
        continue
    code_text += read(f) + '\n'
# The main switch (scr_dialogue_play_script) is code even though it lives in a data file.
non_marker_text = code_text + dispatch
for f, files in sorted(((k, v) for k, v in marker_script_ids.items())):
    if f in exit_labels:
        continue
    if f in defined_ids:
        continue  # played as a node id (scr_dialogue_play_script's fallback) plus script_chain
    if ('"%s"' % f) in non_marker_text:
        continue
    # Collectors such as FL_TUTORIAL / BG_DEFEAT are marker labels for a script_chain or a
    # defeat_script_id; the ids they stand for are the <label>_01 lines, so a family prefix counts.
    if ('"%s_' % f) in non_marker_text:
        continue
    problems.append(f"{sorted(files)[0]}: script_id {f} appears in no script and has no handler"
                    + ("" if f not in dispatch_ids else " (dispatch only)"))

# 3 --------------------------------------------------- exit targets resolve
# A room can build from several marker tables (rm_overworld merges the Chapter 2 patch), so
# collect every scr_*_markers() the builder passes to scr_map_spawn_markers.
marker_bodies = {}
for f in marker_files:
    t = read(f)
    for m in re.finditer(r'function (scr_\w+_markers)\(\) \{', t):
        body = t[m.start():]
        nxt = body.find('\nfunction ', 1)
        marker_bodies[m.group(1)] = body if nxt == -1 else body[:nxt]

room_markers = {}
for f in glob.glob(os.path.join(SCR, 'scr_build_*.gml')):
    room = 'rm_' + os.path.basename(f)[len('scr_build_'):-4]
    fns = [fn for fn in re.findall(r'(scr_\w+_markers)\(\)', read(f)) if fn in marker_bodies]
    if fns:
        room_markers[room] = fns

spawns = {}       # room -> every marker name scr_map_find_marker() can resolve
exits = []        # (source, target_room, target_spawn)
for room, fns in room_markers.items():
    spawns[room] = set()
    for fn in fns:
        body = marker_bodies[fn]
        # scr_map_find_marker matches on name alone, so entrances and locations are spawn targets too.
        spawns[room] |= set(re.findall(r'name: "([a-z_0-9]+)"', body))
        for m in re.finditer(r'type: "zone_exit", name: "([a-z_0-9]+)".*?target_room: "([a-z_0-9]+)", target_spawn: "([a-z_0-9]*)"', body, re.S):
            exits.append((room, m.group(2), m.group(3), m.group(1)))

for src_room, target, spawn, name in exits:
    if target not in spawns:
        if os.path.isdir(os.path.join(GM, 'rooms', target)):
            problems.append(f"{src_room}: exit '{name}' targets {target}, whose markers define no spawns")
        continue  # unbuilt target rooms are reported by validate_gamemaker.py
    if spawn and spawn not in spawns[target]:
        problems.append(f"{src_room}: exit '{name}' -> {target} spawn '{spawn}' does not exist "
                        f"(has: {', '.join(sorted(spawns[target])) or 'none'})")

# 4 --------------------------------------------------- encounter groups/enemies
groups = set(re.findall(r'case "(grp_[a-z0-9_]+)":', read(os.path.join(SCR, 'scr_encounter_tables.gml'))))
for f in glob.glob(os.path.join(SCR, 'scr_ch*_story.gml')):
    for g in set(re.findall(r'scr_encounter_start\("(grp_[a-z0-9_]+)"', read(f))):
        if g not in groups:
            problems.append(f"{rel(f)}: encounter group {g} is not defined")

enemy_ids = set(re.findall(r'case "([a-z0-9_]+)":', read(os.path.join(SCR, 'scr_enemy_database.gml'))))
tables_text = read(os.path.join(SCR, 'scr_encounter_tables.gml'))
for f in marker_files:
    t = read(f)
    for tid in set(re.findall(r'table_id: "([a-z0-9_]+)"', t)):
        if 'case "%s":' % tid not in tables_text:
            problems.append(f"{rel(f)}: encounter table {tid} is not defined")
    for eid in set(re.findall(r'enemy_id: "([a-z0-9_]+)"', t)):
        if eid not in enemy_ids:
            problems.append(f"{rel(f)}: encounter enemy {eid} is not in the enemy database")

# 5 --------------------------------------------------- quests
quest_text = read(os.path.join(SCR, 'scr_quest_data.gml'))
quest_defs = {}
for m in re.finditer(r'\{\s*id: "(Q_[A-Z_]+)",.*?stages: \[(.*?)\]', quest_text, re.S):
    quest_defs[m.group(1)] = set(re.findall(r'id: "(Q_[A-Z0-9_]+)"', m.group(2)))
for f in glob.glob(os.path.join(SCR, 'scr_*_story.gml')):
    for qid, stage in re.findall(r'scr_\w+_quest_set\("(Q_[A-Z_]+)", "([A-Za-z0-9_]+)"\)', read(f)):
        if qid not in quest_defs:
            problems.append(f"{rel(f)}: quest {qid} is not defined")
        elif stage != 'complete' and stage not in quest_defs[qid]:
            problems.append(f"{rel(f)}: quest {qid} has no stage {stage}")

# 6 --------------------------------------------------- audio beds
audio = read(os.path.join(SCR, 'scr_audio.gml'))
for room in sorted(spawns):
    if 'case "%s":' % room not in audio:
        problems.append(f"{room}: no ambience case in scr_audio.gml")

# 7 --------------------------------------------------- script lines exist as data
SCRIPT_HDR = re.compile(r'^(?:.*?[,—] )?\*\*([A-Z][A-Z0-9_]+)\*\*\s*·\s*(.+?):?$')
for md in sorted(glob.glob(os.path.join(ROOT, 'docs', 'story', 'CHAPTER*_SCRIPT.md'))):
    text = read(md)
    # Draft scripts may land before their dialogue data exists. The marker is explicit so a
    # finished chapter that loses its data still fails this check.
    if '<!-- audit-skip:' in text:
        notes.append(f"{rel(md)}: skipped by audit-skip marker (draft script, no dialogue data yet)")
        continue
    want = set()
    for line in text.split('\n'):
        m = SCRIPT_HDR.match(line)
        if m:
            want.add(m.group(1))
    for nid in sorted(want - defined_ids):
        problems.append(f"{rel(md)}: scripted line {nid} has no dialogue node in any scr_dialogue_data file")

# 8 --------------------------------------------------- dead dialogue nodes
# Any id the code names counts, not only NN-suffixed ones: CH10_LOCKED, BG_INTRO and
# CH5_HANDOFF_LOCKED are real dispatcher targets.
referenced = {nid for nid in defined_ids if ('"%s"' % nid) in non_marker_text}
for nid in sorted(defined_ids - referenced):
    notes.append(f"dialogue node {nid} ({node_owner.get(nid, 'scr_dialogue_data.gml')}) is never referenced")

# ---------------------------------------------------------------- report
print(f"story scripts: {len(story_files)}  dialogue files: {len(dialogue_files)}  "
      f"rooms with markers: {len(spawns)}  exits checked: {len(exits)}")
print(f"dialogue ids defined: {len(defined_ids)}  referenced by scripts: {len(referenced & defined_ids)}")
print()
if problems:
    print(f"PROBLEMS ({len(problems)}):")
    for p in problems:
        print(" -", p)
else:
    print("No wiring problems found.")
print()
if notes:
    print(f"NOTES ({len(notes)}):")
    for n in notes[:40]:
        print(" -", n)
    if len(notes) > 40:
        print(f" - … {len(notes) - 40} more")
sys.exit(1 if problems else 0)
