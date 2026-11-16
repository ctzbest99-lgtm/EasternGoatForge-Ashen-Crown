/// scr_encounter — contact-encounter rules for obj_enemy, kept pure so they can be tested.
///
/// `armed` is per-enemy state. It starts true, is spent the moment a battle starts, and comes back only
/// once the player is clear of the enemy and no battle is running. That single rule prevents three
/// failures at once: two battles from one contact, a defeat dropping the player straight back into the
/// same fight while still standing on it, and re-triggering on every step of an overlap.

/// @desc Should this enemy start a battle right now?
function scr_encounter_should_start(_touching, _armed, _battle_active) {
    if (_battle_active) return false;
    if (!_touching) return false;
    return _armed;
}

/// @desc May this enemy re-arm its trigger this step?
function scr_encounter_rearm(_touching, _battle_active) {
    return (!_battle_active && !_touching);
}
