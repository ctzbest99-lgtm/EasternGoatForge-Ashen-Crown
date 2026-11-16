/// scr_battle_ui — small formatting helpers for the battle panel, kept out of the Draw event so the
/// line can be reused when the real UI replaces it.

/// @desc One row of the party list: `>` marks the member acting now, a downed member says so, and a
/// guarding member is flagged until the enemy's turn clears it.
function scr_battle_row_line(_actor, _active) {
    var _line = (_active ? "> " : "  ") + _actor.name;
    if (variable_struct_exists(_actor, "level")) _line += "  Lv" + string(_actor.level);
    if (_actor.hp <= 0) return _line + "   down";
    _line += "   " + string(_actor.hp) + "/" + string(_actor.max_hp) + " HP";
    if (_actor.guarding) _line += "  [guard]";
    return _line;
}

/// @desc One text line for a battle actor: name, level when it has one, and HP with the guard flag.
function scr_battle_player_line(_actor, _gold = undefined) {
    var _line = _actor.name;
    if (variable_struct_exists(_actor, "level")) _line += "  Lv" + string(_actor.level);
    _line += "   " + string(_actor.hp) + "/" + string(_actor.max_hp) + " HP";
    if (_actor.guarding) _line += "  [guarding]";
    if (!is_undefined(_gold)) _line += "    Gold " + string(_gold);
    return _line;
}
