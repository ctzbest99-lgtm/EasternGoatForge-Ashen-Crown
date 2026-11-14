# Room Setup

Do not fabricate .yy/.yyp metadata. Let GameMaker create resources. This document does not prove the project compiles.

Room size, tile size, and resolution are still undecided in a final-design sense, but the Zone 1 overworld is built as a **16×16** tile map: `rm_overworld` is **6400×4800** (400×300 tiles) and `rm_old_watchtower` is **960×720** (60×45 tiles). A camera is required.

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
- **obj_interactable:** sprite `spr_interactable_placeholder`, **Parent = obj_solid** (blocks movement). Event: Create.
- **obj_dialogue_box:** no sprite. Events: Create, Step, Draw ▸ Draw GUI, Clean Up.
- **obj_encounter_trigger:** sprite `spr_encounter_trigger_placeholder`, no parent. Events: Create, Other ▸ Room Start, Step.
- **obj_battle_controller:** no sprite. Events: Create, Step, Draw ▸ Draw GUI.
- **obj_respawn_point:** optional sprite `spr_respawn_point_placeholder` (any small colour; only needed so you can see it while laying out the room). Event: Create. No parent, not solid.
- **obj_encounter_zone:** sprite `spr_encounter_zone_placeholder`. Event: Create. No parent, not solid. The overworld builder stretches these from map markers; you do not have to place them by hand.
- **obj_story_encounter:** sprite `spr_story_encounter_placeholder` (16×16 preferred; a larger placeholder is scaled to one tile). Events: Create, Other ▸ Room Start, Step. No parent, not solid. The Watchtower builder spawns the guaranteed Hunter trigger; do not also hand-place one on the same tile.
- **obj_zone_entrance:** sprite any 16×16 (e.g. `spr_encounter_trigger_placeholder`). Events: Create, Step. No parent, not solid. See `game/objects/obj_zone_entrance/README.md`.

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
3. Instances layer: place **1 × `obj_game_controller`** and **1 × `obj_player`**. Do **not** hand-place a border of `obj_solid`, the test sign, the test trigger, the test zone, or a respawn marker — `scr_build_overworld()` fills the tiles and spawns signs, chests, NPCs, entrances, encounter triggers, encounter zones, and an `obj_respawn_point` at Greyhaven `player_start`.
4. Room Creation Code: `scr_build_overworld();`
5. **Camera:** enable Views, enable Viewport 0, camera / view size **320×180** (display the window at 2× to 640×360), or 256×240 for a closer FF1 feel. The build script also calls `scr_map_enable_camera(320, 180)` if no camera exists yet. `obj_game_controller` End Step follows the player and clamps to the room.
6. Defeat respawn: `TOWN_RESPAWN_X/Y` are **2984, 2752** (Varyn House / `player_start`). The builder also drops `obj_respawn_point` there (facing down). Greyhaven has no encounter zone (safe).

## 6. rm_old_watchtower (960×720, 60×45 tiles)
1. Create room `rm_old_watchtower`, size **960×720**. Leave Persistent off. Use the **same five Tile layers** and tileset `ts_zone1`, plus Instances at depth 0. Enable Viewport 0 the same way as the overworld (the build script will also enable a 320×180 camera if needed).
2. Place **1 × `obj_player`**. Do **not** place a second `obj_game_controller` (the existing one is persistent). Do not hand-place markers; the script spawns them.
3. Room Creation Code: `scr_build_old_watchtower();` (map data is embedded in that script; no Included Files needed).
4. The south exit returns to `rm_overworld` at the `old_watchtower` entrance marker. The basement stairs (`rm_watchtower_basement`) and the Crownveil door are stubs (placeholder dialogue). The Blackguard boss uses `enemy_id = "blackguard"` (placeholder stats in `scr_enemy_database`).
5. The guaranteed Ashbound Hunter fight (`enc_ashbound_hunter_wt`) is spawned by `scr_build_old_watchtower` as a `story_encounter` marker on walkable tile **(41, 24)**, immediately in front of `old_royal_banner` (41, 25). Do not also hand-place a second `obj_story_encounter` on that tile.

## 7. rm_battle_test (placeholder 640×360)
1. Create room `rm_battle_test`. Leave Persistent off.
2. Place 1 × `obj_battle_controller`. Do **not** place `obj_player` or `obj_game_controller` here (the controller arrives from rm_overworld because it is persistent).
3. Running this room alone (Room Order first) works for UI testing: it fights a Bandit, but returning needs `rm_overworld`.

## 8. Compile and run
Run (F5). Expected: the overworld loads (watch the compile / first-room time; 120k tiles × 5 layers), Kael uses the 16×24 idle/walk sprites (or the placeholder if they are not imported) and is y-sorted with `depth = -y`, the camera follows him and stops at the room edges, he starts at Varyn House in Greyhaven, collision tiles block movement, tree tops on the Overhead layer (depth -10000) draw above him, walking a farmlands / Old Road / bandit-camp zone can start a random fight, signs and placeholder NPCs (Tomas, Renn) can be inspected, the Old Watchtower entrance goes to `rm_old_watchtower`, a Bandit or Fallen Knight battle plays idle/attack/hurt/death clips (or rectangles if those sprites are missing), victory returns to the exact overworld spot, and defeat wakes the party up at Greyhaven (2984, 2752) with the gold/XP penalty dialogue. Then run docs/TEST_PLAN.md, including the Sprites and Zone 1 map cases.

If the Included Files are missing, the debug log will print `scr_build_overworld: missing overworld/chunks/...` and the ground will be empty. If `ts_zone1` is not a Tile Set asset, tile layers will be blank or the script will fail.

## 9. Random encounter areas
Rooms are safe until you opt in:
1. **Zone (used by the overworld builder):** `scr_map_spawn_markers` creates stretched `obj_encounter_zone` instances from map markers (`zone01_farmlands`, `zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`), using the existing `table_id` / `enemy_table` API. Greyhaven has no zone. You can still hand-place extra zones the same way as before. See `game/objects/obj_encounter_zone/README.md`.
2. **Whole room:** in `scr_get_room_encounter_table()` (in `scr_encounter_tables`), return `scr_get_encounter_table("zone01_path")` (or a custom table) for that room. Do not do this for `TOWN_RESPAWN_ROOM` or other safe rooms. A zone at the player's position overrides the room table.
3. Keep `obj_encounter_trigger` for simple fixed fights, and `obj_story_encounter` for the guaranteed Watchtower Ashbound Hunter (and later scripted beats). Standing on either does not also roll a random encounter.
4. To disable random encounters while testing: set `#macro RANDOM_ENCOUNTERS_ENABLED false` and recompile, or in the debugger set `global.game.random_encounters_enabled = false`.
5. Default rates (pending tuning): 16 pixels = 1 step (one tile), a new fight after 8–24 steps in an area, 5 grace steps after room entry or after returning from battle.

## 10. Old Watchtower Ashbound Hunter (`enc_ashbound_hunter_wt`)
1. Create `obj_story_encounter` and `spr_story_encounter_placeholder` as in the tables above. Paste the Create, Room Start, and Step snippets. A 16×16 sprite matches the tile grid; a larger placeholder is scaled to one tile when spawned from the map.
2. You do **not** have to place the instance by hand in `rm_old_watchtower`. `scr_build_old_watchtower` / `scr_map_spawn_markers` spawn one on walkable tile (41, 24), immediately in front of `old_royal_banner` (41, 25). Leave `encounter_id` as `enc_ashbound_hunter_wt`. Do not also hand-place a second trigger on that tile.
3. To test the rare random source, walk the Old Road, bandit-camp, or Watchtower encounter zones (`table_id` `zone01_old_road` / `zone01_bandit_camp` / `zone01_watchtower`; the older short ids still work). You can also set `allow_ashbound_rare = true` on a zone. In the debugger, `global.game.ashbound_rare_chance = 1` makes the next random fight in that zone the Hunter. Do not enable this on `zone01_farmlands` or the `zone01_path` fallback unless you are specifically testing the rare roll.

## 11. When the town room is built
1. Create the town room (e.g. `rm_town`). Leave Persistent off. Place `obj_player` in that room (required; the player object is not persistent). Do **not** place a second `obj_game_controller` (the existing one is persistent and will arrive with the party).
2. In `game/scripts/scr_game_constants.gml`, change `#macro TOWN_RESPAWN_ROOM` to the new room asset (e.g. `rm_town`).
3. Place one `obj_respawn_point` in open space (inn, shrine, etc.), or set `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` (currently Greyhaven 2984, 2752) to a known open position in that room instead.
4. Re-run the defeat cases in docs/TEST_PLAN.md.

## Why a battle room instead of an overlay?
Chosen for this prototype (open question in DECISIONS_AND_OPEN_QUESTIONS.md): a separate room keeps overworld objects frozen, prevents overworld input during battle by construction, and makes the "save position → return" step explicit. Cost: the overworld room is rebuilt on return, so any overworld state that must survive a battle has to live in `global.game` (as `cleared_encounters` does).
