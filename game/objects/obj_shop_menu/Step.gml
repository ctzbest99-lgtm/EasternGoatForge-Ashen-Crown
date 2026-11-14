/// obj_shop_menu : Step
if (!is_struct(shop)) {
    if (shop_id != "") shop = scr_shop_get(shop_id);
    if (!is_struct(shop)) {
        instance_destroy();
        exit;
    }
}

var _buy_ids = is_array(shop.items) ? shop.items : [];
var _sell_list = scr_shop_sellable_list();
var _ids = (tab == 1) ? _sell_list : _buy_ids;

if (mode == "root") {
    if (scr_input_up_pressed()) tab = (tab - 1 + 3) mod 3;
    if (scr_input_down_pressed()) tab = (tab + 1) mod 3;
    if (scr_input_cancel_pressed()) {
        instance_destroy();
        exit;
    }
    if (scr_input_confirm_pressed()) {
        if (tab == 2) {
            instance_destroy();
            exit;
        }
        mode = "list";
        index = 0;
        scroll = 0;
        qty = 1;
        message = "";
        if (tab == 1 && array_length(_sell_list) == 0) {
            message = "Nothing to sell.";
            mode = "root";
        }
    }
    exit;
}

if (mode == "list") {
    _ids = (tab == 1) ? scr_shop_sellable_list() : _buy_ids;
    var _n = array_length(_ids);
    if (scr_input_up_pressed() && _n > 0) index = (index - 1 + _n) mod _n;
    if (scr_input_down_pressed() && _n > 0) index = (index + 1) mod _n;
    if (index >= _n) index = max(0, _n - 1);
    if (index < scroll) scroll = index;
    if (index >= scroll + MENU_SHOP_LIST_ROWS) scroll = index - MENU_SHOP_LIST_ROWS + 1;
    if (scr_input_cancel_pressed()) {
        mode = "root";
        message = "";
        exit;
    }
    if (scr_input_confirm_pressed() && _n > 0) {
        qty = 1;
        mode = "qty";
        message = "";
    }
    exit;
}

if (mode == "qty") {
    _ids = (tab == 1) ? scr_shop_sellable_list() : _buy_ids;
    if (index < 0 || index >= array_length(_ids)) {
        mode = "list";
        exit;
    }
    var _item_id = (tab == 1) ? _ids[index].item_id : _ids[index];
    var _max_qty = 99;
    if (tab == 0) {
        var _price = scr_item_buy_price(_item_id);
        if (_price > 0) _max_qty = max(1, global.game.gold div _price);
        _max_qty = min(99, _max_qty);
    } else {
        _max_qty = min(99, _ids[index].qty);
    }
    if (scr_input_left_pressed()) qty = max(1, qty - 1);
    if (scr_input_right_pressed()) qty = min(_max_qty, qty + 1);
    if (scr_input_up_pressed()) qty = min(_max_qty, qty + 5);
    if (scr_input_down_pressed()) qty = max(1, qty - 5);
    if (qty > _max_qty) qty = _max_qty;
    if (qty < 1) qty = 1;
    if (scr_input_cancel_pressed()) {
        mode = "list";
        message = "";
        exit;
    }
    if (scr_input_confirm_pressed()) {
        if (tab == 0) message = scr_shop_buy(_item_id, qty);
        else message = scr_shop_sell(_item_id, qty);
        mode = "list";
        // Refresh sell list after a sale so the cursor stays in range.
        if (tab == 1) {
            var _now = scr_shop_sellable_list();
            if (index >= array_length(_now)) index = max(0, array_length(_now) - 1);
        }
    }
}
