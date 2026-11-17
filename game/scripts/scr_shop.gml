/// scr_shop — the merchant's wares and the buying rules. Pure data and arithmetic, so prices, refusals and
/// the gold accounting can be tested without a window; obj_shop only draws and reads keys.

/// @desc Everything the merchant sells, in menu order: supplies first, then the gear he keeps under the
/// counter. Equipment is priced from the same item table, so a piece costs what its data says.
function scr_shop_stock() {
    return ["potion", "hi_potion", "ember_draught", "iron_blade", "oak_shield", "warden_mail"];
}

/// @desc Price of one unit, or -1 for something the shop does not sell. Prices come from scr_item_data, so
/// the shop cannot drift out of step with the items it sells.
function scr_shop_price(_item_id) {
    var _stock = scr_shop_stock();
    var _sells = false;
    for (var _i = 0; _i < array_length(_stock); _i++) {
        if (_stock[_i] == _item_id) {
            _sells = true;
            break;
        }
    }
    if (!_sells) return -1;
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data)) return -1;
    return max(0, floor(_data.price));
}

/// @desc A closed shop. `cursor` walks scr_shop_stock().
function scr_shop_create() {
    return { open: false, cursor: 0, message: "" };
}

/// @desc True when the party could pay for one unit.
function scr_shop_can_afford(_party, _item_id) {
    var _price = scr_shop_price(_item_id);
    if (_price < 0) return false;
    return (_party.gold >= _price);
}

/// @desc Buy one unit. Returns { ok, message }. A refusal changes nothing, so a confirmed press that lands
/// twice cannot spend twice, and the gold is checked here rather than trusted from the draw code.
function scr_shop_buy(_party, _item_id) {
    var _price = scr_shop_price(_item_id);
    if (_price < 0) return { ok: false, message: "The merchant does not sell that." };
    var _data = scr_item_data(_item_id);
    if (!scr_shop_can_afford(_party, _item_id)) {
        return { ok: false, message: "Not enough gold for " + _data.name + "." };
    }
    if (!scr_party_spend_gold(_party, _price)) {
        return { ok: false, message: "Not enough gold for " + _data.name + "." };
    }
    scr_inventory_add(_party.items, _item_id, 1);
    return { ok: true, message: "Bought " + _data.name + " for " + string(_price) + " gold." };
}

/// @desc Move the stock cursor, wrapping.
function scr_shop_move(_shop, _delta, _count) {
    if (!_shop.open || _count <= 0 || _delta == 0) return false;
    _shop.cursor = (_shop.cursor + _delta + _count) mod _count;
    return true;
}

/// @desc One panel row: name, price, and how many the party already carries.
function scr_shop_row(_item_id, _party) {
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data)) return "";
    var _price = scr_shop_price(_item_id);
    var _owned = scr_inventory_count(_party.items, _item_id);
    return _data.name + "   " + string(_price) + " gold   have " + string(_owned);
}

/// @desc One shop at a time, never during a battle, a conversation or the status menu.
function scr_shop_can_open(_battle_active, _dialogue_open, _menu_open, _shop_open) {
    if (_battle_active || _dialogue_open || _menu_open) return false;
    return !_shop_open;
}

/// @desc Open the panel. Returns the instance, or noone when it may not open.
function scr_shop_begin() {
    var _battle = (variable_global_exists("battle_active") && global.battle_active);
    var _dialogue = (variable_global_exists("dialogue_open") && global.dialogue_open);
    var _menu = (variable_global_exists("menu_open") && global.menu_open);
    var _open = (variable_global_exists("shop_open") && global.shop_open);
    if (!scr_shop_can_open(_battle, _dialogue, _menu, _open)) return noone;
    var _obj = asset_get_index("obj_shop");
    if (_obj < 0) {
        show_debug_message("scr_shop_begin: obj_shop is not in this project");
        return noone;
    }
    return instance_create_depth(0, 0, -100, _obj);
}
