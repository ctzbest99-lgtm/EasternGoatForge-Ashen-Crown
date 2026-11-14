# Manual Test Plan

Run tests in GameMaker after integration; static review is not a substitute for running the game.

## Movement and interaction
- [ ] Project opens and compiles.
- [ ] Four-direction movement works; diagonal movement, if enabled, is normalized.
- [ ] Player cannot pass walls or leave intended map.
- [ ] Input locks during dialogue, menus, and battle.
- [ ] Dialogue closes and returns control; key repeat does not duplicate interaction.

## Battle
- [ ] Encounter starts once only.
- [ ] Attack resolves once per confirmation; Guard works and resets as documented.
- [ ] HP stays between zero and max HP; defeated actors cannot act.
- [ ] Rewards are granted once; victory and defeat return to valid states.
- [ ] Unknown enemy ID is handled safely.

## Exploration prototype (roadmap step 2)
Setup per game/rooms/ROOM_SETUP.md. Controls: arrows move, Z/Enter/Space confirm, X/Backspace cancel.
- [ ] E1 Player moves in four directions at `move_speed`; diagonal speed is not faster (normalized).
- [ ] E2 Walking into an `obj_solid` wall stops the player; holding a diagonal against a wall slides along it.
- [ ] E3 Player cannot leave the room even where a border wall is missing (bbox clamp).
- [ ] E4 If a `Collision` tile layer exists, non-empty tiles block movement; without the layer the game still runs.
- [ ] E5 Player cannot walk through the sign (`obj_interactable` parented to `obj_solid`).
- [ ] E6 Facing the sign and pressing Z opens the dialogue box; pressing Z while facing away does nothing.
- [ ] E7 While the box is open, arrow keys do not move the player and Z only advances lines.
- [ ] E8 The press that opens the box does not also skip the first line.
- [ ] E9 Closing the box on the last line returns control; that same press (or holding Z) does not reopen it. Pressing Z again afterwards reopens it.
- [ ] E10 Only one dialogue box can exist at a time (spam Z at the sign).
- [ ] E11 Instance Creation Code overrides `dialogue_lines` / `speaker_name` on a second sign.

## Battle prototype (roadmap step 3)
- [ ] B1 Walking onto the trigger starts exactly one battle (rm_battle_test opens once; no flicker or double start).
- [ ] B2 Overworld cannot start a battle while dialogue is open (open sign dialogue while overlapping a trigger if layout allows).
- [ ] B3 Intro message names the enemy (Bandit by default; Fallen Knight when `enemy_id = "fallen_knight"`).
- [ ] B4 Up/Down moves the cursor between Attack and Guard (wraps); holding Z resolves only one command per press.
- [ ] B5 Attack: enemy HP drops by `max(1, attack - floor(defense * 0.5))` (Kael 6 vs Bandit def 1 → 6; vs Fallen Knight def 4 → 4).
- [ ] B6 Guard: "[Guard]" shows; enemy damage that turn is halved (min 1); Guard clears when the next command phase starts.
- [ ] B7 HP never shows below 0 or above max for enemy or party.
- [ ] B8 Victory: message shows XP/gold; `global.game.xp`/`gold` increase once (check in debugger); return to the exact pre-battle position and facing.
- [ ] B9 After victory the trigger is gone, and stays gone after a second battle elsewhere (cleared_encounters).
- [ ] B10 Defeat (e.g. set Kael's attack to 0 in scr_party_create_default, or fight Fallen Knight while guarding only): defeat message, HP restored, return to the pre-battle position; the trigger does not fire again until you step off and back on.
- [ ] B11 No input works in the overworld during the frame of return (holding Z does not open dialogue instantly).
- [ ] B12 Unknown enemy: set a trigger's `enemy_id = "nope"` → error message, safe return, game keeps running, no crash.
- [ ] B13 Running rm_battle_test directly (no pending battle) fights a Bandit and logs "[battle] No pending battle".
- [ ] B14 X/Backspace in the command menu does nothing harmful with a one-member party.

## Menus and saves
- [ ] Selection and cancel/back work.
- [ ] Save/load persists after restart; missing/corrupt save fails safely.
- [ ] Bestiary displays correct sprite and description.

Record GameMaker version, date, result, and reproducible failures.