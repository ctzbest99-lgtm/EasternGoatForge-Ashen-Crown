/// obj_merchant : Step
/// Same interaction rule as every other interactable: a discrete press while facing it, never an overlap.
if (!variable_global_exists("dialogue_open")) global.dialogue_open = false;
if (!variable_global_exists("shop_open")) global.shop_open = false;
if (global.dialogue_open || global.battle_active || global.shop_open) exit;
if (variable_global_exists("menu_open") && global.menu_open) exit;

var _player_obj = asset_get_index("obj_player");
if (_player_obj < 0 || instance_number(_player_obj) == 0) exit;
var _player = instance_find(_player_obj, 0);
if (!_player.input_enabled) exit;
if (!keyboard_check_pressed(ord("Z"))) exit;

if (scr_interaction_in_front(_player.x, _player.y, _player.facing_x, _player.facing_y, x, y, talk_range)) {
    /// scr_shop_begin owns the "may a shop open right now" decision and returns noone when it may not.
    scr_shop_begin();
}
