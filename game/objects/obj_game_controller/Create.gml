/// obj_game_controller : Create
/// Owns the session: one startup load per launch, and the autosaves other systems request.
/// Add exactly one instance to the first room; the load only happens once per launch regardless.
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

scr_game_ensure_globals();
/// The load is deferred to Step: Create order between objects is not guaranteed, and restoring a
/// position needs a player instance to restore it into.
pending_load = scr_game_begin_session();
load_message = "";
