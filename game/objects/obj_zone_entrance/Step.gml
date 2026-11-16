/// obj_zone_entrance : Step
/// Walk onto the instance (after first stepping off) to change rooms.
var _on = instance_exists(obj_player) && place_meeting(x, y, obj_player);
if (!_on) { armed = true; exit; }
if (!armed || scr_input_locked()) exit;
armed = false;
if (is_struct(map_marker) && !scr_map_requirement_met(map_marker)) {
    var _lines = ["[It's locked.]"];
    if (variable_struct_exists(map_marker, "lines") && is_array(map_marker.lines) && array_length(map_marker.lines) > 0) {
        _lines = map_marker.lines;
    }
    scr_dialogue_open(_lines, "");
    exit;
}
// Exits with a scene (Chapter 2 west road: WF_HANDOFF, chapter end, save prompt) handle the move themselves.
if (is_struct(map_marker) && variable_struct_exists(map_marker, "script_id") && scr_ch2_exit_script(id)) exit;
if (is_struct(map_marker) && variable_struct_exists(map_marker, "script_id") && scr_ch3_exit_script(id)) exit;
if (is_struct(map_marker) && variable_struct_exists(map_marker, "script_id") && scr_ch4_exit_script(id)) exit;
if (is_struct(map_marker) && variable_struct_exists(map_marker, "script_id") && scr_ch5_exit_script(id)) exit;
if (is_struct(map_marker) && variable_struct_exists(map_marker, "script_id") && scr_ch7_exit_script(id)) exit;
if (sets_flag != "") scr_flag_set(sets_flag);
if (target_room == -1) {
    scr_dialogue_open(["[" + target_room_name + " is not built yet.]"], "");
    exit;
}
global.map_spawn_name = target_spawn;
room_goto(target_room);
