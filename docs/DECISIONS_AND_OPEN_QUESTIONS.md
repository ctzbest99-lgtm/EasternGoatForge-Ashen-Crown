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

## Still undecided
GameMaker version; room resolution and tile size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; save schema; license/proprietary status. Treat these as open questions, not approved requirements.

## Prototype assumptions (exploration + battle prototype; pending owner approval)
These were chosen so roadmap steps 2–3 could be built. None is a locked design decision.
- Battle presentation: dedicated room `rm_battle_test` rather than an overlay.
- Input: arrows move; Z/Enter/Space confirm; X/Backspace cancel. Diagonal movement kept from the original snippet.
- Collision: `obj_solid` objects plus an optional tile layer named `Collision`; requires GameMaker 2023.1+.
- Placeholder sizes: player 32×48 with a feet-sized mask, 32×32 placeholders, 640×360 rooms.
- Party: Kael only, placeholder stats (30 HP, 6 ATK, 2 DEF); party stored as an array for the planned four.
- Guard halves incoming damage (min 1) until the party's next command phase.
- XP/gold are party-wide totals in `global.game` until per-actor progression (roadmap step 4).
- Defeat: prototype restores HP and returns to the pre-battle position. Final rule (game over, return to town, etc.) undecided.
- Encounters: one fixed trigger per encounter, removed after victory for the session. Random encounters, encounter tables, and whether cleared triggers persist in saves are undecided.
- Enemy HP is visible in battle for debugging; whether players see enemy HP is undecided.
- Sign text and battle messages are placeholders, not canon.
