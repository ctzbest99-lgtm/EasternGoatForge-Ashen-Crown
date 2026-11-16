/// scr_shop_data — data-driven shop tables.
/// Marda sells Minor Potion and Antidote (CHAPTER1_SCRIPT.md §1.4, confirmed).
/// Pell sells basic Chapter 1 weapons and armor from the item art / placeholder item DB
/// (Iron Sword, Leather Armor, Iron Helm). Official stock and prices are still open.

function scr_shop_get(_shop_id) {
    switch (_shop_id) {
        case "shop_greyhaven_store":
            return {
                shop_id: "shop_greyhaven_store",
                name: "General Store",
                keeper: "Marda",
                items: ["item_minor_potion", "item_antidote"],
                lines_buy: ["Coin's still coin, Kael.", "Even now."],
                lines_sell: ["Everything went up.", "Including the roof."]
            };
        case "shop_greyhaven_forge":
            return {
                shop_id: "shop_greyhaven_forge",
                name: "Tomas's Forge",
                keeper: "Pell",
                // PLACEHOLDER stock: Chapter 1 equipment that has art and is not a unique reward.
                items: ["item_iron_sword", "item_leather_armor", "item_iron_helm"],
                lines_buy: ["His tools are mostly fine.", "Iron's tougher than people."],
                lines_sell: ["His tools are mostly fine.", "Iron's tougher than people."]
            };
        case "shop_wrenfield_store":
            // Len, Wrenfield (CHAPTER2_SCRIPT.md: "Minor Potion, Antidote, and any mid-tier items
            // Design wants for level 8–10"). Ether and Chain Mail are PLACEHOLDER picks / prices.
            // Opened by the Chapter 2 room wiring (only after the rescue; WF_STORE_SHUT before).
            return {
                shop_id: "shop_wrenfield_store",
                name: "Len's Goods",
                keeper: "Len",
                items: ["item_minor_potion", "item_antidote", "item_ether", "item_chain_mail"],
                lines_buy: ["Shelves are the same.", "Prices are the same."],
                lines_sell: ["Shelves are the same.", "Prices are the same."]
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

/// Every bag item, including unsellable / key rows (those are drawn disabled).
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
        var _price = scr_item_sell_price(_e.item_id);
        var _can = (!_key && _it.sellable && _price > 0);
        array_push(_out, { item_id: _e.item_id, name: _it.name, qty: _e.qty, price: _price, unsellable: !_can, key_item: _key });
    }
    return _out;
}

function scr_shop_buy(_item_id, _qty) {
    scr_game_state_init();
    var _n = max(1, floor(_qty));
    var _it = scr_item_get(_item_id);
    var _price = scr_item_buy_price(_item_id);
    if (_price <= 0) { scr_audio_sfx("menu_error", 0, 0.8); return "That isn't for sale."; }
    var _total = _price * _n;
    if (global.game.gold < _total) { scr_audio_sfx("menu_error", 0, 0.8); return "Not enough gold."; }
    if (_it.key_item && scr_inventory_has(_item_id)) { scr_audio_sfx("menu_error", 0, 0.8); return "You already have that."; }
    global.game.gold -= _total;
    scr_inventory_add(_it.item_id, _it.name, _n, _it.key_item);
    return "Bought " + _it.name + " x" + string(_n) + ".";
}

function scr_shop_sell(_item_id, _qty) {
    scr_game_state_init();
    var _it = scr_item_get(_item_id);
    if (_it.key_item || !_it.sellable) { scr_audio_sfx("menu_error", 0, 0.8); return "You can't sell that."; }
    var _have = scr_inventory_count(_item_id);
    var _n = clamp(floor(_qty), 1, _have);
    if (_n <= 0) { scr_audio_sfx("menu_error", 0, 0.8); return "You don't have that."; }
    var _unit = scr_item_sell_price(_item_id);
    if (_unit <= 0) { scr_audio_sfx("menu_error", 0, 0.8); return "You can't sell that."; }
    if (!scr_inventory_remove(_item_id, _n, false)) { scr_audio_sfx("menu_error", 0, 0.8); return "You can't sell that."; }
    global.game.gold += _unit * _n;
    return "Sold " + _it.name + " x" + string(_n) + ".";
}

/// Inn rest (PLACEHOLDER price). Offers a Yes / No choice; on Yes with enough gold, restores HP
/// and MP for the active party and reserve, clears overworld poison, and takes the gold.
/// `_lines` are the keeper's lines shown before the choice (the last one carries the choice).
function scr_inn_offer(_keeper, _price, _lines = undefined) {
    scr_game_state_init();
    var _ask = "Rest for the night? " + string(_price) + " gold. (You have " + string(global.game.gold) + ".)";
    var _all = is_array(_lines) ? _lines : [];
    var _show = [];
    for (var _i = 0; _i < array_length(_all); _i++) array_push(_show, _all[_i]);
    array_push(_show, _ask);
    var _cb = method({ keeper: _keeper, price: _price }, function(_idx) {
        if (_idx != 0) return;
        if (global.game.gold < price) {
            scr_dialogue_open(["Not enough gold."], keeper);
            return;
        }
        global.game.gold -= price;
        scr_inn_rest_party();
        scr_dialogue_open(["You rest until morning. HP and MP are fully restored."], "");
    });
    return scr_dialogue_choice(_show, _keeper, ["Rest (" + string(_price) + "g)", "Leave"], _cb);
}

function scr_inn_rest_party() {
    var _lists = [global.game.party, global.game.reserve];
    for (var _l = 0; _l < 2; _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            var _a = _list[_i];
            if (!is_struct(_a)) continue;
            _a.hp = _a.max_hp;
            if (variable_struct_exists(_a, "max_mp")) _a.mp = _a.max_mp;
            _a.poisoned = false;
        }
    }
}
