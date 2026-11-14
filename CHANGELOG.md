# Changelog

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