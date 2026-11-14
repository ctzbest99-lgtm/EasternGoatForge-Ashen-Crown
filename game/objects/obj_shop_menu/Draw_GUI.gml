/// obj_shop_menu : Draw GUI
scr_ui_set_font();
scr_menu_draw_dither();

if (!is_struct(shop)) exit;

var _buy_ids = is_array(shop.items) ? shop.items : [];
var _sell_list = scr_shop_sellable_list();
var _portrait_who = variable_struct_exists(shop, "keeper") ? shop.keeper : "";
var _lines = (tab == 1 && variable_struct_exists(shop, "lines_sell")) ? shop.lines_sell : (variable_struct_exists(shop, "lines_buy") ? shop.lines_buy : []);

// Header
scr_menu_draw_window(MENU_SHOP_HEADER_X, MENU_SHOP_HEADER_Y, MENU_SHOP_HEADER_W, MENU_SHOP_HEADER_H, "normal");
var _pfr = scr_sprite_index("spr_ui_portrait_frame");
if (scr_sprite_is_valid(_pfr)) scr_menu_draw_tl(_pfr, 0, 8, 7);
else scr_menu_draw_window(8, 7, 52, 52, "dim");
var _por = scr_ch1_portrait(_portrait_who, "neutral");
if (scr_sprite_is_valid(_por)) draw_sprite(_por, 0, 10, 9);
scr_menu_text(66, 10, shop.name, MENU_COL_Y);
scr_menu_text(66, 21, shop.keeper, MENU_COL_G);
if (is_array(_lines)) {
    if (array_length(_lines) > 0) scr_menu_text(66, 35, _lines[0], MENU_COL_W);
    if (array_length(_lines) > 1) scr_menu_text(66, 46, _lines[1], MENU_COL_W);
}

// Gold
scr_menu_draw_window(MENU_SHOP_GOLD_X, MENU_SHOP_GOLD_Y, MENU_SHOP_GOLD_W, MENU_SHOP_GOLD_H, "normal");
scr_menu_draw_icon("spr_ui_icon_coin", 243, 10);
scr_menu_text_right(308, 9, string(global.game.gold), MENU_COL_W);

// Owned / Equipped
var _sel_id = "";
if (tab == 0 && index >= 0 && index < array_length(_buy_ids)) _sel_id = _buy_ids[index];
if (tab == 1 && index >= 0 && index < array_length(_sell_list)) _sel_id = _sell_list[index].item_id;
scr_menu_draw_window(MENU_SHOP_OWNED_X, MENU_SHOP_OWNED_Y, MENU_SHOP_OWNED_W, MENU_SHOP_OWNED_H, "normal");
scr_menu_text(243, 31, "Owned", MENU_COL_G);
scr_menu_text_right(309, 31, (_sel_id != "") ? string(scr_inventory_count(_sel_id)) : "0", MENU_COL_W);
if (_sel_id != "" && scr_item_is_equipment(_sel_id)) {
    scr_menu_text(243, 44, "Equipped", MENU_COL_G);
    scr_menu_text_right(309, 44, string(scr_menu_equipped_count(_sel_id)), MENU_COL_W);
}

// List window, then tabs on top of its border.
scr_menu_draw_window(MENU_SHOP_LIST_X, MENU_SHOP_LIST_Y, MENU_SHOP_LIST_W, MENU_SHOP_LIST_H, "normal");
scr_menu_draw_tabs(["buy", "sell", "exit"], tab, MENU_SHOP_TAB0_X, MENU_SHOP_TAB_Y, MENU_SHOP_TAB_DX);

var _ids_n = (tab == 1) ? array_length(_sell_list) : ((tab == 0) ? array_length(_buy_ids) : 0);
if (tab < 2 && _ids_n > 0) {
    var _shown = 0;
    for (var _i = scroll; _i < _ids_n && _shown < MENU_SHOP_LIST_ROWS; _i++) {
        var _item_id = (tab == 1) ? _sell_list[_i].item_id : _buy_ids[_i];
        var _it = scr_item_get(_item_id);
        var _row_y = scr_menu_shop_row_y(_shown);
        var _here = (_i == index);
        var _disabled = false;
        if (tab == 0) _disabled = (scr_item_buy_price(_item_id) > global.game.gold);
        if (tab == 1) _disabled = _sell_list[_i].unsellable;
        if (_here) {
            scr_menu_draw_row_select(22, _row_y, 172, _disabled);
            scr_menu_draw_cursor_tip(21, _row_y + 8);
        }
        scr_menu_draw_item_icon(_item_id, 26, _row_y, _disabled);
        var _col = _disabled ? MENU_COL_A : (_here ? MENU_COL_Y : MENU_COL_W);
        scr_menu_text(46, _row_y + 4, _it.name, _col);
        if (tab == 1 && _disabled) {
            scr_menu_text_right(180, _row_y + 4, "--", MENU_COL_A);
            scr_menu_draw_icon("spr_ui_icon_key", 184, _row_y + 4);
        } else {
            var _price = (tab == 0) ? scr_item_buy_price(_item_id) : scr_item_sell_price(_item_id);
            scr_menu_text_right(180, _row_y + 4, string(_price), _col);
            scr_menu_draw_icon("spr_ui_icon_coin", 184, _row_y + 4);
        }
        _shown += 1;
    }
    if (scroll > 0) scr_menu_draw_arrow(0, 180, 73, true);
    if (scroll + MENU_SHOP_LIST_ROWS < _ids_n) scr_menu_draw_arrow(1, 180, 173, true);
}

// Info / compare
scr_menu_draw_window(MENU_SHOP_INFO_X, MENU_SHOP_INFO_Y, MENU_SHOP_INFO_W, MENU_SHOP_INFO_H, "normal");
if (_sel_id != "") {
    var _detail = scr_item_get(_sel_id);
    if (scr_item_is_equipment(_sel_id)) {
        scr_menu_text_right(256, 70, "ATK", MENU_COL_G);
        scr_menu_text_right(302, 70, "DEF", MENU_COL_G);
        var _who = [];
        var _lists = [global.game.party, global.game.reserve];
        for (var _l = 0; _l < 2; _l++) {
            if (!is_array(_lists[_l])) continue;
            for (var _m = 0; _m < array_length(_lists[_l]) && array_length(_who) < 4; _m++) {
                if (is_struct(_lists[_l][_m])) array_push(_who, _lists[_l][_m]);
            }
        }
        for (var _wi = 0; _wi < array_length(_who); _wi++) {
            var _y = 84 + 16 * _wi;
            var _a = _who[_wi];
            scr_menu_draw_party_icon(_a.actor_id, 210, _y);
            if (!scr_item_can_equip(_a, _sel_id)) {
                scr_menu_text(232, _y + 2, "Can't use", MENU_COL_A);
            } else {
                scr_actor_ensure_bases(_a);
                var _b = scr_item_equip_bonuses(_sel_id);
                var _slots = ["weapon", "armor", "helm", "accessory"];
                var _it = _detail;
                var _atk0 = _a.base_attack;
                var _def0 = _a.base_defense;
                var _atk_other = 0;
                var _def_other = 0;
                for (var _s = 0; _s < 4; _s++) {
                    if (_slots[_s] == _it.slot) continue;
                    var _ob = scr_item_equip_bonuses(scr_actor_equipped_in_slot(_a, _slots[_s]));
                    _atk_other += _ob.atk;
                    _def_other += _ob.def;
                }
                var _atk_new = _atk0 + _atk_other + _b.atk;
                var _def_new = _def0 + _def_other + _b.def;
                var _atk_dir = (_atk_new > _a.attack) ? 0 : ((_atk_new < _a.attack) ? 1 : 2);
                var _def_dir = (_def_new > _a.defense) ? 0 : ((_def_new < _a.defense) ? 1 : 2);
                scr_menu_text_right(256, _y + 2, string(_atk_new), MENU_COL_W);
                scr_menu_draw_stat_arrow(_atk_dir, 258, _y + 3);
                scr_menu_text_right(296, _y + 2, string(_def_new), MENU_COL_W);
                scr_menu_draw_stat_arrow(_def_dir, 298, _y + 3);
            }
        }
        scr_menu_text_wrap(210, 140, _detail.desc, 100, 11, MENU_COL_DESC);
    } else {
        scr_menu_text_wrap(210, 70, _detail.desc, 100, 11, MENU_COL_DESC);
    }
}

// Quantity selector (Buy, consumables only)
if (mode == "qty" && tab == 0 && _sel_id != "") {
    var _unit = scr_item_buy_price(_sel_id);
    var _total = _unit * qty;
    var _owned = scr_inventory_count(_sel_id);
    var _afford = (_unit > 0) ? (global.game.gold div _unit) : 1;
    var _max_qty = max(1, min(99 - _owned, _afford));
    scr_menu_draw_window(MENU_SHOP_QTY_X, MENU_SHOP_QTY_Y, MENU_SHOP_QTY_W, MENU_SHOP_QTY_H, "gold");
    scr_menu_draw_arrow(0, 111, 110, true);
    var _qf = scr_sprite_index("spr_ui_qty_field");
    if (scr_sprite_is_valid(_qf)) scr_menu_draw_tl(_qf, 0, 101, 118);
    else scr_menu_draw_window(101, 118, 28, 14, "dim");
    var _qstr = "x" + ((qty < 10) ? ("0" + string(qty)) : string(qty));
    scr_menu_text_center(115, 121, _qstr, MENU_COL_W);
    scr_menu_draw_arrow(1, 111, 134, true);
    scr_menu_text(138, 112, "Total", MENU_COL_G);
    scr_menu_text_right(178, 124, string(_total), MENU_COL_Y);
    scr_menu_draw_icon("spr_ui_icon_coin", 181, 125);
    scr_menu_text(138, 140, "Max", MENU_COL_G);
    scr_menu_text_right(178, 140, string(_max_qty), MENU_COL_W);
}
