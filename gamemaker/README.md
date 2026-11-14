# Ashen Crown — GameMaker project

This folder is a complete, ready-to-open GameMaker project (`.yyp`), generated from the GML snippets, sprites, tileset, and map data in `../game/`. It replaces the manual IDE assembly described in `game/rooms/ROOM_SETUP.md`.

## How to open

1. Open `AshenCrown.yyp` in GameMaker (IDE 2023.1 or newer; the project format is 2024.x).
2. Press F5 (Run) to start in `rm_overworld`.

No manual resource creation, sprite import, or event wiring is required — everything is already declared.

## What is in it

- **20 scripts** (`scripts/`) — pasted verbatim from `game/game/scripts/*.gml`.
- **11 objects** (`objects/`) — pasted verbatim from `game/game/objects/<obj>/<Event>.gml`, with the documented event mapping: Create, Step, Begin/End Step (from `Begin_Step.gml` / `End_Step.gml`), Room Start (from `Room_Start.gml`), Draw GUI, and Clean Up.
- **55 sprites** (`sprites/`) — every art strip in `game/sprites/` split into per-frame PNGs with the origins and collision boxes from `game/sprites/IMPORT.md` (Kael/bandit overworld feet boxes, battle bottom-center origins, 48×48 death frames, 64×48 Fallen Knight attack, and the 256×608 Zone 1 tileset as `spr_ts_zone1`). Seven flat-color placeholder sprites stand in for art that does not exist yet.
- **1 tileset** — `ts_zone1` (16×16, 608 tiles), built on `spr_ts_zone1`.
- **3 rooms** — `rm_overworld` (6400×4800), `rm_old_watchtower` (960×720), `rm_battle_test` (640×360), with Room Creation Code calling `scr_build_overworld()` / `scr_build_old_watchtower()`, the player and controllers placed, and the 320×180 camera view enabled.
- **86 Included Files** (`datafiles/`) — byte-identical copies of `game/game/datafiles/` (the five 240,000-byte map `.bin` files, the Watchtower bins, and the 80 chunk CSVs). Loaded at runtime via the standard `working_directory` paths the scripts already use.

## Intentional stubs (not bugs)

- The seven `*_placeholder` sprites are flat colors; swap them when real art lands.
- Battle uses the test room `rm_battle_test`; the full battle UI is still unbuilt by design.
- Zones 2+ do not exist yet; only Zone 1 content is included.
- No audio has been authored, so no sound assets are referenced.

## Regenerating

`gen_project.py` (repo root, not committed as part of the project) rebuilds this folder from `game/` at any time. The generator is deterministic in content but not in UUIDs — prefer editing resources in the IDE once you have opened the project.
