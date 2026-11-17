# ASHEN CROWN

A dark medieval fantasy RPG by Eastern Goat Forge, built with GameMaker and GML.

**Direction:** classic top-down JRPG exploration inspired by the original Final Fantasy (1987), not side-view. Combat is classic menu-driven turn-based with a five-person roster (four active, one reserve).

**Status (2026-11-17):** Acts I–IV are built and unplayed — Chapters 1–11, 34 rooms, 95 scripts, 844 sprites — ending with the King beneath the barrow and the mark named **the Crownveil**. All the core systems are implemented — top-down exploration and interaction, turn-based battle (skills, six statuses, weakness, two- and three-phase bosses, Guard, Swap, Item, Escape), a five-person roster with four active and one reserve, XP / levels / gold, equipment, inventory, shops, three-slot versioned saves (schema v3) at save crystals inside a town's church or tavern, random encounters, defeat-and-respawn, the Adventure menu (Items, Equip, Party Order, Status, Bestiary, Quests) and the audio system (3 music loops, 20 SFX, 6 ambience beds). Act V's outline and Chapter 12 are approved; Chapters 13–14 are drafted and await review. Its seven-enemy batch, `drowned_coast` table and three boss groups are data and simulated, but no Act V room, dialogue or quest row is built; Acts VI–VIII are titles. **Nothing has been compiled or playtested in GameMaker** — `docs/TEST_PLAN.md` is the manual check list, and `docs/PLAYTEST_RUNBOOK.md` is the order to run its first IDE session in.

A complete, ready-to-open GameMaker project lives in `gamemaker/AshenCrown.yyp` — open it and press F5. The `game/` folder remains the human-readable source of truth for the same GML, sprites, and map data; `python3 validate_gamemaker.py` checks that the two stay byte-identical.

## Confirmed concepts
- Protagonist: Kael Varyn; tragic backstory planned, exact canon still open.
- Tone: dark, atmospheric, serious, with occasional lighthearted moments.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- Menu: the Adventure menu (I / Tab) with Items, Equip, Party Order, Status and Bestiary. Save/load is not a field-menu row — saving stays at the save crystals, inside a town's church or tavern.
- Art for all five chapters is in `game/sprites/`: the five-person party (overworld, battle strips and portraits, all drawn by the same generator), 31 enemy and boss sets (including the Ashbound Hunter and the Blackguard's phases), 27 NPC overworld sets, 19 portrait sets, 17 item icons with chests, the UI kit, the title sets, the ten marker sprites and the Zone 1, Wrenfield and Blackwood (placeholder) tilesets. Remainder: 18 enemy kinds still have no 16×24 overworld set, and Alden has no sprite (see `docs/ASSET_INVENTORY.md`). `game/sprites/IMPORT.md` is the full import table, and the generated project already contains every listed sprite.
- Maps live in `game/tilesets/`, `game/datafiles/` (overworld chunks) and `game/maps/` (Chapter 2 rooms plus the interiors and Watchtower CSV data); the Chapter 3–11 rooms are built at runtime from `scr_build_*` arrays. `game/rooms/ROOM_SETUP.md` documents the rooms, and the generated project builds them from this data.

## Start here
1. Read docs/GAME_DESIGN_DOCUMENT.md and docs/DECISIONS_AND_OPEN_QUESTIONS.md.
2. Read docs/AI_AGENT_DEVELOPMENT_BACKLOG.md before assigning work to Codex or another AI agent; it is the ordered task list with acceptance criteria.
3. Open `gamemaker/AshenCrown.yyp` in GameMaker and run it. See `gamemaker/README.md` for what is included and what is intentionally stubbed.
4. Check docs/DEVELOPMENT_ROADMAP.md for what is built and what is next; docs/CHANGELOG.md has the feature history.
5. Run docs/TEST_PLAN.md before marking features complete.

## Folders
- docs/: design, story, combat, Zone 1, art, asset inventory, roadmap, backlog, tests.
- prompts/: Codex implementation prompts.
- game/: human-readable GML snippets, setup notes, `game/sprites/` art, tileset, and overworld Included Files (the source the GameMaker project is generated from).
- gamemaker/: the generated, ready-to-open GameMaker project (`.yyp`, resources, and datafiles).
- gen_gamemaker.py / validate_gamemaker.py: rebuild and re-check `gamemaker/` from `game/` (Python 3 + Pillow).

Proprietary: all source code and all game assets are the property of Eastern Goat Forge, all rights reserved; see LICENSE.
