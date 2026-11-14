/// scr_battle_math — prototype helper; adapt to the actual actor data structure.
function scr_calculate_damage(_attack, _defense) {
    return max(1, _attack - floor(_defense * 0.5));
}

function scr_apply_damage(_current_hp, _max_hp, _damage) {
    return clamp(_current_hp - max(0, _damage), 0, _max_hp);
}

/// Guard reduces incoming damage by GUARD_DAMAGE_MULTIPLIER, never below 1.
function scr_apply_guard(_damage, _is_guarding) {
    if (!_is_guarding) return _damage;
    return max(1, floor(_damage * GUARD_DAMAGE_MULTIPLIER));
}
