/// obj_dialogue_box : Step
/// Confirm advances one line; after the last line the box closes (see Clean Up for the unlock).
if (global.game.frame == opened_frame) exit;

if (scr_input_confirm_pressed()) {
    line_index += 1;
    if (line_index >= array_length(lines)) instance_destroy();
}
