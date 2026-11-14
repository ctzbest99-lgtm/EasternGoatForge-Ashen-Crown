/// obj_save_menu : Step
if (refresh_slots) {
    slots = [];
    for (var _i = 1; _i <= SAVE_SLOT_COUNT; _i++) {
        array_push(slots, scr_save_slot_info(_i));
    }
    refresh_slots = false;
}

if (need_prompt) {
    if (scr_input_up_pressed() || scr_input_down_pressed() || scr_input_left_pressed() || scr_input_right_pressed()) {
        prompt_index = 1 - prompt_index;
    }
    if (scr_input_cancel_pressed()) {
        instance_destroy();
        exit;
    }
    if (scr_input_confirm_pressed()) {
        if (prompt_index == 1) {
            instance_destroy();
            exit;
        }
        need_prompt = false;
        message = "";
    }
    exit;
}

if (confirming_overwrite) {
    if (scr_input_up_pressed() || scr_input_down_pressed() || scr_input_left_pressed() || scr_input_right_pressed()) {
        prompt_index = 1 - prompt_index;
    }
    if (scr_input_cancel_pressed()) {
        confirming_overwrite = false;
        prompt_index = 0;
        message = "";
        exit;
    }
    if (scr_input_confirm_pressed()) {
        if (prompt_index == 1) {
            confirming_overwrite = false;
            prompt_index = 0;
            message = "";
            exit;
        }
        confirming_overwrite = false;
        if (scr_save_write(index + 1)) {
            message = "Game saved.";
            refresh_slots = true;
        } else {
            message = "Couldn't save.";
        }
    }
    exit;
}

var _n = SAVE_SLOT_COUNT;
if (scr_input_up_pressed()) index = (index - 1 + _n) mod _n;
if (scr_input_down_pressed()) index = (index + 1) mod _n;

if (scr_input_cancel_pressed()) {
    instance_destroy();
    exit;
}

if (scr_input_confirm_pressed()) {
    var _info = slots[index];
    if (mode == "save") {
        if (_info.exists && _info.ok) {
            confirming_overwrite = true;
            prompt_index = 0;
            message = "Overwrite this save?";
        } else {
            if (scr_save_write(index + 1)) {
                message = "Game saved.";
                refresh_slots = true;
            } else {
                message = "Couldn't save.";
            }
        }
    } else {
        if (!_info.exists) {
            message = "No save in this slot.";
        } else if (!_info.ok) {
            message = "This save is damaged and can't be loaded.";
        } else if (scr_save_load(index + 1)) {
            // Room transition will destroy this instance with the room.
        } else {
            message = "Couldn't load this save.";
        }
    }
}
