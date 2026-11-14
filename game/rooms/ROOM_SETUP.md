# Room Setup

Do not fabricate .yy/.yyp metadata. Let GameMaker create resources. This document does not prove the project compiles.

Room size, tile size, and resolution are still undecided in a final-design sense, but the Zone 1 maps are **16×16** tile maps: `rm_overworld` is **6400×4800** (400×300), `rm_old_watchtower` is **960×720** (60×45), `rm_watchtower_basement` is **704×512** (44×32), and the five Greyhaven interiors are 320×240 or similar (see the table in section 6a). A camera is required.

The overworld player uses **16×24** Kael sprites on that 16×16 grid (`depth = -y`). See docs/DECISIONS_AND_OPEN_QUESTIONS.md.

**Sprite import:** follow [`game/sprites/IMPORT.md`](../sprites/IMPORT.md) for every character PNG (asset name, frames, origin, mask, fps). Code uses `asset_get_index` and still compiles if a sprite is missing.

## 1. Project
1. Create a new GameMaker project (GML, GameMaker 2023.1+).
2. Create every Script listed in `game/README.md` first, pasting each `game/scripts/*.gml` file into the script of the same name. Scripts reference objects and rooms by name, so the project will not compile until steps 2–4 are done too.

## 2. Sprites

### 2a. Character art (required for the new look; optional for a compile test)
Import the PNGs in `game/sprites/` using the table in [`game/sprites/IMPORT.md`](../sprites/IMPORT.md). At minimum, import Kael's 16×24 overworld set and the battle idle/attack/hurt/death strips for `spr_hero_*`, `spr_bandit_*`, and `spr_fallen_knight_*`. Keep each asset name identical to the filename (including `_stripN`).

Assign `spr_kael_ow16_idle_down` to `obj_player`. Set the manual feet mask (left 0, top 8, right 15, bottom 23) and origin (8, 23) on every Kael 16×24 sprite. The object code also pins `mask_index` to the idle-down sprite.

### 2b. Placeholder room sprites (Asset Browser → Create → Sprite; draw a flat colour)
Use these for walls, the sign, triggers, and zones. Existing 32×32 placeholders still work (collision uses `bbox_*`), but 16×16 matches the new grid.

| Sprite | Size | Origin | Collision mask | Notes |
|---|---|---|---|---|
| `spr_player_placeholder` | 16×24 | (8, 23) Bottom Centre | Rectangle, manual, 0, 8, 15, 23 (standing tile / feet) | Only if Kael's 16×24 set is not imported yet |
| `spr_solid_placeholder` | 16×16 | Top Left | Rectangle, full image | Dark grey |
| `spr_interactable_placeholder` | 16×16 | Top Left | Rectangle, full image | e.g. brown "sign" |
| `spr_encounter_trigger_placeholder` | 16×16 | Top Left | Rectangle, full image | Semi-transparent red; can be stretched in the room |
| `spr_encounter_zone_placeholder` | 16×16 | Top Left | Rectangle, full image | Semi-transparent yellow; stretch over the wild area. Required so the zone mask matches the rectangle. |
| `spr_respawn_point_placeholder` | 16×16 | Top Left | Rectangle, full image | Optional layout marker |
| `spr_story_encounter_placeholder` | 16×16 preferred (a larger 32×32 placeholder is scaled to one tile by the map spawner) | Top Left | Rectangle, full image | Semi-transparent purple. Required so the story-trigger mask matches the tile. |

Record imported assets in docs/ASSET_INVENTORY.md.

## 3. Objects
Create each object in the table in `game/README.md` with the listed sprite, flags, and events, then paste the matching `.gml` file into each event:
- **obj_game_controller:** no sprite, tick **Persistent**, untick Visible. Events: Create, Step ▸ Begin Step, Step ▸ End Step, Other ▸ Room Start.
- **obj_player:** sprite `spr_kael_ow16_idle_down` (or `spr_player_placeholder` if the sheet is not imported yet). Events: Create, Step. The Step event also picks idle/walk by facing, plays the walk at 8 fps, and sets `depth = -y`.
- **obj_solid:** sprite `spr_solid_placeholder`. No events.
- **obj_interactable:** sprite `spr_interactable_placeholder` (16×16 Top Left preferred; a larger placeholder is scaled to one tile by the map spawner), **Parent = obj_solid** (blocks movement). Event: Create. The spawner also sets `script_id` / `struck_lines` / item fields from map data.
- **obj_dialogue_box:** no sprite. Events: Create, Step, Draw ▸ Draw GUI, Clean Up.
- **obj_encounter_trigger:** sprite `spr_encounter_trigger_placeholder`, no parent. Events: Create, Other ▸ Room Start, Step.
- **obj_battle_controller:** no sprite. Events: Create, Step, Draw ▸ Draw GUI.
- **obj_respawn_point:** optional sprite `spr_respawn_point_placeholder` (any small colour; only needed so you can see it while laying out the room). Event: Create. No parent, not solid.
- **obj_encounter_zone:** sprite `spr_encounter_zone_placeholder`. Event: Create. No parent, not solid. The overworld builder stretches these from map markers; you do not have to place them by hand.
- **obj_story_encounter:** sprite `spr_story_encounter_placeholder` (16×16 preferred; a larger placeholder is scaled to one tile). Events: Create, Other ▸ Room Start, Step. No parent, not solid. The Watchtower builder spawns the guaranteed Hunter trigger at **(33, 33)** (walkable, on the way to the banner); do not also hand-place one on the same tile.
- **obj_story_npc:** sprite `spr_story_npc_placeholder` (or `spr_interactable_placeholder` if you have not made one). Events: Create, Other ▸ Room Start, Step. **No parent, not solid.** The map builder spawns the Fallen Knight beats (`FK_01`, `FK_02`); do not also hand-place them.
- **obj_story_trigger:** sprite `spr_story_trigger_placeholder` or `spr_story_encounter_placeholder`. Events: Create, Other ▸ Room Start, Step. **No parent, not solid.** Used for `BG_INTRO` on arena entry. See `game/objects/obj_story_trigger/README.md`.
- **obj_trap_plate:** sprite `spr_trap_plate_placeholder` or `spr_encounter_trigger_placeholder`. Events: Create, Step. **No parent, not solid.** Basement trap hall + two Watchtower grounds plates. See `game/objects/obj_trap_plate/README.md`.
- **obj_zone_entrance:** sprite any 16×16 (e.g. `spr_encounter_trigger_placeholder`). Events: Create, Step. No parent, not solid. Honours `requires_flag` / `requires_item` / `sets_flag`. See `game/objects/obj_zone_entrance/README.md`.

## 4. Tileset and Included Files (do this before the rooms)
1. **Tileset:** follow `game/tilesets/README.md`. You need a Sprite `spr_ts_zone1` (import `game/tilesets/ts_zone1.png`, do not split it) and a Tile Set named exactly **`ts_zone1`**, tile size 16×16, offset 0, separation 0.
2. **Included Files:** copy `game/datafiles/overworld/` into the project's Included Files so `overworld/ow_ground.bin` (and the other four `.bin` layers, plus `overworld/chunks/` as a fallback) can be found at runtime. See `game/datafiles/README.md`.

## 5. rm_overworld (6400×4800, 400×300 tiles)
1. Create (or resize) room `rm_overworld` to width **6400**, height **4800**. Set it **first** in the Room Order. Leave Persistent **off**.
2. Add Tile layers, all using tileset `ts_zone1`:

   | Layer | Depth | Visible | Purpose |
   |---|---|---|---|
   | `Ground` | 400 | yes | terrain |
   | `Decoration` | 300 | yes | trees, walls, buildings (below the player) |
   | `Overhead` | **-10000** | yes | canopy / arches, always above the player (including when `depth = -y`) |
   | `Collision` | 500 | hidden | tile 1 = solid; `obj_player` already looks up this exact name in Create |
   | `Markers` | 600 | hidden | debug icons; optional |

   Keep the **Instances** layer at depth 0. Create `Collision` in the editor (not only from code) so it exists when `obj_player` is created.
3. Instances layer: place **1 × `obj_game_controller`** and **1 × `obj_player`**. Do **not** hand-place a border of `obj_solid`, the test sign, the test trigger, the test zone, or a respawn marker — `scr_build_overworld()` fills the tiles and spawns signs, chests, NPCs, doors, barriers, encounter triggers, encounter zones, and an `obj_respawn_point` at Greyhaven `town_square` (199, 176).
4. Room Creation Code: `scr_build_overworld();`
5. **Camera:** enable Views, enable Viewport 0, camera / view size **320×180** (display the window at 2× to 640×360), or 256×240 for a closer FF1 feel. The build script also calls `scr_map_enable_camera(320, 180)` if no camera exists yet. `obj_game_controller` End Step follows the player and clamps to the room.
6. Defeat respawn: `TOWN_RESPAWN_X/Y` are **3192, 2832** (Greyhaven `town_square`, tile 199, 176). The builder drops `obj_respawn_point` there (facing down), not on the south-road `player_start`. Greyhaven itself has no encounter zone (safe).
7. Opening: `player_start` is on the south road just outside the palisade **(199, 186 / 3192, 2992)**, facing north. Checked against the 16×24 Kael mask: no nearby `obj_solid` overlap. `GH_ARRIVAL_01`–`03` play once and set `flag_arrived_greyhaven`. `scr_player_unstick()` still runs on Create, after the map places the player, and on Room Start.
8. Building doors (`door_varyn_house`, `door_rusted_boar_tavern`, `door_greyhaven_chapel`, `door_blacksmith`, `door_general_store`) lead to the matching interior's `from_overworld`; each interior's `to_overworld` returns to that door. The North Gate barrier stays up until `flag_pendant_found` (the pendant is now inside Varyn House). Wenna, Dov and Corwin stand in the square / at the gate.

## 6. rm_old_watchtower (960×720, 60×45 tiles)
1. Create room `rm_old_watchtower`, size **960×720**. Leave Persistent off. Use the **same five Tile layers** and tileset `ts_zone1`, plus Instances at depth 0. Enable Viewport 0 the same way as the overworld (the build script will also enable a 320×180 camera if needed).
2. Place **1 × `obj_player`**. Do **not** place a second `obj_game_controller` (the existing one is persistent). Do not hand-place markers; the script spawns them.
3. Room Creation Code: `scr_build_old_watchtower();` (map data is embedded in that script; no Included Files needed).
4. The south exit returns to `rm_overworld` at the `old_watchtower` entrance marker. The basement stairs (`watchtower_basement_stairs`) go to `rm_watchtower_basement` at `from_watchtower`. The terrace hatch (`from_basement`) is the return from the basement upper exit (which also sets `flag_wt_upper_unlocked`, removing the `locked_terrace_stairs` barrier so those stairs work as a shortcut). The arena gate stays shut until `item_watchtower_key` is in the inventory (WT_DOOR_LOCKED). Walking into the arena fires `BG_INTRO` once (`obj_story_trigger`), then starts the Blackguard fight (`zone01_boss_blackguard`, PLACEHOLDER stats). After victory, `blackguard_defeated` is set and `BG_DEFEAT` / `BG_REWARD_01` play (Longsword + Crownveil Fragment). The Crownveil door (`CV_END`) is interactable and stays sealed until that flag is set.
5. The guaranteed Ashbound Hunter fight (`enc_ashbound_hunter_wt`) is spawned on walkable tile **(33, 33)**, on the way to `old_royal_banner` (41, 25). Design's marker is type `encounter`; the spawner still uses `obj_story_encounter` so the ENC_AH parchment flow is kept. Interactables (including the banner) are fitted to one 16×16 tile so a 32×32 placeholder cannot cover a neighbour. Confirm the trigger tile is walkable (it is, on the current collision layer). Do not also hand-place a second `obj_story_encounter` on that tile.


## 6a. rm_watchtower_basement (704×512, 44×32 tiles)
1. Create room `rm_watchtower_basement`, size **704×512**. Leave Persistent off. Same five Tile layers and tileset `ts_zone1`, Instances at depth 0, Viewport 0 as above. Place **1 × `obj_player`**. Do not place a second `obj_game_controller`.
2. Room Creation Code: `scr_build_watchtower_basement();` (embedded data; CSV dump in `game/maps/watchtower_basement_csv/`).
3. Route: `from_watchtower` (7, 4) ← stairs from the tower. `stairs_to_watchtower` (7, 3) goes back up. The trap hall uses `obj_trap_plate` on `plate_tiles` only; sigil stones (`safe_tiles`) are the safe path. A plate plays `WT_TRAP_01`, deals 10% of living active max HP (min 1, never below 1 HP), and knocks the player back 8 px; each plate fires once per session.
4. The spider nest chest `basement_chest_key` grants `item_watchtower_key` (`WT_KEY_01`) into the inventory. The carving hall mural plays `WB_CARVING_01`–`05` and sets `flag_carvings_seen`. `stairs_to_upper_level` (37, 13) returns to `rm_old_watchtower` at `from_basement` and sets `flag_wt_upper_unlocked`.

## 6b. Greyhaven interiors
Create each room below with the **same five Tile layers** (`ts_zone1`), Instances at depth 0, Viewport 0, **1 × `obj_player`**, no second controller. Creation Code is the matching `scr_build_greyhaven_<building>();`. Data is embedded; CSV / JSON live under `game/maps/interiors/`. Interiors are safe (no encounter zones). If the camera is larger than a room, it clamps (void tiles are opaque black).

| Room | Size (px) | Tiles | Creation Code | Notes |
|---|---|---|---|---|
| `rm_greyhaven_varyn_house` | 320×240 | 20×15 | `scr_build_greyhaven_varyn_house();` | `GH_HOUSE_01`–`02` debris; `mira_pendant` plays `GH_HOUSE_03`–`05`, adds `item_mira_pendant`, sets `flag_pendant_found` (unlocks the North Gate) |
| `rm_greyhaven_tavern` | 384×256 | 24×16 | `scr_build_greyhaven_tavern();` | Hob (`GH_TAVERN_01`–`04`). The cellar hatch is closed and inspectable. |
| `rm_greyhaven_chapel` | 320×288 | 20×18 | `scr_build_greyhaven_chapel();` | Sister Ilse (`GH_CHAPEL_01`–`03`) |
| `rm_greyhaven_blacksmith` | 320×240 | 20×15 | `scr_build_greyhaven_blacksmith();` | Tomas and Pell (`GH_TOMAS`). After the pendant, Pell's repeat line is `GH_SMITH_01_B`. A buy UI for the forge shop is not implemented (open). |
| `rm_greyhaven_general_store` | 320×240 | 20×15 | `scr_build_greyhaven_general_store();` | Marda (`GH_STORE_01`–`03`). Shop stock would be Minor Potion and Antidote; buy UI is not implemented (open). |

Paste every new `scr_build_*.gml` and `scr_map_markers_data.gml` as Script assets. Re-import `ts_zone1.png` (now **256×800**; ids in rows 0–37 are unchanged; rows 38–49 are interior/dungeon tiles).

## 7. rm_battle_test (placeholder 640×360)
1. Create room `rm_battle_test`. Leave Persistent off.
2. Place 1 × `obj_battle_controller`. Do **not** place `obj_player` or `obj_game_controller` here (the controller arrives from rm_overworld because it is persistent).
3. Running this room alone (Room Order first) works for UI testing: it fights a Bandit, but returning needs `rm_overworld`.

## 8. Compile and run
Run (F5). Expected: the overworld loads (watch the compile / first-room time; 120k tiles × 5 layers), Kael uses the 16×24 idle/walk sprites (or the placeholder if they are not imported) and is y-sorted with `depth = -y`, the camera follows him and stops at the room edges, he starts on the south road outside Greyhaven (199, 186) and `GH_ARRIVAL` plays once, collision tiles block movement, tree tops on the Overhead layer (depth -10000) draw above him, building doors enter the five interiors, the North Gate is barred until the pendant is found in Varyn House, walking a farmlands / Old Road / bandit-camp zone can start a random fight, signs use the confirmed Chapter 1 wording, Tomas and Pell are inside the Blacksmith (`GH_TOMAS`), Wenna, Dov and Corwin can be spoken to, the Fallen Knight story NPC can be met on the camp path, the Watchtower Hunter trigger at (33, 33) is walkable, the basement trap hall / key chest / mural work, Renn is still a placeholder, a Bandit or new PLACEHOLDER enemy battle plays clips or rectangles, victory returns to the exact overworld spot, and defeat wakes the party up at Greyhaven `town_square` (3192, 2832) with the gold/XP penalty dialogue. Then run docs/TEST_PLAN.md, including the Sprites and Zone 1 map cases.

If the Included Files are missing, the debug log will print `scr_build_overworld: missing overworld/chunks/...` and the ground will be empty. If `ts_zone1` is not a Tile Set asset, tile layers will be blank or the script will fail.

## 9. Random encounter areas
Rooms are safe until you opt in:
1. **Zone (used by the overworld builder):** `scr_map_spawn_markers` creates stretched `obj_encounter_zone` instances from map markers (`zone01_farmlands`, `zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`, `zone01_basement_nest`, `zone01_basement_hall`), using the existing `table_id` / `enemy_table` API. Greyhaven has no zone. You can still hand-place extra zones the same way as before. See `game/objects/obj_encounter_zone/README.md`.
2. **Whole room:** in `scr_get_room_encounter_table()` (in `scr_encounter_tables`), return `scr_get_encounter_table("zone01_path")` (or a custom table) for that room. Do not do this for `TOWN_RESPAWN_ROOM` or other safe rooms. A zone at the player's position overrides the room table.
3. Keep `obj_encounter_trigger` for simple fixed fights, and `obj_story_encounter` for the guaranteed Watchtower Ashbound Hunter (and later scripted beats). Standing on either does not also roll a random encounter.
4. To disable random encounters while testing: set `#macro RANDOM_ENCOUNTERS_ENABLED false` and recompile, or in the debugger set `global.game.random_encounters_enabled = false`.
5. Default rates (pending tuning): 16 pixels = 1 step (one tile), a new fight after 8–24 steps in an area, 5 grace steps after room entry or after returning from battle.

## 10. Old Watchtower Ashbound Hunter (`enc_ashbound_hunter_wt`)
1. Create `obj_story_encounter` and `spr_story_encounter_placeholder` as in the tables above. Paste the Create, Room Start, and Step snippets. A 16×16 sprite matches the tile grid; a larger placeholder is scaled to one tile when spawned from the map.
2. You do **not** have to place the instance by hand in `rm_old_watchtower`. `scr_build_old_watchtower` / `scr_map_spawn_markers` spawn one on walkable tile (33, 33), on the way to `old_royal_banner` (41, 25). Leave `encounter_id` as `enc_ashbound_hunter_wt`. Do not also hand-place a second trigger on that tile.
3. To test the rare random source, walk the Old Road, bandit-camp, or Watchtower encounter zones (`table_id` `zone01_old_road` / `zone01_bandit_camp` / `zone01_watchtower`; the older short ids still work). You can also set `allow_ashbound_rare = true` on a zone. In the debugger, `global.game.ashbound_rare_chance = 1` makes the next random fight in that zone the Hunter. Do not enable this on `zone01_farmlands` or the `zone01_path` fallback unless you are specifically testing the rare roll.

## 11. When the town room is built
1. Create the town room (e.g. `rm_town`). Leave Persistent off. Place `obj_player` in that room (required; the player object is not persistent). Do **not** place a second `obj_game_controller` (the existing one is persistent and will arrive with the party).
2. In `game/scripts/scr_game_constants.gml`, change `#macro TOWN_RESPAWN_ROOM` to the new room asset (e.g. `rm_town`).
3. Place one `obj_respawn_point` in open space (inn, shrine, etc.), or set `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` (currently Greyhaven town_square 3192, 2832) to a known open position in that room instead.
4. Re-run the defeat cases in docs/TEST_PLAN.md.

## Why a battle room instead of an overlay?
Chosen for this prototype (open question in DECISIONS_AND_OPEN_QUESTIONS.md): a separate room keeps overworld objects frozen, prevents overworld input during battle by construction, and makes the "save position → return" step explicit. Cost: the overworld room is rebuilt on return, so any overworld state that must survive a battle has to live in `global.game` (as `cleared_encounters` does).
