/// obj_battle_controller : Create
/// Overlay battle: the room keeps running underneath, so the overworld position needs no bookkeeping
/// and there is no room transition to fail. Set enemy_id before creating, or use scr_battle_start.
if (instance_number(object_index) > 1) {
    /// One battle at a time; the first controller owns the screen.
    instance_destroy();
    exit;
}

/// Every standing member takes the field, by reference: battle damage and victory XP land on the real
/// party. Members already down stay out of the fight.
var _party = scr_party_ensure_global();
battle = scr_battle_create(enemy_id, _party.members, _party.items);
if (is_undefined(battle) || battle == undefined) {
    show_debug_message("obj_battle_controller: unknown enemy id " + string(enemy_id));
    instance_destroy();
    exit;
}

/// Lock exploration input, remembering exactly which instances were enabled so Destroy can restore them.
locked_players = [];
var _player_obj = asset_get_index("obj_player");
if (_player_obj >= 0) {
    var _count = instance_number(_player_obj);
    for (var _i = 0; _i < _count; _i++) {
        var _p = instance_find(_player_obj, _i);
        if (_p.input_enabled) {
            _p.input_enabled = false;
            array_push(locked_players, _p);
        }
    }
}

global.battle_active = true;
exit_battle = false;
level_ups = [];
