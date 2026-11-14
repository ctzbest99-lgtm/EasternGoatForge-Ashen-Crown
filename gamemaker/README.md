# Ashen Crown — GameMaker project

This folder is a complete, ready-to-open GameMaker project (`.yyp`), generated from the GML snippets, sprites, tileset, and map data in `../game/`. It replaces the manual IDE assembly described in `game/rooms/ROOM_SETUP.md`.

## How to open

1. Open `AshenCrown.yyp` in GameMaker (IDE 2023.1 or newer; the project format is 2024.x).
2. Press F5 (Run). The game boots to `rm_title` (title screen → New Game → `rm_overworld`).

No manual resource creation, sprite import, or event wiring is required.

## What is in it

- **34 scripts** — pasted verbatim from `game/scripts/*.gml` (battle system, skills, saves/shops, map builders, UI).
- **20 objects** — pasted verbatim from `game/objects/<obj>/<Event>.gml`, with the documented event mapping (Create, Step, Begin/End Step, Room Start, Draw GUI, Clean Up).
- **460 sprites** — every asset in the `game/sprites/IMPORT.md` import table, split into per-frame PNGs with the documented origins, collision masks, fps, and nine-slice settings (the UI windows use the real nine-slice data, not placeholders). Includes all Chapter 1 art: enemies, NPCs, portraits, items, chests, the full UI kit, sprite font, title screen (320 set), battle backgrounds, and the Act II enemy strips. Ten flat-color placeholder sprites stand in for art that does not exist yet.
- **`ts_zone1` tileset** — 256×800 (800 tiles, 16×16), built on `spr_ts_zone1`.
- **10 rooms** — `rm_title` (first in Room Order), `rm_overworld` (6400×4800, player at the Greyhaven south-road start), `rm_old_watchtower`, `rm_watchtower_basement`, the five Greyhaven interiors, and `rm_battle_test`. Every room has the five tile layers the map code expects (Ground/Decoration/Overhead/Collision/Markers at the exact depths in `scr_map_layer_defs`), an Instances layer, Room Creation Code calling the matching `scr_build_*()`, and the 320×180 camera view.
- **86 Included Files** — byte-identical copies of `game/datafiles/` (the five map `.bin` layers, the chunk CSV fallbacks, and the README).
- **Options** — "Interpolate colours between pixels" is unchecked on every platform, per the setup notes.

## Intentional stubs (not bugs)

- The ten `*_placeholder` sprites are flat colors; swap them when real art lands.
- `spr_menu_embers_640_strip24` is intentionally not imported (it does not fit a default texture page; `obj_title` falls back to the 320 strip, as documented in IMPORT.md).
- Future towns referenced in map marker data (`rm_saltreach`, `rm_valemere`, etc.) are string stubs — those rooms do not exist yet and the entrances are marked `status: "stub"`.
- Act II enemy art is imported, but the Chapter 2 rooms and dialogue are not wired.
- No audio has been authored, so no sound assets are referenced.

## Regenerating

`gen_project.py` (in the workspace, not part of the repo) rebuilds this folder from `game/` at any time. The generator is deterministic in content but not in UUIDs — prefer editing resources in the IDE once you have opened the project.
