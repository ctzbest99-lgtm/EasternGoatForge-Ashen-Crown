/// obj_battle_controller : Draw GUI
/// FF1-style 320×180 battle: background, enemies on the left half (face right) with mini HP bars,
/// party on the right (xscale -1), nine-slice windows, cursor, HP / MP, status icons, floating damage.
/// Bottom row while choosing: enemy list | commands (or skills) | party status.
scr_ui_set_font();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _gold_col = make_color_rgb(217, 184, 96);
var _grey_col = make_color_rgb(154, 146, 132);
var _mp_col = make_color_rgb(122, 150, 192);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Background
if (scr_sprite_is_valid(battle_bg)) {
    draw_sprite_stretched(battle_bg, 0, 0, 0, _gw, _gh);
} else {
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
}

// Enemies, back row first (lower feet y = further back).
var _order = [];
var _i;
for (_i = 0; _i < array_length(enemies); _i++) array_push(_order, { index: _i, key: -enemies[_i].feet.y });
_order = scr_battle_sort_turns(_order);
for (var _o = 0; _o < array_length(_order); _o++) {
    var _ei = _order[_o].index;
    var _en = enemies[_ei];
    var _f = _en.feet;
    var _alpha = ((_en.hp > 0 && !_en.withdrawn) || _en.yielded || _en.is_boss) ? 1 : _en.fade;
    if (_en.hp > 0 && scr_battle_status_has(_en, "veiled")) _alpha = 0.4; // shade_stalker Fade
    if (!scr_battle_draw_vis(enemy_vis[_ei], _f.x, _f.y, _alpha) && _alpha > 0) {
        draw_set_alpha(_alpha);
        draw_set_color((_en.hp > 0 || _en.yielded) ? c_maroon : c_dkgray);
        draw_rectangle(_f.x - 16, _f.y - 48, _f.x + 16, _f.y, false);
        draw_set_alpha(1);
    }
}

// Party battlers (right), facing left (vis.xscale = -1).
for (_i = 0; _i < array_length(party); _i++) {
    var _member = party[_i];
    var _pf = scr_battle_layout_party_feet(_i);
    var _vis = (_i < array_length(party_vis)) ? party_vis[_i] : undefined;
    if (!scr_battle_draw_vis(_vis, _pf.x, _pf.y)) {
        if (_member.hp <= 0) draw_set_color(c_dkgray);
        else if (state == BATTLE_STATE.COMMAND_SELECT && _i == actor_index) draw_set_color(c_yellow);
        else draw_set_color(c_teal);
        draw_rectangle(_pf.x - 8, _pf.y - 24, _pf.x + 8, _pf.y, false);
    }
}

scr_battle_fx_draw(battle_fx);
scr_battle_pops_draw(dmg_pops);

// Mini HP bars (and buff icons) above each living enemy.
for (_i = 0; _i < array_length(enemies); _i++) {
    if (!is_up("enemy", _i)) continue;
    var _me = enemies[_i];
    var _mv = enemy_vis[_i];
    var _top = 48;
    if (is_struct(_mv) && scr_sprite_is_valid(_mv.sprite)) _top = sprite_get_yoffset(_mv.sprite);
    var _bw = _me.is_boss ? 40 : 24;
    var _bx = _me.feet.x - _bw div 2;
    var _by = max(2, _me.feet.y - _top - 6);
    var _pct = (_me.max_hp > 0) ? clamp(_me.hp / _me.max_hp, 0, 1) : 0;
    draw_set_color(c_black);
    draw_rectangle(_bx - 1, _by - 1, _bx + _bw, _by + 3, false);
    var _fill = make_color_rgb(80, 180, 80);
    if (_pct < 0.25) _fill = make_color_rgb(200, 40, 40);
    else if (_pct < 0.5) _fill = make_color_rgb(200, 160, 40);
    var _fw = floor(_bw * _pct);
    if (_fw > 0) {
        draw_set_color(_fill);
        draw_rectangle(_bx, _by, _bx + _fw - 1, _by + 2, false);
    }
    var _ix = _bx + _bw + 7;
    if (scr_battle_has_buff_sign(_me, "atk", 1)) { scr_ui_status_icon(_ix, _by + 1, 6); _ix += 10; }
    if (scr_battle_has_buff_sign(_me, "def", 1) || _me.is_guarding) { scr_ui_status_icon(_ix, _by + 1, 11); _ix += 10; }
    if (scr_battle_has_buff_sign(_me, "def", -1)) { scr_ui_status_icon(_ix, _by + 1, 5); _ix += 10; }
}

// Boss name plate (top-left), as in Chapter 1.
if (boss_index == 0 && array_length(enemies) > 0) {
    var _boss = enemies[0];
    scr_ui_window(8, 6, 120, 22, "gold");
    var _bn = _boss.full_name;
    if (_boss.actor_id == "blackguard" && _boss.phase > 1) _bn += "  P" + string(_boss.phase);
    scr_ui_text(14, 11, _bn, c_white);
}

// Target cursor.
if (state == BATTLE_STATE.TARGET_SELECT && is_up(target_side, target_index)) {
    var _cspr = scr_sprite_index("spr_ui_cursor_strip2");
    var _cframe = scr_sprite_is_valid(_cspr) ? (floor(current_time * 0.004) mod max(1, sprite_get_number(_cspr))) : 0;
    if (target_side == "enemy") {
        // Point left at the enemy from its right side (mirrored cursor).
        var _tf = enemies[target_index].feet;
        var _cx = _tf.x + (enemies[target_index].is_boss ? 26 : 18);
        var _cy = _tf.y - 24;
        if (scr_sprite_is_valid(_cspr)) {
            draw_sprite_ext(_cspr, _cframe, _cx, _cy, -1, 1, 0, c_white, 1);
        } else {
            draw_set_color(_gold_col);
            draw_triangle(_cx + 6, _cy - 4, _cx + 6, _cy + 4, _cx, _cy, false);
        }
    } else {
        var _tp = scr_battle_layout_party_feet(target_index);
        scr_ui_cursor(_tp.x - 10, _tp.y - 14);
    }
}

// Bottom windows.
var _menu_y = 128;
var _choosing = (state == BATTLE_STATE.COMMAND_SELECT || state == BATTLE_STATE.SKILL_SELECT || state == BATTLE_STATE.TARGET_SELECT) && actor_index != -1;
if (_choosing) {
    // Enemy list (living enemies, highlighted while targeting).
    scr_ui_window(4, _menu_y, 86, 48, (boss_index == 0) ? "gold" : "normal");
    var _row = 0;
    for (_i = 0; _i < array_length(enemies) && _row < 4; _i++) {
        if (!is_up("enemy", _i)) continue;
        var _ecol = c_white;
        if (state == BATTLE_STATE.TARGET_SELECT && target_side == "enemy" && target_index == _i) _ecol = _gold_col;
        else if (enemies[_i].is_boss) _ecol = _gold_col;
        var _enm = enemies[_i].short_name;
        if (string_length(_enm) > 12) _enm = string_copy(_enm, 1, 12);
        scr_ui_text(10, _menu_y + 5 + _row * 10, _enm, _ecol);
        _row += 1;
    }

    if (state == BATTLE_STATE.SKILL_SELECT) {
        // Skill window over the command + party area; help line at the top.
        scr_ui_window(92, _menu_y, 224, 48, "normal");
        var _cur_actor = party[actor_index];
        for (var _s = 0; _s < array_length(skill_list) && _s < 4; _s++) {
            var _skd = scr_skill_get(skill_list[_s]);
            var _sy = _menu_y + 5 + _s * 10;
            var _ok = scr_skill_can_afford(_cur_actor, skill_list[_s]);
            var _scol = _ok ? c_white : _grey_col;
            if (_s == skill_index) {
                if (_ok) _scol = _gold_col;
                scr_ui_cursor(104, _sy + 5);
            }
            scr_ui_text(110, _sy, _skd.name, _scol);
            var _cost = string(_skd.mp_cost) + " MP";
            scr_ui_text(300 - string_width(_cost), _sy, _cost, _ok ? _mp_col : _grey_col);
        }
        scr_ui_text(250, _menu_y - 12, "MP " + string(_cur_actor.mp) + "/" + string(_cur_actor.max_mp), _mp_col);
        if (skill_index < array_length(skill_list)) {
            var _help = scr_skill_get(skill_list[skill_index]).desc;
            if (_help != "") {
                scr_ui_window(60, 3, 200, 20, "normal");
                scr_ui_text(68, 8, _help, c_white);
            }
        }
    } else {
        // Commands.
        scr_ui_window(92, _menu_y, 70, 48, "normal");
        var _opts = command_options;
        for (var _c = 0; _c < array_length(_opts); _c++) {
            var _oy = _menu_y + 5 + _c * 10;
            var _col = (_c == command_index) ? _gold_col : c_white;
            if (state == BATTLE_STATE.TARGET_SELECT) _col = (_opts[_c] == pending_command) ? _gold_col : _grey_col;
            if (_c == command_index && state == BATTLE_STATE.COMMAND_SELECT) {
                var _bar = scr_sprite_index("spr_ui_select_bar");
                if (scr_sprite_is_valid(_bar)) draw_sprite_stretched(_bar, 0, 100, _oy - 1, 58, 11);
                scr_ui_cursor(102, _oy + 5);
            }
            scr_ui_text(106, _oy, _opts[_c], _col);
        }

        // Party status: name, HP bar, HP, MP, one status icon.
        scr_ui_window(164, _menu_y, 152, 48, "normal");
        for (_i = 0; _i < array_length(party); _i++) {
            var _hud = party[_i];
            var _hy = _menu_y + 5 + _i * 10;
            var _hcol = c_white;
            if (_hud.hp <= 0) _hcol = c_gray;
            else if (_i == actor_index) _hcol = _gold_col;
            if (state == BATTLE_STATE.TARGET_SELECT && target_side == "party" && target_index == _i) _hcol = _gold_col;
            var _nm = _hud.name;
            if (string_length(_nm) > 6) _nm = string_copy(_nm, 1, 6);
            scr_ui_text(170, _hy, _nm, _hcol);
            scr_ui_hp_bar(207, _hy + 2, _hud.hp, _hud.max_hp, 48);
            // scr_ui_text forces fa_left, so right-align by measuring.
            var _hps = string(_hud.hp);
            scr_ui_text(276 - string_width(_hps), _hy, _hps, _hcol);
            var _hmp = variable_struct_exists(_hud, "max_mp") ? _hud.max_mp : 0;
            if (_hmp > 0) {
                var _mps = string(_hud.mp);
                scr_ui_text(300 - string_width(_mps), _hy, _mps, _mp_col);
            }
            var _icon = -1;
            if (_hud.is_guarding) _icon = 11;
            else if (scr_battle_has_buff_sign(_hud, "atk", 1)) _icon = 6;
            else if (scr_battle_has_buff_sign(_hud, "atk", -1)) _icon = 7;
            else if (scr_battle_has_buff_sign(_hud, "def", -1)) _icon = 5;
            else if (scr_battle_has_buff_sign(_hud, "spd", 1)) _icon = 8;
            else if (scr_battle_has_buff_sign(_hud, "spd", -1)) _icon = 9;
            var _tags = scr_battle_status_tags(_hud);
            if (_tags != "") scr_ui_text(303, _hy, string_copy(_tags, 1, 2), make_color_rgb(186, 140, 220)); // blind / sleep (no icon frames yet)
            else if (_icon != -1) scr_ui_status_icon(309, _hy + 5, _icon);
        }
    }
} else if (state == BATTLE_STATE.MESSAGE || state == BATTLE_STATE.ANIMATING || state == BATTLE_STATE.PHASE_SHIFT || state == BATTLE_STATE.STANCE_SHIFT) {
    var _wkind = (boss_index == 0) ? "gold" : "normal";
    scr_ui_window(4, _menu_y, 312, 48, _wkind);
    var _msg = (state == BATTLE_STATE.MESSAGE) ? message : "";
    if (state == BATTLE_STATE.PHASE_SHIFT && phase_enemy >= 0 && phase_enemy < array_length(enemies) && enemies[phase_enemy].actor_id == "blackguard") _msg = "The air thickens with Ash...";
    if (_msg != "") scr_ui_text_ext(12, _menu_y + 8, _msg, 280, c_white);
    var _hint = (state == BATTLE_STATE.MESSAGE) ? "[Z]" : "[Z skip]";
    scr_ui_text(308 - string_width(_hint), _gh - 14, _hint, (state == BATTLE_STATE.MESSAGE) ? _gold_col : _grey_col);
} else {
    // Fallback strip (victory / intro / turn hand-off frames).
    scr_ui_window(4, _menu_y, 312, 48, "normal");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
