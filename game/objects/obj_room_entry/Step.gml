/// obj_room_entry : Step
/// Placing a player who has not been created yet would fail, so this waits a step rather than acting in
/// Create, where instance order between objects is not guaranteed.
if (applied) exit;
applied = true;

var _entry = scr_room_entry_take();
if (is_undefined(_entry) || _entry == undefined) exit;

var _player_obj = asset_get_index("obj_player");
if (_player_obj < 0 || instance_number(_player_obj) == 0) {
    show_debug_message("obj_room_entry: no player in this room to place");
    exit;
}
var _player = instance_find(_player_obj, 0);

/// A named marker wins; exact coordinates are the fallback for a load saved away from any marker.
var _markers = [];
var _marker_obj = asset_get_index("obj_room_marker");
if (_marker_obj >= 0) {
    var _count = instance_number(_marker_obj);
    for (var _i = 0; _i < _count; _i++) {
        var _m = instance_find(_marker_obj, _i);
        array_push(_markers, { marker_id: _m.marker_id, x: _m.x, y: _m.y });
    }
}

var _target = scr_room_marker_find(_markers, _entry.marker);
if (is_undefined(_target) && _entry.has_position) _target = { x: _entry.x, y: _entry.y };

if (is_undefined(_target)) {
    /// A missing marker must not strand the player: the room's own placement stands, because dropping
    /// them at 0,0 would be worse. No marker asked for (a defeat sending the party back to the room
    /// they left) is a normal arrival, so only an actual miss is logged.
    if (_entry.marker != "") show_debug_message("obj_room_entry: no marker " + string(_entry.marker) + " in " + room_get_name(room));
    exit;
}
_player.x = _target.x;
_player.y = _target.y;
