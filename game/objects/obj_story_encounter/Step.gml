/// obj_story_encounter : Step
depth = -y;
var _touching = instance_exists(obj_player) && place_meeting(x, y, obj_player);
if (!_touching) {
    armed = true;
    exit;
}
if (!armed || scr_input_locked()) exit;

armed = false;
scr_ashbound_hunter_start(encounter_id);
