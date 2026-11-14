/// scr_input — prototype keyboard mapping. Final input mapping is still an open question
/// (see docs/DECISIONS_AND_OPEN_QUESTIONS.md). Change keys here only.
/// Movement still reads the arrow keys directly in obj_player : Step.

function scr_input_confirm_pressed() {
    return keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
}

function scr_input_cancel_pressed() {
    return keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_backspace);
}

function scr_input_up_pressed() {
    return keyboard_check_pressed(vk_up);
}

function scr_input_down_pressed() {
    return keyboard_check_pressed(vk_down);
}
