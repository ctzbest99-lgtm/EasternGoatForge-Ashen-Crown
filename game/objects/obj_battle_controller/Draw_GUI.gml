/// obj_battle_controller : Draw GUI
/// FF1-style 320×180 battle: background, enemies left (face right), party right (xscale -1),
/// nine-slice windows, cursor, HP bars, status icons, floating damage.
scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Background
if (scr_sprite_is_valid(battle_bg)) {
    draw_sprite_stretched(battle_bg, 0, 0, 0, _gw, _gh);
} else {
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
}

// Enemy (left), facing right. Feet sit above the command panel (y ≈ 118).
var _ef = scr_battle_layout_enemy_feet();
if (is_struct(enemy)) {
    if (!scr_battle_draw_vis(enemy_vis, _ef.x, _ef.y)) {
        draw_set_color(enemy.hp > 0 ? c_maroon : c_dkgray);
        draw_rectangle(_ef.x - 16, _ef.y - 48, _ef.x + 16, _ef.y, false);
    }
}

// Party battlers (right), facing left (vis.xscale = -1).
var _i;
for (_i = 0; _i < array_length(party); _i++) {
    var _member = party[_i];
    var _pf = scr_battle_layout_party_feet(_i);
    var _vis = (_i < array_length(party_vis)) ? party_vis[_i] : undefined;
    if (!scr_battle_draw_vis(_vis, _pf.x, _pf.y)) {
        if (_member.hp <= 0) draw_set_color(c_dkgray);
        else if (state == BATTLE_STATE.COMMAND_SELECT && _i == actor_index) draw_set_color(c_yellow);
        else draw_set_color(c_teal);
        draw_rectangle(_pf.x - 8, _pf.y - 24, _pf.x + 8, _pf.y, false);
    }
}

scr_battle_fx_draw(battle_fx);
scr_battle_pops_draw(dmg_pops);

// Enemy name plate (top-left)
if (is_struct(enemy)) {
    var _kind = (enemy.actor_id == "blackguard") ? "gold" : "normal";
    scr_ui_window(8, 6, 120, 22, _kind);
    var _en = enemy.name;
    if (enemy.actor_id == "blackguard" && variable_struct_exists(enemy, "phase") && enemy.phase > 1) {
        _en += "  P" + string(enemy.phase);
    }
    scr_ui_text(14, 11, _en, c_white);
}

// Bottom-left: command window. Bottom-right: party status. Full-width message on MESSAGE.
var _menu_y = 128;
if (state == BATTLE_STATE.COMMAND_SELECT && actor_index != -1) {
    scr_ui_window(4, _menu_y, 88, 48, "normal");
    scr_ui_window(96, _menu_y, 220, 48, "normal");
    var _opts = command_options;
    var _ty0 = _menu_y + 8;
    for (var _c = 0; _c < array_length(_opts); _c++) {
        var _oy = _ty0 + _c * 12;
        var _col = (_c == command_index) ? make_color_rgb(217, 184, 96) : c_white;
        if (_c == command_index) {
            var _bar = scr_sprite_index("spr_ui_select_bar");
            if (scr_sprite_is_valid(_bar)) draw_sprite_stretched(_bar, 0, 16, _oy - 1, 70, 12);
            scr_ui_cursor(16, _oy + 5);
        }
        scr_ui_text(22, _oy, _opts[_c], _col);
    }
    for (_i = 0; _i < array_length(party); _i++) {
        var _hud = party[_i];
        var _hy = _menu_y + 6 + _i * 10;
        var _hcol = c_white;
        if (_hud.hp <= 0) _hcol = c_gray;
        else if (_i == actor_index) _hcol = make_color_rgb(217, 184, 96);
        var _nm = _hud.name;
        if (string_length(_nm) > 8) _nm = string_copy(_nm, 1, 8);
        scr_ui_text(104, _hy, _nm, _hcol);
        scr_ui_hp_bar(164, _hy + 2, _hud.hp, _hud.max_hp, 48);
        scr_ui_text(216, _hy, string(_hud.hp), _hcol);
        if (_hud.is_guarding) scr_ui_status_icon(246, _hy + 5, 11);
    }
} else if (state == BATTLE_STATE.MESSAGE || state == BATTLE_STATE.ANIMATING || state == BATTLE_STATE.PHASE_SHIFT) {
    var _wkind = (is_struct(enemy) && enemy.actor_id == "blackguard") ? "gold" : "normal";
    scr_ui_window(4, _menu_y, 312, 48, _wkind);
    var _msg = (state == BATTLE_STATE.MESSAGE) ? message : "";
    if (state == BATTLE_STATE.PHASE_SHIFT) _msg = "The air thickens with Ash...";
    if (_msg != "") scr_ui_text_ext(12, _menu_y + 8, _msg, 280, c_white);
    if (state == BATTLE_STATE.MESSAGE) {
        draw_set_halign(fa_right);
        scr_ui_text(308, _gh - 14, "[Z]", make_color_rgb(217, 184, 96));
        draw_set_halign(fa_left);
    } else if (state == BATTLE_STATE.ANIMATING || state == BATTLE_STATE.PHASE_SHIFT) {
        draw_set_halign(fa_right);
        scr_ui_text(308, _gh - 14, "[Z skip]", make_color_rgb(154, 146, 132));
        draw_set_halign(fa_left);
    }
} else {
    // Fallback party strip (victory / intro hand-off frames).
    scr_ui_window(4, _menu_y, 312, 48, "normal");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
