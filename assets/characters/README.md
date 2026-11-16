# Character sprites — generated placeholders

Not final art. These sheets exist so movement, combat feedback and the debug overlay can be tested with
something visible. They are produced by code, so silhouettes are blocky and shading is flat.

| File | Size | Frames | Contents |
|---|---|---|---|
| `spr_kael_walk.png` | 128×192 | 16 (4 dirs × 4) | Kael Varyn walk |
| `spr_kael_attack.png` | 96×192 | 12 (4 dirs × 3) | Kael attack: windup, strike, recover |
| `spr_kael_hurt.png` | 32×192 | 4 (4 dirs × 1) | Kael flinch pose, one per direction |
| `spr_bandit_walk.png` | 128×192 | 16 (4 dirs × 4) | Bandit walk |
| `spr_fallen_knight_walk.png` | 128×192 | 16 (4 dirs × 4) | Fallen Knight walk |
| `spr_shadow.png` | 16×4 | 1 | soft ground shadow, draw under any character |
| `preview.png` | 1940×960 | — | 5× contact sheet of the three walk sheets; documentation only, do not import |
| `preview_actions.png` | 524×768 | — | 4× contact sheet of the attack and hurt sheets; documentation only, do not import |

## Frame layout

Rows are always **down, left, right, up**. Columns are the frames of that action:

| Sheet | Columns | Index of frame `f` in row `r` |
|---|---|---|
| walk | 4 | `image_index = r * 4 + f` |
| attack | 3 | `image_index = r * 3 + f` (0 windup, 1 strike, 2 recover) |
| hurt | 1 | `image_index = r` |

There is no separate idle sheet: **walk frame 0 is the idle pose**, as `docs/CHARACTER_MODELS.md` §3
specifies, and the player code parks on it whenever input stops or locks.

The hurt sheet is a deliberate addition to the spec, which called hurt a tint flash with no new art. The
flinch pose reads better in a prototype than a colour flash alone; tint or alpha flash can still be layered
on top of it.

## Regenerate

```sh
python3 tools/generate_character_sprites.py
python3 tools/generate_character_sprites.py --preview /tmp/preview.png   # 5x contact sheet
```

The generator needs only a stock Python 3 (it writes PNGs itself, no Pillow) and verifies every frame
as it writes: bottom row on the ground line, feet inside the 12×6 mask, left/right rows exact mirrors,
and no static cycles. It exits non-zero and lists problems if a change breaks those rules — currently
`checked 64 frames`.

## Import into GameMaker

Per `docs/CHARACTER_MODELS.md` §1 and §4:

- Origin **16, 46** (between the feet, on the ground line).
- Collision mask 12 wide × 6 tall at offset x 10, y 40 — feet only, never the full 32×48.
- Interpolate colours between pixels **off**; sprite FPS **16** for walk, **12** for attack.
- Set `image_speed = 0` on the object and drive `image_index` from code, as `obj_player` already does.

## Provenance

Generated on 2026-11-01 by `tools/generate_character_sprites.py` in this repository. No third-party
art was traced, copied or sampled; treat these files as project placeholders under the same
undecided licence as the rest of the repo (`LICENSE-PLACEHOLDER.md`).
