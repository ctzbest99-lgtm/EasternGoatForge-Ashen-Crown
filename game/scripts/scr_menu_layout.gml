/// scr_menu_layout — field-menu layout, colours, and sprite lookups.
/// Coordinates and nine-slice notes come from Design's README section
/// "Field menus: shop, save/load, inventory/equip" and ui/menus/mockups/.
/// Dedicated art is looked up first via scr_sprite_index / asset_get_index,
/// then we fall back to the existing nine-slice windows, font, cursor, and icons.

#macro MENU_GUI_W 320
#macro MENU_GUI_H 180

// Text colours (font is white; tint with draw_set_colour).
#macro MENU_COL_W make_color_rgb(240, 235, 223)   // #F0EBDF normal
#macro MENU_COL_Y make_color_rgb(217, 184, 96)    // #D9B860 selected / gold
#macro MENU_COL_G make_color_rgb(154, 146, 132)   // #9A9284 label
#macro MENU_COL_A make_color_rgb(125, 117, 112)   // #7D7570 disabled
#macro MENU_COL_DESC make_color_rgb(216, 208, 192) // #D8D0C0 description
#macro MENU_COL_SHADOW make_color_rgb(10, 10, 16) // #0A0A10

// Back-compat aliases used by older menu snippets.
#macro MENU_GOLD_COL MENU_COL_Y
#macro MENU_DIM_COL MENU_COL_G
#macro MENU_DISABLED_COL MENU_COL_A

#macro MENU_ROW_H 16
#macro MENU_TAB_H 15
#macro MENU_TAB_W 40
#macro MENU_TAB_RISE 12
#macro MENU_TAB_NORMAL_SLIDE 2

// Shop
#macro MENU_SHOP_HEADER_X 4
#macro MENU_SHOP_HEADER_Y 4
#macro MENU_SHOP_HEADER_W 228
#macro MENU_SHOP_HEADER_H 58
#macro MENU_SHOP_GOLD_X 236
#macro MENU_SHOP_GOLD_Y 4
#macro MENU_SHOP_GOLD_W 80
#macro MENU_SHOP_GOLD_H 20
#macro MENU_SHOP_OWNED_X 236
#macro MENU_SHOP_OWNED_Y 26
#macro MENU_SHOP_OWNED_W 80
#macro MENU_SHOP_OWNED_H 36
#macro MENU_SHOP_LIST_X 4
#macro MENU_SHOP_LIST_Y 76
#macro MENU_SHOP_LIST_W 196
#macro MENU_SHOP_LIST_H 100
#macro MENU_SHOP_LIST_ROWS 5
#macro MENU_SHOP_LIST_ROW0 82
#macro MENU_SHOP_INFO_X 204
#macro MENU_SHOP_INFO_Y 64
#macro MENU_SHOP_INFO_W 112
#macro MENU_SHOP_INFO_H 112
#macro MENU_SHOP_TAB0_X 10
#macro MENU_SHOP_TAB_Y 64
#macro MENU_SHOP_TAB_DX 42
#macro MENU_SHOP_QTY_X 92
#macro MENU_SHOP_QTY_Y 104
#macro MENU_SHOP_QTY_W 104
#macro MENU_SHOP_QTY_H 54

// Save / load
#macro MENU_SAVE_TITLE_X 4
#macro MENU_SAVE_TITLE_Y 4
#macro MENU_SAVE_TITLE_W 312
#macro MENU_SAVE_TITLE_H 20
#macro MENU_SAVE_SLOT_X 20
#macro MENU_SAVE_SLOT_Y0 28
#macro MENU_SAVE_SLOT_W 296
#macro MENU_SAVE_SLOT_H 46
#macro MENU_SAVE_SLOT_DY 50
#macro MENU_SAVE_SLOT_COUNT 3
#macro MENU_SAVE_OW_X 80
#macro MENU_SAVE_OW_Y 62
#macro MENU_SAVE_OW_W 160
#macro MENU_SAVE_OW_H 56
#macro MENU_TOAST_X 160
#macro MENU_TOAST_Y 8
#macro MENU_TOAST_FROM_Y -20
#macro MENU_TOAST_SLIDE 6
#macro MENU_TOAST_HOLD 60
#macro MENU_TOAST_FADE 20

// Inventory
#macro MENU_INV_MAIN_X 4
#macro MENU_INV_MAIN_Y 16
#macro MENU_INV_MAIN_W 200
#macro MENU_INV_MAIN_H 130
#macro MENU_INV_DESC_X 4
#macro MENU_INV_DESC_Y 148
#macro MENU_INV_DESC_W 200
#macro MENU_INV_DESC_H 28
#macro MENU_INV_GOLD_X 208
#macro MENU_INV_GOLD_Y 156
#macro MENU_INV_GOLD_W 108
#macro MENU_INV_GOLD_H 20
#macro MENU_INV_PARTY_X 208
#macro MENU_INV_PARTY_Y 4
#macro MENU_INV_PARTY_W 108
#macro MENU_INV_PARTY_H 150
#macro MENU_INV_TAB0_X 10
#macro MENU_INV_TAB_Y 4
#macro MENU_INV_TAB_DX 42
#macro MENU_INV_LIST_ROWS 7
#macro MENU_INV_LIST_ROW0 22
#macro MENU_INV_PARTY_BLOCK 36
#macro MENU_INV_PARTY_ROW0 10
#macro MENU_INV_TGT_X 96
#macro MENU_INV_TGT_Y 50
#macro MENU_INV_TGT_W 184
#macro MENU_INV_TGT_ROW 18

/// First existing sprite among reserved Design names, then fallbacks.
function scr_menu_sprite_window(_which) {
    if (_which == "shop" || _which == "inventory" || _which == "normal") {
        return scr_sprite_index("spr_menu_shop_window", "spr_ui_menu_shop", "spr_ui_window");
    }
    if (_which == "gold") return scr_sprite_index("spr_ui_window_gold", "spr_ui_window");
    if (_which == "dim") return scr_sprite_index("spr_ui_window_dim", "spr_ui_window");
    if (_which == "save" || _which == "save_hires") {
        return scr_sprite_index("spr_menu_save_window", "spr_ui_menu_saves", "spr_menu_panel_saves_320", "spr_ui_window_gold");
    }
    return scr_sprite_index("spr_ui_window");
}

function scr_menu_sprite_cursor() {
    return scr_sprite_index("spr_menu_ui_cursor", "spr_ui_cursor_strip2");
}

function scr_menu_sprite_row_select(_disabled = false) {
    if (_disabled) {
        return scr_sprite_index("spr_ui_row_select_disabled", "spr_ui_select_bar", "spr_ui_row_select");
    }
    return scr_sprite_index("spr_ui_row_select", "spr_ui_select_bar");
}

function scr_menu_sprite_select_bar() {
    return scr_sprite_index("spr_ui_select_bar", "spr_ui_row_select");
}

function scr_menu_sprite_tab(_id, _selected) {
    var _state = _selected ? "selected" : "normal";
    var _name = "spr_ui_tab_" + string(_id) + "_" + _state;
    var _spr = scr_sprite_index(_name);
    if (scr_sprite_is_valid(_spr)) return _spr;
    return scr_sprite_index("spr_ui_tab_blank_strip2");
}

function scr_menu_sprite_save_point_idle() {
    return scr_sprite_index("spr_save_point_idle_strip8", "spr_save_point", "spr_menu_save_point", "spr_ui_save_point", "spr_interactable_placeholder");
}

function scr_menu_sprite_save_point_activate() {
    return scr_sprite_index("spr_save_point_activate_strip8", "spr_save_point_idle_strip8");
}

function scr_menu_sprite_save_point() {
    return scr_menu_sprite_save_point_idle();
}

function scr_menu_draw_window(_x, _y, _w, _h, _which = "normal") {
    var _kind = "normal";
    if (_which == "gold" || _which == "save" || _which == "save_hires") _kind = "gold";
    if (_which == "dim") _kind = "dim";
    var _spr = scr_sprite_index(
        (_kind == "gold") ? "spr_ui_window_gold" : ((_kind == "dim") ? "spr_ui_window_dim" : "spr_ui_window")
    );
    if (scr_sprite_is_valid(_spr)) {
        draw_sprite_stretched(_spr, 0, _x, _y, _w, _h);
        return;
    }
    scr_ui_window(_x, _y, _w, _h, _kind);
}

function scr_menu_draw_dither() {
    var _spr = scr_sprite_index("spr_ui_dither");
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    if (scr_sprite_is_valid(_spr)) {
        draw_sprite_tiled(_spr, 0, 0, 0);
        return;
    }
    draw_set_alpha(0.45);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
}

function scr_menu_text(_x, _y, _str, _col = MENU_COL_W) {
    scr_ui_set_font();
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_col);
    draw_text(_x, _y, _str);
}

function scr_menu_text_right(_x, _y, _str, _col = MENU_COL_W) {
    scr_ui_set_font();
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(_col);
    draw_text(_x, _y, _str);
    draw_set_halign(fa_left);
}

function scr_menu_text_center(_x, _y, _str, _col = MENU_COL_W) {
    scr_ui_set_font();
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_col);
    draw_text(_x, _y, _str);
    draw_set_halign(fa_left);
}

function scr_menu_text_wrap(_x, _y, _str, _w, _sep = 11, _col = MENU_COL_DESC) {
    scr_ui_set_font();
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_col);
    draw_text_ext(_x, _y, _str, _sep, _w);
}

/// Draw a sprite so its top-left lands at (_x,_y), regardless of origin.
function scr_menu_draw_tl(_spr, _sub, _x, _y) {
    if (!scr_sprite_is_valid(_spr)) return;
    draw_sprite(_spr, _sub, _x + sprite_get_xoffset(_spr), _y + sprite_get_yoffset(_spr));
}

/// Cursor: origin is the tip (15,4). `_x,_y` is the tip position.
function scr_menu_draw_cursor_tip(_x, _y) {
    var _spr = scr_menu_sprite_cursor();
    if (scr_sprite_is_valid(_spr)) {
        var _n = sprite_get_number(_spr);
        var _frame = floor(current_time * 0.001 * 4) mod max(1, _n);
        draw_sprite(_spr, _frame, _x, _y);
    } else {
        scr_ui_cursor(_x, _y);
    }
}

function scr_menu_draw_cursor(_x, _y) {
    scr_menu_draw_cursor_tip(_x, _y);
}

function scr_menu_arrow_bob() {
    return ((current_time div 250) mod 2);
}

function scr_menu_draw_arrow(_frame, _x, _y, _bob = true) {
    var _spr = scr_sprite_index("spr_ui_arrow_strip4");
    var _oy = _y;
    if (_bob) _oy += scr_menu_arrow_bob();
    if (scr_sprite_is_valid(_spr)) {
        var _n = sprite_get_number(_spr);
        draw_sprite(_spr, clamp(_frame, 0, _n - 1), _x, _oy);
    } else {
        draw_set_color(MENU_COL_Y);
        if (_frame == 0 || _frame == 2) draw_triangle(_x, _oy + 5, _x + 8, _oy + 5, _x + 4, _oy, false);
        else draw_triangle(_x, _oy, _x + 8, _oy, _x + 4, _oy + 5, false);
    }
}

function scr_menu_draw_stat_arrow(_dir, _x, _y) {
    // 0 up, 1 down, 2 equal
    var _spr = scr_sprite_index("spr_ui_stat_arrow_strip3");
    if (scr_sprite_is_valid(_spr)) {
        draw_sprite(_spr, clamp(_dir, 0, sprite_get_number(_spr) - 1), _x, _y);
        return;
    }
    if (_dir == 0) { draw_set_color(make_color_rgb(80, 180, 80)); draw_triangle(_x, _y + 6, _x + 6, _y + 6, _x + 3, _y, false); }
    else if (_dir == 1) { draw_set_color(make_color_rgb(200, 60, 60)); draw_triangle(_x, _y, _x + 6, _y, _x + 3, _y + 6, false); }
    else { draw_set_color(MENU_COL_G); draw_text(_x, _y - 1, "="); }
}

function scr_menu_draw_icon(_name, _x, _y) {
    var _spr = scr_sprite_index(_name);
    if (scr_sprite_is_valid(_spr)) scr_menu_draw_tl(_spr, 0, _x, _y);
}

function scr_menu_draw_tabs(_ids, _selected, _x0, _y_selected, _dx) {
    for (var _i = 0; _i < array_length(_ids); _i++) {
        var _sel = (_i == _selected);
        var _spr = scr_menu_sprite_tab(_ids[_i], _sel);
        var _tx = _x0 + _i * _dx;
        var _ty = _sel ? _y_selected : (_y_selected + MENU_TAB_NORMAL_SLIDE);
        if (scr_sprite_is_valid(_spr)) {
            var _sub = 0;
            if (sprite_get_name(_spr) == "spr_ui_tab_blank_strip2" || sprite_get_number(_spr) > 1) {
                _sub = _sel ? min(1, sprite_get_number(_spr) - 1) : 0;
            }
            scr_menu_draw_tl(_spr, _sub, _tx, _ty);
            // Label fallback when using the blank strip (or a missing baked tab).
            var _nm = sprite_get_name(_spr);
            if (_nm == "spr_ui_tab_blank_strip2" || _nm == "<undefined>" || _nm == "") {
                var _label = string_upper(string_copy(_ids[_i], 1, 1)) + string_delete(_ids[_i], 1, 1);
                scr_menu_text(_tx + 4, _ty + (_sel ? 3 : 5), _label, _sel ? MENU_COL_Y : MENU_COL_W);
            }
        } else {
            var _label2 = string_upper(string_copy(_ids[_i], 1, 1)) + string_delete(_ids[_i], 1, 1);
            scr_menu_text(_tx + 4, _ty + (_sel ? 3 : 5), _label2, _sel ? MENU_COL_Y : MENU_COL_W);
        }
    }
}

function scr_menu_draw_row_select(_x, _y, _w, _disabled = false) {
    var _spr = scr_menu_sprite_row_select(_disabled);
    if (scr_sprite_is_valid(_spr)) draw_sprite_stretched(_spr, 0, _x, _y, _w, MENU_ROW_H);
}

function scr_menu_draw_item_icon(_item_id, _x, _y, _disabled = false) {
    var _spr = -1;
    if (_disabled) {
        var _key = string(_item_id);
        if (string_copy(_key, 1, 5) == "item_") _key = string_delete(_key, 1, 5);
        _spr = scr_sprite_index("spr_item_" + _key + "_disabled");
        if (!scr_sprite_is_valid(_spr) && _key == "mira_pendant") _spr = scr_sprite_index("spr_item_mira_pendant_disabled");
        if (!scr_sprite_is_valid(_spr) && (_key == "blackguard_longsword" || _key == "blackguards_longsword")) {
            _spr = scr_sprite_index("spr_item_blackguards_longsword_disabled");
        }
    }
    if (!scr_sprite_is_valid(_spr)) _spr = scr_ch1_item_sprite(_item_id);
    if (scr_sprite_is_valid(_spr)) {
        if (_disabled && string_pos("_disabled", sprite_get_name(_spr)) <= 0) {
            draw_sprite_ext(_spr, 0, _x + sprite_get_xoffset(_spr), _y + sprite_get_yoffset(_spr), 1, 1, 0, MENU_COL_A, 1);
        } else {
            scr_menu_draw_tl(_spr, 0, _x, _y);
        }
    }
}

function scr_menu_party_icon(_actor_id) {
    var _id = string(_actor_id);
    return scr_sprite_index("spr_ui_party_icon_" + _id, "spr_ui_party_icon_none");
}

function scr_menu_draw_party_icon(_actor_id, _x, _y) {
    var _spr = scr_menu_party_icon(_actor_id);
    if (scr_sprite_is_valid(_spr)) scr_menu_draw_tl(_spr, 0, _x, _y);
}

function scr_menu_leader_sprite(_actor_id) {
    var _id = string(_actor_id);
    if (_id == "kael") return scr_sprite_index("spr_kael_ow16_idle_down", "spr_kael_ow_idle_down");
    return scr_sprite_index("spr_" + _id + "_ow16_idle_down", "spr_" + _id + "_ow_idle_down");
}

function scr_menu_format_playtime(_seconds) {
    return scr_menu_format_playtime_hm(_seconds);
}

function scr_menu_format_playtime_hm(_seconds) {
    var _s = max(0, floor(_seconds));
    var _hh = _s div 3600;
    var _mm = (_s div 60) mod 60;
    var _hhs = (_hh < 10) ? ("0" + string(_hh)) : string(_hh);
    var _mms = (_mm < 10) ? ("0" + string(_mm)) : string(_mm);
    return _hhs + ":" + _mms;
}

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
    if (_inst != noone && instance_exists(_inst) && is_method(_setup)) _setup(_inst);
    return _inst;
}

function scr_menu_toast_saved() {
    var _o = asset_get_index("obj_save_toast");
    if (_o != -1) {
        if (instance_exists(_o)) instance_destroy(_o);
        instance_create_depth(0, 0, -100001, _o);
        return;
    }
    show_debug_message("[save] saved (no obj_save_toast).");
}

/// Shared save/load slot column. Used by obj_save_menu and the title Continue panel.
function scr_menu_draw_save_slots(_slots, _index, _mode, _hint, _message) {
    var _title = (_mode == "load") ? "Load" : "Save";
    scr_menu_draw_window(MENU_SAVE_TITLE_X, MENU_SAVE_TITLE_Y, MENU_SAVE_TITLE_W, MENU_SAVE_TITLE_H, "normal");
    scr_menu_text(12, 9, _title, MENU_COL_Y);
    var _right = (_message != "") ? _message : _hint;
    scr_menu_text_right(308, 9, _right, MENU_COL_G);

    for (var _i = 0; _i < MENU_SAVE_SLOT_COUNT; _i++) {
        var _info = (array_length(_slots) > _i) ? _slots[_i] : { exists: false, ok: false, empty: true, corrupt: false, location_name: "", lead_level: 1, lead_name: "", lead_id: "", party_ids: [], playtime_seconds: 0, gold: 0 };
        var _sy = MENU_SAVE_SLOT_Y0 + _i * MENU_SAVE_SLOT_DY;
        var _sx = MENU_SAVE_SLOT_X;
        var _sel = (_i == _index);
        var _kind = "normal";
        if (_sel) _kind = "gold";
        else if (_info.empty || !_info.exists) _kind = "dim";
        scr_menu_draw_window(_sx, _sy, MENU_SAVE_SLOT_W, MENU_SAVE_SLOT_H, _kind);
        if (_sel) scr_menu_draw_cursor_tip(17, _sy + 23);

        var _fr = scr_sprite_index("spr_ui_leader_frame");
        if (scr_sprite_is_valid(_fr)) scr_menu_draw_tl(_fr, 0, _sx + 6, _sy + 9);
        else scr_menu_draw_window(_sx + 6, _sy + 9, 20, 28, "dim");

        if (_info.empty || !_info.exists) {
            var _col_g = MENU_COL_G;
            scr_menu_text(_sx + 32, _sy + 6, "Slot " + string(_i + 1), _col_g);
            scr_menu_text_center(_sx + 162, _sy + 19, "- Empty -", _col_g);
        } else if (_info.corrupt || !_info.ok) {
            scr_menu_text(_sx + 32, _sy + 6, "Slot " + string(_i + 1), _sel ? MENU_COL_Y : MENU_COL_W);
            scr_menu_text(_sx + 32, _sy + 19, "Damaged save", make_color_rgb(200, 80, 80));
        } else {
            var _lead_spr = scr_menu_leader_sprite(variable_struct_exists(_info, "lead_id") ? _info.lead_id : "kael");
            if (scr_sprite_is_valid(_lead_spr)) {
                draw_sprite(_lead_spr, 0, _sx + 8 + sprite_get_xoffset(_lead_spr), _sy + 11 + sprite_get_yoffset(_lead_spr));
            }
            var _yc = _sel ? MENU_COL_Y : MENU_COL_W;
            scr_menu_text(_sx + 32, _sy + 6, "Slot " + string(_i + 1), _yc);
            scr_menu_text(_sx + 82, _sy + 6, string(_info.location_name), _yc);
            var _lname = variable_struct_exists(_info, "lead_name") && _info.lead_name != "" ? _info.lead_name : "Kael";
            scr_menu_text(_sx + 32, _sy + 19, _lname, MENU_COL_W);
            scr_menu_text(_sx + 82, _sy + 19, "Lv " + string(_info.lead_level), MENU_COL_W);
            var _pids = (variable_struct_exists(_info, "party_ids") && is_array(_info.party_ids)) ? _info.party_ids : [];
            var _pn = min(4, array_length(_pids));
            if (_pn == 0 && variable_struct_exists(_info, "lead_id") && _info.lead_id != "") {
                _pids = [_info.lead_id];
                _pn = 1;
            }
            for (var _p = 0; _p < _pn; _p++) {
                scr_menu_draw_party_icon(_pids[_p], _sx + 32 + 14 * _p, _sy + 31);
            }
            scr_menu_draw_icon("spr_ui_icon_clock", _sx + 234, _sy + 20);
            scr_menu_text_right(_sx + 286, _sy + 19, scr_menu_format_playtime_hm(_info.playtime_seconds), MENU_COL_W);
            scr_menu_draw_icon("spr_ui_icon_coin", _sx + 234, _sy + 33);
            scr_menu_text_right(_sx + 286, _sy + 32, string(_info.gold), MENU_COL_W);
        }
    }
}

function scr_menu_draw_overwrite(_slot_n, _location, _level, _on_no) {
    scr_menu_draw_dither();
    scr_menu_draw_window(MENU_SAVE_OW_X, MENU_SAVE_OW_Y, MENU_SAVE_OW_W, MENU_SAVE_OW_H, "gold");
    scr_menu_text_center(160, 68, "Overwrite Slot " + string(_slot_n) + "?", MENU_COL_W);
    var _sub = string(_location) + "  Lv " + string(_level);
    scr_menu_text_center(160, 80, _sub, MENU_COL_G);
    scr_menu_text(124, 98, "Yes", (!_on_no) ? MENU_COL_Y : MENU_COL_W);
    scr_menu_text(184, 98, "No", _on_no ? MENU_COL_Y : MENU_COL_W);
    // Cursor starts on No; tip at (181,102) or (121,102) for Yes.
    scr_menu_draw_cursor_tip(_on_no ? 181 : 121, 102);
}

function scr_menu_equipped_count(_item_id) {
    scr_game_state_init();
    var _n = 0;
    var _want = scr_item_id_norm(_item_id);
    var _list = global.game.roster;
    if (!is_array(_list)) return 0;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _a = _list[_i];
        if (!is_struct(_a) || !is_struct(_a.equipment)) continue;
        var _slots = ["weapon", "armor", "helm", "accessory"];
        for (var _s = 0; _s < 4; _s++) {
            var _eq = _a.equipment[$ _slots[_s]];
            if (is_string(_eq) && _eq != "" && scr_item_id_norm(_eq) == _want) _n += 1;
        }
    }
    return _n;
}

function scr_menu_shop_row_y(_shown) {
    return MENU_SHOP_LIST_ROW0 + _shown * MENU_ROW_H;
}

function scr_menu_inv_row_y(_shown) {
    return MENU_INV_LIST_ROW0 + _shown * MENU_ROW_H;
}

function scr_menu_inv_party() {
    scr_game_state_init();
    var _out = [];
    var _lists = [global.game.party, global.game.reserve];
    for (var _l = 0; _l < 2; _l++) {
        if (!is_array(_lists[_l])) continue;
        for (var _i = 0; _i < array_length(_lists[_l]); _i++) {
            if (is_struct(_lists[_l][_i])) array_push(_out, _lists[_l][_i]);
        }
    }
    return _out;
}

/// Item ids for the Items (0) or Key (2) tab.
function scr_menu_inv_list(_tab) {
    scr_game_state_init();
    var _out = [];
    var _inv = global.game.inventory;
    if (!is_array(_inv)) return _out;
    for (var _i = 0; _i < array_length(_inv); _i++) {
        var _e = _inv[_i];
        if (!is_struct(_e)) continue;
        var _key = (variable_struct_exists(_e, "key_item") && _e.key_item) || scr_item_is_key(_e.item_id);
        if (_tab == 2 && _key) array_push(_out, _e.item_id);
        if (_tab == 0 && !_key) array_push(_out, _e.item_id);
    }
    return _out;
}

function scr_menu_slot_name(_i) {
    var _names = ["weapon", "armor", "helm", "accessory"];
    return _names[clamp(_i, 0, 3)];
}

function scr_menu_slot_label(_i) {
    var _labels = ["Weapon", "Armor", "Helm", "Accessory"];
    return _labels[clamp(_i, 0, 3)];
}

/// Inventory items that this member can put in the given slot.
function scr_menu_inv_candidates(_actor, _slot_index) {
    var _slot = scr_menu_slot_name(_slot_index);
    var _out = [];
    var _inv = global.game.inventory;
    if (!is_array(_inv) || !is_struct(_actor)) return _out;
    for (var _i = 0; _i < array_length(_inv); _i++) {
        var _e = _inv[_i];
        if (!is_struct(_e)) continue;
        var _it = scr_item_get(_e.item_id);
        if (_it.slot != _slot) continue;
        if (!scr_item_can_equip(_actor, _e.item_id)) continue;
        array_push(_out, _e.item_id);
    }
    return _out;
}

function scr_menu_actor_stat(_actor, _stat) {
    if (!is_struct(_actor)) return 0;
    switch (_stat) {
        case "HP": return _actor.hp;
        case "MP": return variable_struct_exists(_actor, "mp") ? _actor.mp : 0;
        case "ATK": return _actor.attack;
        case "DEF": return _actor.defense;
        case "MAG": return variable_struct_exists(_actor, "magic") ? _actor.magic : 0;
        case "MDF": return variable_struct_exists(_actor, "magic_defense") ? _actor.magic_defense : 0;
        case "SPD": return variable_struct_exists(_actor, "speed") ? _actor.speed : 0;
    }
    return 0;
}

function scr_menu_actor_stat_new(_actor, _stat, _item_id) {
    var _cur = scr_menu_actor_stat(_actor, _stat);
    if (_item_id == "" || !is_struct(_actor)) return _cur;
    if (_stat != "ATK" && _stat != "DEF") return _cur;
    var _it = scr_item_get(_item_id);
    var _b = scr_item_equip_bonuses(_item_id);
    scr_actor_ensure_bases(_actor);
    var _slots = ["weapon", "armor", "helm", "accessory"];
    var _atk_other = 0;
    var _def_other = 0;
    for (var _i = 0; _i < 4; _i++) {
        if (_slots[_i] == _it.slot) continue;
        var _ob = scr_item_equip_bonuses(scr_actor_equipped_in_slot(_actor, _slots[_i]));
        _atk_other += _ob.atk;
        _def_other += _ob.def;
    }
    if (_stat == "ATK") return _actor.base_attack + _atk_other + _b.atk;
    return _actor.base_defense + _def_other + _b.def;
}
