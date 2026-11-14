/// scr_inventory — placeholder bag. Key items cannot be sold or dropped (enforced later).

function scr_inventory_find(_item_id) {
    scr_game_state_init();
    var _inv = global.game.inventory;
    for (var _i = 0; _i < array_length(_inv); _i++) {
        if (is_struct(_inv[_i]) && _inv[_i].item_id == _item_id) return _i;
    }
    return -1;
}

function scr_inventory_has(_item_id) {
    return scr_inventory_find(_item_id) != -1;
}

/// Add an item. Key items are unique: a second add does nothing and returns false.
function scr_inventory_add(_item_id, _name, _qty = 1, _key_item = false) {
    scr_game_state_init();
    var _inv = global.game.inventory;
    var _index = scr_inventory_find(_item_id);
    if (_index != -1) {
        if (_inv[_index].key_item || _key_item) return false;
        _inv[_index].qty += max(1, _qty);
        return true;
    }
    array_push(_inv, {
        item_id: _item_id,
        name: _name,
        qty: max(1, _qty),
        key_item: _key_item
    });
    return true;
}
