/// scr_interaction — deciding what the player is facing. Pure geometry, so the rule can be tested
/// without instances: a target must be within range and inside the cone in front of the facing vector.

/// @desc True when (_nx, _ny) is within _range of the player and in front of it.
/// A target exactly on the player counts as in front, so standing on a sign still works.
function scr_interaction_in_front(_px, _py, _fx, _fy, _nx, _ny, _range) {
    var _dx = _nx - _px;
    var _dy = _ny - _py;
    var _dist = sqrt(_dx * _dx + _dy * _dy);
    if (_dist > _range) return false;
    if (_dist == 0) return true;
    var _dot = (_dx * _fx + _dy * _fy) / _dist;
    /// About 60 degrees either side of straight ahead: generous for a four-direction game, but a
    /// target behind or beside the player is never selected.
    return (_dot > 0.5);
}

/// @desc Nearest candidate in front of the player, or undefined when there is none.
/// _candidates are structs with { instance, x, y }.
function scr_interaction_pick(_candidates, _px, _py, _fx, _fy, _range) {
    var _best = undefined;
    var _best_dist = _range + 1;
    var _count = array_length(_candidates);
    for (var _i = 0; _i < _count; _i++) {
        var _candidate = _candidates[_i];
        if (!scr_interaction_in_front(_px, _py, _fx, _fy, _candidate.x, _candidate.y, _range)) continue;
        var _dx = _candidate.x - _px;
        var _dy = _candidate.y - _py;
        var _dist = sqrt(_dx * _dx + _dy * _dy);
        if (_dist < _best_dist) {
            _best_dist = _dist;
            _best = _candidate;
        }
    }
    return _best;
}
