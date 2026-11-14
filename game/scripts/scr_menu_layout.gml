/// scr_menu_layout — layout constants and sprite lookups for shop, save/load, and inventory.
/// Design is making dedicated menu art that will land later in /workspace/sprites/ui/menus/.
/// Until then, menus use the existing nine-slice windows, bitmap font, cursor, and item icons.
/// Look up the reserved menu sprite names first (asset_get_index via scr_sprite_index) and
/// fall back so the new art can be swapped in without rewriting draw code. When that art
/// arrives, change the numbers in this file to match the panels — callers should not hard-code layout.

#macro MENU_GUI_W 320
#macro MENU_GUI_H 180
#macro MENU_ROW_H 12
#macro MENU_PAD 8
#macro MENU_TITLE_H 16
#macro MENU_HINT_H 14
#macro MENU_GOLD_COL make_color_rgb(217, 184, 96)
#macro MENU_DIM_COL make_color_rgb(154, 146, 132)
#macro MENU_DISABLED_COL make_color_rgb(80, 80, 80)

#macro MENU_INV_X 16
#macro MENU_INV_Y 8
#macro MENU_INV_W 288
#macro MENU_INV_H 164
#macro MENU_INV_LIST_ROWS 9

#macro MENU_SHOP_X 8
#macro MENU_SHOP_Y 6
#macro MENU_SHOP_W 304
#macro MENU_SHOP_H 168
#macro MENU_SHOP_TAB_W 56
#macro MENU_SHOP_LIST_ROWS 8
#macro MENU_SHOP_LIST_X 72

#macro MENU_SAVE_X 40
#macro MENU_SAVE_Y 16
#macro MENU_SAVE_W 240
#macro MENU_SAVE_H 148
#macro MENU_SAVE_SLOT_H 32
#macro MENU_SAVE_SLOT_COUNT 3

/// Reserved names for upcoming Design art under sprites/ui/menus/, then existing UI kit fallbacks.
function scr_menu_sprite_window(_which) {
    if (_which == "shop") {
        return scr_sprite_index("spr_menu_shop_window", "spr_ui_menu_shop", "spr_ui_window");
    }
    if (_which == "inventory") {
        return scr_sprite_index("spr_menu_inventory_window", "spr_ui_menu_inventory", "spr_ui_window");
    }
    if (_which == "save") {
        return scr_sprite_index("spr_menu_save_window", "spr_ui_menu_saves", "spr_menu_panel_saves_320", "spr_ui_window_gold");
    }
    if (_which == "save_hires") {
        return scr_sprite_index("spr_menu_save_window_640", "spr_menu_panel_saves_640", "spr_menu_panel_saves_320", "spr_ui_window_gold");
    }
    return scr_sprite_index("spr_ui_window");
}

function scr_menu_sprite_cursor() {
    return scr_sprite_index("spr_menu_ui_cursor", "spr_ui_cursor_strip2");
}

function scr_menu_sprite_select_bar() {
    return scr_sprite_index("spr_menu_select_bar", "spr_ui_select_bar");
}

function scr_menu_sprite_save_point() {
    return scr_sprite_index("spr_menu_save_point", "spr_save_point", "spr_ui_save_point", "spr_interactable_placeholder");
}

/// Draw a menu window. Nine-slice fallbacks stretch to (_w, _h). Dedicated future
/// panels are also stretched; retune MENU_* constants if a fixed-size panel looks off.
function scr_menu_draw_window(_x, _y, _w, _h, _which = "normal") {
    var _spr = (_which == "normal" || _which == "dim" || _which == "gold")
        ? -1
        : scr_menu_sprite_window(_which);
    if (scr_sprite_is_valid(_spr)) {
        draw_sprite_stretched(_spr, 0, _x, _y, _w, _h);
        return;
    }
    var _kind = "normal";
    if (_which == "save" || _which == "save_hires" || _which == "gold") _kind = "gold";
    if (_which == "dim") _kind = "dim";
    scr_ui_window(_x, _y, _w, _h, _kind);
}

function scr_menu_draw_cursor(_x, _y) {
    var _spr = scr_menu_sprite_cursor();
    if (scr_sprite_is_valid(_spr)) {
        var _n = sprite_get_number(_spr);
        var _frame = floor(current_time * 0.001 * 4) mod max(1, _n);
        draw_sprite(_spr, _frame, _x, _y);
    } else {
        scr_ui_cursor(_x, _y);
    }
}

function scr_menu_draw_select_bar(_x, _y, _w, _h = 12) {
    var _bar = scr_menu_sprite_select_bar();
    if (scr_sprite_is_valid(_bar)) draw_sprite_stretched(_bar, 0, _x, _y, _w, _h);
}

function scr_menu_draw_dim(_gw, _gh) {
    draw_set_alpha(0.45);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
}

function scr_menu_format_playtime(_seconds) {
    var _s = max(0, floor(_seconds));
    var _hh = _s div 3600;
    var _mm = (_s div 60) mod 60;
    var _ss = _s mod 60;
    var _mms = (_mm < 10) ? ("0" + string(_mm)) : string(_mm);
    var _sss = (_ss < 10) ? ("0" + string(_ss)) : string(_ss);
    if (_hh > 0) return string(_hh) + ":" + _mms + ":" + _sss;
    return _mms + ":" + _sss;
}

/// Close every overlay menu. Safe if the objects have not been created in the IDE yet.
function scr_menu_close_all() {
    var _names = ["obj_inventory_menu", "obj_shop_menu", "obj_save_menu"];
    for (var _i = 0; _i < array_length(_names); _i++) {
        var _o = asset_get_index(_names[_i]);
        if (_o != -1 && instance_exists(_o)) instance_destroy(_o);
    }
    if (variable_global_exists("game") && is_struct(global.game)) global.game.menu_open = false;
}

function scr_menu_open_object(_object_name, _setup = undefined) {
    var _o = asset_get_index(_object_name);
    if (_o == -1) {
        show_debug_message("[menu] missing object " + _object_name);
        return noone;
    }
    scr_menu_close_all();
    var _inst = instance_create_depth(0, 0, -100000, _o);
    if (_inst != noone && instance_exists(_inst) && is_method(_setup)) {
        _setup(_inst);
    }
    return _inst;
}
