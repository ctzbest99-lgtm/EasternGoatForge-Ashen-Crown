/// scr_game — session policy for obj_game_controller: one load per launch, and autosaves that other
/// systems request. Keeping the decisions in functions means battle code can ask for an autosave without
/// knowing whether a controller exists, and every rule here can be tested without the object.

/// @desc Create any global the game expects, without clobbering values that already exist.
function scr_game_ensure_globals() {
    scr_party_ensure_global();
    scr_flags_ensure_global();
    if (!variable_global_exists("battle_active")) global.battle_active = false;
    if (!variable_global_exists("autosave_reason")) global.autosave_reason = "";
    if (!variable_global_exists("last_save_message")) global.last_save_message = "";
    if (!variable_global_exists("session_started")) global.session_started = false;
    if (!variable_global_exists("load_message")) global.load_message = "";
    return true;
}

/// @desc The first player instance, or noone when the room does not have one yet.
function scr_game_find_player() {
    var _obj = asset_get_index("obj_player");
    if (_obj < 0 || instance_number(_obj) == 0) return noone;
    return instance_find(_obj, 0);
}

/// @desc True the first time it is called in a launch, which is when the startup load should happen.
/// Later rooms must not load again, or walking through a door would rewind progress and position.
function scr_game_begin_session() {
    scr_game_ensure_globals();
    if (global.session_started) return false;
    global.session_started = true;
    return true;
}

/// @desc Load the save into the world and record the result. Returns the status line.
function scr_game_load_into(_player = noone) {
    global.load_message = scr_save_load(_player);
    /// A save made before quest payouts existed can hold a finished quest with nothing collected yet;
    /// the paid flag makes this a no-op for saves that already have their reward.
    if (global.load_message == "loaded") scr_quest_pay_out(scr_flags_ensure_global(), scr_party_ensure_global());
    return global.load_message;
}

/// @desc Ask for an autosave. Repeated requests collapse into one, so a busy frame cannot cause a
/// write per event; nothing is written until scr_game_process_autosave runs.
function scr_game_request_autosave(_reason) {
    scr_game_ensure_globals();
    if (global.autosave_reason != "") return false;
    global.autosave_reason = _reason;
    return true;
}

/// @desc Perform a pending autosave. Returns true when it actually wrote a file.
/// A battle holds the request: rewards land first, and a save taken mid-fight would store a
/// half-resolved battle.
function scr_game_process_autosave(_player = noone) {
    scr_game_ensure_globals();
    if (global.autosave_reason == "") return false;
    if (global.battle_active) return false;
    var _target = _player;
    if (_target == noone) _target = scr_game_find_player();
    global.last_save_message = scr_save_game(_target);
    global.autosave_reason = "";
    return global.last_save_message == "saved";
}
