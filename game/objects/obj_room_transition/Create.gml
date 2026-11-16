/// obj_room_transition : Create
/// Created by scr_room_transition_request, never placed by hand. It fades, then changes the room, then
/// the destination's obj_room_entry places the player.
if (instance_number(object_index) > 1) {
    /// One fade at a time; the second would own the same black screen.
    instance_destroy();
    exit;
}
timer = 0;
fade_alpha = 0;
target_room = "";
if (variable_global_exists("entry_room")) target_room = global.entry_room;
