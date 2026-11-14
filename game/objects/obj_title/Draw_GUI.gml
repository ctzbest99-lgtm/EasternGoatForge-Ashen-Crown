/// obj_title : Draw GUI
/// Background layers are drawn here (tiled, scrolled) so the menu works even if the
/// room has no background layers. Embers play at 12 fps on top, then the logo and options.
scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _s = layout_scale;
var _bw = 320 * _s;
var _bh = 180 * _s;

draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

var _draw_layer = function(_spr, _scroll) {
    if (!scr_sprite_is_valid(_spr)) return;
    var _w = sprite_get_width(_spr);
    if (_w <= 0) _w = 320 * layout_scale;
    var _x = -(((_scroll mod _w) + _w) mod _w);
    draw_sprite(_spr, 0, _x, 0);
    draw_sprite(_spr, 0, _x + _w, 0);
};

_draw_layer(spr_bg0, scroll0);
_draw_layer(spr_bg1, scroll1);
_draw_layer(spr_bg2, scroll2);
_draw_layer(spr_bg3, scroll3);

if (scr_sprite_is_valid(spr_embers)) {
    var _ef = floor(ember_f) mod 24;
    draw_sprite(spr_embers, _ef, 0, 0);
    // Second pass, 50% alpha, offset 12 frames, mirrored, for depth.
    draw_set_alpha(0.5);
    draw_sprite_ext(spr_embers, (_ef + 12) mod 24, _bw, 0, -1, 1, 0, c_white, 0.5);
    draw_set_alpha(1);
}

var _lx = 160 * _s;
if (scr_sprite_is_valid(spr_logo)) {
    // Place the top-centre of the logo at (160, logo_y) even if the origin was left at 0,0.
    var _lx2 = _lx + sprite_get_width(spr_logo) * 0.5 - sprite_get_xoffset(spr_logo);
    var _ly2 = logo_y - sprite_get_yoffset(spr_logo);
    draw_sprite_ext(spr_logo, 0, _lx2, _ly2, 1, 1, 0, c_white, logo_alpha);
} else {
    draw_set_halign(fa_center);
    scr_ui_text(_lx, logo_y, "ASHEN CROWN", make_color_rgb(217, 184, 96));
    draw_set_halign(fa_left);
}

if (mode == "press") {
    if ((blink div 30) mod 2 == 0) {
        draw_set_halign(fa_center);
        scr_ui_text(_lx, 132 * _s, "Press any key", c_white);
        draw_set_halign(fa_left);
    }
}

if (mode == "menu" || mode == "options" || mode == "saves") {
    var _ids = options;
    for (var _i = 0; _i < array_length(_ids); _i++) {
        var _id = _ids[_i];
        var _state = "normal";
        if (_id == "continue" && !has_save) _state = "disabled";
        else if (_i == index && mode == "menu") _state = "selected";
        var _name = "spr_menu_opt_" + _id + "_" + _state + "_" + res;
        var _spr = scr_sprite_index(_name, "spr_menu_opt_" + _id + "_" + _state + "_320");
        // Continue only has a disabled graphic; other states fall back to normal.
        if (!scr_sprite_is_valid(_spr)) _spr = scr_sprite_index("spr_menu_opt_" + _id + "_normal_" + res, "spr_menu_opt_" + _id + "_normal_320");
        var _oy = (95 + _i * 22) * _s;
        if (scr_sprite_is_valid(_spr)) {
            var _ox2 = _lx + sprite_get_width(_spr) * 0.5 - sprite_get_xoffset(_spr);
            var _oy2 = _oy + sprite_get_height(_spr) * 0.5 - sprite_get_yoffset(_spr);
            draw_sprite_ext(_spr, 0, _ox2, _oy2, 1, 1, 0, c_white, options_alpha);
        } else {
            var _label = "New Game";
            if (_id == "continue") _label = "Continue";
            if (_id == "options") _label = "Options";
            if (_id == "quit") _label = "Quit";
            var _col = c_white;
            if (_state == "selected") _col = make_color_rgb(217, 184, 96);
            if (_state == "disabled") _col = make_color_rgb(80, 80, 80);
            draw_set_halign(fa_center);
            draw_set_alpha(options_alpha);
            scr_ui_text(_lx, _oy - 5, _label, _col);
            draw_set_alpha(1);
            draw_set_halign(fa_left);
        }
        if (_i == index && mode == "menu" && scr_sprite_is_valid(spr_cursor) && options_alpha > 0.4) {
            var _ow = scr_sprite_is_valid(_spr) ? sprite_get_width(_spr) : 80;
            var _cx = _lx - _ow * 0.5 + 2;
            var _cf = floor(current_time * 0.001 * 8) mod 4;
            draw_sprite(spr_cursor, _cf, _cx, cursor_y);
        }
    }
}

if (mode == "options" || mode == "saves") {
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    var _panel = (mode == "options") ? spr_panel_options : spr_panel_saves;
    // Prefer upcoming Design menu art, then the title save panel already wired in #9.
    if (mode == "saves") {
        var _alt = scr_menu_sprite_window(hires ? "save_hires" : "save");
        if (scr_sprite_is_valid(_alt)) _panel = _alt;
    }
    var _px, _py, _pw, _ph;
    if (scr_sprite_is_valid(_panel)) {
        _pw = sprite_get_width(_panel);
        _ph = sprite_get_height(_panel);
        _px = (_gw - _pw) * 0.5;
        _py = (_gh - _ph) * 0.5;
        draw_sprite(_panel, 0, _px, _py);
    } else {
        _pw = (mode == "options") ? 200 * _s : 220 * _s;
        _ph = (mode == "options") ? 118 * _s : 148 * _s;
        _px = (_gw - _pw) * 0.5;
        _py = (_gh - _ph) * 0.5;
        scr_menu_draw_window(_px, _py, _pw, _ph, (mode == "saves") ? "save" : "gold");
    }
    if (mode == "options") {
        draw_set_halign(fa_center);
        scr_ui_text(_gw * 0.5, _py + 16, "Options  (placeholder)", c_white);
        draw_set_halign(fa_left);
    } else {
        draw_set_halign(fa_left);
        scr_ui_text(_px + 12 * _s, _py + 8 * _s, "Continue", MENU_GOLD_COL);
        var _row0 = _py + 24 * _s;
        var _rh = 32 * _s;
        for (var _si = 0; _si < SAVE_SLOT_COUNT; _si++) {
            var _info = (array_length(slots) > _si) ? slots[_si] : { exists: false, ok: false, empty: true, corrupt: false, location_name: "", lead_level: 1, playtime_seconds: 0, gold: 0 };
            var _ry = _row0 + _si * _rh;
            var _sel = (_si == save_index);
            if (_sel) {
                scr_menu_draw_select_bar(_px + 8 * _s, _ry - 1, _pw - 16 * _s, _rh - 2);
                scr_menu_draw_cursor(_px + 16 * _s, _ry + 8 * _s);
            }
            var _col = _sel ? MENU_GOLD_COL : c_white;
            var _label = "Slot " + string(_si + 1);
            if (_info.empty) {
                scr_ui_text(_px + 28 * _s, _ry, _label, _col);
                scr_ui_text(_px + 28 * _s, _ry + 12 * _s, "Empty", MENU_DIM_COL);
            } else if (_info.corrupt || !_info.ok) {
                scr_ui_text(_px + 28 * _s, _ry, _label, _col);
                scr_ui_text(_px + 28 * _s, _ry + 12 * _s, "Damaged save", make_color_rgb(200, 80, 80));
            } else {
                scr_ui_text(_px + 28 * _s, _ry, _label + "   Lv " + string(_info.lead_level), _col);
                var _meta = string(_info.location_name) + "   " + scr_menu_format_playtime(_info.playtime_seconds) + "   " + string(_info.gold) + "g";
                scr_ui_text(_px + 28 * _s, _ry + 12 * _s, _meta, MENU_DIM_COL);
            }
        }
        if (save_message != "") {
            scr_ui_text(_px + 12 * _s, _py + _ph - 16 * _s, save_message, MENU_GOLD_COL);
        } else {
            scr_ui_text(_px + 12 * _s, _py + _ph - 16 * _s, "[Z] Load   [X] Back", MENU_DIM_COL);
        }
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
