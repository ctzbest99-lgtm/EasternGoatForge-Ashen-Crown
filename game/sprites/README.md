# Zone 1 sprites (GameMaker)

Art delivered for Ashen Crown. Import these in the IDE by hand; there is no `.yyp` here.

**Start with [`IMPORT.md`](IMPORT.md).** It is the full IDE table: asset name, file, frame count, origin, collision mask, and fps for every sprite the code looks up.

All strips face right, real alpha, frames edge-to-edge, no padding. Feet sit on the bottom row of every frame (row 47 on 48-px-tall battle / 32×48 overworld frames; row 23 on 16×24 overworld frames).
Import: Sprite Editor → Import → pick the PNG; the `_stripN` suffix auto-splits it. Keep the asset name equal to the filename without `.png`.

| Sprite | Frames | Frame size | Origin |
|---|---|---|---|
| spr_hero_idle/walk/attack/hurt | 4/8/6/3 | 32×48 | (16, 47) |
| spr_hero_death_strip6 | 6 | 48×48 | (16, 47) |
| spr_bandit_idle/walk/attack/hurt | 4/4/6/4 | 32×48 | (16, 47) |
| spr_bandit_death_strip6 | 6 | 48×48 | (16, 47) |
| spr_fallen_knight_idle/walk/hurt | 8/8/6 | 32×48 | (16, 47) |
| spr_fallen_knight_attack_strip6 | 6 | 64×48 | (32, 47) |
| spr_fallen_knight_death_strip8 | 8 | 48×48 | (16, 47) |

Death strips are 48 wide so the body can fall flat. They fall forward to the right of the origin.
The knight's attack is 64 wide: 16 px of wind-up space behind and 32 px of reach in front.
Use a fixed collision mask, such as the idle frame bbox, so the wider strips don't change hitboxes.

Source generators (`src/*.py`, Python + Pillow) are included because they are small. Run `python3 src/hero.py` (and the other scripts) from this folder to regenerate. `__pycache__` is not committed. The Zone 1 tileset / overworld map is still being built and is not in this folder.

## Overworld (top-down, FF1-style exploration)

Each character has 4 directions, a 1-frame idle and a 4-frame walk loop: step, pass, other step, pass. Play the walk at about 6–8 fps (code uses 8).
Feet sit on the bottom row of every frame. `left` is a hand-mirrored copy of `right`, so you don't need `image_xscale`.

| Set | Folder | Frame | Origin | Tile footprint (16×16 tiles) |
|---|---|---|---|---|
| Kael 32×48 | `hero/overworld/` | 32×48 | (16, 47) | 2 wide × 3 tall |
| Kael 16×24 (FF1 scale, **recommended**) | `hero/overworld/16x24/` | 16×24 | (8, 23) | 1 wide × 1.5 tall |
| Bandit 32×48 | `bandit/overworld/` | 32×48 | (16, 47) | 2 wide × 3 tall |
| Bandit 16×24 (FF1 scale) | `bandit/overworld/16x24/` | 16×24 | (8, 23) | 1 wide × 1.5 tall |

Names: `spr_kael_ow_idle_<dir>.png`, `spr_kael_ow_walk_<dir>_strip4.png`, and the same with `ow16` for the small set. The Bandit uses `spr_bandit_ow...`.
`<dir>` is down, up, left or right.
On a 16 px grid, the 16×24 sprites stand on their tile, and their head overlaps the tile above. Draw them sorted by y (`depth = -y`).
Kael's longsword is sheathed on his hip in the overworld; the Bandit carries his knife low.

There is no Fallen Knight overworld set yet (battle sprites only).

Battle assets are named `spr_hero_*` while overworld Kael assets are named `spr_kael_ow*`. The GML maps `actor_id "kael"` to the hero battle set.

Previews: `*_ow_preview.png` (6×) and `*_ow16_preview.png` (8×). The `*_walk_preview.gif` files animate down, left, right and up side by side. Do not import previews as sprites.
