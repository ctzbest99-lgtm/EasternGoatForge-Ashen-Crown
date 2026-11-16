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
    /// Room-change and recovery state. Every field is created here so a fresh launch, a load and a room
    /// entry all read the same globals instead of hoping an object ran first.
    if (!variable_global_exists("entry_room")) global.entry_room = "";
    if (!variable_global_exists("entry_marker")) global.entry_marker = "";
    if (!variable_global_exists("entry_has_position")) global.entry_has_position = false;
    if (!variable_global_exists("entry_x")) global.entry_x = 0;
    if (!variable_global_exists("entry_y")) global.entry_y = 0;
    if (!variable_global_exists("entry_pending")) global.entry_pending = false;
    if (!variable_global_exists("transition_running")) global.transition_running = false;
    if (!variable_global_exists("safe_room")) global.safe_room = "";
    if (!variable_global_exists("safe_marker")) global.safe_marker = "";
    if (!variable_global_exists("shop_open")) global.shop_open = false;
    if (!variable_global_exists("saved_room")) global.saved_room = "";
    if (!variable_global_exists("saved_player")) global.saved_player = undefined;
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
    if (global.load_message == "loaded") {
        /// A save made before quest payouts existed can hold a finished quest with nothing collected yet;
        /// the paid flag makes this a no-op for saves that already have their reward.
        scr_quest_pay_out(scr_flags_ensure_global(), scr_party_ensure_global());
        scr_game_restore_room();
    }
    return global.load_message;
}

/// @desc Return to the room the save was made in, when it is not this one. The saved coordinates travel
/// with the request so a save made away from any marker is still honoured; a save from before rooms were
/// recorded simply loads in place.
function scr_game_restore_room() {
    var _saved = "";
    if (variable_global_exists("saved_room")) _saved = global.saved_room;
    if (_saved == "" || _saved == room_get_name(room)) return false;
    var _pos = undefined;
    if (variable_global_exists("saved_player")) _pos = global.saved_player;
    if (is_undefined(_pos) || _pos == undefined) return scr_room_transition_request(_saved, "");
    return scr_room_transition_request(_saved, "", _pos.x, _pos.y);
}

/// @desc After a defeat, revive everyone who fell to 1 HP — and only those, so a member who was standing
/// keeps their HP — then send the party back to the last safe room when one is known. Reviving only the
/// lead would leave the rest permanently downed, which is a slow softlock with no revive item yet.
/// Returns true when a room change was requested.
function scr_game_defeat_recovery() {
    var _party = scr_party_ensure_global();
    var _count = array_length(_party.members);
    for (var _i = 0; _i < _count; _i++) {
        if (_party.members[_i].hp <= 0) _party.members[_i].hp = 1;
    }
    var _safe = scr_room_safe();
    if (is_undefined(_safe)) return false;
    return scr_room_transition_request(_safe.room, _safe.marker);
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
    global.last_save_message = scr_save_game(_target, room_get_name(room));
    global.autosave_reason = "";
    return global.last_save_message == "saved";
}
