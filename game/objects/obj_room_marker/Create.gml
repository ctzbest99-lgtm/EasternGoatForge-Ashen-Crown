/// obj_room_marker : Create
/// A named arrival point. Place these in rooms and give each a unique marker_id in the instance's creation
/// code; obj_room_entry looks one up when the player arrives. Invisible: the id is the whole point.
if (!variable_instance_exists(id, "marker_id")) marker_id = "";
sprite_index = -1;
depth = -1;
