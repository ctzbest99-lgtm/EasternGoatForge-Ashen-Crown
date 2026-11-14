# Changelog

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