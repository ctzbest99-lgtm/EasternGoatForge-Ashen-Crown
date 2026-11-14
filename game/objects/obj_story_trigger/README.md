# obj_story_trigger

Walk-on story beat. Default use: `blackguard_arena_enter` in `rm_old_watchtower` (`BG_INTRO`, `flag_bg_intro_seen`).

- Sprite: 16×16 (or stretched over `rect_px`), Top Left, e.g. `spr_story_encounter_placeholder`. Parent: **none**, not solid.
- Events: Create, Other ▸ Room Start, Step.
- Visible follows `DEBUG_SHOW_TRIGGERS`.

Fires `script_id` once when the player steps onto the area (or is already on it when the room starts), then sets `story_flag` and removes itself. If the flag is already set, the instance is destroyed on Room Start.

`GH_ARRIVAL` is played from the map spawner when the player is placed at `player_start`, not from this object.
