/// scr_rooms — room changes, arrival markers and the safe room. The rules live here so the transition
/// object stays a fade plus a `room_goto`, and so a missing room or marker can be reported instead of
/// leaving the player in a room with no way to move.

#macro ROOM_FADE_MS 300

/// @desc True when a room asset with this name exists in the project. asset_get_index returns -1 for a
/// name that is not in the project, which is the case this guards: a save or a door naming a room the
/// project does not have must fail loudly rather than silently do nothing.
function scr_room_exists(_name) {
    if (!is_string(_name) || _name == "") return false;
    var _index = asset_get_index(_name);
    if (_index < 0) return false;
    return (asset_get_type(_index) == asset_room);
}

/// @desc Is a fade already running? A second request while one is in flight would fight over the
/// destination, so it is refused rather than queued.
function scr_room_transition_pending() {
    return (variable_global_exists("transition_running") && global.transition_running == true);
}

/// @desc Request a room change, arriving at _marker_id or at exact coordinates when given. Returns false
/// and changes nothing for an unknown room, a fade already running, or a missing transition object.
function scr_room_transition_request(_room_name, _marker_id = "", _x = undefined, _y = undefined) {
    if (!scr_room_exists(_room_name)) {
        show_debug_message("scr_room_transition_request: no room named " + string(_room_name));
        return false;
    }
    if (scr_room_transition_pending()) return false;
    var _obj = asset_get_index("obj_room_transition");
    if (_obj < 0) {
        show_debug_message("scr_room_transition_request: obj_room_transition is not in this project");
        return false;
    }
    global.entry_room = _room_name;
    global.entry_marker = _marker_id;
    global.entry_has_position = (!is_undefined(_x) && !is_undefined(_y));
    if (global.entry_has_position) {
        global.entry_x = _x;
        global.entry_y = _y;
    }
    global.entry_pending = true;
    global.transition_running = true;
    instance_create_depth(0, 0, -1000, _obj);
    return true;
}

/// @desc The arrival this room should apply, or undefined when none is pending. Taking it clears the
/// request, so the position is applied exactly once and a later room entry cannot teleport the player
/// back to an old marker.
function scr_room_entry_take() {
    if (!variable_global_exists("entry_pending") || global.entry_pending != true) return undefined;
    global.entry_pending = false;
    return {
        marker: global.entry_marker,
        has_position: global.entry_has_position,
        x: global.entry_x,
        y: global.entry_y
    };
}

/// @desc The marker with this id from a list of { marker_id, x, y } structs, or undefined.
function scr_room_marker_find(_markers, _marker_id) {
    if (_marker_id == "") return undefined;
    var _count = array_length(_markers);
    for (var _i = 0; _i < _count; _i++) {
        if (_markers[_i].marker_id == _marker_id) return _markers[_i];
    }
    return undefined;
}

/// @desc Remember where a defeat should send the party back to. Refuses a room that does not exist, so a
/// typo cannot cost the player their recovery point.
function scr_room_safe_remember(_room_name, _marker_id = "") {
    if (!scr_room_exists(_room_name)) return false;
    global.safe_room = _room_name;
    global.safe_marker = _marker_id;
    return true;
}

/// @desc The remembered safe room as { room, marker }, or undefined when none has been set.
function scr_room_safe() {
    if (!variable_global_exists("safe_room") || global.safe_room == "") return undefined;
    return { room: global.safe_room, marker: global.safe_marker };
}
