# ASHEN CROWN

A dark medieval fantasy RPG by Eastern Goat Forge, built with GameMaker and GML.

**Direction:** classic top-down JRPG exploration inspired by the original Final Fantasy (1987), not side-view. Combat is classic menu-driven turn-based with a four-character active party and a reserve member.

**Status (2026-11-15):** Chapters 1–4 are built in source/project data (20 rooms). Core systems include top-down exploration and interaction, turn-based battle (skills, statuses, weakness, boss phases, Escape), a four-person active party plus reserve with XP / levels / gold, equipment, inventory, shops, three-slot versioned saves (schema v3) at save crystals, random encounters, the Adventure menu (Items, Equip, Party Order, Status, Bestiary), and story flow for Chapters 1–4. Chapter 5 exists as enemy and encounter data only; Act III onward is design only. There is no authored audio yet, Lyra's art still includes placeholders, Bestiary descriptions are placeholder prose and the requested monster-sprite display remains to be completed. **Nothing has been compiled or playtested in GameMaker.**

A complete, ready-to-open GameMaker project lives in `gamemaker/AshenCrown.yyp` — open it and press F5. The `game/` folder remains the human-readable source of truth for GML, sprites, and map data; `python3 validate_gamemaker.py` checks structural consistency between source and generated project. A passing validator is not a substitute for compiling/running the project in GameMaker.

## Confirmed concepts
- Protagonist: Kael Varyn; his exact tragic backstory remains open in the repository decision log.
- Tone: dark, atmospheric, serious, with occasional lighthearted moments.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- Menu: the Adventure menu (I / Tab) with Items, Equip, Party Order, Status and Bestiary. Save/load is not a field-menu row — saving stays at the save crystals inside a town's church or tavern.
- Art for Chapters 1–3 is in `game/sprites/`: party, enemies (including the Ashbound Hunter and the Blackguard's phases), NPCs, portraits, items, UI kit, title sets and Wrenfield / Valemere tilesets. Ten `*_placeholder` sprites remain, including Lyra's overworld and battle strips. `game/sprites/IMPORT.md` is the full import table.
- Maps for Chapters 1–3 live in `game/tilesets/`, `game/datafiles/` (overworld chunks) and `game/maps/` (Chapter 2–3 room data); `game/rooms/ROOM_SETUP.md` documents rooms and the generated project builds them from this data.

## Start here
1. Read `docs/GAME_DESIGN_DOCUMENT.md` and `docs/DECISIONS_AND_OPEN_QUESTIONS.md`.
2. Read `docs/AI_AGENT_DEVELOPMENT_BACKLOG.md` before assigning work to Codex or another AI agent. It is the prioritized task list and includes acceptance criteria.
3. Open `gamemaker/AshenCrown.yyp` in GameMaker and run it. See `gamemaker/README.md` for project contents and intentional stubs.
4. Check `docs/DEVELOPMENT_ROADMAP.md` for phase status and `docs/CHANGELOG.md` for feature history.
5. Run `docs/TEST_PLAN.md` before marking features complete.

## Folders
- `docs/`: design, story, combat, Zone 1, art, asset inventory, roadmap, backlog, and tests.
- `prompts/`: Codex implementation prompts.
- `game/`: human-readable GML, setup notes, sprites, tilesets, and map data (the source used to generate the GameMaker project).
- `gamemaker/`: generated, ready-to-open GameMaker project (`.yyp`, resources, and datafiles).
- `gen_gamemaker.py` / `validate_gamemaker.py`: rebuild and re-check `gamemaker/` from `game/` (Python 3 + Pillow).

Proprietary: all source code and all game assets are the property of Eastern Goat Forge, all rights reserved; see LICENSE.
