/// scr_input — centralized keyboard + gamepad action layer.
///
/// One place owns every control mapping. Objects call the action functions below and never
/// read gamepad buttons (or movement keys) directly. Keyboard and pad are interchangeable;
/// when both produce the same action in one frame it still fires only once.
///
/// Xbox-style pad baseline (other pads map through GameMaker's device buttons):
///   D-pad / left stick  movement and menu navigation
///   A                   confirm / interact
///   B                   cancel / back
///   Start               Adventure menu (open / close)
///   LB / RB             previous / next tab
/// Keyboard keeps the original bindings: Z/Enter/Space, X/Backspace, arrows, Q/E, I/Tab.
///
/// A disconnected pad is never cached as active, so it cannot leave movement or a menu
/// selection held down. Reconnecting (including at a different index) is picked up on the
/// next frame automatically.

#macro INPUT_DEADZONE 0.24
#macro INPUT_PAD_SCAN_MAX 12

/// Frame used to cache the pad lookup. Same value the rest of the game uses for input blocks.
function scr_input_frame() {
    if (variable_global_exists("game") && is_struct(global.game)) return global.game.frame;
    return current_time;
}

/// The active gamepad index, or -1. Prefers the current pad while it stays connected, then
/// falls back to the first connected device. The result is cached once per game frame so a
/// pad change mid-frame cannot split one action across two devices.
function scr_input_pad() {
    var _frame = scr_input_frame();
    if (variable_global_exists("input_pad_frame") && global.input_pad_frame == _frame) {
        return global.input_pad;
    }
    var _pick = -1;
    var _current = variable_global_exists("input_pad") ? global.input_pad : -1;
    if (_current >= 0 && _current < INPUT_PAD_SCAN_MAX && gamepad_is_connected(_current)) {
        _pick = _current;
    } else {
        for (var _i = 0; _i < INPUT_PAD_SCAN_MAX; _i++) {
            if (gamepad_is_connected(_i)) { _pick = _i; break; }
        }
    }
    if (!variable_global_exists("input_pad_last")) global.input_pad_last = _pick;
    if (global.input_pad_last != _pick) {
        if (_pick < 0) show_debug_message("[input] gamepad disconnected; keyboard remains active.");
        else show_debug_message("[input] gamepad " + string(_pick) + " active.");
        global.input_pad_last = _pick;
    }
    global.input_pad = _pick;
    global.input_pad_frame = _frame;
    return _pick;
}

function scr_input_pad_button(_button) {
    var _pad = scr_input_pad();
    return (_pad >= 0 && gamepad_button_check(_pad, _button));
}

function scr_input_pad_pressed(_button) {
    var _pad = scr_input_pad();
    return (_pad >= 0 && gamepad_button_check_pressed(_pad, _button));
}

function scr_input_pad_released(_button) {
    var _pad = scr_input_pad();
    return (_pad >= 0 && gamepad_button_check_released(_pad, _button));
}

// ---- Confirm ------------------------------------------------------------------------------
function scr_input_confirm_pressed() {
    return keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(vk_space) || scr_input_pad_pressed(gp_face1);
}

function scr_input_confirm_held() {
    return keyboard_check(ord("Z")) || keyboard_check(vk_enter)
        || keyboard_check(vk_space) || scr_input_pad_button(gp_face1);
}

function scr_input_confirm_released() {
    return keyboard_check_released(ord("Z")) || keyboard_check_released(vk_enter)
        || keyboard_check_released(vk_space) || scr_input_pad_released(gp_face1);
}

// ---- Cancel -------------------------------------------------------------------------------
function scr_input_cancel_pressed() {
    return keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_backspace)
        || scr_input_pad_pressed(gp_face2);
}

function scr_input_cancel_held() {
    return keyboard_check(ord("X")) || keyboard_check(vk_backspace)
        || scr_input_pad_button(gp_face2);
}

function scr_input_cancel_released() {
    return keyboard_check_released(ord("X")) || keyboard_check_released(vk_backspace)
        || scr_input_pad_released(gp_face2);
}

// ---- Menu / tabs --------------------------------------------------------------------------
function scr_input_menu_pressed() {
    return keyboard_check_pressed(ord("I")) || keyboard_check_pressed(vk_tab)
        || scr_input_pad_pressed(gp_start);
}

function scr_input_menu_held() {
    return keyboard_check(ord("I")) || keyboard_check(vk_tab)
        || scr_input_pad_button(gp_start);
}

function scr_input_tab_prev_pressed() {
    return keyboard_check_pressed(ord("Q")) || scr_input_pad_pressed(gp_shoulderl);
}

function scr_input_tab_next_pressed() {
    return keyboard_check_pressed(ord("E")) || scr_input_pad_pressed(gp_shoulderr);
}

// ---- Directional actions (menus, dialogue choices, battle navigation) ---------------------
function scr_input_up_pressed() {
    return keyboard_check_pressed(vk_up) || scr_input_pad_pressed(gp_padu);
}

function scr_input_down_pressed() {
    return keyboard_check_pressed(vk_down) || scr_input_pad_pressed(gp_padd);
}

function scr_input_left_pressed() {
    return keyboard_check_pressed(vk_left) || scr_input_pad_pressed(gp_padl);
}

function scr_input_right_pressed() {
    return keyboard_check_pressed(vk_right) || scr_input_pad_pressed(gp_padr);
}

function scr_input_up_held() {
    return keyboard_check(vk_up) || scr_input_pad_button(gp_padu);
}

function scr_input_down_held() {
    return keyboard_check(vk_down) || scr_input_pad_button(gp_padd);
}

function scr_input_left_held() {
    return keyboard_check(vk_left) || scr_input_pad_button(gp_padl);
}

function scr_input_right_held() {
    return keyboard_check(vk_right) || scr_input_pad_button(gp_padr);
}

function scr_input_up_released() {
    return keyboard_check_released(vk_up) || scr_input_pad_released(gp_padu);
}

function scr_input_down_released() {
    return keyboard_check_released(vk_down) || scr_input_pad_released(gp_padd);
}

function scr_input_left_released() {
    return keyboard_check_released(vk_left) || scr_input_pad_released(gp_padl);
}

function scr_input_right_released() {
    return keyboard_check_released(vk_right) || scr_input_pad_released(gp_padr);
}

// ---- Any input (title screens) ------------------------------------------------------------
function scr_input_any_pressed() {
    if (keyboard_check_pressed(vk_anykey)) return true;
    var _pad = scr_input_pad();
    if (_pad < 0) return false;
    var _buttons = [gp_face1, gp_face2, gp_face3, gp_face4, gp_start, gp_select,
                    gp_padu, gp_padd, gp_padl, gp_padr, gp_shoulderl, gp_shoulderr];
    for (var _i = 0; _i < array_length(_buttons); _i++) {
        if (gamepad_button_check_pressed(_pad, _buttons[_i])) return true;
    }
    return false;
}

// ---- Movement -----------------------------------------------------------------------------
/// Keyboard vector, normalized so diagonal movement is not faster than cardinal movement.
function scr_input_keyboard_vector() {
    var _x = keyboard_check(vk_right) - keyboard_check(vk_left);
    var _y = keyboard_check(vk_down) - keyboard_check(vk_up);
    if (_x != 0 && _y != 0) {
        _x *= 0.70710678;
        _y *= 0.70710678;
    }
    return [_x, _y];
}

/// Pad vector. D-pad wins when held; otherwise the left stick is radially dead-zoned and
/// scaled so the edge of the dead zone starts at zero and the rim reaches full speed.
function scr_input_pad_vector() {
    var _pad = scr_input_pad();
    if (_pad < 0) return [0, 0];

    var _dx = gamepad_button_check(_pad, gp_padr) - gamepad_button_check(_pad, gp_padl);
    var _dy = gamepad_button_check(_pad, gp_padd) - gamepad_button_check(_pad, gp_padu);
    if (_dx != 0 || _dy != 0) {
        if (_dx != 0 && _dy != 0) {
            _dx *= 0.70710678;
            _dy *= 0.70710678;
        }
        return [_dx, _dy];
    }

    var _x = gamepad_axis_value(_pad, gp_axislh);
    var _y = gamepad_axis_value(_pad, gp_axislv);
    var _mag = sqrt(_x * _x + _y * _y);
    if (_mag <= INPUT_DEADZONE) return [0, 0];
    var _scale = min(1, (_mag - INPUT_DEADZONE) / (1 - INPUT_DEADZONE)) / _mag;
    return [_x * _scale, _y * _scale];
}

/// Final movement vector. Keyboard takes precedence when it is being used, so switching
/// between devices never adds the two together. Both sources are already normalized.
function scr_input_move_vector() {
    var _kb = scr_input_keyboard_vector();
    if (_kb[0] != 0 || _kb[1] != 0) return _kb;
    return scr_input_pad_vector();
}

function scr_input_axis_x() {
    return scr_input_move_vector()[0];
}

function scr_input_axis_y() {
    return scr_input_move_vector()[1];
}
