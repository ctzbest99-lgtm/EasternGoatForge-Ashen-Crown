/// obj_game_controller : Step
if (pending_load) {
    var _player = scr_game_find_player();
    if (_player != noone) {
        load_message = scr_game_load_into(_player);
        pending_load = false;
        show_debug_message("game: " + load_message);
    }
}

/// Writes at most one save per request, and only when no battle is running.
if (scr_game_process_autosave()) show_debug_message("game: autosaved (" + global.last_save_message + ")");
