# ASHEN CROWN — Bug and Repair Log

**Audit date:** 2026-11-19
**Baseline:** `b4afeb7f` (PR #40 tip, branch `freebuff/world-art-equipment-pass`)
**Repair branch:** `freebuff/audit-save-repair`; audit reports on `freebuff/audit-docs`
**Runtime status:** not compiled or played. “Revalidated” below means the automated
validators pass; it does not mean the behavior was observed in GameMaker.

---

## 1. Repaired defects

### BUG-001 — Legacy saves lost level HP/MP and caster MAG during v4 migration

- **Severity:** HIGH (breaks existing saves)
- **System:** Save/load, character progression
- **Files:** `game/scripts/scr_save.gml`, `gamemaker/scripts/scr_save/scr_save.gml`
- **Function:** `scr_save_apply_member()`
- **Introduced by:** the schema v3 → v4 equipment pass in PR #40.

**Symptom.** Loading a valid schema v1, v2 or v3 save could restore the character's
level, XP, base ATK/DEF, equipment and inventory, but maximum HP and maximum MP were
recomputed from the fresh level-1 roster. A level-10 character could load with a
level-1 HP/MP bar. Caster MAG was also seeded from the fresh level-1 ATK instead of the
saved ATK.

**Root cause.** Schema v4 added `base_max_hp`, `base_max_mp` and `base_magic` and changed
`scr_actor_refresh_equipment()` to recompute:

```
max_hp = base_max_hp + equipment HP
max_mp = base_max_mp + equipment MP
magic  = base_magic + equipment MAG
```

A v1–v3 snapshot has none of those base fields. `scr_save_apply_member()` copied the
saved `max_hp` / `max_mp` into the runtime actor, but `scr_actor_apply_battle_defaults()`
had already seeded `base_max_hp` / `base_max_mp` from the fresh level-1 roster. The later
`scr_actor_refresh_equipment()` therefore overwrote the saved maxima with the level-1
values. The same ordering left `base_magic` at the fresh level-1 ATK.

This was verified against the previous schema: `b4afeb7f^` snapshots contain `max_hp`,
`max_mp`, `base_attack` and `base_defense`, but no `base_max_hp`, `base_max_mp` or
`base_magic`; the old refresh function did not touch max HP/MP.

**Repair.** In `scr_save_apply_member()`, when `base_max_hp` is absent (the pre-v4
marker), seed `base_max_hp` from the saved `max_hp`, `base_max_mp` from the saved
`max_mp`, and `base_magic` from the saved final `attack` (falling back to `base_attack`
if a hand-edited snapshot lacks it). v1–v3 magic resolved off final ATK, gear included;
using the saved final ATK preserves that damage curve better than the un-equipped base.
When the v4 base fields are present, use them unchanged. The equipment refresh then adds
the current gear bonuses once, instead of rebuilding from level 1.

**Consequences if unpatched.** Every pre-v4 save would load with severe HP/MP loss and
weaker caster damage. This is a save-breaking regression, not a cosmetic issue.

**Verification.** `python3 validate_gamemaker.py` passes; `tools/sync_gamemaker.py
--check` reports zero managed changes; the mirrored GML is byte-identical. **An actual
v3 save was not loaded in GameMaker — that test remains NOT RUN.** Follow-up PR #44 adds
sanitized v1–v4 fixtures, a Python fixture/wiring contract test, and
`scr_save_migration_test()` for the real GML migration path; the GML test has not been
executed because this environment has no GameMaker runtime.

---

### BUG-002 — Shop “Equipped” count ignored three of the seven slots

- **Severity:** LOW (wrong display; no item loss)
- **System:** Shop UI, equipment
- **Files:** `game/scripts/scr_menu_layout.gml`, `gamemaker/scripts/scr_menu_layout/scr_menu_layout.gml`
- **Function:** `scr_menu_equipped_count()`
- **Caller:** `game/objects/obj_shop_menu/Draw_GUI.gml`

**Symptom.** The sell pane's “Equipped” count could show 0 or 1 while the same item was
equipped in the off-hand, legs or accessory 2 slot.

**Root cause.** The function still used the pre-v4 four-slot list
`["weapon", "armor", "helm", "accessory"]` and looped `0..3`. The game now has seven
canonical slots, including `off_hand`, `legs` and `accessory_2`.

**Repair.** Iterate `scr_equipment_slots()` and resolve each canonical slot through
`scr_equipment_storage_key()`, so all seven storage keys are counted. The legacy
`accessory` key remains the storage key for `accessory_1`.

**Verification.** Validator and sync check pass. This is a display-only correction; no
inventory or equipment data is mutated. **No in-engine shop test was run.**

---

### BUG-003 — A refused unique drop was still announced as “Found”

- **Severity:** LOW (false message; no item duplication through this path)
- **System:** Battle rewards, inventory
- **Files:** `game/scripts/scr_battle_system.gml`, `gamemaker/scripts/scr_battle_system/scr_battle_system.gml`
- **Function:** `scr_battle_roll_drops()`

**Symptom.** When a defeated enemy rolled a unique item that the party already had in
the bag, the victory message could still add “Found X!” even though
`scr_inventory_add()` refused the item.

**Root cause.** The result of `scr_inventory_add()` was ignored. The code pushed the
display name and played the pickup sound unconditionally; the `|| _it.unique` branch
only ensured the once-only flag was set.

**Repair.** Only push the name and play the pickup cue when the add succeeds. If the add
is refused, set the once-only flag when applicable and skip the announcement. This keeps
the “once” roll latched without lying to the player.

**Verification.** Validator and sync check pass. **No in-engine victory screen test was
run.** This does not address the separate edge case where a unique item is currently
equipped (and therefore absent from the bag) and a non-once source tries to grant it
again; that is recorded as RISK-002 below.

---

### BUG-004 — Bestiary counter comment still said “12/35”

- **Severity:** LOW (maintainer documentation inside code)
- **System:** Bestiary
- **Files:** `game/scripts/scr_bestiary.gml`, mirror
- **Function:** `scr_bestiary_seen_total()`

**Symptom.** The comment described the counter as `"12/35"`, while the Bestiary has 43
entries.

**Repair.** Corrected the comment to `"12/43"`. No behavior changed.

**Verification.** Comment-only; validator and sync check pass.

---

### BUG-005 — CI did not run the equipment audit or a Python syntax pass

- **Severity:** MEDIUM (validation gap)
- **System:** GitHub Actions
- **File:** `.github/workflows/validate.yml`

**Symptom.** CI ran the structural validator, the source-to-generated check and the
chapter wiring audit, but not `tools/equipment_check.py` and not `py_compile`. Item
schema, progression tiers, merchant coverage and Python syntax regressions could reach a
PR without CI noticing.

**Repair.** Added:

```
python3 -m py_compile gen_gamemaker.py validate_gamemaker.py tools/*.py
python3 tools/equipment_check.py
```

No existing check was removed or weakened.

**Verification.** Both commands pass locally with exit status 0. The workflow file was
not executed on GitHub from this environment; the PR run is the remaining evidence.

---

## 2. Content and system defects

These were confirmed by source/data inspection. CONTENT-001 has since been implemented
in source by follow-up PR #44; the remaining items are not patched here and some require
a design decision or content work.

### CONTENT-001 — Chapter 1 main quest is absent from the journal and has no stage wiring

- **Severity:** HIGH (the opening main quest is invisible/untracked)
- **System:** Quest journal, Chapter 1 story
- **Files:** `game/scripts/scr_quest_data.gml`, `game/scripts/scr_map_markers_data.gml`,
  `game/scripts/scr_map_tilemaps.gml`, `game/scripts/scr_story.gml`

**Evidence.**

- `scr_quest_definitions()` defines eight quests: `Q_MAIN_BEYOND_VEIL`,
  `Q_MAIN_BLACKWOOD`, `Q_SIDE_TITHE`, `Q_SIDE_RENN`, `Q_MAIN_CROWN`,
  `Q_SIDE_LEDGER`, `Q_SIDE_ODA`, `Q_SIDE_PARCEL`. `Q_MAIN_FIND_MIRA` is not present.
- The only `Q_MAIN_FIND_MIRA` reference in runtime code is the `player_start` marker's
  `quest_start` field in `scr_map_markers_data.gml`.
- `scr_map_tilemaps.gml` copies marker fields such as `script_id` and `story_flag` into
  instances, but never reads `quest_start` or `quest_advance`. A project-wide search
  finds no consumer for either field.
- The approved stages `Q_FM_S1`–`Q_FM_S9` exist in `docs/story/CHAPTER1_SCRIPT.md`, but
  no runtime code writes those stage flags.

**Consequence.** Even if the marker fields were consumed, the journal would hide the
quest because there is no definition. Chapter 1's main objective is not shown, and its
stage transitions do not run. Chapters 2–11 use `scr_ch*_quest_set()` and are unaffected.

**Why it was not patched in the audit.** Completing it meant adding a nine-stage
definition and wiring starts/advances across the arrival, Tomas scene, pendant pickup,
north gate, Farmlands, Old Road, Bandit Camp, Watchtower, Basement, arena and Blackguard
victory. That is story-system implementation, not a smallest safe audit correction.

**Follow-up implementation (PR #44, `freebuff/audit-followups`).** `scr_quest_definitions()`
now contains the approved nine-stage quest. Starts are wired in the existing `GH_ARRIVAL`,
`GH_TOMAS`, Varyn House pendant, `BG_INTRO` and `CV_END` callbacks. `scr_quest_advance()`
adds ordered, non-regressing stage writes, and `scr_ch1_quest_tick()` backfills existing
saves from flags plus the Farmlands/Old Road/Bandit Camp rectangles and the Watchtower
rooms. The Blackguard victory completes Find Mira; the Crownveil door starts Beyond the
Veil. The Python fixture test and `tools/audit_chapters.py` pass.

**Status:** FIXED IN SOURCE — PR #44; in-engine journal check **NOT RUN**.

---

### DEBT-001 — Map-marker quest metadata is dead data

- **Severity:** MEDIUM
- **System:** Map markers / quests
- **Files:** `game/scripts/scr_map_markers_data.gml`,
  `game/scripts/scr_wf_markers_data.gml`, `game/scripts/scr_map_tilemaps.gml`

**Evidence.** The marker tables contain `quest_start`, `quest_advance` and
`quest_turn_in` fields, and some include `reward`. No runtime file reads any of them.
`quest_start`/`quest_advance` appear only in marker data; `quest_turn_in` and marker
`reward` do not appear outside marker data at all.

**Consequence.** Writers can add quest metadata that looks functional but does nothing.
This is how CONTENT-001 remained hidden. PR #44 resolves Chapter 1 through the existing
story-function pattern (option B), not through these marker fields, so the dead metadata
is still misleading. Remove it or give it a single documented consumer in a separate
change; do not add a second quest mechanism.

**Status:** OPEN — technical debt / cleanup after the PR #44 decision.

---

### DEBT-002 — Save writes are not atomic

- **Severity:** MEDIUM (reliability)
- **System:** Save/load
- **File:** `game/scripts/scr_save.gml`, `scr_save_write()`

`buffer_save()` writes directly to `saveN.sav`. A crash, power loss or full disk during
the write can leave a truncated slot. Reads fail safely (`scr_save_read_raw()` returns
`undefined`), so this does not crash the game, but the previous save is lost.

**Recommended repair:** write to `saveN.tmp`, flush/close, verify, then rename over the
slot, keeping a `.bak` until the new file validates. Needs an in-engine file-system test.

**Status:** OPEN.

---

### DEBT-003 — Invalid equipped items are cleared, not returned to the bag

- **Severity:** LOW (corrupt/edited saves only)
- **System:** Save/load, equipment
- **File:** `game/scripts/scr_save.gml`, `scr_save_sanitize_equipment()`

If a save contains an unknown item, a wrong-slot item or a two-handed/off-hand conflict,
the sanitizer clears the equipment key with a warning. The item is not added back to the
inventory. For a hand-edited or partially corrupt save this can delete a legitimate
piece. The safe repair is to return a valid item to the bag before clearing, with a
duplicate guard.

**Status:** OPEN — low priority; normal saves are already sanitized on write.

---

### DEBT-004 — `scr_craft_make()` ignores a failed inventory add

- **Severity:** LOW (latent; no current unique recipe)
- **System:** Forge
- **File:** `game/scripts/scr_item_data.gml`

`scr_craft_make()` removes materials and gold, then calls `scr_inventory_add()` without
checking the return value. If the result were unique/key and already in the bag, the
materials would be consumed and the message would still say “Forged”. The current 20
recipes produce non-unique rare gear, so the path is not reachable with today's data.
If a unique recipe is added, check ownership before consuming materials.

**Status:** OPEN — latent.

---

### DEBT-005 — Left stick is movement-only

- **Severity:** LOW (behavior/documentation mismatch)
- **System:** Input
- **Files:** `game/scripts/scr_input.gml`

The file header says “D-pad / left stick movement and menu navigation”. Movement reads
both D-pad and left stick, but `scr_input_up_pressed()` and the other menu directions
read only `gp_padu/padd/padl/padr`. The assignment requires D-pad menu navigation and
left-stick movement, so this does not violate the stated requirement; the header should
not imply otherwise. Adding stick menu navigation needs a repeat/dead-zone policy so a
held stick does not race through menus.

**Status:** OPEN — documentation/UX polish.

---

### RISK-001 — Guard may expire before it protects a slow guarder

- **Severity:** MEDIUM (unconfirmed design risk)
- **System:** Battle
- **Files:** `game/objects/obj_battle_controller/Step.gml`,
  `game/scripts/scr_battle_system.gml`

`ROUND_START` calls `scr_party_clear_guard(party)` before the new command phase. If a
party member chooses Guard after all enemies have already acted that round, the guard is
cleared at the start of the next round before any enemy acts, so it provides no
protection. If Guard is meant to last until the guarder's next turn (the usual JRPG
rule), this is a bug. If it is meant to last only within the round it was chosen, it is
working as designed. This needs a design decision and a battle test; no code was changed.

**Status:** UNCONFIRMED — playtest/design.

---

### RISK-002 — Unique items are unique only while in the bag

- **Severity:** LOW (edge case)
- **System:** Inventory/equipment
- **Files:** `game/scripts/scr_inventory.gml`, `game/scripts/scr_battle_system.gml`,
  `game/scripts/scr_shop_data.gml`

`scr_inventory_add()` refuses a second copy of a unique/key item only when
`scr_inventory_count()` finds it in the bag. Equipping removes the item from the bag, so
a second grant from a non-`once` source could add a duplicate while the first copy is
equipped. Boss legendary drops are marked `once` and shops do not stock legendaries, so
the known paths are protected. A future non-once unique source needs an ownership check
across equipment too.

**Status:** OPEN — latent.

---

## 3. Non-issues confirmed during the audit

- **No duplicate function definitions.** 686 definitions, all unique.
- **No undefined `scr_*` calls** after comments and strings were stripped.
- **No function-arity mismatches.** 3,862 call sites checked against 686 definitions;
  `scr_sprite_index()` is variadic by design.
- **No direct gamepad reads outside `scr_input.gml`.** The only direct keyboard read
  outside the input layer is the debug F5 save shortcut in `obj_game_controller`.
- **No missing `target_spawn` names.** All 43 distinct target-spawn strings resolve to a
  marker name somewhere in the project.
- **No Bestiary-to-data or Bestiary-to-art gap.** 43/43 entries resolve.
- **No encounter table references to unknown enemies.** 114 table references checked.
- **No equipment schema errors.** 181 records, 136 equipment items, 20 recipes, 0
  invalid.
- **Seven missing rooms are deliberate stubs**, not accidental broken exits:
  `rm_flooded_ruins`, `rm_frozen_ruins`, `rm_ironspine_mine`, `rm_ironspine_ruins`,
  `rm_saltreach`, `rm_saltreach_pier`, `rm_shipwreck`.

---

## 4. Validation evidence for the repairs

Commands run from the repository root after the edits:

| Command | Status |
|---|---|
| `python3 validate_gamemaker.py` | PASS — `ALL CHECKS PASSED` (4 pre-existing encounter-band warnings) |
| `python3 tools/sync_gamemaker.py --check` | PASS — zero managed changes |
| `python3 tools/audit_chapters.py` | PASS — no wiring problems, 72 notes |
| `python3 tools/equipment_check.py` | PASS — no errors, 5 balance flags |
| `python3 tools/sim_ch5_flow.py` | PASS — both yield/kill branches close |
| `python3 tools/balance_sim.py` | PASS (model only) |
| `python3 -m py_compile ...` | PASS |
| `git diff --check` | PASS |

These are static/automated results. **GameMaker compilation, save loading, battle
runtime, shop rendering and controller testing remain NOT RUN.**
