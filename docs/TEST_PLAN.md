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
- [ ] Rewards are granted once; victory returns to the pre-battle position; defeat wakes the party up in town with HP restored and the gold/XP penalty applied.
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
- [ ] B8 Victory: message shows XP/gold; gold increases once; each party member's `xp` increases by the reward once (Kael is also mirrored in `global.game.xp`); return to the exact pre-battle position and facing.
- [ ] B9 After victory the trigger is gone, and stays gone after a second battle elsewhere (cleared_encounters).
- [ ] B10 Defeat (e.g. set Kael's attack to 0 in scr_party_create_default, or fight Fallen Knight while guarding only): battle shows "The party has fallen..."; after confirm, the party appears in `TOWN_RESPAWN_ROOM` (`rm_overworld` until a town room exists) at `obj_respawn_point` if one is placed, otherwise at `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` (3192, 2832, Greyhaven `town_square`) — not at the pre-battle position. Party HP is full. A placeholder wake-up dialogue opens (wake-up line, then "You lost X gold and Y EXP."); closing it returns overworld control. The same confirm that dismissed the defeat message must not also close the wake-up line.
- [ ] B11 No input works in the overworld during the frame of return from a victory (holding Z does not open dialogue instantly). After a defeat, the wake-up box is already open; holding Z must not skip or instantly close it if that press was the battle confirm (see B10).
- [ ] B12 Unknown enemy: set a trigger's `enemy_id = "nope"` → error message, safe return, game keeps running, no crash.
- [ ] B13 Running rm_battle_test directly (no pending battle) fights a Bandit and logs "[battle] No pending battle".
- [ ] B14 X/Backspace in the command menu does nothing harmful with a one-member party.
- [ ] B15 Defeat penalty (check in the debugger and on the wake-up line "You lost X gold and Y EXP."): gold becomes `gold - floor(gold * 0.5)`; each member loses `floor((xp - scr_xp_for_level(level)) * 0.1)` XP and never drops below that level's floor (level does not change). Suggested checks: win one Bandit first (gold 4, Kael XP 6, level 1, next at 30), then lose — gold 2, XP 6 (`floor(6 * 0.1) = 0`); set gold 10 / Kael XP 25 at level 1, then lose — gold 5, XP 23; set Kael to level 2 / XP 30 (exactly the L2 floor) and lose — XP stays 30, still level 2; set level 2 / XP 50 (progress 20) and lose — XP 48, still level 2. Starting from 0 gold and 0 XP reports "You lost 0 gold and 0 EXP." and stays at 0. The encounter trigger is not cleared: walking back onto it starts the fight again.

## Random encounters (owner decision 2026-11-14; rates pending tuning)
Setup: place a stretched `obj_encounter_zone` over the wild path in `rm_overworld`, not covering the respawn marker or a safe pocket. Defaults: 16 pixels = 1 step (one tile), `ENCOUNTER_STEPS_MIN` 8, `ENCOUNTER_STEPS_MAX` 24, `ENCOUNTER_GRACE_STEPS` 5. Default table `zone01_path` is Bandit weight 3, Fallen Knight weight 1.
- [ ] R1 Walking in a safe area (no zone, no room table, or the respawn/town pocket) never starts a random battle, even after many tiles.
- [ ] R2 Walking inside an `obj_encounter_zone` eventually starts a battle with an enemy from that zone's table (Bandit or Fallen Knight with the default weights).
- [ ] R3 After room entry and after returning from a victory, the first `ENCOUNTER_GRACE_STEPS` tiles in an encounter area do not start a fight (5 tiles at the default).
- [ ] R4 Standing still, walking into a wall (no position change), or holding a direction during dialogue does not advance the encounter counter.
- [ ] R5 Victory from a random encounter returns to the exact pre-battle position and facing; the zone remains and another fight can occur after grace. Random fights are not recorded in `cleared_encounters`.
- [ ] R6 Defeat from a random encounter still wakes the party up in town with HP restored and the gold/XP penalty applied (same as B10/B15).
- [ ] R7 `obj_encounter_trigger` still starts its fixed fight. Standing on a trigger does not also roll a random encounter. Victory still removes that trigger for the session.
- [ ] R8 Setting `RANDOM_ENCOUNTERS_ENABLED` to false (recompile) or `global.game.random_encounters_enabled = false` in the debugger disables random fights; fixed triggers still work. Setting it back to true re-enables them.

## Party and progression (roadmap step 4; numbers pending owner approval)
XP curve: total XP to be level L is `20*(L-1)^2 + 10*(L-1)` (L2=30, L3=100, L4=210). Growth: +4 max HP, +1 ATK, +1 DEF per level. Cap 20. Default party is Kael only (30/6/2 at level 1), with Lyra, Caelan, Sera and Taren Holt on the roster but not joined.
- [ ] P1 Win fights until Kael reaches 30 XP (five Bandits, or set `party[0].xp = 24` then win one Bandit): after the victory line, a message says "Kael reached level 2! HP +4, ATK +1, DEF +1." Max HP is 34, ATK 7, DEF 3, current HP increased by 4, level 2, XP 30 (or 24+6). Confirming the level-up message then returns to the map.
- [ ] P2 Rewards and a level-up are each granted once if Z is held. Two threshold crossings in one win (e.g. set XP to 29 and temporarily raise the Bandit reward, or set XP to 99 and grant enough) show one message per level, in order, then exit.
- [ ] P3 Defeat never lowers `level`. At the exact floor (level 2, XP 30) a defeat takes 0 XP. Below the next threshold, only 10% of the progress is lost (see B15).
- [ ] P4 Battle HUD shows `Lv` for each member. Command select still walks only living members; cancel still steps back to the previous member's command when more than one member is present.
- [ ] P5 Multi-member: set `DEBUG_ADD_FULL_ROSTER` (or `DEBUG_ADD_PLACEHOLDER_ALLY`) true and recompile. Active members pick Attack/Guard in party order; the enemy attacks a random *active* living member (name in the message). A KO'd active member is skipped in command select and cannot act. If they are KO'd before the enemy dies, they receive no XP for that enemy (even if they already acted); they keep credit only for enemies that died while they were still standing. If an active member is KO'd and later levels up from earlier credit, they stay at 0 HP. The reserve member does not appear in the command menu or as a target unless swapped in.
- [ ] P6 Four active members fit the battle HUD (four rows) and command order. `scr_party_add_member` returns false for a fifth *active* member. A fifth *joined* member goes to `global.game.reserve` (`scr_party_join`); a sixth join fails.
- [ ] P7 At `PARTY_MAX_LEVEL` (20), further XP does not raise the level or stats; XP stays at the level-20 floor (7410).
- [ ] P8 `global.game.inventory` starts empty. Equipment slots do not affect combat yet. Taren Holt's roster entry has `weapon_categories = ["heavy_sword"]` and `equipment.weapon = "bastard_sword"`; the others have empty weapon stubs and category lists matching their kit (longsword, dagger, spellbook, holy_sword).
- [ ] P9 `DEBUG_ADD_FULL_ROSTER`: active ids are kael, lyra, caelan, sera; reserve is taren. `scr_party_swap_active_reserve(0)` puts Taren in active slot 0 and Kael in reserve; swap again restores the original. `scr_save_state_collect()` reports those id lists and `save_schema_version` 0.
- [ ] P10 Participation XP and defeat (with `DEBUG_ADD_FULL_ROSTER`): if Taren stays on the bench the whole fight, a victory grants him **no** XP (check `reserve[0].xp`). If the party is wiped, no one receives the banked (or unbanked) XP — including members who had already acted. A defeat does **not** deduct Taren's XP, but does restore his HP if it was not full. If all four active members are KO'd, the battle is lost even if the reserve still has HP. Gold is still shared on a victory (and not granted on a defeat).
- [ ] P11 Mid-battle Swap (with `DEBUG_ADD_FULL_ROSTER`): while a reserve member is present, the command menu lists Attack, Guard, and Swap. With no reserve (default Kael-only party), Swap is hidden. Choosing Swap plays a swap message, costs that member's turn (they do not also attack), and replaces them with the reserve member in the same slot. The incoming member does not act until a later round (they get a command on the next ROUND_START if still living). After the swap, the outgoing member is not an enemy target; the incoming member can be.
- [ ] P12 After swapping Taren in and letting him take at least one later-round action (Attack or Guard) **before** the enemy dies, victory grants that enemy's XP to both the outgoing member (if they were still living when the enemy died) and to Taren. If you swap Taren in and the enemy dies later in the *same* round before Taren's first turn, Taren gets no XP; the outgoing member does if they are still living. If a member acts and is then KO'd **before** the enemy dies, they get no XP for that enemy.



## Enemy batches 7–8 (feature/enemy-batches-7-8; untested in GameMaker)
Start fights from the overworld with `scr_encounter_start(<id, group id, or array>, "test_x")`.
- [ ] E1 Each new id (`crown_sergeant`, `dock_thug`, `cutpurse`, `debt_collector`, `debtman`, `ward_sentinel`, `glyph_wisp`, `aethari_automaton`, `sanctuary_warden`, `garrison_pikeman`, `garrison_field_surgeon`, `garrison_knight`, `commander_hailen`, `shade_stalker`, `briar_hulk`, `lost_one`, `night_moth_swarm`, `door_warden`, `blackwood_matriarch`) starts a battle. Imported strips animate (idle, attack, hurt, death); missing ones draw a rectangle without stalling.
- [ ] E2 Backgrounds: Lower City, Sanctuary, Garrison and Blackwood enemies get their new backgrounds (or forest if not imported).
- [ ] E3 Cutpurse Steal takes gold (never below 0) and says how much. Beating the Cutpurse adds the stolen gold to the victory total.
- [ ] E4 Field Surgeon heals the most-hurt ally (green pop) only when one is below 60% HP.
- [ ] E5 Crown Sergeant Rally puts ATK-up icons on his allies. He never uses it alone.
- [ ] E6 `grp_sanctuary_warden` / `grp_blackwood_matriarch`: at 50% HP, `trans` plays once, the phase line shows, then `idle_p2` / `attack_p2` are used and the boss hits harder.
- [ ] E7 Commander Hailen dies (death strip, battle won) by default. With `scr_flag_set("flag_hailen_yields")` he yields instead (yield holds, `flag_hailen_yielded` set).
- [ ] E8 Night Moth Swarm: the dust flies on cast frame 3. Blind shows "Bl" and makes about half of physical attacks miss ("miss" pop). Sleep shows "Sl", skips the member's command and turn ("X is asleep."), and ends early when the member takes damage. Statuses wear off after their rounds.
- [ ] E9 Shade Stalker Fade: it turns translucent and physical attacks on it miss until the next round.
- [ ] E10 Glyph Wisp Mote flies on cast frame 3 and uses MDEF.
- [ ] E11 Chapter 1 and Chapter 2 fights are unchanged (B1–B8, BP1–BP7).

## Balance pass (feature/balance-pass; untested in GameMaker)
- [ ] BP1 Chapter 1 is unchanged: level-ups from 2 to 7 still show +4 HP / +1 ATK / +1 DEF, Chapter 1 enemy stats are unchanged, and a Blackguard run feels the same.
- [ ] BP2 Level-ups into 8, 9 and 10 show +10 HP, +2 ATK, +2 DEF, +3 MP. With the debugger, `scr_actor_raise_to_level(taren, 9)` gives Taren 80 max HP, ATK 21 with the Bastard Sword, and DEF 15 with the Travel Brigandine.
- [ ] BP3 Kael at level 8 (Blackguard's Longsword, Leather Armor, Iron Helm) beats `["crown_patrolman", "crown_crossbowman"]` and `["grey_ash_wolf", "grey_ash_wolf"]` without items. Occupation Soldiers take about 4–5 hits.
- [ ] BP4 Kael + Taren at level 9 beat `grp_reeve_calder` most of the time. Calder takes about 10–14 party turns.
- [ ] BP5 If Calder yields while a soldier stands, the soldier fades out, "The rest withdraw." shows, and the victory XP / gold totals include the soldier. XP goes only to members who took a turn and are standing.
- [ ] BP6 Ether from the bag on a member with MP restores up to 10 MP (refused when full, or when the member has no MP). The `shop_wrenfield_store` table lists Minor Potion, Antidote, Ether, Chain Mail.
- [ ] BP7 `scr_inn_offer("Perrin", INN_WRENFIELD_PRICE)` shows the price and the gold you have, then Rest / Leave. Up / down moves; X picks Leave. Rest with enough gold takes 30 g and fully restores HP and MP for the party and reserve. Without enough gold it says "Not enough gold." Leave does nothing.

## Battle upgrade (feature/battle-upgrade; untested in GameMaker)
Paste `scr_skill_data` and `scr_battle_system` as new scripts and re-paste the changed scripts and the three `obj_battle_controller` events (ROOM_SETUP.md §7). Use `DEBUG_ADD_FULL_ROSTER true` for the party cases. All numbers are PLACEHOLDER.
- [ ] B1 **Chapter 1 regression:** a single Bandit / Fallen Knight / Chapter 1 regular plays as before: Attack goes straight to the enemy (no target cursor with one enemy), the same "X attacks! Y takes N damage." lines, the same damage numbers (no buffs, no element), Guard halves the next hit until the next round, victory gold / XP and level-up lines are unchanged apart from the new MP / SPD numbers.
- [ ] B2 **Blackguard:** phases still trigger at 60% (270) and 20% (90) with the transition clips; the final death is the p3 strip; Shield Bash / Lunge / Oath / Execution lines and odds feel the same. Phase 3 now acts earlier in the turn order (canon SPD +30%).
- [ ] B3 **Multi-enemy:** `scr_encounter_start(["bandit", "bandit", "fallen_knight"], "test_multi")` from the overworld shows three enemies on the left half (no overlap with the party), labels "Bandit A" / "Bandit B", a mini HP bar over each, and the enemy list window. Attack opens a target cursor; up / down (or left / right) skips dead enemies; X goes back. Each enemy acts once per round. A killed enemy plays its death clip and fades. XP for each enemy is credited at its killing hit (check `pending_xp` in the debugger); gold is the sum over all three.
- [ ] B4 **Turn order:** in a mixed fight, faster actors (higher SPD) act first each round regardless of party order; ties vary slightly between rounds. A member KO'd before their turn is skipped. Swap still costs the member's turn, and the incoming member acts next round.
- [ ] B5 **XP rule unchanged:** the reserve gets nothing unless swapped in and has taken a turn; a member KO'd when an enemy dies gets nothing for that enemy; defeat grants no XP and still costs gold / XP and wakes the party in town.
- [ ] B6 **Skills / MP:** the Skill command appears only for members with skills (Taren). The Skill window shows MP cost and greys out unaffordable skills (confirm does nothing). Rallying Cry costs 4 MP and puts an ATK-up icon over every living party member for 3 rounds (cast round + 2); damage rises ~25%. Cleave costs 3 MP and hits every living enemy for ~60% damage in one clip. MP is shown in the party window, spent when the skill resolves, +2 after a victory, full after a defeat.
- [ ] B7 **Enemy AI:** Crown Patrolman mixes Attack / Thrust / Brace (Brace not repeated while active). Occupation Soldier mixes Attack / Slash / Guard (Guard halves the next hit on it). Crossbowman's bolt sprite flies from the crossbow on attack frame 3 (or at the hit if skipped).
- [ ] B8 **Reeve Calder:** `scr_encounter_start("grp_reeve_calder", "test_calder")` shows Calder (with a boss name plate and HP bar at top) plus 2 Occupation Soldiers. He uses Heavy Strike, Guard, and Rallying Shout (only while a soldier stands; ATK-up icons on the soldiers). When the last soldier falls he plays the stance clip once, "Reeve Calder takes a harder stance!" appears, and the idle switches to `idle_p2` if imported. At 0 HP he plays `yield` and holds the last frame (no death, no fade), the battle ends as a victory ("Reeve Calder yields."), `flag_reeve_calder_yielded` is true, and no Chapter 2 dialogue plays. If he yields while soldiers stand, they withdraw and give no XP / gold.
- [ ] B9 **Encounter tables:** Chapter 1 zones still roll single enemies only. `scr_get_encounter_table("ch2_millhaven_road")` / `"ch2_wrenfield"` return group entries (data only; no Act II rooms or zones exist yet).
- [ ] B10 **Saves:** a save written before this change (schema 1) still loads: every member gets level-scaled MP / SPD / MDEF and full MP, and Taren has Rallying Cry / Cleave. A new save writes `save_schema_version` 2 and keeps current MP. A schema 3+ file is still refused.
- [ ] B11 **Missing art:** with no Act II strips imported, every new enemy draws as a rectangle and turns never stall.

## Old Watchtower Ashbound Hunter (CHAPTER1_SCRIPT.md §4.1 / §6)
Setup: create `obj_story_encounter` with `spr_story_encounter_placeholder` (16×16 preferred; a larger placeholder is scaled to one tile). `scr_build_old_watchtower` already spawns one instance (`encounter_id` = `enc_ashbound_hunter_wt`) on walkable tile (33, 33), on the way to `old_royal_banner` (41, 25). The trigger and the banner each occupy one 16×16 tile. Do not also hand-place a second trigger on that tile. Dialogue IDs and speakers must match the script.
- [ ] W1 Walking onto the story tile plays `ENC_AH_01` (NARRATION: "An arrow slams into the dirt beside Kael's boot.") then `ENC_AH_02` (Kael: "That was a warning. Or a bad shot. Let's find out which."), then a battle against the Ashbound Hunter starts. The sequence does not start mid-dialogue or twice on one touch.
- [ ] W2 First victory (no parchment yet): after returning to the tile, `ENC_AH_03` (NARRATION), `ENC_AH_04` (Parchment, verbatim “Find the girl. The Varyn girl is still alive.”), and `ENC_AH_05` (Kael: "Alive." / "...Then who else is looking for her.") play. `flag_parchment_found` is true, `item_ashbound_parchment` is in `global.game.inventory` as a key item, and the story trigger is gone.
- [ ] W3 If `flag_parchment_found` is already true (set it in the debugger, or obtain the parchment from a rare fight first), the guaranteed fight still plays pre-dialogue and the battle, but `ENC_AH_03`–`05` do not play and a second parchment is not added. After victory the trigger is gone.
- [ ] W4 Defeat during the scripted fight uses the usual town wake-up and gold/XP penalty (B10/B15). The Watchtower trigger is **not** cleared; walking onto it again starts the fight (the parchment cannot be missed).
- [ ] W5 In a zone with `allow_ashbound_rare = true` (or `table_id` `zone01_old_road` / `zone01_bandit_camp` / `zone01_watchtower`, also the older short ids `old_road` / `bandit_camp` / `watchtower`), a random encounter can be the Hunter. Suggested debug: set `global.game.ashbound_rare_chance = 1` so the next random fight is always the Hunter. Same pre-dialogue; first victory gives the parchment and post lines; a later rare victory does not. The guaranteed Watchtower fight still occurs afterwards (see W3). Default chance is 0.04 (4%).
- [ ] W6 `zone01_path` and other areas without the rare flag never roll the Hunter from a random encounter (leave `ashbound_rare_chance` at 1 and walk only in `zone01_path` to confirm).
- [ ] W7 Standing on the story tile (or a fixed `obj_encounter_trigger`) does not also start a random fight. Input stays locked during pre- and post-fight dialogue.
- [ ] W8 In `rm_old_watchtower`, walk onto tile (33, 33) to start the Hunter fight. The tile is walkable and is not covered by a solid (including a 32×32 banner placeholder — the banner is at (41, 25) and is fitted to one tile). After the fight you can reach and inspect the banner.

## Sprites and 16×16 scale (pending owner approval; art untested in GameMaker)
Import per `game/sprites/IMPORT.md`. If you skip the import, S1 should still pass and later sprite checks are N/A.
- [ ] S1 The project compiles with no character PNGs imported: the player uses the IDE placeholder, battles use coloured rectangles, and Attack/Guard still resolve.
- [ ] S2 After importing Kael's 16×24 set and assigning `spr_kael_ow16_idle_down` to `obj_player`: standing shows the idle of the current facing; walking plays the 4-frame walk at about 8 fps; releasing the key returns to idle frame 0. Left uses the pre-mirrored sheet (the sprite is not flipped with `image_xscale`).
- [ ] S3 `depth = -y`: if you place a sign or wall so its origin is lower (larger y) than the player, the player draws behind it; when the player stands lower on the screen, he draws in front. Walking past a 16×16 solid, the head may overlap the tile above without catching on it (feet mask is the lower 16×16).
- [ ] S4 Collision still works against `obj_solid` and, if present, a 16×16 `Collision` tile layer: the player cannot walk through walls; diagonal sliding still works; the bbox clamp still keeps the mask in the room.
- [ ] S5 Move speed is 1 pixel per frame; facing a sign and pressing Z still opens dialogue (`interact_reach` 4). After a default-length walk in a zone, random encounters still occur (16 pixels = 1 step, 8–24 steps).
- [ ] S6 Battle: Kael (right, facing left) and the enemy (left, facing right) loop their idle strips. Attack plays the attack clip, the target plays hurt, then the damage message appears. A killing blow plays death instead of hurt and holds the last death frame through the victory or defeat line. Guard has no clip (idle remains). Pressing Z during the clip skips to the end and then shows the message; that same press must not also dismiss the message.
- [ ] S7 Fallen Knight attack (`spr_fallen_knight_attack_strip6`, 64×48, origin 32, 47): the feet stay planted at the same point as idle; the extra width reaches toward the party, not by sliding the whole body.
- [ ] S8 If only some battle sprites are imported, missing clips fall back to the rectangle and the battle still completes (no freeze in `ANIMATING`).
- [ ] S9 Optional camera: with Viewport 0 enabled (320×180 or 640×360) in a room larger than the view, the camera follows the player and stops at the room edges. With views disabled, the full room is shown and nothing errors.

## Zone 1 overworld and Old Watchtower (map delivery; untested in GameMaker)
Setup per `game/rooms/ROOM_SETUP.md` sections 4–6 (tileset `ts_zone1`, Included Files, room sizes, Creation Code, camera). Greyhaven is safe (no encounter zone). Default farmlands / road / camp / watchtower tables use only enemies already in `scr_get_enemy_data()`.
- [ ] Z1 `rm_overworld` is 6400×4800, loads without a crash, and draws terrain (not an empty room). First-load time is logged (`scr_build_overworld: … ms`). If the `.bin` files are missing, the chunk fallback still draws the map, or the debug log names the missing files.
- [ ] Z2 The camera follows the player and stops at the room edges. Starting position is the south road outside Greyhaven (199, 186 / 3192, 2992, facing north). `GH_ARRIVAL_01`–`03` play once and set `flag_arrived_greyhaven`; they do not replay after a battle return.
- [ ] Z3 Collision: the player cannot walk through palisades, water, or other Collision-tile solids; roads and Greyhaven streets are walkable. Tree canopy / gate arches on the Overhead layer draw above the player.
- [ ] Z4 Greyhaven itself never starts a random encounter, even after many steps. Walking the Farmlands, Old Road, or bandit-camp zones (after grace) can start a fight from that zone's table. Victory returns to the exact pre-battle position; the zone remains.
- [ ] Z5 Fixed triggers still work: `first_bandit` (tutorial) and the bandit camp / road spawns start their `encounter_id` once per victory (`cleared_encounters`). The Blackguard trigger in the Watchtower arena starts a **Blackguard** fight (not a silent Fallen Knight fallback); stats are placeholders.
- [ ] Z6 Signs use the confirmed Chapter 1 wording (`GH_GATE_SIGN`, `HC_SIGN_01`, `OR_SIGN_01`, `BC_SIGN_01`, `WT_SIGN_01`). The Bandit Camp sign's second line is struck through. Doors in Greyhaven enter the interiors (see I1–I6). Wenna, Dov and Corwin use `GH_SQUARE_01`, `GH_SQUARE_02`–`04`, and `GH_GATE_01_A` (or `GH_GATE_01_B`–`03_B` after the pendant). The old royal banner plays `WT_BANNER`. Renn is still a placeholder. A Fallen Knight `obj_story_npc` at the camp north exit plays `FK_01` and disappears; the one at the Watchtower stairs plays `FK_02`.
- [ ] Z7 Walking into the Old Watchtower entrance goes to `rm_old_watchtower` at `from_overworld`. The south exit returns to the overworld door. Other entrances (Valemere, Frostwilds settlement, coastal village, Crownveil breach, basement, …) show `[rm_… is not built yet.]` and do not crash.
- [ ] Z8 Defeat in a Zone 1, Watchtower, or basement fight still wakes the party at Greyhaven `town_square` (respawn point or 3192, 2832) with HP restored and the gold/XP penalty, not at the pre-battle tile or the south-road opening.
- [ ] Z9 The `locked_terrace_stairs` barrier blocks the shortcut until `flag_wt_upper_unlocked` is set by leaving the basement through `stairs_to_upper_level`. After that, the stairs are a walkable shortcut (same room, no extra entrance). The arena gate stays shut until `item_watchtower_key` is in the inventory; inspecting it plays `WT_DOOR_LOCKED`.
- [ ] Z10 After a victory in the overworld, Room Start restores the saved position and facing (map `player_start` must not win over the return point). After going through an entrance, `global.map_spawn_name` is honoured.
- [ ] Z11 On a new game, Kael starts at south-road `player_start` (199, 186 / 3192, 2992) and can walk immediately. He must not be stuck in an `obj_solid`. If you temporarily place a solid on the spawn tile, `scr_player_unstick()` nudges him to a free pixel and movement works.
- [ ] Z12 Farmlands random fights are Bandits and Ash Wolves (PLACEHOLDER stats; rectangles if no sprite). Old Road adds Ashen Wretches, plus the rare Ashbound Hunter roll. Fallen Knights appear in the Bandit Camp, Watchtower, and Basement hall only — never as a Farmlands / Old Road fallback.
- [ ] Z13 New tiles are visible where Design placed them: pallet under Tomas, Mira's bed rubble under the pendant, royal banner in the Watchtower, weathered signposts, crown-and-sun carvings. Re-import `ts_zone1.png` if an older tileset is already in the IDE.

## Interiors, basement, doors, and keyed barriers (untested in GameMaker)
Create the rooms in `game/rooms/ROOM_SETUP.md` sections 6a–6b. Use confirmed Chapter 1 strings only; do not accept Chapter 2 `[PROPOSED]` lines.
- [ ] I1 Each Greyhaven door (`door_varyn_house`, `door_rusted_boar_tavern`, `door_greyhaven_chapel`, `door_blacksmith`, `door_general_store`) enters the matching interior at `from_overworld`. Walking out `to_overworld` returns to that same door. You are not stuck in a solid after either transition.
- [ ] I2 Varyn House: the table and beam play `GH_HOUSE_01` / `GH_HOUSE_02`. The pendant plays `GH_HOUSE_03`–`05`, adds `item_mira_pendant` as a key item, sets `flag_pendant_found`, and is gone afterwards. The North Gate barrier then disappears (leave and re-enter the overworld if you had it loaded).
- [ ] I3 Blacksmith: talking to Tomas or Pell plays `GH_TOMAS_01`–`08` and sets `flag_met_tomas`. Repeat: `GH_TOMAS_R1` / `R2`. After the pendant, Pell's repeat line is `GH_SMITH_01_B`, then the forge shop opens (Iron Sword, Leather Armor, Iron Helm). Before the pendant, talking to Pell must not open the shop.
- [ ] I4 Tavern, chapel, store: Hob / Sister Ilse / Marda play `GH_TAVERN_01`–`04`, `GH_CHAPEL_01`–`03`, `GH_STORE_01`–`03`. After Marda's lines the general-store shop opens (Minor Potion, Antidote). The cellar hatch is closed. A save point exists in the chapel and the tavern and opens the save panel.
- [ ] I5 Wenna, Dov, and Corwin play their Chapter 1 lines. Before the pendant, Corwin is `GH_GATE_01_A` and the gate is blocked; after, he is `GH_GATE_01_B`–`03_B` and the gate is open.
- [ ] I6 `rm_watchtower_basement` loads, the stairs return to the tower, and the upper hatch arrives at `from_basement` while setting `flag_wt_upper_unlocked`.
- [ ] I7 Trap hall: walking only on sigil stones crosses safely. Stepping on a plate plays `WT_TRAP_01`, deals ~10% max HP to living active members (HP never 0), knocks the player back, and will not fire again on that plate.
- [ ] I8 The spider-nest chest adds `item_watchtower_key` to the inventory (`WT_KEY_01`). The mural plays `WB_CARVING_01`–`05` and sets `flag_carvings_seen`. Placeholder chest loot (`watchtower_chest_*`, `hidden_grove_chest`) must **not** invent items; listed loot (camp chests, `basement_chest_hall`) is granted.
- [ ] I9 With the key, the arena gate opens. Walking in plays `BG_INTRO_01`–`05` once, then the Blackguard fight starts. Victory sets `blackguard_defeated`, grants the Longsword and Crownveil Fragment, and plays `BG_DEFEAT` / `BG_REWARD_01`. Defeat uses the usual town wake-up; the intro flag may already be set, but the boss trigger remains until a victory.
- [ ] I10 The Crownveil door stays sealed until `blackguard_defeated`, then plays `CV_END_01`–`06`, sets `flag_chapter1_complete`, and opens a "Save your progress?" prompt into the three-slot save panel. No Chapter 2 `[PROPOSED]` line appears.


## Chapter 1 art (untested in GameMaker)
Create `rm_title`, import sprites from `game/sprites/IMPORT.md` (Chapter 1 section), and enable nine-slice / the 640 texture group as documented. Missing sprites must not crash (rectangles, placeholder objects, or the default font). Do not accept Chapter 2 `[PROPOSED]` lines.
- [ ] A1 Project compiles after `rm_title` exists and is first in Room Order. `scr_ui_init` locks the GUI to 320×180. Interpolation is off.
- [ ] A2 Title: parallax layers drift at 0 / −0.05 / −0.1 / −0.2, the ember loop plays at 12 fps, the logo fades in, and "Press any key" advances to the menu. Options: New Game, Continue (disabled with no `save1.sav`–`save3.sav`, skipped by the cursor), Options (placeholder panel), Quit.
- [ ] A3 New Game enters `rm_overworld`. Kael, NPCs, and chests use the imported 16×24 / chest sprites and y-sort (`depth = -y`). Tomas uses the pallet lying loop and switches to `lying_awake` while his dialogue is open.
- [ ] A4 Talking to Tomas, Pell, Renn, Hob, Ilse, Marda, Wenna, Dov, Corwin, and the Fallen Knight story NPC shows the correct overworld sprite. Dialogue with Kael / Tomas / Pell / Renn / Fallen Knight shows the 48×48 portrait. Other speakers have no portrait and still render text.
- [ ] A5 I / Tab opens the field inventory (dither, Items/Equip/Key tabs, party pane, gold). Q/E (or left/right on Items/Key) cycle tabs. Z on a Minor Potion opens the target picker (PLACEHOLDER 15 HP). The Equip tab shows Weapon / Armor / Helm / Accessory; Iron Helm uses Helm. Key items use the key icon and cannot be used or sold. X / I closes the menu. Input stays locked while it is open. Marda and Hob portraits appear in their dialogue (and Marda / Pell in the shop header).
- [ ] A6 Overworld chests use wood sprites; Watchtower / basement chests use iron. Opening plays the 3-frame strip once and grants the listed loot (or stays a placeholder if the loot is flagged as such).
- [ ] A7 Encounter triggers and the Watchtower Hunter show the matching overworld enemy (or Blackguard) sprite when imported. A missing sprite still starts the fight.
- [ ] A8 Battle: area background (Greyhaven / forest / bandit camp / Watchtower / Blackguard arena), party on the right flipped (`xscale = -1`), enemies on the left facing right, nine-slice command / HP windows, gauntlet cursor, bitmap font, HP bars (colour shifts under 50% / 25%), Guard status icon, floating damage digits. Z still skips clips. Missing strips fall back to rectangles and do not stall `ANIMATING`.
- [ ] A9 New enemies play their battle strips (Wolf howl, Wretch scream, Hunter arrow visual, Spider web + spiderlings visual-only, Hollow Soldier guard). Stats stay the placeholder values.
- [ ] A10 Blackguard starts in Phase 1 (450 HP). At 270 HP the `p1to2` transition plays once and the Phase 2 set (no shield; Ash Slash / Dark Lunge / Blood Oath) takes over. At 90 HP `p2to3` plays and Phase 3 (Execution) starts. A killing blow plays `p3_death` even if earlier phases were skipped. Victory grants 250 XP, 100 Gold, the Longsword, and the Crownveil Fragment. The Phase 1 death strip is not used in the live fight.
- [ ] A11 Continue is enabled when any slot file exists and opens the load panel (location, lead level, playtime, gold). A missing or damaged file is listed as empty / damaged and must not crash. New Game starts a fresh `global.game`. Options is visual only. A 640 ember strip that was not given a large Texture Group must not crash — skip it or use the 320 fallback.
- [ ] A12 No Chapter 2 `[PROPOSED]` dialogue appears anywhere in this pass.

## Menus, saves, and shops (untested in GameMaker)
Create the new objects and scripts in `game/README.md`. Menu layout lives in `scr_menu_layout.gml`. Dedicated shop / save / inventory art is not required; nine-slice windows and the title save panel are the fallbacks.
- [ ] S1 Title Continue is disabled with no slot files and skipped by the cursor. After a save exists, Continue opens the load panel. Slot rows show location, lead level, playtime, and gold. Loading a valid slot restores the party, inventory, gold, flags, room, and position. New Game does not keep the previous run's state.
- [ ] S2 A missing file is "Empty". A truncated or edited-garbage `.sav` is "Damaged save" and does not crash or apply half a load.
- [ ] S3 Talking to a chapel or tavern save point plays `spr_save_point_activate_strip8` once (12 fps), then opens the three-slot Save panel (leader frame, location, level, party icons, clock, gold). Saving writes `saveN.sav`, closes the panel, and shows the "Saved!" toast (`spr_ui_toast_saved` at (160, 8)). Overwrite confirm defaults to **No**. Close with X. The player cannot move while the panel is open.
- [ ] S4 After `CV_END_01`–`06`, the same Save slot panel opens. `flag_chapter1_complete` is set even if the player cancels.
- [ ] S5 With `#macro DEBUG_SAVE_ANYWHERE true`, F5 opens the save panel on the overworld (not the title or battle). With the macro false (default), F5 does nothing.
- [ ] S6 Marda: `GH_STORE_01`–`03`, then the shop (dither, header portrait, gold / owned, Buy/Sell/Exit tabs 12px above the list window). Left/right switches tabs; Exit + Z (or X) closes. Unaffordable rows use the greyed icon, disabled select bar, and do nothing on confirm. Quantity (consumables only) is up/down ±1, left/right ±10, max = min(99 − owned, floor(gold/price)). Input is locked.
- [ ] S7 Pell: shop opens only after `flag_pendant_found` and `GH_SMITH_01_B`. Stock is Iron Sword, Leather Armor, Iron Helm. The info pane shows party icons, new ATK / DEF, and stat arrows (or "Can't use"). Buying and equipping from the Equip tab changes battle stats. Helm is a real slot (Iron Helm); Accessory may be empty.
- [ ] S8 Sell is 50% (PLACEHOLDER, floored, minimum 1). Key items appear on the Sell list as disabled rows ("--" plus the key icon) and cannot be sold. Selling a non-key item removes it and adds gold.
- [ ] S9 Quit to the desktop (or restart the game) and Continue: HP, levels, XP, gear, gold, inventory, flags, room, position, facing, and playtime all match the save. A loaded position is un-stuck if it slightly overlaps a solid.
- [ ] S10 Status, party order, and the Bestiary are still not implemented.

## Chapter 2 (feature/chapter2; untested in GameMaker)
Set up the rooms with `game/rooms/ROOM_SETUP.md` §6c and import the art with `game/sprites/IMPORT.md` ("Chapter 2"). Every line must match `docs/story/CHAPTER2_SCRIPT.md` word for word.
- [ ] C1 **Wake-up.** Finish Chapter 1 (`CV_END`), then save or cancel. `CV_WAKE_01`–`04` and `WT2_BACK_01` play once and `flag_act2_started` is set. Loading a save made at the Chapter 1 prompt plays them again on arrival. Examining the door now plays `CV_WAKE_06`. The arena centre (where the Blackguard fell) plays `CV_WAKE_05` (an invisible inspect spot for now). The banner plays `WT2_BANNER_R1`.
- [ ] C2 **Greyhaven (optional).** Before Act II nothing changes. After it, the Act II lines play: Tomas `GH2_TOMAS_01` (repeat `_R1`); Pell `GH2_PELL_01`–`05` (repeat `GH2_PELL_R1`, then the forge shop); Hob, Ilse, Wenna, Dov and Corwin play their GH2 lines; Marda plays `GH2_MARDA_01`, then the shop. Pell or Corwin sets `flag_hook_taren`.
- [ ] C3 **Overworld.** The south branch off the Veil Road and the fork sign are painted. The entrance at tile (303,184) shows "Crown checkpoint. No passage south without the Reeve's leave." before Act II and opens `rm_millhaven_road` after it. Walking back out of the road lands on the entrance tile and does not bounce.
- [ ] C4 **Millhaven Road.**
  - `MR_ENTER_01` plays once on entry and sets `flag_mr_entered`.
  - The traveler plays `MR_HOOK_01`–`05`, then `MR_HOOK_R1`.
  - Signpost, Crown notice (backup hook) and Architect stones (`MR_STONE_01`–`02`) all play.
  - Random battles use `ch2_millhaven_road` (no groups larger than 2).
  - The patrol plays `MR_PATROL_01`–`03`, then Fight / Move along. Move along waves you through, and the patrol is gone on re-entry. Fight starts 2 Crown Patrolmen, and they are gone after you win.
  - The Ether chest in the east clearing (tile 25,24) gives 1 Ether once.
- [ ] C5 **Wrenfield before.**
  - Entry sets `flag_wrenfield_entered`. The sergeant stops you once (`WF_GATE_01`–`03`, `flag_wf_gate_seen`), then repeats `WF_GATE_A1`.
  - The posted list, both soldiers, Perrin (`WF_TAVERN_A1`–`A3`, chairs up) and Len outside (`WF_STORE_A1`) all play.
  - The store door says `WF_STORE_SHUT`. The west road says "Crown checkpoint. West road closed by order of the Reeve."
  - No random battles in the village.
- [ ] C6 **Oda.** `WF_ODA_A1`, then Accept? Yes / No. Yes plays `A3_YES` (and again on repeat talks). No plays `A4_NO`, and she offers again next time.
- [ ] C7 **Gallows.**
  - Walking into the square (or touching Taren) plays `WF_GALLOWS_01`–`07`.
  - On `_07`, the right rope swaps to the cut tile and Bram drops to the bound idle pose. The inn and store stay shut.
  - `WF_GALLOWS_08` and `WF_CALDER_INTRO_01`–`07` play, then `WF_CALDER_SYS_01`–`03B`.
  - Taren is now in party slot 2 at Kael's level with full HP / MP and the Travel Brigandine. The fight starts with Calder and 2 Occupation Soldiers on the Greyhaven background.
- [ ] C8 **Calder fight.**
  - Taren's sprites: idle, attack and hurt; Guard holds `defend` until the next command phase; Rallying Cry plays `skill_rally`; Cleave plays `skill_cleave`.
  - The first Rallying Cry adds `WF_CALDER_SYS_04` to the message (once per save).
  - When both soldiers fall, the stance message is Calder's bark `Reeve Calder: "Hold, then. I'll finish this myself."` instead of the system line.
  - At 0 HP he yields. The victory message starts with `Reeve Calder: "Enough. I'll not spend another man on this square."`, plus "The rest withdraw." if a soldier was still standing.
- [ ] C9 **After the win.**
  - Back in the square, now in the after state (inn lit, store open, rope cut, villagers, Oda and Bram), `WF_CALDER_DEFEAT_02`–`05`, `WF_CALDER_REWARD_01` and `WF_JOIN_01`–`12` play.
  - `flag_execution_stopped` and `flag_taren_recruited` are set. Taren is not added a second time.
  - Taren stands by Oda (`WF_JOIN_R1`).
- [ ] C10 **Loss to Calder.** You wake in town as usual. Re-entering Wrenfield shows the cut rope, plays `WF_CALDER_INTRO_07` and restarts the fight. Taren is still in the party.
- [ ] C11 **Wrenfield after.**
  - Sergeant `WF_GATE_B1`, soldiers `WF_SOLDIER_B1` / `B2`.
  - Perrin `WF_TAVERN_B1`, then Rest (30 g) / Leave. Rest restores HP and MP for both members. Not enough gold says so.
  - Len's store: `WF_STORE_B1`, then the shop (Minor Potion, Antidote, Ether, Chain Mail).
  - Oda: `WF_ODA_B1` + `B2` gives Minor Potion ×2 and 40 Gold once, whether or not she was spoken to before. Bram: `WF_ODA_B3`, then `WF_BRAM_B1`.
- [ ] C12 **West road.**
  - Before the fight the barrier blocks it. After the fight it opens.
  - Walking out plays `WF_HANDOFF_01`–`05` and "To be continued.", sets `flag_chapter2_complete`, lands on the overworld `from_wrenfield_west` spawn east of Valemere and opens the save panel.
  - A second exit just travels.
- [ ] C13 Portraits: Taren, Perrin, Len, Oda (worried / pleading / relieved), Bram (shaken) and Calder (stern / weary) show the expression set in the dialogue data.
- [ ] C14 Save in the Bent Post era (any save point / F5 debug), reload: flags, Taren in the party, room state (before / after) all match.

Record GameMaker version, date, result, and reproducible failures.