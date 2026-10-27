/// obj_player : Step
/// Minimal top-down prototype; requires obj_solid. Replace collision checks if using tilemap collision.
if (!input_enabled) exit;
var _ix = keyboard_check(vk_right) - keyboard_check(vk_left);
var _iy = keyboard_check(vk_down) - keyboard_check(vk_up);
if (_ix != 0 || _iy != 0) { facing_x = sign(_ix); facing_y = sign(_iy); }
if (_ix != 0 && _iy != 0) { _ix *= 0.70710678; _iy *= 0.70710678; }
var _next_x = x + _ix * move_speed;
var _next_y = y + _iy * move_speed;
if (!place_meeting(_next_x, y, obj_solid)) x = _next_x;
if (!place_meeting(x, _next_y, obj_solid)) y = _next_y;
