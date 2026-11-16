/// obj_dialogue_box : Draw GUI
/// Bottom panel, text only, using fixed offsets so it needs no font asset yet.
var _width = 620;
var _left = (display_get_gui_width() - _width) * 0.5;
var _height = 96;
var _top = display_get_gui_height() - _height - 20;

draw_set_alpha(0.92);
draw_set_colour(c_black);
draw_rectangle(_left, _top, _left + _width, _top + _height, false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_colour(c_aqua);
draw_text(_left + 16, _top + 10, dialogue.speaker);

/// The full line is drawn in the panel colour first, then the revealed prefix in white on top. Laying out
/// the whole line keeps the wrap stable while characters appear; drawing only the prefix would reflow the
/// paragraph on every letter.
var _line = scr_dialogue_current(dialogue);
draw_set_colour(c_black);
draw_text_ext(_left + 16, _top + 32, _line, 18, _width - 32);
draw_set_colour(c_white);
draw_text_ext(_left + 16, _top + 32, scr_dialogue_visible(dialogue), 18, _width - 32);

draw_set_colour(c_gray);
var _prompt = "[Z] next";
if (scr_dialogue_revealing(dialogue)) _prompt = "[Z] skip";
else if (scr_dialogue_is_last(dialogue)) _prompt = "[Z] close";
draw_text(_left + _width - 150, _top + _height - 22, _prompt);
draw_set_colour(c_white);
