# Ashen Crown — GameMaker project

This folder is a complete, ready-to-open GameMaker project (`.yyp`), generated from the GML, sprites, tilesets, and map data in `../game/`. It replaces the manual IDE assembly described in `game/rooms/ROOM_SETUP.md`.

**Status:** Chapters 1–3 are built (18 rooms). Chapters 4–5 exist as enemy and encounter data only, Act III onward is design only, and there is no audio. Nothing has been compiled or playtested in GameMaker — `../docs/TEST_PLAN.md` is the manual check list and `../docs/DEVELOPMENT_ROADMAP.md` tracks what is left.

## How to open

1. Open `AshenCrown.yyp` in GameMaker (IDE 2023.1 or newer; the project format is 2024.x).
2. Press F5 (Run). The game boots to `rm_title` (title screen → New Game → `rm_overworld`).

No manual resource creation, sprite import, or event wiring is required.

## What is in it

- **51 scripts** — pasted verbatim from `game/scripts/*.gml` (battle system, skills, saves/shops, map builders, UI, Bestiary, Chapters 1–3 story flow).
- **22 objects** — pasted verbatim from `game/objects/<obj>/<Event>.gml`, with the documented event mapping (Create, Step, Begin/End Step, Room Start, Draw GUI, Clean Up).
- **806 sprite resources** — every asset in the `game/sprites/IMPORT.md` import table, split into per-frame PNGs with the documented origins, collision masks, fps, and nine-slice settings (the UI windows use the real nine-slice data, not placeholders). Includes all Chapter 1–3 art: enemies, NPCs, portraits, items, chests, the full UI kit, sprite font, title screen (320 set), battle backgrounds, Act II enemy strips, and the Wrenfield / Valemere tileset art. Ten flat-color placeholder sprites stand in for art that does not exist yet (including Lyra).
- **`ts_zone1` tileset** — 256×800 (800 tiles, 16×16), built on `spr_ts_zone1`.
- **18 rooms** — `rm_title` (first in Room Order), `rm_overworld` (6400×4800, player at the Greyhaven south-road start), `rm_old_watchtower`, `rm_watchtower_basement`, the five Greyhaven interiors, `rm_battle_test`, and the Chapter 2–3 rooms `rm_millhaven_road`, `rm_wrenfield`, `rm_wrenfield_store`, `rm_wrenfield_bent_post`, `rm_valemere_road`, `rm_valemere`, `rm_salt_lamp`, `rm_warehouse`. Every room has the five tile layers the map code expects (Ground/Decoration/Overhead/Collision/Markers at the exact depths in `scr_map_layer_defs`), an Instances layer, Room Creation Code calling the matching `scr_build_*()`, and the 320×180 camera view.
- **86 Included Files** — byte-identical copies of `game/datafiles/` (the five map `.bin` layers, the chunk CSV fallbacks, and the README).
- **Options** — "Interpolate colours between pixels" is unchecked on every platform, per the setup notes.

## Intentional stubs (not bugs)

- The ten `*_placeholder` sprites are flat colors (Lyra's overworld and battle strips among them); swap them when real art lands.
- The 640 title set (19 sprites, including `spr_menu_embers_640_strip24`) is imported and assigned to its own `tex_title_640` texture group, per IMPORT.md; every platform uses 2048×2048 texture pages.
- Chapters 4–5 have enemy stats, encounter tables and boss groups, but no rooms, markers or dialogue; Act III onward is design only.
- Future regions referenced in overworld marker data (`rm_saltreach`, `rm_rimehold`, `rm_ironspine_mine`, `rm_blackwood_doors`, `rm_flooded_ruins`, `rm_ashlands_breach`, …) are string stubs — those rooms do not exist and the entrances are marked `status: "stub"`.
- No audio has been authored, so no sound assets are referenced.

## Regenerating

`gen_gamemaker.py` (repo root) rebuilds this folder from `game/` at any time: `python3 gen_gamemaker.py` (Python 3 + Pillow; options and this README are carried over from the existing `gamemaker/`, so it is fully self-contained). `validate_gamemaker.py` re-checks the result: every JSON file parses, all resource paths resolve, sprite PNGs match declared dimensions, scripts and data files are byte-identical to `game/`, and rooms, layers, and room order match the code's expectations.

The generator is deterministic in content but not in UUIDs — prefer editing resources in the IDE once you have opened the project, and treat `game/` as the source of truth for GML and art.
