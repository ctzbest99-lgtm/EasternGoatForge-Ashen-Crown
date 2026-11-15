# ASHEN CROWN

A dark medieval fantasy RPG by Eastern Goat Forge, built with GameMaker and GML.

**Direction:** classic top-down JRPG exploration inspired by the original Final Fantasy (1987), not side-view. Planned combat is classic menu-driven turn-based with a four-character party.

**Status (2026-11-15):** playable slice through Chapter 4. All the core systems are implemented — top-down exploration and interaction, turn-based battle (skills, statuses, weakness, boss phases, Escape), a four-person party plus reserve with XP / levels / gold, equipment, inventory, shops, three-slot versioned saves (schema v3) at save crystals, random encounters, the Adventure menu (Items, Equip, Party Order, Status, Bestiary) and the story flow for Chapters 1–4 (20 rooms). Chapter 5 exists as enemy and encounter data only; Act III onward is design only. There is no audio yet, Lyra's art is still a placeholder, and **nothing has been compiled or playtested in GameMaker** — `docs/TEST_PLAN.md` is the manual check list.

A complete, ready-to-open GameMaker project lives in `gamemaker/AshenCrown.yyp` — open it and press F5. The `game/` folder remains the human-readable source of truth for the same GML, sprites, and map data; `python3 validate_gamemaker.py` checks that the two stay byte-identical.

## Confirmed concepts
- Protagonist: Kael Varyn; tragic backstory planned, exact canon still open.
- Tone: dark, atmospheric, serious, with occasional lighthearted moments.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- Menu: the Adventure menu (I / Tab) with Items, Equip, Party Order, Status and Bestiary. Save/load is not a field-menu row — saving stays at the save crystals, inside a town's church or tavern.
- Art for Chapters 1–3 is in `game/sprites/`: the party, enemies (including the Ashbound Hunter and the Blackguard's phases), NPCs, portraits, items, the UI kit, the title sets and the Wrenfield / Valemere tilesets. Ten `*_placeholder` sprites remain, Lyra's overworld and battle strips among them. `game/sprites/IMPORT.md` is the full import table, and the generated project already contains every listed sprite.
- Maps for Chapters 1–3 live in `game/tilesets/`, `game/datafiles/` (overworld chunks) and `game/maps/` (Chapter 2–3 room data); `game/rooms/ROOM_SETUP.md` documents the rooms and the generated project builds them from this data.

## Start here
1. Read docs/GAME_DESIGN_DOCUMENT.md and docs/DECISIONS_AND_OPEN_QUESTIONS.md.
2. Open `gamemaker/AshenCrown.yyp` in GameMaker and run it. See `gamemaker/README.md` for what is included and what is intentionally stubbed.
3. Check docs/DEVELOPMENT_ROADMAP.md for what is built and what is next; docs/CHANGELOG.md has the feature history.
4. Run docs/TEST_PLAN.md before marking features complete.

## Folders
- docs/: design, story, combat, Zone 1, art, asset inventory, roadmap, tests.
- prompts/: Codex implementation prompts.
- game/: human-readable GML snippets, setup notes, `game/sprites/` art, tileset, and overworld Included Files (the source the GameMaker project is generated from).
- gamemaker/: the generated, ready-to-open GameMaker project (`.yyp`, resources, and datafiles).
- gen_gamemaker.py / validate_gamemaker.py: rebuild and re-check `gamemaker/` from `game/` (Python 3 + Pillow).

Proprietary: all source code and all game assets are the property of Eastern Goat Forge, all rights reserved; see LICENSE.
