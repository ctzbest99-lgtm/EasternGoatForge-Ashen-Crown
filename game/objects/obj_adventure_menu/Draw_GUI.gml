/// obj_adventure_menu : Draw GUI
scr_ui_set_font();
scr_menu_draw_dither();

var _party = scr_menu_inv_party();
var _pane_right = MENU_ADV_PANE_X + MENU_ADV_PANE_W - 8;

// ---------------------------------------------------------------------------------------------
// Menu list + party at a glance
if (mode == "list") {
    scr_menu_draw_window(MENU_ADV_MAIN_X, MENU_ADV_MAIN_Y, MENU_ADV_MAIN_W, MENU_ADV_MAIN_H, "normal");
    scr_menu_text(MENU_ADV_MAIN_X + 8, MENU_ADV_MAIN_Y + 8, "ADVENTURE", MENU_COL_Y);
    for (var _i = 0; _i < array_length(entries); _i++) {
        var _my = MENU_ADV_ROW0 + _i * MENU_ADV_ROW_H;
        var _msel = (_i == index);
        if (_msel) {
            scr_menu_draw_row_select(MENU_ADV_MAIN_X + 6, _my, MENU_ADV_MAIN_W - 12, false);
            scr_menu_draw_cursor_tip(MENU_ADV_MAIN_X + 7, _my + 8);
        }
        scr_menu_text(MENU_ADV_MAIN_X + 18, _my + 4, entries[_i], _msel ? MENU_COL_Y : MENU_COL_W);
    }

    scr_menu_draw_window(MENU_ADV_PANE_X, MENU_ADV_PANE_Y, MENU_ADV_PANE_W, MENU_ADV_PANE_H, "normal");
    scr_menu_text(MENU_ADV_PANE_X + 8, MENU_ADV_PANE_Y + 8, "Party", MENU_COL_Y);
    for (var _p = 0; _p < array_length(_party) && _p < 4; _p++) {
        var _pa = _party[_p];
        var _py = MENU_ADV_PANE_Y + 26 + 30 * _p;
        scr_menu_draw_party_icon(_pa.actor_id, MENU_ADV_PANE_X + 8, _py);
        scr_menu_text(MENU_ADV_PANE_X + 24, _py + 1, _pa.name, MENU_COL_W);
        scr_menu_text_right(_pane_right, _py + 1, "Lv " + string(_pa.level), MENU_COL_G);
        scr_ui_hp_bar(MENU_ADV_PANE_X + 24, _py + 15, _pa.hp, _pa.max_hp, 70);
        scr_menu_text_right(_pane_right, _py + 13, string(_pa.hp) + "/" + string(_pa.max_hp), MENU_COL_W);
    }
    scr_menu_text(MENU_ADV_PANE_X + 8, MENU_ADV_PANE_Y + 152, "Z select", MENU_COL_G);
    scr_menu_text_right(_pane_right, MENU_ADV_PANE_Y + 152, string(global.game.gold) + " g", MENU_COL_G);
    exit;
}

// ---------------------------------------------------------------------------------------------
// Status
if (mode == "status") {
    scr_menu_draw_window(MENU_ADV_FULL_X, MENU_ADV_FULL_Y, MENU_ADV_FULL_W, MENU_ADV_FULL_H, "normal");
    scr_menu_text(MENU_ADV_FULL_X + 8, 10, "STATUS", MENU_COL_Y);
    var _sn = array_length(_party);
    if (_sn == 0) {
        scr_menu_text(MENU_ADV_FULL_X + 8, 34, "(no one has joined yet)", MENU_COL_G);
        exit;
    }
    if (member_index >= _sn) member_index = 0;
    scr_menu_text_right(MENU_ADV_FULL_X + MENU_ADV_FULL_W - 8, 10, string(member_index + 1) + " / " + string(_sn) + "   < >", MENU_COL_G);
    var _sa = _party[member_index];

    var _frame = scr_sprite_index("spr_ui_party_frame_strip2");
    if (scr_sprite_is_valid(_frame)) scr_menu_draw_tl(_frame, 1, 12, 30);
    scr_menu_draw_party_icon(_sa.actor_id, 13, 31);

    var _full = (variable_struct_exists(_sa, "full_name") && _sa.full_name != "") ? _sa.full_name : _sa.name;
    scr_menu_text(40, 30, _full, MENU_COL_Y);
    scr_menu_text(40, 44, variable_struct_exists(_sa, "class_name") ? _sa.class_name : "", MENU_COL_W);
    scr_menu_text(40, 56, variable_struct_exists(_sa, "role") ? _sa.role : "", MENU_COL_G);

    scr_menu_text(12, 82, "Lv " + string(_sa.level), MENU_COL_W);
    var _next_xp = (_sa.level < PARTY_MAX_LEVEL) ? scr_xp_for_level(_sa.level + 1) : -1;
    scr_menu_text(12, 94, (_next_xp > 0) ? ("XP " + string(_sa.xp) + " / " + string(_next_xp)) : "XP MAX", MENU_COL_G);

    scr_menu_text(12, 110, "HP", MENU_COL_Y);
    scr_ui_hp_bar(34, 112, _sa.hp, _sa.max_hp, 56);
    scr_menu_text_right(152, 109, string(_sa.hp) + "/" + string(_sa.max_hp), MENU_COL_W);
    var _smp = variable_struct_exists(_sa, "mp") ? _sa.mp : 0;
    var _smaxmp = variable_struct_exists(_sa, "max_mp") ? _sa.max_mp : 0;
    scr_menu_text(12, 126, "MP", MENU_COL_Y);
    scr_menu_text(34, 126, string(_smp) + " / " + string(_smaxmp), MENU_COL_W);

    // Right column: combat stats, then equipment.
    var _col_x = 168;
    var _col_val = 240;
    var _stat_names = ["ATK", "DEF", "MAG", "MDF", "SPD"];
    var _stat_vals = [
        _sa.attack,
        _sa.defense,
        variable_struct_exists(_sa, "magic") ? _sa.magic : 0,
        variable_struct_exists(_sa, "mdef") ? _sa.mdef : 0,
        variable_struct_exists(_sa, "spd") ? _sa.spd : 0
    ];
    for (var _st = 0; _st < 5; _st++) {
        var _sty = 30 + 14 * _st;
        scr_menu_text(_col_x, _sty, _stat_names[_st], MENU_COL_G);
        scr_menu_text_right(_col_val, _sty, string(_stat_vals[_st]), MENU_COL_W);
    }

    var _eq_slots = ["weapon", "armor", "helm", "accessory"];
    var _eq_labels = ["WPN", "ARM", "HLM", "ACC"];
    for (var _eqi = 0; _eqi < 4; _eqi++) {
        var _eqy = 104 + 14 * _eqi;
        var _eqid = scr_actor_equipped_in_slot(_sa, _eq_slots[_eqi]);
        scr_menu_text(_col_x, _eqy, _eq_labels[_eqi], MENU_COL_G);
        scr_menu_text_right(MENU_ADV_FULL_X + MENU_ADV_FULL_W - 8, _eqy, (_eqid != "") ? scr_item_get(_eqid).name : "-", (_eqid != "") ? MENU_COL_W : MENU_COL_A);
    }

    // Skills across the bottom.
    var _skills = variable_struct_exists(_sa, "skills") && is_array(_sa.skills) ? _sa.skills : [];
    var _skill_line = "Skills: ";
    if (array_length(_skills) == 0) {
        _skill_line += "(none)";
    } else {
        for (var _sk = 0; _sk < array_length(_skills); _sk++) {
            var _sk_def = scr_skill_get(_skills[_sk]);
            if (_sk > 0) _skill_line += ", ";
            _skill_line += is_struct(_sk_def) ? _sk_def.name : string(_skills[_sk]);
        }
    }
    scr_menu_text_wrap(12, 148, _skill_line, 292, 11, MENU_COL_DESC);
    exit;
}

// ---------------------------------------------------------------------------------------------
// Party Order
if (mode == "party") {
    scr_menu_draw_window(MENU_ADV_FULL_X, MENU_ADV_FULL_Y, MENU_ADV_FULL_W, MENU_ADV_FULL_H, "normal");
    scr_menu_text(MENU_ADV_FULL_X + 8, 10, "PARTY ORDER", MENU_COL_Y);
    scr_menu_text_right(MENU_ADV_FULL_X + MENU_ADV_FULL_W - 8, 10, "Z swap reserve   < > move", MENU_COL_G);

    var _act = global.game.party;
    var _res = global.game.reserve;
    var _act_n = is_array(_act) ? array_length(_act) : 0;
    var _res_n = is_array(_res) ? array_length(_res) : 0;

    for (var _ai = 0; _ai < _act_n; _ai++) {
        var _ay = 30 + _ai * 20;
        var _asel = (_ai == party_index);
        var _aa = _act[_ai];
        if (_asel) {
            scr_menu_draw_row_select(8, _ay, 196, false);
            scr_menu_draw_cursor_tip(9, _ay + 8);
        }
        scr_menu_text(20, _ay + 3, string(_ai + 1) + ".", MENU_COL_G);
        scr_menu_draw_party_icon(_aa.actor_id, 34, _ay + 2);
        scr_menu_text(50, _ay + 3, _aa.name, _asel ? MENU_COL_Y : MENU_COL_W);
        scr_menu_text(96, _ay + 3, variable_struct_exists(_aa, "class_name") ? _aa.class_name : "", MENU_COL_G);
        scr_menu_text_right(200, _ay + 3, "Lv " + string(_aa.level), MENU_COL_G);
    }

    var _ry = 30 + _act_n * 20 + 6;
    scr_menu_text(12, _ry, "RESERVE", MENU_COL_G);
    if (_res_n == 0) {
        scr_menu_text(20, _ry + 14, "(empty)", MENU_COL_A);
    } else {
        for (var _ri = 0; _ri < _res_n; _ri++) {
            var _rry = _ry + 14 + _ri * 20;
            var _rsel = (_act_n + _ri == party_index);
            var _ra = _res[_ri];
            if (_rsel) {
                scr_menu_draw_row_select(8, _rry, 196, false);
                scr_menu_draw_cursor_tip(9, _rry + 8);
            }
            scr_menu_draw_party_icon(_ra.actor_id, 34, _rry + 2);
            scr_menu_text(50, _rry + 3, _ra.name, _rsel ? MENU_COL_Y : MENU_COL_W);
            scr_menu_text(96, _rry + 3, variable_struct_exists(_ra, "class_name") ? _ra.class_name : "", MENU_COL_G);
            scr_menu_text_right(200, _rry + 3, "Lv " + string(_ra.level), MENU_COL_G);
        }
    }

    // Right pane: the highlighted member at a glance.
    var _pick = undefined;
    if (party_index < _act_n) _pick = _act[party_index];
    else if (_res_n > 0) _pick = _res[0];
    scr_menu_draw_window(208, 26, 104, 118, "dim");
    if (is_struct(_pick)) {
        scr_menu_text(214, 32, _pick.name, MENU_COL_Y);
        scr_menu_text(214, 46, "HP " + string(_pick.hp) + "/" + string(_pick.max_hp), MENU_COL_W);
        scr_menu_text(214, 58, "ATK " + string(_pick.attack), MENU_COL_W);
        scr_menu_text(214, 70, "DEF " + string(_pick.defense), MENU_COL_W);
        scr_menu_text(214, 82, "SPD " + string(variable_struct_exists(_pick, "spd") ? _pick.spd : 0), MENU_COL_W);
        scr_menu_text(214, 94, (party_index < _act_n) ? "Front line" : "Reserve", MENU_COL_G);
        scr_menu_text(214, 106, "slot " + string((party_index < _act_n) ? party_index + 1 : 0), MENU_COL_G);
    }
    if (message != "") scr_menu_text(12, 160, message, MENU_COL_Y);
    exit;
}

// ---------------------------------------------------------------------------------------------
// Bestiary
// ---------------------------------------------------------------------------------------------
// Quests
if (mode == "quests") {
    scr_menu_draw_window(MENU_ADV_FULL_X, MENU_ADV_FULL_Y, MENU_ADV_FULL_W, MENU_ADV_FULL_H, "normal");
    scr_menu_text(MENU_ADV_FULL_X + 8, 10, "QUESTS", MENU_COL_Y);
    var _qn = array_length(quests);
    scr_menu_text_right(MENU_ADV_FULL_X + MENU_ADV_FULL_W - 8, 10, string(scr_quest_open_count()) + " open", MENU_COL_G);
    if (_qn == 0) {
        scr_menu_text(12, 34, "(no quests yet)", MENU_COL_A);
        scr_menu_text_wrap(12, 50, "Talk to people: side quests and the main quest appear here once they start.", 292, 11, MENU_COL_DESC);
        exit;
    }
    if (quest_index >= _qn) quest_index = 0;

    for (var _qi = quest_scroll; _qi < _qn && _qi < quest_scroll + MENU_ADV_ROWS; _qi++) {
        var _qy = 30 + (_qi - quest_scroll) * MENU_ADV_ROW_H_FULL;
        var _qsel = (_qi == quest_index);
        var _q = quests[_qi];
        if (_qsel) {
            scr_menu_draw_row_select(8, _qy, MENU_ADV_LIST_W - 4, false);
            scr_menu_draw_cursor_tip(9, _qy + 8);
        }
        scr_menu_text(20, _qy + 2, _q.title, _qsel ? MENU_COL_Y : (_q.complete ? MENU_COL_G : MENU_COL_W));
        if (_q.complete) scr_menu_text_right(MENU_ADV_LIST_W + 2, _qy + 2, "done", MENU_COL_G);
    }
    if (quest_scroll > 0) scr_menu_draw_arrow(0, MENU_ADV_LIST_W - 6, 18, true);
    if (quest_scroll + MENU_ADV_ROWS < _qn) scr_menu_draw_arrow(1, MENU_ADV_LIST_W - 6, 158, true);

    var _qj = quests[quest_index];
    var _qx = MENU_ADV_LIST_W + 12;
    scr_menu_text(_qx, 30, _qj.title, MENU_COL_Y);
    scr_menu_text(_qx, 44, _qj.kind, MENU_COL_G);
    scr_menu_text_wrap(_qx, 60, _qj.text, 148, 11, MENU_COL_DESC);
    scr_menu_text(_qx, 126, "Stage", MENU_COL_G);
    scr_menu_text_right(MENU_ADV_FULL_X + MENU_ADV_FULL_W - 8, 126,
        _qj.complete ? "complete" : (string(_qj.stage) + " / " + string(_qj.total)), MENU_COL_W);
    exit;
}

// ---------------------------------------------------------------------------------------------
// Bestiary
if (mode == "bestiary") {
    scr_menu_draw_window(MENU_ADV_FULL_X, MENU_ADV_FULL_Y, MENU_ADV_FULL_W, MENU_ADV_FULL_H, "normal");
    scr_menu_text(MENU_ADV_FULL_X + 8, 10, "BESTIARY", MENU_COL_Y);
    var _ids = scr_bestiary_ids();
    var _bn = array_length(_ids);
    scr_menu_text_right(MENU_ADV_FULL_X + MENU_ADV_FULL_W - 8, 10, string(scr_bestiary_seen_total()) + " / " + string(_bn) + " seen", MENU_COL_G);
    if (_bn == 0) exit;
    if (bestiary_index >= _bn) bestiary_index = 0;

    for (var _bi = bestiary_scroll; _bi < _bn && _bi < bestiary_scroll + MENU_ADV_ROWS; _bi++) {
        var _by = 30 + (_bi - bestiary_scroll) * MENU_ADV_ROW_H_FULL;
        var _bsel = (_bi == bestiary_index);
        var _be = scr_bestiary_entry(_ids[_bi]);
        if (_bsel) {
            scr_menu_draw_row_select(8, _by, MENU_ADV_LIST_W - 4, !_be.seen);
            scr_menu_draw_cursor_tip(9, _by + 8);
        }
        scr_menu_text(20, _by + 2, _be.seen ? _be.name : "???", _bsel ? MENU_COL_Y : (_be.seen ? MENU_COL_W : MENU_COL_A));
        if (_be.seen && _be.defeated > 0) scr_menu_text_right(MENU_ADV_LIST_W + 2, _by + 2, "x" + string(_be.defeated), MENU_COL_DESC);
    }
    if (bestiary_scroll > 0) scr_menu_draw_arrow(0, MENU_ADV_LIST_W - 6, 18, true);
    if (bestiary_scroll + MENU_ADV_ROWS < _bn) scr_menu_draw_arrow(1, MENU_ADV_LIST_W - 6, 158, true);

    // Detail pane: text on the left, the monster plate on the bottom right.
    var _de = scr_bestiary_entry(_ids[bestiary_index]);
    var _dx = MENU_ADV_LIST_W + 12;
    var _ix = MENU_ADV_FULL_X + MENU_ADV_FULL_W - 60; // 60x64 monster plate, flush with the pane edge
    var _iy = 112;
    var _iw = 60;
    var _ih = 64;
    if (!_de.seen) {
        scr_menu_text(_dx, 26, "No record yet.", MENU_COL_A);
        scr_menu_text_wrap(_dx, 42, "Meet this enemy in battle and its entry fills in.", 84, 11, MENU_COL_DESC);
        scr_bestiary_draw_illustration(_de.id, false, _ix, _iy, _iw, _ih);
        exit;
    }
    scr_menu_text(_dx, 26, _de.name, MENU_COL_Y);
    scr_menu_text(_dx, 40, "Lv " + string(_de.level) + "   " + _de.role, MENU_COL_G);
    scr_menu_text_wrap(_dx, 52, scr_bestiary_desc_fit(_de.desc), 148, 11, MENU_COL_DESC);

    scr_menu_text(_dx, 88, "Weak", MENU_COL_G);
    scr_menu_text_right(_ix - 4, 88, (_de.weakness != "") ? _de.weakness : "-", MENU_COL_W);
    scr_menu_text(_dx, 100, "Found", MENU_COL_G);
    scr_menu_text_right(_ix - 4, 110, scr_bestiary_area_label(_de.area), MENU_COL_W);

    var _rows = [["HP", _de.hp, "MDF", _de.mdef], ["ATK", _de.attack, "SPD", _de.spd], ["DEF", _de.defense, "Gold", _de.gold]];
    for (var _rr = 0; _rr < 3; _rr++) {
        var _rry2 = 124 + 16 * _rr;
        scr_menu_text(_dx, _rry2, _rows[_rr][0], MENU_COL_G);
        scr_menu_text_right(_dx + 38, _rry2, string(_rows[_rr][1]), MENU_COL_W);
        scr_menu_text(_dx + 46, _rry2, _rows[_rr][2], MENU_COL_G);
        scr_menu_text_right(_ix - 4, _rry2, string(_rows[_rr][3]), MENU_COL_W);
    }
    scr_bestiary_draw_illustration(_de.id, true, _ix, _iy, _iw, _ih);
    exit;
}
