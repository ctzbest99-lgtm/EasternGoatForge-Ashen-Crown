/// Shared Options model for the title screen and the Adventure menu.
/// These are audio settings only: scr_audio owns the gains and the mute flag, and every
/// change is written to AUDIO_SETTINGS_FILE at once, so the two screens cannot disagree
/// and a change made mid-chapter survives a restart.

/// Row ids in menu order. "back" is the last row; the other four are audio controls.
function scr_options_rows() {
    return ["music", "ambience", "sfx", "muted", "back"];
}

/// Row labels, in the same order as scr_options_rows().
function scr_options_labels() {
    return ["Music", "Ambience", "Sound effects", "Mute", "Back"];
}

/// Step a row index by _dir (-1 / +1), wrapping at both ends.
function scr_options_move(_index, _dir) {
    var _n = array_length(scr_options_rows());
    return (_index + _dir + _n) mod _n;
}

/// Apply left/right (or confirm, on Mute) to one row and save. Returns true when the
/// row changed something. "back" belongs to the caller, so it is never touched here.
function scr_options_adjust(_row, _dir) {
    if (_row == "back") return false;
    if (_row == "muted") {
        scr_audio_mute(!global.audio_ctx.muted);
    } else {
        scr_audio_set_gain(_row, scr_audio_get_gain(_row) + 0.05 * _dir);
    }
    scr_audio_settings_save();
    return true;
}

/// The row's value as the menus show it: "On"/"Off" for mute, "NN%" for a gain.
function scr_options_value_text(_row) {
    scr_audio_init();
    if (_row == "muted") return global.audio_ctx.muted ? "On" : "Off";
    return string(round(scr_audio_get_gain(_row) * 100)) + "%";
}
