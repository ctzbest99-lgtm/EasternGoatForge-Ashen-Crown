/// obj_battle_controller : Draw GUI
/// Text-only prototype panel; the final UI replaces this file without touching the battle logic.
var _panel_w = 420;
var _panel_h = 150;
var _left = (display_get_gui_width() - _panel_w) * 0.5;
var _top = display_get_gui_height() - _panel_h - 16;

draw_set_alpha(0.85);
draw_set_colour(c_black);
draw_rectangle(_left, _top, _left + _panel_w, _top + _panel_h, false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_colour(c_white);

/// Enemy line
draw_text(_left + 12, _top + 10, battle.enemy.name + "   " + string(battle.enemy.hp) + "/" + string(battle.enemy.max_hp) + " HP");
/// Player line, with level and purse when a party member is fighting
draw_text(_left + 12, _top + 32, scr_battle_player_line(battle.player, variable_global_exists("party") ? global.party.gold : undefined));

/// Message line
draw_set_colour(c_yellow);
draw_text(_left + 12, _top + 62, battle.message);
draw_set_colour(c_white);

/// Commands, only while they are usable
if (battle.state == BATTLE_PHASE.COMMAND) {
    for (var _i = 0; _i < BATTLE_COMMAND_COUNT; _i++) {
        draw_set_colour((_i == battle.cursor) ? c_aqua : c_white);
        draw_text(_left + 24 + _i * 110, _top + 96, ((_i == battle.cursor) ? "> " : "  ") + scr_battle_command_name(_i));
    }
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 122, "[ENTER] confirm   [UP/DOWN] choose");
} else if (battle.state == BATTLE_PHASE.VICTORY) {
    draw_set_colour(c_lime);
    draw_text(_left + 12, _top + 96, "Victory!  +" + string(battle.enemy.xp_reward) + " XP  +" + string(battle.enemy.gold_reward) + " gold");
    draw_set_colour(c_white);
    for (var _i = 0; _i < array_length(level_ups); _i++) {
        draw_set_colour(c_aqua);
        draw_text(_left + 12, _top + 108 + _i * 14, level_ups[_i]);
    }
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + _panel_h - 28, "[ENTER] return to exploration");
} else if (battle.state == BATTLE_PHASE.DEFEAT) {
    draw_set_colour(c_red);
    draw_text(_left + 12, _top + 96, "Defeat...");
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 122, "[ENTER] return to exploration");
} else if (battle.state == BATTLE_PHASE.ITEM) {
    var _usable = scr_inventory_usable(battle.inventory);
    for (var _i = 0; _i < array_length(_usable); _i++) {
        var _data = scr_item_data(_usable[_i].id);
        draw_set_colour((_i == battle.item_cursor) ? c_aqua : c_white);
        draw_text(_left + 24, _top + 90 + _i * 16, ((_i == battle.item_cursor) ? "> " : "  ") + _data.name + "   x" + string(_usable[_i].count));
    }
    draw_set_colour(c_white);
    draw_text(_left + 12, _top + 122, "[ENTER] use   [ESC] back");
} else {
    draw_text(_left + 12, _top + 122, "[ENTER] continue");
}
