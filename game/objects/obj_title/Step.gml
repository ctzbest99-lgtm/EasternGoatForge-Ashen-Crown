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
            if (_rm != -1) room_goto(_rm);
            else show_debug_message("[title] rm_overworld is not in the project.");
        } else if (_pick == "continue") {
            if (has_save) mode = "saves";
        } else if (_pick == "options") {
            mode = "options";
        } else if (_pick == "quit") {
            game_end();
        }
    }
} else if (mode == "options" || mode == "saves") {
    if (scr_input_cancel_pressed() || scr_input_confirm_pressed()) {
        mode = "menu";
    }
}

var _target = (95 + index * 22) * _s;
cursor_y = lerp(cursor_y, _target, 0.35);
