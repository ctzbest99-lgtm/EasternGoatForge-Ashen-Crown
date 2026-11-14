/// obj_save_menu : Step
if (refresh_slots) {
    slots = [];
    for (var _i = 1; _i <= SAVE_SLOT_COUNT; _i++) array_push(slots, scr_save_slot_info(_i));
    refresh_slots = false;
}

if (confirming_overwrite) {
    if (scr_input_up_pressed() || scr_input_down_pressed() || scr_input_left_pressed() || scr_input_right_pressed()) {
        prompt_index = 1 - prompt_index;
    }
    if (scr_input_cancel_pressed()) {
        confirming_overwrite = false;
        prompt_index = 1;
        message = "";
        exit;
    }
    if (scr_input_confirm_pressed()) {
        var _on_no = (prompt_index != 0);
        if (_on_no) {
            confirming_overwrite = false;
            prompt_index = 1;
            exit;
        }
        confirming_overwrite = false;
        if (scr_save_write(index + 1)) {
            scr_menu_toast_saved();
            instance_destroy();
        } else {
            message = "Couldn't save.";
        }
    }
    exit;
}

var _n = SAVE_SLOT_COUNT;
if (scr_input_up_pressed()) {
    var _tries = 0;
    do {
        index = (index - 1 + _n) mod _n;
        _tries += 1;
        // Load skips empty slots.
    } until (_tries >= _n || mode != "load" || (array_length(slots) > index && slots[index].ok));
}
if (scr_input_down_pressed()) {
    var _tries2 = 0;
    do {
        index = (index + 1) mod _n;
        _tries2 += 1;
    } until (_tries2 >= _n || mode != "load" || (array_length(slots) > index && slots[index].ok));
}

if (scr_input_cancel_pressed()) {
    instance_destroy();
    exit;
}

if (scr_input_confirm_pressed()) {
    var _info = slots[index];
    if (mode == "save") {
        if (_info.exists && _info.ok) {
            confirming_overwrite = true;
            prompt_index = 1; // default No
            message = "";
        } else {
            if (scr_save_write(index + 1)) {
                scr_menu_toast_saved();
                instance_destroy();
            } else {
                message = "Couldn't save.";
            }
        }
    } else {
        if (!_info.exists || _info.empty) {
            message = "No save in this slot.";
        } else if (!_info.ok) {
            message = "This save is damaged and can't be loaded.";
        } else if (!scr_save_load(index + 1)) {
            message = "Couldn't load this save.";
        }
    }
}
