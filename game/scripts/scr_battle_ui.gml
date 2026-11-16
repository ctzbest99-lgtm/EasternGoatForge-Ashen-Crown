/// scr_battle_ui — small formatting helpers for the battle panel, kept out of the Draw event so the
/// line can be reused when the real UI replaces it.

/// @desc One text line for a battle actor: name, level when it has one, and HP with the guard flag.
function scr_battle_player_line(_actor, _gold = undefined) {
    var _line = _actor.name;
    if (variable_struct_exists(_actor, "level")) _line += "  Lv" + string(_actor.level);
    _line += "   " + string(_actor.hp) + "/" + string(_actor.max_hp) + " HP";
    if (_actor.guarding) _line += "  [guarding]";
    if (!is_undefined(_gold)) _line += "    Gold " + string(_gold);
    return _line;
}
