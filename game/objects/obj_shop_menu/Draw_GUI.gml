/// obj_shop_menu : Draw GUI
scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
scr_menu_draw_dim(_gw, _gh);

var _x = MENU_SHOP_X;
var _y = MENU_SHOP_Y;
var _w = MENU_SHOP_W;
var _h = MENU_SHOP_H;
scr_menu_draw_window(_x, _y, _w, _h, "shop");

var _title = is_struct(shop) ? shop.name : "Shop";
scr_ui_text(_x + MENU_PAD, _y + 4, _title, MENU_GOLD_COL);
scr_ui_text(_x + _w - 96, _y + 4, "Gold " + string(global.game.gold), c_white);

var _tabs = ["Buy", "Sell", "Exit"];
var _tab_y = _y + MENU_TITLE_H + 2;
for (var _t = 0; _t < 3; _t++) {
    var _ty = _tab_y + _t * MENU_ROW_H;
    var _sel = (tab == _t) && (mode == "root");
    if (_sel) {
        scr_menu_draw_select_bar(_x + 4, _ty - 1, MENU_SHOP_TAB_W, MENU_ROW_H);
        scr_menu_draw_cursor(_x + 12, _ty + 5);
    }
    var _col = _sel ? MENU_GOLD_COL : ((tab == _t && mode != "root") ? MENU_GOLD_COL : c_white);
    scr_ui_text(_x + 20, _ty, _tabs[_t], _col);
}

var _lx = _x + MENU_SHOP_LIST_X;
var _ly = _tab_y;
var _lw = _w - MENU_SHOP_LIST_X - MENU_PAD;
var _buy_ids = (is_struct(shop) && is_array(shop.items)) ? shop.items : [];
var _sell_list = scr_shop_sellable_list();
var _n = 0;
if (tab == 2) {
    scr_ui_text(_lx, _ly, "Leave the shop.", MENU_DIM_COL);
} else if (tab == 1 && array_length(_sell_list) == 0) {
    scr_ui_text(_lx, _ly, "(nothing to sell)", MENU_DIM_COL);
} else {
    var _count = (tab == 1) ? array_length(_sell_list) : array_length(_buy_ids);
    _n = _count;
    var _start = scroll;
    var _shown = 0;
    for (var _i = _start; _i < _count && _shown < MENU_SHOP_LIST_ROWS; _i++) {
        var _item_id = (tab == 1) ? _sell_list[_i].item_id : _buy_ids[_i];
        var _it = scr_item_get(_item_id);
        var _row = _ly + _shown * MENU_ROW_H;
        var _here = (mode != "root" && _i == index);
        if (_here) {
            scr_menu_draw_select_bar(_lx - 4, _row - 1, _lw, MENU_ROW_H);
            scr_menu_draw_cursor(_lx + 4, _row + 5);
        }
        var _spr = scr_ch1_item_sprite(_item_id);
        if (scr_sprite_is_valid(_spr)) {
            draw_sprite_ext(_spr, 0, _lx + 14, _row + 4, 0.75, 0.75, 0, c_white, 1);
        }
        var _price = (tab == 0) ? scr_item_buy_price(_item_id) : scr_item_sell_price(_item_id);
        var _owned = scr_inventory_count(_item_id);
        var _nm = _it.name;
        var _col2 = _here ? MENU_GOLD_COL : c_white;
        if (tab == 0 && _price > global.game.gold) _col2 = MENU_DISABLED_COL;
        scr_ui_text(_lx + 26, _row, _nm, _col2);
        scr_ui_text(_lx + _lw - 70, _row, string(_price) + "g", _col2);
        scr_ui_text(_lx + _lw - 28, _row, "x" + string(_owned), MENU_DIM_COL);
        _shown += 1;
    }
}

// Detail / quantity / equipment preview along the bottom of the list pane.
var _dx = _lx;
var _dy = _y + _h - 52;
if (mode != "root" && tab < 2 && _n > 0 && index >= 0 && index < _n) {
    var _sid = (tab == 1) ? _sell_list[index].item_id : _buy_ids[index];
    var _detail = scr_item_get(_sid);
    scr_ui_text(_dx, _dy, _detail.desc, MENU_DIM_COL);
    if (scr_item_is_equipment(_sid)) {
        var _who = scr_party_members_for_item(_sid);
        var _ey = _dy + 11;
        if (array_length(_who) == 0) {
            var _need = "";
            if (is_array(_detail.weapon_categories) && array_length(_detail.weapon_categories) > 0) {
                _need = "Requires: " + _detail.weapon_categories[0];
            }
            scr_ui_text(_dx, _ey, (_need == "") ? "No one in the party can equip this." : _need, MENU_DIM_COL);
        } else {
            for (var _wi = 0; _wi < array_length(_who) && _wi < 2; _wi++) {
                scr_ui_text(_dx, _ey + _wi * 10, scr_item_preview_line(_who[_wi], _sid), c_white);
            }
        }
    }
    if (mode == "qty") {
        var _unit = (tab == 0) ? scr_item_buy_price(_sid) : scr_item_sell_price(_sid);
        var _total = _unit * qty;
        var _verb = (tab == 0) ? "Buy" : "Sell";
        scr_ui_text(_dx, _y + _h - 16, _verb + "  < " + string(qty) + " >   " + string(_total) + "g   [Z] Confirm", MENU_GOLD_COL);
    }
}

if (message != "" && mode != "qty") {
    scr_ui_text(_x + MENU_PAD, _y + _h - 16, message, MENU_GOLD_COL);
} else if (mode == "root") {
    scr_ui_text(_x + MENU_PAD, _y + _h - 16, "[Z] Select   [X] Leave", MENU_DIM_COL);
} else if (mode == "list") {
    scr_ui_text(_x + MENU_PAD, _y + _h - 16, "[Z] Quantity   [X] Back", MENU_DIM_COL);
}
