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
| `spr_item_crownveil_fragment` | `items/spr_item_crownveil_fragment.png` | 1 | 16×16 | (8, 8) | 0, 0, 15, 15 | 0 |
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
| `spr_ui_status_strip12` | `ui/spr_ui_status_strip12.png` | 12 | 10×10 | (5, 5) | full image | 10 |
| `spr_ui_toggle_strip2` | `ui/spr_ui_toggle_strip2.png` | 2 | 16×10 | (0, 0) | full image | 10 |
| `spr_ui_window` | `ui/spr_ui_window.png` | 1 | 24×24 | (0, 0) | full image | 0 |
| `spr_ui_window_dim` | `ui/spr_ui_window_dim.png` | 1 | 24×24 | (0, 0) | full image | 0 |
| `spr_ui_window_gold` | `ui/spr_ui_window_gold.png` | 1 | 24×24 | (0, 0) | full image | 0 |

## Future menu art (`/workspace/sprites/ui/menus/`)

Design is preparing dedicated shop, save/load, and inventory panels. When those PNGs land, import them with these reserved asset names (origins and nine-slice TBD with the drop):

- `spr_menu_shop_window`, `spr_ui_menu_shop`
- `spr_menu_inventory_window`, `spr_ui_menu_inventory`
- `spr_menu_save_window`, `spr_ui_menu_saves` (and `_640` if a hires panel is provided)
- `spr_menu_save_point` (or `spr_save_point`) for the world shrine

Code looks these up with `scr_sprite_index` / `asset_get_index` and already falls back to `spr_ui_window*`, `spr_menu_panel_saves_*`, and `spr_ui_cursor_strip2`. Layout numbers are in `scr_menu_layout.gml` — retune that file to match the new panels; do not scatter magic numbers in the menu objects.
