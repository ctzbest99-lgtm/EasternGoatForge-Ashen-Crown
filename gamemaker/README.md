# Ashen Crown — GameMaker project

This folder is a complete, ready-to-open GameMaker project (`.yyp`), generated from the GML, sprites, tilesets, and map data in `../game/`. It replaces the manual IDE assembly described in `game/rooms/ROOM_SETUP.md`.

**Status:** Acts I–IV are built (Chapters 1–11, 35 rooms), audio is wired through `scr_audio`, Act V's Chapters 12–14 are approved as story and its enemy batch is data, and Acts VI–VIII are titles. Rimehold's armoury courtyard is built ahead of Act VIII so the tier-VIII shelf is reachable. Controller support is implemented in `scr_input` but has not been physically tested. Nothing has been compiled or playtested in GameMaker — `../docs/PLAYTEST_RUNBOOK.md` is the order to run the first IDE session in, `../docs/TEST_PLAN.md` is the manual check list and `../docs/DEVELOPMENT_ROADMAP.md` tracks what is left.

## How to open

1. Open `AshenCrown.yyp` in GameMaker (IDE 2023.1 or newer; the project format is 2024.x).
2. Press F5 (Run). The game boots to `rm_title` (title screen → New Game → `rm_overworld`).

No manual resource creation, sprite import, or event wiring is required.

## What is in it

- **97 scripts** — pasted verbatim from `game/scripts/*.gml` (battle system, skills, saves/shops, map builders, UI, Bestiary, Chapters 1–11 story flow).
- **22 objects** — pasted verbatim from `game/objects/<obj>/<Event>.gml`, with the documented event mapping (Create, Step, Begin/End Step, Room Start, Draw GUI, Clean Up).
- **1,087 sprite resources** — every asset in the `game/sprites/IMPORT.md` import table, split into per-frame PNGs with the documented origins, collision masks, fps, and nine-slice settings (the UI windows use the real nine-slice data, not placeholders). Includes all Chapter 1–4 art — enemies, NPCs, portraits (including Alden, Nim and Derry), 19 item icons (including Ether and Chain Mail), chests, the full UI kit, sprite font, title screen (320 set), battle backgrounds, Act II enemy strips and map sets, the Cinderhollow burner and Lost One map sets, Kael's Guard pose, the Blind/Sleep status icons, and the Wrenfield / Valemere tileset art; the Chapter 6–8 Blackwood rooms and the Aethari doors clearing use `ts_blackwood`, the Chapter 3 rooms use `ts_valemere`, the two Chapter 5 garrison rooms use `ts_garrison`, Coleford uses `ts_coleford`, and the Chapter 10–11 barrow rooms use `ts_barrow`; all borrow enemy strips. The ten `*_placeholder` sprites are functional debug markers, not unfinished character art.
- **`ts_zone1` tileset** — 256×800 (800 tiles, 16×16), built on `spr_ts_zone1`.
- **`ts_barrow` tileset** — 256×1040 (1,040 tiles, 16×16), built on `spr_ts_barrow`; rows 0–49 match `ts_zone1`, rows 50–55 are the crypt.
- **`ts_valemere`, `ts_coleford`, `ts_garrison` tilesets** — 256×1040 each, built on their `spr_ts_*` sprites; Wrenfield ids repainted with each region's material by `tools/gen_region_tilesets.py`.
- **35 rooms** — `rm_title` (first in Room Order), `rm_overworld` (6400×4800, player at the Greyhaven south-road start), `rm_old_watchtower`, `rm_watchtower_basement`, the five Greyhaven interiors, `rm_battle_test`, the Chapter 2–3 rooms `rm_millhaven_road`, `rm_wrenfield`, `rm_wrenfield_store`, `rm_wrenfield_bent_post`, `rm_valemere_road`, `rm_valemere`, `rm_salt_lamp`, `rm_warehouse`, `rm_hollow_approach`, `rm_hollow_sanctuary`, the Blackwood rooms (`rm_blackwood_garrison`, `rm_garrison_keep`, `rm_blackwood_shrine`, `rm_blackwood_glade`, `rm_blackwood_doors`, `rm_blackwood_deep`, `rm_blackwood_hollow`), the Act IV rooms `rm_town`, `rm_barrow_gate`, `rm_barrow_halls`, `rm_barrow_deep`, and the Rimehold armoury `rm_rimehold`. Every room has the five tile layers the map code expects (Ground/Decoration/Overhead/Collision/Markers at the exact depths in `scr_map_layer_defs`), an Instances layer, Room Creation Code calling the matching `scr_build_*()`, and the 320×180 camera view.
- **86 Included Files** — byte-identical copies of `game/datafiles/` (the five map `.bin` layers, the chunk CSV fallbacks, and the README).
- **Options** — "Interpolate colours between pixels" is unchecked on every platform, per the setup notes.

## Intentional stubs (not bugs)

- The ten `*_placeholder` sprites are deliberate debug markers from `game/sprites/src/markers.py`, not missing character art. Lyra has a full generated party kit.
- The 640 title set (19 sprites, including `spr_menu_embers_640_strip24`) is imported and assigned to its own `tex_title_640` texture group, per IMPORT.md; every platform uses 2048×2048 texture pages.
- The Act III and Act IV rooms are Wrenfield-tileset blockouts; their enemies reuse existing strips. Vell and Nessa are placeholder sprites; Alden, Nim, Derry, Berrin, the ward sentinels, the Cinderhollow burners and the Lost Ones have dedicated sets.
- Future regions referenced in overworld marker data (`rm_saltreach`, `rm_saltreach_pier`, `rm_ironspine_mine`, `rm_ironspine_ruins`, `rm_flooded_ruins`, `rm_frozen_ruins`, `rm_shipwreck`) are string stubs — those rooms do not exist and the entrances are marked `status: "stub"`. `rm_ashlands_breach` (the outpost), `rm_ashlands_ruins` (the ruin beyond it) and `rm_rimehold` (the armoury courtyard) are built.
- Act V's Chapters 12–14 are approved as story and its seven enemies/three boss groups are data, but no Act V room, dialogue data, quest row or story code exists.

## Regenerating

`gen_gamemaker.py` (repo root) rebuilds this folder from `game/` at any time: `python3 gen_gamemaker.py` (Python 3 + Pillow; options and this README are carried over from the existing `gamemaker/`, so it is fully self-contained). `validate_gamemaker.py` re-checks the result: every JSON file parses, all resource paths resolve, sprite PNGs match declared dimensions, scripts and data files are byte-identical to `game/`, and rooms, layers, and room order match the code's expectations.

The generator is deterministic in content but not in UUIDs — prefer editing resources in the IDE once you have opened the project, and treat `game/` as the source of truth for GML and art.
