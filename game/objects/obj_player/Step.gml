/// obj_player : Step
/// Top-down movement with obj_solid / "Collision" tile layer collision, plus facing-based interaction.
/// Input is ignored while dialogue, battle, or a room transition is active (scr_input_locked).
if (!input_enabled || scr_input_locked()) exit;

// --- Movement (same behaviour as the original prototype; collision targets extended) ---
var _ix = keyboard_check(vk_right) - keyboard_check(vk_left);
var _iy = keyboard_check(vk_down) - keyboard_check(vk_up);
if (_ix != 0 || _iy != 0) { facing_x = sign(_ix); facing_y = sign(_iy); }
if (_ix != 0 && _iy != 0) { _ix *= 0.70710678; _iy *= 0.70710678; }
var _next_x = x + _ix * move_speed;
var _next_y = y + _iy * move_speed;
if (!place_meeting(_next_x, y, collision_targets)) x = _next_x;
if (!place_meeting(x, _next_y, collision_targets)) y = _next_y;

// Safety net: keep the collision mask inside the room even if a border wall is missing.
if (bbox_left < 0) x -= bbox_left;
if (bbox_top < 0) y -= bbox_top;
if (bbox_right > room_width - 1) x -= bbox_right - (room_width - 1);
if (bbox_bottom > room_height - 1) y -= bbox_bottom - (room_height - 1);

// --- Interaction: probe a small box just past the mask edge in the facing direction ---
if (scr_input_confirm_pressed()) {
    var _cx = (bbox_left + bbox_right) * 0.5;
    var _cy = (bbox_top + bbox_bottom) * 0.5;
    var _probe_x = _cx + facing_x * ((bbox_right - bbox_left) * 0.5 + interact_reach);
    var _probe_y = _cy + facing_y * ((bbox_bottom - bbox_top) * 0.5 + interact_reach);
    var _target = collision_rectangle(_probe_x - 4, _probe_y - 4, _probe_x + 4, _probe_y + 4, obj_interactable, false, true);
    if (_target != noone) _target.interact();
}
