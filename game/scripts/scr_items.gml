/// scr_items — item definitions and the party inventory. Pure data, so both can be tested and saved.
/// An inventory is an array of stacks: { id, count }. Unknown ids are ignored everywhere, so a bad
/// save entry or a removed item cannot poison the list.

/// @desc Item definition, or undefined for an unknown id.
function scr_item_data(_item_id) {
    switch (_item_id) {
        case "potion":
            return { id: "potion", name: "Potion", heal: 12, price: 12, description: "Restores 12 HP." };
        case "hi_potion":
            return { id: "hi_potion", name: "Hi-Potion", heal: 32, price: 45, description: "Restores 32 HP." };
        /// The revive item: `heal` is 0 and `revive` is the fraction of max HP the member comes back with.
        /// Keeping them separate is what stops the healing items from doubling as revives.
        case "ember_draught":
            return { id: "ember_draught", name: "Ember Draught", heal: 0, revive: 0.3, price: 60, description: "Revives a fallen ally with 30% HP." };
    }
    return undefined;
}

/// @desc Every item id, in menu order.
function scr_item_ids() {
    return ["potion", "hi_potion", "ember_draught"];
}

/// @desc An empty inventory.
function scr_inventory_create() {
    return [];
}

/// @desc Index of _item_id in the inventory, or -1.
function scr_inventory_index(_inventory, _item_id) {
    var _count = array_length(_inventory);
    for (var _i = 0; _i < _count; _i++) {
        if (_inventory[_i].id == _item_id) return _i;
    }
    return -1;
}

/// @desc Add items, merging into an existing stack. Returns the stack's new count (0 for a bad request).
function scr_inventory_add(_inventory, _item_id, _count = 1) {
    var _amount = floor(_count);
    if (is_undefined(scr_item_data(_item_id)) || _amount <= 0) return 0;
    var _index = scr_inventory_index(_inventory, _item_id);
    if (_index < 0) {
        array_push(_inventory, { id: _item_id, count: _amount });
        return _amount;
    }
    _inventory[_index].count += _amount;
    return _inventory[_index].count;
}

/// @desc How many of _item_id the inventory holds.
function scr_inventory_count(_inventory, _item_id) {
    var _index = scr_inventory_index(_inventory, _item_id);
    return (_index < 0) ? 0 : _inventory[_index].count;
}

/// @desc Remove _count of _item_id. Returns false and changes nothing when there are not enough.
/// Empty stacks are dropped, so the menu never lists a zero.
function scr_inventory_remove(_inventory, _item_id, _count = 1) {
    var _amount = floor(_count);
    var _index = scr_inventory_index(_inventory, _item_id);
    if (_index < 0 || _amount <= 0 || _inventory[_index].count < _amount) return false;
    _inventory[_index].count -= _amount;
    if (_inventory[_index].count <= 0) array_delete(_inventory, _index, 1);
    return true;
}

/// @desc Stacks the menu may show: those with at least one item left.
function scr_inventory_usable(_inventory) {
    var _rows = [];
    var _count = array_length(_inventory);
    for (var _i = 0; _i < _count; _i++) {
        if (_inventory[_i].count > 0) array_push(_rows, _inventory[_i]);
    }
    return _rows;
}

/// @desc True for a revive item, whose effect is `revive` rather than `heal`.
function scr_item_is_revive(_item_id) {
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data)) return false;
    return (variable_struct_exists(_data, "revive") && _data.revive > 0);
}

/// @desc HP a revive brings the actor back with: a fraction of max HP, at least 1.
function scr_item_revive_hp(_actor, _item_id) {
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data) || !scr_item_is_revive(_item_id)) return 0;
    return clamp(max(1, round(_actor.max_hp * _data.revive)), 0, _actor.max_hp);
}

/// @desc True when _item_id would actually change the actor's state, which is what makes both menus
/// refuse to waste an item and a turn. A healing item refuses an actor who is down: otherwise pouring a
/// Potion into a fallen member would raise them off zero and quietly turn every potion into a revive.
function scr_item_can_use(_actor, _item_id) {
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data)) return false;
    if (scr_item_is_revive(_item_id)) return (_actor.hp <= 0);
    if (_actor.hp <= 0) return false;
    return (_data.heal > 0 && _actor.hp < _actor.max_hp);
}

/// @desc Use _item_id from the inventory on _actor. Returns { used, healed, message }; `healed` is the HP
/// actually gained, so a revive from 0 onto 9 HP reports 9.
function scr_inventory_use(_inventory, _actor, _item_id) {
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data)) return { used: false, healed: 0, message: "unknown item" };
    if (scr_inventory_count(_inventory, _item_id) <= 0) return { used: false, healed: 0, message: "none left" };
    if (!scr_item_can_use(_actor, _item_id)) {
        /// Say which refusal it is: full HP, already standing, or down and needing a revive.
        var _why = "HP is already full";
        if (_actor.hp <= 0) _why = (scr_item_is_revive(_item_id) ? "already revived" : "they are down");
        else if (scr_item_is_revive(_item_id)) _why = "they are still standing";
        return { used: false, healed: 0, message: _why };
    }
    var _before = _actor.hp;
    if (scr_item_is_revive(_item_id)) _actor.hp = scr_item_revive_hp(_actor, _item_id);
    else _actor.hp = clamp(_actor.hp + _data.heal, 0, _actor.max_hp);
    scr_inventory_remove(_inventory, _item_id, 1);
    return { used: true, healed: _actor.hp - _before, message: "" };
}
