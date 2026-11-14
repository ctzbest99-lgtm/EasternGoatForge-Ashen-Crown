/// obj_save_menu : Draw GUI
scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
scr_menu_draw_dim(_gw, _gh);

var _x = MENU_SAVE_X;
var _y = MENU_SAVE_Y;
var _w = MENU_SAVE_W;
var _h = MENU_SAVE_H;
scr_menu_draw_window(_x, _y, _w, _h, "save");

var _title = (mode == "load") ? "Load" : "Save";
if (need_prompt) _title = "Save your progress?";
scr_ui_text(_x + MENU_PAD, _y + 4, _title, MENU_GOLD_COL);

if (need_prompt) {
    var _yes = (prompt_index == 0);
    if (_yes) scr_menu_draw_cursor(_x + 28, _y + 48);
    scr_ui_text(_x + 40, _y + 43, "Yes", _yes ? MENU_GOLD_COL : c_white);
    if (!_yes) scr_menu_draw_cursor(_x + 28, _y + 64);
    scr_ui_text(_x + 40, _y + 59, "No", (!_yes) ? MENU_GOLD_COL : c_white);
    scr_ui_text(_x + MENU_PAD, _y + _h - 16, "[Z] Confirm   [X] Cancel", MENU_DIM_COL);
    exit;
}

var _list_y = _y + 20;
for (var _i = 0; _i < SAVE_SLOT_COUNT; _i++) {
    var _info = (array_length(slots) > _i) ? slots[_i] : { exists: false, ok: false, empty: true, corrupt: false, location_name: "", lead_level: 1, playtime_seconds: 0, gold: 0 };
    var _row = _list_y + _i * MENU_SAVE_SLOT_H;
    var _sel = (_i == index);
    if (_sel) {
        scr_menu_draw_select_bar(_x + 6, _row - 2, _w - 12, MENU_SAVE_SLOT_H - 2);
        scr_menu_draw_cursor(_x + 16, _row + 8);
    }
    var _label = "Slot " + string(_i + 1);
    var _col = _sel ? MENU_GOLD_COL : c_white;
    if (_info.empty) {
        scr_ui_text(_x + 28, _row, _label, _col);
        scr_ui_text(_x + 28, _row + 12, "Empty", MENU_DIM_COL);
    } else if (_info.corrupt || !_info.ok) {
        scr_ui_text(_x + 28, _row, _label, _col);
        scr_ui_text(_x + 28, _row + 12, "Damaged save", make_color_rgb(200, 80, 80));
    } else {
        scr_ui_text(_x + 28, _row, _label + "   Lv " + string(_info.lead_level), _col);
        var _meta = _info.location_name + "   " + scr_menu_format_playtime(_info.playtime_seconds) + "   " + string(_info.gold) + "g";
        scr_ui_text(_x + 28, _row + 12, _meta, MENU_DIM_COL);
    }
}

if (confirming_overwrite) {
    scr_ui_text(_x + MENU_PAD, _y + _h - 28, "Overwrite this save?", MENU_GOLD_COL);
    var _yes2 = (prompt_index == 0);
    var _ox = _x + 80;
    if (_yes2) scr_menu_draw_cursor(_ox - 12, _y + _h - 12);
    scr_ui_text(_ox, _y + _h - 17, "Yes", _yes2 ? MENU_GOLD_COL : c_white);
    if (!_yes2) scr_menu_draw_cursor(_ox + 48, _y + _h - 12);
    scr_ui_text(_ox + 60, _y + _h - 17, "No", (!_yes2) ? MENU_GOLD_COL : c_white);
} else if (message != "") {
    scr_ui_text(_x + MENU_PAD, _y + _h - 16, message, MENU_GOLD_COL);
} else {
    var _hint = (mode == "load") ? "[Z] Load   [X] Back" : "[Z] Save   [X] Back";
    scr_ui_text(_x + MENU_PAD, _y + _h - 16, _hint, MENU_DIM_COL);
}
