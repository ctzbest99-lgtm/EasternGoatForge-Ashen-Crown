# Asset Inventory

Character sprites were added on 2026-11-14 under `game/sprites/`. Import settings (asset name, frames, origin, mask, fps) are in `game/sprites/IMPORT.md`. These have not been compiled or playtested in GameMaker yet. All assets are the property of Eastern Goat Forge (see LICENSE).

| Asset | Status | Notes |
|---|---|---|
| Kael overworld 16×24 (`spr_kael_ow16_*`) | In repo, recommended | 16×24, origin (8, 23), 1-frame idle and 4-frame walk per direction. Wired to `obj_player`. |
| Kael overworld 32×48 (`spr_kael_ow_*`) | In repo, fallback only | 32×48, origin (16, 47). Code uses this only if the 16×24 set is missing. |
| Kael battle (`spr_hero_*`) | In repo | Idle 4 / walk 8 / attack 6 / hurt 3 / death 6. Death is 48×48, origin (16, 47); others 32×48, origin (16, 47). Wired in `obj_battle_controller`. Naming differs from overworld (`spr_hero_*` vs `spr_kael_ow*`). |
| Bandit overworld 16×24 and 32×48 (`spr_bandit_ow16_*`, `spr_bandit_ow_*`) | In repo, not wired | Same layout as Kael. No overworld Bandit object yet. |
| Bandit battle (`spr_bandit_*`) | In repo | Idle 4 / walk 4 / attack 6 / hurt 4 / death 6. Death 48×48. Wired in battle. |
| Fallen Knight battle (`spr_fallen_knight_*`) | In repo | Idle 8 / walk 8 / attack 6 / hurt 6 / death 8. Attack is 64×48, origin (32, 47); death 48×48. No overworld set. |
| Rare encounter sprite | Planned | Concept not finalized |
| Zone 1 boss sprite | Planned | Concept not finalized |
| Zone 1 tileset (`ts_zone1.png`) | Being built, not in repo | Delivered alongside a large overworld map under `/workspace/zone1/`; may still change. Not imported in the sprites PR. |
| UI panels/cursor | Planned | Readable at target resolution |
| Music, SFX, font | Planned | Verify rights/licenses |
| Source generators | In repo (`game/sprites/src/*.py`) | Python + Pillow. Included because they are small. Do not import as game assets. |

For each added asset, record filename, dimensions, creator/source, license, import settings, and test status.

**Known art gaps:** no Fallen Knight overworld sheet; no Guard battle pose; no left-facing battle strips (party is flipped with `image_xscale`); Kael's hurt clip is only 3 frames (Bandit 4, Fallen Knight 6); battle vs overworld naming mismatch (`spr_hero_*` / `spr_kael_ow*`).
