/// obj_title : Step
var _s = layout_scale;
scroll1 -= 0.05 * _s;
scroll2 -= 0.1 * _s;
scroll3 -= 0.2 * _s;
ember_f = (ember_f + TITLE_EMBER_FPS / max(1, game_get_speed(gamespeed_fps))) mod 24;
logo_alpha = min(1, logo_alpha + 1 / 60);
blink += 1;
logo_y = lerp(logo_y, logo_y_target, 0.2);
if (mode == "menu") options_alpha = min(1, options_alpha + 1 / 18);

if (mode == "press") {
    if (keyboard_check_pressed(vk_anykey) || scr_input_confirm_pressed()) {
        mode = "menu";
        logo_y_target = 6 * _s;
        options_alpha = 0;
        index = 0;
    }
    exit;
}

var _n = array_length(options);
if (mode == "menu") {
    if (scr_input_up_pressed() || scr_input_down_pressed()) {
        var _dir = scr_input_up_pressed() ? -1 : 1;
        var _tries = 0;
        do {
            index = (index + _dir + _n) mod _n;
            _tries += 1;
        } until (_tries >= _n || !(options[index] == "continue" && !has_save));
    }
    if (scr_input_confirm_pressed()) {
        var _pick = options[index];
        if (_pick == "new_game") {
            var _rm = asset_get_index("rm_overworld");
            if (_rm != -1) {
                scr_game_state_reset();
                room_goto(_rm);
            } else show_debug_message("[title] rm_overworld is not in the project.");
        } else if (_pick == "continue") {
            if (has_save) {
                mode = "saves";
                save_index = 0;
                save_message = "";
                slots = [];
                for (var _s = 1; _s <= SAVE_SLOT_COUNT; _s++) array_push(slots, scr_save_slot_info(_s));
                // Land on the first usable slot if there is one.
                for (var _j = 0; _j < array_length(slots); _j++) {
                    if (slots[_j].ok) { save_index = _j; break; }
                }
            }
        } else if (_pick == "options") {
            mode = "options";
        } else if (_pick == "quit") {
            game_end();
        }
    }
} else if (mode == "options") {
    if (scr_input_cancel_pressed() || scr_input_confirm_pressed()) {
        mode = "menu";
    }
} else if (mode == "saves") {
    var _sn = array_length(slots);
    if (scr_input_up_pressed() && _sn > 0) save_index = (save_index - 1 + _sn) mod _sn;
    if (scr_input_down_pressed() && _sn > 0) save_index = (save_index + 1) mod _sn;
    if (scr_input_cancel_pressed()) {
        mode = "menu";
        has_save = scr_save_any_exists();
        save_message = "";
    } else if (scr_input_confirm_pressed() && _sn > 0) {
        var _info = slots[save_index];
        if (!_info.exists) {
            save_message = "No save in this slot.";
        } else if (!_info.ok) {
            save_message = "This save is damaged and can't be loaded.";
        } else if (!scr_save_load(save_index + 1)) {
            save_message = "Couldn't load this save.";
        }
    }
}

var _target = (95 + index * 22) * _s;
cursor_y = lerp(cursor_y, _target, 0.35);
