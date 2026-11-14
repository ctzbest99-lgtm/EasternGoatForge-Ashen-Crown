/// scr_flags — story flags stored in global.game.flags.
/// Names match docs/story/CHAPTER1_SCRIPT.md (e.g. flag_parchment_found).

function scr_flag_get(_name) {
    scr_game_state_init();
    if (!variable_struct_exists(global.game.flags, _name)) return false;
    return global.game.flags[$ _name];
}

function scr_flag_set(_name, _value = true) {
    scr_game_state_init();
    global.game.flags[$ _name] = _value;
}

function scr_flag_clear(_name) {
    scr_flag_set(_name, false);
}
