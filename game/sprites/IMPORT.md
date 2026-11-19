# Sprite import table

These PNGs live in `game/sprites/` and are **not** a GameMaker project. Create each Sprite in the IDE and import the file by hand. GameMaker auto-splits a strip when the filename ends in `_stripN` (N = frame count). Keep the asset name identical to the filename without `.png` (including `_stripN`) so the GML `asset_get_index` lookups match.

All battle strips face right. Overworld `left` frames are already mirrored; do **not** set `image_xscale` on the player. Code falls back to placeholder rectangles (battle) or the object's IDE sprite (overworld) when an asset is missing, so the project can compile before every sprite is imported.

**Recommended overworld set:** Kael's 16×24 sprites (`hero/overworld/16x24/`). Assign `spr_kael_ow16_idle_down` to `obj_player`. The 32×48 overworld set is included as a fallback the code will use only if the 16×24 assets are absent.

**Playback:** overworld walk 8 fps; battle idle 6 fps; battle attack / hurt / death 10 fps. These are macros in `scr_game_constants` (`PLAYER_WALK_FPS`, `BATTLE_IDLE_FPS`, `BATTLE_ANIM_FPS`).

**Collision masks** are set in the Sprite Editor (Image → Collision Mask). Use a **manual rectangle**, **not** automatic per-frame, so wider attack and death strips cannot change the hitbox. The player code also pins `mask_index` to the idle-down sprite.

The Zone 1 tileset is `game/tilesets/ts_zone1.png` (see `game/tilesets/README.md`). Character sprites stay in this table; the Mira pendant icon is below.

Source generators (`game/sprites/src/*.py`, Python + Pillow) are included because they are small. Run e.g. `python3 src/hero.py` from `game/sprites/` to regenerate a set. Do not import anything in `src/`.

Preview PNGs and walk GIFs are reference only; do not import them as game sprites.

---

## How to import one sprite

1. Asset Browser → Create → Sprite. Name it exactly as in the **Asset name** column.
2. Import the PNG in the Sprite Editor. Confirm the frame count matches **Frames**.
3. Set **Origin** to the values below (or type them; do not use default Top Left).
4. Collision Mask: Mode Manual, Type Rectangle, values in **Mask (left, top, right, bottom)** (pixel coordinates in one frame, 0-based, inclusive).
5. Playback: set texture / playback speed to the **FPS** column if you want a preview in the editor. Runtime speed is driven by code.

---

## Overworld — Kael 16×24 (recommended)

Folder: `hero/overworld/16x24/`. Frame size 16×24. Origin (8, 23) — feet on the bottom row. Tile footprint: 1 tile wide, 1.5 tall (the head overlaps the tile above). Mask is the standing 16×16 tile (the lower 16 pixels), so the head can overlap a wall or tree in the tile above without getting stuck.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_kael_ow16_idle_down` | `hero/overworld/16x24/spr_kael_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_idle_up` | `hero/overworld/16x24/spr_kael_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_idle_left` | `hero/overworld/16x24/spr_kael_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_idle_right` | `hero/overworld/16x24/spr_kael_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_walk_down_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_kael_ow16_walk_up_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_kael_ow16_walk_left_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_kael_ow16_walk_right_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

Assign `spr_kael_ow16_idle_down` as the `obj_player` sprite after import.

## Overworld — Bandit 16×24 (for future NPCs; not wired yet)

Folder: `bandit/overworld/16x24/`. Same size, origin, and mask as Kael 16×24.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_bandit_ow16_idle_down` | `bandit/overworld/16x24/spr_bandit_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_idle_up` | `bandit/overworld/16x24/spr_bandit_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_idle_left` | `bandit/overworld/16x24/spr_bandit_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_idle_right` | `bandit/overworld/16x24/spr_bandit_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_walk_down_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_ow16_walk_up_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_ow16_walk_left_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_ow16_walk_right_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

## Overworld — Kael 32×48 (optional fallback)

Folder: `hero/overworld/`. Frame size 32×48. Origin (16, 47). Tile footprint: 2 wide × 3 tall. Mask is the lower 32×32 (two tiles), so the top 16 pixels may overlap the tile above.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_kael_ow_idle_down` | `hero/overworld/spr_kael_ow_idle_down.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_kael_ow_idle_up` | `hero/overworld/spr_kael_ow_idle_up.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_kael_ow_idle_left` | `hero/overworld/spr_kael_ow_idle_left.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_kael_ow_idle_right` | `hero/overworld/spr_kael_ow_idle_right.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_kael_ow_walk_down_strip4` | `hero/overworld/spr_kael_ow_walk_down_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |
| `spr_kael_ow_walk_up_strip4` | `hero/overworld/spr_kael_ow_walk_up_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |
| `spr_kael_ow_walk_left_strip4` | `hero/overworld/spr_kael_ow_walk_left_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |
| `spr_kael_ow_walk_right_strip4` | `hero/overworld/spr_kael_ow_walk_right_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |

## Overworld — Bandit 32×48 (optional; not wired yet)

Folder: `bandit/overworld/`. Same size, origin, and mask as Kael 32×48.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_bandit_ow_idle_down` | `bandit/overworld/spr_bandit_ow_idle_down.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_bandit_ow_idle_up` | `bandit/overworld/spr_bandit_ow_idle_up.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_bandit_ow_idle_left` | `bandit/overworld/spr_bandit_ow_idle_left.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_bandit_ow_idle_right` | `bandit/overworld/spr_bandit_ow_idle_right.png` | 1 | 32×48 | (16, 47) | 0, 16, 31, 47 | 0 |
| `spr_bandit_ow_walk_down_strip4` | `bandit/overworld/spr_bandit_ow_walk_down_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |
| `spr_bandit_ow_walk_up_strip4` | `bandit/overworld/spr_bandit_ow_walk_up_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |
| `spr_bandit_ow_walk_left_strip4` | `bandit/overworld/spr_bandit_ow_walk_left_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |
| `spr_bandit_ow_walk_right_strip4` | `bandit/overworld/spr_bandit_ow_walk_right_strip4.png` | 4 | 32×48 | (16, 47) | 0, 16, 31, 47 | 8 |

## Battle — Kael (`spr_hero_*`)

Folder: `hero/`. All strips face right. The party is drawn with `xscale = -1` so Kael faces the enemy. Use a **fixed** mask from the idle frame on every battle sprite, including the wider death strip. Battle drawing is done in Draw GUI (not physics), but the mask keeps the assets consistent if they are later used on instances.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_hero_idle_strip4` | `hero/spr_hero_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 6 |
| `spr_hero_defend_strip3` | `hero/spr_hero_defend_strip3.png` | 3 | 32×48 | (16, 47) | 8, 16, 23, 47 | 6 |
| `spr_hero_walk_strip8` | `hero/spr_hero_walk_strip8.png` | 8 | 32×48 | (16, 47) | 8, 16, 23, 47 | 8 |
| `spr_hero_attack_strip6` | `hero/spr_hero_attack_strip6.png` | 6 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_hero_hurt_strip3` | `hero/spr_hero_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_hero_death_strip6` | `hero/spr_hero_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 16, 23, 47 | 10 |

The death strip is 48 wide so the body can fall flat, forward (to the right of the origin, or to the left when flipped).

## Battle — Bandit

Folder: `bandit/`. Faces right (toward the party). Same idle-frame mask on every strip.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_bandit_idle_strip4` | `bandit/spr_bandit_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 6 |
| `spr_bandit_walk_strip4` | `bandit/spr_bandit_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 8 |
| `spr_bandit_attack_strip6` | `bandit/spr_bandit_attack_strip6.png` | 6 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_bandit_hurt_strip4` | `bandit/spr_bandit_hurt_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_bandit_death_strip6` | `bandit/spr_bandit_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 16, 23, 47 | 10 |

## Battle — Fallen Knight

Folder: `fallen_knight/`. Faces right. The attack strip is 64×48 with origin **(32, 47)**: 16 px of wind-up behind the feet and 32 px of reach in front. Keep the feet on the same point as idle by honouring that origin (the battle drawer uses `draw_sprite_ext` at the feet and lets the sprite origin do the work). Still use the **idle-frame** mask (16×32 body over the 32×48 idle), not the full 64-wide frame.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_fallen_knight_idle_strip8` | `fallen_knight/spr_fallen_knight_idle_strip8.png` | 8 | 32×48 | (16, 47) | 8, 16, 23, 47 | 6 |
| `spr_fallen_knight_walk_strip8` | `fallen_knight/spr_fallen_knight_walk_strip8.png` | 8 | 32×48 | (16, 47) | 8, 16, 23, 47 | 8 |
| `spr_fallen_knight_attack_strip6` | `fallen_knight/spr_fallen_knight_attack_strip6.png` | 6 | 64×48 | (32, 47) | 24, 16, 39, 47 | 10 |
| `spr_fallen_knight_hurt_strip6` | `fallen_knight/spr_fallen_knight_hurt_strip6.png` | 6 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_fallen_knight_death_strip8` | `fallen_knight/spr_fallen_knight_death_strip8.png` | 8 | 48×48 | (16, 47) | 8, 16, 23, 47 | 10 |

The Fallen Knight attack mask is shifted by +16 in X so it still covers the same body box relative to the feet (origin x is 32 instead of 16).

## Placeholder room sprites (unchanged role, new size)

These are still drawn in the IDE if you want visible walls, signs, and triggers. They are not in `game/sprites/`; create them as flat-colour sprites.

| Asset name | Size | Origin | Mask | Notes |
|---|---|---|---|---|
| `spr_player_placeholder` | 16×24 | (8, 23) | 0, 8, 15, 23 | Only needed if the Kael 16×24 set is not imported yet |
| `spr_solid_placeholder` | 16×16 | Top Left (0, 0) | Full image | Dark grey walls |
| `spr_interactable_placeholder` | 16×16 | Top Left (0, 0) | Full image | Sign / inspect target |
| `spr_encounter_trigger_placeholder` | 16×16 | Top Left (0, 0) | Full image | Stretchable; semi-transparent red |
| `spr_encounter_zone_placeholder` | 16×16 | Top Left (0, 0) | Full image | Stretchable; semi-transparent yellow |
| `spr_respawn_point_placeholder` | 16×16 | Top Left (0, 0) | Full image | Optional layout marker |

Existing 32×32 / 32×48 placeholders still work (collision uses `bbox_*`), but 16×16 matches the new tile grid.

## Do not import

| File | Reason |
|---|---|
| `*/**_preview.png`, `*/**_walk_preview.gif` | Reference sheets and animated previews only |
| `src/*.py` | Generators, not game assets |
| Zone 1 `ts_zone1.png` / map CSVs | Still being built; not in this repo |

---

## Items

Folder: `items/`. Preview PNGs are reference only; do not import them.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_item_mira_pendant` | `items/spr_item_mira_pendant.png` | 1 | (see image) | Top Left or centred on the tile | full image | 0 |

Optional overworld icon for the pendant marker at Varyn House (186, 169). If it is not imported, the interactable placeholder is used. Key-item inventory still uses the `item_mira_pendant` id regardless.

---

## Chapter 1 art (feature/ch1-art)

Design's remaining Chapter 1 set lives under `blackguard/`, `enemies/`, `npcs/`, `portraits/`, `title/`, `ui/`, and `items/` (the Mira pendant from PR #6 stays in `items/`). A copy of Design's sizes, origins, and layout notes is in `README_CH1_ART.md`; batch status is in `STATUS.md`.

Do **not** import `*_preview.png`, `*_preview.gif`, `title/mockups/`, `ui/mockups/`, or anything in `src/`.

`scr_ui_init()` locks the GUI to **320×180**. Import the 320 title set first; the 640 set is optional. After import, **uncheck Game Options ▸ Graphics ▸ Interpolate colours between pixels**.

### Font (`spr_font_main_strip95`)

95 glyphs, 6×10 cells, ASCII 32–126. Origin (0, 0). Do not create a Font asset — the game builds it at runtime:

```gml
global.fnt_main = font_add_sprite_ext(spr_font_main_strip95,
    " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~", true, 1);
```

(`spr_font_main_noshadow_strip95` is optional; the game uses the shadowed strip.)

### Nine-slice and texture groups

1. `spr_ui_window`, `spr_ui_window_dim`, `spr_ui_window_gold`: nine-slice on, 8 px on every side, Stretch or Repeat.
2. `spr_ui_select_bar`: nine-slice 3 px on every side.
3. `spr_ui_slider_track`: nine-slice 2 px on every side.
4. **Texture group (required for the 640 ember strip):** `spr_menu_embers_640_strip24` spans two default texture pages. Create a Texture Group (e.g. `tex_title_640`) with a 2048×2048 (or larger) page and assign the 640 title sprites to it. If that import fails or looks sliced, skip the 640 ember strip — `obj_title` will use `spr_menu_embers_320_strip24` scaled logically via the 320 fallback.

Code looks up every asset with `asset_get_index`. A missing sprite falls back to a rectangle, the object's IDE sprite, or the default font, and will not crash.

### Other

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_bandit_ow16_idle_down` | `bandit/overworld/16x24/spr_bandit_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_idle_left` | `bandit/overworld/16x24/spr_bandit_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_idle_right` | `bandit/overworld/16x24/spr_bandit_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_idle_up` | `bandit/overworld/16x24/spr_bandit_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_ow16_walk_down_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_ow16_walk_left_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_ow16_walk_right_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_ow16_walk_up_strip4` | `bandit/overworld/16x24/spr_bandit_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_ow_idle_down` | `bandit/overworld/spr_bandit_ow_idle_down.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_bandit_ow_idle_left` | `bandit/overworld/spr_bandit_ow_idle_left.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_bandit_ow_idle_right` | `bandit/overworld/spr_bandit_ow_idle_right.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_bandit_ow_idle_up` | `bandit/overworld/spr_bandit_ow_idle_up.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_bandit_ow_walk_down_strip4` | `bandit/overworld/spr_bandit_ow_walk_down_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_bandit_ow_walk_left_strip4` | `bandit/overworld/spr_bandit_ow_walk_left_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_bandit_ow_walk_right_strip4` | `bandit/overworld/spr_bandit_ow_walk_right_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_bandit_ow_walk_up_strip4` | `bandit/overworld/spr_bandit_ow_walk_up_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_bandit_attack_strip6` | `bandit/spr_bandit_attack_strip6.png` | 6 | 32×48 | (16, 47) | full image | 10 |
| `spr_bandit_death_strip6` | `bandit/spr_bandit_death_strip6.png` | 6 | 48×48 | (16, 47) | full image | 10 |
| `spr_bandit_hurt_strip4` | `bandit/spr_bandit_hurt_strip4.png` | 4 | 32×48 | (16, 47) | full image | 10 |
| `spr_bandit_idle_strip4` | `bandit/spr_bandit_idle_strip4.png` | 4 | 32×48 | (16, 47) | full image | 6 |
| `spr_bandit_walk_strip4` | `bandit/spr_bandit_walk_strip4.png` | 4 | 32×48 | (16, 47) | full image | 10 |
| `spr_fallen_knight_attack_strip6` | `fallen_knight/spr_fallen_knight_attack_strip6.png` | 6 | 64×48 | (32, 47) | full image | 10 |
| `spr_fallen_knight_death_strip8` | `fallen_knight/spr_fallen_knight_death_strip8.png` | 8 | 48×48 | (16, 47) | full image | 10 |
| `spr_fallen_knight_hurt_strip6` | `fallen_knight/spr_fallen_knight_hurt_strip6.png` | 6 | 32×48 | (16, 47) | full image | 10 |
| `spr_fallen_knight_idle_strip8` | `fallen_knight/spr_fallen_knight_idle_strip8.png` | 8 | 32×48 | (16, 47) | full image | 6 |
| `spr_fallen_knight_walk_strip8` | `fallen_knight/spr_fallen_knight_walk_strip8.png` | 8 | 32×48 | (16, 47) | full image | 10 |
| `spr_kael_ow16_idle_down` | `hero/overworld/16x24/spr_kael_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_idle_left` | `hero/overworld/16x24/spr_kael_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_idle_right` | `hero/overworld/16x24/spr_kael_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_idle_up` | `hero/overworld/16x24/spr_kael_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_kael_ow16_walk_down_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_kael_ow16_walk_left_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_kael_ow16_walk_right_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_kael_ow16_walk_up_strip4` | `hero/overworld/16x24/spr_kael_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_kael_ow_idle_down` | `hero/overworld/spr_kael_ow_idle_down.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_kael_ow_idle_left` | `hero/overworld/spr_kael_ow_idle_left.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_kael_ow_idle_right` | `hero/overworld/spr_kael_ow_idle_right.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_kael_ow_idle_up` | `hero/overworld/spr_kael_ow_idle_up.png` | 1 | 32×48 | (16, 47) | full image | 0 |
| `spr_kael_ow_walk_down_strip4` | `hero/overworld/spr_kael_ow_walk_down_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_kael_ow_walk_left_strip4` | `hero/overworld/spr_kael_ow_walk_left_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_kael_ow_walk_right_strip4` | `hero/overworld/spr_kael_ow_walk_right_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_kael_ow_walk_up_strip4` | `hero/overworld/spr_kael_ow_walk_up_strip4.png` | 4 | 32×48 | (16, 47) | full image | 8 |
| `spr_hero_attack_strip6` | `hero/spr_hero_attack_strip6.png` | 6 | 32×48 | (16, 47) | full image | 10 |
| `spr_hero_death_strip6` | `hero/spr_hero_death_strip6.png` | 6 | 48×48 | (16, 47) | full image | 10 |
| `spr_hero_defend_strip3` | `hero/spr_hero_defend_strip3.png` | 3 | 32×48 | (16, 47) | full image | 6 |
| `spr_hero_hurt_strip3` | `hero/spr_hero_hurt_strip3.png` | 3 | 32×48 | (16, 47) | full image | 10 |
| `spr_hero_idle_strip4` | `hero/spr_hero_idle_strip4.png` | 4 | 32×48 | (16, 47) | full image | 6 |
| `spr_hero_walk_strip8` | `hero/spr_hero_walk_strip8.png` | 8 | 32×48 | (16, 47) | full image | 10 |

### Blackguard overworld 16×24
Recommended overworld / arena set. Origin (8, 23). Mask is the standing 16×16 tile. `left` is pre-mirrored.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_blackguard_ow16_idle_down` | `blackguard/overworld/16x24/spr_blackguard_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackguard_ow16_idle_left` | `blackguard/overworld/16x24/spr_blackguard_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackguard_ow16_idle_right` | `blackguard/overworld/16x24/spr_blackguard_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackguard_ow16_idle_up` | `blackguard/overworld/16x24/spr_blackguard_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackguard_ow16_walk_down_strip4` | `blackguard/overworld/16x24/spr_blackguard_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_blackguard_ow16_walk_left_strip4` | `blackguard/overworld/16x24/spr_blackguard_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_blackguard_ow16_walk_right_strip4` | `blackguard/overworld/16x24/spr_blackguard_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_blackguard_ow16_walk_up_strip4` | `blackguard/overworld/16x24/spr_blackguard_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

### Blackguard overworld 32×48 (optional fallback)
Only if the 16×24 set is not imported. Origin (16, 47).

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_blackguard_ow_idle_down` | `blackguard/overworld/spr_blackguard_ow_idle_down.png` | 1 | 32×48 | (16, 47) | 8, 16, 39, 63 | 0 |
| `spr_blackguard_ow_idle_left` | `blackguard/overworld/spr_blackguard_ow_idle_left.png` | 1 | 32×48 | (16, 47) | 8, 16, 39, 63 | 0 |
| `spr_blackguard_ow_idle_right` | `blackguard/overworld/spr_blackguard_ow_idle_right.png` | 1 | 32×48 | (16, 47) | 8, 16, 39, 63 | 0 |
| `spr_blackguard_ow_idle_up` | `blackguard/overworld/spr_blackguard_ow_idle_up.png` | 1 | 32×48 | (16, 47) | 8, 16, 39, 63 | 0 |
| `spr_blackguard_ow_walk_down_strip4` | `blackguard/overworld/spr_blackguard_ow_walk_down_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 39, 63 | 8 |
| `spr_blackguard_ow_walk_left_strip4` | `blackguard/overworld/spr_blackguard_ow_walk_left_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 39, 63 | 8 |
| `spr_blackguard_ow_walk_right_strip4` | `blackguard/overworld/spr_blackguard_ow_walk_right_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 39, 63 | 8 |
| `spr_blackguard_ow_walk_up_strip4` | `blackguard/overworld/spr_blackguard_ow_walk_up_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 39, 63 | 8 |

### Blackguard phases and transitions
Same origins as Phase 1 so `sprite_index` can swap without a jump. Play `transition_p1to2` at 60% HP and `transition_p2to3` at 20% HP (~10 fps, once). Final death is `spr_blackguard_p3_death_strip8`.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_blackguard_p2_attack_strip6` | `blackguard/phases/spr_blackguard_p2_attack_strip6.png` | 6 | 96×64 | (40, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p2_hurt_strip4` | `blackguard/phases/spr_blackguard_p2_hurt_strip4.png` | 4 | 48×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p2_idle_strip8` | `blackguard/phases/spr_blackguard_p2_idle_strip8.png` | 8 | 48×64 | (24, 63) | 8, 16, 39, 63 | 6 |
| `spr_blackguard_p2_lunge_strip6` | `blackguard/phases/spr_blackguard_p2_lunge_strip6.png` | 6 | 96×64 | (40, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p2_oath_strip6` | `blackguard/phases/spr_blackguard_p2_oath_strip6.png` | 6 | 48×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p2_walk_strip8` | `blackguard/phases/spr_blackguard_p2_walk_strip8.png` | 8 | 48×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p3_attack_strip5` | `blackguard/phases/spr_blackguard_p3_attack_strip5.png` | 5 | 96×64 | (40, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p3_death_strip8` | `blackguard/phases/spr_blackguard_p3_death_strip8.png` | 8 | 64×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p3_execution_strip8` | `blackguard/phases/spr_blackguard_p3_execution_strip8.png` | 8 | 96×64 | (40, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p3_hurt_strip4` | `blackguard/phases/spr_blackguard_p3_hurt_strip4.png` | 4 | 48×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_p3_idle_strip8` | `blackguard/phases/spr_blackguard_p3_idle_strip8.png` | 8 | 48×64 | (24, 63) | 8, 16, 39, 63 | 6 |
| `spr_blackguard_p3_walk_strip8` | `blackguard/phases/spr_blackguard_p3_walk_strip8.png` | 8 | 48×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_transition_p1to2_strip8` | `blackguard/phases/spr_blackguard_transition_p1to2_strip8.png` | 8 | 64×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_transition_p2to3_strip8` | `blackguard/phases/spr_blackguard_transition_p2to3_strip8.png` | 8 | 64×64 | (24, 63) | 8, 16, 39, 63 | 10 |

### Blackguard Phase 1 battle
48×64 body, origin (24, 63). Attack and Shield Bash are 96×64, origin (40, 63). Phase 1 `spr_blackguard_death_strip8` is **debug only**; the live fight uses `spr_blackguard_p3_death_strip8`.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_blackguard_attack_strip6` | `blackguard/spr_blackguard_attack_strip6.png` | 6 | 96×64 | (40, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_death_strip8` | `blackguard/spr_blackguard_death_strip8.png` | 8 | 64×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_hurt_strip6` | `blackguard/spr_blackguard_hurt_strip6.png` | 6 | 48×64 | (24, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_idle_strip8` | `blackguard/spr_blackguard_idle_strip8.png` | 8 | 48×64 | (24, 63) | 8, 16, 39, 63 | 6 |
| `spr_blackguard_shieldbash_strip8` | `blackguard/spr_blackguard_shieldbash_strip8.png` | 8 | 96×64 | (40, 63) | 8, 16, 39, 63 | 10 |
| `spr_blackguard_walk_strip8` | `blackguard/spr_blackguard_walk_strip8.png` | 8 | 48×64 | (24, 63) | 8, 16, 39, 63 | 10 |

### Enemy overworld
Humanoids (Wretch, Hunter, Hollow Soldier, and unused-here Bandit-scale) are 16×24 origin (8, 23). Wolf and Grave Spider are 16×16 origin (8, 15). Walk loops are 4 frames at 8 fps.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_ash_wolf_ow16_idle_down` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_idle_down.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_ash_wolf_ow16_idle_left` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_idle_left.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_ash_wolf_ow16_idle_right` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_idle_right.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_ash_wolf_ow16_idle_up` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_idle_up.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_ash_wolf_ow16_walk_down_strip4` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_walk_down_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_ash_wolf_ow16_walk_left_strip4` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_walk_left_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_ash_wolf_ow16_walk_right_strip4` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_walk_right_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_ash_wolf_ow16_walk_up_strip4` | `enemies/ash_wolf/overworld/spr_ash_wolf_ow16_walk_up_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_ashbound_hunter_ow16_idle_down` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashbound_hunter_ow16_idle_left` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashbound_hunter_ow16_idle_right` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashbound_hunter_ow16_idle_up` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashbound_hunter_ow16_walk_down_strip4` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ashbound_hunter_ow16_walk_left_strip4` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ashbound_hunter_ow16_walk_right_strip4` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ashbound_hunter_ow16_walk_up_strip4` | `enemies/ashbound_hunter/overworld/spr_ashbound_hunter_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ashen_wretch_ow16_idle_down` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashen_wretch_ow16_idle_left` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashen_wretch_ow16_idle_right` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashen_wretch_ow16_idle_up` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ashen_wretch_ow16_walk_down_strip4` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ashen_wretch_ow16_walk_left_strip4` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ashen_wretch_ow16_walk_right_strip4` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ashen_wretch_ow16_walk_up_strip4` | `enemies/ashen_wretch/overworld/spr_ashen_wretch_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_grave_spider_ow16_idle_down` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_idle_down.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_grave_spider_ow16_idle_left` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_idle_left.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_grave_spider_ow16_idle_right` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_idle_right.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_grave_spider_ow16_idle_up` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_idle_up.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_grave_spider_ow16_walk_down_strip4` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_walk_down_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_grave_spider_ow16_walk_left_strip4` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_walk_left_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_grave_spider_ow16_walk_right_strip4` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_walk_right_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_grave_spider_ow16_walk_up_strip4` | `enemies/grave_spider/overworld/spr_grave_spider_ow16_walk_up_strip4.png` | 4 | 16×16 | (8, 15) | 0, 0, 15, 15 | 8 |
| `spr_hollow_soldier_ow16_idle_down` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hollow_soldier_ow16_idle_left` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hollow_soldier_ow16_idle_right` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hollow_soldier_ow16_idle_up` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hollow_soldier_ow16_walk_down_strip4` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_hollow_soldier_ow16_walk_left_strip4` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_hollow_soldier_ow16_walk_right_strip4` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_hollow_soldier_ow16_walk_up_strip4` | `enemies/hollow_soldier/overworld/spr_hollow_soldier_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

### Enemy battle strips
All face right (stand on the left of the battle screen). 32×48 humanoids origin (16, 47); 48×32 Wolf / Spider origin (24, 31). Hunter arrow 16×8 origin (15, 4). Spiderlings 16×16 origin (8, 15). Web projectile 16×16 origin (8, 8). Wider death frames keep the same feet origin.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_ash_wolf_attack_strip6` | `enemies/ash_wolf/spr_ash_wolf_attack_strip6.png` | 6 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_ash_wolf_death_strip6` | `enemies/ash_wolf/spr_ash_wolf_death_strip6.png` | 6 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_ash_wolf_howl_strip4` | `enemies/ash_wolf/spr_ash_wolf_howl_strip4.png` | 4 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_ash_wolf_hurt_strip3` | `enemies/ash_wolf/spr_ash_wolf_hurt_strip3.png` | 3 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_ash_wolf_idle_strip4` | `enemies/ash_wolf/spr_ash_wolf_idle_strip4.png` | 4 | 48×32 | (24, 31) | 8, 8, 39, 31 | 6 |
| `spr_ash_wolf_walk_strip4` | `enemies/ash_wolf/spr_ash_wolf_walk_strip4.png` | 4 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_ashbound_hunter_arrow_strip3` | `enemies/ashbound_hunter/spr_ashbound_hunter_arrow_strip3.png` | 3 | 16×8 | (15, 4) | 8, 16, 23, 47 | 10 |
| `spr_ashbound_hunter_attack_strip6` | `enemies/ashbound_hunter/spr_ashbound_hunter_attack_strip6.png` | 6 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_ashbound_hunter_death_strip6` | `enemies/ashbound_hunter/spr_ashbound_hunter_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_ashbound_hunter_hurt_strip3` | `enemies/ashbound_hunter/spr_ashbound_hunter_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_ashbound_hunter_idle_strip4` | `enemies/ashbound_hunter/spr_ashbound_hunter_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 6 |
| `spr_ashen_wretch_attack_strip6` | `enemies/ashen_wretch/spr_ashen_wretch_attack_strip6.png` | 6 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_ashen_wretch_death_strip6` | `enemies/ashen_wretch/spr_ashen_wretch_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_ashen_wretch_hurt_strip3` | `enemies/ashen_wretch/spr_ashen_wretch_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_ashen_wretch_idle_strip4` | `enemies/ashen_wretch/spr_ashen_wretch_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 6 |
| `spr_ashen_wretch_scream_strip4` | `enemies/ashen_wretch/spr_ashen_wretch_scream_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_grave_spider_attack_strip6` | `enemies/grave_spider/spr_grave_spider_attack_strip6.png` | 6 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_grave_spider_cast_strip4` | `enemies/grave_spider/spr_grave_spider_cast_strip4.png` | 4 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_grave_spider_death_strip6` | `enemies/grave_spider/spr_grave_spider_death_strip6.png` | 6 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_grave_spider_hurt_strip3` | `enemies/grave_spider/spr_grave_spider_hurt_strip3.png` | 3 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_grave_spider_idle_strip4` | `enemies/grave_spider/spr_grave_spider_idle_strip4.png` | 4 | 48×32 | (24, 31) | 8, 8, 39, 31 | 6 |
| `spr_grave_spider_walk_strip4` | `enemies/grave_spider/spr_grave_spider_walk_strip4.png` | 4 | 48×32 | (24, 31) | 8, 8, 39, 31 | 10 |
| `spr_grave_spider_web_proj_strip3` | `enemies/grave_spider/spr_grave_spider_web_proj_strip3.png` | 3 | 16×16 | (8, 8) | 8, 8, 39, 31 | 10 |
| `spr_spiderling_attack_strip4` | `enemies/grave_spider/spr_spiderling_attack_strip4.png` | 4 | 16×16 | (8, 15) | full image | 10 |
| `spr_spiderling_death_strip4` | `enemies/grave_spider/spr_spiderling_death_strip4.png` | 4 | 16×16 | (8, 15) | full image | 10 |
| `spr_spiderling_idle_strip4` | `enemies/grave_spider/spr_spiderling_idle_strip4.png` | 4 | 16×16 | (8, 15) | full image | 6 |
| `spr_spiderling_walk_strip4` | `enemies/grave_spider/spr_spiderling_walk_strip4.png` | 4 | 16×16 | (8, 15) | full image | 10 |
| `spr_hollow_soldier_attack_strip6` | `enemies/hollow_soldier/spr_hollow_soldier_attack_strip6.png` | 6 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_hollow_soldier_death_strip6` | `enemies/hollow_soldier/spr_hollow_soldier_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_hollow_soldier_guard_strip3` | `enemies/hollow_soldier/spr_hollow_soldier_guard_strip3.png` | 3 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_hollow_soldier_hurt_strip3` | `enemies/hollow_soldier/spr_hollow_soldier_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |
| `spr_hollow_soldier_idle_strip4` | `enemies/hollow_soldier/spr_hollow_soldier_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 6 |
| `spr_hollow_soldier_walk_strip4` | `enemies/hollow_soldier/spr_hollow_soldier_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 16, 23, 47 | 10 |

### Act II enemies — Millhaven Road / Wrenfield (feature/battle-upgrade)
Design batch 6 (`/workspace/sprites/README.md`, "Act II" section). All face right. Commons are 32×48, origin (16, 47); their attack strips are 48×48 with origin (24, 47) (bandit_veteran's attack stays 32×48, origin (16, 47)); death strips are 48×48 with origin (16, 47). `grey_ash_wolf` is 48×32, origin (24, 31). Reeve Calder is 48×64, origin (24, 63); his Heavy Strike attack is 96×64, origin (40, 63). Use the **idle bbox as a fixed manual mask** (values below, measured from each idle strip and shifted on the wider attack frames so the box stays on the body) so wider attack / death frames cannot change the hitbox. Battle drawing does not use masks; this only keeps the assets consistent.

- Crossbowman bolt `spr_crown_crossbowman_bolt_strip3` is a 16×8 projectile with origin (15, 4) at the tip; code spawns it on attack frame index 3.
- Reeve Calder has **no death strip**: `yield` plays once and holds its last frame (he lives). `stance` plays once when his last add falls. `spr_reeve_calder_idle_p2_strip8` arrived after Design's README was written (frames / origin assumed to match `idle`, 48×64, (24, 63)); code uses it after the stance and falls back to `idle` if it is not imported.
- Playback FPS below is Design's; runtime uses `BATTLE_IDLE_FPS` (loops) and `BATTLE_ANIM_FPS` (one-shots).
- Every name is looked up with `scr_sprite_index` / `asset_get_index`, so a missing import falls back to a rectangle and never blocks a turn.
- Do not import `*_preview.*`, `act2_veteran_palettes.png`, or the 4× frame sheets (not copied).

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_crown_patrolman_attack_strip6` | `enemies/crown_patrolman/spr_crown_patrolman_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 7, 35, 47 | 10 |
| `spr_crown_patrolman_brace_strip3` | `enemies/crown_patrolman/spr_crown_patrolman_brace_strip3.png` | 3 | 32×48 | (16, 47) | 8, 7, 27, 47 | 6 |
| `spr_crown_patrolman_death_strip6` | `enemies/crown_patrolman/spr_crown_patrolman_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 7, 27, 47 | 8 |
| `spr_crown_patrolman_hurt_strip3` | `enemies/crown_patrolman/spr_crown_patrolman_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 7, 27, 47 | 12 |
| `spr_crown_patrolman_idle_strip4` | `enemies/crown_patrolman/spr_crown_patrolman_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 27, 47 | 6 |
| `spr_crown_patrolman_walk_strip4` | `enemies/crown_patrolman/spr_crown_patrolman_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 27, 47 | 8 |
| `spr_crown_crossbowman_attack_strip6` | `enemies/crown_crossbowman/spr_crown_crossbowman_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 8, 39, 47 | 10 |
| `spr_crown_crossbowman_bolt_strip3` | `enemies/crown_crossbowman/spr_crown_crossbowman_bolt_strip3.png` | 3 | 16×8 | (15, 4) | full image | 12 |
| `spr_crown_crossbowman_death_strip6` | `enemies/crown_crossbowman/spr_crown_crossbowman_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 8, 31, 47 | 8 |
| `spr_crown_crossbowman_hurt_strip3` | `enemies/crown_crossbowman/spr_crown_crossbowman_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 8, 31, 47 | 12 |
| `spr_crown_crossbowman_idle_strip4` | `enemies/crown_crossbowman/spr_crown_crossbowman_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 8, 31, 47 | 6 |
| `spr_crown_crossbowman_walk_strip4` | `enemies/crown_crossbowman/spr_crown_crossbowman_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 8, 31, 47 | 8 |
| `spr_occupation_soldier_attack_strip6` | `enemies/occupation_soldier/spr_occupation_soldier_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 6, 37, 47 | 10 |
| `spr_occupation_soldier_death_strip6` | `enemies/occupation_soldier/spr_occupation_soldier_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 6, 29, 47 | 8 |
| `spr_occupation_soldier_guard_strip3` | `enemies/occupation_soldier/spr_occupation_soldier_guard_strip3.png` | 3 | 32×48 | (16, 47) | 8, 6, 29, 47 | 6 |
| `spr_occupation_soldier_hurt_strip3` | `enemies/occupation_soldier/spr_occupation_soldier_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 6, 29, 47 | 12 |
| `spr_occupation_soldier_idle_strip4` | `enemies/occupation_soldier/spr_occupation_soldier_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 6, 29, 47 | 6 |
| `spr_occupation_soldier_walk_strip4` | `enemies/occupation_soldier/spr_occupation_soldier_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 6, 29, 47 | 8 |
| `spr_bandit_veteran_attack_strip6` | `enemies/bandit_veteran/spr_bandit_veteran_attack_strip6.png` | 6 | 32×48 | (16, 47) | 3, 4, 29, 47 | 10 |
| `spr_bandit_veteran_death_strip6` | `enemies/bandit_veteran/spr_bandit_veteran_death_strip6.png` | 6 | 48×48 | (16, 47) | 3, 4, 29, 47 | 8 |
| `spr_bandit_veteran_hurt_strip4` | `enemies/bandit_veteran/spr_bandit_veteran_hurt_strip4.png` | 4 | 32×48 | (16, 47) | 3, 4, 29, 47 | 12 |
| `spr_bandit_veteran_idle_strip4` | `enemies/bandit_veteran/spr_bandit_veteran_idle_strip4.png` | 4 | 32×48 | (16, 47) | 3, 4, 29, 47 | 6 |
| `spr_bandit_veteran_walk_strip4` | `enemies/bandit_veteran/spr_bandit_veteran_walk_strip4.png` | 4 | 32×48 | (16, 47) | 3, 4, 29, 47 | 8 |
| `spr_grey_ash_wolf_attack_strip6` | `enemies/grey_ash_wolf/spr_grey_ash_wolf_attack_strip6.png` | 6 | 48×32 | (24, 31) | 4, 5, 42, 31 | 10 |
| `spr_grey_ash_wolf_death_strip6` | `enemies/grey_ash_wolf/spr_grey_ash_wolf_death_strip6.png` | 6 | 48×32 | (24, 31) | 4, 5, 42, 31 | 8 |
| `spr_grey_ash_wolf_howl_strip4` | `enemies/grey_ash_wolf/spr_grey_ash_wolf_howl_strip4.png` | 4 | 48×32 | (24, 31) | 4, 5, 42, 31 | 8 |
| `spr_grey_ash_wolf_hurt_strip3` | `enemies/grey_ash_wolf/spr_grey_ash_wolf_hurt_strip3.png` | 3 | 48×32 | (24, 31) | 4, 5, 42, 31 | 12 |
| `spr_grey_ash_wolf_idle_strip4` | `enemies/grey_ash_wolf/spr_grey_ash_wolf_idle_strip4.png` | 4 | 48×32 | (24, 31) | 4, 5, 42, 31 | 6 |
| `spr_grey_ash_wolf_walk_strip4` | `enemies/grey_ash_wolf/spr_grey_ash_wolf_walk_strip4.png` | 4 | 48×32 | (24, 31) | 4, 5, 42, 31 | 8 |
| `spr_reeve_calder_attack_strip6` | `enemies/reeve_calder/spr_reeve_calder_attack_strip6.png` | 6 | 96×64 | (40, 63) | 19, 5, 60, 63 | 10 |
| `spr_reeve_calder_guard_strip4` | `enemies/reeve_calder/spr_reeve_calder_guard_strip4.png` | 4 | 48×64 | (24, 63) | 3, 5, 44, 63 | 6 |
| `spr_reeve_calder_hurt_strip4` | `enemies/reeve_calder/spr_reeve_calder_hurt_strip4.png` | 4 | 48×64 | (24, 63) | 3, 5, 44, 63 | 12 |
| `spr_reeve_calder_idle_p2_strip8` | `enemies/reeve_calder/spr_reeve_calder_idle_p2_strip8.png` | 8 | 48×64 | (24, 63) | 3, 5, 44, 63 | 6 |
| `spr_reeve_calder_idle_strip8` | `enemies/reeve_calder/spr_reeve_calder_idle_strip8.png` | 8 | 48×64 | (24, 63) | 3, 5, 44, 63 | 6 |
| `spr_reeve_calder_shout_strip6` | `enemies/reeve_calder/spr_reeve_calder_shout_strip6.png` | 6 | 48×64 | (24, 63) | 3, 5, 44, 63 | 8 |
| `spr_reeve_calder_stance_strip6` | `enemies/reeve_calder/spr_reeve_calder_stance_strip6.png` | 6 | 48×64 | (24, 63) | 3, 5, 44, 63 | 8 |
| `spr_reeve_calder_walk_strip8` | `enemies/reeve_calder/spr_reeve_calder_walk_strip8.png` | 8 | 48×64 | (24, 63) | 3, 5, 44, 63 | 8 |
| `spr_reeve_calder_yield_strip8` | `enemies/reeve_calder/spr_reeve_calder_yield_strip8.png` | 8 | 48×64 | (24, 63) | 3, 5, 44, 63 | 8 |

#### Reeve Calder overworld (16×24, origin (8, 23); left = mirrored right)
Not wired to an object yet (the Wrenfield rooms do not exist). Names follow the Chapter 1 enemy overworld pattern, so `scr_ch1_bind_enemy_ow(inst, "reeve_calder", marker)` will pick them up.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_reeve_calder_ow16_idle_down` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_reeve_calder_ow16_idle_left` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_reeve_calder_ow16_idle_right` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_reeve_calder_ow16_idle_up` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_reeve_calder_ow16_walk_down_strip4` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_reeve_calder_ow16_walk_left_strip4` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_reeve_calder_ow16_walk_right_strip4` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_reeve_calder_ow16_walk_up_strip4` | `enemies/reeve_calder/overworld/spr_reeve_calder_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

#### Reeve Calder portraits (48×48, origin (0, 0))
`scr_ch1_portrait("Reeve Calder", "stern")` resolves these. `weary` is the yield face. Chapter 2 dialogue is not wired in this PR.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_portrait_reeve_calder_neutral` | `portraits/reeve_calder/spr_portrait_reeve_calder_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_reeve_calder_stern` | `portraits/reeve_calder/spr_portrait_reeve_calder_stern.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_reeve_calder_weary` | `portraits/reeve_calder/spr_portrait_reeve_calder_weary.png` | 1 | 48×48 | (0, 0) | full image | 0 |

### Act II enemies, batch 7: Wrenfield elite, Lower City, Hollow Sanctuary, Garrison (feature/enemy-batches-7-8)
Design batch 7 (`/workspace/sprites/README.md`, "batch 7"). All face right. Commons are 32×48 with origin (16, 47); their 48×48 attack / steal frames use (24, 47) and 48×48 death frames use (16, 47). The Debtman and Commander Hailen are 48×64 with origin (24, 63); their 96×64 attack / reel / special frames use (40, 63), and Hailen's 96×64 death keeps (24, 63) under the standing feet. The Sanctuary Warden is 96×96 with origin (48, 95). The wisp mote is 16×16 with origin (8, 8) (centre). Masks are the idle bbox (measured), shifted on wider frames so the box stays on the body.
- **No per-sprite code is needed.** These kinds are resolved by name (`scr_battle_auto_strip`: any `_stripN`, and `<anim>_p2` first in phase 2). A missing import draws a rectangle and never blocks a turn.
- Two-phase bosses (Sanctuary Warden): `trans` plays once at the shift, then `idle_p2` / `attack_p2` loop.
- Commander Hailen: `yield` holds its last frame if he yields (`flag_hailen_yields` set); otherwise `death` plays.
- Do not import `*_preview.*` / GIFs or the 4× frame sheets (not copied).
- `crown_sergeant` here is the **battle elite**. The Chapter 2 gate NPC is the separate `npcs/crown_sergeant_gate/` set.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_crown_sergeant_attack_strip6` | `enemies/crown_sergeant/spr_crown_sergeant_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 6, 38, 47 | 10 |
| `spr_crown_sergeant_cast_strip6` | `enemies/crown_sergeant/spr_crown_sergeant_cast_strip6.png` | 6 | 32×48 | (16, 47) | 8, 6, 30, 47 | 8 |
| `spr_crown_sergeant_death_strip6` | `enemies/crown_sergeant/spr_crown_sergeant_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 6, 30, 47 | 8 |
| `spr_crown_sergeant_hurt_strip3` | `enemies/crown_sergeant/spr_crown_sergeant_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 6, 30, 47 | 12 |
| `spr_crown_sergeant_idle_strip4` | `enemies/crown_sergeant/spr_crown_sergeant_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 6, 30, 47 | 6 |
| `spr_crown_sergeant_walk_strip4` | `enemies/crown_sergeant/spr_crown_sergeant_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 6, 30, 47 | 8 |
| `spr_dock_thug_attack_strip6` | `enemies/dock_thug/spr_dock_thug_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 7, 39, 47 | 10 |
| `spr_dock_thug_death_strip6` | `enemies/dock_thug/spr_dock_thug_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 7, 31, 47 | 8 |
| `spr_dock_thug_hurt_strip3` | `enemies/dock_thug/spr_dock_thug_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 7, 31, 47 | 12 |
| `spr_dock_thug_idle_strip4` | `enemies/dock_thug/spr_dock_thug_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 31, 47 | 6 |
| `spr_dock_thug_walk_strip4` | `enemies/dock_thug/spr_dock_thug_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 31, 47 | 8 |
| `spr_cutpurse_attack_strip6` | `enemies/cutpurse/spr_cutpurse_attack_strip6.png` | 6 | 48×48 | (24, 47) | 14, 8, 37, 47 | 10 |
| `spr_cutpurse_death_strip6` | `enemies/cutpurse/spr_cutpurse_death_strip6.png` | 6 | 48×48 | (16, 47) | 6, 8, 29, 47 | 8 |
| `spr_cutpurse_hurt_strip3` | `enemies/cutpurse/spr_cutpurse_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 6, 8, 29, 47 | 12 |
| `spr_cutpurse_idle_strip4` | `enemies/cutpurse/spr_cutpurse_idle_strip4.png` | 4 | 32×48 | (16, 47) | 6, 8, 29, 47 | 6 |
| `spr_cutpurse_steal_strip6` | `enemies/cutpurse/spr_cutpurse_steal_strip6.png` | 6 | 48×48 | (24, 47) | 14, 8, 37, 47 | 8 |
| `spr_cutpurse_walk_strip4` | `enemies/cutpurse/spr_cutpurse_walk_strip4.png` | 4 | 32×48 | (16, 47) | 6, 8, 29, 47 | 8 |
| `spr_debt_collector_attack_strip6` | `enemies/debt_collector/spr_debt_collector_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 7, 37, 47 | 10 |
| `spr_debt_collector_death_strip6` | `enemies/debt_collector/spr_debt_collector_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 7, 29, 47 | 8 |
| `spr_debt_collector_hurt_strip3` | `enemies/debt_collector/spr_debt_collector_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 7, 29, 47 | 12 |
| `spr_debt_collector_idle_strip4` | `enemies/debt_collector/spr_debt_collector_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 29, 47 | 6 |
| `spr_debt_collector_walk_strip4` | `enemies/debt_collector/spr_debt_collector_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 29, 47 | 8 |
| `spr_debtman_attack_strip6` | `enemies/debtman/spr_debtman_attack_strip6.png` | 6 | 96×64 | (40, 63) | 22, 4, 59, 63 | 10 |
| `spr_debtman_death_strip7` | `enemies/debtman/spr_debtman_death_strip7.png` | 7 | 48×64 | (24, 63) | 6, 4, 43, 63 | 8 |
| `spr_debtman_hurt_strip4` | `enemies/debtman/spr_debtman_hurt_strip4.png` | 4 | 48×64 | (24, 63) | 6, 4, 43, 63 | 12 |
| `spr_debtman_idle_strip8` | `enemies/debtman/spr_debtman_idle_strip8.png` | 8 | 48×64 | (24, 63) | 6, 4, 43, 63 | 6 |
| `spr_debtman_reel_strip6` | `enemies/debtman/spr_debtman_reel_strip6.png` | 6 | 96×64 | (40, 63) | 22, 4, 59, 63 | 10 |
| `spr_debtman_walk_strip8` | `enemies/debtman/spr_debtman_walk_strip8.png` | 8 | 48×64 | (24, 63) | 6, 4, 43, 63 | 8 |
| `spr_ward_sentinel_attack_strip6` | `enemies/ward_sentinel/spr_ward_sentinel_attack_strip6.png` | 6 | 32×48 | (16, 47) | 7, 6, 25, 47 | 10 |
| `spr_ward_sentinel_death_strip6` | `enemies/ward_sentinel/spr_ward_sentinel_death_strip6.png` | 6 | 48×48 | (16, 47) | 7, 6, 25, 47 | 8 |
| `spr_ward_sentinel_hurt_strip3` | `enemies/ward_sentinel/spr_ward_sentinel_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 7, 6, 25, 47 | 12 |
| `spr_ward_sentinel_idle_strip4` | `enemies/ward_sentinel/spr_ward_sentinel_idle_strip4.png` | 4 | 32×48 | (16, 47) | 7, 6, 25, 47 | 6 |
| `spr_glyph_wisp_attack_strip6` | `enemies/glyph_wisp/spr_glyph_wisp_attack_strip6.png` | 6 | 32×48 | (16, 47) | 8, 13, 25, 47 | 10 |
| `spr_glyph_wisp_cast_strip6` | `enemies/glyph_wisp/spr_glyph_wisp_cast_strip6.png` | 6 | 32×48 | (16, 47) | 8, 13, 25, 47 | 8 |
| `spr_glyph_wisp_death_strip6` | `enemies/glyph_wisp/spr_glyph_wisp_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 13, 25, 47 | 8 |
| `spr_glyph_wisp_hurt_strip3` | `enemies/glyph_wisp/spr_glyph_wisp_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 13, 25, 47 | 12 |
| `spr_glyph_wisp_idle_strip4` | `enemies/glyph_wisp/spr_glyph_wisp_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 13, 25, 47 | 6 |
| `spr_glyph_wisp_mote_strip3` | `enemies/glyph_wisp/spr_glyph_wisp_mote_strip3.png` | 3 | 16×16 | (8, 8) | full image | 10 |
| `spr_aethari_automaton_attack_strip6` | `enemies/aethari_automaton/spr_aethari_automaton_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 6, 35, 47 | 10 |
| `spr_aethari_automaton_death_strip6` | `enemies/aethari_automaton/spr_aethari_automaton_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 6, 27, 47 | 8 |
| `spr_aethari_automaton_hurt_strip3` | `enemies/aethari_automaton/spr_aethari_automaton_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 6, 27, 47 | 12 |
| `spr_aethari_automaton_idle_strip4` | `enemies/aethari_automaton/spr_aethari_automaton_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 6, 27, 47 | 6 |
| `spr_aethari_automaton_walk_strip4` | `enemies/aethari_automaton/spr_aethari_automaton_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 6, 27, 47 | 8 |
| `spr_sanctuary_warden_attack_p2_strip6` | `enemies/sanctuary_warden/spr_sanctuary_warden_attack_p2_strip6.png` | 6 | 96×96 | (48, 95) | 14, 14, 86, 95 | 10 |
| `spr_sanctuary_warden_attack_strip6` | `enemies/sanctuary_warden/spr_sanctuary_warden_attack_strip6.png` | 6 | 96×96 | (48, 95) | 14, 14, 86, 95 | 10 |
| `spr_sanctuary_warden_death_strip7` | `enemies/sanctuary_warden/spr_sanctuary_warden_death_strip7.png` | 7 | 96×96 | (48, 95) | 14, 14, 86, 95 | 8 |
| `spr_sanctuary_warden_hurt_strip4` | `enemies/sanctuary_warden/spr_sanctuary_warden_hurt_strip4.png` | 4 | 96×96 | (48, 95) | 14, 14, 86, 95 | 12 |
| `spr_sanctuary_warden_idle_p2_strip8` | `enemies/sanctuary_warden/spr_sanctuary_warden_idle_p2_strip8.png` | 8 | 96×96 | (48, 95) | 14, 14, 86, 95 | 6 |
| `spr_sanctuary_warden_idle_strip8` | `enemies/sanctuary_warden/spr_sanctuary_warden_idle_strip8.png` | 8 | 96×96 | (48, 95) | 14, 14, 86, 95 | 6 |
| `spr_sanctuary_warden_special_strip6` | `enemies/sanctuary_warden/spr_sanctuary_warden_special_strip6.png` | 6 | 96×96 | (48, 95) | 14, 14, 86, 95 | 8 |
| `spr_sanctuary_warden_trans_strip6` | `enemies/sanctuary_warden/spr_sanctuary_warden_trans_strip6.png` | 6 | 96×96 | (48, 95) | 14, 14, 86, 95 | 8 |
| `spr_sanctuary_warden_walk_strip4` | `enemies/sanctuary_warden/spr_sanctuary_warden_walk_strip4.png` | 4 | 96×96 | (48, 95) | 14, 14, 86, 95 | 8 |
| `spr_garrison_pikeman_attack_strip6` | `enemies/garrison_pikeman/spr_garrison_pikeman_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 1, 34, 47 | 10 |
| `spr_garrison_pikeman_death_strip6` | `enemies/garrison_pikeman/spr_garrison_pikeman_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 1, 26, 47 | 8 |
| `spr_garrison_pikeman_hurt_strip3` | `enemies/garrison_pikeman/spr_garrison_pikeman_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 1, 26, 47 | 12 |
| `spr_garrison_pikeman_idle_strip4` | `enemies/garrison_pikeman/spr_garrison_pikeman_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 1, 26, 47 | 6 |
| `spr_garrison_pikeman_walk_strip4` | `enemies/garrison_pikeman/spr_garrison_pikeman_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 1, 26, 47 | 8 |
| `spr_garrison_field_surgeon_attack_strip6` | `enemies/garrison_field_surgeon/spr_garrison_field_surgeon_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 5, 37, 47 | 10 |
| `spr_garrison_field_surgeon_cast_strip6` | `enemies/garrison_field_surgeon/spr_garrison_field_surgeon_cast_strip6.png` | 6 | 32×48 | (16, 47) | 8, 5, 29, 47 | 8 |
| `spr_garrison_field_surgeon_death_strip6` | `enemies/garrison_field_surgeon/spr_garrison_field_surgeon_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 5, 29, 47 | 8 |
| `spr_garrison_field_surgeon_hurt_strip3` | `enemies/garrison_field_surgeon/spr_garrison_field_surgeon_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 5, 29, 47 | 12 |
| `spr_garrison_field_surgeon_idle_strip4` | `enemies/garrison_field_surgeon/spr_garrison_field_surgeon_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 5, 29, 47 | 6 |
| `spr_garrison_field_surgeon_walk_strip4` | `enemies/garrison_field_surgeon/spr_garrison_field_surgeon_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 5, 29, 47 | 8 |
| `spr_garrison_knight_attack_strip6` | `enemies/garrison_knight/spr_garrison_knight_attack_strip6.png` | 6 | 48×48 | (24, 47) | 15, 5, 35, 47 | 10 |
| `spr_garrison_knight_death_strip6` | `enemies/garrison_knight/spr_garrison_knight_death_strip6.png` | 6 | 48×48 | (16, 47) | 7, 5, 27, 47 | 8 |
| `spr_garrison_knight_hurt_strip3` | `enemies/garrison_knight/spr_garrison_knight_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 7, 5, 27, 47 | 12 |
| `spr_garrison_knight_idle_strip4` | `enemies/garrison_knight/spr_garrison_knight_idle_strip4.png` | 4 | 32×48 | (16, 47) | 7, 5, 27, 47 | 6 |
| `spr_garrison_knight_walk_strip4` | `enemies/garrison_knight/spr_garrison_knight_walk_strip4.png` | 4 | 32×48 | (16, 47) | 7, 5, 27, 47 | 8 |
| `spr_commander_hailen_attack_strip6` | `enemies/commander_hailen/spr_commander_hailen_attack_strip6.png` | 6 | 96×64 | (40, 63) | 21, 5, 63, 63 | 10 |
| `spr_commander_hailen_death_strip7` | `enemies/commander_hailen/spr_commander_hailen_death_strip7.png` | 7 | 96×64 | (24, 63) | 5, 5, 47, 63 | 8 |
| `spr_commander_hailen_hurt_strip4` | `enemies/commander_hailen/spr_commander_hailen_hurt_strip4.png` | 4 | 48×64 | (24, 63) | 5, 5, 47, 63 | 12 |
| `spr_commander_hailen_idle_strip8` | `enemies/commander_hailen/spr_commander_hailen_idle_strip8.png` | 8 | 48×64 | (24, 63) | 5, 5, 47, 63 | 6 |
| `spr_commander_hailen_special_strip6` | `enemies/commander_hailen/spr_commander_hailen_special_strip6.png` | 6 | 96×64 | (40, 63) | 21, 5, 63, 63 | 8 |
| `spr_commander_hailen_walk_strip8` | `enemies/commander_hailen/spr_commander_hailen_walk_strip8.png` | 8 | 48×64 | (24, 63) | 5, 5, 47, 63 | 8 |
| `spr_commander_hailen_yield_strip8` | `enemies/commander_hailen/spr_commander_hailen_yield_strip8.png` | 8 | 48×64 | (24, 63) | 5, 5, 47, 63 | 8 |

#### Batch 7 overworld sets (elites and bosses; 16×24, origin (8, 23))
Not placed on any map yet.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_crown_sergeant_ow16_idle_down` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_ow16_idle_left` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_ow16_idle_right` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_ow16_idle_up` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_ow16_walk_down_strip4` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_sergeant_ow16_walk_left_strip4` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_sergeant_ow16_walk_right_strip4` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_sergeant_ow16_walk_up_strip4` | `enemies/crown_sergeant/overworld/spr_crown_sergeant_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debt_collector_ow16_idle_down` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debt_collector_ow16_idle_left` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debt_collector_ow16_idle_right` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debt_collector_ow16_idle_up` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debt_collector_ow16_walk_down_strip4` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debt_collector_ow16_walk_left_strip4` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debt_collector_ow16_walk_right_strip4` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debt_collector_ow16_walk_up_strip4` | `enemies/debt_collector/overworld/spr_debt_collector_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debtman_ow16_idle_down` | `enemies/debtman/overworld/spr_debtman_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debtman_ow16_idle_left` | `enemies/debtman/overworld/spr_debtman_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debtman_ow16_idle_right` | `enemies/debtman/overworld/spr_debtman_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debtman_ow16_idle_up` | `enemies/debtman/overworld/spr_debtman_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_debtman_ow16_walk_down_strip4` | `enemies/debtman/overworld/spr_debtman_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debtman_ow16_walk_left_strip4` | `enemies/debtman/overworld/spr_debtman_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debtman_ow16_walk_right_strip4` | `enemies/debtman/overworld/spr_debtman_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_debtman_ow16_walk_up_strip4` | `enemies/debtman/overworld/spr_debtman_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_aethari_automaton_ow16_idle_down` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_aethari_automaton_ow16_idle_left` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_aethari_automaton_ow16_idle_right` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_aethari_automaton_ow16_idle_up` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_aethari_automaton_ow16_walk_down_strip4` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_aethari_automaton_ow16_walk_left_strip4` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_aethari_automaton_ow16_walk_right_strip4` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_aethari_automaton_ow16_walk_up_strip4` | `enemies/aethari_automaton/overworld/spr_aethari_automaton_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_knight_ow16_idle_down` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_knight_ow16_idle_left` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_knight_ow16_idle_right` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_knight_ow16_idle_up` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_knight_ow16_walk_down_strip4` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_knight_ow16_walk_left_strip4` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_knight_ow16_walk_right_strip4` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_knight_ow16_walk_up_strip4` | `enemies/garrison_knight/overworld/spr_garrison_knight_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_commander_hailen_ow16_idle_down` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_commander_hailen_ow16_idle_left` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_commander_hailen_ow16_idle_right` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_commander_hailen_ow16_idle_up` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_commander_hailen_ow16_walk_down_strip4` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_commander_hailen_ow16_walk_left_strip4` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_commander_hailen_ow16_walk_right_strip4` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_commander_hailen_ow16_walk_up_strip4` | `enemies/commander_hailen/overworld/spr_commander_hailen_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

#### Batch 7 portraits (48×48, origin (0, 0))
| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_portrait_commander_hailen_neutral` | `portraits/commander_hailen/spr_portrait_commander_hailen_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_commander_hailen_resolve` | `portraits/commander_hailen/spr_portrait_commander_hailen_resolve.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_commander_hailen_weary` | `portraits/commander_hailen/spr_portrait_commander_hailen_weary.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_debtman_grim` | `portraits/debtman/spr_portrait_debtman_grim.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_debtman_neutral` | `portraits/debtman/spr_portrait_debtman_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_debtman_threat` | `portraits/debtman/spr_portrait_debtman_threat.png` | 1 | 48×48 | (0, 0) | full image | 0 |

### Act III enemies, batch 8: the Blackwood (feature/enemy-batches-7-8)
Design batch 8 ("batch 8"). Shade Stalker is 64×48 with origin (32, 47). Briar Hulk is 48×48 with origin (24, 47). Lost One, Night Moth Swarm and Door Warden are 32×48 with origin (16, 47), with 48×48 attack (24, 47) and death (16, 47) frames. The moth dust is 16×16 with origin (8, 8), spawned on cast frame 3. The **Blackwood Matriarch** is 96×96 with origin (48, 95), two phases (`trans`, `idle_p2`, `attack_p2`). She is a **PLACEHOLDER boss, not canon**, and `lost_one` may be revised (see DECISIONS).

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_shade_stalker_attack_strip6` | `enemies/shade_stalker/spr_shade_stalker_attack_strip6.png` | 6 | 64×48 | (32, 47) | 10, 12, 53, 47 | 10 |
| `spr_shade_stalker_death_strip6` | `enemies/shade_stalker/spr_shade_stalker_death_strip6.png` | 6 | 64×48 | (32, 47) | 10, 12, 53, 47 | 8 |
| `spr_shade_stalker_hurt_strip3` | `enemies/shade_stalker/spr_shade_stalker_hurt_strip3.png` | 3 | 64×48 | (32, 47) | 10, 12, 53, 47 | 12 |
| `spr_shade_stalker_idle_strip4` | `enemies/shade_stalker/spr_shade_stalker_idle_strip4.png` | 4 | 64×48 | (32, 47) | 10, 12, 53, 47 | 6 |
| `spr_shade_stalker_special_strip8` | `enemies/shade_stalker/spr_shade_stalker_special_strip8.png` | 8 | 64×48 | (32, 47) | 10, 12, 53, 47 | 8 |
| `spr_shade_stalker_walk_strip4` | `enemies/shade_stalker/spr_shade_stalker_walk_strip4.png` | 4 | 64×48 | (32, 47) | 10, 12, 53, 47 | 8 |
| `spr_briar_hulk_attack_strip6` | `enemies/briar_hulk/spr_briar_hulk_attack_strip6.png` | 6 | 48×48 | (24, 47) | 7, 12, 41, 47 | 10 |
| `spr_briar_hulk_death_strip6` | `enemies/briar_hulk/spr_briar_hulk_death_strip6.png` | 6 | 48×48 | (24, 47) | 7, 12, 41, 47 | 8 |
| `spr_briar_hulk_hurt_strip3` | `enemies/briar_hulk/spr_briar_hulk_hurt_strip3.png` | 3 | 48×48 | (24, 47) | 7, 12, 41, 47 | 12 |
| `spr_briar_hulk_idle_strip4` | `enemies/briar_hulk/spr_briar_hulk_idle_strip4.png` | 4 | 48×48 | (24, 47) | 7, 12, 41, 47 | 6 |
| `spr_briar_hulk_walk_strip4` | `enemies/briar_hulk/spr_briar_hulk_walk_strip4.png` | 4 | 48×48 | (24, 47) | 7, 12, 41, 47 | 8 |
| `spr_lost_one_attack_strip6` | `enemies/lost_one/spr_lost_one_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 7, 31, 47 | 10 |
| `spr_lost_one_death_strip6` | `enemies/lost_one/spr_lost_one_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 7, 23, 47 | 8 |
| `spr_lost_one_hurt_strip3` | `enemies/lost_one/spr_lost_one_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 7, 23, 47 | 12 |
| `spr_lost_one_idle_strip4` | `enemies/lost_one/spr_lost_one_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 23, 47 | 6 |
| `spr_lost_one_walk_strip4` | `enemies/lost_one/spr_lost_one_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 7, 23, 47 | 8 |
| `spr_night_moth_swarm_attack_strip6` | `enemies/night_moth_swarm/spr_night_moth_swarm_attack_strip6.png` | 6 | 32×48 | (16, 47) | 5, 13, 27, 47 | 10 |
| `spr_night_moth_swarm_cast_strip6` | `enemies/night_moth_swarm/spr_night_moth_swarm_cast_strip6.png` | 6 | 32×48 | (16, 47) | 5, 13, 27, 47 | 8 |
| `spr_night_moth_swarm_death_strip6` | `enemies/night_moth_swarm/spr_night_moth_swarm_death_strip6.png` | 6 | 48×48 | (16, 47) | 5, 13, 27, 47 | 8 |
| `spr_night_moth_swarm_dust_strip4` | `enemies/night_moth_swarm/spr_night_moth_swarm_dust_strip4.png` | 4 | 16×16 | (8, 8) | full image | 10 |
| `spr_night_moth_swarm_hurt_strip3` | `enemies/night_moth_swarm/spr_night_moth_swarm_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 5, 13, 27, 47 | 12 |
| `spr_night_moth_swarm_idle_strip4` | `enemies/night_moth_swarm/spr_night_moth_swarm_idle_strip4.png` | 4 | 32×48 | (16, 47) | 5, 13, 27, 47 | 6 |
| `spr_door_warden_attack_strip6` | `enemies/door_warden/spr_door_warden_attack_strip6.png` | 6 | 48×48 | (24, 47) | 16, 5, 33, 47 | 10 |
| `spr_door_warden_death_strip6` | `enemies/door_warden/spr_door_warden_death_strip6.png` | 6 | 48×48 | (16, 47) | 8, 5, 25, 47 | 8 |
| `spr_door_warden_hurt_strip3` | `enemies/door_warden/spr_door_warden_hurt_strip3.png` | 3 | 32×48 | (16, 47) | 8, 5, 25, 47 | 12 |
| `spr_door_warden_idle_strip4` | `enemies/door_warden/spr_door_warden_idle_strip4.png` | 4 | 32×48 | (16, 47) | 8, 5, 25, 47 | 6 |
| `spr_door_warden_walk_strip4` | `enemies/door_warden/spr_door_warden_walk_strip4.png` | 4 | 32×48 | (16, 47) | 8, 5, 25, 47 | 8 |
| `spr_blackwood_matriarch_attack_p2_strip6` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_attack_p2_strip6.png` | 6 | 96×96 | (48, 95) | 22, 10, 87, 95 | 10 |
| `spr_blackwood_matriarch_attack_strip6` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_attack_strip6.png` | 6 | 96×96 | (48, 95) | 22, 10, 87, 95 | 10 |
| `spr_blackwood_matriarch_death_strip8` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_death_strip8.png` | 8 | 96×96 | (48, 95) | 22, 10, 87, 95 | 8 |
| `spr_blackwood_matriarch_hurt_strip4` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_hurt_strip4.png` | 4 | 96×96 | (48, 95) | 22, 10, 87, 95 | 12 |
| `spr_blackwood_matriarch_idle_p2_strip8` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_idle_p2_strip8.png` | 8 | 96×96 | (48, 95) | 22, 10, 87, 95 | 6 |
| `spr_blackwood_matriarch_idle_strip8` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_idle_strip8.png` | 8 | 96×96 | (48, 95) | 22, 10, 87, 95 | 6 |
| `spr_blackwood_matriarch_special_strip6` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_special_strip6.png` | 6 | 96×96 | (48, 95) | 22, 10, 87, 95 | 8 |
| `spr_blackwood_matriarch_trans_strip6` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_trans_strip6.png` | 6 | 96×96 | (48, 95) | 22, 10, 87, 95 | 8 |
| `spr_blackwood_matriarch_walk_strip4` | `enemies/blackwood_matriarch/spr_blackwood_matriarch_walk_strip4.png` | 4 | 96×96 | (48, 95) | 22, 10, 87, 95 | 8 |

#### Batch 8 overworld sets (16×24, origin (8, 23))
| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_door_warden_ow16_idle_down` | `enemies/door_warden/overworld/spr_door_warden_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_door_warden_ow16_idle_left` | `enemies/door_warden/overworld/spr_door_warden_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_door_warden_ow16_idle_right` | `enemies/door_warden/overworld/spr_door_warden_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_door_warden_ow16_idle_up` | `enemies/door_warden/overworld/spr_door_warden_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_door_warden_ow16_walk_down_strip4` | `enemies/door_warden/overworld/spr_door_warden_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_door_warden_ow16_walk_left_strip4` | `enemies/door_warden/overworld/spr_door_warden_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_door_warden_ow16_walk_right_strip4` | `enemies/door_warden/overworld/spr_door_warden_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_door_warden_ow16_walk_up_strip4` | `enemies/door_warden/overworld/spr_door_warden_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_blackwood_matriarch_ow16_idle_down` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackwood_matriarch_ow16_idle_left` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackwood_matriarch_ow16_idle_right` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackwood_matriarch_ow16_idle_up` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_blackwood_matriarch_ow16_walk_down_strip4` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_blackwood_matriarch_ow16_walk_left_strip4` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_blackwood_matriarch_ow16_walk_right_strip4` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_blackwood_matriarch_ow16_walk_up_strip4` | `enemies/blackwood_matriarch/overworld/spr_blackwood_matriarch_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

#### New battle backgrounds (320×180, origin (0, 0))
Used automatically by area: `lower_city`, `sanctuary_hall`, `garrison_yard`, `blackwood` (missing imports fall back to the forest background). Skip the `_2x_preview` files.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_bg_battle_blackwood` | `ui/battle_bg/spr_bg_battle_blackwood.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_bg_battle_garrison_yard` | `ui/battle_bg/spr_bg_battle_garrison_yard.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_bg_battle_lower_city` | `ui/battle_bg/spr_bg_battle_lower_city.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_bg_battle_sanctuary_hall` | `ui/battle_bg/spr_bg_battle_sanctuary_hall.png` | 1 | 320×180 | (0, 0) | full image | 0 |

### Chests
16×16 tiles, origin (0, 0). Wood for the overworld; iron for Watchtower / basement. Play `*_open_strip3` once at ~10 fps, then hold the open frame.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_chest_iron_closed` | `items/chests/spr_chest_iron_closed.png` | 1 | 16×16 | (0, 0) | 0, 0, 15, 15 | 0 |
| `spr_chest_iron_open` | `items/chests/spr_chest_iron_open.png` | 1 | 16×16 | (0, 0) | 0, 0, 15, 15 | 0 |
| `spr_chest_iron_open_strip3` | `items/chests/spr_chest_iron_open_strip3.png` | 3 | 16×16 | (0, 0) | 0, 0, 15, 15 | 10 |
| `spr_chest_wood_closed` | `items/chests/spr_chest_wood_closed.png` | 1 | 16×16 | (0, 0) | 0, 0, 15, 15 | 0 |
| `spr_chest_wood_open` | `items/chests/spr_chest_wood_open.png` | 1 | 16×16 | (0, 0) | 0, 0, 15, 15 | 0 |
| `spr_chest_wood_open_strip3` | `items/chests/spr_chest_wood_open_strip3.png` | 3 | 16×16 | (0, 0) | 0, 0, 15, 15 | 10 |

### Item icons
16×16, origin (8, 8). Used in the inventory overlay (I / Tab) and as overworld pickup sprites.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_item_antidote` | `items/spr_item_antidote.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_ashbound_parchment` | `items/spr_item_ashbound_parchment.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_ashen_arrow` | `items/spr_item_ashen_arrow.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_ashen_longbow` | `items/spr_item_ashen_longbow.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_blackened_feather` | `items/spr_item_blackened_feather.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_blackguards_longsword` | `items/spr_item_blackguards_longsword.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_chain_mail` | `items/spr_item_chain_mail.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_crownveil_fragment` | `items/spr_item_crownveil_fragment.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_ether` | `items/spr_item_ether.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_gold` | `items/spr_item_gold.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_hunters_charm` | `items/spr_item_hunters_charm.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_hunters_knife` | `items/spr_item_hunters_knife.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_iron_helm` | `items/spr_item_iron_helm.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_iron_sword` | `items/spr_item_iron_sword.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_kaels_longsword` | `items/spr_item_kaels_longsword.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_leather_armor` | `items/spr_item_leather_armor.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_minor_potion` | `items/spr_item_minor_potion.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_mira_pendant` | `items/spr_item_mira_pendant.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
| `spr_item_watchtower_key` | `items/spr_item_watchtower_key.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |

### NPC overworld
All 16×24, origin (8, 23), mask 0, 8, 15, 23, walk 4 frames at 8 fps. `left` is pre-mirrored; do not use `image_xscale`. Tomas pallet pose: `spr_tomas_varyn_ow16_lying_strip2` (16×16 ×2, origin (8, 15), ~1.5 fps) and `spr_tomas_varyn_ow16_lying_awake`. Place at the pallet tile bottom-centre.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_corwin_ow16_idle_down` | `npcs/corwin/spr_corwin_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_corwin_ow16_idle_left` | `npcs/corwin/spr_corwin_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_corwin_ow16_idle_right` | `npcs/corwin/spr_corwin_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_corwin_ow16_idle_up` | `npcs/corwin/spr_corwin_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_corwin_ow16_walk_down_strip4` | `npcs/corwin/spr_corwin_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_corwin_ow16_walk_left_strip4` | `npcs/corwin/spr_corwin_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_corwin_ow16_walk_right_strip4` | `npcs/corwin/spr_corwin_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_corwin_ow16_walk_up_strip4` | `npcs/corwin/spr_corwin_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dov_ow16_idle_down` | `npcs/dov/spr_dov_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dov_ow16_idle_left` | `npcs/dov/spr_dov_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dov_ow16_idle_right` | `npcs/dov/spr_dov_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dov_ow16_idle_up` | `npcs/dov/spr_dov_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dov_ow16_walk_down_strip4` | `npcs/dov/spr_dov_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dov_ow16_walk_left_strip4` | `npcs/dov/spr_dov_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dov_ow16_walk_right_strip4` | `npcs/dov/spr_dov_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dov_ow16_walk_up_strip4` | `npcs/dov/spr_dov_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_story_ow16_idle_down` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_story_ow16_idle_left` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_story_ow16_idle_right` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_story_ow16_idle_up` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_story_ow16_walk_down_strip4` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_story_ow16_walk_left_strip4` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_story_ow16_walk_right_strip4` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_story_ow16_walk_up_strip4` | `npcs/fallen_knight_story/spr_fallen_knight_story_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_hob_ow16_idle_down` | `npcs/hob/spr_hob_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hob_ow16_idle_left` | `npcs/hob/spr_hob_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hob_ow16_idle_right` | `npcs/hob/spr_hob_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hob_ow16_idle_up` | `npcs/hob/spr_hob_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_hob_ow16_walk_down_strip4` | `npcs/hob/spr_hob_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_hob_ow16_walk_left_strip4` | `npcs/hob/spr_hob_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_hob_ow16_walk_right_strip4` | `npcs/hob/spr_hob_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_hob_ow16_walk_up_strip4` | `npcs/hob/spr_hob_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ilse_ow16_idle_down` | `npcs/ilse/spr_ilse_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ilse_ow16_idle_left` | `npcs/ilse/spr_ilse_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ilse_ow16_idle_right` | `npcs/ilse/spr_ilse_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ilse_ow16_idle_up` | `npcs/ilse/spr_ilse_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ilse_ow16_walk_down_strip4` | `npcs/ilse/spr_ilse_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ilse_ow16_walk_left_strip4` | `npcs/ilse/spr_ilse_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ilse_ow16_walk_right_strip4` | `npcs/ilse/spr_ilse_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ilse_ow16_walk_up_strip4` | `npcs/ilse/spr_ilse_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_marda_ow16_idle_down` | `npcs/marda/spr_marda_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_marda_ow16_idle_left` | `npcs/marda/spr_marda_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_marda_ow16_idle_right` | `npcs/marda/spr_marda_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_marda_ow16_idle_up` | `npcs/marda/spr_marda_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_marda_ow16_walk_down_strip4` | `npcs/marda/spr_marda_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_marda_ow16_walk_left_strip4` | `npcs/marda/spr_marda_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_marda_ow16_walk_right_strip4` | `npcs/marda/spr_marda_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_marda_ow16_walk_up_strip4` | `npcs/marda/spr_marda_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_pell_ow16_idle_down` | `npcs/pell/spr_pell_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_pell_ow16_idle_left` | `npcs/pell/spr_pell_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_pell_ow16_idle_right` | `npcs/pell/spr_pell_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_pell_ow16_idle_up` | `npcs/pell/spr_pell_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_pell_ow16_walk_down_strip4` | `npcs/pell/spr_pell_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_pell_ow16_walk_left_strip4` | `npcs/pell/spr_pell_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_pell_ow16_walk_right_strip4` | `npcs/pell/spr_pell_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_pell_ow16_walk_up_strip4` | `npcs/pell/spr_pell_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_renn_ow16_idle_down` | `npcs/renn/spr_renn_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_renn_ow16_idle_left` | `npcs/renn/spr_renn_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_renn_ow16_idle_right` | `npcs/renn/spr_renn_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_renn_ow16_idle_up` | `npcs/renn/spr_renn_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_renn_ow16_walk_down_strip4` | `npcs/renn/spr_renn_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_renn_ow16_walk_left_strip4` | `npcs/renn/spr_renn_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_renn_ow16_walk_right_strip4` | `npcs/renn/spr_renn_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_renn_ow16_walk_up_strip4` | `npcs/renn/spr_renn_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_tomas_varyn_ow16_idle_down` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_tomas_varyn_ow16_idle_left` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_tomas_varyn_ow16_idle_right` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_tomas_varyn_ow16_idle_up` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_tomas_varyn_ow16_lying_awake` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_lying_awake.png` | 1 | 16×16 | (8, 15) | 0, 0, 15, 15 | 0 |
| `spr_tomas_varyn_ow16_lying_strip2` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_lying_strip2.png` | 2 | 16×16 | (8, 15) | 0, 0, 15, 15 | 1.5 |
| `spr_tomas_varyn_ow16_walk_down_strip4` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_tomas_varyn_ow16_walk_left_strip4` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_tomas_varyn_ow16_walk_right_strip4` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_tomas_varyn_ow16_walk_up_strip4` | `npcs/tomas_varyn/spr_tomas_varyn_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_wenna_ow16_idle_down` | `npcs/wenna/spr_wenna_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_wenna_ow16_idle_left` | `npcs/wenna/spr_wenna_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_wenna_ow16_idle_right` | `npcs/wenna/spr_wenna_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_wenna_ow16_idle_up` | `npcs/wenna/spr_wenna_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_wenna_ow16_walk_down_strip4` | `npcs/wenna/spr_wenna_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_wenna_ow16_walk_left_strip4` | `npcs/wenna/spr_wenna_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_wenna_ow16_walk_right_strip4` | `npcs/wenna/spr_wenna_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_wenna_ow16_walk_up_strip4` | `npcs/wenna/spr_wenna_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

### Dialogue portraits
48×48, origin (0, 0). Shown in the dialogue box when the speaker is Kael, Tomas, Pell, Renn, or the Fallen Knight. Default expression is `_neutral`. Mira is not included (she is not on screen in Chapter 1).

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_portrait_fallen_knight_dim` | `portraits/fallen_knight_story/spr_portrait_fallen_knight_dim.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_fallen_knight_flare` | `portraits/fallen_knight_story/spr_portrait_fallen_knight_flare.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_fallen_knight_neutral` | `portraits/fallen_knight_story/spr_portrait_fallen_knight_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_kael_determined` | `portraits/kael/spr_portrait_kael_determined.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_kael_neutral` | `portraits/kael/spr_portrait_kael_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_kael_sad` | `portraits/kael/spr_portrait_kael_sad.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_kael_surprised` | `portraits/kael/spr_portrait_kael_surprised.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_pell_neutral` | `portraits/pell/spr_portrait_pell_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_pell_smile` | `portraits/pell/spr_portrait_pell_smile.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_pell_worried` | `portraits/pell/spr_portrait_pell_worried.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_renn_neutral` | `portraits/renn/spr_portrait_renn_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_renn_smirk` | `portraits/renn/spr_portrait_renn_smirk.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_renn_stern` | `portraits/renn/spr_portrait_renn_stern.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_tomas_neutral` | `portraits/tomas_varyn/spr_portrait_tomas_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_tomas_pained` | `portraits/tomas_varyn/spr_portrait_tomas_pained.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_tomas_smile` | `portraits/tomas_varyn/spr_portrait_tomas_smile.png` | 1 | 48×48 | (0, 0) | full image | 0 |

### Title / main menu — 320
Use when the GUI is 320×180 (this is the project default after `scr_ui_init`). Logo origin is top-centre (w/2, 0). Option graphics origin is middle-centre. Cursor 320: (9, 6). Panels: centre origin. Ember strip: 24 frames at 12 fps, origin (0, 0).

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_logo_ashen_crown_320` | `title/320/spr_logo_ashen_crown_320.png` | 1 | 250×71 | (125, 0) | full image | 0 |
| `spr_menu_bg0_sky_320` | `title/320/spr_menu_bg0_sky_320.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_menu_bg1_hills_320` | `title/320/spr_menu_bg1_hills_320.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_menu_bg2_ruins_320` | `title/320/spr_menu_bg2_ruins_320.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_menu_bg3_foreground_320` | `title/320/spr_menu_bg3_foreground_320.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_menu_cursor_320_strip4` | `title/320/spr_menu_cursor_320_strip4.png` | 4 | 10×12 | (9, 6) | full image | 8 |
| `spr_menu_embers_320_strip24` | `title/320/spr_menu_embers_320_strip24.png` | 24 | 320×180 | (0, 0) | full image | 12 |
| `spr_menu_opt_continue_disabled_320` | `title/320/spr_menu_opt_continue_disabled_320.png` | 1 | 104×30 | (52, 15) | full image | 0 |
| `spr_menu_opt_continue_normal_320` | `title/320/spr_menu_opt_continue_normal_320.png` | 1 | 104×30 | (52, 15) | full image | 0 |
| `spr_menu_opt_continue_selected_320` | `title/320/spr_menu_opt_continue_selected_320.png` | 1 | 104×30 | (52, 15) | full image | 0 |
| `spr_menu_opt_new_game_normal_320` | `title/320/spr_menu_opt_new_game_normal_320.png` | 1 | 102×30 | (51, 15) | full image | 0 |
| `spr_menu_opt_new_game_selected_320` | `title/320/spr_menu_opt_new_game_selected_320.png` | 1 | 102×30 | (51, 15) | full image | 0 |
| `spr_menu_opt_options_normal_320` | `title/320/spr_menu_opt_options_normal_320.png` | 1 | 92×30 | (46, 15) | full image | 0 |
| `spr_menu_opt_options_selected_320` | `title/320/spr_menu_opt_options_selected_320.png` | 1 | 92×30 | (46, 15) | full image | 0 |
| `spr_menu_opt_quit_normal_320` | `title/320/spr_menu_opt_quit_normal_320.png` | 1 | 56×30 | (28, 15) | full image | 0 |
| `spr_menu_opt_quit_selected_320` | `title/320/spr_menu_opt_quit_selected_320.png` | 1 | 56×30 | (28, 15) | full image | 0 |
| `spr_menu_panel_options_320` | `title/320/spr_menu_panel_options_320.png` | 1 | 200×118 | (100, 59) | full image | 0 |
| `spr_menu_panel_saves_320` | `title/320/spr_menu_panel_saves_320.png` | 1 | 220×132 | (110, 66) | full image | 0 |
| `spr_title_screen_320` | `title/320/spr_title_screen_320.png` | 1 | 320×180 | (0, 0) | full image | 0 |

### Title / main menu — 640
Use when the GUI is 640×360 (or as a native high-res set). **`spr_menu_embers_640_strip24` is 640×360 × 24 frames and will not fit on a single default texture page.** Put that sprite (and ideally the other 640 title sprites) in their own Texture Group with a page size of at least 2048×2048, or import only the 320 ember strip and scale it 2× in code (the title object already falls back to the 320 strip if the 640 one is missing). Cursor 640 origin (19, 12). Double every layout number from the 320 section.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_logo_ashen_crown_640` | `title/640/spr_logo_ashen_crown_640.png` | 1 | 501×143 | (250, 0) | full image | 0 |
| `spr_menu_bg0_sky_640` | `title/640/spr_menu_bg0_sky_640.png` | 1 | 640×360 | (0, 0) | full image | 0 |
| `spr_menu_bg1_hills_640` | `title/640/spr_menu_bg1_hills_640.png` | 1 | 640×360 | (0, 0) | full image | 0 |
| `spr_menu_bg2_ruins_640` | `title/640/spr_menu_bg2_ruins_640.png` | 1 | 640×360 | (0, 0) | full image | 0 |
| `spr_menu_bg3_foreground_640` | `title/640/spr_menu_bg3_foreground_640.png` | 1 | 640×360 | (0, 0) | full image | 0 |
| `spr_menu_cursor_640_strip4` | `title/640/spr_menu_cursor_640_strip4.png` | 4 | 20×24 | (19, 12) | full image | 8 |
| `spr_menu_embers_640_strip24` | `title/640/spr_menu_embers_640_strip24.png` | 24 | 640×360 | (0, 0) | full image | 12 |
| `spr_menu_opt_continue_disabled_640` | `title/640/spr_menu_opt_continue_disabled_640.png` | 1 | 208×60 | (104, 30) | full image | 0 |
| `spr_menu_opt_continue_normal_640` | `title/640/spr_menu_opt_continue_normal_640.png` | 1 | 208×60 | (104, 30) | full image | 0 |
| `spr_menu_opt_continue_selected_640` | `title/640/spr_menu_opt_continue_selected_640.png` | 1 | 208×60 | (104, 30) | full image | 0 |
| `spr_menu_opt_new_game_normal_640` | `title/640/spr_menu_opt_new_game_normal_640.png` | 1 | 204×60 | (102, 30) | full image | 0 |
| `spr_menu_opt_new_game_selected_640` | `title/640/spr_menu_opt_new_game_selected_640.png` | 1 | 204×60 | (102, 30) | full image | 0 |
| `spr_menu_opt_options_normal_640` | `title/640/spr_menu_opt_options_normal_640.png` | 1 | 184×60 | (92, 30) | full image | 0 |
| `spr_menu_opt_options_selected_640` | `title/640/spr_menu_opt_options_selected_640.png` | 1 | 184×60 | (92, 30) | full image | 0 |
| `spr_menu_opt_quit_normal_640` | `title/640/spr_menu_opt_quit_normal_640.png` | 1 | 112×60 | (56, 30) | full image | 0 |
| `spr_menu_opt_quit_selected_640` | `title/640/spr_menu_opt_quit_selected_640.png` | 1 | 112×60 | (56, 30) | full image | 0 |
| `spr_menu_panel_options_640` | `title/640/spr_menu_panel_options_640.png` | 1 | 400×236 | (200, 118) | full image | 0 |
| `spr_menu_panel_saves_640` | `title/640/spr_menu_panel_saves_640.png` | 1 | 440×264 | (220, 132) | full image | 0 |
| `spr_title_screen_640` | `title/640/spr_title_screen_640.png` | 1 | 640×360 | (0, 0) | full image | 0 |

### Battle backgrounds
320×180, origin (0, 0). Feet line is y ≈ 105–125. The bottom 52 px sits under the menu windows. `*_2x_preview.png` files are not imported.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_bg_battle_bandit_camp` | `ui/battle_bg/spr_bg_battle_bandit_camp.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_bg_battle_blackguard_arena` | `ui/battle_bg/spr_bg_battle_blackguard_arena.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_bg_battle_forest` | `ui/battle_bg/spr_bg_battle_forest.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_bg_battle_greyhaven` | `ui/battle_bg/spr_bg_battle_greyhaven.png` | 1 | 320×180 | (0, 0) | full image | 0 |
| `spr_bg_battle_watchtower` | `ui/battle_bg/spr_bg_battle_watchtower.png` | 1 | 320×180 | (0, 0) | full image | 0 |

### UI kit, font, bars, digits
Nine-slice **must** be turned on for `spr_ui_window`, `spr_ui_window_dim`, and `spr_ui_window_gold`: left/right/top/bottom = 8, mode Stretch or Repeat. `spr_ui_select_bar`: nine-slice 3 on every side. `spr_ui_slider_track`: nine-slice 2 on every side. Cursor origin (15, 4). HP bar frame 50×6; fill stretches inside (1, 1) at 48×4 (`hp` → `hp_low` under 50% → `hp_crit` under 25%). Status strip: 10×10, origin (5, 5), frames 0 poison, 1 bleed, 2 ashburn, 3 stun, 4 fear, 5 defense down, 6 attack up, 7 attack down, 8 speed up, 9 speed down, 10 marked, 11 guard.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_font_main_noshadow_strip95` | `ui/spr_font_main_noshadow_strip95.png` | 95 | 6×10 | (0, 0) | full image | 10 |
| `spr_font_main_strip95` | `ui/spr_font_main_strip95.png` | 95 | 6×10 | (0, 0) | full image | 10 |
| `spr_ui_bar_fill_back` | `ui/spr_ui_bar_fill_back.png` | 1 | 1×4 | (0, 0) | full image | 0 |
| `spr_ui_bar_fill_hp` | `ui/spr_ui_bar_fill_hp.png` | 1 | 1×4 | (0, 0) | full image | 0 |
| `spr_ui_bar_fill_hp_crit` | `ui/spr_ui_bar_fill_hp_crit.png` | 1 | 1×4 | (0, 0) | full image | 0 |
| `spr_ui_bar_fill_hp_low` | `ui/spr_ui_bar_fill_hp_low.png` | 1 | 1×4 | (0, 0) | full image | 0 |
| `spr_ui_bar_fill_mp` | `ui/spr_ui_bar_fill_mp.png` | 1 | 1×4 | (0, 0) | full image | 0 |
| `spr_ui_bar_frame` | `ui/spr_ui_bar_frame.png` | 1 | 50×6 | (0, 0) | full image | 0 |
| `spr_ui_crit_digits_strip10` | `ui/spr_ui_crit_digits_strip10.png` | 10 | 7×9 | (0, 0) | full image | 10 |
| `spr_ui_cursor_strip2` | `ui/spr_ui_cursor_strip2.png` | 2 | 16×12 | (15, 4) | full image | 4 |
| `spr_ui_dmg_critical` | `ui/spr_ui_dmg_critical.png` | 1 | 48×10 | (0, 0) | full image | 0 |
| `spr_ui_dmg_digits_strip10` | `ui/spr_ui_dmg_digits_strip10.png` | 10 | 7×9 | (0, 0) | full image | 10 |
| `spr_ui_dmg_miss` | `ui/spr_ui_dmg_miss.png` | 1 | 24×10 | (0, 0) | full image | 0 |
| `spr_ui_dmg_weak` | `ui/spr_ui_dmg_weak.png` | 1 | 28×10 | (0, 0) | full image | 0 |
| `spr_ui_heal_digits_strip10` | `ui/spr_ui_heal_digits_strip10.png` | 10 | 7×9 | (0, 0) | full image | 10 |
| `spr_ui_select_bar` | `ui/spr_ui_select_bar.png` | 1 | 24×12 | (0, 0) | full image | 0 |
| `spr_ui_slider_knob` | `ui/spr_ui_slider_knob.png` | 1 | 8×10 | (4, 5) | full image | 0 |
| `spr_ui_slider_track` | `ui/spr_ui_slider_track.png` | 1 | 12×6 | (0, 0) | full image | 0 |
| `spr_ui_status_extra_strip2` | `ui/spr_ui_status_extra_strip2.png` | 2 | 10×10 | (5, 5) | full image | 10 |
| `spr_ui_status_strip12` | `ui/spr_ui_status_strip12.png` | 12 | 10×10 | (5, 5) | full image | 10 |
| `spr_ui_toggle_strip2` | `ui/spr_ui_toggle_strip2.png` | 2 | 16×10 | (0, 0) | full image | 10 |
| `spr_ui_window` | `ui/spr_ui_window.png` | 1 | 24×24 | (0, 0) | full image | 0 |
| `spr_ui_window_dim` | `ui/spr_ui_window_dim.png` | 1 | 24×24 | (0, 0) | full image | 0 |
| `spr_ui_window_gold` | `ui/spr_ui_window_gold.png` | 1 | 24×24 | (0, 0) | full image | 0 |

### Field menus (`ui/menus/`) — shop, save/load, inventory/equip

Layout, colours, nine-slice margins, and behaviour: Design README section "Field menus: shop, save/load, inventory/equip", plus `ui/menus/mockups/`. All coordinates live in `scr_menu_layout.gml`. Code looks these up with `scr_sprite_index` / `asset_get_index` and falls back to the nine-slice windows, font, cursor, and item icons if a sprite is missing.

**Nine-slice (enable after import):**

| Asset | Margins (L,T,R,B) |
|---|---|
| `spr_ui_row_select`, `spr_ui_row_select_disabled` | 4, 4, 4, 4 |
| `spr_ui_tab_blank_strip2` | 4, 4, 4, 3 |
| `spr_ui_portrait_frame`, `spr_ui_leader_frame`, `spr_ui_qty_field` | 3, 3, 3, 3 |

Windows already listed above (`spr_ui_window*`, nine-slice 8) and `spr_ui_select_bar` (nine-slice 3) are reused. Tabs are drawn at `window_y - 12` **after** their window (the selected tab's bottom 3 rows cover the top border; a normal tab sits 2px lower). Cursor origin is still (15, 4): place it at the tip x, the row's middle y. `spr_ui_dither` is tiled full-screen behind every field menu. Item icons (colour and `_disabled`) are drawn from the top-left in the mockups even though their origin is (8, 8).

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS / notes |
|---|---|---|---|---|---|---|
| `spr_ui_tab_buy_normal` | `ui/menus/spr_ui_tab_buy_normal.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_buy_selected` | `ui/menus/spr_ui_tab_buy_selected.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_sell_normal` | `ui/menus/spr_ui_tab_sell_normal.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_sell_selected` | `ui/menus/spr_ui_tab_sell_selected.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_exit_normal` | `ui/menus/spr_ui_tab_exit_normal.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_exit_selected` | `ui/menus/spr_ui_tab_exit_selected.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_items_normal` | `ui/menus/spr_ui_tab_items_normal.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_items_selected` | `ui/menus/spr_ui_tab_items_selected.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_equip_normal` | `ui/menus/spr_ui_tab_equip_normal.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_equip_selected` | `ui/menus/spr_ui_tab_equip_selected.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_key_normal` | `ui/menus/spr_ui_tab_key_normal.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_key_selected` | `ui/menus/spr_ui_tab_key_selected.png` | 1 | 40×15 | (0, 0) | full image | 0 |
| `spr_ui_tab_blank_strip2` | `ui/menus/spr_ui_tab_blank_strip2.png` | 2 | 40×15 | (0, 0) | full image | 0; frame 0 normal, 1 selected; nine-slice L4 T4 R4 B3 |
| `spr_ui_row_select` | `ui/menus/spr_ui_row_select.png` | 1 | 24×16 | (0, 0) | full image | 0; nine-slice 4 |
| `spr_ui_row_select_disabled` | `ui/menus/spr_ui_row_select_disabled.png` | 1 | 24×16 | (0, 0) | full image | 0; nine-slice 4 |
| `spr_ui_arrow_strip4` | `ui/menus/spr_ui_arrow_strip4.png` | 4 | 9×6 | (0, 0) | full image | 0; 0 up, 1 down, 2 up-dim, 3 down-dim |
| `spr_ui_stat_arrow_strip3` | `ui/menus/spr_ui_stat_arrow_strip3.png` | 3 | 7×7 | (0, 0) | full image | 0; 0 up, 1 down, 2 equal |
| `spr_ui_icon_coin` | `ui/menus/spr_ui_icon_coin.png` | 1 | 8×8 | (0, 0) | full image | 0 |
| `spr_ui_icon_clock` | `ui/menus/spr_ui_icon_clock.png` | 1 | 8×8 | (0, 0) | full image | 0 |
| `spr_ui_icon_key` | `ui/menus/spr_ui_icon_key.png` | 1 | 8×8 | (0, 0) | full image | 0 |
| `spr_ui_icon_ember` | `ui/menus/spr_ui_icon_ember.png` | 1 | 8×8 | (0, 0) | full image | 0 |
| `spr_ui_party_icon_kael` | `ui/menus/spr_ui_party_icon_kael.png` | 1 | 12×12 | (0, 0) | full image | 0 |
| `spr_ui_party_icon_none` | `ui/menus/spr_ui_party_icon_none.png` | 1 | 12×12 | (0, 0) | full image | 0; stand-in for Lyra / Caelan / Sera / Taren until their icons exist (`spr_ui_party_icon_<id>`) |
| `spr_ui_party_frame_strip2` | `ui/menus/spr_ui_party_frame_strip2.png` | 2 | 14×14 | (0, 0) | full image | 0; 0 normal, 1 selected |
| `spr_ui_slot_weapon` | `ui/menus/spr_ui_slot_weapon.png` | 1 | 16×16 | (0, 0) | full image | 0 |
| `spr_ui_slot_armor` | `ui/menus/spr_ui_slot_armor.png` | 1 | 16×16 | (0, 0) | full image | 0 |
| `spr_ui_slot_helm` | `ui/menus/spr_ui_slot_helm.png` | 1 | 16×16 | (0, 0) | full image | 0 |
| `spr_ui_slot_accessory` | `ui/menus/spr_ui_slot_accessory.png` | 1 | 16×16 | (0, 0) | full image | 0 |
| `spr_ui_portrait_frame` | `ui/menus/spr_ui_portrait_frame.png` | 1 | 52×52 | (0, 0) | full image | 0; nine-slice 3; portrait at +2,+2 |
| `spr_ui_leader_frame` | `ui/menus/spr_ui_leader_frame.png` | 1 | 20×28 | (0, 0) | full image | 0; nine-slice 3; 16×24 idle_down at +2,+2 |
| `spr_ui_qty_field` | `ui/menus/spr_ui_qty_field.png` | 1 | 28×14 | (0, 0) | full image | 0; nine-slice 3 |
| `spr_ui_dither` | `ui/menus/spr_ui_dither.png` | 1 | 2×2 | (0, 0) | full image | 0; tile with `draw_sprite_tiled` |
| `spr_ui_toast_saved` | `ui/menus/spr_ui_toast_saved.png` | 1 | 64×20 | **(32, 0)** | full image | 0; draw at (160, 8) |
| `spr_save_point_idle_strip8` | `ui/menus/save_point/spr_save_point_idle_strip8.png` | 8 | 16×24 | **(8, 23)** | 0, 16, 15, 23 (feet) | 8; loop |
| `spr_save_point_activate_strip8` | `ui/menus/save_point/spr_save_point_activate_strip8.png` | 8 | 32×40 | **(16, 39)** | feet-aligned with idle | 12; play once, then idle |

Greyed item icons (16×16, origin (8, 8), same names as the colour icons plus `_disabled`). Import every file in `ui/menus/items_disabled/`:

`spr_item_antidote_disabled`, `spr_item_ashbound_parchment_disabled`, `spr_item_ashen_arrow_disabled`, `spr_item_ashen_longbow_disabled`, `spr_item_blackened_feather_disabled`, `spr_item_blackguards_longsword_disabled`, `spr_item_chain_mail_disabled`, `spr_item_crownveil_fragment_disabled`, `spr_item_ether_disabled`, `spr_item_gold_disabled`, `spr_item_hunters_charm_disabled`, `spr_item_hunters_knife_disabled`, `spr_item_iron_helm_disabled`, `spr_item_iron_sword_disabled`, `spr_item_kaels_longsword_disabled`, `spr_item_leather_armor_disabled`, `spr_item_minor_potion_disabled`, `spr_item_mira_pendant_disabled`, `spr_item_watchtower_key_disabled`.

Do not import `menus_parts_preview.png`, the mockups, or the save-point preview GIFs as sprites (reference only).

### Dialogue portraits (Marda, Hob)

Same rules as the other 48×48 portraits: origin (0, 0), full-image mask, one sprite per expression.

| Asset name | File | Frames | Frame size | Origin | Mask | FPS |
|---|---|---|---|---|---|---|
| `spr_portrait_marda_neutral` | `portraits/marda/spr_portrait_marda_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_marda_smirk` | `portraits/marda/spr_portrait_marda_smirk.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_marda_stern` | `portraits/marda/spr_portrait_marda_stern.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_hob_neutral` | `portraits/hob/spr_portrait_hob_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_hob_grim` | `portraits/hob/spr_portrait_hob_grim.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_hob_wry` | `portraits/hob/spr_portrait_hob_wry.png` | 1 | 48×48 | (0, 0) | full image | 0 |

Preview sheets in those folders are not imported.

## Chapter 2 (feature/chapter2)

Rooms, tileset and NPCs for Millhaven Road and Wrenfield. Everything goes through `asset_get_index`, so the game still runs (with placeholders) before these are imported. Do not import `*_preview*` files.

### Tileset
`game/tilesets/ts_wrenfield.png` → Sprite `spr_ts_wrenfield` (one image, do not split) → Tile Set **`ts_wrenfield`** (16×16, offset 0, separation 0). See `game/tilesets/README.md`.

### Chapter 2 NPC overworld
All 16×24, origin (8, 23), mask 0, 8, 15, 23. Walk strips 4 frames at 8 fps. `left` is pre-mirrored. Two 2-frame strips play at 2 fps: `spr_bram_bound_ow16_noose_taut_strip2` (Bram on the gallows; the rope lines up with the `gallows_taut` tile) and `spr_bram_ow16_rub_neck_strip2` (freed Bram). `crown_sergeant_gate` is the checkpoint NPC and is separate from the battle enemy `crown_sergeant`.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_bram_bound_ow16_idle_down` | `npcs/bram/spr_bram_bound_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_bound_ow16_idle_left` | `npcs/bram/spr_bram_bound_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_bound_ow16_idle_right` | `npcs/bram/spr_bram_bound_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_bound_ow16_idle_up` | `npcs/bram/spr_bram_bound_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_bound_ow16_noose_taut_strip2` | `npcs/bram/spr_bram_bound_ow16_noose_taut_strip2.png` | 2 | 16×24 | (8, 23) | 0, 8, 15, 23 | 2 |
| `spr_bram_bound_ow16_walk_down_strip4` | `npcs/bram/spr_bram_bound_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bram_bound_ow16_walk_left_strip4` | `npcs/bram/spr_bram_bound_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bram_bound_ow16_walk_right_strip4` | `npcs/bram/spr_bram_bound_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bram_bound_ow16_walk_up_strip4` | `npcs/bram/spr_bram_bound_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bram_ow16_idle_down` | `npcs/bram/spr_bram_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_ow16_idle_left` | `npcs/bram/spr_bram_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_ow16_idle_right` | `npcs/bram/spr_bram_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_ow16_idle_up` | `npcs/bram/spr_bram_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bram_ow16_rub_neck_strip2` | `npcs/bram/spr_bram_ow16_rub_neck_strip2.png` | 2 | 16×24 | (8, 23) | 0, 8, 15, 23 | 2 |
| `spr_bram_ow16_walk_down_strip4` | `npcs/bram/spr_bram_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bram_ow16_walk_left_strip4` | `npcs/bram/spr_bram_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bram_ow16_walk_right_strip4` | `npcs/bram/spr_bram_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bram_ow16_walk_up_strip4` | `npcs/bram/spr_bram_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_a_ow16_idle_down` | `npcs/prisoner_a/spr_prisoner_a_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_a_ow16_idle_left` | `npcs/prisoner_a/spr_prisoner_a_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_a_ow16_idle_right` | `npcs/prisoner_a/spr_prisoner_a_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_a_ow16_idle_up` | `npcs/prisoner_a/spr_prisoner_a_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_a_ow16_walk_down_strip4` | `npcs/prisoner_a/spr_prisoner_a_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_a_ow16_walk_left_strip4` | `npcs/prisoner_a/spr_prisoner_a_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_a_ow16_walk_right_strip4` | `npcs/prisoner_a/spr_prisoner_a_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_a_ow16_walk_up_strip4` | `npcs/prisoner_a/spr_prisoner_a_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_b_ow16_idle_down` | `npcs/prisoner_b/spr_prisoner_b_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_b_ow16_idle_left` | `npcs/prisoner_b/spr_prisoner_b_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_b_ow16_idle_right` | `npcs/prisoner_b/spr_prisoner_b_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_b_ow16_idle_up` | `npcs/prisoner_b/spr_prisoner_b_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_b_ow16_walk_down_strip4` | `npcs/prisoner_b/spr_prisoner_b_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_b_ow16_walk_left_strip4` | `npcs/prisoner_b/spr_prisoner_b_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_b_ow16_walk_right_strip4` | `npcs/prisoner_b/spr_prisoner_b_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_b_ow16_walk_up_strip4` | `npcs/prisoner_b/spr_prisoner_b_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_c_ow16_idle_down` | `npcs/prisoner_c/spr_prisoner_c_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_c_ow16_idle_left` | `npcs/prisoner_c/spr_prisoner_c_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_c_ow16_idle_right` | `npcs/prisoner_c/spr_prisoner_c_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_c_ow16_idle_up` | `npcs/prisoner_c/spr_prisoner_c_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_prisoner_c_ow16_walk_down_strip4` | `npcs/prisoner_c/spr_prisoner_c_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_c_ow16_walk_left_strip4` | `npcs/prisoner_c/spr_prisoner_c_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_c_ow16_walk_right_strip4` | `npcs/prisoner_c/spr_prisoner_c_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_prisoner_c_ow16_walk_up_strip4` | `npcs/prisoner_c/spr_prisoner_c_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_oda_ow16_idle_down` | `npcs/oda/spr_oda_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_oda_ow16_idle_left` | `npcs/oda/spr_oda_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_oda_ow16_idle_right` | `npcs/oda/spr_oda_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_oda_ow16_idle_up` | `npcs/oda/spr_oda_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_oda_ow16_walk_down_strip4` | `npcs/oda/spr_oda_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_oda_ow16_walk_left_strip4` | `npcs/oda/spr_oda_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_oda_ow16_walk_right_strip4` | `npcs/oda/spr_oda_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_oda_ow16_walk_up_strip4` | `npcs/oda/spr_oda_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_perrin_ow16_idle_down` | `npcs/perrin/spr_perrin_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_perrin_ow16_idle_left` | `npcs/perrin/spr_perrin_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_perrin_ow16_idle_right` | `npcs/perrin/spr_perrin_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_perrin_ow16_idle_up` | `npcs/perrin/spr_perrin_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_perrin_ow16_walk_down_strip4` | `npcs/perrin/spr_perrin_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_perrin_ow16_walk_left_strip4` | `npcs/perrin/spr_perrin_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_perrin_ow16_walk_right_strip4` | `npcs/perrin/spr_perrin_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_perrin_ow16_walk_up_strip4` | `npcs/perrin/spr_perrin_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_len_ow16_idle_down` | `npcs/len/spr_len_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_len_ow16_idle_left` | `npcs/len/spr_len_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_len_ow16_idle_right` | `npcs/len/spr_len_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_len_ow16_idle_up` | `npcs/len/spr_len_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_len_ow16_walk_down_strip4` | `npcs/len/spr_len_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_len_ow16_walk_left_strip4` | `npcs/len/spr_len_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_len_ow16_walk_right_strip4` | `npcs/len/spr_len_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_len_ow16_walk_up_strip4` | `npcs/len/spr_len_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_traveler_ow16_idle_down` | `npcs/traveler/spr_traveler_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_traveler_ow16_idle_left` | `npcs/traveler/spr_traveler_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_traveler_ow16_idle_right` | `npcs/traveler/spr_traveler_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_traveler_ow16_idle_up` | `npcs/traveler/spr_traveler_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_traveler_ow16_walk_down_strip4` | `npcs/traveler/spr_traveler_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_traveler_ow16_walk_left_strip4` | `npcs/traveler/spr_traveler_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_traveler_ow16_walk_right_strip4` | `npcs/traveler/spr_traveler_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_traveler_ow16_walk_up_strip4` | `npcs/traveler/spr_traveler_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_sergeant_gate_ow16_idle_down` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_gate_ow16_idle_left` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_gate_ow16_idle_right` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_gate_ow16_idle_up` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_sergeant_gate_ow16_walk_down_strip4` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_sergeant_gate_ow16_walk_left_strip4` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_sergeant_gate_ow16_walk_right_strip4` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_sergeant_gate_ow16_walk_up_strip4` | `npcs/crown_sergeant_gate/spr_crown_sergeant_gate_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_firm_ow16_idle_down` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_firm_ow16_idle_left` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_firm_ow16_idle_right` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_firm_ow16_idle_up` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_firm_ow16_walk_down_strip4` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_firm_ow16_walk_left_strip4` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_firm_ow16_walk_right_strip4` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_firm_ow16_walk_up_strip4` | `npcs/crown_soldier_firm/spr_crown_soldier_firm_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_unwilling_ow16_idle_down` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_unwilling_ow16_idle_left` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_unwilling_ow16_idle_right` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_unwilling_ow16_idle_up` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_soldier_unwilling_ow16_walk_down_strip4` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_unwilling_ow16_walk_left_strip4` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_unwilling_ow16_walk_right_strip4` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_soldier_unwilling_ow16_walk_up_strip4` | `npcs/crown_soldier_unwilling/spr_crown_soldier_unwilling_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_a_ow16_idle_down` | `npcs/villager_a/spr_villager_a_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_a_ow16_idle_left` | `npcs/villager_a/spr_villager_a_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_a_ow16_idle_right` | `npcs/villager_a/spr_villager_a_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_a_ow16_idle_up` | `npcs/villager_a/spr_villager_a_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_a_ow16_walk_down_strip4` | `npcs/villager_a/spr_villager_a_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_a_ow16_walk_left_strip4` | `npcs/villager_a/spr_villager_a_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_a_ow16_walk_right_strip4` | `npcs/villager_a/spr_villager_a_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_a_ow16_walk_up_strip4` | `npcs/villager_a/spr_villager_a_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_b_ow16_idle_down` | `npcs/villager_b/spr_villager_b_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_b_ow16_idle_left` | `npcs/villager_b/spr_villager_b_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_b_ow16_idle_right` | `npcs/villager_b/spr_villager_b_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_b_ow16_idle_up` | `npcs/villager_b/spr_villager_b_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_villager_b_ow16_walk_down_strip4` | `npcs/villager_b/spr_villager_b_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_b_ow16_walk_left_strip4` | `npcs/villager_b/spr_villager_b_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_b_ow16_walk_right_strip4` | `npcs/villager_b/spr_villager_b_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_villager_b_ow16_walk_up_strip4` | `npcs/villager_b/spr_villager_b_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_taren_ow16_idle_down` | `npcs/taren/spr_taren_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_taren_ow16_idle_left` | `npcs/taren/spr_taren_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_taren_ow16_idle_right` | `npcs/taren/spr_taren_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_taren_ow16_idle_up` | `npcs/taren/spr_taren_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_taren_ow16_walk_down_strip4` | `npcs/taren/spr_taren_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_taren_ow16_walk_left_strip4` | `npcs/taren/spr_taren_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_taren_ow16_walk_right_strip4` | `npcs/taren/spr_taren_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_taren_ow16_walk_up_strip4` | `npcs/taren/spr_taren_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

### Lyra (generated party kit)

Lyra Veyne, generated by `src/lyra.py` through the shared party renderer. The earlier flat-colour set was replaced in Batch 10; these are the current imported frames. Same frame sizes and origins as the Taren set. Replace only if Design supplies new canon art.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_lyra_ow16_idle_down` | `npcs/lyra/spr_lyra_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lyra_ow16_idle_left` | `npcs/lyra/spr_lyra_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lyra_ow16_idle_right` | `npcs/lyra/spr_lyra_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lyra_ow16_idle_up` | `npcs/lyra/spr_lyra_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lyra_ow16_walk_down_strip4` | `npcs/lyra/spr_lyra_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lyra_ow16_walk_left_strip4` | `npcs/lyra/spr_lyra_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lyra_ow16_walk_right_strip4` | `npcs/lyra/spr_lyra_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lyra_ow16_walk_up_strip4` | `npcs/lyra/spr_lyra_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

### Chapter 2 dialogue portraits
48×48, origin (0, 0). The dialogue data picks an expression per line (`expr`); Bram and Oda have no `_neutral`, so their defaults are `_shaken` and `_worried`.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_portrait_bram_afraid` | `portraits/bram/spr_portrait_bram_afraid.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_bram_grateful` | `portraits/bram/spr_portrait_bram_grateful.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_bram_shaken` | `portraits/bram/spr_portrait_bram_shaken.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_oda_pleading` | `portraits/oda/spr_portrait_oda_pleading.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_oda_relieved` | `portraits/oda/spr_portrait_oda_relieved.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_oda_worried` | `portraits/oda/spr_portrait_oda_worried.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_perrin_grim` | `portraits/perrin/spr_portrait_perrin_grim.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_perrin_neutral` | `portraits/perrin/spr_portrait_perrin_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_perrin_warm` | `portraits/perrin/spr_portrait_perrin_warm.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_len_nervous` | `portraits/len/spr_portrait_len_nervous.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_len_neutral` | `portraits/len/spr_portrait_len_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_len_smile` | `portraits/len/spr_portrait_len_smile.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_taren_determined` | `portraits/taren/spr_portrait_taren_determined.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_taren_neutral` | `portraits/taren/spr_portrait_taren_neutral.png` | 1 | 48×48 | (0, 0) | full image | 0 |
| `spr_portrait_taren_wry` | `portraits/taren/spr_portrait_taren_wry.png` | 1 | 48×48 | (0, 0) | full image | 0 |

### Taren Holt battle set
Origin **(16, 47)** on every strip (feet; frames are 32 or 48 px wide, as drawn). Battle FPS as for Kael (idle / walk use `BATTLE_IDLE_FPS`, the rest `BATTLE_ANIM_FPS`). The code finds them by name (`scr_battle_auto_strip`): Guard holds `defend`, Rallying Cry plays `skill_rally`, Cleave plays `skill_cleave`. Mask: full image.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_taren_attack_strip6` | `party/taren/spr_taren_attack_strip6.png` | 6 | 48×48 | (16, 47) | full image | battle |
| `spr_taren_death_strip6` | `party/taren/spr_taren_death_strip6.png` | 6 | 48×48 | (16, 47) | full image | battle |
| `spr_taren_defend_strip3` | `party/taren/spr_taren_defend_strip3.png` | 3 | 32×48 | (16, 47) | full image | battle |
| `spr_taren_hurt_strip3` | `party/taren/spr_taren_hurt_strip3.png` | 3 | 32×48 | (16, 47) | full image | battle |
| `spr_taren_idle_strip4` | `party/taren/spr_taren_idle_strip4.png` | 4 | 32×48 | (16, 47) | full image | battle |
| `spr_taren_skill_cleave_strip6` | `party/taren/spr_taren_skill_cleave_strip6.png` | 6 | 48×48 | (16, 47) | full image | battle |
| `spr_taren_skill_rally_strip6` | `party/taren/spr_taren_skill_rally_strip6.png` | 6 | 32×48 | (16, 47) | full image | battle |
| `spr_taren_walk_strip8` | `party/taren/spr_taren_walk_strip8.png` | 8 | 32×48 | (16, 47) | full image | battle |

### Lyra battle strips (generated party kit)

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_lyra_idle_strip4` | `party/lyra/spr_lyra_idle_strip4.png` | 4 | 32×48 | (16, 47) | full image | battle |
| `spr_lyra_walk_strip8` | `party/lyra/spr_lyra_walk_strip8.png` | 8 | 32×48 | (16, 47) | full image | battle |
| `spr_lyra_attack_strip6` | `party/lyra/spr_lyra_attack_strip6.png` | 6 | 48×48 | (16, 47) | full image | battle |
| `spr_lyra_hurt_strip3` | `party/lyra/spr_lyra_hurt_strip3.png` | 3 | 32×48 | (16, 47) | full image | battle |
| `spr_lyra_defend_strip3` | `party/lyra/spr_lyra_defend_strip3.png` | 3 | 32×48 | (16, 47) | full image | battle |
| `spr_lyra_death_strip6` | `party/lyra/spr_lyra_death_strip6.png` | 6 | 48×48 | (16, 47) | full image | battle |

### Batch 9 — Sera, Caelan (full sets) and Lyra (portraits)

Initial party-kit sets generated by `src/party_kit.py` through `src/sera.py`, `src/caelan.py` and `src/portraits.py`; Lyra's set was redrawn in Batch 10 and is no longer a flat colour. Unlike the older PNG-only entries above, these are **already imported**: `tools/import_sprites.py` created the sprite resources (frames, layer, sequence) under `gamemaker/sprites/` and registered them in `AshenCrown.yyp`. Do not re-create them by hand; re-run that tool instead.

Overworld sets: frame 16×24, origin (8, 23), mask 0, 8, 15, 23, walk 8 fps.
Battle strips: party faces right, origin (16, 47) on 32- and 48-wide frames, idle/walk loop at `BATTLE_IDLE_FPS`, the rest at `BATTLE_ANIM_FPS`.
Portraits: 48×48, origin (0, 0).

| Asset name | File | Frames | Frame size | Origin |
|---|---|---|---|---|
| `spr_sera_ow16_idle_down` | `npcs/sera/spr_sera_ow16_idle_down.png` | 1 | 16×24 | (8, 23) |
| `spr_sera_ow16_idle_up` | `npcs/sera/spr_sera_ow16_idle_up.png` | 1 | 16×24 | (8, 23) |
| `spr_sera_ow16_idle_left` | `npcs/sera/spr_sera_ow16_idle_left.png` | 1 | 16×24 | (8, 23) |
| `spr_sera_ow16_idle_right` | `npcs/sera/spr_sera_ow16_idle_right.png` | 1 | 16×24 | (8, 23) |
| `spr_sera_ow16_walk_down_strip4` | `npcs/sera/spr_sera_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_sera_ow16_walk_up_strip4` | `npcs/sera/spr_sera_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_sera_ow16_walk_left_strip4` | `npcs/sera/spr_sera_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_sera_ow16_walk_right_strip4` | `npcs/sera/spr_sera_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_sera_{idle_strip4,walk_strip8}` | `party/sera/…` | 4 / 8 | 32×48 | (16, 47) |
| `spr_sera_{hurt_strip3,defend_strip3}` | `party/sera/…` | 3 | 32×48 | (16, 47) |
| `spr_sera_{attack_strip6,death_strip6}` | `party/sera/…` | 6 | 48×48 | (16, 47) |
| `spr_portrait_sera_{neutral,determined,pained}` | `portraits/sera/…` | 1 | 48×48 | (0, 0) |
| `spr_caelan_ow16_idle_*` / `spr_caelan_ow16_walk_*_strip4` | `npcs/caelan/…` | 1 / 4 | 16×24 | (8, 23) |
| `spr_caelan_{idle_strip4,walk_strip8,hurt_strip3,defend_strip3,attack_strip6,death_strip6}` | `party/caelan/…` | 4/8/3/3/6/6 | 32×48 or 48×48 | (16, 47) |
| `spr_portrait_caelan_{neutral,determined,pained}` | `portraits/caelan/…` | 1 | 48×48 | (0, 0) |
| `spr_portrait_lyra_{neutral,determined,pained}` | `portraits/lyra/…` | 1 | 48×48 | (0, 0) |

Names resolve by convention: `scr_battle_kind_is_generic` includes `caelan` and `sera`, and `scr_ch1_portrait` maps all three speakers.

## Batch 10 — Lyra redraw and marker art (refreshed in place)

`src/lyra.py` and the ten marker sprites in `src/markers.py` replace art that already had
GameMaker resources, so they are **not imported**: they are **refreshed**, which rewrites the
frame PNGs and the `layers/<frame>/<layer>.png` copies while keeping every id in the `.yy` (frames,
layer, origin) and every `AshenCrown.yyp` entry untouched.

```bash
python3 tools/import_sprites.py --refresh   # 61 resources: Sera, Caelan, Lyra, 10 markers
```

The party sets are regenerated from `src/sera.py`, `src/caelan.py`, `src/lyra.py`; the overworld
figures now share one Taren-derived template, and the battle walk carries a real stride.

| Resources | Source | Frames | Size | Origin |
|---|---|---|---|---|
| `spr_lyra_ow16_idle_down` | `npcs/lyra/spr_lyra_ow16_idle_down.png` | 1 | 16×24 | (8, 23) |
| `spr_lyra_ow16_idle_up` | `npcs/lyra/spr_lyra_ow16_idle_up.png` | 1 | 16×24 | (8, 23) |
| `spr_lyra_ow16_idle_left` | `npcs/lyra/spr_lyra_ow16_idle_left.png` | 1 | 16×24 | (8, 23) |
| `spr_lyra_ow16_idle_right` | `npcs/lyra/spr_lyra_ow16_idle_right.png` | 1 | 16×24 | (8, 23) |
| `spr_lyra_ow16_walk_down_strip4` | `npcs/lyra/spr_lyra_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_lyra_ow16_walk_up_strip4` | `npcs/lyra/spr_lyra_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_lyra_ow16_walk_left_strip4` | `npcs/lyra/spr_lyra_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_lyra_ow16_walk_right_strip4` | `npcs/lyra/spr_lyra_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_lyra_{idle_strip4,walk_strip8,hurt_strip3,defend_strip3}` | `party/lyra/…` | 4/8/3/3 | 32×48 | (16, 47) |
| `spr_lyra_{attack_strip6,death_strip6}` | `party/lyra/…` | 6 | 48×48 | (16, 47) |
| `spr_portrait_lyra_{neutral,determined,pained}` | `portraits/lyra/…` | 1 | 48×48 | (0, 0) |
| `spr_{solid,interactable,story_npc,respawn_point,encounter_trigger,encounter_zone,story_trigger,story_encounter,trap_plate}_placeholder` | `ui/markers/…` | 1 | 16×16 | (0, 0) |
| `spr_player_placeholder` | `ui/markers/spr_player_placeholder.png` | 1 | 16×24 | (0, 0) |

`--refresh` verifies the art's frame count against the resource's frame count and aborts on a
mismatch, so a changed strip layout cannot silently corrupt an existing sprite. A normal run
(without `--refresh`) still imports new resources and registers them in the yyp; the marker list
is part of the manifest but only ever refreshed, since all ten already have resources.

## Batch 11 — Alden, Nim and Derry (2026-11-18)

Named speakers that previously borrowed other characters' art. Generated by `src/story_npcs.py`
and **already imported** with their own resources:

```bash
python3 tools/import_sprites.py --story-npcs   # 33 new resources: 24 overworld + 9 portraits
```

Overworld sets: 16×24, origin (8, 23), mask 0, 8, 15, 23, idle 1 frame + walk 4 frames at 8 fps.
Portraits: 48×48, origin (0, 0), one sprite per expression. There are no battle strips: Alden has
no battle slot, and Nim and Derry are not party members. Their appearance is new art direction,
not story canon.

| Asset name | File | Frames | Frame size | Origin |
|---|---|---|---|---|
| `spr_alden_ow16_idle_down` | `npcs/alden/spr_alden_ow16_idle_down.png` | 1 | 16×24 | (8, 23) |
| `spr_alden_ow16_idle_up` | `npcs/alden/spr_alden_ow16_idle_up.png` | 1 | 16×24 | (8, 23) |
| `spr_alden_ow16_idle_left` | `npcs/alden/spr_alden_ow16_idle_left.png` | 1 | 16×24 | (8, 23) |
| `spr_alden_ow16_idle_right` | `npcs/alden/spr_alden_ow16_idle_right.png` | 1 | 16×24 | (8, 23) |
| `spr_alden_ow16_walk_down_strip4` | `npcs/alden/spr_alden_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_alden_ow16_walk_up_strip4` | `npcs/alden/spr_alden_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_alden_ow16_walk_left_strip4` | `npcs/alden/spr_alden_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_alden_ow16_walk_right_strip4` | `npcs/alden/spr_alden_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) |
| `spr_nim_ow16_idle_*` / `spr_nim_ow16_walk_*_strip4` | `npcs/nim/…` | 1 / 4 | 16×24 | (8, 23) |
| `spr_derry_ow16_idle_*` / `spr_derry_ow16_walk_*_strip4` | `npcs/derry/…` | 1 / 4 | 16×24 | (8, 23) |
| `spr_portrait_alden_{neutral,warm,resolved}` | `portraits/alden/…` | 1 | 48×48 | (0, 0) |
| `spr_portrait_nim_{neutral,wry,wary}` | `portraits/nim/…` | 1 | 48×48 | (0, 0) |
| `spr_portrait_derry_{neutral,wary,grim}` | `portraits/derry/…` | 1 | 48×48 | (0, 0) |

`scr_ch1_portrait` maps the speakers **Alden**, **Nim** and **Derry** to these sets. `scr_ch3_markers_data`
and `scr_ch9_markers_data` are generated by their room tools and point at the idle-down frames.

## Batch 12 — Act II enemy map sets (2026-11-18)

Four enemy kinds that had battle strips but no 16×24 map set. Generated by
`src/act2_enemy_ow.py` and **already imported** with their own resources:

```bash
python3 tools/import_sprites.py --act2-enemy-ow   # 32 new resources: 4 kinds x 8
```

Each kind has a 16×24 idle frame and a 4-frame walk strip in all four directions,
origin (8, 23), mask 0, 8, 15, 23, walk at 8 fps. The battle strips above are unchanged.
The details are hand-drawn over the shared 16×24 party template: kettle helm, spear and
shield for the Patrolman; cap, blue sash and crossbow for the Crossbowman; great helm,
halberd and heavy shield for the Occupation Soldier; fur hood, red scarf and axe for the
Bandit Veteran. The four sets are wired into visible encounter markers: the Millhaven
patrol's leader uses the Patrolman, the east and west clearings use the Crossbowman and
Bandit Veteran, and occupied Wrenfield uses the Occupation Soldier.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_crown_patrolman_ow16_idle_down` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_patrolman_ow16_walk_down_strip4` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_patrolman_ow16_idle_up` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_patrolman_ow16_walk_up_strip4` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_patrolman_ow16_idle_left` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_patrolman_ow16_walk_left_strip4` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_patrolman_ow16_idle_right` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_patrolman_ow16_walk_right_strip4` | `enemies/crown_patrolman/overworld/spr_crown_patrolman_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_crossbowman_ow16_idle_down` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_crossbowman_ow16_walk_down_strip4` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_crossbowman_ow16_idle_up` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_crossbowman_ow16_walk_up_strip4` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_crossbowman_ow16_idle_left` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_crossbowman_ow16_walk_left_strip4` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_crown_crossbowman_ow16_idle_right` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_crown_crossbowman_ow16_walk_right_strip4` | `enemies/crown_crossbowman/overworld/spr_crown_crossbowman_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_occupation_soldier_ow16_idle_down` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_occupation_soldier_ow16_walk_down_strip4` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_occupation_soldier_ow16_idle_up` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_occupation_soldier_ow16_walk_up_strip4` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_occupation_soldier_ow16_idle_left` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_occupation_soldier_ow16_walk_left_strip4` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_occupation_soldier_ow16_idle_right` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_occupation_soldier_ow16_walk_right_strip4` | `enemies/occupation_soldier/overworld/spr_occupation_soldier_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_veteran_ow16_idle_down` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_veteran_ow16_walk_down_strip4` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_veteran_ow16_idle_up` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_veteran_ow16_walk_up_strip4` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_veteran_ow16_idle_left` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_veteran_ow16_walk_left_strip4` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_bandit_veteran_ow16_idle_right` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_bandit_veteran_ow16_walk_right_strip4` | `enemies/bandit_veteran/overworld/spr_bandit_veteran_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

## Batch 13 — Berrin and the ward sentinels (2026-11-18)

Two Blackwood roles that had been borrowing other characters' map sets. Generated by
`src/story_extra.py` and **already imported** with their own resources:

```bash
python3 tools/import_sprites.py --berrin-sentinels   # 16 new resources: 2 sets x 8
```

Each set is 16×24, origin (8, 23), mask 0, 8, 15, 23, idle 1 frame + walk 4 frames at 8 fps.
No battle strips or portraits: Berrin has no battle slot, and the sentinels are map-only ward
posts. Berrin's appearance is new art direction: a dark wool cap, grey beard and worn green coat.
The sentinels keep the Door Warden's “same make” silhouette but are pale limestone with an amber
ward-mark and a raised crest, so they read as ward posts rather than as the boss.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_berrin_ow16_idle_down` | `npcs/berrin/spr_berrin_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_berrin_ow16_idle_up` | `npcs/berrin/spr_berrin_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_berrin_ow16_idle_left` | `npcs/berrin/spr_berrin_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_berrin_ow16_idle_right` | `npcs/berrin/spr_berrin_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_berrin_ow16_walk_down_strip4` | `npcs/berrin/spr_berrin_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_berrin_ow16_walk_up_strip4` | `npcs/berrin/spr_berrin_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_berrin_ow16_walk_left_strip4` | `npcs/berrin/spr_berrin_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_berrin_ow16_walk_right_strip4` | `npcs/berrin/spr_berrin_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ward_sentinel_ow16_idle_down` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ward_sentinel_ow16_idle_up` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ward_sentinel_ow16_idle_left` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ward_sentinel_ow16_idle_right` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_ward_sentinel_ow16_walk_down_strip4` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ward_sentinel_ow16_walk_up_strip4` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ward_sentinel_ow16_walk_left_strip4` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_ward_sentinel_ow16_walk_right_strip4` | `enemies/ward_sentinel/overworld/spr_ward_sentinel_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

`scr_ch6_markers_data` and `scr_ch7_markers_data` use Berrin's idle-down and idle-left frames;
`scr_ch8_markers_data` uses the sentinels' inward-facing idle-left and idle-right frames. The
ward-sentinel set also closes the `ward_sentinel` enemy map-set gap recorded in Batch 12.

## Batch 14 — Cinderhollow burners and the Lost Ones (2026-11-18)

Five dedicated 16×24 sets for the silent Cinderhollow crowd and the shrine's Lost Ones. Generated
by `src/blackwood_folk.py` and **already imported** with their own resources:

```bash
python3 tools/import_sprites.py --blackwood-folk   # 40 new resources: 5 sets x 8
```

Each set is 16×24, origin (8, 23), mask 0, 8, 15, 23, idle 1 frame + walk 4 frames at 8 fps.
No battle strips or portraits: these are map-only silent figures. The burner adult is soot-dark
with a charcoal cap; the wood-carrier has a strapped shoulder bundle; the child is a 12×18 figure
inside the same cell. The Lost Ones are pale, gaunt and leaf-littered, with a boots variant for the
one recognizable by the patrol camp's boots. Their appearance is art direction, not story canon.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_burner_ow16_idle_down` | `npcs/burner/spr_burner_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_ow16_walk_down_strip4` | `npcs/burner/spr_burner_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_ow16_idle_up` | `npcs/burner/spr_burner_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_ow16_walk_up_strip4` | `npcs/burner/spr_burner_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_ow16_idle_left` | `npcs/burner/spr_burner_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_ow16_walk_left_strip4` | `npcs/burner/spr_burner_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_ow16_idle_right` | `npcs/burner/spr_burner_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_ow16_walk_right_strip4` | `npcs/burner/spr_burner_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_wood_ow16_idle_down` | `npcs/burner_wood/spr_burner_wood_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_wood_ow16_walk_down_strip4` | `npcs/burner_wood/spr_burner_wood_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_wood_ow16_idle_up` | `npcs/burner_wood/spr_burner_wood_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_wood_ow16_walk_up_strip4` | `npcs/burner_wood/spr_burner_wood_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_wood_ow16_idle_left` | `npcs/burner_wood/spr_burner_wood_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_wood_ow16_walk_left_strip4` | `npcs/burner_wood/spr_burner_wood_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_wood_ow16_idle_right` | `npcs/burner_wood/spr_burner_wood_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_wood_ow16_walk_right_strip4` | `npcs/burner_wood/spr_burner_wood_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_child_ow16_idle_down` | `npcs/burner_child/spr_burner_child_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_child_ow16_walk_down_strip4` | `npcs/burner_child/spr_burner_child_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_child_ow16_idle_up` | `npcs/burner_child/spr_burner_child_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_child_ow16_walk_up_strip4` | `npcs/burner_child/spr_burner_child_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_child_ow16_idle_left` | `npcs/burner_child/spr_burner_child_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_child_ow16_walk_left_strip4` | `npcs/burner_child/spr_burner_child_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_burner_child_ow16_idle_right` | `npcs/burner_child/spr_burner_child_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_burner_child_ow16_walk_right_strip4` | `npcs/burner_child/spr_burner_child_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_ow16_idle_down` | `enemies/lost_one/overworld/spr_lost_one_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_ow16_walk_down_strip4` | `enemies/lost_one/overworld/spr_lost_one_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_ow16_idle_up` | `enemies/lost_one/overworld/spr_lost_one_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_ow16_walk_up_strip4` | `enemies/lost_one/overworld/spr_lost_one_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_ow16_idle_left` | `enemies/lost_one/overworld/spr_lost_one_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_ow16_walk_left_strip4` | `enemies/lost_one/overworld/spr_lost_one_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_ow16_idle_right` | `enemies/lost_one/overworld/spr_lost_one_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_ow16_walk_right_strip4` | `enemies/lost_one/overworld/spr_lost_one_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_boots_ow16_idle_down` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_boots_ow16_walk_down_strip4` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_boots_ow16_idle_up` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_boots_ow16_walk_up_strip4` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_boots_ow16_idle_left` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_boots_ow16_walk_left_strip4` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_lost_one_boots_ow16_idle_right` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_lost_one_boots_ow16_walk_right_strip4` | `enemies/lost_one/overworld/spr_lost_one_boots_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

## Batch 15 — Coleford's magistrate and his clerk (2026-11-18)

Two Act IV NPCs that had been standing on the generic story-NPC placeholder. Generated by
`src/crown_town_folk.py` and **already imported** with their own resources:

```bash
python3 tools/import_sprites.py --crown-town   # 16 new resources: 2 sets x 8
```

Each set is 16×24, origin (8, 23), mask 0, 8, 15, 23, idle 1 frame + walk 4 frames at 8 fps.
No battle strips and no portraits: Vell yields in one scripted fight and neither has a portrait
slot. Vell reads as a Crown administrator — indigo coat, grey temples, brass seal, ink at the
cuffs, and the heavy ledger his `VG_FIGHT` kit names. Nessa reads as his clerk — hair tied back,
linen apron, ink-stained fingers, and the folded page she asks an hour with. Their appearance is
art direction, not story canon.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_vell_ow16_idle_down` | `npcs/vell/spr_vell_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_vell_ow16_walk_down_strip4` | `npcs/vell/spr_vell_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_vell_ow16_idle_up` | `npcs/vell/spr_vell_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_vell_ow16_walk_up_strip4` | `npcs/vell/spr_vell_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_vell_ow16_idle_left` | `npcs/vell/spr_vell_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_vell_ow16_walk_left_strip4` | `npcs/vell/spr_vell_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_vell_ow16_idle_right` | `npcs/vell/spr_vell_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_vell_ow16_walk_right_strip4` | `npcs/vell/spr_vell_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_nessa_ow16_idle_down` | `npcs/nessa/spr_nessa_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_nessa_ow16_walk_down_strip4` | `npcs/nessa/spr_nessa_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_nessa_ow16_idle_up` | `npcs/nessa/spr_nessa_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_nessa_ow16_walk_up_strip4` | `npcs/nessa/spr_nessa_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_nessa_ow16_idle_left` | `npcs/nessa/spr_nessa_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_nessa_ow16_walk_left_strip4` | `npcs/nessa/spr_nessa_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_nessa_ow16_idle_right` | `npcs/nessa/spr_nessa_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_nessa_ow16_walk_right_strip4` | `npcs/nessa/spr_nessa_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |

`scr_ch9_markers_data` names `spr_vell_ow16_idle_down` and `spr_nessa_ow16_idle_down` at the
ledger house door. Their tile coordinates, `npc_id`, speaker, script id and facing are unchanged.

## Batch 16 — the last twelve enemy map sets (2026-11-19)

Every remaining enemy kind with battle art and no 16×24 set. Generated by
`src/enemy_ow_remaining.py` and **already imported** with their own resources:

```bash
python3 tools/import_sprites.py --remaining-enemies   # 96 new resources: 12 sets x 8
```

Each set is 16×24, origin (8, 23), mask 0, 8, 15, 23, idle 1 frame + walk 4 frames at 8 fps.
The four humanoids use the shared body template; the hostile Fallen Knight is the story
sighting's armour darkened, with a drawn greatsword; the Sanctuary Warden is the Door Warden's
stone with moss and a verdant ward-light; the wraith and the four beasts are hand-drawn grids.
No battle strip changed, and no marker data had to change: `scr_ch1_bind_enemy_ow` resolves
`spr_<kind>_ow16_idle_<dir>` by name, so the five Fallen Knight `enemy_spawn` markers now draw
the hostile set.

| Asset name | File | Frames | Frame size | Origin | Mask (L,T,R,B) | FPS |
|---|---|---|---|---|---|---|
| `spr_cutpurse_ow16_idle_down` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_cutpurse_ow16_idle_up` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_cutpurse_ow16_idle_left` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_cutpurse_ow16_idle_right` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_cutpurse_ow16_walk_down_strip4` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_cutpurse_ow16_walk_up_strip4` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_cutpurse_ow16_walk_left_strip4` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_cutpurse_ow16_walk_right_strip4` | `enemies/cutpurse/overworld/spr_cutpurse_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dock_thug_ow16_idle_down` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dock_thug_ow16_idle_up` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dock_thug_ow16_idle_left` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dock_thug_ow16_idle_right` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_dock_thug_ow16_walk_down_strip4` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dock_thug_ow16_walk_up_strip4` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dock_thug_ow16_walk_left_strip4` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_dock_thug_ow16_walk_right_strip4` | `enemies/dock_thug/overworld/spr_dock_thug_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_field_surgeon_ow16_idle_down` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_field_surgeon_ow16_idle_up` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_field_surgeon_ow16_idle_left` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_field_surgeon_ow16_idle_right` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_field_surgeon_ow16_walk_down_strip4` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_field_surgeon_ow16_walk_up_strip4` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_field_surgeon_ow16_walk_left_strip4` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_field_surgeon_ow16_walk_right_strip4` | `enemies/garrison_field_surgeon/overworld/spr_garrison_field_surgeon_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_pikeman_ow16_idle_down` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_pikeman_ow16_idle_up` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_pikeman_ow16_idle_left` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_pikeman_ow16_idle_right` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_garrison_pikeman_ow16_walk_down_strip4` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_pikeman_ow16_walk_up_strip4` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_pikeman_ow16_walk_left_strip4` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_garrison_pikeman_ow16_walk_right_strip4` | `enemies/garrison_pikeman/overworld/spr_garrison_pikeman_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_ow16_idle_down` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_ow16_idle_up` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_ow16_idle_left` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_ow16_idle_right` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_fallen_knight_ow16_walk_down_strip4` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_ow16_walk_up_strip4` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_ow16_walk_left_strip4` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_fallen_knight_ow16_walk_right_strip4` | `enemies/fallen_knight/overworld/spr_fallen_knight_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_sanctuary_warden_ow16_idle_down` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_sanctuary_warden_ow16_idle_up` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_sanctuary_warden_ow16_idle_left` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_sanctuary_warden_ow16_idle_right` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_sanctuary_warden_ow16_walk_down_strip4` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_sanctuary_warden_ow16_walk_up_strip4` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_sanctuary_warden_ow16_walk_left_strip4` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_sanctuary_warden_ow16_walk_right_strip4` | `enemies/sanctuary_warden/overworld/spr_sanctuary_warden_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_shade_stalker_ow16_idle_down` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_shade_stalker_ow16_idle_up` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_shade_stalker_ow16_idle_left` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_shade_stalker_ow16_idle_right` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_shade_stalker_ow16_walk_down_strip4` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_shade_stalker_ow16_walk_up_strip4` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_shade_stalker_ow16_walk_left_strip4` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_shade_stalker_ow16_walk_right_strip4` | `enemies/shade_stalker/overworld/spr_shade_stalker_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_briar_hulk_ow16_idle_down` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_briar_hulk_ow16_idle_up` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_briar_hulk_ow16_idle_left` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_briar_hulk_ow16_idle_right` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_briar_hulk_ow16_walk_down_strip4` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_briar_hulk_ow16_walk_up_strip4` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_briar_hulk_ow16_walk_left_strip4` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_briar_hulk_ow16_walk_right_strip4` | `enemies/briar_hulk/overworld/spr_briar_hulk_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_glyph_wisp_ow16_idle_down` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_glyph_wisp_ow16_idle_up` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_glyph_wisp_ow16_idle_left` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_glyph_wisp_ow16_idle_right` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_glyph_wisp_ow16_walk_down_strip4` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_glyph_wisp_ow16_walk_up_strip4` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_glyph_wisp_ow16_walk_left_strip4` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_glyph_wisp_ow16_walk_right_strip4` | `enemies/glyph_wisp/overworld/spr_glyph_wisp_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_grey_ash_wolf_ow16_idle_down` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_grey_ash_wolf_ow16_idle_up` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_grey_ash_wolf_ow16_idle_left` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_grey_ash_wolf_ow16_idle_right` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_grey_ash_wolf_ow16_walk_down_strip4` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_grey_ash_wolf_ow16_walk_up_strip4` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_grey_ash_wolf_ow16_walk_left_strip4` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_grey_ash_wolf_ow16_walk_right_strip4` | `enemies/grey_ash_wolf/overworld/spr_grey_ash_wolf_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_night_moth_swarm_ow16_idle_down` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_night_moth_swarm_ow16_idle_up` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_night_moth_swarm_ow16_idle_left` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_night_moth_swarm_ow16_idle_right` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_night_moth_swarm_ow16_walk_down_strip4` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_night_moth_swarm_ow16_walk_up_strip4` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_night_moth_swarm_ow16_walk_left_strip4` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_night_moth_swarm_ow16_walk_right_strip4` | `enemies/night_moth_swarm/overworld/spr_night_moth_swarm_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_spiderling_ow16_idle_down` | `enemies/spiderling/overworld/spr_spiderling_ow16_idle_down.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_spiderling_ow16_idle_up` | `enemies/spiderling/overworld/spr_spiderling_ow16_idle_up.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_spiderling_ow16_idle_left` | `enemies/spiderling/overworld/spr_spiderling_ow16_idle_left.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_spiderling_ow16_idle_right` | `enemies/spiderling/overworld/spr_spiderling_ow16_idle_right.png` | 1 | 16×24 | (8, 23) | 0, 8, 15, 23 | 0 |
| `spr_spiderling_ow16_walk_down_strip4` | `enemies/spiderling/overworld/spr_spiderling_ow16_walk_down_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_spiderling_ow16_walk_up_strip4` | `enemies/spiderling/overworld/spr_spiderling_ow16_walk_up_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_spiderling_ow16_walk_left_strip4` | `enemies/spiderling/overworld/spr_spiderling_ow16_walk_left_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
| `spr_spiderling_ow16_walk_right_strip4` | `enemies/spiderling/overworld/spr_spiderling_ow16_walk_right_strip4.png` | 4 | 16×24 | (8, 23) | 0, 8, 15, 23 | 8 |
