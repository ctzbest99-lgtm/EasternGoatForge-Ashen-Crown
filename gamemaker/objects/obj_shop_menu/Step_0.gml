/// obj_shop_menu : Step
if (!is_struct(shop)) {
    if (shop_id != "") shop = scr_shop_get(shop_id);
    if (!is_struct(shop)) { instance_destroy(); exit; }
}
if (global.game.frame == opened_frame) exit; // the press that opened the shop cannot buy/sell in it
if (buzz_t > 0) buzz_t -= 1;
if (scr_input_menu_pressed()) { instance_destroy(); exit; }

var _buy_ids = is_array(shop.items) ? shop.items : [];
var _sell_list = scr_shop_sellable_list();

// Q/E or left/right change tabs while browsing the list (qty uses left/right for ±10).
if (mode == "list") {
    var _tdir = 0;
    if (scr_input_tab_prev_pressed() || scr_input_left_pressed()) _tdir = -1;
    if (scr_input_tab_next_pressed() || scr_input_right_pressed()) _tdir = 1;
    if (_tdir != 0) {
        tab = (tab + _tdir + 3) mod 3;
        index = 0;
        scroll = 0;
        message = "";
    }
}

if (scr_input_cancel_pressed()) {
    if (mode == "qty") { mode = "list"; qty = 1; exit; }
    instance_destroy();
    exit;
}

if (mode == "list") {
    var _n = (tab == 1) ? array_length(_sell_list) : ((tab == 0) ? array_length(_buy_ids) : 0);
    if (tab < 2 && _n > 0) {
        if (scr_input_up_pressed()) index = (index - 1 + _n) mod _n;
        if (scr_input_down_pressed()) index = (index + 1) mod _n;
        if (index >= _n) index = max(0, _n - 1);
        if (index < scroll) scroll = index;
        if (index >= scroll + MENU_SHOP_LIST_ROWS) scroll = index - MENU_SHOP_LIST_ROWS + 1;
    }
    if (scr_input_confirm_pressed()) {
        if (tab == 2) { instance_destroy(); exit; }
        if (_n <= 0) exit;
        if (tab == 0) {
            var _id = _buy_ids[index];
            var _price = scr_shop_buy_price(_id);
            if (_price > global.game.gold) { buzz_t = 8; exit; }
            if (scr_item_is_consumable(_id)) {
                qty = 1;
                mode = "qty";
            } else {
                message = scr_shop_buy(_id, 1);
            }
        } else {
            var _row = _sell_list[index];
            if (_row.unsellable) { buzz_t = 8; exit; }
            message = scr_shop_sell(_row.item_id, 1);
            var _now = scr_shop_sellable_list();
            if (index >= array_length(_now)) index = max(0, array_length(_now) - 1);
        }
    }
    exit;
}

if (mode == "qty") {
    _buy_ids = is_array(shop.items) ? shop.items : [];
    if (tab != 0 || index < 0 || index >= array_length(_buy_ids)) { mode = "list"; exit; }
    var _item_id = _buy_ids[index];
    var _price = scr_shop_buy_price(_item_id);
    var _owned = scr_inventory_count(_item_id);
    var _afford = (_price > 0) ? (global.game.gold div _price) : 1;
    var _max_qty = max(1, min(99 - _owned, _afford));
    if (_max_qty < 1) _max_qty = 1;
    if (scr_input_up_pressed()) qty = min(_max_qty, qty + 1);
    if (scr_input_down_pressed()) qty = max(1, qty - 1);
    if (scr_input_right_pressed()) qty = min(_max_qty, qty + 10);
    if (scr_input_left_pressed()) qty = max(1, qty - 10);
    if (qty > _max_qty) qty = _max_qty;
    if (scr_input_confirm_pressed()) {
        message = scr_shop_buy(_item_id, qty);
        mode = "list";
    }
}
