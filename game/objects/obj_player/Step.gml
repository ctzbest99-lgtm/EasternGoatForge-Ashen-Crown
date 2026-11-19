/// obj_player : Step
/// Top-down movement with obj_solid / "Collision" tile layer collision, plus facing-based interaction.
/// Input is ignored while dialogue, battle, or a room transition is active (scr_input_locked).
/// Sprite and depth still update while locked so facing and y-sort stay correct.
if (!input_enabled || scr_input_locked()) {
    scr_player_update_sprite(false);
    depth = -y;
    exit;
}

var _prev_x = x;
var _prev_y = y;

// --- Movement (keyboard + left stick / D-pad; the vector is already normalized) ---
var _move = scr_input_move_vector();
var _ix = _move[0];
var _iy = _move[1];
if (_ix != 0 || _iy != 0) { facing_x = sign(_ix); facing_y = sign(_iy); }
var _next_x = x + _ix * move_speed;
var _next_y = y + _iy * move_speed;
if (!place_meeting(_next_x, y, collision_targets)) x = _next_x;
if (!place_meeting(x, _next_y, collision_targets)) y = _next_y;

// Safety net: keep the collision mask inside the room even if a border wall is missing.
if (bbox_left < 0) x -= bbox_left;
if (bbox_top < 0) y -= bbox_top;
if (bbox_right > room_width - 1) x -= bbox_right - (room_width - 1);
if (bbox_bottom > room_height - 1) y -= bbox_bottom - (room_height - 1);

// --- Interaction: probe a small box just past the edge of the collision mask in the facing direction ---
if (scr_input_confirm_pressed()) {
    var _cx = (bbox_left + bbox_right) * 0.5;
    var _cy = (bbox_top + bbox_bottom) * 0.5;
    var _probe_x = _cx + facing_x * ((bbox_right - bbox_left) * 0.5 + interact_reach);
    var _probe_y = _cy + facing_y * ((bbox_bottom - bbox_top) * 0.5 + interact_reach);
    var _target = collision_rectangle(_probe_x - 4, _probe_y - 4, _probe_x + 4, _probe_y + 4, obj_interactable, false, true);
    if (_target == noone) {
        var _o_snpc = asset_get_index("obj_story_npc");
        if (_o_snpc != -1) {
            _target = collision_rectangle(_probe_x - 4, _probe_y - 4, _probe_x + 4, _probe_y + 4, _o_snpc, false, true);
        }
    }
    if (_target != noone) _target.interact();
}

var _moved = point_distance(_prev_x, _prev_y, x, y);
scr_player_update_sprite(_moved > 0);
depth = -y;

// --- Random encounters: only actual movement, and only if interact did not lock input ---
if (!scr_input_locked()) {
    if (_moved > 0) scr_random_encounter_tick(_moved);
}
