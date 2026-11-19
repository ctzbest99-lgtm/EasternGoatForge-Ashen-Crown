/// scr_progression — XP curve, levels, and stat growth (roadmap step 4).
/// Numbers are placeholders, pending owner approval.

/// Total shared-scale XP required to *be* this level. Level 1 is 0.
function scr_xp_for_level(_level) {
    if (_level <= 1) return 0;
    var _n = clamp(_level, 1, PARTY_MAX_LEVEL) - 1;
    return XP_CURVE_QUAD * (_n * _n) + XP_CURVE_LIN * _n;
}

/// Highest level whose floor is <= _xp, capped at PARTY_MAX_LEVEL.
function scr_level_from_xp(_xp) {
    var _level = 1;
    while (_level < PARTY_MAX_LEVEL && _xp >= scr_xp_for_level(_level + 1)) {
        _level += 1;
    }
    return _level;
}

/// XP earned toward the next level (0 at a level boundary or at the cap).
function scr_xp_progress_to_next(_xp, _level) {
    var _floor = scr_xp_for_level(_level);
    if (_level >= PARTY_MAX_LEVEL) return 0;
    return max(0, _xp - _floor);
}

/// Apply one level of placeholder stat growth. KO'd members gain max HP only (stay at 0 HP).
/// Returns a struct describing the change, for the battle level-up message.
/// Growth for one level-up INTO `_new_level`. Levels below LEVEL_UP_TIER_LEVEL keep the
/// Chapter 1 numbers; from the tier level up the *_HIGH placeholders apply (balance pass).
function scr_level_growth(_new_level) {
    if (_new_level >= LEVEL_UP_TIER_LEVEL) {
        return { hp: LEVEL_UP_HP_GROWTH_HIGH, atk: LEVEL_UP_ATTACK_GROWTH_HIGH, def: LEVEL_UP_DEFENSE_GROWTH_HIGH,
                 mp: LEVEL_UP_MP_GROWTH_HIGH, spd: LEVEL_UP_SPD_GROWTH_HIGH, mdef: LEVEL_UP_MDEF_GROWTH_HIGH };
    }
    return { hp: LEVEL_UP_HP_GROWTH, atk: LEVEL_UP_ATTACK_GROWTH, def: LEVEL_UP_DEFENSE_GROWTH,
             mp: LEVEL_UP_MP_GROWTH, spd: LEVEL_UP_SPD_GROWTH, mdef: LEVEL_UP_MDEF_GROWTH };
}

/// Total growth from level 1 to `_level` (sum of scr_level_growth for 2.._level).
function scr_level_growth_total(_level) {
    var _t = { hp: 0, atk: 0, def: 0, mp: 0, spd: 0, mdef: 0 };
    for (var _l = 2; _l <= _level; _l++) {
        var _g = scr_level_growth(_l);
        _t.hp += _g.hp; _t.atk += _g.atk; _t.def += _g.def;
        _t.mp += _g.mp; _t.spd += _g.spd; _t.mdef += _g.mdef;
    }
    return _t;
}

/// Raise a (usually newly joined) member to `_level` with normal growth, XP set to that
/// level's floor, then full HP / MP. Used when Taren joins at Kael's level (Chapter 2).
function scr_actor_raise_to_level(_actor, _level) {
    if (!is_struct(_actor)) return;
    _level = clamp(_level, 1, PARTY_MAX_LEVEL);
    while (_actor.level < _level) scr_actor_apply_level_up(_actor);
    _actor.xp = max(_actor.xp, scr_xp_for_level(_actor.level));
    _actor.hp = _actor.max_hp;
    if (variable_struct_exists(_actor, "max_mp")) _actor.mp = _actor.max_mp;
}

function scr_actor_apply_level_up(_actor) {
    var _gr = scr_level_growth(_actor.level + 1);
    var _hp = _gr.hp;
    var _atk = _gr.atk;
    var _def = _gr.def;
    _actor.level += 1;
    _actor.max_hp += _hp;
    // Keep the un-equipped maximum in step, so equipment HP bonuses never compound.
    if (variable_struct_exists(_actor, "base_max_hp")) _actor.base_max_hp += _hp;
    else _actor.base_max_hp = _actor.max_hp;
    if (_actor.hp > 0) _actor.hp = min(_actor.max_hp, _actor.hp + _hp);
    if (!variable_struct_exists(_actor, "base_attack")) _actor.base_attack = _actor.attack;
    if (!variable_struct_exists(_actor, "base_defense")) _actor.base_defense = _actor.defense;
    _actor.base_attack += _atk;
    _actor.base_defense += _def;
    _actor.attack += _atk;
    _actor.defense += _def;
    // PLACEHOLDER growth for MP / SPD / MDEF (tiered, see scr_level_growth). KO'd members gain max MP only.
    var _mp = _gr.mp;
    var _spd = _gr.spd;
    var _mdef = _gr.mdef;
    if (!variable_struct_exists(_actor, "max_mp")) { _actor.max_mp = 0; _actor.mp = 0; }
    if (!variable_struct_exists(_actor, "base_spd")) _actor.base_spd = variable_struct_exists(_actor, "spd") ? _actor.spd : 8;
    if (!variable_struct_exists(_actor, "base_mdef")) _actor.base_mdef = variable_struct_exists(_actor, "mdef") ? _actor.mdef : 0;
    _actor.max_mp += _mp;
    _actor.base_max_mp = (variable_struct_exists(_actor, "base_max_mp") ? _actor.base_max_mp : 0) + _mp;
    if (_actor.hp > 0) _actor.mp = min(_actor.max_mp, _actor.mp + _mp);
    _actor.base_spd += _spd;
    _actor.spd = _actor.base_spd;
    _actor.base_mdef += _mdef;
    _actor.mdef = _actor.base_mdef;
    scr_actor_refresh_equipment(_actor);
    return { name: _actor.name, level: _actor.level, hp: _hp, attack: _atk, defense: _def, mp: _mp, spd: _spd, mdef: _mdef };
}

/// Grant `_amount` XP to each actor in `_list` (including KO'd). Returns level-up structs.
function scr_party_grant_xp_to(_list, _amount) {
    var _ups = [];
    if (_amount <= 0 || !is_array(_list)) return _ups;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _actor = _list[_i];
        if (!is_struct(_actor)) continue;
        _actor.xp += _amount;
        while (_actor.level < PARTY_MAX_LEVEL && _actor.xp >= scr_xp_for_level(_actor.level + 1)) {
            array_push(_ups, scr_actor_apply_level_up(_actor));
        }
        if (_actor.level >= PARTY_MAX_LEVEL) {
            _actor.xp = min(_actor.xp, scr_xp_for_level(PARTY_MAX_LEVEL));
        }
    }
    return _ups;
}

/// Legacy helper: grant `_amount` XP now. Battle victory uses
/// scr_party_credit_enemy_xp / scr_party_apply_pending_xp instead (per-enemy
/// credit to living participants, applied only if the party wins).
function scr_party_grant_xp(_party, _amount) {
    if (!XP_REQUIRES_PARTICIPATION) return scr_party_grant_xp_to(_party, _amount);
    return scr_party_grant_xp_to(scr_party_participants(), _amount);
}
