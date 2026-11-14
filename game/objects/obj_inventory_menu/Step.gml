/// obj_inventory_menu : Step
var _inv = global.game.inventory;
var _n = array_length(_inv);

if (scr_input_cancel_pressed() || keyboard_check_pressed(ord("I")) || keyboard_check_pressed(vk_tab)) {
    if (mode == "target") {
        mode = "list";
        message = "";
        exit;
    }
    instance_destroy();
    exit;
}

if (mode == "list") {
    if (scr_input_up_pressed() && _n > 0) index = (index - 1 + _n) mod _n;
    if (scr_input_down_pressed() && _n > 0) index = (index + 1) mod _n;
    if (index >= _n) index = max(0, _n - 1);
    if (index < scroll) scroll = index;
    if (index >= scroll + MENU_INV_LIST_ROWS) scroll = index - MENU_INV_LIST_ROWS + 1;
    if (scr_input_confirm_pressed() && _n > 0) {
        var _it = _inv[index];
        var _id = _it.item_id;
        if (scr_item_is_key(_id) || (variable_struct_exists(_it, "key_item") && _it.key_item)) {
            var _data = scr_item_get(_id);
            message = (_data.desc != "") ? _data.desc : "A key item. It can't be used or sold.";
        } else if (scr_item_is_consumable(_id) || scr_item_is_equipment(_id)) {
            var _who = scr_party_members_for_item(_id);
            if (array_length(_who) == 0) {
                message = scr_item_is_equipment(_id) ? "No one in the party can equip that." : "No one to use that on.";
            } else {
                mode = "target";
                target_index = 0;
                message = scr_item_is_equipment(_id) ? "Equip on whom?" : "Use on whom?";
            }
        } else {
            var _data2 = scr_item_get(_id);
            message = (_data2.desc != "") ? _data2.desc : "Can't use that here.";
        }
    }
    exit;
}

if (mode == "target") {
    if (index < 0 || index >= array_length(_inv)) {
        mode = "list";
        exit;
    }
    var _id2 = _inv[index].item_id;
    var _who2 = scr_party_members_for_item(_id2);
    var _tn = array_length(_who2);
    if (_tn == 0) {
        mode = "list";
        exit;
    }
    if (scr_input_up_pressed()) target_index = (target_index - 1 + _tn) mod _tn;
    if (scr_input_down_pressed()) target_index = (target_index + 1) mod _tn;
    if (target_index >= _tn) target_index = max(0, _tn - 1);
    if (scr_input_confirm_pressed()) {
        var _actor = _who2[target_index];
        if (scr_item_is_equipment(_id2)) message = scr_item_equip_to(_actor, _id2);
        else message = scr_item_use_on(_actor, _id2);
        mode = "list";
        var _n2 = array_length(global.game.inventory);
        if (index >= _n2) index = max(0, _n2 - 1);
    }
}
