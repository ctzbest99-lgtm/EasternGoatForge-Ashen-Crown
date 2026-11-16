/// obj_ruin_door : Step
/// Same interaction rule as obj_npc: a discrete press while facing it, never an overlap. The door is the
/// gate, so this is the only place that decides whether Zone 1 can be entered.
if (!variable_global_exists("dialogue_open")) global.dialogue_open = false;
if (global.dialogue_open || global.battle_active) exit;
if (variable_global_exists("menu_open") && global.menu_open) exit;
if (variable_global_exists("shop_open") && global.shop_open) exit;
if (scr_room_transition_pending()) exit;

var _player_obj = asset_get_index("obj_player");
if (_player_obj < 0 || instance_number(_player_obj) == 0) exit;
var _player = instance_find(_player_obj, 0);
if (!_player.input_enabled) exit;
if (!keyboard_check_pressed(ord("Z"))) exit;
if (!scr_interaction_in_front(_player.x, _player.y, _player.facing_x, _player.facing_y, x, y, talk_range)) exit;

var _flags = scr_flags_ensure_global();

/// Barred: the door speaks. The first look records that it was found, which is what the Hermit's
/// check-off scene is waiting for.
var _scene = scr_ruin_door_script(_flags);
if (_scene != "") {
    scr_dialogue_begin(_scene);
    exit;
}

/// Open: remember where to send the party back to before leaving it, then fade in.
scr_room_safe_remember(room_get_name(room), "");
if (!scr_room_transition_request(door_room, door_marker)) {
    /// No such room, or a fade already running: say so in character rather than appearing to ignore the
    /// press. The debug message from the request names the missing room.
    scr_dialogue_begin(RUIN_LOCKED_SCRIPT);
}
