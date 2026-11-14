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
function scr_actor_apply_level_up(_actor) {
    var _hp = LEVEL_UP_HP_GROWTH;
    var _atk = LEVEL_UP_ATTACK_GROWTH;
    var _def = LEVEL_UP_DEFENSE_GROWTH;
    _actor.level += 1;
    _actor.max_hp += _hp;
    if (_actor.hp > 0) _actor.hp = min(_actor.max_hp, _actor.hp + _hp);
    if (!variable_struct_exists(_actor, "base_attack")) _actor.base_attack = _actor.attack;
    if (!variable_struct_exists(_actor, "base_defense")) _actor.base_defense = _actor.defense;
    _actor.base_attack += _atk;
    _actor.base_defense += _def;
    _actor.attack += _atk;
    _actor.defense += _def;
    // Battle upgrade: PLACEHOLDER flat growth for MP / SPD / MDEF. KO'd members gain max MP only.
    var _mp = LEVEL_UP_MP_GROWTH;
    var _spd = LEVEL_UP_SPD_GROWTH;
    var _mdef = LEVEL_UP_MDEF_GROWTH;
    if (!variable_struct_exists(_actor, "max_mp")) { _actor.max_mp = 0; _actor.mp = 0; }
    if (!variable_struct_exists(_actor, "base_spd")) _actor.base_spd = variable_struct_exists(_actor, "spd") ? _actor.spd : 8;
    if (!variable_struct_exists(_actor, "base_mdef")) _actor.base_mdef = variable_struct_exists(_actor, "mdef") ? _actor.mdef : 0;
    _actor.max_mp += _mp;
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
