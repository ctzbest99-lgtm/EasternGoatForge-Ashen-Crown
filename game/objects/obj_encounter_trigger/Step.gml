/// obj_encounter_trigger : Step
depth = -y;
var _touching = instance_exists(obj_player) && place_meeting(x, y, obj_player);
if (!_touching) {
    armed = true;
    exit;
}
if (!armed || scr_input_locked()) exit; // no battle during dialogue, another battle, or a transition

armed = false;
scr_encounter_start(enemy_id, encounter_id);
