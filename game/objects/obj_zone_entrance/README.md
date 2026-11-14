# obj_zone_entrance

Walk-on entrance or exit created by `scr_map_spawn_markers` from map markers of type `entrance` or `zone_exit`.

- Sprite: any 16×16 (for example `spr_encounter_trigger_placeholder`), Top Left origin. The spawner scales it to the marker's `w`×`h` tiles.
- Parent: none. Do **not** parent to `obj_solid`.
- Events: Create, Step.
- Visible follows `DEBUG_SHOW_TRIGGERS`.

If `target_room` is not a real room asset (`asset_get_index` is -1), stepping on the door opens a placeholder dialogue: `[rm_name is not built yet.]`. Built links (`rm_old_watchtower` ↔ `rm_overworld`) set `global.map_spawn_name` and `room_goto`. The map builder then places the player on that named marker. After a battle, `obj_game_controller` Room Start still restores the saved overworld position.

Stub rooms (Valemere, the Frostwilds settlement, the coastal village, the basement, the Crownveil breach, and the rest) stay placeholders until those rooms exist.
