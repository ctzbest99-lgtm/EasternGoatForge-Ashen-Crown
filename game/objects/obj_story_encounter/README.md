# obj_story_encounter

Scripted story fight trigger. Default instance is the guaranteed first Ashbound Hunter fight in the Old Watchtower (`enc_ashbound_hunter_wt`).

- Sprite: `spr_story_encounter_placeholder` (32×32, Top Left origin, semi-transparent purple). A sprite is required so the collision mask matches the tile.
- Parent: none. Do **not** parent to `obj_solid`.
- Events: Create, Other ▸ Room Start, Step.
- Visible follows `DEBUG_SHOW_TRIGGERS`.

## Watchtower placement
Place **one** instance on a set tile in the Watchtower **before the banner room** (Design picks the tile; CHAPTER1_SCRIPT.md §6). Until `rm_watchtower` exists, a copy may be placed in `rm_overworld` for testing.

Default `encounter_id` is `enc_ashbound_hunter_wt`. Do not change it for the guaranteed fight: a victory records that id in `cleared_encounters` and the instance is removed. A defeat does **not** clear it.

## Flow
1. Pre-fight: `ENC_AH_01` (NARRATION) then `ENC_AH_02` (Kael).
2. Battle: 1× Ashbound Hunter.
3. First victory: add `item_ashbound_parchment`, set `flag_parchment_found`, play `ENC_AH_03`–`ENC_AH_05`.
4. If `flag_parchment_found` is already set (rare random fight earlier), the battle still happens once, but steps 3's pickup and post-fight lines are skipped.
