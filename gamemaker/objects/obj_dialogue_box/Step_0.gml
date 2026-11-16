/// obj_dialogue_box : Step
/// Confirm advances one line; after the last line the box closes (see Clean Up for the unlock).
/// With `choices` set (scr_dialogue_choice), the last line waits for a pick instead.
if (global.game.frame == opened_frame) exit;

var _n_choices = is_array(choices) ? array_length(choices) : 0;
if (_n_choices > 0 && line_index >= array_length(lines) - 1) {
    if (scr_input_up_pressed()) choice_index = (choice_index - 1 + _n_choices) mod _n_choices;
    if (scr_input_down_pressed()) choice_index = (choice_index + 1) mod _n_choices;
    var _picked = -1;
    if (scr_input_confirm_pressed()) _picked = choice_index;
    else if (scr_input_cancel_pressed()) _picked = _n_choices - 1;
    if (_picked >= 0) {
        if (!is_undefined(on_choice)) {
            // Runs from obj_game_controller Begin Step once this box is gone.
            global.game.dialogue_on_finish = method({ cb: on_choice, idx: _picked }, function() { cb(idx); });
        }
        instance_destroy();
    }
    exit;
}

if (scr_input_confirm_pressed()) {
    scr_audio_sfx("text", 0, 0.6);
    line_index += 1;
    if (line_index >= array_length(lines)) instance_destroy();
}
