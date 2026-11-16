/// obj_npc : Draw
/// Code-drawn placeholder: there is no NPC sprite asset yet, and this file is the only thing that would
/// need to change when one lands (set sprite_index and delete the rectangles below).
if (npc_kind == "prop") {
    /// A door or sign: wider than it is deep, with a frame line and a seam down the middle.
    draw_set_colour(c_black);
    draw_rectangle(x - 15, y - 34, x + 15, y + 1, false);
    draw_set_colour(c_dkgray);
    draw_rectangle(x - 13, y - 32, x + 13, y, false);
    draw_set_colour(c_gray);
    draw_rectangle(x - 10, y - 28, x + 10, y - 4, true);
    draw_set_colour(c_black);
    draw_rectangle(x - 1, y - 32, x + 1, y, false);
} else {
    draw_set_colour(c_black);
    draw_rectangle(x - 9, y - 24, x + 9, y + 1, false);
    draw_set_colour(c_dkgray);
    draw_rectangle(x - 7, y - 22, x + 7, y, false);
    draw_set_colour(c_white);
    draw_rectangle(x - 5, y - 28, x + 5, y - 18, false);
}

/// Talk prompt only when this NPC is the one the player is facing.
var _show = false;
var _player_obj = asset_get_index("obj_player");
var _dialogue_open = (variable_global_exists("dialogue_open") && global.dialogue_open);
if (_player_obj >= 0 && instance_number(_player_obj) > 0 && !_dialogue_open) {
    var _player = instance_find(_player_obj, 0);
    if (_player.input_enabled) {
        _show = scr_interaction_in_front(_player.x, _player.y, _player.facing_x, _player.facing_y, x, y, talk_range);
    }
}
if (_show) {
    draw_set_colour(c_yellow);
    draw_text(x - 2, y - 48, "!");
}

draw_set_colour(c_white);
