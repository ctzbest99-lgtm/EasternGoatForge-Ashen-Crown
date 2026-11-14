/// obj_inventory_menu : Draw GUI
scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
draw_set_alpha(0.45);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

var _x = 40;
var _y = 16;
var _w = 240;
var _h = 148;
scr_ui_window(_x, _y, _w, _h, "normal");
scr_ui_text(_x + 10, _y + 6, "Inventory", make_color_rgb(217, 184, 96));
scr_ui_text(_x + 140, _y + 6, "Gold " + string(global.game.gold), c_white);

var _inv = global.game.inventory;
var _list_y = _y + 22;
if (array_length(_inv) == 0) {
    scr_ui_text(_x + 12, _list_y, "(empty)", make_color_rgb(154, 146, 132));
} else {
    var _start = max(0, index - 8);
    var _shown = 0;
    for (var _i = _start; _i < array_length(_inv) && _shown < 10; _i++) {
        var _it = _inv[_i];
        var _row = _list_y + _shown * 12;
        if (_i == index) {
            var _bar = scr_sprite_index("spr_ui_select_bar");
            if (scr_sprite_is_valid(_bar)) draw_sprite_stretched(_bar, 0, _x + 8, _row - 1, _w - 16, 12);
            scr_ui_cursor(_x + 16, _row + 5);
        }
        var _spr = scr_ch1_item_sprite(_it.item_id);
        if (scr_sprite_is_valid(_spr)) {
            draw_sprite_ext(_spr, 0, _x + 28, _row + 4, 0.75, 0.75, 0, c_white, 1);
        }
        var _nm = variable_struct_exists(_it, "name") ? _it.name : _it.item_id;
        var _qty = variable_struct_exists(_it, "qty") ? _it.qty : 1;
        var _key = variable_struct_exists(_it, "key_item") && _it.key_item;
        if (_key) _nm = _nm + "  [Key]";
        if (_qty > 1) _nm = _nm + "  x" + string(_qty);
        var _col = (_i == index) ? make_color_rgb(217, 184, 96) : c_white;
        scr_ui_text(_x + 40, _row, _nm, _col);
        _shown += 1;
    }
}
scr_ui_text(_x + 10, _y + _h - 14, "[I/X] Close", make_color_rgb(154, 146, 132));
