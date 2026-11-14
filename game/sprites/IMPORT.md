# Sprite import table

These PNGs live in `game/sprites/` and are **not** a GameMaker project. Create each Sprite in the IDE and import the file by hand. GameMaker auto-splits a strip when the filename ends in `_stripN` (N = frame count). Keep the asset name identical to the filename without `.png` (including `_stripN`) so the GML `asset_get_index` lookups match.

All battle strips face right. Overworld `left` frames are already mirrored; do **not** set `image_xscale` on the player. Code falls back to placeholder rectangles (battle) or the object's IDE sprite (overworld) when an asset is missing, so the project can compile before every sprite is imported.

**Recommended overworld set:** Kael's 16×24 sprites (`hero/overworld/16x24/`). Assign `spr_kael_ow16_idle_down` to `obj_player`. The 32×48 overworld set is included as a fallback the code will use only if the 16×24 assets are absent.

**Playback:** overworld walk 8 fps; battle idle 6 fps; battle attack / hurt / death 10 fps. These are macros in `scr_game_constants` (`PLAYER_WALK_FPS`, `BATTLE_IDLE_FPS`, `BATTLE_ANIM_FPS`).

**Collision masks** are set in the Sprite Editor (Image → Collision Mask). Use a **manual rectangle**, **not** automatic per-frame, so wider attack and death strips cannot change the hitbox. The player code also pins `mask_index` to the idle-down sprite.

The Zone 1 tileset / map under `/workspace/zone1/` is still being built and is **not** imported here.

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
