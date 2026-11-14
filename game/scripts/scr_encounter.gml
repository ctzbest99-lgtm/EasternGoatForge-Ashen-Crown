/// scr_encounter — overworld -> battle -> overworld hand-off.
/// Decision for this prototype: battles run in a dedicated room (BATTLE_ROOM), not an overlay.

/// Start a battle. Returns false (and does nothing) if a battle or transition is already active.
function scr_encounter_start(_enemy_id, _encounter_id = "") {
    scr_game_state_init();
    var _g = global.game;
    if (_g.battle_active || _g.transition_active) return false;
    if (!instance_exists(obj_player)) return false;

    var _player = instance_find(obj_player, 0);
    _g.return_point = {
        room_id: room,
        px: _player.x,
        py: _player.y,
        facing_x: _player.facing_x,
        facing_y: _player.facing_y
    };
    _g.pending_battle = { enemy_id: _enemy_id, encounter_id: _encounter_id };
    _g.last_battle_result = undefined;
    _g.battle_active = true; // locks overworld input immediately, before the room change happens
    room_goto(BATTLE_ROOM);
    return true;
}

/// End the battle and return to the saved overworld position. Called once by obj_battle_controller.
/// _result: "victory" | "defeat" | "error"
function scr_battle_finish(_result) {
    scr_game_state_init();
    var _g = global.game;
    var _pending = _g.pending_battle;

    if (_result == "victory" && is_struct(_pending) && _pending.encounter_id != "") {
        _g.cleared_encounters[$ _pending.encounter_id] = true;
    }
    scr_party_clear_guard(_g.party);

    _g.last_battle_result = _result;
    _g.pending_battle = undefined;
    _g.battle_active = false;
    _g.transition_active = true; // cleared by obj_game_controller : Room Start after restoring the player

    var _target_room = OVERWORLD_ROOM;
    if (is_struct(_g.return_point) && room_exists(_g.return_point.room_id)) {
        _target_room = _g.return_point.room_id;
    }
    room_goto(_target_room);
}
