# Character Models — Model Sheets

Design specification for the top-down character sprites. **No image files exist**; this defines what to draw.
Every value here is a proposal consistent with `ART_DIRECTION.md` (32×48 player reference, four directions,
strong silhouettes). Palette, frame layout and final scale are **not confirmed canon** yet — see
`DECISIONS_AND_OPEN_QUESTIONS.md`.

Assumption: "model" means the 2D sprite model for a top-down pixel-art JRPG, not a 3D mesh.

## 1. Universal rules

- **Canvas:** 32×48 per frame, feet anchored to the bottom. Ground contact at y = 46; row 47 is the shadow only.
- **Origin:** x = 16, y = 46 (between the feet, on the ground line). Every character uses the same origin so
  `place_meeting`, interaction offsets and teleports behave identically.
- **Collision mask:** 12 wide × 6 tall, offset x 10..21, y 40..46 — feet only. Never mask the full 32×48 or the
  player will collide with walls a head-height early. Note the mask is **symmetric about x 15.5** (the canvas
  centre), not about the origin pixel: right-facing frames are mirrored left art, so art placed on a 16-centred
  axis would shift a pixel when flipped and poke outside the mask.
- **Directions:** down (front), left, right, up (back). Author three, mirror left→right, so art cost is 3/4.
- **Draw order:** shadow → cape (only when facing up) → legs → torso → arms → head → held item.
- **No anti-aliasing, no sub-pixel offsets.** Pixels stay on the grid; camera movement does the smoothing.

### Proportion grid (front, y in rows)

| Rows | Body part | Width (x span) |
|---|---|---|
| 0–3 | hair/helmet crest | 12..20 |
| 4–15 | head (12px tall) | 11..21 |
| 16–17 | neck and shoulder line | 10..22 |
| 18–31 | torso (14px) | 10..22, tapering to 11..21 at the waist |
| 32–34 | belt and hips | 10..22 |
| 35–44 | legs | two 4px legs at 11..14 and 18..21 |
| 45–46 | boots | 5px wide each |
| 47 | shadow ellipse | 8..24 |

Head is 12px of 48 → a 1:3.5 head-to-body ratio. That is deliberately chibi-heroic: at 32×48 a realistic
1:7.5 figure would be an unreadable smudge, and 1987-era JRPG readability needs a large head.

**Side views** narrow the torso by 2px (x 12..20), the head by 2px, and place the single visible arm forward.
**Back view** drops the face and shows the cape/hood mass, hair colour only.

## 2. Palettes

Five-step ramps per material: outline → dark → base → light → highlight. No pure black outlines (they read as
holes on dark maps); the outline colour is a warm near-black. Cap each character at 16 colours.

### Kael Varyn — worn traveller, one pauldron, ash-blond
| Role | Dark | Base | Light |
|---|---|---|---|
| Outline | `#100E0E` | | |
| Skin | `#9C7350` | `#C79A72` | `#E3BC94` |
| Hair | `#5F523D` | `#8A7A5C` | `#B7A87F` |
| Cloak | `#1E272C` | `#2E3B42` | `#465961` |
| Leather | `#482C1D` | `#6B4630` | `#8C603F` |
| Steel (pauldron, blade) | `#545A62` | `#8C9096` | `#C3C8CE` |
| Accent (scarf) | `#5E1C1C` | `#8E2F2F` | `#B14A44` |

Kael is the lightest figure on screen (cape mid-value, steel highlights) so the eye finds him first.

### Bandit — ragged, low-tier, masked
| Role | Dark | Base | Light |
|---|---|---|---|
| Skin | `#8E6446` | `#B98862` | `#D6A97F` |
| Hood/rags | `#3B3529` | `#5A5140` | `#7A7159` |
| Tunic | `#3A4229` | `#55603C` | `#74805A` |
| Leather belt | `#2F2418` | `#4C3A2A` | `#6B5138` |
| Cheap steel | `#5E6469` | `#9AA0A6` | `#C6CBD0` |
| Bandana (threat read) | `#511A1A` | `#7E2A2A` | `#A33B34` |

### Fallen Knight — rusted plate, hollow
| Role | Dark | Base | Light |
|---|---|---|---|
| Plate | `#343A44` | `#5C636E` | `#9AA3AF` |
| Rust | `#52301B` | `#7A4A2C` | `#9E6A42` |
| Tabard | `#48201F` | `#6E2A2E` | `#8C3A38` |
| Tarnished trim | `#6B5220` | `#9C7A3A` | `#C4A05C` |
| Helm void | `#141A1A` | | glow `#A8C8C0` |

The Fallen Knight is the darkest and widest silhouette (17–19px shoulders vs Bandit's 13), so the pair reads
apart instantly even in monochrome.

## 3. Animation sets

Walk is a four-frame cycle: contact → pass → contact (opposite foot) → pass. Idle is frame 0 with
`image_speed = 0`. Authored per direction, so walk = 12 frames (3 directions × 4), 16 with the mirrored right.

Timing: a full cycle should cover ~30px of travel, which at `move_speed = 2` and 60fps (120px/s) means
0.25s per cycle → **sprite FPS 16, `image_speed = 1`**. Retune if `move_speed` changes; formula is
`cycle_seconds = 4 / (sprite_fps * image_speed)`.

| Action | Frames | FPS | Notes |
|---|---|---|---|
| idle | 1 (or 2 for breathing) | — | frame 0, `image_speed = 0` |
| walk | 4 per direction | 16 | frame 0 reused as idle |
| attack | 3 | 12 | windup, strike, recover; strike holds 1 extra frame |
| hurt | 1 | — | flash white/tint, no new art |
| death | 4 | 8 | collapse, last frame holds |

Attack/hurt/death are down-and-side only for the vertical slice; up-facing reuses the down pose flipped.

## 4. Sprite assets and GameMaker settings

| Sprite | Size | Frames | Notes |
|---|---|---|---|
| `spr_kael_walk` | 32×48 | 16 (4 dirs × 4) | rows: down 0–3, left 4–7, right 8–11, up 12–15 |
| `spr_kael_attack` | 32×48 | 12 | 3 frames × 4 dirs (windup, strike, recover); idle is walk frame 0, so no separate idle sprite |
| `spr_kael_hurt` | 32×48 | 4 | one flinch pose per direction at 4 fps or held; tint flash can still be layered |
| `spr_bandit_walk` | 32×48 | 16 | same layout |
| `spr_fallen_knight_walk` | 32×48 | 16 | heavier cadence: 14 fps reads slower |
| `spr_shadow` | 16×4 | 1 | drawn under every character |

Import settings: **Interpolate colours between pixels off**, origin 16/46, collision mask as in §1, one texture
page per character for now, `image_speed = 1` by default with movement code owning playback.

Direction → frame row in GML: `image_index = dir_row * 4 + walk_frame`, where `dir_row` is 0 down, 1 left,
2 right, 3 up. Derive `dir_row` from the normalised facing vector, not from raw key input.

Implemented in `game/scripts/scr_player_animation.gml`: `scr_walk_dir_row` maps facing to a row,
`scr_walk_frame_from_clock` derives the frame, and `scr_update_walk_animation(inst, moving)` owns
`image_index`. `obj_player` sets `image_speed = 0` so the sprite's own playback cannot fight it.

Actions use the same file: `scr_action_start(inst, PLAYER_ACTION.ATTACK | HURT)` swaps to the action
sheet and locks movement, `scr_action_update` advances it (the strike holds two frame-times), and
`scr_action_end` restores the walk sheet on its idle frame so control resumes where it left off. A
missing attack or hurt sheet makes the action refuse to start, so an unimported sprite cannot freeze
the player.

## 5. Attach points (front view, for equipment and effects)

| Point | Position | Use |
|---|---|---|
| weapon_hand | (24, 26) | sword hilt; swaps per equipped weapon |
| off_hand | (8, 26) | shield/torch |
| head | (16, 4) | status icons, helmet overlay |
| feet | (16, 46) | dust puffs, shadow origin |
| overhead | (16, 0) | damage numbers, "!" alert |

Equipment overlays are separate 16×16 sprites drawn at these points, so one body sprite serves every gear set.

## 6. Coordinate guide (build it, do not draw it)

The "Kael 32×48 template and coordinate guide" in `ASSET_INVENTORY.md` is a working file, not art: a 32×48
canvas with 1px grid, a horizontal line at every row in the §1 table (0, 4, 16, 18, 32, 35, 45, 47), the
origin marked at (16,46), the 12×6 mask rectangle drawn at 10,40, and numbered X/Y rulers. Author every sprite
over that template so proportions never drift between characters.

## 7. Open questions this does not settle

- Room resolution and tile size are undecided, so whether 32×48 is final on-screen scale is unknown.
- Battle art scale: JRPGs usually show enemies larger in battle (64×64 or 96×96). That is a separate model set.
- Kael's cape adds 12 frames if it animates; cloak currently reads as a static silhouette.
- Party members beyond Kael are unnamed, so only three models are specified.
- Portrait/menu faces for the status and Bestiary screens are not covered here.

## 8. Placeholder sheets built from this spec

`assets/characters/` holds generated placeholders so movement and combat feedback can be tested before a
pixel artist is involved: `spr_kael_walk.png` (128×192), `spr_kael_attack.png` (96×192, three frames per
direction), `spr_kael_hurt.png` (32×192, one flinch pose per direction), `spr_bandit_walk.png` and
`spr_fallen_knight_walk.png` (128×192 each) plus `spr_shadow.png` (16×4). Rebuild them with
`python3 tools/generate_character_sprites.py`, which self-checks frame bounds, foot-mask containment,
left/right mirror equality and pose variation, and fails loudly if a change violates them (64 frames).

Two deviations from §3 are intentional: hurt is drawn as a flinch pose rather than a pure tint flash, and
there is no idle sheet because walk frame 0 already serves as the idle pose.

One deviation from §1 worth knowing when drawing the real thing: front and back boots sit at x 11..14 and
17..20 rather than 18..21, so the boot outline stays inside the mask after the right-facing mirror. The
side view's leading foot lifts instead of stepping forward for the same reason.
