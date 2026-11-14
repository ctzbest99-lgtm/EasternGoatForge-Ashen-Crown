/// obj_battle_controller : Draw GUI
/// Battle screen: draw imported battler sprites at their feet origin, or a rectangle if missing.
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

// Enemy (left), facing right. Feet sit above the command panel.
if (is_struct(enemy)) {
    var _ex = _gw * 0.28;
    var _ey = _gh * 0.52;
    if (!scr_battle_draw_vis(enemy_vis, _ex, _ey)) {
        draw_set_color(enemy.hp > 0 ? c_maroon : c_dkgray);
        draw_rectangle(_ex - 32, _ey - 64, _ex + 32, _ey, false);
    }
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_ex, _ey + 8, enemy.name);
    draw_text(_ex, _ey + 26, "HP " + string(enemy.hp) + "/" + string(enemy.max_hp));
    draw_set_halign(fa_left);
}

// Party battlers (right), facing left (vis.xscale = -1). Status text is the list above.
var _px = _gw * 0.72;
var _py = _gh * 0.52;
var _i;
for (_i = 0; _i < array_length(party); _i++) {
    var _member = party[_i];
    var _fx = _px + _i * 16;
    var _fy = _py + _i * 20;
    var _vis = (_i < array_length(party_vis)) ? party_vis[_i] : undefined;
    if (!scr_battle_draw_vis(_vis, _fx, _fy)) {
        if (_member.hp <= 0) draw_set_color(c_dkgray);
        else if (state == BATTLE_STATE.COMMAND_SELECT && _i == actor_index) draw_set_color(c_yellow);
        else draw_set_color(c_teal);
        draw_rectangle(_fx - 16, _fy - 48, _fx + 16, _fy, false);
    }
}

// Party HUD (upper right). Sized for up to four rows.
var _hx = _gw * 0.58;
var _hy = 16;
for (_i = 0; _i < array_length(party); _i++) {
    var _hud = party[_i];
    var _line = _hud.name + "  Lv " + string(_hud.level) + "  HP " + string(_hud.hp) + "/" + string(_hud.max_hp);
    if (_hud.is_guarding) _line += "  [Guard]";
    if (_hud.hp <= 0) draw_set_color(c_gray);
    else if (state == BATTLE_STATE.COMMAND_SELECT && _i == actor_index) draw_set_color(c_yellow);
    else draw_set_color(c_white);
    draw_text(_hx, _hy + _i * 20, _line);
}

// Bottom panel: command menu or current message. (Blank during ANIMATING.)
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
} else if (state == BATTLE_STATE.ANIMATING) {
    draw_set_halign(fa_right);
    draw_text(_gw - 16, _gh - 28, "[Z skip]");
    draw_set_halign(fa_left);
}
