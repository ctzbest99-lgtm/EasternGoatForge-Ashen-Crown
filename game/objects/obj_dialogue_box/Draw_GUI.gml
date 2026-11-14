/// obj_dialogue_box : Draw GUI
if (line_index >= array_length(lines)) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _margin = 8;
var _box_h = 80;
var _left = _margin;
var _top = _gh - _box_h - _margin;
var _right = _gw - _margin;
var _bottom = _gh - _margin;

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_navy);
draw_rectangle(_left, _top, _right, _bottom, false);
draw_set_color(c_white);
draw_rectangle(_left, _top, _right, _bottom, true);

var _text_y = _top + 8;
if (speaker_name != "") {
    draw_text(_left + 12, _text_y, speaker_name);
    _text_y += 18;
}
var _text = lines[line_index];
var _max_w = (_right - _left) - 24;
draw_text_ext(_left + 12, _text_y, _text, -1, _max_w);

// Strike-through for indices listed in struck_lines (e.g. Bandit Camp line 1).
var _struck = false;
if (is_array(struck_lines)) {
    for (var _i = 0; _i < array_length(struck_lines); _i++) {
        if (struck_lines[_i] == line_index) { _struck = true; break; }
    }
}
if (_struck) {
    var _sep = string_height("Ag");
    var _h = string_height_ext(_text, -1, _max_w);
    var _rows = max(1, ceil(_h / max(1, _sep)));
    for (var _r = 0; _r < _rows; _r++) {
        var _ly = _text_y + _sep * (_r + 0.5);
        var _lw = (_r == _rows - 1 && _rows == 1) ? min(string_width(_text), _max_w) : _max_w;
        if (_r == _rows - 1) _lw = min(string_width(_text), _max_w);
        draw_line(_left + 12, _ly, _left + 12 + _lw, _ly);
    }
}

draw_set_halign(fa_right);
draw_text(_right - 8, _bottom - 20, (line_index < array_length(lines) - 1) ? "[Z] Next" : "[Z] Close");
draw_set_halign(fa_left);
