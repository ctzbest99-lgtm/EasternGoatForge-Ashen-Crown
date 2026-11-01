/// scr_debug_commands — debug-only helpers used by obj_debug_menu.
/// Delete this script and obj_debug_menu before shipping. Requires GameMaker 2.3+.

/// @desc Parse "x,y" (spaces allowed) into { x, y }, or undefined if the text is not a coordinate pair.
function scr_debug_parse_coord(_text) {
    var _s = string_replace_all(_text, " ", "");
    var _comma = string_pos(",", _s);
    if (_comma <= 1) return undefined;
    var _sx = string_copy(_s, 1, _comma - 1);
    var _sy = string_copy(_s, _comma + 1, string_length(_s) - _comma);
    if (!scr_debug_is_integer_text(_sx) || !scr_debug_is_integer_text(_sy)) return undefined;
    return { x: real(_sx), y: real(_sy) };
}

/// @desc True when _s is a non-empty whole number, optionally negative.
function scr_debug_is_integer_text(_s) {
    var _len = string_length(_s);
    if (_len == 0) return false;
    var _start = 1;
    if (string_char_at(_s, 1) == "-") {
        if (_len == 1) return false;
        _start = 2;
    }
    for (var _i = _start; _i <= _len; _i++) {
        if (string_pos(string_char_at(_s, _i), "0123456789") == 0) return false;
    }
    return true;
}

/// @desc Move the first obj_player to (_x, _y). Returns a status line for the overlay.
/// Teleporting into a solid is safe: obj_player's Step lets an overlapping player walk free.
function scr_debug_teleport_player(_x, _y) {
    var _obj = asset_get_index("obj_player");
    if (_obj < 0) return "obj_player is not in this project";
    if (instance_number(_obj) == 0) return "no obj_player instance in the room";
    var _player = instance_find(_obj, 0);
    _player.x = _x;
    _player.y = _y;
    return "player -> " + string(_x) + "," + string(_y);
}

/// @desc Spawn one enemy of _enemy_id at (_x, _y). Returns a status line for the overlay.
function scr_debug_spawn_enemy(_enemy_id, _x, _y) {
    var _data = scr_get_enemy_data(_enemy_id);
    if (is_undefined(_data)) return "unknown enemy id: " + string(_enemy_id);
    var _obj = asset_get_index("obj_enemy");
    if (_obj < 0) return "obj_enemy is not in this project — create it to spawn enemies";
    var _inst = instance_create_depth(_x, _y, 0, _obj);
    /// obj_enemy's Create runs before this line, so seed the fields combat reads directly.
    _inst.enemy_id = _enemy_id;
    _inst.enemy_data = _data;
    _inst.max_hp = _data.max_hp;
    _inst.hp = _data.max_hp;
    _inst.attack = _data.attack;
    _inst.defense = _data.defense;
    return "spawned " + _data.name + " at " + string(_x) + "," + string(_y);
}

/// @desc Spawn _enemy_id just ahead of the player, or at the room centre if there is no player.
function scr_debug_spawn_enemy_near_player(_enemy_id) {
    var _px = room_width * 0.5;
    var _py = room_height * 0.5;
    var _fx = 0;
    var _fy = 1;
    var _obj = asset_get_index("obj_player");
    if (_obj >= 0 && instance_number(_obj) > 0) {
        var _p = instance_find(_obj, 0);
        _px = _p.x;
        _py = _p.y;
        _fx = _p.facing_x;
        _fy = _p.facing_y;
    }
    return scr_debug_spawn_enemy(_enemy_id, _px + _fx * 48, _py + _fy * 48);
}
