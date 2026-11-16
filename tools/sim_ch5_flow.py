#!/usr/bin/env python3
"""Static flow check for Chapter 5 (docs/story/CHAPTER5_SCRIPT.md, approved 2026-11-16).

This does not play the chapter. It models the gates that game/scripts/scr_ch5_story.gml
applies, then exhaustively explores every reachable state to prove three things:

  1. ORDERED COMPLETION — a path exists from arrival to the treeline handoff: enter, notice,
     gate, yard, Sera, Hailen, the choice, the fight, the records room, Sera's stake, the join,
     the handoff.
  2. NO DEAD ENDS — from *every* reachable state the handoff is still reachable. Nothing the
     player can do first (records before the fight, handoff before the join, wrong choice,
     a lost fight) can lock the chapter.
  3. BOTH OUTCOMES — the yield choice and the kill branch each complete, and `flag_hailen_yielded`
     only ever matches the choice.

It also cross-checks the model against the real files so it cannot drift:
  - every flag the model knows exists in scr_ch5_story.gml, and every flag in that file is modelled;
  - every marker's script_id is handled by the story script;
  - every door's target room exists (or is a declared stub) and its target spawn exists there.

Run from the repo root:
    python3 tools/sim_ch5_flow.py
"""
import itertools, os, re, sys
from collections import deque

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
STORY = os.path.join(ROOT, 'game/scripts/scr_ch5_story.gml')
MARKERS = os.path.join(ROOT, 'game/scripts/scr_ch5_markers_data.gml')
YPP = os.path.join(ROOT, 'gamemaker/AshenCrown.yyp')

failures = []


def fail(msg):
    failures.append(msg)


# ======================================================================================
# Static cross-checks against the real project

story_src = open(STORY, encoding='utf-8').read()
marker_src = open(MARKERS, encoding='utf-8').read()
yyp_src = open(YPP, encoding='utf-8').read()

built_rooms = set(re.findall(r'"name"\s*:\s*"(rm_[a-z0-9_]+)"', yyp_src))
stub_rooms = {'rm_blackwood_deep'}  # Act III, deliberately unwritten


def parse_markers(src):
    out = []
    for line in src.split('\n'):
        if not line.strip().startswith('{ type:'):
            continue
        m = dict(re.findall(r'(\w+):\s*"([^"]*)"', line))
        nums = dict(re.findall(r'(\w+):\s*(-?\d+)(?![\w"])', line))
        m.update({k: int(v) for k, v in nums.items()})
        out.append(m)
    return out


markers = parse_markers(marker_src)
by_room = {}
for m in markers:
    by_room.setdefault(m.get('name'), m)  # flat namespace; names are unique per chapter

handled_scripts = set(re.findall(r'case "([A-Z0-9_]+)"', story_src))
exit_names = set(re.findall(r'_m\.name\s*[!=]=\s*"([a-z0-9_]+)"', story_src))


# Spawn names live in each room's marker table; index every markers file by its room.
room_spawns = {}
scripts_dir = os.path.join(ROOT, 'game/scripts')
for fn in sorted(os.listdir(scripts_dir)):
    if not fn.endswith('markers_data.gml'):
        continue
    src = open(os.path.join(scripts_dir, fn), encoding='utf-8').read()
    for fname, body in re.findall(r'function scr_(\w+)_markers\(\) \{(.*?)\n\}', src, re.S):
        room = 'rm_' + fname
        room_spawns.setdefault(room, set()).update(re.findall(r'name: "([a-z0-9_]+)"', body))


def spawn_exists(room_name, spawn_name):
    if room_name not in built_rooms:
        return None
    return spawn_name in room_spawns.get(room_name, set())


for m in markers:
    sid = m.get('script_id', '')
    if sid and sid not in handled_scripts and m.get('name') not in exit_names:
        fail('marker %r has script_id %r that scr_ch5_story does not handle' % (m.get('name'), sid))
    if not m.get('target_room'):
        continue
    tgt = m['target_room']
    if tgt not in built_rooms and tgt not in stub_rooms:
        fail('marker %r targets unknown room %r' % (m.get('name'), tgt))
    if tgt in built_rooms and not spawn_exists(tgt, m.get('target_spawn', '')):
        fail('marker %r targets %r spawn %r that does not exist' % (m.get('name'), tgt, m.get('target_spawn')))

# ======================================================================================
# The model. Each action mirrors a gate in scr_ch5_story.gml; the comment names it.

FLAGS = {
    'entered': 'flag_garrison_entered',        # scr_ch5_bg_enter callback
    'notice': 'flag_bg_notice_seen',           # scr_ch5_play_script BG_NOTICE
    'gate': 'flag_bg_gate_seen',               # BG_GATE
    'yard': 'flag_bg_yard_seen',               # BG_YARD
    'sera': 'flag_sera_met',                   # SR_MEET
    'intro': 'flag_hailen_intro_seen',         # scr_ch5_hailen_scene callback
    'yields': 'flag_hailen_yields',            # the pre-battle choice
    'yielded': 'flag_hailen_yielded',          # set by the battle engine on a yield
    'beaten': 'flag_hailen_beaten',            # scr_ch5_on_battle_finish
    'lead': 'flag_blackwood_lead',             # BW_LEAD
    'stake': 'flag_sera_stake_done',           # SR_STAKE
    'recruited': 'flag_sera_recruited',        # scr_ch5_sera_join callback
    'fk4': 'flag_fk_seen_4',                   # handoff callback
    'complete': 'flag_chapter5_complete',
    'act2': 'flag_act2_complete',
}

gml_flags = set(re.findall(r'"(flag_[a-z0-9_]+)"', story_src))
model_flags = set(FLAGS.values())
for f in sorted(model_flags - gml_flags):
    fail('model uses %r, which scr_ch5_story.gml never mentions (stale model)' % f)
for f in sorted(gml_flags - model_flags):
    fail('scr_ch5_story.gml uses %r, which the model does not track (missing gate)' % f)

ROAD, YARD, KEEP = 'road', 'yard', 'keep'


def move(state, loc):
    return (state, loc)


def step(state, loc, action):
    """Apply one player action. Returns (new_state, new_loc) or the same pair if blocked."""
    s, l = set(state), loc
    a = action

    if a == 'walk_road':
        if l == YARD and not s & {'gate'}:
            pass  # out through a gate that closed behind them is still open to the road
        return (frozenset(s), ROAD)
    if a == 'walk_yard':
        if l == ROAD and 'gate' not in s:
            return (frozenset(s), ROAD)  # the sergeant stops them at the ledger (BG_GATE_01-10)
        return (frozenset(s), YARD)
    if a == 'walk_keep':
        if l == YARD and 'beaten' in s:
            return (frozenset(s), KEEP)
        return (frozenset(s), l)  # barred: BG_KEEP_LOCKED

    if a == 'inspect_notice' and l == ROAD:
        s.add('notice')
    elif a == 'talk_gate' and l == ROAD:
        s.add('gate')
    elif a == 'enter_yard' and l == YARD:
        s.add('yard')
    elif a == 'talk_sera' and l == YARD:
        s.add('sera')
    elif a == 'talk_hailen' and l == YARD:
        if 'beaten' in s:
            pass                                   # HL_INTRO_R1
        elif 'yard' not in s:
            pass                                   # BG_YARD_R1 gate
        elif 'intro' in s:
            s.add('intro')                         # HL_INTRO_R1, then the choice again (retry)
        else:
            s.add('intro')                         # HL_INTRO_01-19
    elif a == 'choose_yield' and l == YARD:
        if 'intro' in s and 'beaten' not in s:
            s.add('yields')
    elif a == 'choose_kill' and l == YARD:
        if 'intro' in s and 'beaten' not in s:
            s.discard('yields')
    elif a in ('win_fight', 'lose_fight') and l == YARD:
        if 'intro' in s and 'beaten' not in s:
            if a == 'lose_fight':
                return (frozenset(s), l)           # defeat: nothing consumed, retry allowed
            s.add('beaten')
            if 'yields' in s:
                s.add('yielded')
    elif a == 'read_records' and l == KEEP:
        if 'beaten' in s:
            s.add('lead')                          # BW_LEAD_01-11
    elif a == 'talk_sera_stake' and l == KEEP:
        if 'lead' in s:
            s.add('stake')                         # SR_STAKE_01-09
    elif a == 'leave_keep' and l == KEEP:
        if 'stake' in s and 'recruited' not in s:
            s.add('recruited')                     # scr_ch5_sera_join on the to_yard door
        return (frozenset(s), YARD)
    elif a == 'handoff' and l == ROAD:
        if 'recruited' in s and 'complete' not in s:
            s |= {'fk4', 'complete', 'act2'}       # BG_HANDOFF_01-08 + FK4_01-05
    return (frozenset(s), l)


ACTIONS = ['walk_road', 'walk_yard', 'walk_keep', 'inspect_notice', 'talk_gate', 'enter_yard',
           'talk_sera', 'talk_hailen', 'choose_yield', 'choose_kill', 'win_fight', 'lose_fight',
           'read_records', 'talk_sera_stake', 'leave_keep', 'handoff']

GOAL = ('complete',)


def is_goal(state):
    return all(g in state for g in GOAL)


start = (frozenset(), ROAD)
seen = {start: None}
queue = deque([start])
edges = {}
while queue:
    node = queue.popleft()
    for a in ACTIONS:
        nxt = step(node[0], node[1], a)
        edges[(node, a)] = nxt
        if nxt != node and nxt not in seen:
            seen[nxt] = (node, a)
            queue.append(nxt)

# 1. the goal is reachable, and the path is reported
if not any(is_goal(n[0]) for n in seen):
    fail('the handoff is unreachable from the start state')


def path_to(goal_node):
    out, cur = [], goal_node
    while seen[cur] is not None:
        prev, a = seen[cur]
        out.append(a)
        cur = prev
    return list(reversed(out))


# 2. no dead ends: from every reachable state the handoff stays reachable
goal_states = [n for n in seen if is_goal(n[0])]
if not goal_states:
    print('model states explored:', len(seen))
    print('\nFAILURES (%d):' % len(failures))
    for f in failures:
        print(' -', f)
    sys.exit(1)
reachable_from = {}
reverse = {}
for (node, a), nxt in edges.items():
    if nxt != node:
        reverse.setdefault(nxt, set()).add((node, a))
for g in goal_states:
    stack = [g]
    while stack:
        cur = stack.pop()
        if cur in reachable_from:
            continue
        reachable_from[cur] = True
        for prev, _a in reverse.get(cur, ()):
            if prev not in reachable_from:
                stack.append(prev)
dead = [n for n in seen if n not in reachable_from]
if dead:
    fail('%d reachable state(s) cannot reach the handoff, e.g. %r' % (len(dead), dead[0]))

# 3. both choice branches complete, and the yielded flag never lies
for choice in ('choose_yield', 'choose_kill'):
    branch = [n for n in seen if ('complete' in n[0] and
                                  ((choice == 'choose_yield') == ('yielded' in n[0]))
                                  and ('yields' in n[0]) == (choice == 'choose_yield'))]
    if not branch:
        fail('no completed state for the %s branch' % choice)
for n in seen:
    s = n[0]
    if 'yielded' in s and 'yields' not in s:
        fail('flag_hailen_yielded set without flag_hailen_yields: %r' % (n,))
    if 'recruited' in s and 'stake' not in s:
        fail('Sera recruited without her stake scene: %r' % (n,))
    if 'beaten' in s and 'intro' not in s:
        fail('Hailen beaten without his intro: %r' % (n,))
    if 'complete' in s and not {'recruited', 'lead'} <= s:
        fail('chapter complete without the lead and the recruit: %r' % (n,))

# ======================================================================================
# Report

print('model states explored:', len(seen))
print('markers checked:', len(markers), '(script_ids handled, doors and spawns resolved)')
first_goal = next(n for n in seen if is_goal(n[0]))
route = path_to(first_goal)
print('shortest route to the handoff (%d actions):' % len(route))
print('  ' + ' -> '.join(route))

# a readable happy path through the real scene order
happy = ['inspect_notice', 'talk_gate', 'walk_yard', 'enter_yard', 'talk_sera', 'talk_hailen',
         'choose_yield', 'win_fight', 'walk_keep', 'read_records', 'talk_sera_stake',
         'leave_keep', 'walk_road', 'handoff']
state, loc = start
for a in happy:
    state, loc = step(state, loc, a)
if not is_goal(state):
    fail('the intended scene order does not complete the chapter (%r)' % (sorted(state),))

# the two branches, and the defeat retry
for choice in ('choose_yield', 'choose_kill'):
    s, l = start
    for a in ['talk_gate', 'walk_yard', 'enter_yard', 'talk_hailen', choice, 'lose_fight']:
        s, l = step(s, l, a)
    if 'beaten' in s:
        fail('a lost fight marked Hailen beaten')
    for a in ['win_fight', 'walk_keep', 'read_records', 'talk_sera_stake', 'leave_keep', 'walk_road', 'handoff']:
        s, l = step(s, l, a)
    if not is_goal(s):
        fail('%s branch did not reach the handoff' % choice)
    print('%s branch: yielded=%s complete=%s' % (choice, 'yielded' in s, 'complete' in s))

# out-of-order attempts are refused, not absorbed
s, l = start
for a in ['read_records', 'talk_sera_stake', 'handoff', 'leave_keep', 'win_fight']:
    s, l = step(s, l, a)
if s or l != ROAD:
    fail('out-of-order actions changed state before the gate: %r' % (sorted(s),))
print('out-of-order attempts at the road spawn: no state change')


def refused(before, action, label):
    """Run one action in a given (state, loc) and require that nothing changes."""
    after = step(before[0], before[1], action)
    if after != before:
        fail('%s: %s changed the state to %r' % (label, action, sorted(after[0])))
    else:
        print('guard holds: %s' % label)


road = (frozenset(), ROAD)
yard = (frozenset({'gate', 'yard'}), YARD)
keep_no_lead = (frozenset({'gate', 'yard', 'intro', 'beaten'}), KEEP)
done = (frozenset({'gate', 'yard', 'intro', 'beaten', 'lead', 'stake', 'recruited',
                   'fk4', 'complete', 'act2'}), ROAD)

refused(yard, 'walk_keep', 'the office stays barred until Hailen is beaten')
refused(yard, 'read_records', 'records cannot be read from the yard')
refused(yard, 'talk_sera_stake', 'Sera makes her case in the records room, not the yard')
refused(keep_no_lead, 'talk_sera_stake', 'no stake scene before the sealed order is read')
refused(road, 'talk_hailen', 'Hailen cannot be reached from the road')
refused((frozenset({'gate', 'yard'}), YARD), 'choose_yield', 'no choice before Hailen speaks')
refused(road, 'handoff', 'no handoff before Sera joins')
refused(done, 'handoff', 'a finished chapter does not replay the handoff')

if failures:
    print('\nFAILURES (%d):' % len(failures))
    for f in failures:
        print(' -', f)
    sys.exit(1)
print('\nALL CHECKS PASSED — the chapter completes in order, both branches close, and no reachable state dead-ends.')
