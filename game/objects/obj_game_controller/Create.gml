/// obj_game_controller : Create
/// One persistent controller: owns global.game, the frame counter, and the post-battle return.
/// Placed in rm_overworld; the duplicate created when re-entering that room removes itself.
if (instance_number(obj_game_controller) > 1) {
    instance_destroy();
    exit;
}
persistent = true;
randomize();
scr_game_state_init();
