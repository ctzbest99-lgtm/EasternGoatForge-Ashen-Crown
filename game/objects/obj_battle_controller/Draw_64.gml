/// obj_battle_controller : Draw GUI
/// Text-only prototype panel; the final UI replaces this file without touching the battle logic.
var _panel_w = 460;
var _panel_h = 214;
var _left = (display_get_gui_width() - _panel_w) * 0.5;
var _top = display_get_gui_height() - _panel_h - 16;

draw_set_alpha(0.85);
draw_set_colour(c_black);
draw_rectangle(_left, _top, _left + _panel_w, _top + _panel_h, false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_colour(c_white);

/// Enemy line
draw_text(_left + 12, _top + 8, battle.enemy.name + "   " + string(battle.enemy.hp) + "/" + string(battle.enemy.max_hp) + " HP");

/// Party list, in party order, with the acting member marked
var _members = array_length(battle.party);
for (var _i = 0; _i < _members; _i++) {
    draw_set_colour((_i == battle.active_actor && !scr_battle_is_over(battle)) ? c_aqua : c_white);
    draw_text(_left + 14, _top + 28 + _i * 16, scr_battle_row_line(battle.party[_i], _i == battle.active_actor));
}
draw_set_colour(c_white);
if (_members > 1) {
    var _purse = variable_global_exists("party") ? global.party.gold : 0;
    draw_text(_left + _panel_w - 96, _top + 8, "Gold " + string(_purse));
}

/// Message line
draw_set_colour(c_yellow);
draw_text(_left + 12, _top + 100, battle.message);
draw_set_colour(c_white);

/// Commands, only while they are usable
if (battle.state == BATTLE_PHASE.COMMAND) {
    for (var _i = 0; _i < BATTLE_COMMAND_COUNT; _i++) {
        draw_set_colour((_i == battle.cursor) ? c_aqua : c_white);
        draw_text(_left + 18 + _i * 86, _top + 128, ((_i == battle.cursor) ? "> " : "  ") + scr_battle_command_name(_i));
    }
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 164, "[" + battle.player.name + "]  [ENTER] confirm   [UP/DOWN] choose");
} else if (battle.state == BATTLE_PHASE.VICTORY) {
    draw_set_colour(c_lime);
    draw_text(_left + 12, _top + 128, "Victory!  +" + string(battle.enemy.xp_reward) + " XP  +" + string(battle.enemy.gold_reward) + " gold");
    draw_set_colour(c_white);
    for (var _i = 0; _i < array_length(level_ups); _i++) {
        draw_set_colour(c_aqua);
        draw_text(_left + 12, _top + 144 + _i * 14, level_ups[_i]);
    }
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + _panel_h - 26, "[ENTER] return to exploration");
} else if (battle.state == BATTLE_PHASE.ESCAPED) {
    draw_set_colour(c_lime);
    draw_text(_left + 12, _top + 128, "Escaped.");
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 164, "[ENTER] return to exploration");
} else if (battle.state == BATTLE_PHASE.DEFEAT) {
    draw_set_colour(c_red);
    draw_text(_left + 12, _top + 128, "Defeat...");
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 164, "[ENTER] return to exploration");
} else if (battle.state == BATTLE_PHASE.ITEM) {
    var _usable = scr_inventory_usable(battle.inventory);
    for (var _i = 0; _i < array_length(_usable); _i++) {
        var _data = scr_item_data(_usable[_i].id);
        draw_set_colour((_i == battle.item_cursor) ? c_aqua : c_white);
        draw_text(_left + 20, _top + 118 + _i * 16, ((_i == battle.item_cursor) ? "> " : "  ") + _data.name + "   x" + string(_usable[_i].count));
    }
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 164, "on " + battle.player.name + "   [ENTER] use   [ESC] back");
} else if (battle.state == BATTLE_PHASE.SWITCH) {
    /// Only standing members are listed, and only they can be chosen.
    for (var _i = 0; _i < _members; _i++) {
        var _actor = battle.party[_i];
        if (!scr_battle_is_alive(_actor)) continue;
        draw_set_colour((_i == battle.member_cursor) ? c_aqua : c_white);
        draw_text(_left + 20, _top + 118 + _i * 16, ((_i == battle.member_cursor) ? "> " : "  ") + scr_battle_row_line(_actor, false));
    }
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 164, "[ENTER] switch   [ESC] back");
} else {
    draw_text(_left + 12, _top + 164, "[ENTER] continue");
}
