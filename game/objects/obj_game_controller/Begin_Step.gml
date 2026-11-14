/// obj_game_controller : Begin Step
/// Frame counter used by scr_input_block / scr_input_locked and dialogue open-frame guards.
global.game.frame += 1;
scr_dialogue_try_advance_queue();
