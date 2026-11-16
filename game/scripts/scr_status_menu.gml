/// scr_status_menu — state and view rows for the party status panel, with no input and no drawing.
/// The panel has two views: the member list, and an item list that heals the selected member outside
/// battle. Item use goes through scr_inventory_use, so the field rules are the battle rules: refuse when
/// the heal would do nothing, clamp at max HP, consume exactly one.

enum STATUS_VIEW {
    MEMBERS,
    ITEM
}

/// @desc A closed menu on the member view.
function scr_status_menu_create() {
    return { open: false, cursor: 0, item_cursor: 0, mode: STATUS_VIEW.MEMBERS, message: "" };
}

/// @desc Open on the member list with the cursor at the top, so it always starts where a player looks.
function scr_status_menu_open(_menu) {
    _menu.open = true;
    _menu.cursor = 0;
    _menu.item_cursor = 0;
    _menu.mode = STATUS_VIEW.MEMBERS;
    _menu.message = "";
    return true;
}

function scr_status_menu_close(_menu) {
    _menu.open = false;
    _menu.mode = STATUS_VIEW.MEMBERS;
    _menu.message = "";
    return true;
}

/// @desc Move the member selection, wrapping. Inert in the item view.
function scr_status_menu_move(_menu, _delta, _count) {
    if (!_menu.open || _menu.mode != STATUS_VIEW.MEMBERS || _count <= 0 || _delta == 0) return false;
    _menu.cursor = (_menu.cursor + _delta + _count) mod _count;
    return true;
}

/// @desc Move the item selection, wrapping. Inert in the member view.
function scr_status_menu_move_item(_menu, _delta, _count) {
    if (!_menu.open || _menu.mode != STATUS_VIEW.ITEM || _count <= 0 || _delta == 0) return false;
    _menu.item_cursor = (_menu.item_cursor + _delta + _count) mod _count;
    return true;
}

/// @desc One menu at a time: never over a battle, and never twice.
function scr_status_menu_can_open(_battle_active, _menu_open) {
    return (!_battle_active && !_menu_open);
}

/// @desc The party inventory, tolerating a party struct from before items existed.
function scr_status_inventory(_party) {
    if (!variable_struct_exists(_party, "items")) return [];
    return _party.items;
}

/// @desc The member the panel is acting on.
function scr_status_menu_member(_party, _menu) {
    var _count = array_length(_party.members);
    if (_count <= 0) return undefined;
    return _party.members[clamp(_menu.cursor, 0, _count - 1)];
}

/// @desc Open the item list. Refuses with a message when the bag is empty.
function scr_status_menu_open_items(_menu, _party) {
    if (!_menu.open || _menu.mode == STATUS_VIEW.ITEM) return false;
    if (array_length(scr_inventory_usable(scr_status_inventory(_party))) == 0) {
        _menu.message = "No items.";
        return false;
    }
    _menu.mode = STATUS_VIEW.ITEM;
    _menu.item_cursor = 0;
    _menu.message = "";
    return true;
}

/// @desc Back to the member list.
function scr_status_menu_close_items(_menu) {
    if (_menu.mode != STATUS_VIEW.ITEM) return false;
    _menu.mode = STATUS_VIEW.MEMBERS;
    _menu.message = "";
    return true;
}

/// @desc Use the selected item on the selected member. Returns true when something was consumed.
/// A refusal keeps the list open with the reason, exactly like the battle submenu, so nothing is
/// thrown away by a mistimed confirm.
function scr_status_menu_use_item(_menu, _party, _actor) {
    if (_menu.mode != STATUS_VIEW.ITEM || is_undefined(_actor)) return false;
    var _inventory = scr_status_inventory(_party);
    var _usable = scr_inventory_usable(_inventory);
    if (array_length(_usable) == 0) {
        scr_status_menu_close_items(_menu);
        _menu.message = "No items.";
        return false;
    }
    var _index = min(_menu.item_cursor, array_length(_usable) - 1);
    var _item_id = _usable[_index].id;
    var _data = scr_item_data(_item_id);
    var _result = scr_inventory_use(_inventory, _actor, _item_id);
    if (!_result.used) {
        _menu.message = _data.name + ": " + _result.message + ".";
        return false;
    }
    _menu.message = _actor.name + " uses " + _data.name + " and recovers " + string(_result.healed) + " HP.";
    /// An empty bag leaves no list to show, so drop back to the members but keep the message.
    if (array_length(scr_inventory_usable(_inventory)) == 0) {
        var _kept = _menu.message;
        scr_status_menu_close_items(_menu);
        _menu.message = _kept;
    }
    return true;
}

/// @desc One display row per party member, in party order.
function scr_status_rows(_party) {
    var _rows = [];
    var _count = array_length(_party.members);
    for (var _i = 0; _i < _count; _i++) {
        var _actor = _party.members[_i];
        array_push(_rows, {
            name: _actor.name,
            level_text: "Lv" + string(_actor.level),
            hp_text: scr_hud_hp_line(_actor),
            xp_text: scr_hud_xp_line(_actor),
            stats_text: "ATK " + string(_actor.attack) + "   DEF " + string(_actor.defense),
            alive: _actor.hp > 0
        });
    }
    return _rows;
}
