/// scr_equipment — what each member wears, and the stats that follow from it. Pure data and arithmetic, so
/// bonuses, swapping and the bag accounting can be tested without a window.
///
/// An item is equipment when its scr_item_data entry has a `slot`. That keeps one table of things you can
/// own: the shop sells equipment out of the same stock list, and the bag counts it the same way as potions.
/// A worn piece lives on the actor as an id only — the numbers are read back from the item table, so
/// retuning an item changes every member already wearing it and a save can never carry stale stats.

/// @desc The slots a member has, in display order.
function scr_equipment_slots() {
    return ["weapon", "offhand", "armour"];
}

/// @desc Display name of a slot, so "offhand" reads as a shield on screen.
function scr_equipment_slot_name(_slot) {
    switch (_slot) {
        case "weapon": return "Weapon";
        case "offhand": return "Shield";
        case "armour": return "Armour";
    }
    return "?";
}

/// @desc Nothing worn.
function scr_equipment_create() {
    return { weapon: "", offhand: "", armour: "" };
}

/// @desc The actor's worn ids, created on first use so a debug actor or a save from before equipment
/// existed still answers every question below.
function scr_equipment_ensure(_actor) {
    if (!variable_struct_exists(_actor, "equipment") || !is_struct(_actor.equipment)) {
        _actor.equipment = scr_equipment_create();
    }
    return _actor.equipment;
}

/// @desc True when _item_id is equipment that belongs in _slot.
function scr_equipment_fits(_slot, _item_id) {
    if (_item_id == "" || is_undefined(_item_id)) return false;
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data) || !variable_struct_exists(_data, "slot")) return false;
    return (_data.slot == _slot);
}

/// @desc The id worn in _slot, or "" when the slot is empty or holds something that does not belong there
/// — a removed item or a hand-edited save contributes nothing rather than a mystery bonus.
function scr_equipment_worn(_actor, _slot) {
    var _worn = scr_equipment_ensure(_actor);
    if (!variable_struct_exists(_worn, _slot)) return "";
    if (!scr_equipment_fits(_slot, _worn[_slot])) return "";
    return _worn[_slot];
}

/// @desc Total attack and defense from what the actor wears: { attack, defense }.
function scr_equipment_bonus(_actor) {
    var _attack = 0;
    var _defense = 0;
    var _slots = scr_equipment_slots();
    for (var _i = 0; _i < array_length(_slots); _i++) {
        var _id = scr_equipment_worn(_actor, _slots[_i]);
        if (_id == "") continue;
        var _data = scr_item_data(_id);
        if (variable_struct_exists(_data, "attack")) _attack += _data.attack;
        if (variable_struct_exists(_data, "defense")) _defense += _data.defense;
    }
    return { attack: _attack, defense: _defense };
}

/// @desc Attack including equipment. The base stat is never mutated, so taking a piece off is exact and a
/// level-up applies to the same base the equipment was added to.
function scr_actor_attack(_actor) {
    return _actor.attack + scr_equipment_bonus(_actor).attack;
}

/// @desc Defense including equipment, for the same reason as scr_actor_attack.
function scr_actor_defense(_actor) {
    return _actor.defense + scr_equipment_bonus(_actor).defense;
}

/// @desc Equip one unit of _item_id from _inventory, returning the piece it replaces to the bag. Returns
/// { ok, message, replaced }. A refusal (not carried, not equipment) changes nothing.
function scr_equip(_inventory, _actor, _item_id) {
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data) || !variable_struct_exists(_data, "slot")) {
        return { ok: false, message: "That cannot be equipped.", replaced: "" };
    }
    var _slot = _data.slot;
    if (!scr_equipment_fits(_slot, _item_id)) return { ok: false, message: "That does not go there.", replaced: "" };
    if (scr_inventory_count(_inventory, _item_id) <= 0) {
        return { ok: false, message: "You do not carry one.", replaced: "" };
    }
    var _worn = scr_equipment_ensure(_actor);
    var _old = scr_equipment_worn(_actor, _slot);
    scr_inventory_remove(_inventory, _item_id, 1);
    var _message = _actor.name + " equips " + _data.name + " (" + scr_equipment_bonus_text(_data) + ").";
    if (_old != "") {
        /// Swap, not discard: the piece that was worn is still yours.
        scr_inventory_add(_inventory, _old, 1);
        _message += " " + scr_item_data(_old).name + " goes back in the bag.";
    }
    _worn[_slot] = _item_id;
    return { ok: true, message: _message, replaced: _old };
}

/// @desc Take a slot's piece off and put it back in the bag. Returns { ok, message }.
function scr_unequip(_inventory, _actor, _slot) {
    var _worn = scr_equipment_ensure(_actor);
    if (!variable_struct_exists(_worn, _slot)) return { ok: false, message: "There is no such slot." };
    if (scr_equipment_worn(_actor, _slot) == "") return { ok: false, message: "That slot is empty." };
    var _id = _worn[_slot];
    _worn[_slot] = "";
    scr_inventory_add(_inventory, _id, 1);
    return { ok: true, message: _actor.name + " puts away " + scr_item_data(_id).name + "." };
}

/// @desc "+3 ATK", "+3 DEF", "+1 ATK +2 DEF", or "no bonus" for one piece of equipment.
function scr_equipment_bonus_text(_data) {
    var _text = "";
    if (variable_struct_exists(_data, "attack") && _data.attack != 0) {
        _text += "+" + string(_data.attack) + " ATK";
    }
    if (variable_struct_exists(_data, "defense") && _data.defense != 0) {
        if (_text != "") _text += " ";
        _text += "+" + string(_data.defense) + " DEF";
    }
    if (_text == "") return "no bonus";
    return _text;
}

/// @desc One piece's own numbers: { attack, defense }, and zeros for anything that cannot be worn.
function scr_equipment_piece_stats(_item_id) {
    var _data = scr_item_data(_item_id);
    if (is_undefined(_data) || !scr_item_is_equipment(_item_id)) return { attack: 0, defense: 0 };
    return {
        attack: variable_struct_exists(_data, "attack") ? _data.attack : 0,
        defense: variable_struct_exists(_data, "defense") ? _data.defense : 0
    };
}

/// @desc What wearing _item_id would change, against what this actor has in that slot now: { attack,
/// defense }. Only the piece's own slot is replaced, so the delta is the difference between the two pieces
/// and every other slot is untouched. A swap that costs something reads as a loss before it is confirmed.
function scr_equipment_compare(_actor, _item_id) {
    if (!scr_item_is_equipment(_item_id)) return { attack: 0, defense: 0 };
    var _slot = scr_item_data(_item_id).slot;
    var _next = scr_equipment_piece_stats(_item_id);
    var _now = scr_equipment_piece_stats(scr_equipment_worn(_actor, _slot));
    return { attack: _next.attack - _now.attack, defense: _next.defense - _now.defense };
}

/// @desc A signed change as text: "+3 ATK", "-2 ATK +3 DEF", or "no change" when the swap is even.
function scr_equipment_delta_text(_attack, _defense) {
    var _text = "";
    if (_attack != 0) _text += ((_attack > 0) ? "+" : "") + string(_attack) + " ATK";
    if (_defense != 0) {
        if (_text != "") _text += " ";
        _text += ((_defense > 0) ? "+" : "") + string(_defense) + " DEF";
    }
    if (_text == "") return "no change";
    return _text;
}

/// @desc The change one carried piece would make, as text for the equip list.
function scr_equipment_compare_text(_actor, _item_id) {
    if (is_undefined(_actor) || !scr_item_is_equipment(_item_id)) return "cannot be worn";
    var _delta = scr_equipment_compare(_actor, _item_id);
    return scr_equipment_delta_text(_delta.attack, _delta.defense);
}

/// @desc One line of worn gear: "Weapon Iron Blade   Shield -   Armour -".
function scr_equipment_row(_actor) {
    var _slots = scr_equipment_slots();
    var _text = "";
    for (var _i = 0; _i < array_length(_slots); _i++) {
        var _id = scr_equipment_worn(_actor, _slots[_i]);
        var _name = (_id == "") ? "-" : scr_item_data(_id).name;
        if (_i > 0) _text += "   ";
        _text += scr_equipment_slot_name(_slots[_i]) + " " + _name;
    }
    return _text;
}

/// @desc Base stats with the equipment bonus in brackets when there is one: "ATK 9 (+3)   DEF 5 (+3)".
/// Showing base and bonus apart keeps it obvious what a piece is worth and what a level gives.
function scr_equipment_stat_text(_actor) {
    var _bonus = scr_equipment_bonus(_actor);
    var _text = "ATK " + string(_actor.attack);
    if (_bonus.attack != 0) _text += " (+" + string(_bonus.attack) + ")";
    _text += "   DEF " + string(_actor.defense);
    if (_bonus.defense != 0) _text += " (+" + string(_bonus.defense) + ")";
    return _text;
}
