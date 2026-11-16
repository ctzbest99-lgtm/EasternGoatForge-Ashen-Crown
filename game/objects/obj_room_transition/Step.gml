/// obj_room_transition : Step
/// The fade is driven by delta_time, so it takes the same wall-clock time at any frame rate. The room
/// changes only once the screen is fully black, so the swap is never seen.
timer += delta_time;
fade_alpha = clamp(timer / (ROOM_FADE_MS * 1000), 0, 1);
if (fade_alpha < 1) exit;

var _room = asset_get_index(target_room);
if (_room < 0 || asset_get_type(_room) != asset_room) {
    /// A room that vanished between the request and the fade must not leave the game stuck on a black
    /// screen with input locked: clear the flags and destroy, so the player keeps playing where they are.
    show_debug_message("obj_room_transition: no room named " + string(target_room));
    global.transition_running = false;
    global.entry_pending = false;
    instance_destroy();
    exit;
}

global.transition_running = false;
/// The room change destroys this instance; the entry request stays for the destination to consume.
room_goto(_room);
