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

_draw_layer(t_bg0, scroll0);
_draw_layer(t_bg1, scroll1);
_draw_layer(t_bg2, scroll2);
_draw_layer(t_bg3, scroll3);

if (scr_sprite_is_valid(t_embers)) {
    var _ef = floor(ember_f) mod 24;
    draw_sprite(t_embers, _ef, 0, 0);
    // Second pass, 50% alpha, offset 12 frames, mirrored, for depth.
    draw_set_alpha(0.5);
    draw_sprite_ext(t_embers, (_ef + 12) mod 24, _bw, 0, -1, 1, 0, c_white, 0.5);
    draw_set_alpha(1);
}

var _lx = 160 * _s;
if (scr_sprite_is_valid(t_logo)) {
    // Place the top-centre of the logo at (160, logo_y) even if the origin was left at 0,0.
    var _lx2 = _lx + sprite_get_width(t_logo) * 0.5 - sprite_get_xoffset(t_logo);
    var _ly2 = logo_y - sprite_get_yoffset(t_logo);
    draw_sprite_ext(t_logo, 0, _lx2, _ly2, 1, 1, 0, c_white, logo_alpha);
} else {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_lx, logo_y, "ASHEN CROWN", 2 * _s, 2 * _s, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ---------------------------------------------------------------------------------------------
// Main menu. These are drawn as text rather than the old baked option sprites so the five
// labels and the disabled Continue state can never drift from the code.
if (mode == "menu") {
    draw_set_alpha(0.38);
    draw_set_color(c_black);
    draw_rectangle(64 * _s, 64 * _s, 256 * _s, 170 * _s, false);
    draw_set_alpha(1);

    scr_ui_set_font();
    draw_set_valign(fa_middle);
    for (var _i = 0; _i < array_length(options); _i++) {
        var _id = options[_i];
        var _y = (76 + _i * 20) * _s;
        var _disabled = (_id == "continue" && !has_save);
        var _selected = (_i == index);
        var _col = c_white;
        if (_disabled) _col = make_color_rgb(92, 88, 80);
        else if (_selected) _col = make_color_rgb(217, 184, 96);

        if (_selected && !_disabled) {
            draw_set_alpha(0.12);
            draw_set_color(make_color_rgb(217, 184, 96));
            draw_rectangle(72 * _s, (_y - 9 * _s), 248 * _s, (_y + 10 * _s), false);
            draw_set_alpha(1);
        }

        draw_set_halign(fa_center);
        draw_set_alpha(options_alpha);
        draw_set_color(_col);
        draw_text_transformed(_lx, _y, menu_labels[_i], 1.75 * _s, 1.75 * _s, 0);
        if (_selected && !_disabled) {
            draw_set_color(make_color_rgb(217, 184, 96));
            draw_rectangle((_lx - 62 * _s), (_y + 10 * _s), (_lx + 62 * _s), (_y + 11 * _s), false);
        }

        if (_selected && scr_sprite_is_valid(t_cursor) && options_alpha > 0.4) {
            var _tw = string_width(menu_labels[_i]) * 1.75 * _s;
            var _cx = _lx - _tw * 0.5 - 14 * _s;
            var _cf = floor(current_time * 0.001 * 8) mod 4;
            draw_sprite(t_cursor, _cf, _cx, _y - 6 * _s);
        }
    }

    if (menu_message != "") {
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(make_color_rgb(190, 186, 178));
        draw_text_transformed(_lx, 168 * _s, menu_message, _s, _s, 0);
    }
}

// ---------------------------------------------------------------------------------------------
// Settings. Audio is the only configurable system the project actually has; the footer names
// the fixed keyboard controls rather than pretending a remapping/controller screen exists.
if (mode == "settings") {
    scr_menu_draw_dither();
    var _px = settings_x * _s;
    var _py = settings_y * _s;
    var _pw = settings_w * _s;
    var _ph = settings_h * _s;
    scr_menu_draw_window(_px, _py, _pw, _ph, "gold");

    scr_ui_set_font();
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(217, 184, 96));
    draw_text_transformed(_px + _pw * 0.5, _py + 10 * _s, "Settings", 2 * _s, 2 * _s, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _labels = scr_options_labels();
    var _rx = _px + 12 * _s;
    var _bar_x = _px + 106 * _s;
    for (var _r = 0; _r < array_length(opt_rows); _r++) {
        var _ry = (settings_row0 + _r * settings_row_dy) * _s;
        var _sel = (_r == opt_index);
        var _col = _sel ? make_color_rgb(217, 184, 96) : c_white;
        scr_ui_text(_rx, _ry, (_sel ? "> " : "  ") + _labels[_r], _col);
        var _kind = opt_rows[_r];
        if (_kind == "back") continue;
        if (_kind == "muted") {
            draw_set_halign(fa_right);
            draw_set_color(_col);
            draw_text(_px + _pw - 12 * _s, _ry, global.audio_ctx.muted ? "On" : "Off");
            draw_set_halign(fa_left);
        } else {
            var _v = scr_audio_get_gain(_kind);
            var _seg = 10;
            var _on = round(_v * _seg);
            for (var _k = 0; _k < _seg; _k++) {
                var _bx = _bar_x + _k * 6 * _s;
                draw_set_color(_k < _on ? make_color_rgb(217, 184, 96) : make_color_rgb(60, 56, 48));
                draw_rectangle(_bx, _ry + _s, _bx + 5 * _s, _ry + 6 * _s, false);
            }
            draw_set_color(_col);
            draw_set_halign(fa_right);
            draw_text(_px + _pw - 12 * _s, _ry, string(round(_v * 100)) + "%");
            draw_set_halign(fa_left);
        }
    }

    draw_set_color(make_color_rgb(150, 146, 138));
    scr_ui_text(_rx, _py + _ph - 28 * _s, "Arrows move/change | Z confirm", make_color_rgb(150, 146, 138));
    scr_ui_text(_rx, _py + _ph - 17 * _s, "X back | Mouse hover/click", make_color_rgb(150, 146, 138));
}

if (mode == "saves") {
    // Field-menu load layout: dither, then the three slot windows.
    scr_menu_draw_dither();
    scr_menu_draw_save_slots(slots, save_index, "load", "Load which file?", save_message);
}

// ---------------------------------------------------------------------------------------------
// New Game confirmation. The default is No; a stray Z cannot wipe the current run.
if (mode == "confirm_new") {
    scr_menu_draw_dither();
    scr_menu_draw_window(64, 48, 192, 92, "gold");
    scr_ui_set_font();

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(217, 184, 96));
    draw_text(160, 56, "Start a new game?");
    draw_set_color(c_white);
    draw_text(160, 74, "Current unsaved progress");
    draw_text(160, 86, "will be lost.");
    draw_set_color(make_color_rgb(180, 176, 168));
    draw_text(160, 98, has_save ? "Existing save files are kept." : "No save files exist yet.");

    draw_set_valign(fa_middle);
    draw_set_color(confirm_index == 0 ? make_color_rgb(217, 184, 96) : c_white);
    draw_text(130, 114, "No");
    draw_set_color(confirm_index == 1 ? make_color_rgb(217, 184, 96) : c_white);
    draw_text(192, 114, "Yes");
    if (confirm_index == 0) {
        draw_set_color(make_color_rgb(217, 184, 96));
        draw_rectangle(119, 122, 141, 123, false);
    } else {
        draw_set_color(make_color_rgb(217, 184, 96));
        draw_rectangle(181, 122, 203, 123, false);
    }
    draw_set_color(make_color_rgb(150, 146, 138));
    draw_set_valign(fa_top);
    draw_text(160, 130, "Left/right or mouse; X cancels");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
