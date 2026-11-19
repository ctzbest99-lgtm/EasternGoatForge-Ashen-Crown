/// obj_inventory_menu : Step
if (global.game.frame == opened_frame) exit; // the press that opened the menu cannot act in it
var _close = scr_input_menu_pressed();

if (mode == "target" || mode == "pick") {
    if (scr_input_cancel_pressed() || _close) {
        mode = (mode == "pick") ? "slots" : "list";
        message = "";
        exit;
    }
} else if (scr_input_cancel_pressed() || _close) {
    instance_destroy();
    exit;
}

// Q/E always cycle tabs. Left/right cycle tabs on Items/Key/Materials; on Equip they switch member.
var _tabdir = 0;
if (scr_input_tab_prev_pressed()) _tabdir = -1;
if (scr_input_tab_next_pressed()) _tabdir = 1;
if (mode == "list" && tab != 1) {
    if (scr_input_left_pressed()) _tabdir = -1;
    if (scr_input_right_pressed()) _tabdir = 1;
}
if (_tabdir != 0 && mode != "target" && mode != "pick") {
    tab = (tab + _tabdir + 4) mod 4;
    index = 0;
    scroll = 0;
    slot_index = 0;
    cand_index = 0;
    mode = (tab == 1) ? "slots" : "list";
    message = "";
}

var _items = scr_menu_inv_list(tab);

if (tab != 1 && mode == "list") {
    var _n = array_length(_items);
    if (scr_input_up_pressed() && _n > 0) index = (index - 1 + _n) mod _n;
    if (scr_input_down_pressed() && _n > 0) index = (index + 1) mod _n;
    if (index >= _n) index = max(0, _n - 1);
    if (index < scroll) scroll = index;
    if (index >= scroll + MENU_INV_LIST_ROWS) scroll = index - MENU_INV_LIST_ROWS + 1;
    if (scr_input_confirm_pressed() && _n > 0 && tab == 0) {
        var _id = _items[index];
        if (scr_item_is_consumable(_id)) {
            var _who = scr_party_members_for_item(_id);
            if (array_length(_who) == 0) message = "No one to use that on.";
            else { mode = "target"; target_index = 0; message = ""; }
        } else if (scr_item_is_equipment(_id)) {
            tab = 1;
            mode = "slots";
            message = "";
            // Prefer the slot this item would fill, and highlight it as a candidate if possible.
            var _item_slot = scr_item_slot(_id);
            var _slot_names = scr_equipment_slots();
            for (var _s = 0; _s < array_length(_slot_names); _s++) {
                if (_slot_names[_s] == _item_slot) slot_index = _s;
                if (_item_slot == "accessory" && _slot_names[_s] == "accessory_1") slot_index = _s;
            }
        }
    }
}

if (mode == "target") {
    var _id2 = (array_length(_items) > index) ? _items[index] : "";
    var _who2 = scr_party_members_for_item(_id2);
    var _tn = array_length(_who2);
    if (_tn == 0) { mode = "list"; exit; }
    if (scr_input_up_pressed()) target_index = (target_index - 1 + _tn) mod _tn;
    if (scr_input_down_pressed()) target_index = (target_index + 1) mod _tn;
    if (target_index >= _tn) target_index = max(0, _tn - 1);
    if (scr_input_confirm_pressed()) {
        message = scr_item_use_on(_who2[target_index], _id2);
        mode = "list";
        var _now = scr_menu_inv_list(tab);
        if (index >= array_length(_now)) index = max(0, array_length(_now) - 1);
    }
}

if (tab == 1) {
    var _party = scr_menu_inv_party();
    var _pn = array_length(_party);
    if (_pn == 0) exit;
    if (member_index >= _pn) member_index = 0;

    if (mode == "slots") {
        if (scr_input_left_pressed()) member_index = (member_index - 1 + _pn) mod _pn;
        if (scr_input_right_pressed()) member_index = (member_index + 1) mod _pn;
        if (scr_input_up_pressed()) slot_index = (slot_index - 1 + 7) mod 7;
        if (scr_input_down_pressed()) slot_index = (slot_index + 1) mod 7;
        if (scr_input_confirm_pressed()) {
            var _cands = scr_menu_inv_candidates(_party[member_index], slot_index);
            if (array_length(_cands) == 0) {
                message = "Nothing to equip.";
            } else {
                mode = "pick";
                cand_index = 0;
                cand_scroll = 0;
                message = "";
            }
        }
    } else if (mode == "pick") {
        var _cands2 = scr_menu_inv_candidates(_party[member_index], slot_index);
        var _cn = array_length(_cands2);
        if (_cn == 0) { mode = "slots"; exit; }
        if (scr_input_up_pressed()) cand_index = (cand_index - 1 + _cn) mod _cn;
        if (scr_input_down_pressed()) cand_index = (cand_index + 1) mod _cn;
        if (cand_index >= _cn) cand_index = max(0, _cn - 1);
        var _visible = 2;
        if (cand_index < cand_scroll) cand_scroll = cand_index;
        if (cand_index >= cand_scroll + _visible) cand_scroll = cand_index - _visible + 1;
        if (scr_input_confirm_pressed()) {
            message = scr_item_equip_to(_party[member_index], _cands2[cand_index]);
            mode = "slots";
        }
    }
}
