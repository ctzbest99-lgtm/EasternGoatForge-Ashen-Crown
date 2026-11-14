/// scr_shop_data — data-driven shop tables.
/// Marda sells Minor Potion and Antidote (CHAPTER1_SCRIPT.md §1.4, confirmed).
/// Pell sells basic Chapter 1 weapons and armor from the item art / placeholder item DB
/// (Iron Sword, Leather Armor, Iron Helm). Official stock and prices are still open.

function scr_shop_get(_shop_id) {
    switch (_shop_id) {
        case "shop_greyhaven_store":
            return {
                shop_id: "shop_greyhaven_store",
                name: "Marda's Store",
                keeper: "Marda",
                items: ["item_minor_potion", "item_antidote"]
            };
        case "shop_greyhaven_forge":
            return {
                shop_id: "shop_greyhaven_forge",
                name: "Pell's Forge",
                keeper: "Pell",
                // PLACEHOLDER stock: Chapter 1 equipment that has art and is not a unique reward.
                items: ["item_iron_sword", "item_leather_armor", "item_iron_helm"]
            };
    }
    return undefined;
}

function scr_shop_open(_shop_id) {
    var _shop = scr_shop_get(_shop_id);
    if (!is_struct(_shop)) {
        show_debug_message("[shop] unknown shop_id: " + string(_shop_id));
        return noone;
    }
    if (variable_global_exists("game") && is_struct(global.game)) {
        if (global.game.battle_active || global.game.dialogue_open) {
            // Caller should open after dialogue finishes; do not overlap the box.
        }
    }
    var _inst = scr_menu_open_object("obj_shop_menu");
    if (_inst != noone && instance_exists(_inst)) {
        _inst.shop_id = _shop.shop_id;
        _inst.shop = _shop;
        _inst.mode = "root";
        _inst.tab = 0;
        _inst.index = 0;
        _inst.qty = 1;
        _inst.message = "";
    }
    return _inst;
}

function scr_shop_sellable_list() {
    scr_game_state_init();
    var _out = [];
    var _inv = global.game.inventory;
    if (!is_array(_inv)) return _out;
    for (var _i = 0; _i < array_length(_inv); _i++) {
        var _e = _inv[_i];
        if (!is_struct(_e)) continue;
        var _it = scr_item_get(_e.item_id);
        var _key = (variable_struct_exists(_e, "key_item") && _e.key_item) || _it.key_item;
        if (_key || !_it.sellable) continue;
        var _price = scr_item_sell_price(_e.item_id);
        if (_price <= 0) continue;
        array_push(_out, { item_id: _e.item_id, name: _it.name, qty: _e.qty, price: _price });
    }
    return _out;
}

function scr_shop_buy(_item_id, _qty) {
    scr_game_state_init();
    var _n = max(1, floor(_qty));
    var _it = scr_item_get(_item_id);
    var _price = scr_item_buy_price(_item_id);
    if (_price <= 0) return "That isn't for sale.";
    var _total = _price * _n;
    if (global.game.gold < _total) return "Not enough gold.";
    if (_it.key_item && scr_inventory_has(_item_id)) return "You already have that.";
    global.game.gold -= _total;
    scr_inventory_add(_it.item_id, _it.name, _n, _it.key_item);
    return "Bought " + _it.name + " x" + string(_n) + ".";
}

function scr_shop_sell(_item_id, _qty) {
    scr_game_state_init();
    var _it = scr_item_get(_item_id);
    if (_it.key_item || !_it.sellable) return "You can't sell that.";
    var _have = scr_inventory_count(_item_id);
    var _n = clamp(floor(_qty), 1, _have);
    if (_n <= 0) return "You don't have that.";
    var _unit = scr_item_sell_price(_item_id);
    if (_unit <= 0) return "You can't sell that.";
    if (!scr_inventory_remove(_item_id, _n, false)) return "You can't sell that.";
    global.game.gold += _unit * _n;
    return "Sold " + _it.name + " x" + string(_n) + ".";
}
