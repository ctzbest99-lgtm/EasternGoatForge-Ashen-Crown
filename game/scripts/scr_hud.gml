/// scr_hud — formatting and bar fractions for the overworld HUD. Kept out of the Draw event so the panel
/// can be reused, and so the numbers can be checked without a window.

/// @desc True when _actor can be displayed: a missing actor would otherwise draw "undefined".
function scr_hud_has_actor(_actor) {
    return (!is_undefined(_actor) && _actor != undefined && variable_struct_exists(_actor, "name"));
}

/// @desc Name, level and the shared purse for the panel's first line.
function scr_hud_title_line(_actor, _gold = undefined) {
    var _line = _actor.name + "   Lv" + string(_actor.level);
    if (!is_undefined(_gold)) _line += "      Gold " + string(_gold);
    return _line;
}

/// @desc Current and maximum HP.
function scr_hud_hp_line(_actor) {
    return "HP " + string(_actor.hp) + "/" + string(_actor.max_hp);
}

/// @desc Experience progress toward the next level.
function scr_hud_xp_line(_actor) {
    return "XP " + string(_actor.xp) + "/" + string(_actor.xp_to_next);
}

/// @desc HP as a 0..1 bar width, safe when max HP is somehow zero.
function scr_hud_hp_fraction(_actor) {
    if (_actor.max_hp <= 0) return 0;
    return clamp(_actor.hp / _actor.max_hp, 0, 1);
}

/// @desc XP as a 0..1 bar width.
function scr_hud_xp_fraction(_actor) {
    if (_actor.xp_to_next <= 0) return 0;
    return clamp(_actor.xp / _actor.xp_to_next, 0, 1);
}
