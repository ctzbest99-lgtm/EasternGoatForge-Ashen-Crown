/// obj_zone_entrance : Create
/// Door / exit used by scr_map_spawn_markers for "entrance" and "zone_exit" markers.
/// Sprite: any 16×16 (e.g. spr_encounter_trigger_placeholder). No parent, not solid.
/// Visible follows DEBUG_SHOW_TRIGGERS. Rooms that are not built yet show a placeholder line.
target_room = -1;          // set by scr_map_spawn_markers (asset_get_index of the marker's target_room)
target_room_name = "";
target_spawn = "";         // marker name to arrive at in the target room
armed = false;
visible = DEBUG_SHOW_TRIGGERS;
