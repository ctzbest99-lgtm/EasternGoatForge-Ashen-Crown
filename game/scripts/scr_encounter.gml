/// scr_encounter — overworld -> battle -> overworld hand-off.
/// Decision for this prototype: battles run in a dedicated room (BATTLE_ROOM), not an overlay.

/// Start a battle. Returns false (and does nothing) if a battle or transition is already active.
/// `_enemy_id` may be one enemy id (Chapter 1 callers), a group id such as "grp_reeve_calder",
/// or an array of 1–3 enemy ids (random group). pending_battle.enemy_id stays the lead / boss id
/// so the existing story hooks (Ashbound Hunter, Blackguard) keep working.
function scr_encounter_start(_enemy_id, _encounter_id = "", _script_id = "") {
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
    var _resolved = scr_encounter_resolve_ids(_enemy_id);
    var _lead = (array_length(_resolved.ids) > 0) ? _resolved.ids[0] : (is_string(_enemy_id) ? _enemy_id : "");
    _g.pending_battle = {
        enemy_id: _lead,
        enemy_ids: _resolved.ids,
        boss_index: _resolved.boss_index,
        group_id: (is_string(_enemy_id) && is_struct(scr_get_encounter_group(_enemy_id))) ? _enemy_id : "",
        encounter_id: _encounter_id,
        script_id: _script_id,
        area: scr_ch1_battle_area(_lead, _encounter_id)
    };
    _g.last_battle_result = undefined;
    _g.last_defeat_penalty = undefined;
    _g.battle_active = true; // locks overworld input immediately, before the room change happens
    room_goto(BATTLE_ROOM);
    return true;
}

/// End the battle and leave the battle room. Called once by obj_battle_controller.
/// _result: "victory" | "defeat" | "error"
/// Victory and error return to the saved overworld position. Defeat restores party
/// HP, applies the gold/XP penalty, and sends the party to the town respawn point
/// (TOWN_RESPAWN_ROOM, currently rm_overworld until a town room exists).
function scr_battle_finish(_result) {
    scr_game_state_init();
    var _g = global.game;
    var _pending = _g.pending_battle;

    if (_result == "victory" && is_struct(_pending) && _pending.encounter_id != "") {
        _g.cleared_encounters[$ _pending.encounter_id] = true;
    }
    scr_ashbound_on_battle_finish(_result, _pending);
    scr_blackguard_on_battle_finish(_result, _pending);
    scr_ch2_on_battle_finish(_result, _pending);
    scr_ch3_on_battle_finish(_result, _pending);
    scr_party_clear_guard(_g.party);
    scr_battle_clear_party_battle_state(_result == "victory");

    if (_result == "defeat") {
        // Defeat *check* and XP/gold penalty use the active party only (assumption).
        // HP is still restored for the reserve member too (they wake up in town with the others).
        scr_party_restore_active_and_reserve();
        scr_apply_defeat_penalty();
    } else {
        _g.last_defeat_penalty = undefined;
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

/// Deduct the defeat penalty from shared gold and each *active* member's XP
/// (reserve is not penalized; assumption pending owner approval). Stores the
/// amounts in global.game.last_defeat_penalty for the wake-up message.
/// Gold: floor(current * DEFEAT_GOLD_LOSS_PCT), never below 0.
/// XP: 10% of progress toward the next level, never enough to drop a level.
function scr_apply_defeat_penalty() {
    scr_game_state_init();
    var _g = global.game;

    var _gold_lost = floor(max(0, _g.gold) * DEFEAT_GOLD_LOSS_PCT);
    if (_gold_lost > _g.gold) _gold_lost = _g.gold;
    if (_gold_lost < 0) _gold_lost = 0;
    _g.gold -= _gold_lost;

    var _xp_lost = 0;
    for (var _i = 0; _i < array_length(_g.party); _i++) {
        var _member = _g.party[_i];
        if (!is_struct(_member)) continue;
        var _lost = scr_defeat_xp_loss_amount(_member.xp, _member.level);
        _member.xp -= _lost;
        _xp_lost += _lost;
    }
    if (array_length(_g.party) > 0 && is_struct(_g.party[0])) _g.xp = _g.party[0].xp;

    _g.last_defeat_penalty = { gold_lost: _gold_lost, xp_lost: _xp_lost };
    return _g.last_defeat_penalty;
}

/// XP deducted on defeat: floor(progress toward next level * DEFEAT_XP_LOSS_PCT),
/// never enough to drop below scr_xp_for_level(_level) (no level-down, never negative).
/// Pass the member's current level so the floor is that level's XP requirement.
function scr_defeat_xp_loss_amount(_xp, _level = undefined) {
    if (is_undefined(_level)) _level = scr_level_from_xp(_xp);
    var _level_floor = scr_xp_for_level(_level);
    var _progress = max(0, _xp - _level_floor);
    var _lost = floor(_progress * DEFEAT_XP_LOSS_PCT);
    if (_lost < 0) _lost = 0;
    if (_xp - _lost < _level_floor) _lost = max(0, _xp - _level_floor);
    return _lost;
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

/// Placeholder wake-up lines after a defeat respawn, including the gold/XP lost.
/// Final wording is not approved.
function scr_town_wake_up_dialogue() {
    var _gold_lost = 0;
    var _xp_lost = 0;
    var _penalty = (variable_global_exists("game") && is_struct(global.game))
        ? global.game.last_defeat_penalty
        : undefined;
    if (is_struct(_penalty)) {
        _gold_lost = _penalty.gold_lost;
        _xp_lost = _penalty.xp_lost;
    }
    scr_dialogue_open([
        "[Placeholder] You wake up back in town.",
        "You lost " + string(_gold_lost) + " gold and " + string(_xp_lost) + " EXP."
    ]);
}


/// Reset the random-encounter grace period and roll a new steps-until counter.
/// Called from obj_game_controller : Room Start on every non-battle room.
function scr_random_encounter_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    _g.encounter_grace_steps = ENCOUNTER_GRACE_STEPS;
    _g.encounter_step_remainder = 0;
    _g.encounter_steps_until = scr_random_encounter_roll_steps();
}

function scr_random_encounter_roll_steps() {
    var _min = max(1, ENCOUNTER_STEPS_MIN);
    var _max = max(_min, ENCOUNTER_STEPS_MAX);
    return irandom_range(_min, _max);
}

/// Advance the random-encounter counter by `_pixels_moved` of actual movement.
/// Only counts inside an encounter area, and only when input is not locked.
function scr_random_encounter_tick(_pixels_moved) {
    scr_game_state_init();
    var _g = global.game;
    if (!RANDOM_ENCOUNTERS_ENABLED || !_g.random_encounters_enabled) return;
    if (_g.battle_active || _g.transition_active || _g.dialogue_open) return;
    if (!instance_exists(obj_player) || _pixels_moved <= 0) return;

    // Fixed story/boss triggers win over a random roll on the same tile.
    var _on_trigger = false;
    with (obj_player) {
        _on_trigger = place_meeting(x, y, obj_encounter_trigger)
            || place_meeting(x, y, obj_story_encounter);
    }
    if (_on_trigger) return;

    var _table = scr_random_encounter_table_at(obj_player.x, obj_player.y);
    if (!is_array(_table)) return; // safe area (town, or no zone / room table)

    var _size = max(1, ENCOUNTER_STEP_PIXELS);
    _g.encounter_step_remainder += _pixels_moved;

    while (_g.encounter_step_remainder >= _size) {
        _g.encounter_step_remainder -= _size;

        if (_g.encounter_grace_steps > 0) {
            _g.encounter_grace_steps -= 1;
            continue;
        }

        if (_g.encounter_steps_until <= 0) {
            _g.encounter_steps_until = scr_random_encounter_roll_steps();
        }

        _g.encounter_steps_until -= 1;
        if (_g.encounter_steps_until > 0) continue;

        _g.encounter_steps_until = scr_random_encounter_roll_steps();
        // Rare Ashbound Hunter (3–5% of random fights in opted-in areas). Empty
        // encounter_id so a rare victory does not consume the Watchtower guarantee.
        if (scr_area_allows_ashbound_rare() && random(1) < _g.ashbound_rare_chance) {
            scr_ashbound_hunter_start("");
            return;
        }
        var _enemy_id = scr_encounter_table_pick(_table); // enemy id, group id, or array of ids
        if (is_undefined(_enemy_id)) continue;
        // Empty encounter_id: random fights are not recorded in cleared_encounters.
        scr_encounter_start(_enemy_id, "");
        return;
    }
}

/// Encounter table at a world position: overlapping obj_encounter_zone first,
/// otherwise the room table from scr_get_room_encounter_table(). Undefined = safe.
function scr_random_encounter_table_at(_x, _y) {
    if (instance_exists(obj_player)) {
        var _zone = noone;
        with (obj_player) _zone = instance_place(_x, _y, obj_encounter_zone);
        if (_zone != noone) {
            var _zone_table = scr_encounter_zone_table(_zone);
            if (is_array(_zone_table)) return _zone_table;
        }
    }
    return scr_get_room_encounter_table(room);
}

function scr_encounter_zone_table(_zone) {
    if (!instance_exists(_zone)) return undefined;
    if (is_string(_zone.table_id) && _zone.table_id != "") {
        var _named = scr_get_encounter_table(_zone.table_id);
        if (is_array(_named)) return _named;
    }
    if (is_array(_zone.enemy_table)) return _zone.enemy_table;
    return undefined;
}

/// Weighted pick from [{ enemy_id | group | group_id, weight }, ...]. Skips unknown ids,
/// empty groups, and non-positive weights. Returns an enemy id string, a group id string,
/// or an array of enemy ids (scr_encounter_start accepts all three), or undefined if empty.
function scr_encounter_table_pick(_table) {
    if (!is_array(_table)) return undefined;
    var _ids = [];
    var _weights = [];
    var _total = 0;
    for (var _i = 0; _i < array_length(_table); _i++) {
        var _entry = _table[_i];
        if (!is_struct(_entry)) continue;
        var _w = variable_struct_exists(_entry, "weight") ? max(0, _entry.weight) : 1;
        if (_w <= 0) continue;
        var _id = undefined;
        if (variable_struct_exists(_entry, "group_id")) _id = _entry.group_id;
        else if (variable_struct_exists(_entry, "group")) _id = _entry.group;
        else if (variable_struct_exists(_entry, "enemy_id")) _id = _entry.enemy_id;
        if (is_undefined(_id)) continue;
        if (array_length(scr_encounter_resolve_ids(_id).ids) == 0) continue;
        array_push(_ids, _id);
        array_push(_weights, _w);
        _total += _w;
    }
    if (_total <= 0) return undefined;
    var _roll = irandom(_total - 1);
    for (var _j = 0; _j < array_length(_ids); _j++) {
        _roll -= _weights[_j];
        if (_roll < 0) return _ids[_j];
    }
    return _ids[array_length(_ids) - 1];
}
