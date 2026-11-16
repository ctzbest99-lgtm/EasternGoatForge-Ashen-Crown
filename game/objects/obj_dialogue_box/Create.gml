/// obj_dialogue_box : Create
/// Data-driven dialogue panel: one script id in, ordered lines out. Locks exploration input while open
/// and restores exactly the instances it locked on destroy.
if (!variable_instance_exists(id, "script_id")) script_id = "npc_hermit";
scr_game_ensure_globals();
if (!variable_global_exists("dialogue_open")) global.dialogue_open = false;

dialogue = scr_dialogue_create();
locked_players = [];

if (!scr_dialogue_open(dialogue, script_id)) {
    show_debug_message("obj_dialogue_box: unknown dialogue id " + string(script_id));
    instance_destroy();
    exit;
}

global.dialogue_open = true;

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
