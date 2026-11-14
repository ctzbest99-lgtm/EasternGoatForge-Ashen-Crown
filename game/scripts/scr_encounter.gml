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

/// End the battle and leave the battle room. Called once by obj_battle_controller.
/// _result: "victory" | "defeat" | "error"
/// Victory and error return to the saved overworld position. Defeat restores party
/// HP, keeps earned XP/gold, and sends the party to the town respawn point
/// (TOWN_RESPAWN_ROOM, currently rm_overworld until a town room exists).
function scr_battle_finish(_result) {
    scr_game_state_init();
    var _g = global.game;
    var _pending = _g.pending_battle;

    if (_result == "victory" && is_struct(_pending) && _pending.encounter_id != "") {
        _g.cleared_encounters[$ _pending.encounter_id] = true;
    }
    scr_party_clear_guard(_g.party);

    if (_result == "defeat") {
        scr_party_restore_all(_g.party);
    }

    _g.last_battle_result = _result;
    _g.pending_battle = undefined;
    _g.battle_active = false;
    _g.transition_active = true; // cleared by obj_game_controller : Room Start after restoring the player

    var _target_room = OVERWORLD_ROOM;
    if (_result == "defeat") {
        _g.return_point = undefined; // do not snap back to the encounter
        if (room_exists(TOWN_RESPAWN_ROOM)) _target_room = TOWN_RESPAWN_ROOM;
    } else if (is_struct(_g.return_point) && room_exists(_g.return_point.room_id)) {
        _target_room = _g.return_point.room_id;
    }
    room_goto(_target_room);
}

/// Place the player at obj_respawn_point if one exists in the current room,
/// otherwise at TOWN_RESPAWN_X / TOWN_RESPAWN_Y. Facing defaults to down
/// (0, 1) unless the marker sets facing_x / facing_y.
function scr_apply_town_respawn() {
    if (!instance_exists(obj_player)) return;

    var _px = TOWN_RESPAWN_X;
    var _py = TOWN_RESPAWN_Y;
    var _fx = 0;
    var _fy = 1;

    if (instance_exists(obj_respawn_point)) {
        var _marker = instance_find(obj_respawn_point, 0);
        _px = _marker.x;
        _py = _marker.y;
        if (variable_instance_exists(_marker, "facing_x")) _fx = _marker.facing_x;
        if (variable_instance_exists(_marker, "facing_y")) _fy = _marker.facing_y;
    }

    with (obj_player) {
        x = _px;
        y = _py;
        facing_x = _fx;
        facing_y = _fy;
    }
}

/// Short placeholder line shown after a defeat respawn. Final wording is not approved.
function scr_town_wake_up_dialogue() {
    scr_dialogue_open("[Placeholder] You wake up back in town.");
}
