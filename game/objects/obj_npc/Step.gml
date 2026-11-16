/// obj_npc : Step
/// Talking is a discrete press while facing the NPC, never an overlap: walking past does not start a
/// conversation, and holding the key cannot restart one.
if (!variable_global_exists("dialogue_open")) global.dialogue_open = false;
if (global.dialogue_open || global.battle_active) exit;
if (variable_global_exists("menu_open") && global.menu_open) exit;
if (variable_global_exists("shop_open") && global.shop_open) exit;

var _player_obj = asset_get_index("obj_player");
if (_player_obj < 0 || instance_number(_player_obj) == 0) exit;
var _player = instance_find(_player_obj, 0);
if (!_player.input_enabled) exit;
if (!keyboard_check_pressed(ord("Z"))) exit;

if (scr_interaction_in_front(_player.x, _player.y, _player.facing_x, _player.facing_y, x, y, talk_range)) {
    /// Scenes are a chain: the furthest one whose flags allow it wins, so the NPC needs no branching code.
    var _chain = [dialogue_id];
    if (dialogue_id_after != "") array_push(_chain, dialogue_id_after);
    if (dialogue_id_final != "") array_push(_chain, dialogue_id_final);
    scr_dialogue_begin(scr_dialogue_pick_chain(_chain, scr_flags_ensure_global()));
}
