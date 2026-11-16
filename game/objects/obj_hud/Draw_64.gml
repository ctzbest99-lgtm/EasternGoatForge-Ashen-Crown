/// obj_hud : Draw GUI
/// Hidden during a battle: the battle panel already shows the same actor, and two overlapping HP
/// readouts in different places is exactly the kind of thing a player reads wrong.
if (global.battle_active) exit;
/// The status menu shows the same numbers, so the corner panel gets out of the way while it is open.
if (variable_global_exists("menu_open") && global.menu_open) exit;
if (!variable_global_exists("party") || array_length(global.party.members) == 0) exit;

var _actor = scr_party_lead(global.party);
if (!scr_hud_has_actor(_actor)) exit;

var _left = 16;
var _top = 16;
var _width = 240;
/// The quest row is measured first, because the panel only grows to hold it.
var _quest_flags = (variable_global_exists("flags") ? global.flags : undefined);
var _quest_line = scr_hud_quest_line(_quest_flags);
var _height = scr_hud_panel_height(_quest_line != "");
var _bar_x = _left + 12;
var _bar_w = _width - 24;

draw_set_alpha(0.8);
draw_set_colour(c_black);
draw_rectangle(_left, _top, _left + _width, _top + _height, false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_colour(c_white);

draw_text(_left + 12, _top + 8, scr_hud_title_line(_actor, global.party.gold));
draw_text(_left + 12, _top + 26, scr_hud_hp_line(_actor));

/// HP bar
draw_set_colour(c_maroon);
draw_rectangle(_bar_x, _top + 40, _bar_x + _bar_w, _top + 44, false);
draw_set_colour(c_red);
draw_rectangle(_bar_x, _top + 40, _bar_x + _bar_w * scr_hud_hp_fraction(_actor), _top + 44, false);

draw_set_colour(c_white);
draw_text(_left + 12, _top + 46, scr_hud_xp_line(_actor));

/// XP bar
draw_set_colour(c_dkgray);
draw_rectangle(_bar_x, _top + 60, _bar_x + _bar_w, _top + 64, false);
draw_set_colour(c_aqua);
draw_rectangle(_bar_x, _top + 60, _bar_x + _bar_w * scr_hud_xp_fraction(_actor), _top + 64, false);

/// Quest stage: the flags decide it, and nothing is drawn until one is active.
if (_quest_line != "") {
    draw_set_colour(c_silver);
    draw_text(_left + 12, _top + 72, _quest_line);
    draw_set_colour(c_white);
}

draw_set_colour(c_white);
