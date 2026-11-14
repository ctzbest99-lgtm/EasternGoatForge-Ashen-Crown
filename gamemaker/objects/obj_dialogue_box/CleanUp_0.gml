/// obj_dialogue_box : Clean Up
/// Runs on instance_destroy() and on room end, so the overworld can never stay locked.
global.game.dialogue_open = false;
scr_input_block(1); // the press that closed the box must not re-open it or move/interact
