# obj_story_npc

Non-hostile story character that talks through a Chapter 1 script id, then removes itself.

- Sprite: `spr_story_npc_placeholder` (16×16 or 16×24, Top Left or Bottom Centre). If it is missing, assign `spr_interactable_placeholder`. There is no Fallen Knight overworld sheet yet.
- Parent: **none**. Do **not** parent to `obj_solid`. The player must be able to walk onto the tile.
- Events: Create, Other ▸ Room Start, Step.
- Visible: yes (unlike `obj_story_encounter`).

`scr_map_spawn_markers` spawns these from `story_npc` markers and skips them when `story_flag` is already set:

- `fallen_knight_story_1` at overworld (173, 136), script `FK_01`, flag `flag_fk_seen_1` (bandit-camp north exit).
- `fallen_knight_story_2` at Watchtower (20, 29), script `FK_02`, flag `flag_fk_seen_2` (top of the basement stairs).

The knight's "walks off into the trees / descends the stairs" staging is a placeholder: the instance is destroyed when the scene ends. Do not also hand-place a second instance on those tiles.
