/// obj_status_menu : Draw GUI
/// Text panel over the room; columns are fixed x offsets so the values line up without a font asset.
if (!menu.open) exit;

var _party = scr_party_ensure_global();

if (menu.mode == STATUS_VIEW.ITEM) {
    var _usable = scr_inventory_usable(scr_status_inventory(_party));
    var _target = scr_status_menu_member(_party, menu);
    var _width = 360;
    var _left = (display_get_gui_width() - _width) * 0.5;
    var _height = 116 + array_length(_usable) * 18;
    var _top = (display_get_gui_height() - _height) * 0.5;

    draw_set_alpha(0.92);
    draw_set_colour(c_black);
    draw_rectangle(_left, _top, _left + _width, _top + _height, false);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_colour(c_white);
    draw_text(_left + 14, _top + 8, "ITEMS");
    if (!is_undefined(_target)) {
        draw_text(_left + 14, _top + 30, _target.name + "   " + scr_hud_hp_line(_target));
    }

    for (var _i = 0; _i < array_length(_usable); _i++) {
        var _data = scr_item_data(_usable[_i].id);
        draw_set_colour((_i == menu.item_cursor) ? c_yellow : c_white);
        draw_text(_left + 20, _top + 54 + _i * 18, ((_i == menu.item_cursor) ? "> " : "  ") + _data.name + "   x" + string(_usable[_i].count));
    }

    draw_set_colour(c_aqua);
    draw_text(_left + 14, _top + 62 + array_length(_usable) * 18, menu.message);
    draw_set_colour(c_white);
    draw_text(_left + 14, _top + _height - 22, "[ENTER] use   [ESC] back");
    exit;
}

var _rows = scr_status_rows(_party);
var _width = 460;
var _left = (display_get_gui_width() - _width) * 0.5;
var _top = (display_get_gui_height() - 40 - array_length(_rows) * 30) * 0.5;
var _height = 76 + array_length(_rows) * 30;

draw_set_alpha(0.92);
draw_set_colour(c_black);
draw_rectangle(_left, _top, _left + _width, _top + _height, false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_colour(c_white);
draw_text(_left + 14, _top + 8, "PARTY STATUS");

for (var _i = 0; _i < array_length(_rows); _i++) {
    var _row = _rows[_i];
    var _y = _top + 32 + _i * 30;
    draw_set_colour((_i == menu.cursor) ? c_yellow : c_white);
    draw_text(_left + 20, _y, ((_i == menu.cursor) ? "> " : "  ") + _row.name);
    draw_text(_left + 132, _y, _row.level_text);
    draw_text(_left + 186, _y, _row.hp_text);
    draw_text(_left + 276, _y, _row.xp_text);
    draw_set_colour((_i == menu.cursor) ? c_yellow : ((_row.alive) ? c_white : c_gray));
    draw_text(_left + 20, _y + 14, "     " + _row.stats_text);
}

draw_set_colour(c_aqua);
draw_text(_left + 14, _top + _height - 24, menu.message);
draw_set_colour(c_white);
draw_text(_left + 14, _top + _height - 40, "[UP/DOWN] select   [ENTER] items   [ESC] close");
