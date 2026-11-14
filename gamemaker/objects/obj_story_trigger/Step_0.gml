/// obj_story_trigger : Step
if (fired) exit;
if (story_flag != "" && scr_flag_get(story_flag)) {
    instance_destroy();
    exit;
}
var _touching = instance_exists(obj_player) && place_meeting(x, y, obj_player);
if (!_touching) {
    armed = true;
    exit;
}
if (!armed || scr_input_locked()) exit;
armed = false;
fired = true;
if (script_id != "" && scr_dialogue_play_script(script_id, id)) {
    // script sets the flag and may destroy this instance
} else if (is_array(script_chain) && array_length(script_chain) > 0) {
    var _self = id;
    var _flag = story_flag;
    scr_dialogue_play(script_chain, method({ src: _self, flag: _flag }, function() {
        if (flag != "") scr_flag_set(flag);
        if (src != noone && instance_exists(src)) instance_destroy(src);
    }));
} else if (story_flag != "") {
    // Flag-only trigger (Chapter 2 wf_enter sets flag_wrenfield_entered with no line).
    scr_flag_set(story_flag);
}
if (story_flag != "" && scr_flag_get(story_flag)) {
    instance_destroy();
}
