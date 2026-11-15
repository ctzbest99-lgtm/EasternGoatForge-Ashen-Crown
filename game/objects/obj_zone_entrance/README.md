# obj_zone_entrance

Walk-on entrance or exit created by `scr_map_spawn_markers` from map markers of type `entrance` or `zone_exit`.

- Sprite: any 16×16 (for example `spr_encounter_trigger_placeholder`), Top Left origin. The spawner scales it to the marker's `w`×`h` tiles.
- Parent: none. Do **not** parent to `obj_solid`.
- Events: Create, Step.
- Visible follows `DEBUG_SHOW_TRIGGERS`.

If `target_room` is not a real room asset (`asset_get_index` is -1), stepping on the door opens a placeholder dialogue: `[rm_name is not built yet.]`. Built links (`rm_old_watchtower` ↔ `rm_overworld`) set `global.map_spawn_name` and `room_goto`. The map builder then places the player on that named marker. After a battle, `obj_game_controller` Room Start still restores the saved overworld position.

Honours `map_marker.requires_flag` / `requires_item` / `requires` (shows locked text and does not change rooms) and `sets_flag` on a successful use. Built links include the five Greyhaven interiors, `rm_old_watchtower`, `rm_watchtower_basement`, `rm_valemere`, and the Chapter 2–3 rooms and roads. Stub rooms (Rimehold, Saltreach, the Blackwood doors, the Drowned Coast ruins, the Crownveil breach, and the rest) still show `[rm_… is not built yet.]`.
