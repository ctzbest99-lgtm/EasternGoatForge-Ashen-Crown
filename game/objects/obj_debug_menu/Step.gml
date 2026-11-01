/// obj_debug_menu : Step
/// Place this object once in rm_overworld (or any test room). It draws its own panel in Draw GUI.
if (keyboard_check_pressed(vk_f10)) {
    visible_debug = !visible_debug;
    keyboard_string = "";
}
if (!visible_debug) exit;
if (keyboard_check_pressed(vk_tab)) {
    debug_mode = 1 - debug_mode;
    keyboard_string = "";
    exit;
}
var _count = array_length(enemy_ids);
if (debug_mode == 0) {
    if (_count > 0) {
        if (keyboard_check_pressed(vk_up)) selected = (selected - 1 + _count) mod _count;
        if (keyboard_check_pressed(vk_down)) selected = (selected + 1) mod _count;
        if (keyboard_check_pressed(vk_enter)) message = scr_debug_spawn_enemy_near_player(enemy_ids[selected]);
    }
} else {
    if (keyboard_check_pressed(vk_enter)) {
        var _pos = scr_debug_parse_coord(keyboard_string);
        if (is_undefined(_pos)) {
            message = "expected x,y — for example 128,96";
        } else {
            message = scr_debug_teleport_player(_pos.x, _pos.y);
            keyboard_string = "";
        }
    }
}
