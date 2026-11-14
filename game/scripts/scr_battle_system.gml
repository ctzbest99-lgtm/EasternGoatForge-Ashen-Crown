/// scr_battle_system — multi-enemy battle helpers (feature/battle-upgrade): buffed stats, damage with
/// elemental weakness, buffs / statuses, enemy AI picks, SPD turn-order sort, and enemy formations.
/// Used by obj_battle_controller. Numbers live in scr_game_constants / scr_skill_data / scr_enemy_database.

/// Sum of active buff percentages for one stat ("atk" | "def" | "mdef" | "spd"), clamped to [-0.9, 2].
function scr_battle_buff_total(_actor, _stat) {
    if (!is_struct(_actor) || !variable_struct_exists(_actor, "buffs") || !is_array(_actor.buffs)) return 0;
    var _sum = 0;
    for (var _i = 0; _i < array_length(_actor.buffs); _i++) {
        var _b = _actor.buffs[_i];
        if (is_struct(_b) && _b.stat == _stat) _sum += _b.pct;
    }
    return clamp(_sum, -0.9, 2);
}

/// Current battle value of a stat with buffs (and the Blackguard's speed_mod for SPD).
/// With no buffs this equals the raw stat, so Chapter 1 damage numbers are unchanged.
function scr_battle_stat(_actor, _stat) {
    if (!is_struct(_actor)) return 0;
    var _base = 0;
    switch (_stat) {
        case "atk": _base = _actor.attack; break;
        case "def": _base = _actor.defense; break;
        case "mdef": _base = variable_struct_exists(_actor, "mdef") ? _actor.mdef : 0; break;
        case "spd":
            _base = variable_struct_exists(_actor, "spd") ? _actor.spd : 8;
            if (variable_struct_exists(_actor, "speed_mod")) _base = _base * _actor.speed_mod;
            if (scr_battle_status_has(_actor, "slow")) _base = _base * BATTLE_SLOW_SPD_PCT; // the Debtman's bind
            break;
    }
    // Last Stand (Kael's canon passive, CHAPTER1_SCRIPT.md §2.1 / FL_TUTORIAL_SYS_05):
    // below 25% HP, Attack +15% and Defense +10%.
    if (_stat == "atk" || _stat == "def") {
        if (variable_struct_exists(_actor, "passives") && is_array(_actor.passives)
            && variable_struct_exists(_actor, "hp") && _actor.hp > 0
            && _actor.hp < _actor.max_hp * 0.25) {
            for (var _p = 0; _p < array_length(_actor.passives); _p++) {
                if (_actor.passives[_p] == "last_stand") {
                    _base = _base * ((_stat == "atk") ? BATTLE_LAST_STAND_ATK_PCT : BATTLE_LAST_STAND_DEF_PCT);
                    break;
                }
            }
        }
    }
    var _val = round(_base * (1 + scr_battle_buff_total(_actor, _stat)));
    if (_stat == "atk" || _stat == "spd") return max(1, _val);
    return max(0, _val);
}

/// Add or refresh a buff. Same source + stat refreshes instead of stacking. `_turns` -1 = whole battle.
function scr_battle_add_buff(_actor, _stat, _pct, _turns, _source = "") {
    if (!is_struct(_actor)) return;
    if (!variable_struct_exists(_actor, "buffs") || !is_array(_actor.buffs)) _actor.buffs = [];
    for (var _i = 0; _i < array_length(_actor.buffs); _i++) {
        var _b = _actor.buffs[_i];
        if (is_struct(_b) && _b.stat == _stat && _b.source == _source) {
            _b.pct = _pct;
            _b.turns = _turns;
            return;
        }
    }
    array_push(_actor.buffs, { stat: _stat, pct: _pct, turns: _turns, source: _source });
}

/// Called once per round (ROUND_START). Buffs with turns > 0 count down and drop at 0;
/// so a 3-turn buff lasts the rest of the round it was cast in plus the next two rounds.
function scr_battle_tick_buffs(_actor) {
    if (!is_struct(_actor) || !variable_struct_exists(_actor, "buffs") || !is_array(_actor.buffs)) return;
    for (var _i = array_length(_actor.buffs) - 1; _i >= 0; _i--) {
        var _b = _actor.buffs[_i];
        if (!is_struct(_b)) { array_delete(_actor.buffs, _i, 1); continue; }
        if (_b.turns < 0) continue;
        _b.turns -= 1;
        if (_b.turns <= 0) array_delete(_actor.buffs, _i, 1);
    }
}

function scr_battle_has_buff_sign(_actor, _stat, _sign) {
    var _t = scr_battle_buff_total(_actor, _stat);
    return (_sign > 0) ? (_t > 0) : (_t < 0);
}

/// True when one of the actor's passives (e.g. Unbowed) resists `_status` ("fear", "stun", ...).
function scr_battle_status_resisted(_actor, _status) {
    if (!is_struct(_actor) || !variable_struct_exists(_actor, "passives") || !is_array(_actor.passives)) return false;
    for (var _i = 0; _i < array_length(_actor.passives); _i++) {
        var _sk = scr_skill_get(_actor.passives[_i]);
        if (!is_array(_sk.resists)) continue;
        for (var _j = 0; _j < array_length(_sk.resists); _j++) {
            if (_sk.resists[_j] == _status) return true;
        }
    }
    return false;
}

/// Battle statuses are { id, turns } structs in actor.statuses (battle only, never saved).
/// "blind": physical attacks miss BATTLE_BLIND_MISS_CHANCE of the time. "sleep": the turn is
/// skipped; any damage wakes the sleeper. "veiled" (shade_stalker Fade): physical attacks against
/// it miss. Statuses tick down at round start like buffs. Unbowed resists "fear" / "stun".
function scr_battle_status_has(_actor, _status) {
    if (!is_struct(_actor) || !variable_struct_exists(_actor, "statuses") || !is_array(_actor.statuses)) return false;
    for (var _i = 0; _i < array_length(_actor.statuses); _i++) {
        var _st = _actor.statuses[_i];
        if (is_struct(_st) && _st.id == _status) return true;
        if (is_string(_st) && _st == _status) return true;
    }
    return false;
}

/// Try to inflict a status for `_turns` rounds. Returns false if resisted or already present.
function scr_battle_try_add_status(_actor, _status, _turns = 2) {
    if (!is_struct(_actor)) return false;
    if (scr_battle_status_resisted(_actor, _status)) return false;
    if (!variable_struct_exists(_actor, "statuses") || !is_array(_actor.statuses)) _actor.statuses = [];
    if (scr_battle_status_has(_actor, _status)) return false;
    array_push(_actor.statuses, { id: _status, turns: max(1, _turns) });
    return true;
}

function scr_battle_remove_status(_actor, _status) {
    if (!is_struct(_actor) || !variable_struct_exists(_actor, "statuses") || !is_array(_actor.statuses)) return;
    for (var _i = array_length(_actor.statuses) - 1; _i >= 0; _i--) {
        var _st = _actor.statuses[_i];
        if ((is_struct(_st) && _st.id == _status) || (is_string(_st) && _st == _status)) array_delete(_actor.statuses, _i, 1);
    }
}

function scr_battle_tick_statuses(_actor) {
    if (!is_struct(_actor) || !variable_struct_exists(_actor, "statuses") || !is_array(_actor.statuses)) return;
    for (var _i = array_length(_actor.statuses) - 1; _i >= 0; _i--) {
        var _st = _actor.statuses[_i];
        if (!is_struct(_st)) { array_delete(_actor.statuses, _i, 1); continue; }
        // Bleed (Open Vein) and poison tick at ROUND_START: damage over time that
        // never kills (PLACEHOLDER rule, same as bleed).
        if (_st.id == "bleed" && _actor.hp > 1) {
            var _b = max(1, floor(_actor.max_hp * BATTLE_BLEED_PCT));
            _actor.hp = max(1, _actor.hp - _b);
            _actor.bleed_last = _b;
        }
        if (_st.id == "poison" && _actor.hp > 1) {
            var _p = max(1, floor(_actor.max_hp * BATTLE_POISON_PCT));
            _actor.hp = max(1, _actor.hp - _p);
            _actor.poison_last = _p;
        }
        _st.turns -= 1;
        if (_st.turns <= 0) array_delete(_actor.statuses, _i, 1);
    }
}

/// One actor's damage-over-time report for the round-start message
/// ("X bleeds for 3. Y is sickened for 2."), then clears the tick counters.
function scr_battle_dot_report(_actor) {
    if (!is_struct(_actor)) return "";
    var _t = "";
    if (variable_struct_exists(_actor, "bleed_last") && _actor.bleed_last > 0) {
        _t += _actor.name + " bleeds for " + string(_actor.bleed_last) + ". ";
        _actor.bleed_last = 0;
    }
    if (variable_struct_exists(_actor, "poison_last") && _actor.poison_last > 0) {
        _t += _actor.name + " is sickened for " + string(_actor.poison_last) + ". ";
        _actor.poison_last = 0;
    }
    return _t;
}

/// Critical hit chance for `_actor`: the base rate plus Cutthroat (Lyra's passive).
function scr_battle_crit_chance(_actor) {
    var _c = BATTLE_CRIT_BASE;
    if (is_struct(_actor) && variable_struct_exists(_actor, "passives") && is_array(_actor.passives)) {
        for (var _i = 0; _i < array_length(_actor.passives); _i++) {
            if (_actor.passives[_i] == "cutthroat") _c += BATTLE_CUTTHROAT_CRIT_BONUS;
        }
    }
    return _c;
}

/// Short tags for the HUD ("Bl", "Sl", "Vl", "Bd", "Pn", "Sw").
function scr_battle_status_tags(_actor) {
    var _t = "";
    if (scr_battle_status_has(_actor, "blind")) _t += "Bl";
    if (scr_battle_status_has(_actor, "sleep")) _t += (_t == "" ? "" : " ") + "Sl";
    if (scr_battle_status_has(_actor, "veiled")) _t += (_t == "" ? "" : " ") + "Vl";
    if (scr_battle_status_has(_actor, "bleed")) _t += (_t == "" ? "" : " ") + "Bd";
    if (scr_battle_status_has(_actor, "poison")) _t += (_t == "" ? "" : " ") + "Pn";
    if (scr_battle_status_has(_actor, "slow")) _t += (_t == "" ? "" : " ") + "Sw";
    return _t;
}

/// Damage of `_skill` (a scr_skill_get struct) from `_user` to `_target`, before Guard.
/// Physical uses ATK vs DEF, magic uses ATK vs MDEF; power scales the normal Attack formula.
/// A matching `weakness` multiplies by BATTLE_WEAKNESS_MULTIPLIER. Returns { damage, weak }.
function scr_battle_skill_damage(_user, _target, _skill) {
    var _atk = scr_battle_stat(_user, "atk");
    var _def = (_skill.dmg_type == "mag") ? scr_battle_stat(_target, "mdef") : scr_battle_stat(_target, "def");
    var _dmg = scr_calculate_damage(_atk, _def);
    if (_skill.power != 1) _dmg = max(1, floor(_dmg * _skill.power));
    var _weak = false;
    var _wk = (is_struct(_target) && variable_struct_exists(_target, "weakness")) ? _target.weakness : "";
    if (_skill.element != "none" && _skill.element != "" && _skill.element == _wk) {
        _dmg = max(1, floor(_dmg * BATTLE_WEAKNESS_MULTIPLIER));
        _weak = true;
    }
    return { damage: _dmg, weak: _weak };
}

/// Weighted AI pick for one enemy. `_allies_alive` = other living enemies on its side.
/// Blackguard uses phase_actions[phase - 1]; a boss with actions_alone uses it once its adds are gone.
/// Skills the enemy cannot afford (MP) or whose `cond` fails are skipped. Falls back to "attack".
function scr_battle_ai_pick(_enemy, _allies_alive) {
    if (!is_struct(_enemy)) return "attack";
    var _list = variable_struct_exists(_enemy, "actions") ? _enemy.actions : undefined;
    var _pa = variable_struct_exists(_enemy, "phase_actions") ? _enemy.phase_actions : undefined;
    var _alone = variable_struct_exists(_enemy, "actions_alone") ? _enemy.actions_alone : undefined;
    if (is_array(_pa) && array_length(_pa) > 0) {
        var _ph = variable_struct_exists(_enemy, "phase") ? _enemy.phase : 1;
        _list = _pa[clamp(_ph, 1, array_length(_pa)) - 1];
    } else if (_allies_alive <= 0 && is_array(_alone)) {
        _list = _alone;
    }
    if (!is_array(_list)) return "attack";

    var _ids = [];
    var _weights = [];
    var _total = 0;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _e = _list[_i];
        if (!is_struct(_e)) continue;
        var _w = variable_struct_exists(_e, "weight") ? _e.weight : 1;
        if (_w <= 0) continue;
        var _sk = scr_skill_get(_e.skill);
        if (_sk.mp_cost > (variable_struct_exists(_enemy, "mp") ? _enemy.mp : 0)) continue;
        if (_sk.cond == "has_allies" && _allies_alive <= 0) continue;
        if (_sk.cond == "no_def_buff" && scr_battle_buff_total(_enemy, "def") > 0) continue;
        if (_sk.cond == "not_veiled" && scr_battle_status_has(_enemy, "veiled")) continue;
        if (_sk.cond == "ally_hurt" && !(variable_struct_exists(_enemy, "ally_hurt") && _enemy.ally_hurt)) continue;
        array_push(_ids, _e.skill);
        array_push(_weights, _w);
        _total += _w;
    }
    if (_total <= 0) return "attack";
    var _roll = random(_total);
    for (var _j = 0; _j < array_length(_ids); _j++) {
        _roll -= _weights[_j];
        if (_roll < 0) return _ids[_j];
    }
    return _ids[array_length(_ids) - 1];
}

/// Sort turn entries in place by `.key` (highest first). Insertion sort: tiny arrays, no
/// dependency on array_sort's comparator semantics.
function scr_battle_sort_turns(_arr) {
    for (var _i = 1; _i < array_length(_arr); _i++) {
        var _cur = _arr[_i];
        var _j = _i - 1;
        while (_j >= 0 && _arr[_j].key < _cur.key) {
            _arr[_j + 1] = _arr[_j];
            _j -= 1;
        }
        _arr[_j + 1] = _cur;
    }
    return _arr;
}

/// Feet positions on the left half of the 320×180 battle screen (enemies face right).
/// Regular: 1 = the old single spot; 2–3 follow Design's Crown mockup. With a boss (index 0),
/// the boss stands front-right at (100, 124) and adds fill the back-left (Calder mockup).
function scr_battle_formation(_count, _boss_index = -1) {
    var _out = [];
    if (_boss_index == 0) {
        array_push(_out, { x: 100, y: 124 });
        var _adds = [{ x: 30, y: 106 }, { x: 52, y: 127 }, { x: 14, y: 124 }];
        for (var _a = 1; _a < _count; _a++) array_push(_out, _adds[min(_a - 1, 2)]);
        return _out;
    }
    if (_count <= 1) return [{ x: 86, y: 118 }];
    if (_count == 2) return [{ x: 52, y: 112 }, { x: 98, y: 124 }];
    return [{ x: 36, y: 108 }, { x: 64, y: 120 }, { x: 100, y: 126 }];
}

/// Give duplicate enemy names a letter (Occ. Soldier A / B) so messages and targeting are clear.
function scr_battle_label_duplicates(_enemies) {
    for (var _i = 0; _i < array_length(_enemies); _i++) {
        var _e = _enemies[_i];
        var _same = 0;
        var _rank = 0;
        for (var _j = 0; _j < array_length(_enemies); _j++) {
            if (_enemies[_j].actor_id == _e.actor_id) {
                if (_j < _i) _rank += 1;
                _same += 1;
            }
        }
        if (_same > 1) {
            var _letter = chr(ord("A") + _rank);
            _e.name = _e.full_name + " " + _letter;
            _e.short_name = string_copy(_e.short_name, 1, 10) + " " + _letter;
        }
    }
}

/// "A Bandit appears!" / "Crown Patrolman and Crown Crossbowman appear!" / boss + adds line.
function scr_battle_intro_text(_enemies, _boss_index) {
    var _n = array_length(_enemies);
    if (_n == 0) return "";
    if (_n == 1) return "A " + _enemies[0].full_name + " appears!";
    if (_boss_index == 0) {
        var _adds = _n - 1;
        return _enemies[0].full_name + " appears with " + string(_adds) + ((_adds == 1) ? " soldier!" : " soldiers!");
    }
    var _txt = "";
    for (var _i = 0; _i < _n; _i++) {
        if (_i > 0) _txt += (_i == _n - 1) ? " and " : ", ";
        _txt += _enemies[_i].name;
    }
    return _txt + " appear!";
}

/// End-of-battle cleanup for every roster member: clear battle buffs / statuses and Guard.
/// After a victory, living active members regain BATTLE_VICTORY_MP_REGEN MP (PLACEHOLDER).
function scr_battle_clear_party_battle_state(_victory) {
    scr_game_state_init();
    var _lists = [global.game.roster, global.game.party, global.game.reserve];
    for (var _l = 0; _l < array_length(_lists); _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            var _a = _list[_i];
            if (!is_struct(_a)) continue;
            _a.buffs = [];
            _a.statuses = [];
            _a.is_guarding = false;
        }
    }
    if (_victory && is_array(global.game.party)) {
        for (var _p = 0; _p < array_length(global.game.party); _p++) {
            var _m = global.game.party[_p];
            if (!is_struct(_m) || _m.hp <= 0 || !variable_struct_exists(_m, "max_mp")) continue;
            _m.mp = min(_m.max_mp, _m.mp + BATTLE_VICTORY_MP_REGEN);
        }
    }
}
