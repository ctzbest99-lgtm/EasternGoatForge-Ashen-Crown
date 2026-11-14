/// obj_game_controller : Room Start   (Other > Room Start)
/// After a battle, put the player back where the encounter began and release the input lock.
if (room == BATTLE_ROOM) exit;

var _g = global.game;
if (_g.transition_active) {
    var _rp = _g.return_point;
    if (is_struct(_rp) && _rp.room_id == room && instance_exists(obj_player)) {
        with (obj_player) {
            x = _rp.px;
            y = _rp.py;
            facing_x = _rp.facing_x;
            facing_y = _rp.facing_y;
        }
    }
    _g.return_point = undefined;
    _g.transition_active = false;
    scr_input_block(1);
}
