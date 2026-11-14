/// obj_game_controller : Room Start   (Other > Room Start)
/// After a battle: victory/error restore the pre-battle position; defeat places
/// the player at the town respawn point and opens a short wake-up dialogue.
if (room == BATTLE_ROOM) exit;

var _g = global.game;
if (_g.transition_active) {
    if (_g.last_battle_result == "defeat") {
        scr_apply_town_respawn();
        scr_town_wake_up_dialogue();
    } else {
        var _rp = _g.return_point;
        if (is_struct(_rp) && _rp.room_id == room && instance_exists(obj_player)) {
            with (obj_player) {
                x = _rp.px;
                y = _rp.py;
                facing_x = _rp.facing_x;
                facing_y = _rp.facing_y;
            }
        }
    }
    _g.return_point = undefined;
    _g.transition_active = false;
    scr_input_block(1);
}

// Grace period + new steps-until counter after room entry and after returning from battle.
scr_random_encounter_on_room_start();
