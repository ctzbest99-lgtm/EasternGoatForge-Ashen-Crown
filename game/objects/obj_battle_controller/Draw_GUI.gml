/// obj_battle_controller : Draw GUI
/// Placeholder battle screen drawn with rectangles and the default font (no sprites required).
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

// Enemy (left). Enemy HP is shown for prototype debugging only.
if (is_struct(enemy)) {
    var _ex = _gw * 0.25;
    var _ey = _gh * 0.35;
    draw_set_color(enemy.hp > 0 ? c_maroon : c_dkgray);
    draw_rectangle(_ex - 32, _ey - 32, _ex + 32, _ey + 32, false);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_ex, _ey + 40, enemy.name);
    draw_text(_ex, _ey + 58, "HP " + string(enemy.hp) + "/" + string(enemy.max_hp));
    draw_set_halign(fa_left);
}

// Party (right). Sized for up to four rows.
var _px = _gw * 0.6;
var _py = _gh * 0.15;
for (var _i = 0; _i < array_length(party); _i++) {
    var _member = party[_i];
    var _line = _member.name + "  Lv " + string(_member.level) + "  HP " + string(_member.hp) + "/" + string(_member.max_hp);
    if (_member.is_guarding) _line += "  [Guard]";
    if (_member.hp <= 0) draw_set_color(c_gray);
    else if (state == BATTLE_STATE.COMMAND_SELECT && _i == actor_index) draw_set_color(c_yellow);
    else draw_set_color(c_white);
    draw_text(_px, _py + _i * 20, _line);
}

// Bottom panel: command menu or current message.
var _top = _gh - 104;
draw_set_color(c_navy);
draw_rectangle(8, _top, _gw - 8, _gh - 8, false);
draw_set_color(c_white);
draw_rectangle(8, _top, _gw - 8, _gh - 8, true);

if (state == BATTLE_STATE.COMMAND_SELECT && actor_index != -1) {
    draw_text(24, _top + 10, party[actor_index].name + ":");
    for (var _c = 0; _c < array_length(command_options); _c++) {
        draw_text(24, _top + 32 + _c * 20, ((_c == command_index) ? "> " : "  ") + command_options[_c]);
    }
} else if (state == BATTLE_STATE.MESSAGE) {
    draw_text_ext(24, _top + 10, message, -1, _gw - 48);
    draw_set_halign(fa_right);
    draw_text(_gw - 16, _gh - 28, "[Z]");
    draw_set_halign(fa_left);
}
