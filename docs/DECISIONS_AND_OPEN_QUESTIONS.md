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
- Defeat penalty: lose `DEFEAT_GOLD_LOSS_PCT` of current shared gold (floored) and `DEFEAT_XP_LOSS_PCT` of XP progress toward the next level, never causing a level-down or a negative total. Defaults are 50% gold and 10% XP; exact percentages are pending tuning. There is no level system yet (roadmap step 4), so the XP penalty is currently 10% of total shared XP, floored.
- Random encounters: classic JRPG walking encounters using a randomized steps-until-encounter counter (distance-based). Steps count only while the player is actually moving and input is not locked, after a grace period following battle or room entry. Per-area tables (an `obj_encounter_zone` and/or a room table in `scr_encounter_tables`) pick a weighted enemy from `scr_enemy_database`. Towns and other rooms with no table are safe. `obj_encounter_trigger` remains for fixed boss/story fights. Encounter rates are pending tuning (defaults: 32 pixels per step, 8–24 steps between fights, 5 grace steps).

## Still undecided
GameMaker version; room resolution and tile size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; save schema; license/proprietary status; exact defeat gold/XP percentages (defaults 50% / 10%, pending tuning); whether a defeat should also deduct items; exact random-encounter rates and table weights (defaults 8–24 steps, 5 grace, 3:1 Bandit/Fallen Knight). Treat these as open questions, not approved requirements.

## Prototype assumptions (exploration + battle prototype; pending owner approval)
These were chosen so roadmap steps 2–3 could be built. None is a locked design decision.
- Battle presentation: dedicated room `rm_battle_test` rather than an overlay.
- Input: arrows move; Z/Enter/Space confirm; X/Backspace cancel. Diagonal movement kept from the original snippet.
- Collision: `obj_solid` objects plus an optional tile layer named `Collision`; requires GameMaker 2023.1+.
- Placeholder sizes: player 32×48 with a feet-sized mask, 32×32 placeholders, 640×360 rooms.
- Party: Kael only, placeholder stats (30 HP, 6 ATK, 2 DEF); party stored as an array for the planned four.
- Guard halves incoming damage (min 1) until the party's next command phase.
- XP/gold are party-wide totals in `global.game` until per-actor progression (roadmap step 4).
- Fixed `obj_encounter_trigger` encounters are removed after victory for the session. Whether cleared triggers persist in saves is undecided. Random walking encounters are owner-decided (see above); they are not cleared after victory.
- Enemy HP is visible in battle for debugging; whether players see enemy HP is undecided.
- Sign text and battle messages are placeholders, not canon.
