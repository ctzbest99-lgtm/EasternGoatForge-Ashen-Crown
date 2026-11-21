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

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _mouse_moved = (_mx != mouse_last_x || _my != mouse_last_y);

if (mode == "menu") {
    var _n = array_length(options);
    var _hover = menu_row_at(_mx, _my);
    if (_mouse_moved && _hover >= 0) index = _hover;

    if (scr_input_up_pressed() || scr_input_down_pressed()) {
        var _dir = scr_input_up_pressed() ? -1 : 1;
        var _menu_tries = 0;
        do {
            index = (index + _dir + _n) mod _n;
            _menu_tries += 1;
        } until (_menu_tries >= _n || !(options[index] == "continue" && !has_save));
    }
    if (scr_input_confirm_pressed()) do_menu_action(options[index]);
    if (mouse_check_button_pressed(mb_left) && _hover >= 0) do_menu_action(options[_hover]);
} else if (mode == "settings") {
    // Up/down picks a row; left/right changes a gain by 5%, or flips mute.
    var _rows = opt_rows;
    if (scr_input_up_pressed()) {
        opt_index = scr_options_move(opt_index, -1);
        scr_audio_sfx("menu_move", 0, 0.6);
    }
    if (scr_input_down_pressed()) {
        opt_index = scr_options_move(opt_index, 1);
        scr_audio_sfx("menu_move", 0, 0.6);
    }

    var _hover_row = settings_row_at(_mx, _my);
    if (_mouse_moved && _hover_row >= 0) opt_index = _hover_row;

    var _row = _rows[opt_index];
    var _change = scr_input_left_pressed() || scr_input_right_pressed();
    if (_row == "back") {
        if (scr_input_confirm_pressed()) {
            scr_audio_sfx("menu_cancel", 0, 0.7);
            mode = "menu";
        }
    } else if (_row == "muted") {
        if (_change || scr_input_confirm_pressed()) {
            scr_options_adjust(_row, 0);
            if (!global.audio_ctx.muted) scr_audio_sfx("menu_confirm", 0, 0.7);
        }
    } else if (_change) {
        scr_options_adjust(_row, scr_input_right_pressed() ? 1 : -1);
        scr_audio_sfx("menu_move", 0, 0.6);
    }

    // Mouse: click a row to select it; a gain row then steps up/down depending on
    // which side of the bar was clicked. Mute toggles, Back leaves.
    if (mouse_check_button_pressed(mb_left) && _hover_row >= 0) {
        var _pick = _rows[_hover_row];
        if (_pick == "back") {
            scr_audio_sfx("menu_cancel", 0, 0.7);
            mode = "menu";
        } else if (_pick == "muted") {
            scr_options_adjust(_pick, 0);
            if (!global.audio_ctx.muted) scr_audio_sfx("menu_confirm", 0, 0.7);
        } else {
            var _dir2 = (_mx < (settings_x + 112) * _s) ? -1 : 1;
            scr_options_adjust(_pick, _dir2);
            scr_audio_sfx("menu_move", 0, 0.6);
        }
    }

    if (mode == "settings" && scr_input_cancel_pressed()) {
        scr_audio_sfx("menu_cancel", 0, 0.7);
        mode = "menu";
    }
} else if (mode == "saves") {
    var _sn = array_length(slots);
    if (scr_input_up_pressed() && _sn > 0) {
        var _slot_tries = 0;
        do { save_index = (save_index - 1 + _sn) mod _sn; _slot_tries += 1; }
        until (_slot_tries >= _sn || slots[save_index].ok);
    }
    if (scr_input_down_pressed() && _sn > 0) {
        var _slot_tries2 = 0;
        do { save_index = (save_index + 1) mod _sn; _slot_tries2 += 1; }
        until (_slot_tries2 >= _sn || slots[save_index].ok);
    }

    var _hover_slot = save_slot_at(_mx, _my);
    if (_mouse_moved && _hover_slot >= 0) save_index = _hover_slot;

    if (scr_input_cancel_pressed()) {
        mode = "menu";
        refresh_saves();
        save_message = "";
    } else if (mouse_check_button_pressed(mb_left) && _hover_slot >= 0) {
        load_save_slot(_hover_slot);
    } else if (scr_input_confirm_pressed() && _sn > 0) {
        load_save_slot(save_index);
    }
} else if (mode == "confirm_new") {
    if (scr_input_left_pressed() || scr_input_right_pressed() || scr_input_up_pressed() || scr_input_down_pressed()) {
        confirm_index = 1 - confirm_index;
        scr_audio_sfx("menu_move", 0, 0.6);
    }
    var _hover_button = confirm_button_at(_mx, _my);
    if (_mouse_moved && _hover_button >= 0) confirm_index = _hover_button;

    if (mouse_check_button_pressed(mb_left) && _hover_button >= 0) {
        if (_hover_button == 1) start_new_game(); else mode = "menu";
    } else if (scr_input_confirm_pressed()) {
        if (confirm_index == 1) start_new_game(); else mode = "menu";
    } else if (scr_input_cancel_pressed()) {
        mode = "menu";
    }
}

if (mode == "menu") {
    var _target = (76 + index * 20) * _s;
    cursor_y = lerp(cursor_y, _target, 0.35);
}
mouse_last_x = _mx;
mouse_last_y = _my;
