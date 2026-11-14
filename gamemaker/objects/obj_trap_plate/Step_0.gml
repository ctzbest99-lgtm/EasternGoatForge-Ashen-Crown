/// obj_trap_plate : Step
if (sprung) exit;
var _touching = instance_exists(obj_player) && place_meeting(x, y, obj_player);
if (!_touching) {
    armed = true;
    exit;
}
if (!armed || scr_input_locked()) exit;
armed = false;
sprung = true;

// Knock the player back along the step they just took (8 px), or south if unknown.
if (instance_exists(obj_player)) {
    var _px = obj_player.x;
    var _py = obj_player.y;
    var _dx = 0;
    var _dy = 8;
    if (variable_instance_exists(obj_player, "facing_x") && (obj_player.facing_x != 0 || obj_player.facing_y != 0)) {
        _dx = -obj_player.facing_x * 8;
        _dy = -obj_player.facing_y * 8;
    }
    var _nx = _px + _dx;
    var _ny = _py + _dy;
    with (obj_player) {
        if (!place_meeting(_nx, _ny, collision_targets)) {
            x = _nx;
            y = _ny;
        }
    }
}

scr_trap_apply_damage(damage_pct);

if (script_id != "" && scr_dialogue_play_script(script_id, id)) {
    // WT_TRAP_01 queued
} else if (is_array(dialogue_lines) && array_length(dialogue_lines) > 0) {
    scr_dialogue_open(dialogue_lines, "");
}
