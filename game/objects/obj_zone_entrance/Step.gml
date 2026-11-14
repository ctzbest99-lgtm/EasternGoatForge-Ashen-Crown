/// obj_zone_entrance : Step
/// Walk onto the instance (after first stepping off) to change rooms.
var _on = instance_exists(obj_player) && place_meeting(x, y, obj_player);
if (!_on) { armed = true; exit; }
if (!armed || scr_input_locked()) exit;
armed = false;
if (target_room == -1) {
    scr_dialogue_open(["[" + target_room_name + " is not built yet.]"], "");
    exit;
}
global.map_spawn_name = target_spawn;
room_goto(target_room);
