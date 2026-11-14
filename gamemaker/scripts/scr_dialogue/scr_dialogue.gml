/// scr_dialogue — open the single dialogue box. Overworld input stays locked until it closes.

/// _lines: array of strings (or one string). _struck_lines: optional array of line
/// indices (0-based) to draw with a strike-through (Bandit Camp sign, BC_SIGN_01).
/// Returns the obj_dialogue_box instance, or noone if a box is already open or
/// there is nothing to show.
function scr_dialogue_open(_lines, _speaker = "", _struck_lines = undefined) {
    scr_game_state_init();
    if (global.game.dialogue_open || instance_exists(obj_dialogue_box)) return noone;
    if (!is_array(_lines)) _lines = [string(_lines)];
    if (array_length(_lines) == 0) return noone;

    var _box = instance_create_depth(0, 0, -10000, obj_dialogue_box);
    _box.lines = _lines;
    _box.speaker_name = _speaker;
    _box.struck_lines = is_array(_struck_lines) ? _struck_lines : [];
    global.game.dialogue_open = true;
    return _box;
}
