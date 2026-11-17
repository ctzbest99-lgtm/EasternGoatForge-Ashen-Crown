# Asset Inventory

Measured 2026-11-16. Source art lives under `game/sprites/`, `game/audio/` and `game/tilesets/`; the GameMaker resources under `gamemaker/` are generated from it. Import settings (asset name, frames, origin, mask, fps) are in `game/sprites/IMPORT.md` and `game/sprites/README.md`.

**Totals:** 844 sprite resources and 29 sound resources in `gamemaker/`, 34 rooms, 2 tilesets, 95 scripts. **Nothing here has been compiled or playtested in GameMaker.** All assets are the property of Eastern Goat Forge (see LICENSE).

## Characters

| Asset | Status | Notes |
|---|---|---|
| Kael overworld 16×24 (`spr_kael_ow16_*`) | In repo, in use | 16×24, origin (8, 23), 1-frame idle + 4-frame walk × 4 directions. `scr_sprites` wires it to `obj_player`. Source: `game/sprites/hero/overworld/16x24/`. |
| Kael overworld 32×48 (`spr_kael_ow_*`) | In repo, fallback only | 32×48, origin (16, 47). Used only if the 16×24 set is missing. |
| Kael battle (`spr_hero_*`) | In repo | Idle 4 / walk 8 / attack 6 / hurt 3 / death 6. Idle/walk are 32×48 strips; attack and death are 48×48; origin (16, 47). Naming differs from the overworld set (`spr_hero_*` vs `spr_kael_ow*`). |
| Party kits: Sera, Caelan, Lyra | In repo, generated | Each has a 16×24 four-direction idle + walk4 set, 32×48 idle/walk/hurt/defend, 48×48 attack/death and three 48×48 portraits (neutral, determined, pained). All three are drawn by `game/sprites/src/party_kit.py` from one template, so they share Taren's proportions; weapons are longsword (Sera), crystal staff (Caelan) and twin daggers (Lyra). |
| Taren Holt | In repo | Hand-drawn 16×24 set, battle strips and a 48×48 portrait. Taren's overworld grids are the template the party kit is transcribed from. |
| NPC overworld sets (27 kinds) | In repo | 16×24 sets in `game/sprites/npcs/<name>/` for the Greyhaven survivors, Wrenfield pair, Valemere cast, garrison officers and story characters. |
| Portraits (19 sets) | In repo | 48×48, origin (0, 0): the five party members plus Tomas, Renn, the Fallen Knight, Bram, Oda, Perrin, Len, Marda, Hob, Pell, the Debtman, Reeve Calder and Commander Hailen. |

## Enemies and bosses

| Asset | Status | Notes |
|---|---|---|
| Enemy battle art (31 folders) | In repo | Idle 4 / walk / attack 6 / hurt / death per kind; 32×48, with bosses at 48×64 and two at 96×96. All 43 bestiary entries resolve to art (the Act III/IV boss ids and Emberwake reuse a base creature's strips; no Act IV enemy and no Emberwake has its own art yet). |
| Blackguard | In repo | Three phases plus both transitions in `game/sprites/blackguard/phases/`. |
| Bandit | In repo | Overworld 16×24 and 32×48 sets, battle strips. The overworld set is not wired (no overworld Bandit object). |
| Fallen Knight (enemy) | Battle only | 64×48 attack, 48×48 death; **no overworld set**. |
| Zone 1 boss / rare encounter | In repo | The Blackguard is the Zone 1 boss; the Ashbound Hunter is the rare encounter. |
| Enemy overworld sets | 18 kinds missing | 27 kinds have 16×24 map sets. The gap is listed below. |

## Interface and presentation

| Asset | Status | Notes |
|---|---|---|
| UI kit | In repo | Nine-slice window 24×24 (`spr_ui_window`, plus dim and gold variants), cursor strip 2×32×12, select bar, slider track and knob, toggle strip 2, dither, bars and frames for HP/MP, critical/low HP bar fills. |
| Bitmap font | In repo | `spr_font_main_strip95` 570×10 (95 glyphs, 6×10 cell), plus a no-shadow variant used inside dim windows. |
| Numbers and status | In repo | Damage digits strip 10 (70×9) with miss/weak/critical marks, heal digits, critical digits, status icon strip 12 (120×10, 10×10 cells). Blind and sleep have no icon frame yet. |
| Menu parts | In repo | 34 parts in `game/sprites/ui/menus/` (arrows, icons, panels, save point), plus mockups. |
| Marker sprites (10) | In repo, real art | `spr_{solid,interactable,story_npc,player,respawn_point,encounter_trigger,encounter_zone,story_trigger,story_encounter,trap_plate}_placeholder`: 16×16 icons/props (16×24 for the player fallback) from `game/sprites/src/markers.py`. Most draw only with `DEBUG_SHOW_TRIGGERS`. |
| Title and main menu | In repo | 19 files each at 320 and 640: logo (250×71 at 320), four parallax layers, ember loop strip 24, cursor strip 4, option graphics, save/options panels, mockups. |
| Battle backgrounds | In repo | 5 × 320×180: forest, bandit camp, Blackguard arena, Blackwood, garrison yard. |
| Item icons and chests | In repo | 17 × 16×16 icons (potions, key items, weapons, armour, the pendant) and wood/iron chests, closed and opening strip 3. |

## World

| Asset | Status | Notes |
|---|---|---|
| Zone 1 tileset (`ts_zone1.png`) | In repo | 256×800, 16×16 tiles, 16 columns × **50 rows**, no spacing. Import as sprite `spr_ts_zone1`, then tileset `ts_zone1`. |
| Wrenfield tileset (`ts_wrenfield.png`) | In repo | 256×1040, 16×16 tiles, 16 columns × 65 rows. Also used by the Chapter 3–5 blockout rooms. |
| Blackwood tileset (`ts_blackwood.png`) | In repo, placeholder | 256×1040, 16×16 tiles. Rows 0–49 are `ts_zone1` unchanged; rows 50–64 (ids 800–1039) are the wood's own dark material: moss floor, black road, charcoal, bog, thorn walls, dead canopy and trunks, kilns and stone. Drawn by `tools/gen_blackwood_tileset.py`. Used by the Chapter 6 rooms. |
| Tile id map (`game/tilesets/tile_ids.json`) | In repo | Named tile ids used by the room builders. |
| Map data | In repo | `game/datafiles/overworld/` (400×300 × 5 layers, bin + chunk fallback), `game/maps/chapter2/`, `game/maps/interiors/`, `game/maps/old_watchtower_csv/`, `game/maps/watchtower_basement_csv/`, plus marker JSON. Chapters 3–5 rooms are built from `scr_build_*` arrays. |

## Audio

| Asset | Status | Notes |
|---|---|---|
| Music (3 loops) | In repo, original | `snd_mus_overworld.wav` 40.0 s, `snd_mus_battle.wav` 37.9 s, `snd_mus_boss.wav` 34.3 s; 22050 Hz mono 16-bit, synthesised by `tools/audio/tracks.py`. |
| Ambience (6 beds) | In repo, original | `snd_amb_wind/forest/dungeon/fire/water/night.wav`, 9.6–11.5 s loop-safe. `night` now plays in the Blackwood shrine and glade (Chapters 7); `water` is still unassigned. |
| Effects (20) | In repo, original | Character, menu and UI cues; four are generated but unhooked (`arrow`, `enemy_fall`, `party_hurt`, `menu_open`), and `step` is deliberately unused. Names, durations and hook points are in `docs/AUDIO.md`. |
| Sound resources | In repo | 29 `GMSound` resources. Never heard in GameMaker. |

## Source

| Asset | Status | Notes |
|---|---|---|
| Sprite generators | In repo (`game/sprites/src/*.py`) | Python + Pillow, deterministic. Do not import as game assets. |
| Audio generators | In repo (`tools/audio/`) | Python synthesis; run `python3 tools/audio/build.py`. |
| Import tools | In repo (`tools/import_sprites.py`, `tools/import_sounds.py`) | `--refresh` rewrites pixels of existing resources without touching ids. |

**Known art gaps (measured):**
- 18 enemy kinds have battle art but no 16×24 overworld set: `bandit_veteran`, `briar_hulk`, `crown_crossbowman`, `crown_patrolman`, `cutpurse`, `dock_thug`, `garrison_field_surgeon`, `garrison_pikeman`, `glyph_wisp`, `grey_ash_wolf`, `lost_one`, `night_moth_swarm`, `occupation_soldier`, `sanctuary_warden`, `shade_stalker`, `spiderling`, `ward_sentinel`, `fallen_knight`.
- Alden Marr has no sprite at all; Nim and Derry have no portrait; the Ash King and the rare-encounter concept art are unstarted.
- No Guard battle pose; no left-facing battle strips (the party is flipped with `image_xscale`).
- Status icon strip has no frames for blind or sleep (they show as "Bl" / "Sl" text).
- Kael's hurt clip is 3 frames (Bandit 4, Fallen Knight 6), and the battle vs overworld naming mismatch (`spr_hero_*` / `spr_kael_ow*`) still stands.
- Chapters 3–11 rooms use Wrenfield tiles as blockouts — every Act III room among them; only two tilesets exist. The Aethari doors and the shrine's stone face are three stone tiles each.
