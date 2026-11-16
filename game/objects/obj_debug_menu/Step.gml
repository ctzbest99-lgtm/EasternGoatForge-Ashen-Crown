/// obj_debug_menu : Step
/// Place this object once in rm_overworld (or any test room). It draws its own panel in Draw GUI.
if (keyboard_check_pressed(vk_f10)) {
    visible_debug = !visible_debug;
    keyboard_string = "";
}
/// Saving works with the overlay closed; a real game saves at save points instead of on a key.
var _player_obj = asset_get_index("obj_player");
var _player = (_player_obj >= 0 && instance_number(_player_obj) > 0) ? instance_find(_player_obj, 0) : noone;
if (keyboard_check_pressed(vk_f5)) {
    message = "save: " + scr_save_game(_player, room_get_name(room));
    exit;
}
if (keyboard_check_pressed(vk_f9)) {
    message = "load: " + scr_save_load(_player);
    exit;
}
if (!visible_debug) exit;
/// Battle prototype trigger: B starts a Bandit fight through the overlay controller.
if (keyboard_check_pressed(ord("B"))) {
    message = (scr_battle_start("bandit") == noone) ? "battle not started: controller missing or already active" : "battle started: bandit";
    exit;
}
/// Fills the party with placeholder members so four-person battles can be tried from one save.
if (keyboard_check_pressed(ord("P"))) {
    var _added = scr_party_fill_placeholders(scr_party_ensure_global(), 4);
    message = (_added > 0) ? "party +" + string(_added) : "party already full";
    exit;
}
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
