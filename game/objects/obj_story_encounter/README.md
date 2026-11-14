# obj_story_encounter

Scripted story fight trigger. Default instance is the guaranteed first Ashbound Hunter fight in the Old Watchtower (`enc_ashbound_hunter_wt`).

- Sprite: `spr_story_encounter_placeholder` (16×16 preferred to match the Zone 1 grid; Top Left origin, semi-transparent purple). A sprite is required so the collision mask matches the tile. If the sprite is larger (e.g. the original 32×32), the map spawner scales it to one 16×16 tile.
- Parent: none. Do **not** parent to `obj_solid`.
- Events: Create, Other ▸ Room Start, Step.
- Visible follows `DEBUG_SHOW_TRIGGERS`.

## Watchtower placement
`scr_build_old_watchtower` places **one** instance on walkable tile **(41, 23)** in `rm_old_watchtower`, two tiles north of `old_royal_banner` (41, 25). The banner is scaled to a single 16×16 tile so it cannot cover the trigger (a static review found a 32×32 placeholder would sit on (41, 24)). Tile (41, 24) stays walkable between the trigger and the banner. Do not also hand-place a second trigger on that tile.

Default `encounter_id` is `enc_ashbound_hunter_wt`. Do not change it for the guaranteed fight: a victory records that id in `cleared_encounters` and the instance is removed. A defeat does **not** clear it.

## Flow
1. Pre-fight: `ENC_AH_01` (NARRATION) then `ENC_AH_02` (Kael).
2. Battle: 1× Ashbound Hunter.
3. First victory: add `item_ashbound_parchment`, set `flag_parchment_found`, play `ENC_AH_03`–`ENC_AH_05`.
4. If `flag_parchment_found` is already set (rare random fight earlier), the battle still happens once, but steps 3's pickup and post-fight lines are skipped.
