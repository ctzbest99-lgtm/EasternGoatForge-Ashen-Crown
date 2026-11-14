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
- Random encounters: classic JRPG walking encounters using a randomized steps-until-encounter counter (distance-based). Steps count only while the player is actually moving and input is not locked, after a grace period following battle or room entry. Per-area tables (an `obj_encounter_zone` and/or a room table in `scr_encounter_tables`) pick a weighted enemy from `scr_enemy_database`. Towns and other rooms with no table are safe. `obj_encounter_trigger` remains for fixed boss/story fights. Encounter rates are pending tuning (defaults: 16 pixels per step, 8–24 steps between fights, 5 grace steps).

## Still undecided
GameMaker version; room resolution and whether 640×360 stays (height is not a multiple of 16) or is replaced by a 16-aligned size (e.g. 640×368, 320×180 with a 2× window, or 256×224); camera / view size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; save schema; license/proprietary status; exact defeat gold/XP percentages (defaults 50% gold / 10% of XP-to-next-level, pending tuning); whether a defeat should also deduct items; exact random-encounter rates and table weights (defaults 8–24 steps, 5 grace, 3:1 Bandit/Fallen Knight); XP curve, max level, and level-up stat growth (placeholder defaults below); whether KO'd members receive XP. Treat these as open questions, not approved requirements.

## Prototype assumptions (party + progression; pending owner approval)
These were chosen so roadmap step 4 could be built. None is a locked design decision.
- Party: up to four members; array order is battle command and turn order. Default party is Kael only. A debug flag `DEBUG_ADD_PLACEHOLDER_ALLY` can add a non-canon second member for testing.
- Each member has their own `level` and `xp`. Gold is still a shared party total. `global.game.xp` mirrors Kael's (`party[0]`) XP for the debugger.
- XP curve (total XP to *be* level L): `20*(L-1)^2 + 10*(L-1)`. L1=0, L2=30, L3=100, L4=210, L5=360, L10=1710, L20=7410 (cap 20).
- On level-up: +4 max HP, +1 ATK, +1 DEF (placeholder). Living members also gain the HP increment as current HP; KO'd members stay at 0 HP.
- Victory XP is granted to every current party member (including KO'd). Each member who crosses a threshold shows a level-up message after the victory line.
- Equipment slots (`weapon`, `armor`, `accessory`) and `global.game.inventory` exist as empty placeholders; menus, items, and equipment bonuses are roadmap step 5.


## Prototype assumptions (sprites + 16×16 scale; pending owner approval)
These were chosen so Design's art could be wired in. None is a locked design decision.
- Overworld uses the 16×24 Kael / Bandit sheets on a 16×16 tile grid. `PLAYER_MOVE_SPEED` is 1 (same tiles per second as the earlier speed of 2 on 32 px tiles). `PLAYER_INTERACT_REACH` is 4. Encounter steps are 16 pixels so "8–24 steps" still means 8–24 tiles.
- Default town respawn is (320, 176) so it sits on the grid (was 320, 180). Prefer placing `obj_respawn_point` on a tile too.
- Y-sort with `depth = -y`. Overworld `left` is a pre-mirrored sheet; `image_xscale` stays 1. Battle party members are flipped with `xscale = -1` because battle strips only face right.
- Battle playback: idle 6 fps, attack/hurt/death 10 fps, drawn in Draw GUI at `BATTLE_SPRITE_SCALE` 2. Damage is applied at about 60% through the attack clip; a KO plays death instead of hurt and holds the last frame. Confirm skips the clip. There is no Guard pose in the art.
- Camera: if Viewport 0 is enabled, the controller follows the player and clamps to the room. Recommended view is 320×180 displayed at 2× (640×360 window) for pixel art, or 640×360 1:1. No camera is required for the current 640×360 test room.
- The Zone 1 tileset and large overworld map are still being built and are not in the repo. When they arrive, the test room will be too small and the camera will be required (the map is expected to be hundreds of 16×16 tiles).
- Bandit overworld sheets are in the repo but not used by any object yet. There is no Fallen Knight overworld sheet. Battle assets are named `spr_hero_*`; overworld Kael is `spr_kael_ow*`.

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
