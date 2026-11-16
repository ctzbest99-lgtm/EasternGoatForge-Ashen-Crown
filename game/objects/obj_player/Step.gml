/// obj_player : Step
/// Minimal top-down prototype; requires obj_solid. Replace collision checks if using tilemap collision.
if (!input_enabled) {
    /// Input is locked (dialogue, menu, battle): settle on the idle pose rather than freeze mid-stride,
    /// but let an action in progress finish so the sprite does not change sheet underneath it.
    if (scr_action_busy(id)) scr_action_update(id);
    else scr_update_walk_animation(id, false);
    exit;
}
/// Action lock: an attack or hurt animation owns the sprite and blocks movement until it ends.
if (scr_action_busy(id)) {
    scr_action_update(id);
    exit;
}
/// Testing triggers. Battle code calls the same two functions instead of pressing keys.
if (keyboard_check_pressed(vk_space)) scr_action_start(id, PLAYER_ACTION.ATTACK);
if (keyboard_check_pressed(ord("H"))) scr_action_start(id, PLAYER_ACTION.HURT);
if (scr_action_busy(id)) exit;

var _ix = keyboard_check(vk_right) - keyboard_check(vk_left);
var _iy = keyboard_check(vk_down) - keyboard_check(vk_up);
if (_ix != 0 && _iy != 0) { _ix *= 0.70710678; _iy *= 0.70710678; }
/// Facing is normalised with movement so interaction targets stay one step away on diagonals.
if (_ix != 0 || _iy != 0) { facing_x = _ix; facing_y = _iy; }
var _next_x = x + _ix * move_speed;
var _next_y = y + _iy * move_speed;
if (place_meeting(x, y, obj_solid)) {
    /// Recovery: already overlapping geometry (bad spawn, teleport, loaded save).
    /// Both axis checks below would reject every move, so pass through until free.
    x = _next_x;
    y = _next_y;
} else {
    if (!place_meeting(_next_x, y, obj_solid)) x = _next_x;
    if (!place_meeting(x, _next_y, obj_solid)) y = _next_y;
}
/// Animation follows the facing vector and whether the player is actually trying to move.
scr_update_walk_animation(id, _ix != 0 || _iy != 0);
