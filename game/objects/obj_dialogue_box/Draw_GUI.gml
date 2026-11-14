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
draw_text_ext(_left + 12, _text_y, lines[line_index], -1, (_right - _left) - 24);

draw_set_halign(fa_right);
draw_text(_right - 8, _bottom - 20, (line_index < array_length(lines) - 1) ? "[Z] Next" : "[Z] Close");
draw_set_halign(fa_left);
