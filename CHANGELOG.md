# Changelog

## 2026-11-14 — Character sprites and 16×16 overworld scale
- Added Kael, Bandit, and Fallen Knight art under `game/sprites/` (battle strips plus 16×24 and 32×48 overworld walk/idle sets for Kael and the Bandit). IDE import table is `game/sprites/IMPORT.md`. Source generators (`src/*.py`) are included because they are small. The Zone 1 tileset / map is not imported; it is still being built.
- `obj_player` uses the 16×24 Kael sheet: idle/walk by facing, walk at 8 fps, `depth = -y`, no `image_xscale` (left is pre-mirrored). `mask_index` is pinned to idle-down (16×16 standing-tile feet box). `asset_get_index` falls back to the IDE placeholder if the sheet is missing. The 32×48 overworld set is a code fallback only.
- Overworld scale defaults (pending approval): `TILE_SIZE` 16, `PLAYER_MOVE_SPEED` 1 (same tiles-per-second as the old speed of 2 on 32 px tiles), `PLAYER_INTERACT_REACH` 4. Encounter steps are now 16 pixels (one tile); the 8–24 step interval is unchanged in tile terms. Default town respawn is (320, 176) so it sits on the 16 px grid (was 320, 180).
- Battle: `obj_battle_controller` draws Kael and the enemy with idle loops, plays attack then hurt (or death on a KO) in a new `BATTLE_STATE.ANIMATING` state, and holds the last death frame. Confirm skips the clip. Missing sprites draw the old placeholder rectangles and do not stall the state machine. Party faces left via `xscale = -1`; the Fallen Knight's 64×48 attack origin (32, 47) is honoured so the feet stay planted.
- Optional camera: if Viewport 0 is enabled, `obj_game_controller` End Step follows the player and clamps to the room (`CAMERA_FOLLOW_PLAYER`). Recommended view is 320×180 at 2×, or 640×360 1:1. Rooms themselves are still 640×360 (height is not a multiple of 16).
- Documented in `game/sprites/IMPORT.md`, `game/rooms/ROOM_SETUP.md`, docs/ASSET_INVENTORY.md, docs/DECISIONS_AND_OPEN_QUESTIONS.md; test plan S1–S9 added. Not compiled or playtested in GameMaker yet.


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