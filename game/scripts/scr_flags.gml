/// scr_flags — story flags: the set of named events that have happened. A list of strings rather than a
/// struct, so it serializes trivially, validates as plain data, and cannot carry a stale value.
/// Flags are set by dialogue that reaches its natural end (see scr_dialogue_confirm), never by ESC.

/// @desc An empty flag list.
function scr_flags_create() {
    return [];
}

/// @desc True when _name has been set. An empty name is never set.
function scr_flags_has(_flags, _name) {
    if (_name == "") return false;
    var _count = array_length(_flags);
    for (var _i = 0; _i < _count; _i++) {
        if (_flags[_i] == _name) return true;
    }
    return false;
}

/// @desc Set a flag. Setting one twice changes nothing, so re-reading dialogue cannot double-apply.
function scr_flags_set(_flags, _name) {
    if (_name == "") return false;
    if (scr_flags_has(_flags, _name)) return true;
    array_push(_flags, _name);
    return true;
}

/// @desc Remove a flag, for debug commands and future quest resets.
function scr_flags_clear(_flags, _name) {
    var _count = array_length(_flags);
    for (var _i = 0; _i < _count; _i++) {
        if (_flags[_i] == _name) {
            array_delete(_flags, _i, 1);
            return true;
        }
    }
    return false;
}

/// @desc A copy, so saved data can never alias the live flag list.
function scr_flags_copy(_flags) {
    var _copy = [];
    var _count = array_length(_flags);
    for (var _i = 0; _i < _count; _i++) array_push(_copy, _flags[_i]);
    return _copy;
}

/// @desc The game's flag list, created on first use.
function scr_flags_ensure_global() {
    if (!variable_global_exists("flags") || global.flags == undefined) global.flags = scr_flags_create();
    return global.flags;
}
