/// obj_dialogue_box : Draw GUI
if (line_index >= array_length(lines)) exit;

scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _margin = 4;
var _box_h = 52;
var _left = _margin;
var _top = _gh - _box_h - _margin;
var _right = _gw - _margin;
var _bottom = _gh - _margin;

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

scr_ui_window(_left, _top, _right - _left, _bottom - _top, "normal");

var _portrait = scr_ch1_portrait(speaker_name, "neutral");
var _px = 0;
if (scr_sprite_is_valid(_portrait)) {
    // 48×48 in a 48×48 well on the left of the box.
    draw_sprite(_portrait, 0, _left + 4, _top + 2);
    _px = 52;
}

var _text_y = _top + 6;
if (speaker_name != "") {
    scr_ui_text(_left + 8 + _px, _text_y, speaker_name, make_color_rgb(217, 184, 96));
    _text_y += 12;
}
var _text = lines[line_index];
var _max_w = (_right - _left) - 16 - _px;
scr_ui_text_ext(_left + 8 + _px, _text_y, _text, _max_w, c_white);

// Strike-through for indices listed in struck_lines (e.g. Bandit Camp line 1).
var _struck = false;
if (is_array(struck_lines)) {
    for (var _i = 0; _i < array_length(struck_lines); _i++) {
        if (struck_lines[_i] == line_index) { _struck = true; break; }
    }
}
if (_struck) {
    var _sep = 11;
    var _h = 11;
    if (variable_global_exists("fnt_main") && global.fnt_main != -1) {
        _h = string_height_ext(_text, 11, _max_w);
        _sep = 11;
    } else {
        _sep = string_height("Ag");
        _h = string_height_ext(_text, -1, _max_w);
    }
    var _rows = max(1, ceil(_h / max(1, _sep)));
    draw_set_color(c_white);
    for (var _r = 0; _r < _rows; _r++) {
        var _ly = _text_y + _sep * (_r + 0.5);
        var _lw = min(string_width(_text), _max_w);
        if (_r == _rows - 1) _lw = min(string_width(_text), _max_w);
        else _lw = _max_w;
        draw_line(_left + 8 + _px, _ly, _left + 8 + _px + _lw, _ly);
    }
}

// Choice list (scr_dialogue_choice) in a small window above the box, right-aligned.
if (is_array(choices) && array_length(choices) > 0 && line_index >= array_length(lines) - 1) {
    var _cw = 0;
    for (var _c = 0; _c < array_length(choices); _c++) _cw = max(_cw, string_width(choices[_c]));
    _cw += 24;
    var _ch = 8 + 11 * array_length(choices);
    var _cx = _right - _cw;
    var _cy = _top - _ch - 2;
    scr_ui_window(_cx, _cy, _cw, _ch, "normal");
    for (var _c2 = 0; _c2 < array_length(choices); _c2++) {
        var _col = (_c2 == choice_index) ? make_color_rgb(217, 184, 96) : c_white;
        scr_ui_text(_cx + 14, _cy + 4 + 11 * _c2, choices[_c2], _col);
        if (_c2 == choice_index) scr_ui_text(_cx + 5, _cy + 4 + 11 * _c2, ">", _col);
    }
}

draw_set_halign(fa_right);
scr_ui_text(_right - 6, _bottom - 12, (line_index < array_length(lines) - 1) ? "[Z]" : "[Z]", make_color_rgb(154, 146, 132));
draw_set_halign(fa_left);
