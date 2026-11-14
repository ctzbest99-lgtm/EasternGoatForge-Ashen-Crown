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
    _actor.attack += _atk;
    _actor.defense += _def;
    return { name: _actor.name, level: _actor.level, hp: _hp, attack: _atk, defense: _def };
}

/// Grant `_amount` XP to every current party member (including KO'd; pending assumption)
/// and apply as many level-ups as the curve allows. Returns an array of level-up structs
/// in party order. Caps XP at the max-level floor.
function scr_party_grant_xp(_party, _amount) {
    var _ups = [];
    if (_amount <= 0) return _ups;
    for (var _i = 0; _i < array_length(_party); _i++) {
        var _actor = _party[_i];
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
