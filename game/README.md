# GameMaker Starter Code

This folder contains illustrative GML snippets and setup notes, not a complete GameMaker project. No .yyp or IDE-generated .yy resources are included. Create resources in GameMaker and copy/adapt snippets into matching events/scripts.

Snippets are prototypes, not verified production code. Compile in the selected GameMaker version after adding each resource. Create missing objects/sprites/rooms or adjust code to match the actual project.

**Target syntax:** GameMaker 2023.1 or newer (structs, methods, `function` scripts, default arguments, arrays of objects/tilemaps in `place_meeting`). The final GameMaker version is still an open question.

## File layout
- `game/scripts/<name>.gml` → one **Script** asset named `<name>`; paste the whole file in.
- `game/objects/<obj>/<Event>.gml` → object `<obj>`, event `<Event>` (see the event table below).
- `game/sprites/` → PNG art plus [`sprites/IMPORT.md`](sprites/IMPORT.md). Import in the IDE; do not expect a `.yy` sidecar here.
- `game/tilesets/ts_zone1.png` → Sprite `spr_ts_zone1`, then Tile Set `ts_zone1` (see `game/tilesets/README.md`).
- `game/datafiles/overworld/` → Included Files (see `game/datafiles/README.md`).

## Resources (roadmap steps 2–3: exploration + battle prototype)

### Scripts (Asset Browser → Create → Script; name must match exactly)
| Script | Purpose |
|---|---|
| `scr_game_constants` | Macros (`OVERWORLD_ROOM`, `BATTLE_ROOM`, `TOWN_RESPAWN_ROOM` / `_X` / `_Y`, `DEFEAT_GOLD_LOSS_PCT`, `DEFEAT_XP_LOSS_PCT`, `RANDOM_ENCOUNTERS_ENABLED`, `ENCOUNTER_STEP_PIXELS`, `ENCOUNTER_STEPS_MIN` / `_MAX`, `ENCOUNTER_GRACE_STEPS`, `DEBUG_SHOW_TRIGGERS`, `GUARD_DAMAGE_MULTIPLIER`, `TILE_SIZE`, `PLAYER_MOVE_SPEED`, `PLAYER_INTERACT_REACH`, `PLAYER_WALK_FPS`, `BATTLE_ANIM_FPS`, `BATTLE_IDLE_FPS`, `BATTLE_SPRITE_SCALE`, `CAMERA_FOLLOW_PLAYER`) and `enum BATTLE_STATE` (includes `ANIMATING`) |
| `scr_game_state` | `global.game` struct, `scr_input_locked()`, `scr_input_block()` |
| `scr_sprites` | `asset_get_index` lookups, overworld idle/walk, battle visual clips |
| `scr_input` | Prototype key mapping: confirm, cancel, menu up/down |
| `scr_dialogue` | `scr_dialogue_open(lines, speaker)` |
| `scr_dialogue_data` | Chapter 1 nodes by ID (`ENC_AH_01` …) and `scr_dialogue_play()` |
| `scr_flags` | `scr_flag_get` / `scr_flag_set` / `scr_flag_clear` (`global.game.flags`) |
| `scr_inventory` | `scr_inventory_has` / `scr_inventory_add` (key items unique) |
| `scr_story` | Ashbound Hunter pre/post-fight flow (`scr_ashbound_hunter_start`) |
| `scr_encounter` | `scr_encounter_start()`, `scr_battle_finish()`, `scr_apply_defeat_penalty()`, `scr_apply_town_respawn()`, `scr_town_wake_up_dialogue()`, `scr_random_encounter_tick()` (overworld ↔ battle hand-off and walking encounters) |
| `scr_encounter_tables` | Named / per-room random encounter tables (`zone01_path`, `zone01_farmlands`, `zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`, plus short-id aliases `old_road` / `bandit_camp` / `watchtower`) |
| `scr_battle_actors` | Actor structs (level, xp, equipment stubs), party of up to four, party helpers |
| `scr_progression` | XP curve (`scr_xp_for_level`), `scr_party_grant_xp()`, level-up growth |
| `scr_battle_math` | Damage, HP clamp, Guard reduction (existing file, `scr_apply_guard` added) |
| `scr_enemy_database` | Bandit, Fallen Knight, Ashbound Hunter, and placeholder **Blackguard** (Zone 1 boss; stats pending) |
| `scr_map_tilemaps` | Tile layer setup, `.bin`/CSV loaders, collision hook, marker spawner, camera helpers |
| `scr_build_overworld` | `scr_build_overworld()`, `scr_overworld_load_chunk()` — fills `rm_overworld` from Included Files |
| `scr_build_old_watchtower` | `scr_build_old_watchtower()` plus embedded 60×45 layer data |
| `scr_map_markers_data` | `scr_overworld_markers()`, `scr_old_watchtower_markers()` |

### Objects
| Object | Sprite | Flags | Events (file → IDE event) |
|---|---|---|---|
| `obj_game_controller` | none | **Persistent** ✔, Visible off | `Create.gml` → Create; `Begin_Step.gml` → Step ▸ Begin Step; `End_Step.gml` → Step ▸ End Step; `Room_Start.gml` → Other ▸ Room Start |
| `obj_player` | `spr_kael_ow16_idle_down` (fallback `spr_player_placeholder`) | — | `Create.gml` → Create; `Step.gml` → Step ▸ Step |
| `obj_solid` | `spr_solid_placeholder` | — | none (see `obj_solid/README.md`) |
| `obj_interactable` | `spr_interactable_placeholder` | **Parent: `obj_solid`** | `Create.gml` → Create |
| `obj_dialogue_box` | none | — | `Create.gml` → Create; `Step.gml` → Step ▸ Step; `Draw_GUI.gml` → Draw ▸ Draw GUI; `Clean_Up.gml` → Clean Up |
| `obj_encounter_trigger` | `spr_encounter_trigger_placeholder` | No parent (must **not** be `obj_solid`) | `Create.gml` → Create; `Room_Start.gml` → Other ▸ Room Start; `Step.gml` → Step ▸ Step |
| `obj_battle_controller` | none | — | `Create.gml` → Create; `Step.gml` → Step ▸ Step; `Draw_GUI.gml` → Draw ▸ Draw GUI |
| `obj_respawn_point` | optional `spr_respawn_point_placeholder` | — | `Create.gml` → Create (see `obj_respawn_point/README.md`) |
| `obj_encounter_zone` | `spr_encounter_zone_placeholder` | No parent (must **not** be `obj_solid`) | `Create.gml` → Create (see `obj_encounter_zone/README.md`) |
| `obj_story_encounter` | `spr_story_encounter_placeholder` | No parent (must **not** be `obj_solid`) | `Create.gml` → Create; `Room_Start.gml` → Other ▸ Room Start; `Step.gml` → Step (see `obj_story_encounter/README.md`) |
| `obj_zone_entrance` | 16×16 placeholder (e.g. `spr_encounter_trigger_placeholder`) | No parent (must **not** be `obj_solid`) | `Create.gml` → Create; `Step.gml` → Step ▸ Step (see `obj_zone_entrance/README.md`) |
| `obj_story_npc` | `spr_story_npc_placeholder` (or interactable placeholder) | No parent (must **not** be `obj_solid`) | `Create.gml` → Create; `Room_Start.gml` → Other ▸ Room Start; `Step.gml` → Step (see `obj_story_npc/README.md`) |
| `obj_story_trigger` | `spr_story_trigger_placeholder` (or story-encounter placeholder) | No parent (must **not** be `obj_solid`) | `Create.gml` → Create; `Room_Start.gml` → Other ▸ Room Start; `Step.gml` → Step (see `obj_story_trigger/README.md`) |
| `obj_trap_plate` | `spr_trap_plate_placeholder` (or encounter-trigger placeholder) | No parent (must **not** be `obj_solid`) | `Create.gml` → Create; `Step.gml` → Step (see `obj_trap_plate/README.md`) |

`obj_dialogue_box` and `obj_battle_controller` draw only in Draw GUI. Adding a Draw GUI event does not disable default sprite drawing, but neither object has a sprite, so nothing else is drawn.

### Rooms
- `rm_overworld` (must be **first** in the Room Order) — 6400×4800 Zone 1 overworld; see `game/rooms/ROOM_SETUP.md`.
- `rm_old_watchtower` — 960×720 Watchtower grounds and Blackguard arena.
- `rm_watchtower_basement` — 704×512 Architect carvings, trap hall, spider nest.
- `rm_greyhaven_varyn_house`, `rm_greyhaven_tavern`, `rm_greyhaven_chapel`, `rm_greyhaven_blacksmith`, `rm_greyhaven_general_store` — Greyhaven interiors.
- `rm_battle_test` — dedicated battle room.

## How the pieces fit
1. `obj_game_controller` (persistent) creates `global.game` and counts frames.
2. `obj_player` moves only when `scr_input_locked()` is false (no dialogue, battle, or transition, and not the frame right after one closes).
3. Facing an `obj_interactable` and pressing confirm calls its `interact()` method → `scr_dialogue_open()` → `obj_dialogue_box`. Closing the box blocks overworld input for one extra frame so the same key press cannot reopen it.
4. Walking onto an armed `obj_encounter_trigger` calls `scr_encounter_start()`: saves the return point, sets `battle_active`, goes to `rm_battle_test`.
5. `obj_battle_controller` runs the `BATTLE_STATE` machine: INTRO → ROUND_START → COMMAND_SELECT → PLAYER_ACTION → (ANIMATING) → ENEMY_TURN → (ANIMATING) → (ROUND_START | VICTORY | DEFEAT) → EXIT. Attack clips play in `ANIMATING` (hit frame applies damage, then hurt or death); Guard has no clip. Living members choose and act in party order; the enemy targets a random living member. Victory may go through `LEVEL_UP` messages before EXIT. Every message waits for a confirm press. Pressing Z during `ANIMATING` skips to the end of the clip. Missing sprites draw as rectangles and do not block the state machine.
6. EXIT calls `scr_battle_finish()` once: remembers a victory by `encounter_id`, clears `battle_active`, sets `transition_active`. Victory and error return to the saved room; defeat restores party HP, deducts 50% of current gold and 10% of each member's XP progress toward the next level (never below the current level's floor), and goes to `TOWN_RESPAWN_ROOM`. `obj_game_controller`'s Room Start then either restores the pre-battle position/facing, or (on defeat) places the player at `obj_respawn_point` / `TOWN_RESPAWN_X,Y` and opens the wake-up dialogue, including the amounts lost.
7. A won trigger destroys itself on Room Start. A lost encounter is not cleared, so walking back onto that trigger starts the fight again.
8. Random encounters: while moving inside an `obj_encounter_zone` (or a room listed in `scr_get_room_encounter_table`), actual movement accumulates toward steps of `ENCOUNTER_STEP_PIXELS`. After `ENCOUNTER_GRACE_STEPS` following room entry or battle, a randomized counter in `[ENCOUNTER_STEPS_MIN, ENCOUNTER_STEPS_MAX]` counts down and starts a fight from the area's weighted table. Towns and rooms with no table are safe. Disable with `RANDOM_ENCOUNTERS_ENABLED` or `global.game.random_encounters_enabled`. Victory still returns to the exact spot; random fights are not stored in `cleared_encounters`.
9. The guaranteed Old Watchtower Ashbound Hunter fight is an `obj_story_encounter` (`enc_ashbound_hunter_wt`). It plays `ENC_AH_01`–`02`, starts the battle, and on the first victory sets `flag_parchment_found`, adds `item_ashbound_parchment`, and plays `ENC_AH_03`–`05`. If the parchment was already found in a rare fight, the guaranteed fight still happens once and the pickup lines are skipped. Rare 4% Hunter rolls can be enabled on a zone (`allow_ashbound_rare` or table ids `zone01_old_road` / `zone01_bandit_camp` / `zone01_watchtower`; older short ids still work).
10. The permanent roster is five (Kael, Lyra, Caelan, Sera, Taren Holt). `global.game.party` is the active battle party (max 4); `global.game.reserve` is the one benched slot. Battle, the defeat check, and the defeat XP penalty use the active party only. When an enemy dies, its XP is credited to members who have already taken a turn and are still living; banked XP is applied at victory, and a defeat grants none. A reserve member must swap in and act before a kill to earn that enemy's XP. Gold stays shared. Mid-battle Swap costs the outgoing member's turn. Default run: Kael only has joined. `DEBUG_ADD_FULL_ROSTER` fills all five for testing (Taren in reserve).

## Default controls (prototype; final mapping is an open question)
- Move: arrow keys (diagonal normalized, as before).
- Confirm / interact / advance: **Z**, Enter, or Space.
- Cancel (battle: undo previous party member's command): **X** or Backspace.
- Battle menu: Up/Down.
