/// obj_ruin_door : Create
/// The way into the ruin. While the Hermit has not checked the quest off the door only speaks; once he
/// has, it fades into Zone 1 and puts the player on its entry marker.
if (!variable_instance_exists(id, "talk_range")) talk_range = 56;
/// The room and marker to arrive at, overridable per instance so the object is not hard-wired to one map.
if (!variable_instance_exists(id, "door_room")) door_room = RUIN_ROOM;
if (!variable_instance_exists(id, "door_marker")) door_marker = RUIN_ENTRY_MARKER;
sprite_index = -1;
/// Behind the player, so the player is never hidden under the door.
depth = 1;
