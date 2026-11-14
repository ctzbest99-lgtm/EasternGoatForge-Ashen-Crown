/// obj_game_controller : Room Start   (Other > Room Start)
/// After a battle: victory/error restore the pre-battle position; defeat places
/// the player at the town respawn point and opens a short wake-up dialogue.
if (room == BATTLE_ROOM) exit;
// rm_title has no player; skip return-from-battle placement.
if (room == TITLE_ROOM) exit;

var _g = global.game;

// A loaded save restores the player after the room builder has run (which may
// have placed them at a default spawn).
if (variable_struct_exists(_g, "pending_load") && is_struct(_g.pending_load)) {
    var _pl = _g.pending_load;
    _g.pending_load = undefined;
    if (instance_exists(obj_player) && (!variable_struct_exists(_pl, "room_id") || _pl.room_id == room)) {
        with (obj_player) {
            x = _pl.px;
            y = _pl.py;
            facing_x = _pl.facing_x;
            facing_y = _pl.facing_y;
        }
    }
    scr_input_block(1);
}

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
    if (_g.last_battle_result == "victory") {
        scr_story_try_pending_post_dialogue();
    }
}

// Grace period + new steps-until counter after room entry and after returning from battle.
scr_random_encounter_on_room_start();

// Safety: after spawn, after a return from battle, or after town wake-up,
// nudge the player if they came up overlapping an obj_solid.
scr_player_unstick();
