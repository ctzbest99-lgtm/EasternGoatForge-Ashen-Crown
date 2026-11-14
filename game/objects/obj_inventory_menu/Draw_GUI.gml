/// obj_inventory_menu : Draw GUI
scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
scr_menu_draw_dim(_gw, _gh);

var _x = MENU_INV_X;
var _y = MENU_INV_Y;
var _w = MENU_INV_W;
var _h = MENU_INV_H;
scr_menu_draw_window(_x, _y, _w, _h, "inventory");
scr_ui_text(_x + MENU_PAD, _y + 4, "Inventory", MENU_GOLD_COL);
scr_ui_text(_x + _w - 96, _y + 4, "Gold " + string(global.game.gold), c_white);

var _inv = global.game.inventory;
var _list_y = _y + MENU_TITLE_H + 2;
var _list_w = (mode == "target") ? 168 : (_w - 16);
if (array_length(_inv) == 0) {
    scr_ui_text(_x + 12, _list_y, "(empty)", MENU_DIM_COL);
} else {
    var _start = scroll;
    var _shown = 0;
    for (var _i = _start; _i < array_length(_inv) && _shown < MENU_INV_LIST_ROWS; _i++) {
        var _it = _inv[_i];
        var _row = _list_y + _shown * MENU_ROW_H;
        if (_i == index) {
            scr_menu_draw_select_bar(_x + 6, _row - 1, _list_w, MENU_ROW_H);
            if (mode == "list") scr_menu_draw_cursor(_x + 16, _row + 5);
        }
        var _spr = scr_ch1_item_sprite(_it.item_id);
        if (scr_sprite_is_valid(_spr)) {
            draw_sprite_ext(_spr, 0, _x + 26, _row + 4, 0.75, 0.75, 0, c_white, 1);
        }
        var _nm = variable_struct_exists(_it, "name") ? _it.name : _it.item_id;
        var _qty = variable_struct_exists(_it, "qty") ? _it.qty : 1;
        var _key = variable_struct_exists(_it, "key_item") && _it.key_item;
        if (_key) _nm = _nm + "  [Key]";
        if (_qty > 1) _nm = _nm + "  x" + string(_qty);
        var _col = (_i == index) ? MENU_GOLD_COL : c_white;
        scr_ui_text(_x + 38, _row, _nm, _col);
        _shown += 1;
    }
}

if (mode == "target" && array_length(_inv) > 0 && index < array_length(_inv)) {
    var _id = _inv[index].item_id;
    var _who = scr_party_members_for_item(_id);
    var _px = _x + 180;
    scr_ui_text(_px, _list_y - 2, scr_item_is_equipment(_id) ? "Equip" : "Use", MENU_GOLD_COL);
    for (var _t = 0; _t < array_length(_who); _t++) {
        var _row2 = _list_y + 10 + _t * MENU_ROW_H;
        var _sel = (_t == target_index);
        if (_sel) {
            scr_menu_draw_select_bar(_px - 4, _row2 - 1, _w - 188, MENU_ROW_H);
            scr_menu_draw_cursor(_px + 4, _row2 + 5);
        }
        var _line = scr_item_is_equipment(_id) ? scr_item_preview_line(_who[_t], _id) : (_who[_t].name + "  " + string(_who[_t].hp) + "/" + string(_who[_t].max_hp));
        scr_ui_text(_px + 14, _row2, _line, _sel ? MENU_GOLD_COL : c_white);
    }
} else if (array_length(_inv) > 0 && index < array_length(_inv)) {
    var _desc = scr_item_get(_inv[index].item_id).desc;
    if (_desc != "") scr_ui_text(_x + 10, _y + _h - 26, _desc, MENU_DIM_COL);
}

if (message != "") {
    scr_ui_text(_x + 10, _y + _h - 14, message, MENU_GOLD_COL);
} else {
    var _hint = (mode == "target") ? "[Z] Confirm   [X] Back" : "[Z] Use / Equip   [I/X] Close";
    scr_ui_text(_x + 10, _y + _h - 14, _hint, MENU_DIM_COL);
}
