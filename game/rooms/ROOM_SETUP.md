# Room Setup

Do not fabricate .yy/.yyp metadata. Let GameMaker create resources. This document does not prove the project compiles.

Room size, tile size, and resolution are still undecided. The numbers below are **placeholders** so the prototype can be tested; change them freely.

The prototype now assumes a **16×16 tile grid** and **16×24** player sprites. Rooms stay **640×360** for now. Note that 360 is not a multiple of 16 (22 tiles + 8 px). See docs/DECISIONS_AND_OPEN_QUESTIONS.md. When the Zone 1 map is ready it will need a camera; that map is not imported yet.

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

Record imported assets in docs/ASSET_INVENTORY.md.

## 3. Objects
Create each object in the table in `game/README.md` with the listed sprite, flags, and events, then paste the matching `.gml` file into each event:
- **obj_game_controller:** no sprite, tick **Persistent**, untick Visible. Events: Create, Step ▸ Begin Step, Step ▸ End Step, Other ▸ Room Start.
- **obj_player:** sprite `spr_kael_ow16_idle_down` (or `spr_player_placeholder` if the sheet is not imported yet). Events: Create, Step. The Step event now also picks idle/walk by facing, plays the walk at 8 fps, and sets `depth = -y`.
- **obj_solid:** sprite `spr_solid_placeholder`. No events.
- **obj_interactable:** sprite `spr_interactable_placeholder`, **Parent = obj_solid** (blocks movement). Event: Create.
- **obj_dialogue_box:** no sprite. Events: Create, Step, Draw ▸ Draw GUI, Clean Up.
- **obj_encounter_trigger:** sprite `spr_encounter_trigger_placeholder`, no parent. Events: Create, Other ▸ Room Start, Step.
- **obj_battle_controller:** no sprite. Events: Create, Step, Draw ▸ Draw GUI.
- **obj_respawn_point:** optional sprite `spr_respawn_point_placeholder` (any small colour; only needed so you can see it while laying out the room). Event: Create. No parent, not solid.
- **obj_encounter_zone:** sprite `spr_encounter_zone_placeholder`. Event: Create. No parent, not solid. Stretch over the wild path only.

## 4. rm_overworld (placeholder 640×360; 16×16 grid)

**Camera (optional but recommended once the room is larger than the view, and for the coming Zone 1 map):** in the room editor, enable Views, enable Viewport 0, set the camera / view size to **320×180** (then set the game window or viewport scale to 2× so it displays at 640×360), or to **640×360** at 1:1. Visibility object can be `obj_player`. If Viewport 0 is enabled, `obj_game_controller`'s End Step follows the player and clamps to the room. If views stay off, the whole 640×360 room is the view and the follow is a no-op.

1. Create room `rm_overworld`; set it **first** in the Room Order (open the Room Manager and drag it to the top; the home icon marks the start room). Leave Persistent **off**.
2. Instances layer:
   - 1 × `obj_game_controller` anywhere.
   - Border of `obj_solid` around the room edge (stretch instances), plus a few interior walls to test sliding.
   - 1 × `obj_player` in open space.
   - 1 × `obj_interactable` next to open space (the sign).
   - 1 × `obj_encounter_trigger` on a path a few tiles from the player, **not** overlapping the player's start position.
   - 1 × `obj_respawn_point` in open space, **not** on the encounter trigger, preferably on a 16×16 tile (x and y multiples of 16). This is the stand-in town wake-up spot until a town room exists. If you omit it, defeat places the player at `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` (320, 176 by default), which must also be walkable.
   - 1 × `obj_encounter_zone` stretched over the wild path / grass, **not** covering the respawn marker, the player start if that pocket is meant to be "town", or a story trigger if you want that tile to stay a fixed fight only. The zone is what enables random encounters in this room (`rm_overworld` has no room-wide table because it is also the temporary town).
3. Optional per-instance overrides (double-click instance → Creation Code):
   - Sign: `dialogue_lines = ["[Placeholder line]"]; speaker_name = "";`
   - Trigger: `enemy_id = "fallen_knight"; encounter_id = "zone01_test_knight";` (each trigger needs a unique `encounter_id`).
   - Respawn marker: `facing_x = 0; facing_y = 1;` (defaults face down).
   - Zone: `table_id = "zone01_path";` or `table_id = ""; enemy_table = [{ enemy_id: "bandit", weight: 3 }, { enemy_id: "fallen_knight", weight: 1 }];`
4. Optional tile collision: add a Tile layer named exactly **`Collision`** with any tileset; every non-empty tile blocks the player. The layer may be hidden. If you use tiles for all walls you can drop the `obj_solid` walls, but keep the `obj_solid` object (the code references it).

## 5. rm_battle_test (placeholder 640×360)
1. Create room `rm_battle_test`. Leave Persistent off.
2. Place 1 × `obj_battle_controller`. Do **not** place `obj_player` or `obj_game_controller` here (the controller arrives from rm_overworld because it is persistent).
3. Running this room alone (Room Order first) works for UI testing: it fights a Bandit, but returning needs `rm_overworld`.

## 6. Compile and run
Run (F5). Expected: Kael uses the 16×24 idle/walk sprites (or the placeholder if they are not imported), is y-sorted with `depth = -y`, moves and collides with a 16×16 feet mask, the sign opens dialogue, the trigger starts a Bandit battle with idle/attack/hurt/death clips (or rectangles if those sprites are missing), walking the wild path (inside the zone, after a short grace) can start a random Bandit or Fallen Knight fight, victory returns to the same spot, and defeat wakes the party up at the respawn marker (or 320, 176) with a short placeholder dialogue that reports any gold and XP lost. Then run the "Exploration", "Battle prototype", "Random encounters", and "Sprites" sections of docs/TEST_PLAN.md.

## 7. Random encounter areas
Rooms are safe until you opt in:
1. **Zone (recommended for `rm_overworld`):** create `obj_encounter_zone` with `spr_encounter_zone_placeholder`, stretch it over the wild area only, leave towns / the respawn pocket uncovered. Default table is `zone01_path`. See `game/objects/obj_encounter_zone/README.md`.
2. **Whole room:** in `scr_get_room_encounter_table()` (in `scr_encounter_tables`), return `scr_get_encounter_table("zone01_path")` (or a custom table) for that room. Do not do this for `TOWN_RESPAWN_ROOM` or other safe rooms. A zone at the player's position overrides the room table.
3. Keep `obj_encounter_trigger` for fixed boss/story fights. Standing on a trigger does not also roll a random encounter.
4. To disable random encounters while testing: set `#macro RANDOM_ENCOUNTERS_ENABLED false` and recompile, or in the debugger set `global.game.random_encounters_enabled = false`.
5. Default rates (pending tuning): 16 pixels = 1 step (one tile), a new fight after 8–24 steps in an area, 5 grace steps after room entry or after returning from battle.

## 8. When the town room is built
1. Create the town room (e.g. `rm_town`). Leave Persistent off. Place `obj_player` in that room (required; the player object is not persistent). Do **not** place a second `obj_game_controller` (the existing one is persistent and will arrive with the party).
2. In `game/scripts/scr_game_constants.gml`, change `#macro TOWN_RESPAWN_ROOM` to the new room asset (e.g. `rm_town`).
3. Place one `obj_respawn_point` in open space (inn, shrine, etc.), or set `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` to a known open position in that room instead.
4. Re-run the defeat cases in docs/TEST_PLAN.md.

## 9. Zone 1 map (not imported yet)

The overworld tileset and map being built under `/workspace/zone1/` (`ts_zone1.png`, markers, upcoming chunk CSVs and a build script) are **not** part of this repository yet and may still change. Do not import them until that delivery is marked complete. This 640×360 test room remains the playable overworld until then. A camera follow is already in the controller so a large map can be dropped in later (see section 4).

## Why a battle room instead of an overlay?
Chosen for this prototype (open question in DECISIONS_AND_OPEN_QUESTIONS.md): a separate room keeps overworld objects frozen, prevents overworld input during battle by construction, and makes the "save position → return" step explicit. Cost: the overworld room is rebuilt on return, so any overworld state that must survive a battle has to live in `global.game` (as `cleared_encounters` does).
