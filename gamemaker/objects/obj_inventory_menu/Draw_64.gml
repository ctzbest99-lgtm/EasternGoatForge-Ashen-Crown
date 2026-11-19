/// obj_inventory_menu : Draw GUI
scr_ui_set_font();
scr_menu_draw_dither();

var _party = scr_menu_inv_party();
if (member_index >= array_length(_party)) member_index = 0;
var _items = scr_menu_inv_list(tab);

// Main list window, then Items/Equip/Key/Materials tabs on its top border.
scr_menu_draw_window(MENU_INV_MAIN_X, MENU_INV_MAIN_Y, MENU_INV_MAIN_W, MENU_INV_MAIN_H, "normal");
scr_menu_draw_tabs(["items", "equip", "key", "materials"], tab, MENU_INV_TAB0_X, MENU_INV_TAB_Y, MENU_INV_TAB_DX);

var _desc = "";

if (tab != 1) {
    var _n = array_length(_items);
    if (_n == 0) {
        scr_menu_text(12, MENU_INV_LIST_ROW0 + 4, (tab == 2) ? "(no key items)" : ((tab == 3) ? "(no materials)" : "(empty)"), MENU_COL_G);
    } else {
        var _shown = 0;
        for (var _i = scroll; _i < _n && _shown < MENU_INV_LIST_ROWS; _i++) {
            var _id = _items[_i];
            var _it = scr_item_get(_id);
            var _row_y = scr_menu_inv_row_y(_shown);
            var _here = (_i == index && mode != "target");
            if (_here || (_i == index && mode == "target")) {
                scr_menu_draw_row_select(22, _row_y, 172, false);
                if (mode != "target") scr_menu_draw_cursor_tip(21, _row_y + 8);
            }
            scr_menu_draw_item_icon(_id, 26, _row_y, false);
            var _col = (_i == index) ? MENU_COL_Y : MENU_COL_W;
            scr_menu_text(46, _row_y + 4, _it.name, _col);
            if (tab == 2 || _it.key_item) {
                scr_menu_draw_icon("spr_ui_icon_key", 186, _row_y + 4);
            } else {
                var _qty = scr_inventory_count(_id);
                scr_menu_text_right(194, _row_y + 4, "x" + string(_qty), MENU_COL_DESC);
            }
            if (_i == index) _desc = _it.desc;
            _shown += 1;
        }
        if (scroll > 0) scr_menu_draw_arrow(0, 180, 13, true);
        if (scroll + MENU_INV_LIST_ROWS < _n) scr_menu_draw_arrow(1, 180, 143, true);
    }
} else {
    // Equip tab: member header + four slots + "Change to" candidates.
    var _actor = (array_length(_party) > 0) ? _party[member_index] : undefined;
    if (is_struct(_actor)) {
        var _fr = scr_sprite_index("spr_ui_party_frame_strip2");
        var _fsub = 1;
        if (scr_sprite_is_valid(_fr)) scr_menu_draw_tl(_fr, _fsub, 10, 22);
        scr_menu_draw_party_icon(_actor.actor_id, 11, 23);
        scr_menu_text(30, 25, _actor.name, MENU_COL_Y);
        var _class = variable_struct_exists(_actor, "class_name") ? _actor.class_name : "";
        if (_class != "") scr_menu_text_right(196, 25, _class, MENU_COL_G);

        // Seven slots in two columns: 4 left, 3 right. The item icon shows what is worn;
        // the selected slot's name and description fill the description box.
        var _slot_ids = scr_equipment_slots();
        var _slot_short = ["Main", "Off", "Head", "Body", "Legs", "Acc 1", "Acc 2"];
        var _slot_spr = ["spr_ui_slot_weapon", "spr_ui_slot_weapon", "spr_ui_slot_helm",
                         "spr_ui_slot_armor", "spr_ui_slot_armor", "spr_ui_slot_accessory", "spr_ui_slot_accessory"];
        for (var _s = 0; _s < array_length(_slot_ids); _s++) {
            var _col = (_s < 4) ? 0 : 1;
            var _row = (_s < 4) ? _s : _s - 4;
            var _sx = 12 + _col * 92;
            var _sy = 40 + 16 * _row;
            var _eq = scr_actor_equipped_in_slot(_actor, _slot_ids[_s]);
            if (mode == "slots" && _s == slot_index) {
                scr_menu_draw_row_select(_sx, _sy, 88, false);
                scr_menu_draw_cursor_tip(_sx - 1, _sy + 8);
            }
            if (_eq != "") scr_menu_draw_item_icon(_eq, _sx + 4, _sy, false);
            else {
                var _glyph = scr_sprite_index(_slot_spr[_s]);
                if (scr_sprite_is_valid(_glyph)) scr_menu_draw_tl(_glyph, 0, _sx + 4, _sy);
            }
            scr_menu_text(_sx + 22, _sy + 4, _slot_short[_s], MENU_COL_G);
            if (mode == "slots" && _s == slot_index) {
                _desc = (_eq != "") ? (scr_item_get(_eq).name + " \u2014 " + scr_item_get(_eq).desc) : "(empty)";
            }
        }

        scr_menu_text(10, 108, "Change to", MENU_COL_G);
        var _cands = scr_menu_inv_candidates(_actor, slot_index);
        var _shown_c = 0;
        var _cvis = 2;
        for (var _c = cand_scroll; _c < array_length(_cands) && _shown_c < _cvis; _c++) {
            var _cid = _cands[_c];
            var _cy = 120 + 16 * _shown_c;
            var _csel = (mode == "pick" && _c == cand_index);
            if (_csel) {
                var _bar = scr_menu_sprite_select_bar();
                if (scr_sprite_is_valid(_bar)) draw_sprite_stretched(_bar, 0, 12, _cy, 176, 16);
                scr_menu_draw_cursor_tip(21, _cy + 8);
            }
            scr_menu_draw_item_icon(_cid, 26, _cy, false);
            scr_menu_text(46, _cy + 4, scr_item_get(_cid).name, _csel ? MENU_COL_Y : MENU_COL_W);
            scr_menu_text_right(194, _cy + 4, "x" + string(scr_inventory_count(_cid)), MENU_COL_DESC);
            if (_csel) _desc = scr_item_preview_line(_actor, _cid);
            _shown_c += 1;
        }
    }
}

// Description + gold
scr_menu_draw_window(MENU_INV_DESC_X, MENU_INV_DESC_Y, MENU_INV_DESC_W, MENU_INV_DESC_H, "normal");
if (message != "") {
    scr_menu_text_wrap(10, 152, message, 188, 11, MENU_COL_Y);
} else if (_desc != "") {
    scr_menu_text_wrap(10, 152, _desc, 188, 11, MENU_COL_DESC);
}
scr_menu_draw_window(MENU_INV_GOLD_X, MENU_INV_GOLD_Y, MENU_INV_GOLD_W, MENU_INV_GOLD_H, "normal");
scr_menu_draw_icon("spr_ui_icon_coin", 214, 162);
scr_menu_text_right(308, 161, string(global.game.gold), MENU_COL_W);

// Party pane (Items/Key) or stats pane (Equip)
if (tab != 1) {
    scr_menu_draw_window(MENU_INV_PARTY_X, MENU_INV_PARTY_Y, MENU_INV_PARTY_W, MENU_INV_PARTY_H, "normal");
    for (var _p = 0; _p < array_length(_party) && _p < 4; _p++) {
        var _a = _party[_p];
        var _y = MENU_INV_PARTY_ROW0 + MENU_INV_PARTY_BLOCK * _p;
        scr_menu_draw_party_icon(_a.actor_id, 214, _y);
        scr_menu_text(230, _y + 1, _a.name, MENU_COL_W);
        scr_menu_text_right(308, _y + 1, "Lv " + string(_a.level), MENU_COL_G);
        scr_menu_text(214, _y + 14, "HP", MENU_COL_Y);
        scr_ui_hp_bar(230, _y + 16, _a.hp, _a.max_hp, 48);
        scr_menu_text_right(308, _y + 24, string(_a.hp) + "/" + string(_a.max_hp), MENU_COL_W);
    }
} else {
    scr_menu_draw_window(MENU_INV_PARTY_X, MENU_INV_PARTY_Y, MENU_INV_PARTY_W, MENU_INV_PARTY_H, "normal");
    var _actor2 = (array_length(_party) > 0) ? _party[member_index] : undefined;
    if (is_struct(_actor2)) {
        scr_menu_draw_party_icon(_actor2.actor_id, 214, 10);
        scr_menu_text(230, 11, _actor2.name, MENU_COL_W);
        scr_menu_text_right(308, 11, "Lv " + string(_actor2.level), MENU_COL_G);
        var _preview_id = "";
        if (mode == "pick") {
            var _cands3 = scr_menu_inv_candidates(_actor2, slot_index);
            if (cand_index >= 0 && cand_index < array_length(_cands3)) _preview_id = _cands3[cand_index];
        }
        // All ten derived stats; the last four are the new equipment-facing ones.
        var _stats = ["HP", "MP", "ATK", "DEF", "MAG", "MDF", "SPD", "ACC", "EVA", "CRIT"];
        for (var _si = 0; _si < array_length(_stats); _si++) {
            var _sy2 = 28 + 11 * _si;
            var _st = _stats[_si];
            var _cur = scr_menu_actor_stat(_actor2, _st);
            var _label = _st;
            var _cur_s = string(_cur);
            if (_st == "HP") _cur_s = string(_actor2.hp) + "/" + string(_actor2.max_hp);
            if (_st == "MP") {
                var _maxmp = variable_struct_exists(_actor2, "max_mp") ? _actor2.max_mp : 0;
                _cur_s = string(_cur) + "/" + string(_maxmp);
            }
            if (_st == "CRIT") _cur_s += "%";
            scr_menu_text(214, _sy2, _label, MENU_COL_G);
            scr_menu_text_right(270, _sy2, _cur_s, MENU_COL_W);
            // HP/MP previews would be max-side changes, so only the other eight preview here.
            if (_preview_id != "" && _st != "HP" && _st != "MP") {
                var _nw = scr_menu_actor_stat_new(_actor2, _st, _preview_id);
                scr_menu_text(276, _sy2, ">", MENU_COL_G);
                var _ncol = (_nw > _cur) ? MENU_COL_Y : MENU_COL_W;
                var _nw_s = string(_nw) + ((_st == "CRIT") ? "%" : "");
                scr_menu_text_right(300, _sy2, _nw_s, _ncol);
                var _dir = (_nw > _cur) ? 0 : ((_nw < _cur) ? 1 : 2);
                scr_menu_draw_stat_arrow(_dir, 302, _sy2 + 1);
            }
        }
    }
}

// Target picker for a consumable
if (mode == "target" && array_length(_items) > index) {
    var _tid = _items[index];
    var _tit = scr_item_get(_tid);
    var _who = scr_party_members_for_item(_tid);
    var _members = array_length(_who);
    var _th = 26 + 18 * max(1, _members);
    scr_menu_draw_dither();
    scr_menu_draw_window(MENU_INV_TGT_X, MENU_INV_TGT_Y, MENU_INV_TGT_W, _th, "gold");
    scr_menu_draw_item_icon(_tid, 102, 54, false);
    scr_menu_text(122, 58, _tit.name, MENU_COL_Y);
    scr_menu_text_right(272, 58, "x" + string(scr_inventory_count(_tid)), MENU_COL_W);
    for (var _t = 0; _t < _members; _t++) {
        var _ty = 74 + 18 * _t;
        var _sel = (_t == target_index);
        if (_sel) scr_menu_draw_cursor_tip(113, _ty + 6);
        scr_menu_draw_party_icon(_who[_t].actor_id, 116, _ty);
        scr_menu_text(132, _ty + 2, _who[_t].name, _sel ? MENU_COL_Y : MENU_COL_W);
        scr_ui_hp_bar(166, _ty + 4, _who[_t].hp, _who[_t].max_hp, 48);
        scr_menu_text_right(272, _ty + 2, string(_who[_t].hp) + "/" + string(_who[_t].max_hp), MENU_COL_W);
    }
}
