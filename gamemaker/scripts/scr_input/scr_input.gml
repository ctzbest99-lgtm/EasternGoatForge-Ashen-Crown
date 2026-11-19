/// scr_input — unified keyboard + gamepad input for ASHEN CROWN.
/// Keyboard remains fully supported. The first connected gamepad (up to 12 devices)
/// is used for the local player. Standard GameMaker/XInput face and D-pad mappings:
/// A = confirm, B = cancel, Start = Adventure menu, shoulders = tab navigation.
/// Left stick and D-pad both move the player; D-pad navigates menus.

function scr_input_gamepad_device() {
    for (var _pad = 0; _pad < 12; _pad++) {
        if (gamepad_is_connected(_pad)) return _pad;
    }
    return -1;
}

function scr_input_confirm_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(ord("Z"))
        || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(vk_space)
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face1));
}

function scr_input_cancel_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(ord("X"))
        || keyboard_check_pressed(vk_backspace)
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face2));
}

function scr_input_menu_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(ord("I"))
        || keyboard_check_pressed(vk_tab)
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_start));
}

function scr_input_up_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(vk_up)
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_padu));
}

function scr_input_down_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(vk_down)
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_padd));
}

function scr_input_left_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(vk_left)
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_padl));
}

function scr_input_right_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(vk_right)
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_padr));
}

function scr_input_tab_prev_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(ord("Q"))
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_shoulderl));
}

function scr_input_tab_next_pressed() {
    var _pad = scr_input_gamepad_device();
    return keyboard_check_pressed(ord("E"))
        || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_shoulderr));
}

/// Continuous horizontal movement input, normalized to -1, 0, or 1.
function scr_input_move_x() {
    var _value = keyboard_check(vk_right) - keyboard_check(vk_left);
    var _pad = scr_input_gamepad_device();

    if (_pad != -1) {
        var _axis = gamepad_axis_value(_pad, gp_axislh);
        var _pad_value = gamepad_button_check(_pad, gp_padr) - gamepad_button_check(_pad, gp_padl);
        if (abs(_axis) > 0.25) _pad_value = sign(_axis);
        if (_pad_value != 0) _value = _pad_value;
    }

    return clamp(_value, -1, 1);
}

/// Continuous vertical movement input, normalized to -1, 0, or 1.
function scr_input_move_y() {
    var _value = keyboard_check(vk_down) - keyboard_check(vk_up);
    var _pad = scr_input_gamepad_device();

    if (_pad != -1) {
        var _axis = gamepad_axis_value(_pad, gp_axislv);
        var _pad_value = gamepad_button_check(_pad, gp_padd) - gamepad_button_check(_pad, gp_padu);
        if (abs(_axis) > 0.25) _pad_value = sign(_axis);
        if (_pad_value != 0) _value = _pad_value;
    }

    return clamp(_value, -1, 1);
}
