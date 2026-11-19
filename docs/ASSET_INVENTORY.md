# Asset Inventory

Measured 2026-11-18. Source art lives under `game/sprites/`, `game/audio/` and `game/tilesets/`; the GameMaker resources under `gamemaker/` are generated from it. Import settings (asset name, frames, origin, mask, fps) are in `game/sprites/IMPORT.md` and `game/sprites/README.md`.

**Totals:** 1087 sprite resources and 29 sound resources in `gamemaker/`, 35 rooms, 7 tilesets, 97 scripts. **Nothing here has been compiled or playtested in GameMaker.** All assets are the property of Eastern Goat Forge (see LICENSE).

## Characters

| Asset | Status | Notes |
|---|---|---|
| Kael overworld 16×24 (`spr_kael_ow16_*`) | In repo, in use | 16×24, origin (8, 23), 1-frame idle + 4-frame walk × 4 directions. `scr_sprites` wires it to `obj_player`. Source: `game/sprites/hero/overworld/16x24/`. |
| Kael overworld 32×48 (`spr_kael_ow_*`) | In repo, fallback only | 32×48, origin (16, 47). Used only if the 16×24 set is missing. |
| Kael battle (`spr_hero_*`) | In repo | Idle 4 / walk 8 / attack 6 / defend 3 / hurt 3 / death 6. Idle/walk/defend are 32×48 strips; attack and death are 48×48; origin (16, 47). The defend strip is wired to the battle Guard command. Naming differs from the overworld set (`spr_hero_*` vs `spr_kael_ow*`). |
| Party kits: Sera, Caelan, Lyra | In repo, generated | Each has a 16×24 four-direction idle + walk4 set, 32×48 idle/walk/hurt/defend, 48×48 attack/death and three 48×48 portraits (neutral, determined, pained). All three are drawn by `game/sprites/src/party_kit.py` from one template, so they share Taren's proportions; weapons are longsword (Sera), crystal staff (Caelan) and twin daggers (Lyra). |
| Taren Holt | In repo | Hand-drawn 16×24 set, battle strips and a 48×48 portrait. Taren's overworld grids are the template the party kit is transcribed from. |
| Named speakers: Alden Marr, Nim, Derry | In repo, generated | Dedicated 16×24 four-direction idle + walk4 sets and three 48×48 portraits each, from `game/sprites/src/story_npcs.py`; imported by `tools/import_sprites.py --story-npcs`. No battle strips: none has a battle slot. Their appearance is new art direction, not story canon. |
| NPC overworld sets (36 kinds) | In repo | 16×24 sets in `game/sprites/npcs/<name>/` for the Greyhaven survivors, Wrenfield pair, Valemere cast, garrison officers, story characters, the three named speakers above, Berrin, Coleford's magistrate and clerk, and the Burner adult, wood-carrier and child. |
| Portraits (21 sets) | In repo | 48×48, origin (0, 0): the five party members plus Tomas, Renn, the Fallen Knight, Bram, Oda, Perrin, Len, Marda, Hob, Pell, the Debtman, Reeve Calder, Commander Hailen, Alden, Nim and Derry. |

## Enemies and bosses

| Asset | Status | Notes |
|---|---|---|
| Enemy battle art (31 folders) | In repo | Idle 4 / walk / attack 6 / hurt / death per kind; 32×48, with bosses at 48×64 and two at 96×96. All 43 bestiary entries resolve to art (the Act III/IV boss ids and Emberwake reuse a base creature's strips; no Act IV enemy and no Emberwake has its own art yet). |
| Blackguard | In repo | Three phases plus both transitions in `game/sprites/blackguard/phases/`. |
| Bandit | In repo | Overworld 16×24 and 32×48 sets, battle strips. The overworld set is not wired (no overworld Bandit object). |
| Fallen Knight (enemy) | Battle only | 64×48 attack, 48×48 death; **no overworld set**. |
| Zone 1 boss / rare encounter | In repo | The Blackguard is the Zone 1 boss; the Ashbound Hunter is the rare encounter. |
| Enemy overworld sets | Complete (2026-11-19) | Every enemy kind with battle art now has a 16×24 map set. Batch 16 added the last 12 — `briar_hulk`, `cutpurse`, `dock_thug`, `fallen_knight`, `garrison_field_surgeon`, `garrison_pikeman`, `glyph_wisp`, `grey_ash_wolf`, `night_moth_swarm`, `sanctuary_warden`, `shade_stalker` and `spiderling`. The five Fallen Knight `enemy_spawn` markers pick the new set up by name; the rest are ready for visible markers when a room needs one. |

## Interface and presentation

| Asset | Status | Notes |
|---|---|---|
| UI kit | In repo | Nine-slice window 24×24 (`spr_ui_window`, plus dim and gold variants), cursor strip 2×32×12, select bar, slider track and knob, toggle strip 2, dither, bars and frames for HP/MP, critical/low HP bar fills. |
| Bitmap font | In repo | `spr_font_main_strip95` 570×10 (95 glyphs, 6×10 cell), plus a no-shadow variant used inside dim windows. |
| Numbers and status | In repo | Damage digits strip 10 (70×9) with miss/weak/critical marks, heal digits, critical digits, status icon strip 12 (120×10, 10×10 cells), plus `spr_ui_status_extra_strip2` (20×10) for Blind and Sleep. The battle HUD draws the new icons; the old 12-frame indices are unchanged. |
| Menu parts | In repo | 34 parts in `game/sprites/ui/menus/` (arrows, icons, panels, save point), plus mockups. |
| Marker sprites (10) | In repo, real art | `spr_{solid,interactable,story_npc,player,respawn_point,encounter_trigger,encounter_zone,story_trigger,story_encounter,trap_plate}_placeholder`: 16×16 icons/props (16×24 for the player fallback) from `game/sprites/src/markers.py`. These are functional debug markers, **not** unfinished character art. Most draw only with `DEBUG_SHOW_TRIGGERS`. |
| Title and main menu | In repo | 19 files each at 320 and 640: logo (250×71 at 320), four parallax layers, ember loop strip 24, cursor strip 4, option graphics, save/options panels, mockups. |
| Battle backgrounds | In repo | 5 × 320×180: forest, bandit camp, Blackguard arena, Blackwood, garrison yard. |
| Item icons and chests | In repo | 19 × 16×16 icons (potions, key items, weapons, armour, the pendant, plus Ether and Chain Mail) and wood/iron chests, closed and opening strip 3. Ether and Chain Mail each have an enabled and disabled icon; the disabled variants are generated by `game/sprites/src/item_extra.py`. |

## World

| Asset | Status | Notes |
|---|---|---|
| Zone 1 tileset (`ts_zone1.png`) | In repo | 256×800, 16×16 tiles, 16 columns × **50 rows**, no spacing. Import as sprite `spr_ts_zone1`, then tileset `ts_zone1`. |
| Wrenfield tileset (`ts_wrenfield.png`) | In repo | 256×1040, 16×16 tiles, 16 columns × 65 rows. Used by the Wrenfield and Millhaven rooms. |
| Valemere tileset (`ts_valemere.png`) | In repo | 256×1040. Wrenfield ids repainted as harbour-town cobbles, plaster, slate, oak and market props. Chapter 3 rooms. |
| Coleford tileset (`ts_coleford.png`) | In repo | 256×1040. Mud roads, cream plaster, thatch and warm oak. `rm_town`. |
| Garrison tileset (`ts_garrison.png`) | In repo | 256×1040. Courtyard paving, dressed stone, dark planks. The two Chapter 5 garrison rooms. |
| Barrow tileset (`ts_barrow.png`) | In repo | 256×1040, 16×16 tiles, 16 columns × 65 rows. Rows 0–49 are `ts_zone1` unchanged; rows 50–55 (ids 800–895) are the crypt's dead turf, flagstone, rubble, wall courses and props. Drawn by `tools/gen_barrow_tileset.py`. Used by `rm_barrow_gate`, `rm_barrow_halls` and `rm_barrow_deep`. |
| Blackwood tileset (`ts_blackwood.png`) | In repo, placeholder | 256×1040, 16×16 tiles. Rows 0–49 are `ts_zone1` unchanged; rows 50–64 (ids 800–1039) are the wood's own dark material: moss floor, black road, charcoal, bog, thorn walls, dead canopy and trunks, kilns and stone. Drawn by `tools/gen_blackwood_tileset.py`. Used by the Chapter 6 rooms. |
| Tile id map (`game/tilesets/tile_ids.json`) | In repo | Named tile ids used by the room builders. |
| Map data | In repo | `game/datafiles/overworld/` (400×300 × 5 layers, bin + chunk fallback), `game/maps/chapter2/`, `game/maps/interiors/`, `game/maps/old_watchtower_csv/`, `game/maps/watchtower_basement_csv/`, plus marker JSON. Chapters 3–5 rooms are built from `scr_build_*` arrays. |

## Audio

| Asset | Status | Notes |
|---|---|---|
| Music (3 loops) | In repo, original | `snd_mus_overworld.wav` 40.0 s, `snd_mus_battle.wav` 37.9 s, `snd_mus_boss.wav` 34.3 s; 22050 Hz mono 16-bit, synthesised by `tools/audio/tracks.py`. |
| Ambience (6 beds) | In repo, original | `snd_amb_wind/forest/dungeon/fire/water/night.wav`, 9.6–11.5 s loop-safe. `night` plays in the Blackwood shrine and glade; `water` is assigned to `rm_saltreach_pier`, `rm_shipwreck` and `rm_flooded_ruins` (the first two are currently unresolved room references, so the assignment is data-ready rather than audible until those rooms exist). |
| Effects (20) | In repo, original | Character, menu and UI cues. All four previously listed as unhooked are wired: `arrow` (ranged skill cue), `enemy_fall` (non-yielding death), `party_hurt` (party damage) and `menu_open` (Adventure menu). `step` is deliberately unused. Names, durations and hook points are in `docs/AUDIO.md`. |
| Sound resources | In repo | 29 `GMSound` resources. Never heard in GameMaker. |

## Source

| Asset | Status | Notes |
|---|---|---|
| Sprite generators | In repo (`game/sprites/src/*.py`) | Python + Pillow, deterministic. Do not import as game assets. `act2_enemy_ow.py` draws the four Act II enemy map sets; `story_npcs.py` draws Alden, Nim and Derry. |
| Audio generators | In repo (`tools/audio/`) | Python synthesis; run `python3 tools/audio/build.py`. |
| Import tools | In repo (`tools/import_sprites.py`, `tools/import_sounds.py`) | `--refresh` rewrites pixels of existing resources without touching ids. `--story-npcs`, `--act2-enemy-ow`, `--berrin-sentinels`, `--blackwood-folk`, `--crown-town` and `--remaining-enemies` import the generated character and enemy map sets. |

**Known art gaps (measured):**
- Every enemy kind with battle art now has a 16×24 overworld set (2026-11-19); the previous 12-kind gap is closed.
- Alden, Nim, Derry, Berrin, the ward sentinels, the Cinderhollow burners and the Lost Ones now have dedicated sets (2026-11-18); their designs are art direction, not story canon. Berrin uses `spr_berrin_ow16_*`; the sentinels use `spr_ward_sentinel_ow16_*`; the burners use `spr_burner_ow16_*`, `spr_burner_wood_ow16_*` and `spr_burner_child_ow16_*`; the Lost Ones use `spr_lost_one_ow16_*` and `spr_lost_one_boots_ow16_*`, closing the `lost_one` map-set gap. Vell and Nessa now have dedicated sets (`spr_vell_ow16_*`, `spr_nessa_ow16_*`, 2026-11-18). The Ash King and the rare-encounter concept art are unstarted.
- Kael now has a three-frame Guard pose (`spr_hero_defend_strip3`, wired through `scr_battle_frame_count`); the other four party members already had defend strips. No left-facing battle strips exist (the party is flipped with `image_xscale`).
- Blind and Sleep now use `spr_ui_status_extra_strip2` in the battle HUD. The old 12-frame status strip keeps its indices. The adventure Status screen does not list statuses; only the battle HUD does.
- Kael's hurt clip is 3 frames (Bandit 4, Fallen Knight 6), and the battle vs overworld naming mismatch (`spr_hero_*` / `spr_kael_ow*`) still stands.
- Every room in the user's environment pass now has its own material: Valemere, the Salt Lamp and the warehouse on `ts_valemere`; Coleford on `ts_coleford`; both garrison rooms on `ts_garrison`; the Blackwood shrine and glade on `ts_blackwood`; the three barrow rooms on `ts_barrow`. Seven tilesets exist (`ts_zone1`, `ts_wrenfield`, `ts_blackwood`, `ts_barrow`, `ts_valemere`, `ts_coleford`, `ts_garrison`); the Blackwood atlas is still a placeholder. The Aethari doors and the shrine's stone face are three stone tiles each.
