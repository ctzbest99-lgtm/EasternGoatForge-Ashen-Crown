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
- Defeat: when the party loses a battle, they wake up back in town with HP fully restored. Until a town room exists, the respawn target is `TOWN_RESPAWN_ROOM` (currently `rm_overworld`), at `obj_respawn_point` if one is placed (the overworld builder drops one at Greyhaven `player_start`), otherwise at `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` (2984, 2752). A short placeholder wake-up dialogue is shown through the existing dialogue box and reports the gold and XP lost.
- Defeat penalty: lose `DEFEAT_GOLD_LOSS_PCT` of current shared gold (floored) and `DEFEAT_XP_LOSS_PCT` of each member's XP progress toward the next level (`floor((xp - scr_xp_for_level(level)) * 0.1)`), never causing a level-down or a negative total. Defaults are 50% gold and 10% of progress; exact percentages are pending tuning.
- Random encounters: classic JRPG walking encounters using a randomized steps-until-encounter counter (distance-based). Steps count only while the player is actually moving and input is not locked, after a grace period following battle or room entry. Per-area tables (an `obj_encounter_zone` and/or a room table in `scr_encounter_tables`) pick a weighted enemy from `scr_enemy_database`. Towns and other rooms with no table are safe. `obj_encounter_trigger` remains for fixed boss/story fights. Encounter rates are pending tuning (defaults: 16 pixels per step, 8–24 steps between fights, 5 grace steps).
- Ashbound parchment (Chapter 1, approved 2026-11-14): the first Ashbound Hunter fight in the Old Watchtower is a guaranteed scripted encounter (`enc_ashbound_hunter_wt`), so the parchment cannot be missed. The rare 3–5% random Hunter stays on the Old Road, Bandit Camp, and Watchtower. If the parchment was already obtained from a rare fight (`flag_parchment_found`), the guaranteed fight still happens but the pickup and post-fight lines (`ENC_AH_03`–`05`) are skipped.

- Battle XP (2026-11-14): when an enemy dies, its XP is credited to each party member who has already participated (taken at least one turn: Attack, Guard, or Swap) **and** is not KO'd at that moment. Credit is accumulated per member (`pending_xp`) and applied at victory, including level-up messages. If the party loses, no XP is granted. Gold stays shared. A reserve/bench member who swapped in and has taken a turn counts from then on, but gets no credit for enemies that died before their first turn. A member KO'd before an enemy dies gets no XP for that enemy, but keeps credit for enemies that died while they were still standing. A mid-battle Swap command lets an active member switch with the reserve; it costs that member's turn, and the incoming member acts on later rounds.

## Still undecided
GameMaker version; room resolution and whether 640×360 stays (height is not a multiple of 16) or is replaced by a 16-aligned size (e.g. 640×368, 320×180 with a 2× window, or 256×224); camera / view size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; save schema; license/proprietary status; exact defeat gold/XP percentages (defaults 50% gold / 10% of XP-to-next-level, pending tuning); whether a defeat should also deduct items; exact random-encounter rates and table weights (defaults 8–24 steps, 5 grace, 3:1 Bandit/Fallen Knight); Ashbound Hunter placeholder stats and rare rate (default 4%, midpoint of 3–5%); whether a defeat during the scripted Watchtower Hunter fight should consume the trigger (currently it does not, so the parchment cannot be missed); whether that scripted fight should grant regular XP/gold (currently yes, using the same per-enemy living-participant rule); XP curve, max level, and level-up stat growth (placeholder defaults below); whether the defeat penalty should also hit the reserve; whether story events lock or force party slots. Treat these as open questions, not approved requirements.

## Prototype assumptions (party + progression; pending owner approval)
These were chosen so roadmap step 4 could be built. None is a locked design decision.
- Party roster (coder note from STORY_BIBLE.md, confirmed 2026-11-14): five permanent members — Kael (Vanguard), Lyra (Rogue), Caelan (Arcanist), Sera (Warden), Taren Holt (Rebel Captain, Broken Yoke). Four fight at a time; one reserve slot. Array order of `global.game.party` is battle command and turn order. Default run: Kael only has joined; the other four exist on `global.game.roster` but are not in a slot. `DEBUG_ADD_FULL_ROSTER` puts Kael/Lyra/Caelan/Sera in active and Taren in reserve.
- Defeat *check* and the defeat gold/XP *penalty* apply to active members only (assumption). Reserve HP is still restored on a defeat. Battle XP is owner-decided (see above): participation only.
- Placeholder roster stats (pending approval, not canon): Lyra 24/7/1, Caelan 22/8/1, Sera 28/4/4, Taren Holt 36/8/3 (warrior-leaning). Taren's `weapon_categories` is `["heavy_sword"]` and his equipment stub starts with `bastard_sword`. Skills are placeholders. Equipment bonuses are not applied yet.
- Each member has their own `level` and `xp`. Gold is still a shared party total. `global.game.xp` mirrors Kael's (`party[0]`) XP for the debugger.
- XP curve (total XP to *be* level L): `20*(L-1)^2 + 10*(L-1)`. L1=0, L2=30, L3=100, L4=210, L5=360, L10=1710, L20=7410 (cap 20).
- On level-up: +4 max HP, +1 ATK, +1 DEF (placeholder). Living members also gain the HP increment as current HP; KO'd members stay at 0 HP.
- When an enemy dies, its XP is banked to members who have already taken a turn and are still living. A KO'd member does not receive that enemy's XP, even if they acted earlier; they keep any credit from enemies that died before they fell. A reserve member who swapped in and has taken a turn is eligible for later kills only. Banked XP is applied at victory (level-up messages still play). A defeat grants no XP. Gold is still shared among the party.
- Equipment slots (`weapon`, `armor`, `accessory`) and `global.game.inventory` exist as empty placeholders; menus, items, and equipment bonuses are roadmap step 5.


## Prototype assumptions (Zone 1 overworld + sprites; pending owner approval)
These were chosen so Design's map and art could be wired into the existing prototype. None is a locked design decision.
- `rm_overworld` is the 400×300-tile Eldara hub (6400×4800 px) including Zone 1 "The Ashen Road" and Greyhaven. `rm_old_watchtower` is 60×45 tiles (960×720). Tile size is 16×16 (`TILE_SIZE`). The old 640×360 test layout is retired.
- Overworld uses the 16×24 Kael / Bandit sheets on that 16×16 grid. `PLAYER_MOVE_SPEED` is 1 (same tiles per second as the earlier speed of 2 on 32 px tiles). `PLAYER_INTERACT_REACH` is 4. Encounter steps are 16 pixels so "8–24 steps" still means 8–24 tiles.
- Town respawn is Greyhaven `player_start` (2984, 2752). The builder also drops `obj_respawn_point` there.
- Y-sort with `depth = -y`. Overworld `left` is a pre-mirrored sheet; `image_xscale` stays 1. Battle party members are flipped with `xscale = -1` because battle strips only face right.
- Battle playback: idle 6 fps, attack/hurt/death 10 fps, drawn in Draw GUI at `BATTLE_SPRITE_SCALE` 2. Damage is applied at about 60% through the attack clip; a KO plays death instead of hurt and holds the last frame. Confirm skips the clip. There is no Guard pose in the art.
- Camera view 320×180, optionally displayed at 2× (640×360 window). `CAMERA_FOLLOW_PLAYER` is on. `scr_camera_follow_player` is defined once in `scr_map_tilemaps.gml` and called from `obj_game_controller` End Step. Overhead tiles use depth -10000 so they stay above a player that y-sorts with `depth = -y`.
- Greyhaven is safe (no encounter zone, no room-wide table). Other areas use the existing `obj_encounter_zone` API with tables `zone01_farmlands`, `zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`, falling back to `zone01_path`.
- Blackguard placeholder stats: 80 HP, 12 ATK, 8 DEF, 50 XP, 30 gold. Not balanced.
- Entrances to rooms that are not built yet (`rm_valemere`, `rm_frostwilds_settlement`, `rm_coast_village`, `rm_watchtower_basement`, `rm_ashlands_breach`, and others) only show a placeholder dialogue line.
- A story-flag system and key-item inventory helpers exist (`scr_flag_get` / `scr_inventory_add`). Tomas / pendant / Crownveil scenes are not implemented yet; inspecting those markers still shows placeholder text. The locked terrace stairs are a blocking `obj_interactable` (`watchtower_basement_cleared` is named but not yet enforced in code).
- The guaranteed Ashbound Hunter fight (`enc_ashbound_hunter_wt`) is spawned in `rm_old_watchtower` on walkable tile (41, 24), immediately in front of `old_royal_banner` (41, 25). Rare Hunter rolls are allowed on `zone01_old_road`, `zone01_bandit_camp`, and `zone01_watchtower` (short ids `old_road` / `bandit_camp` / `watchtower` still work).
- Bandit overworld sheets are in the repo but not used by any object yet. There is no Fallen Knight overworld sheet. Battle assets are named `spr_hero_*`; overworld Kael is `spr_kael_ow*`.

### Placeholders still waiting on Kevin (story bible Open, or not implemented)
- Names of the Frostwilds settlement and the Drowned Coast village.
- The pendant / Crownveil symbol (banner and sealed door; no symbol is drawn).
- Where the Tomas Varyn scene happens (his NPC marker beside Varyn House is only a suggestion) and the Fallen Knight story beat.
- Sign text (`sign_greyhaven`, `sign_bridge`, `sign_watchtower`, `sign_grounds`).
- Several chest loots (`hidden_grove_chest`, `watchtower_chest_2`, `watchtower_chest_3`).
- What lies past the Crownveil breach.
- Stats for Blackguard and for missing bestiary entries (Ash Wolves, Ashen Wretches, Grave Spiders, Hollow Soldiers, Ashbound Hunter).

## Prototype assumptions (exploration + battle prototype; pending owner approval)
These were chosen so roadmap steps 2–3 could be built. None is a locked design decision.
- Battle presentation: dedicated room `rm_battle_test` rather than an overlay.
- Input: arrows move; Z/Enter/Space confirm; X/Backspace cancel. Diagonal movement kept from the original snippet.
- Collision: `obj_solid` objects plus an optional tile layer named `Collision`; requires GameMaker 2023.1+.
- Placeholder sizes: player **16×24** (FF1-scale overworld, origin 8, 23) with a 16×16 standing-tile feet mask; room placeholders 16×16; rooms still **640×360**. 360 is not a multiple of 16 (22 tiles + 8 px). Battle battlers stay 32×48 side-view strips (death 48×48; Fallen Knight attack 64×48). A 32×48 overworld set exists as a fallback only.
- Party defaults and progression numbers: see "Prototype assumptions (party + progression)" above. Guard still halves incoming damage (min 1) until the party's next command phase.
- Fixed `obj_encounter_trigger` encounters are removed after victory for the session. Whether cleared triggers persist in saves is undecided. Random walking encounters are owner-decided (see above); they are not cleared after victory.
- Enemy HP is visible in battle for debugging; whether players see enemy HP is undecided.
- Sign text and battle messages are placeholders, not canon.
