/// scr_player_animation — walk and action playback for obj_player.
/// Sheet layouts (see assets/characters/README.md):
///   walk   4 dirs x 4 frames, index = row * 4 + frame
///   attack 4 dirs x 3 frames, index = row * 3 + frame (windup, strike, recover)
///   hurt   4 dirs x 1 frame,  index = row
/// Rows are down, left, right, up, derived from the normalised facing vector. Playback is driven
/// here, not by image_speed. Requires GameMaker 2.3+.

/// Player action states. FREE is normal movement; the others own the sprite and lock input.
enum PLAYER_ACTION {
    FREE,
    ATTACK,
    HURT
}

/// @desc Direction row for a facing vector: 0 down, 1 left, 2 right, 3 up.
/// Diagonals resolve vertically because facing is normalised to equal x/y magnitude.
function scr_walk_dir_row(_facing_x, _facing_y) {
    if (abs(_facing_x) > abs(_facing_y)) return (_facing_x > 0) ? 2 : 1;
    return (_facing_y < 0) ? 3 : 0;
}

/// @desc Walk frame 0–3 from an accumulated clock in microseconds at _fps.
function scr_walk_frame_from_clock(_clock, _fps) {
    if (_fps <= 0) return 0;
    var _frame_us = 1000000 / _fps;
    return floor(_clock / _frame_us) mod 4;
}

/// @desc Advance _inst's walk animation for this step. _moving is whether it moved this step.
/// Pass false when input is locked so the sprite settles on its idle frame instead of freezing mid-stride.
function scr_update_walk_animation(_inst, _moving) {
    /// asset_get_index returns -1 until the sheet is imported; do nothing until then.
    if (_inst.walk_sprite < 0) return;
    var _fps = max(1, _inst.walk_fps);
    if (_moving) {
        _inst.walk_clock += delta_time;
        /// Keep the clock bounded so long sessions cannot drift on float precision.
        var _cycle_us = 4000000 / _fps;
        if (_inst.walk_clock >= _cycle_us) _inst.walk_clock = _inst.walk_clock mod _cycle_us;
    } else {
        _inst.walk_clock = 0;
    }
    _inst.walk_row = scr_walk_dir_row(_inst.facing_x, _inst.facing_y);
    _inst.walk_frame = scr_walk_frame_from_clock(_inst.walk_clock, _fps);
    _inst.image_index = _inst.walk_row * 4 + _inst.walk_frame;
}

// -------------------------------------------------------------------- actions

/// @desc True while an action (attack or hurt) owns the player.
function scr_action_busy(_inst) {
    return _inst.action_state != PLAYER_ACTION.FREE;
}

/// @desc Total length of the current action in microseconds.
function scr_action_duration(_inst) {
    switch (_inst.action_state) {
        case PLAYER_ACTION.ATTACK:
            /// Windup, a strike held for two frame-times, then recover: four frames at attack_fps.
            /// A non-positive attack_fps is a misconfiguration, not a reason to hold movement for seconds.
            if (_inst.attack_fps <= 0) return 0;
            return 4000000 / _inst.attack_fps;
        case PLAYER_ACTION.HURT:
            return _inst.hurt_hold_us;
    }
    return 0;
}

/// @desc Attack frame for a clock in microseconds: 0 windup, 1 strike (held), 2 recover.
function scr_attack_frame_from_clock(_clock, _fps) {
    var _frame_us = 1000000 / max(1, _fps);
    if (_clock < _frame_us) return 0;
    if (_clock < 3 * _frame_us) return 1;
    return 2;
}

/// @desc image_index for the current action and facing direction.
function scr_action_image_index(_inst) {
    var _row = scr_walk_dir_row(_inst.facing_x, _inst.facing_y);
    if (_inst.action_state == PLAYER_ACTION.ATTACK) {
        return _row * 3 + scr_attack_frame_from_clock(_inst.action_clock, _inst.attack_fps);
    }
    return _row;
}

/// @desc Start an action. Returns false and changes nothing if it cannot start.
/// A missing sheet means "not imported yet", so the action refuses rather than locking movement forever.
function scr_action_start(_inst, _action) {
    switch (_action) {
        case PLAYER_ACTION.ATTACK:
            if (_inst.attack_sprite < 0 || scr_action_busy(_inst)) return false;
            _inst.sprite_index = _inst.attack_sprite;
            break;
        case PLAYER_ACTION.HURT:
            /// Hurt interrupts a swing: taking a hit should cancel the attack.
            if (_inst.hurt_sprite < 0) return false;
            _inst.sprite_index = _inst.hurt_sprite;
            break;
        default:
            return false;
    }
    _inst.action_state = _action;
    _inst.action_clock = 0;
    _inst.image_index = scr_action_image_index(_inst);
    return true;
}

/// @desc End the current action and hand the player back to walking on its idle frame.
function scr_action_end(_inst) {
    _inst.action_state = PLAYER_ACTION.FREE;
    _inst.action_clock = 0;
    _inst.sprite_index = _inst.walk_sprite;
    _inst.walk_clock = 0;
    _inst.walk_row = scr_walk_dir_row(_inst.facing_x, _inst.facing_y);
    _inst.walk_frame = 0;
    _inst.image_index = _inst.walk_row * 4;
}

/// @desc Advance the current action by one step. Returns true while it is still running.
function scr_action_update(_inst) {
    if (!scr_action_busy(_inst)) return false;
    _inst.action_clock += delta_time;
    if (_inst.action_clock >= scr_action_duration(_inst)) {
        scr_action_end(_inst);
        return false;
    }
    _inst.image_index = scr_action_image_index(_inst);
    return true;
}
