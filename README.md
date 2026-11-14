# ASHEN CROWN

A dark medieval fantasy RPG by Eastern Goat Forge, built with GameMaker and GML.

**Direction:** classic top-down JRPG exploration inspired by the original Final Fantasy (1987), not side-view. Planned combat is classic menu-driven turn-based with a four-character party.

**Status:** pre-production starter. A complete, ready-to-open GameMaker project now lives in `gamemaker/AshenCrown.yyp` — open it and press F5. The `game/` folder remains the human-readable source of truth for the same GML, sprites, and map data.

## Confirmed concepts
- Protagonist: Kael Varyn; tragic backstory planned, exact canon still open.
- Tone: dark, atmospheric, serious, with occasional lighthearted moments.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- Planned menu: equipment, party order, items, save/load, character status, Bestiary.
- Character art for Kael, the Bandit, and the Fallen Knight is in `game/sprites/` (16×24 overworld recommended; 32×48 battle strips). Import with `game/sprites/IMPORT.md`. Rare-encounter and Zone 1 boss sprites are still outstanding.
- Zone 1 overworld and Old Watchtower maps are in `game/tilesets/` and `game/datafiles/`; import per `game/rooms/ROOM_SETUP.md`.

## Start here
1. Read docs/GAME_DESIGN_DOCUMENT.md and docs/DECISIONS_AND_OPEN_QUESTIONS.md.
2. Open `gamemaker/AshenCrown.yyp` in GameMaker and run it. See `gamemaker/README.md` for what is included and what is intentionally stubbed.
3. Use prompts/ one at a time with Codex.
4. Run docs/TEST_PLAN.md before marking features complete.

## Folders
- docs/: design, story, combat, Zone 1, art, asset inventory, roadmap, tests.
- prompts/: Codex implementation prompts.
- game/: human-readable GML snippets, setup notes, `game/sprites/` art, tileset, and overworld Included Files (the source the GameMaker project is generated from).
- gamemaker/: the generated, ready-to-open GameMaker project (`.yyp`, resources, and datafiles).
- gen_gamemaker.py / validate_gamemaker.py: rebuild and re-check `gamemaker/` from `game/` (Python 3 + Pillow).

Proprietary: all source code and all game assets are the property of Eastern Goat Forge, all rights reserved; see LICENSE.
