# Changelog

## 2026-11-14 — 640 title set imported; generator committed to the repo
- `gamemaker/` now includes the full 640 title set (19 sprites, including `spr_menu_embers_640_strip24`) in its own `tex_title_640` texture group, as IMPORT.md prescribes; every platform's texture page is already 2048×2048. The previous "skip the 640 ember strip" note no longer applies. 461 sprites total.
- Added `gen_gamemaker.py` and `validate_gamemaker.py` at the repo root: the generator rebuilds `gamemaker/` from `game/` self-contained (options and README are restored from the existing tree; needs Python 3 + Pillow), and the validator re-checks the result (JSON parses, resource paths resolve, sprite PNG dimensions, byte-identical scripts/datafiles, room layers and room order).

## 2026-11-14 — Generated ready-to-open GameMaker project (v2, current with battle-upgrade main)
- Added `gamemaker/`: a complete GameMaker project (`AshenCrown.yyp`, 2024.x format) generated from `game/` — 34 scripts, 20 objects with all events wired (Create, Step, Begin/End Step, Room Start, Draw GUI, Clean Up), 460 sprites (every asset in the `game/sprites/IMPORT.md` table, split into per-frame PNGs with the documented origins, collision masks, fps, nine-slice, and texture groups), the `ts_zone1` tileset (256×800, 800 tiles), and 10 rooms — `rm_title` (first in Room Order), `rm_overworld`, `rm_old_watchtower`, `rm_watchtower_basement`, the five Greyhaven interiors, and `rm_battle_test` — each with the five tile layers the map code expects, creation code calling the matching `scr_build_*()`, player/controller placement at the documented spawn markers, and the 320×180 camera view. `datafiles/` are byte-identical copies of `game/datafiles/` (86 Included Files). Manual IDE assembly per `game/rooms/ROOM_SETUP.md` is no longer needed — open the `.yyp` and run.
- "Interpolate colours between pixels" unchecked on every platform; nine-slice enabled on the UI windows (8/3/2 px), select bars, tabs, and menu frames per IMPORT.md. `spr_menu_embers_640_strip24` intentionally not imported (does not fit a default texture page; the documented 320 fallback is used). Ten flat-color placeholder sprites stand in for missing art. Act II enemy art is imported; Chapter 2 rooms/dialogue remain unwired (stub entrances are string data only).
- Requires GameMaker IDE 2023.1+ (project format is 2024.x). Generated and validated by script: 537 JSON files parse, every resource path resolves, sprite frame PNGs match declared dimensions, nine-slice enabled where required, layer names/depths match `scr_map_layer_defs`, scripts and datafiles byte-identical to source, all instances inside room bounds, `rm_title` first in Room Order.
- `game/` remains the human-readable source of truth; READMEs updated.

## 2026-11-14 — Battle upgrade (`feature/battle-upgrade`)
- Branched from `feature/save-and-shops` (PR #10, stacked on #9 → #8). This PR depends on #10 and should be merged after it. Chapter 2 dialogue is **not** wired.
- **Multi-enemy battles:** 1–3 regular enemies, or a boss plus adds (Reeve Calder + 2 Occupation Soldiers). Target cursor (auto-target when one enemy is left, so Chapter 1 fights play as before), per-enemy mini HP bars and A / B / C labels, enemy list window, boss name plate, formations on the left half. Encounter tables accept `group` entries; single entries still work. XP is credited per enemy at its killing hit (owner rule unchanged); gold is summed.
- **New stats:** SPD (turn order by SPD with a small random tiebreak), MP / max MP, MDEF, with level-up growth (PLACEHOLDER).
- **Skills:** data-driven skill table (`scr_skill_data`) and a Skill command. Taren: Rallying Cry, Cleave, Unbowed (passive). Timed buffs / debuffs with icons, elemental weakness (×1.5).
- **Enemy AI:** weighted action lists per enemy. Patrolman Thrust / Brace, Occupation Soldier Slash / Guard, Crossbowman bolt spawned on attack frame 3. Reeve Calder: Guard, Rallying Shout (buffs his soldiers), Heavy Strike, a one-time stance when his soldiers fall, and a yield that replaces death (holds the last frame, ends the battle as a win, sets `flag_reeve_calder_yielded`).
- **Act II enemies:** Crown Patrolman, Crown Crossbowman, Occupation Soldier, Bandit Veteran, Grey Ash Wolf, Reeve Calder with Design's suggested stats; `ch2_millhaven_road` / `ch2_wrenfield` encounter stubs (level 8–10, data only). Sprites copied to `game/sprites/enemies/`, `portraits/reeve_calder/`, and two battle mockups; IMPORT.md "Act II enemies" section.
- Chapter 1 enemies got SPD / MDEF defaults; their damage formula and special-move odds are unchanged.
- **Saves:** schema version 2 stores MP, SPD, MDEF, and skills; v1 saves are migrated on load.
- Placeholders and open questions: `docs/DECISIONS_AND_OPEN_QUESTIONS.md` ("battle upgrade"). Test plan B1–B11. Not compiled or playtested in GameMaker yet.

## 2026-11-14 — Chapter 1 art wiring
- Branched from `feature/zone1-placement-fixes` (PR #8). This PR depends on #8 and should be merged after it. Chapter 2 lines tagged `[PROPOSED]` are **not** wired.
- Added Design's remaining Chapter 1 sprites under `game/sprites/` (`blackguard/`, `enemies/`, `npcs/`, `portraits/`, `title/`, `ui/`, `items/`). Import tables, origins, frame counts, and fps are in `game/sprites/IMPORT.md`. `README_CH1_ART.md` and `STATUS.md` are copies of Design's notes.
- Hooked overworld NPC, enemy, chest, and item sprites at spawn (`scr_ch1_art`) with `asset_get_index` fallbacks. Tomas uses the pallet lying loop / awake pose. Watchtower chests use the iron set. `old_hunter_renn` is mapped even without `npc_id`.
- Dialogue portraits (48×48) for Kael, Tomas, Pell, Renn, and the Fallen Knight. Nine-slice dialogue window on a 320×180 GUI.
- Battle is now an FF1-style 320×180 screen (`scr_ui`): area backgrounds, party on the right with `image_xscale = -1`, enemies on the left, command / HP windows, cursor, bitmap font (`spr_font_main_strip95` via `font_add_sprite_ext`), HP bars, Guard icon, damage digits. New enemy battle strips and visual-only Hunter arrow / Spider web / spiderlings.
- Blackguard canon from `STORY_BIBLE.md` §5.13 / `CHAPTER1_SCRIPT.md` §8: **450 HP**, **250 XP**, **100 Gold**, weak to Holy. ATK 12 / DEF 8 stay placeholders. Phase 2 at 60% HP (270) and Phase 3 at 20% HP (90) play `p1to2` / `p2to3` and swap sprite sets. Final death is `p3_death`; the Phase 1 death strip is debug only. Phase 2/3 attack modifiers are applied in battle (Speed +30% is stored but unused).
- Title screen: new room `rm_title` (must be first in Room Order) and `obj_title`. Parallax at 0 / −0.05 / −0.1 / −0.2, ember loop at 12 fps in Draw GUI, logo, New Game / Continue (disabled without `save1.sav`) / Options / Quit. The 640 ember strip needs its own Texture Group — flagged in IMPORT.md.
- Simple inventory overlay (I / Tab) with 16×16 icons. Not a full menu or save system (Continue stays disabled; no save writer).
- New scripts `scr_ch1_art`, `scr_ui`; new objects `obj_title`, `obj_inventory_menu`. `scr_ui_init()` locks the GUI to 320×180. Placeholder fallbacks so a missing import cannot crash. Test plan A1–A12. Not compiled or playtested in GameMaker yet.

## 2026-11-14 — Greyhaven interiors, Watchtower Basement, and map hookup
- Merged Lore's docs commit `96882ca` (Chapter 2 draft) into this branch. Chapter 2 lines tagged `[PROPOSED]` are **not** wired.
- Added `rm_watchtower_basement` (44×32) and five Greyhaven interiors (`rm_greyhaven_varyn_house`, `_tavern`, `_chapel`, `_blacksmith`, `_general_store`) from Design's dataset. Tileset is now 256×800 (rows 0–37 ids unchanged). Door markers link the overworld to each interior.
- Opening: `player_start` is on the south road (199, 186 / 3192, 2992). `GH_ARRIVAL_01`–`03` play once (`flag_arrived_greyhaven`). Checked: the 16×24 Kael mask does not overlap a solid there. Defeat respawn is Greyhaven `town_square` (199, 176 / 3192, 2832).
- Story scenes moved indoors: pendant in Varyn House (`GH_HOUSE_01`–`05`, actually adds `item_mira_pendant`), Tomas and Pell in the Blacksmith (`GH_TOMAS`), Hob, Sister Ilse, Marda. New square / gate NPCs: Wenna, Dov, Corwin. The North Gate barrier stays up until `flag_pendant_found`.
- Watchtower: guaranteed Hunter trigger is on walkable tile **(33, 33)** (still `obj_story_encounter`, 16×16), banner remains at (41, 25), arena gate opens with `item_watchtower_key`, `BG_INTRO` fires on arena entry then the Blackguard fight starts. Victory sets `blackguard_defeated` and plays `BG_DEFEAT` / `BG_REWARD_01`. `CV_END` stays sealed until then.
- Basement: trap hall (`obj_trap_plate`; sigil stones are the safe path; 10% max-HP damage, min 1, never below 1 HP, 8 px knockback, once per plate), Watchtower Key chest actually grants the key, mural plays `WB_CARVING`, hatch to the terrace sets `flag_wt_upper_unlocked`.
- New objects: `obj_trap_plate`, `obj_story_trigger`. Doors use existing `obj_zone_entrance` with `requires_*` / `sets_flag`. Flags and inventory use the existing `scr_flag_*` / `scr_inventory_*` (thin `scr_map_*` wrappers only). Chests/pickups add items or gold.
- PLACEHOLDER enemy DB entries: `ash_wolf`, `ashen_wretch`, `grave_spider`, `hollow_soldier`. `blackguard` and `ashbound_hunter` were already present (Blackguard remains a placeholder; canon 450 HP / phases are not implemented). Missing battle sprites still draw the rectangle.
- Marda and Pell's forge shop have confirmed talk lines but **no buy UI** (open). FL_TUTORIAL pre/post lines and a save prompt at `CV_END` are also still open.
- Test plan I1–I10 and updates to Z2, Z6, Z8, Z11, W1/W8. Not compiled or playtested in GameMaker yet.


## 2026-11-14 — Placement fixes and Zone 1 Design update
- Fixed two placement bugs found in a static review, and folded in Design's updated Zone 1 dataset, on one branch.
- **Spawn soft-lock:** `player_start` (186, 171) used to sit between solid `mira_pendant` and `tomas_varyn` markers (`obj_interactable` is parented to `obj_solid`), so the 16×24 Kael mask could overlap a solid on frame 1. Design moved Tomas and Pell into the Blacksmith (210/209, 179, `GH_TOMAS`) and placed `item_mira_pendant` at (186, 169) on `mira_bed_rubble` (`GH_HOUSE_03`), two tiles north of the spawn — verified clear of the 16×24 feet mask. `scr_player_unstick()` still runs on `obj_player` Create, after the map places the player, and on Room Start, and nudges to the nearest free pixel if an `obj_solid` overlap remains.
- **Watchtower Hunter trigger:** a 32×32 top-left `spr_interactable_placeholder` for `old_royal_banner` (41, 25) covered walkable tile (41, 24), so `enc_ashbound_hunter_wt` could never fire. Interactables (including the banner) are now fitted to one 16×16 tile, and the trigger is at **(41, 23)**. Tile (41, 24) stays walkable between them. Design's drop did not include the Hunter marker; it is kept in `wt_markers.json` / `scr_map_markers_data`.
- Zone 1 tileset, layers, markers, and renders updated: new tiles `pallet`, `mira_bed_rubble`, `royal_banner`, `carving_crown_sun`, `signpost_weathered`; re-rolled scatter; pendant icon `spr_item_mira_pendant`. Reconciled map helpers were not overwritten (Overhead depth stays -10000; camera follow stays in `scr_map_tilemaps`; `scr_map_create_at_feet` kept).
- New `obj_story_npc` (not solid) plays `FK_01` at the bandit-camp north exit (173, 136) and `FK_02` at the Watchtower basement stairs (20, 29), then sets `flag_fk_seen_1` / `flag_fk_seen_2` and removes itself (walk-off is not animated).
- Confirmed Chapter 1 sign strings are used as data. The Bandit Camp sign's second line (`struck_lines: [1]`) is drawn with a strike-through in `obj_dialogue_box`. Tomas / pendant / banner scenes play `GH_TOMAS`, `GH_HOUSE_03`–`05`, and `WT_BANNER` (flags `flag_met_tomas`, `flag_pendant_found`, `flag_banner_clue`; pendant is a key item).
- Elite Fallen Knights stay limited to the Bandit Camp and Watchtower (plus those areas' `zone01_path` fallback). Farmlands and the Old Road no longer fall back to `zone01_path` and do not roll Fallen Knights. Missing Design enemies (`ash_wolf`, `ashen_wretch`, `grave_spider`, `hollow_soldier`) are not added to the database; listed as open. The Watchtower table includes the existing Ashbound Hunter at weight 1.
- Test plan Z6, Z11–Z13, and W1/W8 updated. Not compiled or playtested in GameMaker yet.


## 2026-11-14 — Character sprites and 16×16 overworld scale
- Added Kael, Bandit, and Fallen Knight art under `game/sprites/` (battle strips plus 16×24 and 32×48 overworld walk/idle sets for Kael and the Bandit). IDE import table is `game/sprites/IMPORT.md`. Source generators (`src/*.py`) are included because they are small. The Zone 1 tileset and maps now live on `main` and are included in this branch after the merge.
- `obj_player` uses the 16×24 Kael sheet: idle/walk by facing, walk at 8 fps, `depth = -y`, no `image_xscale` (left is pre-mirrored). `mask_index` is pinned to idle-down (16×16 standing-tile feet box). `asset_get_index` falls back to the IDE placeholder if the sheet is missing. The 32×48 overworld set is a code fallback only.
- Overworld scale defaults (pending approval): `TILE_SIZE` 16, `PLAYER_MOVE_SPEED` 1 (same tiles-per-second as the old speed of 2 on 32 px tiles), `PLAYER_INTERACT_REACH` 4. Encounter steps are 16 pixels (one tile); the 8–24 step interval is unchanged in tile terms.
- Town respawn after merging Zone 1 is Greyhaven `player_start` (2984, 2752), not the earlier 16 px-grid test point (320, 176).
- Battle: `obj_battle_controller` draws Kael and the enemy with idle loops, plays attack then hurt (or death on a KO) in a new `BATTLE_STATE.ANIMATING` state, and holds the last death frame. Confirm skips the clip. Missing sprites draw the old placeholder rectangles and do not stall the state machine. Party faces left via `xscale = -1`; the Fallen Knight's 64×48 attack origin (32, 47) is honoured so the feet stay planted. Per-enemy XP credit runs in `apply_pending_hit()` at the hit frame (not when the Attack command is chosen).
- Camera follow lives once in `scr_map_tilemaps` (`scr_camera_follow_player`), called from the existing `obj_game_controller` End Step. Overhead tiles stay at depth -10000 so they remain above a player using `depth = -y`.
- Documented in `game/sprites/IMPORT.md`, `game/rooms/ROOM_SETUP.md`, docs/ASSET_INVENTORY.md, docs/DECISIONS_AND_OPEN_QUESTIONS.md; test plan S1–S9 added. Not compiled or playtested in GameMaker yet.

## 2026-11-14 — Old Watchtower Ashbound Hunter scripted encounter
- Added a story-flag system (`global.game.flags`, `scr_flag_get` / `scr_flag_set`) and key-item helpers (`scr_inventory_add` / `scr_inventory_has`).
- Added the Ashbound Hunter to `scr_enemy_database` (placeholder stats: 42 HP, 9 ATK, 5 DEF, 20 XP, 12 gold; Ice weakness stored for the bestiary, not used in combat). The Zone 1 **Blackguard** entry is kept as well (one of each).
- Guaranteed Watchtower fight (`enc_ashbound_hunter_wt` via `obj_story_encounter`): pre-fight `ENC_AH_01`–`02`, battle, then on first victory set `flag_parchment_found`, add `item_ashbound_parchment`, and play `ENC_AH_03`–`05`. If the flag is already set, the fight still happens once and the pickup is skipped.
- The map builder spawns that trigger on walkable tile (41, 24) in `rm_old_watchtower`, immediately in front of `old_royal_banner` (41, 25). Do not also hand-place a second instance on the same tile.
- Rare random Hunter (default 4% of random fights) in areas that opt in (`allow_ashbound_rare`, or table ids `zone01_old_road` / `zone01_bandit_camp` / `zone01_watchtower`, plus the older short ids `old_road` / `bandit_camp` / `watchtower`). Same pre/post lines; a rare victory does not consume the Watchtower trigger.
- Dialogue nodes are keyed by the script's IDs in `scr_dialogue_data` and played through `scr_dialogue_play` / `scr_dialogue_open`.
- Assumptions (open questions): a defeat does not consume the guaranteed trigger; the fight grants regular XP/gold; rare rate and Hunter stats are placeholders pending tuning.
## 2026-11-14 — Per-enemy XP credit for living participants
- Owner decision: when an enemy dies, its XP is credited to each party member who has participated (taken at least one turn) and is not KO'd at that moment. Credit is stored as `pending_xp` and applied at victory (level-up messages unchanged). A defeat grants no XP. Gold stays shared.
- A member KO'd before an enemy dies gets no XP for that enemy, but keeps credit for enemies that died before they fell. A reserve member who swapped in and has taken a turn counts from then on, but gets no credit for earlier kills.
- Replaces the earlier "KO'd members who acted still get XP" behaviour. `XP_REQUIRES_PARTICIPATION` still names the rule. Test plan P5/P10/P12 updated.

## 2026-11-14 — Battle XP requires participation; mid-battle Swap
- Owner decision: a bench/reserve member gets no XP unless they participate for at least one turn in that battle. Victory XP goes only to members who took a turn (Attack, Guard, or Swap).
- A KO'd member who already acted still receives XP; a member KO'd before their first action does not. `RESERVE_EARNS_XP` / `RESERVE_XP_SHARE` were replaced by this rule (`XP_REQUIRES_PARTICIPATION`).
- Mid-battle Swap command (shown only when a reserve member is waiting) costs the acting member's turn; the incoming member acts on later rounds.
- Test plan P5/P10 updated; P11–P12 added.

## 2026-11-14 — Party reserve slot (five-person roster)
- Permanent roster is five: Kael, Lyra, Caelan, Sera, and Taren Holt (Rebel Captain of the Broken Yoke, frontline warrior). Four active battle slots plus one reserve. Default run: only Kael has joined.
- Helpers: `scr_party_list_active`, `scr_party_list_reserve`, `scr_party_swap_active_reserve`, `scr_party_join`. Battle still reads `global.game.party` (the active list) and was not rewritten.
- Defeat check and the defeat XP/gold penalty apply to active members only (assumption). Reserve HP is still restored on defeat. `RESERVE_EARNS_XP` defaults to true with `RESERVE_XP_SHARE` 1.0 (pending owner approval).
- Placeholder stats (pending): Lyra 24/7/1, Caelan 22/8/1, Sera 28/4/4, Taren 36/8/3. Taren's weapon categories include `heavy_sword`; his equipment stub starts with a bastard sword. Skills are placeholders.
- `scr_save_state_collect()` snapshots active and reserve ids (`save_schema_version` 0). The versioned save schema is still roadmap step 5.
- `DEBUG_ADD_FULL_ROSTER` fills all five for testing (Taren in reserve). Test plan P5–P6 updated; P9–P10 added.
## 2026-11-14 — Zone 1 overworld and Old Watchtower maps
- Added the 400×300-tile overworld (`rm_overworld`, 6400×4800) and 60×45 Old Watchtower (`rm_old_watchtower`, 960×720) at 16×16. Tileset `game/tilesets/ts_zone1.png` (256×608); layer data in Included Files `game/datafiles/overworld/*.bin` with 100×75 CSV chunk fallback. Watchtower layers are embedded in `scr_build_old_watchtower`.
- Five Tile layers: Ground, Decoration, Overhead (depth -10000, so it stays above a player using `depth = -y`), Collision (hooks into the existing `obj_player` Collision-layer check), Markers.
- `scr_map_spawn_markers` uses the existing `obj_encounter_trigger`, `obj_encounter_zone` (`table_id` / `enemy_table` API unchanged), and `obj_interactable`. New `obj_zone_entrance` handles room links; stub rooms show a placeholder line.
- Town respawn is Greyhaven `player_start` (2984, 2752, facing down). The builder also spawns `obj_respawn_point` there. `CAMERA_FOLLOW_PLAYER` plus `scr_map_enable_camera(320, 180)` make the large map playable.
- Encounter tables `zone01_farmlands`, `zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower` added beside the existing `zone01_path` fallback. Missing Design enemies (Ash Wolves, Ashen Wretches, Grave Spiders, Hollow Soldiers, Ashbound Hunter) are omitted for now. Placeholder **Blackguard** entry added to `scr_enemy_database` (80/12/8, 50 XP, 30 gold, pending approval) so the arena fight does not fall back to Fallen Knight.
- Placeholder list (story bible still Open): Frostwilds settlement and coastal village names; pendant / Crownveil symbol (banner and door); Tomas Varyn placement and scene; sign text; several chest loots; Watchtower basement, locked terrace stairs, and Crownveil door.
- Documented in `game/rooms/ROOM_SETUP.md` sections 4–6, `game/tilesets/README.md`, `game/datafiles/README.md`; test plan Z1–Z10; decisions updated. Source generators and the 2.6 MB full 1× overworld render are not in the repo. Not compiled or playtested in GameMaker yet.

## 2026-11-14 — Party and progression (roadmap step 4)
- Each party member has `level` and `xp`. Shared gold is unchanged. Placeholder XP curve: `20*(L-1)^2 + 10*(L-1)` (L2=30, L3=100, cap 20). Level-up growth: +4 HP, +1 ATK, +1 DEF. All pending owner approval.
- Victory grants XP to every current member, then shows a level-up message per threshold crossed before returning to the map. HUD shows `Lv`.
- Party supports up to four members (Kael only by default; `DEBUG_ADD_PLACEHOLDER_ALLY` adds a non-canon test ally). Battle command order, cancel, and enemy targeting already follow living members in party order.
- Defeat XP penalty now uses `scr_xp_for_level(level)` as `_level_floor`: 10% of progress toward the next level, never a level-down.
- Empty equipment slots and `global.game.inventory` are stubs for roadmap step 5 menus.
- Documented in docs/DECISIONS_AND_OPEN_QUESTIONS.md; test plan P1–P8 added; B8/B15 updated.

## 2026-11-14 — Random encounters while walking
- Walking in an encounter area uses a randomized steps-until-encounter counter (distance-based). Steps count only when the player actually moves and input is not locked, after `ENCOUNTER_GRACE_STEPS` following battle or room entry.
- Defaults (pending tuning): 32 pixels per step, 8–24 steps between fights, 5 grace steps. Disable with `RANDOM_ENCOUNTERS_ENABLED` or `global.game.random_encounters_enabled`.
- Per-area tables: stretch `obj_encounter_zone` over a wild region (default `zone01_path`, 3:1 Bandit/Fallen Knight) or add a room table in `scr_encounter_tables`. Towns and rooms with no table are safe. `obj_encounter_trigger` remains for fixed boss/story fights.
- Victory still returns to the exact pre-battle spot; defeat (town wake-up plus gold/XP penalty) is unchanged. Random fights are not added to `cleared_encounters`.
- Owner decision recorded in docs/DECISIONS_AND_OPEN_QUESTIONS.md; test plan R1–R8 added. Encounter rates and table weights remain pending tuning.

## 2026-11-14 — Defeat costs gold and XP
- On defeat, the party loses `DEFEAT_GOLD_LOSS_PCT` (default 50%) of current shared gold, floored, and `DEFEAT_XP_LOSS_PCT` (default 10%) of XP progress toward the next level, never going negative or causing a level-down.
- No level system exists yet, so the XP penalty is 10% of total shared XP, floored. Exact percentages are pending tuning.
- The town wake-up dialogue now includes "You lost X gold and Y EXP." (`scr_apply_defeat_penalty` / `scr_town_wake_up_dialogue`).
- Owner decision recorded in docs/DECISIONS_AND_OPEN_QUESTIONS.md; test plan B10/B15 updated. Item loss on defeat remains an open question.

## 2026-11-14 — Defeat wakes the party up in town
- On defeat, party HP is restored, XP/gold already earned are kept, and the player is sent to the town respawn point instead of the pre-battle position.
- Added `TOWN_RESPAWN_ROOM` / `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` in scr_game_constants (defaults: `rm_overworld` at 320, 180). An optional `obj_respawn_point` marker overrides the coordinates if one is placed in that room.
- After arrival, a placeholder wake-up line is shown through the existing dialogue box (`scr_town_wake_up_dialogue`).
- Owner decision recorded in docs/DECISIONS_AND_OPEN_QUESTIONS.md; ROOM_SETUP.md documents how to repoint the respawn when a town room is built; test plan B10 updated and B15 added. Whether defeat should penalize gold, XP, or items remains an open question.

## 2026-11-14 — Exploration and battle prototype (roadmap steps 2–3)
- obj_player: collision now uses obj_solid plus an optional `Collision` tile layer, room-bounds clamp, facing-based interaction, and the global input lock. Movement behaviour unchanged.
- Added obj_game_controller (persistent; global state, frame counter, post-battle return), obj_solid, obj_interactable (placeholder sign), obj_dialogue_box (input-locking dialogue), obj_encounter_trigger, obj_battle_controller.
- Added scripts scr_game_constants, scr_game_state, scr_input, scr_dialogue, scr_encounter, scr_battle_actors; added scr_apply_guard to scr_battle_math.
- Battle prototype: dedicated rm_battle_test room, explicit BATTLE_STATE machine, Attack/Guard, one enemy from scr_enemy_database, rewards granted once, victory/defeat/unknown-enemy return to the saved overworld position.
- Documented IDE setup (game/README.md, game/rooms/ROOM_SETUP.md), test cases E1–E11 and B1–B14 (docs/TEST_PLAN.md), and prototype assumptions (docs/DECISIONS_AND_OPEN_QUESTIONS.md).
- Not compiled or playtested in GameMaker yet.

## 2026-11-14 — Proprietary license
- Added LICENSE: all source code and all game assets are the property of Eastern Goat Forge, all rights reserved.
- Removed LICENSE-PLACEHOLDER.md now that the terms are set.

## 2026-10-27 — Repository rebuild
- Rebuilt core documentation around the confirmed top-down classic JRPG viewpoint.
- Clarified this is not a complete runnable GameMaker project.
- Marked rare encounter/boss details as unapproved concepts.
- Added setup notes, starter-code guidance, and Codex instructions.
- Clarified sample values/code require IDE integration and testing.