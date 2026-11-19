/// scr_ui — 320×180 FF1-style GUI helpers (nine-slice windows, bitmap font, bars, digits).
/// Missing imports fall back to rectangles and the default font so a gap cannot crash.

#macro UI_FONT_MAP " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"

function scr_ui_init() {
    display_set_gui_size(320, 180);
    scr_ui_fonts_init();
}

function scr_ui_fonts_init() {
    if (variable_global_exists("fnt_main") && global.fnt_main != -1 && font_exists(global.fnt_main)) return;
    global.fnt_main = -1;
    var _spr = scr_sprite_index("spr_font_main_strip95");
    if (!scr_sprite_is_valid(_spr)) return;
    global.fnt_main = font_add_sprite_ext(_spr, UI_FONT_MAP, true, 1);
}

function scr_ui_set_font() {
    scr_ui_fonts_init();
    if (variable_global_exists("fnt_main") && global.fnt_main != -1 && font_exists(global.fnt_main)) {
        draw_set_font(global.fnt_main);
    } else {
        draw_set_font(-1);
    }
}

function scr_ui_scale() {
    var _gw = max(1, display_get_gui_width());
    var _gh = max(1, display_get_gui_height());
    return min(_gw / 320, _gh / 180);
}

function scr_ui_window(_x, _y, _w, _h, _kind = "normal") {
    var _name = "spr_ui_window";
    if (_kind == "dim") _name = "spr_ui_window_dim";
    if (_kind == "gold") _name = "spr_ui_window_gold";
    var _spr = scr_sprite_index(_name, "spr_ui_window");
    if (scr_sprite_is_valid(_spr)) {
        draw_sprite_stretched(_spr, 0, _x, _y, _w, _h);
    } else {
        if (_kind == "gold") draw_set_color(make_color_rgb(40, 28, 16));
        else if (_kind == "dim") draw_set_color(make_color_rgb(12, 14, 22));
        else draw_set_color(make_color_rgb(16, 20, 40));
        draw_rectangle(_x, _y, _x + _w - 1, _y + _h - 1, false);
        draw_set_color(make_color_rgb(217, 184, 96));
        draw_rectangle(_x, _y, _x + _w - 1, _y + _h - 1, true);
    }
}

function scr_ui_cursor(_x, _y, _fps = 4) {
    var _spr = scr_sprite_index("spr_ui_cursor_strip2");
    var _frame = 0;
    if (scr_sprite_is_valid(_spr)) {
        var _n = sprite_get_number(_spr);
        var _t = current_time * 0.001 * _fps;
        _frame = floor(_t) mod max(1, _n);
        draw_sprite(_spr, _frame, _x, _y);
    } else {
        draw_set_color(make_color_rgb(217, 184, 96));
        draw_triangle(_x - 6, _y - 4, _x - 6, _y + 4, _x, _y, false);
    }
}

function scr_ui_hp_bar(_x, _y, _hp, _max, _w = 48) {
    var _frame = scr_sprite_index("spr_ui_bar_frame");
    var _back = scr_sprite_index("spr_ui_bar_fill_back");
    var _fill = scr_sprite_index("spr_ui_bar_fill_hp");
    var _pct = (_max > 0) ? clamp(_hp / _max, 0, 1) : 0;
    if (_pct < 0.25) _fill = scr_sprite_index("spr_ui_bar_fill_hp_crit", "spr_ui_bar_fill_hp");
    else if (_pct < 0.5) _fill = scr_sprite_index("spr_ui_bar_fill_hp_low", "spr_ui_bar_fill_hp");
    var _fw = max(0, floor(_w * _pct));
    if (scr_sprite_is_valid(_frame)) {
        draw_sprite(_frame, 0, _x, _y);
    } else {
        draw_set_color(c_black);
        draw_rectangle(_x, _y, _x + _w + 1, _y + 5, false);
        draw_set_color(c_white);
        draw_rectangle(_x, _y, _x + _w + 1, _y + 5, true);
    }
    if (scr_sprite_is_valid(_back)) draw_sprite_stretched(_back, 0, _x + 1, _y + 1, _w, 4);
    if (_fw > 0) {
        if (scr_sprite_is_valid(_fill)) draw_sprite_stretched(_fill, 0, _x + 1, _y + 1, _fw, 4);
        else {
            var _col = make_color_rgb(80, 180, 80);
            if (_pct < 0.25) _col = make_color_rgb(200, 40, 40);
            else if (_pct < 0.5) _col = make_color_rgb(200, 160, 40);
            draw_set_color(_col);
            draw_rectangle(_x + 1, _y + 1, _x + _fw, _y + 4, false);
        }
    }
}

function scr_ui_status_icon(_x, _y, _index) {
    var _spr = scr_sprite_index("spr_ui_status_strip12");
    if (!scr_sprite_is_valid(_spr)) return;
    draw_sprite(_spr, _index, _x, _y);
}

/// Blind (0) and Sleep (1) live in their own 2-frame strip so the original 12-frame
/// status strip keeps every existing index.
function scr_ui_status_icon_extra(_x, _y, _index) {
    var _spr = scr_sprite_index("spr_ui_status_extra_strip2");
    if (!scr_sprite_is_valid(_spr)) return;
    draw_sprite(_spr, _index, _x, _y);
}

/// Draw a floating integer with the 7×9 digit strips (6px advance). _kind: "dmg" | "heal" | "crit"
function scr_ui_draw_digits(_x, _y, _value, _kind = "dmg", _alpha = 1) {
    var _name = "spr_ui_dmg_digits_strip10";
    if (_kind == "heal") _name = "spr_ui_heal_digits_strip10";
    if (_kind == "crit") _name = "spr_ui_crit_digits_strip10";
    var _spr = scr_sprite_index(_name, "spr_ui_dmg_digits_strip10");
    var _s = string(max(0, floor(abs(_value))));
    var _w = 6 * string_length(_s);
    var _cx = _x - _w * 0.5;
    draw_set_alpha(_alpha);
    if (scr_sprite_is_valid(_spr)) {
        for (var _i = 1; _i <= string_length(_s); _i++) {
            var _d = real(string_char_at(_s, _i));
            draw_sprite(_spr, _d, _cx + (_i - 1) * 6, _y);
        }
    } else {
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(_x, _y, _s);
        draw_set_halign(fa_left);
    }
    draw_set_alpha(1);
}

function scr_ui_text(_x, _y, _str, _col = c_white) {
    scr_ui_set_font();
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_col);
    draw_text(_x, _y, _str);
}

function scr_ui_text_ext(_x, _y, _str, _w, _col = c_white) {
    scr_ui_set_font();
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_col);
    draw_text_ext(_x, _y, _str, 11, _w);
}

function scr_battle_layout_enemy_feet() {
    return { x: 86, y: 118 };
}

function scr_battle_layout_party_feet(_i) {
    return { x: 230 + _i * 10, y: 118 + _i * 8 };
}

function scr_battle_fx_step(_list) {
    if (!is_array(_list)) return;
    for (var _i = array_length(_list) - 1; _i >= 0; _i--) {
        var _fx = _list[_i];
        _fx.t += 1;
        if (variable_struct_exists(_fx, "tx")) {
            var _u = clamp(_fx.t / max(1, _fx.life), 0, 1);
            _fx.x = lerp(_fx.x0, _fx.tx, _u);
            _fx.y = lerp(_fx.y0, _fx.ty, _u);
        }
        if (variable_struct_exists(_fx, "fps") && _fx.fps > 0 && variable_struct_exists(_fx, "frames")) {
            _fx.frame = (_fx.frame + _fx.fps / max(1, game_get_speed(gamespeed_fps))) mod max(1, _fx.frames);
        }
        if (_fx.t >= _fx.life) array_delete(_list, _i, 1);
    }
}

function scr_battle_fx_draw(_list) {
    if (!is_array(_list)) return;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _fx = _list[_i];
        if (scr_sprite_is_valid(_fx.sprite)) {
            var _xs = variable_struct_exists(_fx, "xscale") ? _fx.xscale : 1;
            draw_sprite_ext(_fx.sprite, _fx.frame, _fx.x, _fx.y, _xs, 1, 0, c_white, 1);
        }
    }
}

function scr_battle_pops_step(_list) {
    if (!is_array(_list)) return;
    for (var _i = array_length(_list) - 1; _i >= 0; _i--) {
        var _p = _list[_i];
        _p.y += _p.vy;
        _p.life -= 1;
        if (_p.life <= 0) array_delete(_list, _i, 1);
    }
}

function scr_battle_pops_draw(_list) {
    if (!is_array(_list)) return;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _p = _list[_i];
        var _a = clamp(_p.life / 20, 0, 1);
        if (variable_struct_exists(_p, "word") && _p.word != "") {
            var _ws = scr_sprite_index(_p.word);
            if (scr_sprite_is_valid(_ws)) {
                draw_set_alpha(_a);
                draw_sprite(_ws, 0, _p.x, _p.y);
                draw_set_alpha(1);
                continue;
            }
        }
        scr_ui_draw_digits(_p.x, _p.y, _p.value, _p.kind, _a);
    }
}

function scr_battle_pop_add(_list, _x, _y, _value, _kind = "dmg") {
    if (!is_array(_list)) return;
    array_push(_list, { x: _x, y: _y - 12, value: _value, kind: _kind, word: "", vy: -0.6, life: 40 });
}
