/// obj_adventure_menu : Step
scr_game_state_init();

// I / Tab / X / Backspace: back out one level, then close.
var _close_key = keyboard_check_pressed(ord("I")) || keyboard_check_pressed(vk_tab);
if (scr_input_cancel_pressed() || _close_key) {
    if (mode != "list") {
        mode = "list";
        message = "";
        exit;
    }
    instance_destroy();
    exit;
}

if (mode == "list") {
    var _n = array_length(entries);
    if (scr_input_up_pressed()) index = (index - 1 + _n) mod _n;
    if (scr_input_down_pressed()) index = (index + 1) mod _n;
    if (scr_input_confirm_pressed()) {
        message = "";
        switch (index) {
            case 0:
            case 1:
                // Hand off to the existing Items / Equip screens.
                var _inv = scr_menu_open_object("obj_inventory_menu");
                if (_inv != noone && instance_exists(_inv)) {
                    _inv.tab = (index == 1) ? 1 : 0;
                    _inv.mode = (index == 1) ? "slots" : "list";
                    _inv.index = 0;
                    _inv.scroll = 0;
                    _inv.message = "";
                }
                exit;
            case 2:
                mode = "party";
                party_index = 0;
                break;
            case 3:
                mode = "status";
                member_index = 0;
                break;
            case 4:
                mode = "bestiary";
                bestiary_index = 0;
                bestiary_scroll = 0;
                break;
            case 5:
                instance_destroy();
                break;
        }
    }
    exit;
}

var _party = scr_menu_inv_party();

if (mode == "status") {
    var _pn = array_length(_party);
    if (_pn > 0) {
        if (member_index >= _pn) member_index = 0;
        if (scr_input_left_pressed() || scr_input_up_pressed()) member_index = (member_index - 1 + _pn) mod _pn;
        if (scr_input_right_pressed() || scr_input_down_pressed()) member_index = (member_index + 1) mod _pn;
    }
    exit;
}

if (mode == "party") {
    var _active = global.game.party;
    var _reserve = global.game.reserve;
    var _an = is_array(_active) ? array_length(_active) : 0;
    var _rn = is_array(_reserve) ? array_length(_reserve) : 0;
    var _rows = _an + max(1, _rn); // the empty reserve row is always listed
    if (_rows > 0 && party_index >= _rows) party_index = 0;
    if (scr_input_up_pressed() && _rows > 0) party_index = (party_index - 1 + _rows) mod _rows;
    if (scr_input_down_pressed() && _rows > 0) party_index = (party_index + 1) mod _rows;

    if (party_index < _an) {
        // Left/right reorders the active line-up (this is the battle slot order).
        if ((scr_input_left_pressed() || scr_input_right_pressed()) && _an > 1) {
            var _to = clamp(party_index + (scr_input_left_pressed() ? -1 : 1), 0, _an - 1);
            if (_to != party_index) {
                var _tmp = _active[party_index];
                _active[party_index] = _active[_to];
                _active[_to] = _tmp;
                party_index = _to;
                message = _active[_to].name + " moves to slot " + string(_to + 1) + ".";
            }
        }
        if (scr_input_confirm_pressed()) {
            if (_rn == 0) {
                message = "No one is in reserve.";
            } else {
                var _out_name = _active[party_index].name;
                var _in_name = _reserve[0].name;
                if (scr_party_swap_active_reserve(party_index)) {
                    message = _out_name + " steps back; " + _in_name + " takes the front line.";
                } else {
                    message = "Nothing to swap.";
                }
            }
        }
    } else if (scr_input_confirm_pressed()) {
        message = "Pick an active slot to swap with the reserve.";
    }
    exit;
}

if (mode == "bestiary") {
    var _bn = scr_bestiary_count();
    if (_bn > 0) {
        if (scr_input_up_pressed()) bestiary_index = (bestiary_index - 1 + _bn) mod _bn;
        if (scr_input_down_pressed()) bestiary_index = (bestiary_index + 1) mod _bn;
        if (bestiary_index >= _bn) bestiary_index = 0;
        if (bestiary_index < bestiary_scroll) bestiary_scroll = bestiary_index;
        if (bestiary_index >= bestiary_scroll + MENU_ADV_ROWS) bestiary_scroll = bestiary_index - MENU_ADV_ROWS + 1;
    }
    exit;
}
