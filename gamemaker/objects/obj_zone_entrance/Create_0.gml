/// obj_zone_entrance : Create
/// Door / exit / stairs used by scr_map_spawn_markers for "entrance" and "zone_exit".
/// Sprite: any 16×16 (e.g. spr_encounter_trigger_placeholder). No parent, not solid.
/// Visible follows DEBUG_SHOW_TRIGGERS. Rooms that are not built yet show a placeholder line.
/// Honours map_marker.requires_flag / requires_item / requires, and sets_flag on a successful use.
target_room = -1;
target_room_name = "";
target_spawn = "";
sets_flag = "";
map_marker = undefined;
armed = false;
visible = DEBUG_SHOW_TRIGGERS;
