/// obj_debug_menu : Draw GUI (Draw event, subtype 64 — GameMaker stores it as Draw_64.gml)
if (!visible_debug) exit;
var _left = 16;
var _top = 16;
var _width = 350;
var _count = array_length(enemy_ids);
var _height = 78 + _count * 18;
draw_set_alpha(0.9);
draw_set_colour(c_black);
draw_rectangle(_left, _top, _left + _width, _top + _height, false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_colour(c_white);
draw_text(_left + 8, _top + 6, "DEBUG — [F10] close  [TAB] switch  [B] battle  [P] fill party  [F5] save  [F9] load");
if (debug_mode == 0) {
    draw_text(_left + 8, _top + 26, "Spawn enemy ahead of player — [ENTER]");
    for (var _i = 0; _i < _count; _i++) {
        var _row = _top + 46 + _i * 18;
        var _data = scr_get_enemy_data(enemy_ids[_i]);
        draw_set_colour((_i == selected) ? c_yellow : c_white);
        draw_text(_left + 16, _row, ((_i == selected) ? "> " : "  ") + _data.name + "   " + string(_data.max_hp) + " hp   " + string(_data.attack) + " atk");
    }
} else {
    draw_text(_left + 8, _top + 26, "Teleport player — type x,y then [ENTER]");
    draw_set_colour(c_yellow);
    draw_text(_left + 16, _top + 46, "> " + keyboard_string + "_");
}
draw_set_colour(c_white);
draw_text(_left + 8, _top + _height - 22, message);
