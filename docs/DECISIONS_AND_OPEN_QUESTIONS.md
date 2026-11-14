# Decisions and Open Questions

## Confirmed
- Working title: ASHEN CROWN; GameMaker/GML.
- Dark medieval fantasy RPG; top-down classic JRPG exploration, not side-view.
- Protagonist: Kael Varyn; tragic backstory planned, details not locked as canon.
- Tone: atmospheric and serious with some lighthearted moments.
- Classic menu-driven turn-based combat; planned four-person battle party.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- No automatic enemy level scaling by default.
- Planned menu: equipment, party order, items, save/load, status, Bestiary.

## Owner-decided (2026-11-14)
- Defeat: when the party loses a battle, they wake up back in town with HP fully restored. Until a town room exists, the respawn target is `TOWN_RESPAWN_ROOM` (currently `rm_overworld`), at `obj_respawn_point` if one is placed, otherwise at `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y`. A short placeholder wake-up dialogue is shown through the existing dialogue box and reports the gold and XP lost.
- Defeat penalty: lose `DEFEAT_GOLD_LOSS_PCT` of current shared gold (floored) and `DEFEAT_XP_LOSS_PCT` of each member's XP progress toward the next level (`floor((xp - scr_xp_for_level(level)) * 0.1)`), never causing a level-down or a negative total. Defaults are 50% gold and 10% of progress; exact percentages are pending tuning.
- Random encounters: classic JRPG walking encounters using a randomized steps-until-encounter counter (distance-based). Steps count only while the player is actually moving and input is not locked, after a grace period following battle or room entry. Per-area tables (an `obj_encounter_zone` and/or a room table in `scr_encounter_tables`) pick a weighted enemy from `scr_enemy_database`. Towns and other rooms with no table are safe. `obj_encounter_trigger` remains for fixed boss/story fights. Encounter rates are pending tuning (defaults: 32 pixels per step, 8–24 steps between fights, 5 grace steps).

## Still undecided
GameMaker version; room resolution and tile size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; save schema; license/proprietary status; exact defeat gold/XP percentages (defaults 50% gold / 10% of XP-to-next-level, pending tuning); whether a defeat should also deduct items; exact random-encounter rates and table weights (defaults 8–24 steps, 5 grace, 3:1 Bandit/Fallen Knight); XP curve, max level, and level-up stat growth (placeholder defaults below); whether KO'd members receive XP; whether the reserve member earns XP (defaults: yes, 100% share, pending); whether the defeat penalty should also hit the reserve; whether story events lock or force party slots. Treat these as open questions, not approved requirements.

## Prototype assumptions (party + progression; pending owner approval)
These were chosen so roadmap step 4 could be built. None is a locked design decision.
- Party roster (coder note from STORY_BIBLE.md, confirmed 2026-11-14): five permanent members — Kael (Vanguard), Lyra (Rogue), Caelan (Arcanist), Sera (Warden), Taren Holt (Rebel Captain, Broken Yoke). Four fight at a time; one reserve slot. Array order of `global.game.party` is battle command and turn order. Default run: Kael only has joined; the other four exist on `global.game.roster` but are not in a slot. `DEBUG_ADD_FULL_ROSTER` puts Kael/Lyra/Caelan/Sera in active and Taren in reserve.
- Reserve XP: `RESERVE_EARNS_XP` defaults to true with `RESERVE_XP_SHARE` 1.0 (pending owner approval). Defeat *check* and the defeat gold/XP *penalty* apply to active members only (assumption). Reserve HP is still restored on a defeat.
- Placeholder roster stats (pending approval, not canon): Lyra 24/7/1, Caelan 22/8/1, Sera 28/4/4, Taren Holt 36/8/3 (warrior-leaning). Taren's `weapon_categories` is `["heavy_sword"]` and his equipment stub starts with `bastard_sword`. Skills are placeholders. Equipment bonuses are not applied yet.
- Each member has their own `level` and `xp`. Gold is still a shared party total. `global.game.xp` mirrors Kael's (`party[0]`) XP for the debugger.
- XP curve (total XP to *be* level L): `20*(L-1)^2 + 10*(L-1)`. L1=0, L2=30, L3=100, L4=210, L5=360, L10=1710, L20=7410 (cap 20).
- On level-up: +4 max HP, +1 ATK, +1 DEF (placeholder). Living members also gain the HP increment as current HP; KO'd members stay at 0 HP.
- Victory XP is granted to every active party member (including KO'd). If `RESERVE_EARNS_XP` is true, the reserve also receives `floor(reward * RESERVE_XP_SHARE)`. Each member who crosses a threshold (active or reserve) shows a level-up message after the victory line.
- Equipment slots (`weapon`, `armor`, `accessory`) and `global.game.inventory` exist as empty placeholders; menus, items, and equipment bonuses are roadmap step 5.

## Prototype assumptions (exploration + battle prototype; pending owner approval)
These were chosen so roadmap steps 2–3 could be built. None is a locked design decision.
- Battle presentation: dedicated room `rm_battle_test` rather than an overlay.
- Input: arrows move; Z/Enter/Space confirm; X/Backspace cancel. Diagonal movement kept from the original snippet.
- Collision: `obj_solid` objects plus an optional tile layer named `Collision`; requires GameMaker 2023.1+.
- Placeholder sizes: player 32×48 with a feet-sized mask, 32×32 placeholders, 640×360 rooms.
- Party defaults and progression numbers: see "Prototype assumptions (party + progression)" above. Guard still halves incoming damage (min 1) until the party's next command phase.
- Fixed `obj_encounter_trigger` encounters are removed after victory for the session. Whether cleared triggers persist in saves is undecided. Random walking encounters are owner-decided (see above); they are not cleared after victory.
- Enemy HP is visible in battle for debugging; whether players see enemy HP is undecided.
- Sign text and battle messages are placeholders, not canon.
