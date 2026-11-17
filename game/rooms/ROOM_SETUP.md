# Room Setup

Do not fabricate .yy/.yyp metadata. Let GameMaker create resources. This document does not prove the project compiles.

Every built room is a **16×16** tile map and needs a camera (a 320×180 viewport). The rooms in the project are listed in the index below; the sections after it give the per-room setup. Room size and resolution are still undecided in a final-design sense — the sizes here are what the builders and the generated project currently use.

The overworld player uses **16×24** Kael sprites on that 16×16 grid (`depth = -y`). See docs/DECISIONS_AND_OPEN_QUESTIONS.md.

**Sprite import:** follow [`game/sprites/IMPORT.md`](../sprites/IMPORT.md) for every character PNG (asset name, frames, origin, mask, fps). Code uses `asset_get_index` and still compiles if a sprite is missing.

## Room index

| Room | Size (px) | Tiles | Chapter | Creation Code / contents |
|---|---|---|---|---|
| `rm_title` | 320×180 | — (GUI) | Title | `obj_title` + `obj_game_controller`; no player, no builder (section 0) |
| `rm_overworld` | 6400×4800 | 400×300 | 1 | `scr_build_overworld();` |
| `rm_old_watchtower` | 960×720 | 60×45 | 1 | `scr_build_old_watchtower();` |
| `rm_watchtower_basement` | 704×512 | 44×32 | 1 | `scr_build_watchtower_basement();` |
| `rm_greyhaven_varyn_house` | 320×240 | 20×15 | 1 | `scr_build_greyhaven_varyn_house();` |
| `rm_greyhaven_tavern` | 384×256 | 24×16 | 1 | `scr_build_greyhaven_tavern();` — save crystal at (10, 6) |
| `rm_greyhaven_chapel` | 320×288 | 20×18 | 1 | `scr_build_greyhaven_chapel();` — save crystal at (10, 7) |
| `rm_greyhaven_blacksmith` | 320×240 | 20×15 | 1 | `scr_build_greyhaven_blacksmith();` |
| `rm_greyhaven_general_store` | 320×240 | 20×15 | 1 | `scr_build_greyhaven_general_store();` |
| `rm_battle_test` | 640×360 | — (battle room) | — | `obj_battle_controller` only (section 7) |
| `rm_millhaven_road` | 512×960 | 32×60 | 2 | `scr_build_millhaven_road();` |
| `rm_wrenfield` | 896×704 | 56×44 | 2 | `scr_build_wrenfield();` |
| `rm_wrenfield_bent_post` | 384×256 | 24×16 | 2 | `scr_build_wrenfield_bent_post();` — closed/open patch, save crystal at (4, 9) |
| `rm_wrenfield_store` | 320×224 | 20×14 | 2 | `scr_build_wrenfield_store();` |
| `rm_valemere_road` | 384×704 | 24×44 | 3 | `scr_build_valemere_road();` |
| `rm_valemere` | 640×480 | 40×30 | 3 | `scr_build_valemere();` |
| `rm_salt_lamp` | 320×224 | 20×14 | 3 | `scr_build_salt_lamp();` — save crystal at (4, 6) |
| `rm_warehouse` | 416×288 | 26×18 | 3 | `scr_build_warehouse();` + `obj_night_overlay` |
| `rm_hollow_approach` | 384×320 | 24×20 | 4 | `scr_build_hollow_approach();` — the doors and the waystone |
| `rm_hollow_sanctuary` | 448×416 | 28×26 | 4 | `scr_build_hollow_sanctuary();` — records hall, sealed door, inner door |
| `rm_ashlands_breach` | 512×320 | 32×20 | — (Act VII region) | `scr_build_ashlands_breach();` — the Crownveil breach, the ash field and Sarn's outpost |
| `rm_ashlands_ruins` | 640×448 | 40×28 | — (Act VII region) | `scr_build_ashlands_ruins();` — the walled ruin up the black road: gated outer wall, pillared court, two side halls and the north sanctum |
| `rm_ashlands_depths` | 576×384 | 36×24 | — (Act VII region) | `scr_build_ashlands_depths();` — the undercroft behind the sanctum wall: stair down, pillared hall, four burial niches and the black-sun shrine |

Chapters 4–5 have no rooms yet: their encounter tables, level bands and boss groups exist in `scr_encounter_tables` / `scr_enemy_database`, but the Hollow Sanctuary and the Blackwood garrison are unbuilt. The 8 overworld entrances still marked `status: "stub"` (Rimehold, Saltreach, the Ironspine and Drowned Coast ruins, …) point at rooms that do not exist and show `[rm_… is not built yet.]`; the Blackwood doors and deep shrine target built rooms and are now marked `built`. `rm_ashlands_breach` and `rm_ashlands_ruins` are built, so the Crownveil and broken-structure entrances open (both after `flag_act4_complete`); `rm_ashlands_depths` has no overworld entrance and is reached through the ruin's sanctum stair.

## 0. Title room (`rm_title`) — first in Room Order
1. Create room `rm_title`. Size 320×180 (or 640×360 if you prefer a 2× room; the menu is drawn in Draw GUI either way). Persistent off. Clear colour black.
2. **Room Order:** move `rm_title` to the **top** so it is the first room. `rm_overworld` is no longer first.
3. Place **`obj_title`** and **`obj_game_controller`** (persistent). Do **not** place `obj_player` here.
4. Views: enable Viewport 0, camera 320×180, visible area 1280×720 (or 2× the camera). `scr_ui_init()` also locks the GUI to 320×180.
5. Background layers are optional. `obj_title` draws the parallax (`spr_menu_bg0`–`bg3`) in Draw GUI at speeds 0, −0.05, −0.1, −0.2, then the ember loop at 12 fps, the logo, and the menu options (New Game, Continue disabled when no `save1.sav`–`save3.sav` exists, Options, Quit). Continue opens the field-menu load panel (leader portrait, location, level, party icons, playtime, gold). Import the field-menu parts from `game/sprites/IMPORT.md` (Field menus) so tabs, dither, and slot frames appear; missing sprites fall back to the nine-slice windows.
6. Uncheck **Game Options ▸ Graphics ▸ Interpolate colours between pixels**.
7. Import the 320 title sprites (and the UI font / nine-slice windows) from `game/sprites/IMPORT.md`. The 640 ember strip needs its own Texture Group (see IMPORT.md); otherwise skip it and the 320 strip is used.
8. `#macro TITLE_ROOM rm_title` is in `scr_game_constants.gml`. The project will not compile until this room exists.
9. New Game resets `global.game` and goes to `rm_overworld`. Continue is enabled when any of `save1.sav`–`save3.sav` exists and opens the load panel. A damaged file is listed as such and will not crash. Options opens the placeholder panel (`spr_menu_panel_options_*`).

The Design README called this room `rm_main_menu`. This project uses **`rm_title`**.

## 1. Project
1. Create a new GameMaker project (GML, GameMaker 2023.1+).
2. Create every Script listed in `game/README.md` first, pasting each `game/scripts/*.gml` file into the script of the same name. Scripts reference objects and rooms by name, so the project will not compile until steps 2–4 are done too.

## 2. Sprites

### 2a. Character art (required for the new look; optional for a compile test)
Import the PNGs in `game/sprites/` using the table in [`game/sprites/IMPORT.md`](../sprites/IMPORT.md). At minimum, import Kael's 16×24 overworld set and the battle idle/attack/hurt/death strips for `spr_hero_*`, `spr_bandit_*`, and `spr_fallen_knight_*`. For the Chapter 1 look, also import the enemy / Blackguard / NPC / portrait / UI / item / title sets in the Chapter 1 section of IMPORT.md (origins, frame counts, and fps are listed per asset). Keep each asset name identical to the filename (including `_stripN`).

After import: enable nine-slice on the three `spr_ui_window*` sprites (8 px each side) and put `spr_menu_embers_640_strip24` in a 2048+ Texture Group, or skip that one strip. The font is created in code from `spr_font_main_strip95` via `font_add_sprite_ext` — do not make a Font asset.

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
- **obj_game_controller:** no sprite, tick **Persistent**, untick Visible. Events: Create, Step ▸ Begin Step, Step ▸ End Step, Other ▸ Room Start. Place in `rm_title` (and a spare in `rm_overworld` is fine — the duplicate destroys itself).
- **obj_title:** no sprite. Events: Create, Step, Draw ▸ Draw GUI. Place only in `rm_title`.
- **obj_adventure_menu:** no sprite. Events: Create, Step, Draw ▸ Draw GUI, Clean Up. Do not place in a room; `obj_game_controller` opens it on I / Tab. Rows: Items, Equip, Party Order, Status, Bestiary, Close — Items and Equip hand off to `obj_inventory_menu`. Saving is deliberately not a row.
- **obj_inventory_menu:** no sprite. Events: Create, Step, Draw ▸ Draw GUI, Clean Up. Do not place in a room; it is opened from the Adventure menu's Items / Equip rows. Tabs: Items / Equip / Key (Q/E). Z uses a consumable or opens the Equip slot list.
- **obj_shop_menu:** no sprite. Events: Create, Step, Draw ▸ Draw GUI, Clean Up. Do not place in a room; talking to Marda or (after the pendant) Pell opens it after their dialogue. Tabs Buy / Sell / Exit sit 12px above the list window and are drawn after it.
- **obj_save_menu:** no sprite. Events: Create, Step, Draw ▸ Draw GUI, Clean Up. Do not place in a room; opened by `obj_save_point`, `CV_END`, or (if `DEBUG_SAVE_ANYWHERE` is true) F5. Overwrite confirm defaults to No. A successful save creates `obj_save_toast`.
- **obj_save_toast:** no sprite. Events: Create, Step, Draw ▸ Draw GUI. Do not place in a room. Draws `spr_ui_toast_saved` (origin (32, 0)) at (160, 8).
- **obj_save_point:** parent `obj_interactable`. Events: Create, Step. Sprite: `spr_save_point_idle_strip8` (16×24, origin (8, 23), 8 fps loop); activate uses `spr_save_point_activate_strip8` (32×40, origin (16, 39), 12 fps once) then opens the save menu. Import a feet mask (0, 16, 15, 23). The map builder places four: Greyhaven Chapel (10, 7), Greyhaven Tavern (10, 6), the Wrenfield Bent Post (4, 9) and the Valemere Salt Lamp (4, 6) — do not also hand-place them unless you are testing. Saving and loading only work inside a town's church or tavern (`scr_save_allowed_here()`), so a crystal placed anywhere else shows the blocked line instead of the slot panel.
- **obj_player:** sprite `spr_kael_ow16_idle_down` (or `spr_player_placeholder` if the sheet is not imported yet). Events: Create, Step. The Step event also picks idle/walk by facing, plays the walk at 8 fps, and sets `depth = -y`.
- **obj_solid:** sprite `spr_solid_placeholder`. No events.
- **obj_interactable:** (also add a Step event: `Step.gml` — y-sort, Tomas pallet pose, chest open strip)  sprite `spr_interactable_placeholder` (16×16 Top Left preferred; a larger placeholder is scaled to one tile by the map spawner), **Parent = obj_solid** (blocks movement). Event: Create. The spawner also sets `script_id` / `struck_lines` / item fields from map data.
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
- **obj_night_overlay:** no sprite. Events: Create, Draw ▸ Draw GUI. Do not place in a room; `scr_build_warehouse()` creates it for the Chapter 3 heist-night darkness with lantern pools (PLACEHOLDER lighting until Design's pass). See `game/objects/obj_night_overlay/README.md`.

## 4. Tileset and Included Files (do this before the rooms)
1. **Tileset:** follow `game/tilesets/README.md`. You need a Sprite `spr_ts_zone1` (import `game/tilesets/ts_zone1.png`, do not split it) and a Tile Set named exactly **`ts_zone1`**, tile size 16×16, offset 0, separation 0. The Chapter 2–3 rooms need the second tileset, `ts_wrenfield` (section 6c).
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
| `rm_greyhaven_tavern` | 384×256 | 24×16 | `scr_build_greyhaven_tavern();` | Hob (`GH_TAVERN_01`–`04`). The cellar hatch is closed and inspectable. An `obj_save_point` is spawned at tile (10, 6) — location is still open. |
| `rm_greyhaven_chapel` | 320×288 | 20×18 | `scr_build_greyhaven_chapel();` | Sister Ilse (`GH_CHAPEL_01`–`03`). An `obj_save_point` is spawned at tile (10, 7) — location is still open. |
| `rm_greyhaven_blacksmith` | 320×240 | 20×15 | `scr_build_greyhaven_blacksmith();` | Tomas and Pell (`GH_TOMAS`). After the pendant, Pell's repeat line is `GH_SMITH_01_B`, then `shop_greyhaven_forge` opens (Iron Sword, Leather Armor, Iron Helm; PLACEHOLDER prices). |
| `rm_greyhaven_general_store` | 320×240 | 20×15 | `scr_build_greyhaven_general_store();` | Marda (`GH_STORE_01`–`03`), then `shop_greyhaven_store` opens (Minor Potion, Antidote; PLACEHOLDER prices). |

Paste every new `scr_build_*.gml` and `scr_map_markers_data.gml` as Script assets. Re-import `ts_zone1.png` (now **256×800**; ids in rows 0–37 are unchanged; rows 38–49 are interior/dungeon tiles).

## 6c. Chapter 2 rooms (feature/chapter2)
Data is embedded in the scripts. The source CSVs, marker JSON and renders are under `game/maps/chapter2/` (Design's pipeline lives in `/workspace/wrenfield`).
1. **Tileset:** import `game/tilesets/ts_wrenfield.png` as Sprite `spr_ts_wrenfield` (one image), then make a Tile Set named exactly **`ts_wrenfield`** (16×16, offset 0, separation 0). Rows 0–49 are `ts_zone1`.
2. **Scripts:** add one Script asset for each new file in `game/scripts/`:
   - `scr_dialogue_data_ch2` (generated from the script by `tools/gen_ch2_dialogue.py`)
   - `scr_ch2_story`
   - `scr_wf_tilemaps`, `scr_wf_markers_data`, `scr_wf_overworld_patch`
   - `scr_build_millhaven_road`, `scr_build_wrenfield`, `scr_build_wrenfield_bent_post`, `scr_build_wrenfield_store`
3. **Rooms.** Create these four rooms. Leave Persistent off. Give each the **same five Tile layers** as the Zone 1 rooms (any tileset; the build script switches them to `ts_wrenfield`), Instances at depth 0 and Viewport 0, and place **1 × `obj_player`**:
   | Room | Size (px) | Creation Code |
   |---|---|---|
   | `rm_millhaven_road` | 512×960 | `scr_build_millhaven_road();` |
   | `rm_wrenfield` | 896×704 | `scr_build_wrenfield();` |
   | `rm_wrenfield_bent_post` | 384×256 | `scr_build_wrenfield_bent_post();` |
   | `rm_wrenfield_store` | 320×224 | `scr_build_wrenfield_store();` |
   Each builder picks the before / after state from `flag_execution_stopped`.
4. **Overworld:** nothing to add. `scr_build_overworld()` now paints the Millhaven Road branch and spawns its three markers. Ignore the `scr_wf_overworld_patch();` step in Design's README: in the repo that function only returns data. The entrance at tile (303,184) stays shut ("Crown checkpoint. No passage south without the Reeve's leave.") until `flag_act2_started`. That flag is set when Kael wakes at the Crownveil door after the Chapter 1 save prompt.
5. **West road:** the exit `west_road_to_valemere` targets `rm_valemere_road` (built in Chapter 3), plays WF_HANDOFF, sets `flag_chapter2_complete` and lands on the road. Its `fallback_room` / `fallback_spawn` (`rm_overworld` / `from_wrenfield_west`) are a safety net only, used if that room ever resolves to nothing.
6. **Optional object:** `obj_story_npc` is used for the gallows scene (Calder, Taren, Bram and the prisoners). `obj_story_trigger` is used for walk-on beats. Both already exist from Zone 1.

## 6d. Chapter 3 rooms (feature/chapter3)
Data is embedded in the scripts (generated by `tools/gen_ch3_rooms.py`; markers in `scr_ch3_markers_data.gml`). These are functional blockouts: Design's Valemere art has not landed, so the rooms use `ts_wrenfield` tiles and existing / placeholder sprites. Everything follows the Chapter 2 pattern (`scr_wf_prepare_layers` + `scr_map_build_from_arrays` + `scr_map_spawn_markers`).
1. **Scripts:** `scr_dialogue_data_ch3` (generated by `tools/gen_ch3_dialogue.py`, 149 nodes), `scr_ch3_story`, `scr_ch3_markers_data`, and the four builders `scr_build_valemere_road`, `scr_build_valemere`, `scr_build_salt_lamp`, `scr_build_warehouse`.
2. **Object:** `obj_night_overlay` (heist-night lighting, created by `scr_build_warehouse`; draws a dark overlay with lantern pools in the GUI layer).
3. **Sprites:** Lyra placeholder set (`npcs/lyra/` overworld, `party/lyra/` battle strips; `game/sprites/src/lyra.py`). Rows are in `game/sprites/IMPORT.md`. Replace wholesale when Design's Lyra lands.
4. **Rooms.** Same five Tile layers, Instances at depth 0, Viewport 0, **1 × `obj_player`** each:
   | Room | Size (px) | Creation Code |
   |---|---|---|
   | `rm_valemere_road` | 384×704 | `scr_build_valemere_road();` |
   | `rm_valemere` | 640×480 | `scr_build_valemere();` |
   | `rm_salt_lamp` | 320×224 | `scr_build_salt_lamp();` |
   | `rm_warehouse` | 416×288 | `scr_build_warehouse();` |
5. **Wiring:** the Wrenfield west exit goes to `rm_valemere_road` (its `west_road_to_valemere` marker is `status: "built"`; the overworld fallback stays only as a safety net). `rm_valemere`'s west gate (`west_country_road`) is the Chapter 3 end: `scr_ch3_exit_script` plays VM_HANDOFF, sets `flag_chapter3_complete` and opens the save prompt; `rm_west_country_road` was the Chapter 3 placeholder for Chapter 4; the gate now targets `rm_hollow_approach` (`scr_ch3_west_leave`), and `rm_valemere` has a `from_hollow` spawn for the walk back.
6. **The generator:** `python3 gen_gamemaker.py` now emits all Chapter 2 + 3 rooms and `ts_wrenfield` into `gamemaker/`; `python3 validate_gamemaker.py` covers them (player present, layers, refs).

## 7. rm_battle_test (placeholder 640×360)
1. Create room `rm_battle_test`. Leave Persistent off.
2. Place 1 × `obj_battle_controller`. Do **not** place `obj_player` or `obj_game_controller` here (the controller arrives from rm_overworld because it is persistent).
3. Running this room alone (Room Order first) works for UI testing: it fights a Bandit, but returning needs `rm_overworld`.
4. **Battle upgrade (feature/battle-upgrade):** no new objects or rooms. Create two new Script assets, `scr_skill_data` and `scr_battle_system`, from `game/scripts/`, and re-paste the changed scripts (`scr_game_constants`, `scr_battle_actors`, `scr_party`, `scr_progression`, `scr_enemy_database`, `scr_encounter_tables`, `scr_encounter`, `scr_ch1_art`, `scr_sprites`, `scr_save`) and all three `obj_battle_controller` events (Create, Step, Draw GUI). Import the Act II enemy strips listed in IMPORT.md ("Act II enemies") when you want the new art; until then those enemies draw as rectangles.
5. **Balance pass (feature/balance-pass):** no new assets. Re-paste `scr_game_constants`, `scr_progression`, `scr_party`, `scr_save`, `scr_enemy_database`, `scr_encounter_tables`, `scr_item_data`, `scr_shop_data`, `scr_dialogue`, `scr_battle_actors`, the `obj_battle_controller` Create / Step / Draw GUI events, and the `obj_dialogue_box` Create / Step / Draw GUI events.
6. **Enemy batches 7–8 (feature/enemy-batches-7-8):** no new objects or scripts. Re-paste `scr_game_constants`, `scr_skill_data`, `scr_battle_system`, `scr_battle_actors`, `scr_enemy_database`, `scr_encounter_tables`, `scr_sprites`, `scr_ch1_art`, and the `obj_battle_controller` Create / Step / Draw GUI events. Import the batch 7 / 8 strips and the four backgrounds from IMPORT.md when you want the art.
7. **Quick multi-enemy test without Act II rooms:** in the debugger (or a temporary key in `obj_game_controller`), call `scr_encounter_start("grp_reeve_calder", "test_calder")` or `scr_encounter_start(["crown_patrolman", "crown_crossbowman", "occupation_soldier"], "test_crown")` while standing on the overworld. These are Chapter 2 levels (8–10); turn on `DEBUG_ADD_FULL_ROSTER` and expect a hard fight with a Chapter 1 party.

## 8. Compile and run
Run (F5). Expected: the overworld loads (watch the compile / first-room time; 120k tiles × 5 layers), Kael uses the 16×24 idle/walk sprites (or the placeholder if they are not imported) and is y-sorted with `depth = -y`, the camera follows him and stops at the room edges, he starts on the south road outside Greyhaven (199, 186) and `GH_ARRIVAL` plays once, collision tiles block movement, tree tops on the Overhead layer (depth -10000) draw above him, building doors enter the five interiors, the North Gate is barred until the pendant is found in Varyn House, walking a farmlands / Old Road / bandit-camp zone can start a random fight, signs use the confirmed Chapter 1 wording, Tomas and Pell are inside the Blacksmith (`GH_TOMAS`), Wenna, Dov and Corwin can be spoken to, the Fallen Knight story NPC can be met on the camp path, the Watchtower Hunter trigger at (33, 33) is walkable, the basement trap hall / key chest / mural work, Renn is still a placeholder, a Bandit or new PLACEHOLDER enemy battle plays clips or rectangles, victory returns to the exact overworld spot, and defeat wakes the party up at Greyhaven `town_square` (3192, 2832) with the gold/XP penalty dialogue. Then run docs/TEST_PLAN.md, including the Sprites and Zone 1 map cases. For a Chapter 2–3 smoke run: wake at the Crownveil door → optional Greyhaven → Millhaven Road → Wrenfield (gate, gallows, Calder, Taren joins) → west road (WF_HANDOFF) → Valemere Road (the FK_03 sighting) → Valemere (gate scene, Alden) → Salt Lamp (Nim, Lyra) → warehouse (heist night, the notes, the Debtman) → west gate (VM_HANDOFF). Save crystals are in the Greyhaven chapel and tavern, the Bent Post and the Salt Lamp.

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

## 9. Chapter 4 rooms — `rm_hollow_approach`, `rm_hollow_sanctuary`

1. **Scripts:** `scr_dialogue_data_ch4` (generated by `tools/gen_ch4_dialogue.py`, 101 nodes), `scr_ch4_story`, `scr_ch4_markers_data`, and the builders `scr_build_hollow_approach` / `scr_build_hollow_sanctuary`. Both rooms are produced by `tools/gen_ch4_rooms.py`, which also writes the two `.yy` files below.
2. **Rooms.** Same five Tile layers, Instances at depth 0, Viewport 0, **1 × `obj_player`** each, Creation Code calling the builder:
   | Room | Size (px) | Creation Code | Contents |
   |---|---|---|---|
   | `rm_hollow_approach` | 384×320 | `scr_build_hollow_approach();` | West road in, waystone, shepherd, the doors (HS_DOOR), exit into the sanctuary |
   | `rm_hollow_sanctuary` | 448×416 | `scr_build_hollow_sanctuary();` | Outer hall, carved wall, sealed door, lamp, records hall (Caelan), inner door (the Warden) |
3. **Wiring:** `rm_valemere`'s west gate (`west_country_road`) now targets `rm_hollow_approach` (`from_valemere`); the approach links back to `rm_valemere` (`from_hollow`) and into the sanctuary. The sanctuary's south exit is the Chapter 4 handoff (`CH4_HANDOFF` in `scr_ch4_exit_script`), which plays HS_HANDOFF, sets `flag_chapter4_complete` and lands back on the approach.
4. **No save crystal:** the save rule is a crystal inside a town's church or tavern, so the chapter-end prompt is quiet here.
5. **Placeholder content:** the sanctuary uses the `ts_wrenfield` blockout tiles, Caelan's overworld sprite is a traveler stand-in, and the layout is Design's to replace. The `hollow_sanctuary` encounter table is active between the lore nodes.

## 10. Chapter 5 rooms — `rm_blackwood_garrison`, `rm_garrison_keep`

1. **Scripts:** `scr_dialogue_data_ch5` (generated by `tools/gen_ch5_dialogue.py`, 151 nodes), `scr_ch5_story`, `scr_ch5_markers_data`, and the builders `scr_build_blackwood_garrison` / `scr_build_garrison_keep`. Both rooms and both builders come from `tools/gen_ch5_rooms.py`.
2. **Rooms.** Same five Tile layers, Instances at depth 0, Viewport 0, **1 × `obj_player`** each, Creation Code calling the builder:
   | Room | Size (px) | Creation Code | Contents |
   |---|---|---|---|
   | `rm_blackwood_garrison` | 416×352 | `scr_build_blackwood_garrison();` | Road in, notice board, palisade gate, yard (well, cold forge, dispatch chest), cell block (Sera), office alcove, treeline exit |
   | `rm_garrison_keep` | 320×224 | `scr_build_garrison_keep();` | The commander's office: desk, map table, dispatch chest, ledger (the sealed order) |
3. **Wiring:** `rm_valemere_road` gained an east fork — `to_blackwood_road` at tile 23,11 with the `from_blackwood` spawn at 22,12 — targeting `rm_blackwood_garrison` (`from_road`); the added markers are in the generator source as well, so a future regeneration keeps them. Inside the post, the office door (`to_keep`, tile 17,2) is barred until `flag_hailen_beaten` and the keep returns to `from_keep`. The east exit (`to_blackwood`, tile 25,10) plays BG_HANDOFF and the Fallen Knight sighting, then points at the unbuilt `rm_blackwood_deep`, so afterwards it is an ordinary stub door.
4. **Walkable geometry:** the gate is the gap in the palisade at x=10 (y 10–12), the cell door is the gap at tile (15,15), and the office door is the gap at (17–18,2) with the tree border opened behind it. All three were checked in the generated arrays (decor 0 / collision 0).
5. **No encounters and no save crystal:** the post is a story location, so `blackwood_garrison` is not spawned inside it, and the chapter-end prompt is the quiet one (saving stays inside a town's church or tavern).
6. **Placeholder content:** both rooms are `ts_wrenfield` blockouts and the layout is Design's to replace. Hailen uses his imported overworld set (`spr_commander_hailen_ow16_*`), and his battle strips and portrait already exist, so his fight needs no art work. **Sera has no art at all** (no overworld set, battle strips or portrait), so she uses `spr_prisoner_a_ow16_idle_down` in the cell block and the engine's fallback in battle until her set is drawn.

## 12. Where a room's tiles actually live

The `.yy` tile layers of every built room are **empty on purpose**. Creation Code calls `scr_build_<room>()`, which walks the five named layers (Ground, Decoration, Overhead, Collision, Markers), clears them and refills them from the flat arrays in `scr_<room>_data()`:

```gml
scr_map_build_from_arrays(scr_<room>_data(), W, H);   // 0 = empty cell, row-major, index = y * W + x
```

Consequences for anyone editing a room:

- **Painting tiles into the `.yy` is pointless** — the builder clears those layers on entry. Change the authored array in the builder instead (`ground` for floors and walls, `decor` for furniture and props, `overhead` for canopies, `collision` for blocking, `markers` for spawn points).
- **The builders are generated** (`src/export.py` for Chapters 1–3, `wrenfield/src/export_wf.py` for Chapter 2's village, `tools/gen_ch5_rooms.py` for Chapter 5). Prefer editing the source map data and re-exporting; if the exporter is unavailable, edit the builder and say so.
- **To see a room without the IDE**, run `python3 tools/render_built_maps.py [room]` — it composites the authored arrays and writes `/tmp/map_<room>.png`.
- The rooms are dressed, not bare: walls, doorways, furniture, burn damage, paving and tree lines are all in the arrays.
