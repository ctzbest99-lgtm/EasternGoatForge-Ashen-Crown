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

/// @desc The quest line for the panel, or "" when no stage is active. The stage itself comes from the
/// story flags, so this only owns the label.
function scr_hud_quest_line(_flags) {
    var _stage = scr_quest_stage(_flags);
    if (_stage == "") return "";
    return "Quest: " + _stage;
}

/// @desc Panel height. The quest row is only reserved when there is a line to put in it, so a quest that
/// has not started (or has been checked off) leaves the compact panel rather than a blank strip.
function scr_hud_panel_height(_has_quest_line) {
    return _has_quest_line ? 88 : 68;
}
